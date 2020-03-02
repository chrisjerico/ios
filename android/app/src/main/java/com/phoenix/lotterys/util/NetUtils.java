package com.phoenix.lotterys.util;

import android.content.Context;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.HttpParams;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.json.JSONObject;

import java.net.URLDecoder;
import java.util.Map;

/**
 * 文件描述: 请求二次封装下
 * 创建者: IAN
 * 创建时间: 2019/7/2 13:28
 */
public class NetUtils {

    /**
     * get二次处理
     * @param url  路由
     * @param isShow  是否有login
     * @param context
     * @param netCallBack 回调
     */
    public static void get(String url,String map ,boolean isShow, Context context,NetCallBack netCallBack){
        //加密配制
        if (!StringUtils.isEmpty(map)) {
            if (Constants.ENCRYPT) {
                map=SecretUtils.DESede(map);
                url = url +map+Constants.SIGN+"&sign="+SecretUtils.RsaToken();
            }else{
                url = url + map;
            }
        }

        String urlDecode= URLDecoder.decode(Constants.BaseUrl()+url);

        OkGo.<String>get(urlDecode).tag(context).execute(new DialogCallBack(context, isShow,
                context, true) {
            @Override
            public void onSuccess(Response<String> response) {
                super.onSuccess(response);
                ResponseProcessing(response, netCallBack, context);
            }
            @Override
            public void onError(Response<String> response) {
//                ToastUtils.ToastUtils("网络异常，请稍后再试",context);
//                netCallBack.onError();
                ResponseProcessing(response, netCallBack, context);
            }
        });
    }


    /**
     * get二次处理
     * @param url  路由
     * @param isShow  是否有login
     * @param context
     * @param netCallBack 回调
     */
    public static void get(String url,Map<String,Object> map ,boolean isShow, Context context,NetCallBack netCallBack){
        //加密配制
        if (null!=map&&map.size()>0) {
            if (Constants.ENCRYPT) {
                map = Uiutils.sginEncrypt(map);
                url = url +Uiutils.transMapToString(map)+Constants.SIGN;
            }else{
                url = url + Uiutils.transMapToString(map);
            }
        }

        String urlDecode= URLDecoder.decode(Constants.BaseUrl()+url);

        OkGo.<String>get(urlDecode).tag(context).execute(new DialogCallBack(context, isShow,
                context, true) {
            @Override
            public void onSuccess(Response<String> response) {
                super.onSuccess(response);
                ResponseProcessing(response, netCallBack, context);
            }
            @Override
            public void onError(Response<String> response) {
//                ToastUtils.ToastUtils("网络异常，请稍后再试",context);
//                netCallBack.onError();
                ResponseProcessing(response, netCallBack, context);
            }
        });
    }
    public  static JSONObject mJSONObject;
    public static Map params;
    /**
     *
     * @param url
     * @param isShow
     * @param context
     * @param netCallBack
     */
    public static void post(String url,Map<String,Object> map , boolean isShow, Context context, NetCallBack
            netCallBack){
        //加密配制
        if (Constants.ENCRYPT) {
            map = Uiutils.sginEncrypt(map);
            url = url+Constants.SIGN;
        }

        OkGo.<String>post(Constants.BaseUrl()+url).tag(context).upJson(GsonUtil.toJson(map)).execute(new DialogCallBack(context,
                isShow, context,
                true) {
            @Override
            public void onSuccess(Response<String> response) {
                super.onSuccess(response);
                ResponseProcessing(response, netCallBack, context);
            }

            @Override
            public void onError(Response<String> response) {
//                ToastUtil.toastShortShow(context,"网络异常，请稍后再试");
                ResponseProcessing(response, netCallBack, context);
            }
        });
    }
    /**
     *
     * @param url
     * @param isShow
     * @param context
     * @param netCallBack
     */
    public static void post1(String url,HttpParams map , boolean isShow, Context context, NetCallBack
            netCallBack){
        //加密配制
//        if (Constants.ENCRYPT) {
//            map = Uiutils.sginEncrypt(map);
//            url = url + "&checkSign=true";
//        }
//        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");//使用的是表单请求类型
        OkGo.<String>post(Constants.BaseUrl()+url).tag(context).headers("Content-Type",
                "application/x-www-form-urlencoded;charset=UTF-8").params(map). execute(new DialogCallBack(context,
                isShow, context,
                true) {
            @Override
            public void onSuccess(Response<String> response) {
                super.onSuccess(response);
                ResponseProcessing(response, netCallBack, context);
            }

            @Override
            public void onError(Response<String> response) {
//                ToastUtil.toastShortShow(context,"网络异常，请稍后再试");
                ResponseProcessing(response, netCallBack, context);
            }
        });
    }

    private static void ResponseProcessing(Response<String> response, NetCallBack netCallBack, Context context) {
        if ( response.body() != null) {
            try {
                BaseBean bb = new Gson().fromJson(response.body(), BaseBean.class);
                if (bb.getCode()==0){
                    netCallBack.onSuccess(null!=response.body()?response.body(): null);
                }else if (response.code() == 401 && response.body() != null) {
                    errorTis(bb, context);
                    netCallBack.onError();

                    Uiutils.login(context);
                }else {
                    errorTis(bb, context);

                }
            } catch (Exception e) {
                ToastUtil.toastShortShow(context,"网络异常，请稍后再试");
                netCallBack.onError();
            }
        }else{
            ToastUtil.toastShortShow(context,"网络异常，请 稍后再试");
            netCallBack.onError();
        }
        if(response!=null&&response.getException()!=null&&response.getException().toString().contains("UnknownHostException"))
            Constants.alterHost();
    }

    private static void errorTis(BaseBean bb, Context context) {
        if (null!=bb&&null!=bb.getExtra()&&!bb.getExtra().isHasNickname()){
            EvenBusUtils.setEvenBus(new Even(EvenBusCode.NOTHASNICKNAME));
        }else if (null!=bb && null!=bb.getMsg()&& !bb.getMsg().equals("")) {
            ToastUtil.toastShortShow(context, bb.getMsg());
        }else{
            ToastUtil.toastShortShow(context,"网络异常，请稍后 再试");
        }
    }

    public interface  NetCallBack {
        void onSuccess(String object);
        void onError();
    }
}
