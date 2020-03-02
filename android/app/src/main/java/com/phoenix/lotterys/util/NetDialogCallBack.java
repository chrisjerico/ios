package com.phoenix.lotterys.util;

import android.content.Context;
import android.content.SharedPreferences;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.lzy.okgo.request.base.Request;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.view.LoadingDialog;

import java.io.IOException;

/**
 * Created by Luke
 * on 2019/6/16
 */
public abstract class NetDialogCallBack extends StringCallback {

    private String tag_log = "DialogCallBack";

    LoadingDialog dialog;
    private Context context;
    private boolean isShowDialog;//是否显示dialog
    private boolean isCancel;//是否能返回键取消，默认能
    private Object tag;//用于取消网络连接
    private Class responseClass;//返回的数据类型
    private int bet;//   传110不弹错误信息

    public NetDialogCallBack() {

    }

    /**
     * @param context
     * @param isShowDialog 是否显示dialog
     * @param tag          用于取消网络连接
     * @param isCancel     是否能返回键取消，默认能
     */
    public NetDialogCallBack(Context context, boolean isShowDialog, Object tag, boolean isCancel, Class responseClass) {
        this.context = context;
        this.isShowDialog = isShowDialog;
        this.tag = tag;
        this.isCancel = isCancel;
        this.responseClass = responseClass;
    }

    public NetDialogCallBack(Context context, boolean isShowDialog, Object tag, boolean isCancel, Class responseClass, int bet) {   //下注
        this.context = context;
        this.isShowDialog = isShowDialog;
        this.tag = tag;
        this.bet = bet;
        this.isCancel = isCancel;
        this.responseClass = responseClass;
    }

    public NetDialogCallBack(Context context, boolean isShowDialog, Object tag) {
        this.context = context;
        this.isShowDialog = isShowDialog;
        this.tag = tag;
        isCancel = true;
    }

    public NetDialogCallBack(Context context, boolean isShowDialog) {
        this.context = context;
        this.isShowDialog = isShowDialog;
        isCancel = true;
    }

    @Override
    public void onStart(Request<String, ? extends Request> request) {
        super.onStart(request);
        if (isShowDialog) {
            dialog = LoadingDialog.showprogress(context, isCancel);
        }
    }

    @Override
    public void onSuccess(Response<String> response) {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
        if (response != null && response.code() == 200 && response.body() != null) {
            BaseBean bb = null;
            try {
                bb = new Gson().fromJson(response.body(), BaseBean.class);
            } catch (JsonSyntaxException e) {
                e.printStackTrace();
                ToastUtils.ToastUtils("数据结构错误", context);
            }
            if (bb != null && bb.getCode() == 0) {
                try {
                    Object o = new Gson().fromJson(response.body(), responseClass);
                    if (o == null) {
                        ToastUtils.ToastUtils("获取数据失败，请稍后再试", context);
                        return;
                    }
                    try {
                        onUi(o);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } catch (JsonSyntaxException e) {
                    e.printStackTrace();
                    ToastUtils.ToastUtils("数据结构错误", context);
                }
            } else if (bb != null && bb.getCode() != 0 && bb.getMsg() != null && !bb.getMsg().equals("")) {
                if (bet != 110)  //110不弹窗
                    ToastUtils.ToastUtils(bb.getMsg(), context);
                try {
                    onErr(bb);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } else {
                ToastUtils.ToastUtils("获取数据失败，请稍后再试", context);
            }
        } else if (response != null && response.code() == 401 && response.body() != null) {
            errCode(response.body());
//            ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
//            if (configBean != null && configBean.getData() != null && configBean.getData().getMobileTemplateCategory().equals("5")) {
//                context.startActivity(new Intent(context, BlackLoginActivity.class));
//            } else {
//                context.startActivity(new Intent(context, LoginActivity.class));
//            }
            SharedPreferences sp;
            sp = context.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
            SharedPreferences.Editor edit = sp.edit();
            edit.putString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
            edit.putString(SPConstants.SP_API_TOKEN, SPConstants.SP_NULL);
            edit.commit();

            Uiutils.login(context);
        } else if (response != null && (response.code() == 403 || response.code() == 404) && response.body() != null) {
            errCode(response.body());
        } else {
//            ToastUtils.ToastUtils("网络异常，请稍后再试1"+responseClass, context);
        }
    }

    private void errCode(String body) {
        try {
            BaseBean bb = new Gson().fromJson(body, BaseBean.class);
            if (bb != null && bb.getMsg() != null && !bb.getMsg().equals("")) {
                if(bet!=110)
                ToastUtils.ToastUtils(bb.getMsg(), context);
            } else {
                ToastUtils.ToastUtils("网络异常，请稍后 再试", context);
            }
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onError(Response<String> response) {
        if (dialog != null) {
            dialog.dismiss();
        }
        if (response != null && response.getRawResponse() != null && response.getRawResponse().code() == 401 && response.getRawResponse().body() != null) {
            try {
                errCode(response.getRawResponse().body().string());
            } catch (IOException e) {
                e.printStackTrace();
            }
//            context.startActivity(new Intent(context, LoginActivity.class));
            Uiutils.login(context);
        } else if (response != null && response.getRawResponse() != null && (response.getRawResponse().code() == 403 || response.getRawResponse().code() == 404 || response.getRawResponse().code() == 500) && response.getRawResponse().body() != null) {
            try {
                errCode(response.getRawResponse().body().string());
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            ToastUtils.ToastUtils("网络异常，请稍后再 试", context);
            if (response != null && response.getException() != null && response.getException().toString().contains("UnknownHostException"))
                Constants.alterHost();
        }
        onFailed(response);
    }

    public abstract void onUi(Object o) throws IOException;

    public abstract void onErr(BaseBean bb) throws IOException;

    public abstract void onFailed(Response<String> response);

}