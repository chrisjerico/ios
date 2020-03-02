package com.phoenix.lotterys.util;

import android.content.Context;

import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.lzy.okgo.request.base.Request;
import com.phoenix.lotterys.view.LoadingDialog;

/**
 * Created by Luke
 * on 2019/6/16
 */
public class DialogCallBack extends StringCallback {

    private String tag_log = "DialogCallBack";

    LoadingDialog dialog;
    private Context context;
    private boolean isShowDialog;//是否显示dialog
    private boolean isCancel;//是否能返回键取消，默认能
    private Object tag;//用于取消网络连接

    /**
     * @param context
     * @param isShowDialog 是否显示dialog
     * @param tag          用于取消网络连接
     * @param isCancel     是否能返回键取消，默认能
     */
    public DialogCallBack(Context context, boolean isShowDialog, Object tag, boolean isCancel) {
        this.context = context;
        this.isShowDialog = isShowDialog;
        this.tag = tag;
        this.isCancel = isCancel;
    }

    public DialogCallBack(Context context, boolean isShowDialog, Object tag) {
        this.context = context;
        this.isShowDialog = isShowDialog;
        this.tag = tag;
        isCancel = true;
    }

    public DialogCallBack(Context context, boolean isShowDialog) {
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
        if(dialog!=null){
            dialog.dismiss();
        }
    }

    @Override
    public void onFinish() {
        super.onFinish();
        if(dialog!=null&&dialog.isShowing()){
            dialog.dismiss();
        }
    }
}