package com.phoenix.lotterys.view;


import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import androidx.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.bean.UpdataVersionBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.LoginInfo;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.greenrobot.eventbus.EventBus;

import java.net.URLDecoder;


/**
 * Date:2019/4/19
 * TIME:13:03
 * author：Luke
 */
public class MyIntentService extends IntentService {

    private final String TAG = "MyIntentService";
    private final int CONFIG = 1000;
    private final int DEMO = 2000;
    private final int UPDATA = 5000;
    private final int USERINFO = 3000;
    private final int SIXNUM = 4000;
    private final int AUTOTRANSFEROUT = 6000;

    private SharedPreferences sp;

    public MyIntentService(String name) {
        super(name);
    }

    public MyIntentService() {
        this("MyIntentServiceThread");
    }

    @Override
    protected void onHandleIntent(@Nullable Intent intent) {
        sp = getSharedPreferences("User", Context.MODE_PRIVATE);
        int type = Integer.parseInt(intent.getStringExtra("type"));
        switch (type) {
            case CONFIG:
                getConfig();
                break;
            case AUTOTRANSFEROUT:
                checkToken();
                Log.e("getAutoTransfer111","getAutoTransfer");
                break;
            case DEMO:
                mDemo();
                break;
            case SIXNUM:
                break;
            case USERINFO:
                String token = SPConstants.getValue(MyIntentService.this, SPConstants.SP_API_SID);
                if (!token.equals(SPConstants.SP_NULL)) {
                    getUserInfo(token);
                }
                break;
            case UPDATA:
                getUpdataVersion();
                break;
            default:
                break;
        }
    }

    private void checkToken() {
        String token = SPConstants.getValue(MyIntentService.this, SPConstants.SP_API_SID);
        if (!token.equals(SPConstants.SP_NULL)) {
            getAutotransferout(token);
        }
    }

    private void getAutotransferout(String token) {
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.AUTOTRANSFEROUT + (Constants.ENCRYPT ? Constants.SIGN : "")))
                .params("token", SecretUtils.DESede(token))
                .params("sign", SecretUtils.RsaToken())//
                .execute(new StringCallback() {
                    @Override
                    public void onSuccess(Response<String> response) {
                        if (response != null && response.code() == 200 && response.body() != null) {
                            BaseBean bb = null;
                            try {
                                bb = new Gson().fromJson(response.body(), BaseBean.class);
                            } catch (JsonSyntaxException e) {
                                e.printStackTrace();
                            }
                        }
                    }

                    @Override
                    public void onError(Response<String> response) {
//                        checkToken();
                    }

                });
    }

    private void getUpdataVersion() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.ANDROIDVERSION+SecretUtils.DESede("android")+"&sign="+SecretUtils.RsaToken())).execute(new StringCallback() {
            @Override
            public void onSuccess(Response<String> response) {
                if (response != null && response.code() == 200 && response.body() != null) {
                    BaseBean bb = null;
                    try {
                        bb = new Gson().fromJson(response.body(), BaseBean.class);
                    } catch (JsonSyntaxException e) {
                        e.printStackTrace();
                    }
                    if (bb != null && bb.getCode() == 0) {
                        try {
                            UpdataVersionBean uv = new Gson().fromJson(response.body(), UpdataVersionBean.class);
                            if (uv != null && uv.getCode() == 0) {
                                int apkVer = APKVersionCodeUtils.getVersionCode(MyIntentService.this);
                                if (uv.getData() != null && !TextUtils.isEmpty(uv.getData().getVersionCode()) ) {
                                    String verCode = uv.getData().getVersionCode().replaceAll("\\.", "");
                                    if (ShowItem.checkStrIsNum(verCode)) {
                                        Double ver = Double.parseDouble(verCode);
                                        if (ver > apkVer) {
                                            EventBus.getDefault().postSticky(new Even(50000, response.body() + ""));   //版本更新

                                        } else
                                            ToastUtil.toastShortShow(getApplication(), "当前版本已经是最新版本");
                                    }
                                }
                            }
                        } catch (JsonSyntaxException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        });
    }


    private void getUserInfo(String s) {
        clearUserInfo();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.USERINFO + SecretUtils.DESede(s)+"&sign="+ SecretUtils.RsaToken())).execute(new StringCallback() {
            @Override
            public void onSuccess(Response<String> response) {
                if (response != null && response.code() == 200 && response.body() != null) {
                    BaseBean bb = null;
                    try {
                        bb = new Gson().fromJson(response.body(), BaseBean.class);
                    } catch (JsonSyntaxException e) {
                        e.printStackTrace();
                    }
                    if (bb != null && bb.getCode() == 0) {
                        try {
                            UserInfo li = new Gson().fromJson(response.body(), UserInfo.class);
                            if (li != null && li.getCode() == 0) {
                                SharedPreferences.Editor edit = sp.edit();
                                edit.putString(SPConstants.SP_BALANCE, FormatNum.amountFormat(li.getData().getBalance(), 4));   //金额
                                edit.putString(SPConstants.SP_USR, li.getData().getUsr());
                                edit.putString(SPConstants.SP_CURLEVELGRADE, li.getData().getCurLevelGrade());
                                edit.putString(SPConstants.SP_NEXTLEVELGRADE, li.getData().getNextLevelGrade());
                                edit.putString(SPConstants.SP_CURLEVELINT, li.getData().getCurLevelInt());
                                edit.putString(SPConstants.SP_NEXTLEVELINT, li.getData().getNextLevelInt());
                                edit.putString(SPConstants.SP_TASKREWARDTITLE, li.getData().getTaskRewardTitle());
                                edit.putString(SPConstants.SP_TASKREWARDTOTAL, li.getData().getTaskRewardTotal());
                                edit.putString(SPConstants.SP_HASBANKCARD, li.getData().isHasBankCard() + "");
                                edit.putString(SPConstants.SP_HASFUNDPWD, li.getData().isHasFundPwd() + "");
                                edit.putString(SPConstants.SP_ISTEST, li.getData().isIsTest() + "");
                                edit.putString(SPConstants.SP_UNREADMSG, li.getData().getUnreadMsg() + "");  //未读消息
                                edit.putString(SPConstants.SP_CURLEVELTITLE, li.getData().getCurLevelTitle());
                                edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, li.getData().isYuebaoSwitch());
                                edit.putString(SPConstants.SP_TASKREWARD, li.getData().getTaskReward());
                                //头像
                                edit.putString(SPConstants.AVATAR, li.getData().getAvatar());
                                //存登录返回对像
                                ShareUtils.saveObject(MyIntentService.this,
                                        SPConstants.USERINFO, li);
                                SPConstants.saveData(li,MyIntentService.this);
                                edit.commit();

                                EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LOGIN));

                            }
                        } catch (JsonSyntaxException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }


        });
    }

    private void clearUserInfo() {
        SharedPreferences.Editor edit = sp.edit();
        edit.putString(SPConstants.SP_BALANCE, "Null");   //金额
        edit.putString(SPConstants.SP_USR, "Null");
        edit.putString(SPConstants.SP_CURLEVELGRADE, "Null");
        edit.putString(SPConstants.SP_NEXTLEVELGRADE, "Null");
        edit.putString(SPConstants.SP_CURLEVELINT, "Null");
        edit.putString(SPConstants.SP_NEXTLEVELINT, "Null");
        edit.putString(SPConstants.SP_TASKREWARDTITLE, "Null");
        edit.putString(SPConstants.SP_TASKREWARDTOTAL, "Null");
        edit.putString(SPConstants.SP_HASBANKCARD, "Null");
        edit.putString(SPConstants.SP_HASFUNDPWD, "Null");
        edit.putString(SPConstants.SP_ISTEST, "Null");
        edit.putString(SPConstants.SP_UNREADMSG, "Null");  //未读消息
        edit.putString(SPConstants.SP_CURLEVELTITLE, "Null");
        edit.putString(SPConstants.AVATAR, "Null");
        edit.commit();
    }

    //配置文件   0隐藏 1 选填  2必填
    private void getConfig() {
//
//        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.CONFIG)).tag(MyIntentService.this).execute(new NetDialogCallBack(MyIntentService.this, false, MyIntentService.this,
//                true, ConfigBean.class) {
//            @Override
//            public void onUi(Object o) throws IOException {
//                ConfigBean config = (ConfigBean) o;
//                if (config != null && config.getCode() == 0 && config.getData() != null) {
//                    ShareUtils.saveObject(MyIntentService.this, SPConstants.CONFIGBEAN, config);
//                    SharedPreferences.Editor edit = sp.edit();
//                    edit.putString(SPConstants.SP_ZXKFURL, config.getData().getZxkfUrl() == null ? "" : config.getData().getZxkfUrl());
//                    edit.putString(SPConstants.SP_MOBILE_LOGO, config.getData().getMobile_logo() == null ? "" : config.getData().getMobile_logo());   //首页左边logo
////                    edit.putString(SPConstants.SP_MINWITHDRAWMONEY, config.getData().getMinWithdrawMoney() == null ? "" : config.getData().getMinWithdrawMoney());//下注单笔限额最小
////                    edit.putString(SPConstants.SP_MAXWITHDRAWMONEY, config.getData().getMaxWithdrawMoney() == null ? "" : config.getData().getMaxWithdrawMoney());//下注单笔限额最大
//                    edit.putString(SPConstants.SP_YUEBAONAME, config.getData().getYuebaoName() == null ? "" : config.getData().getYuebaoName());//利息宝
////                    edit.putString(SPConstants.SP_APIHOSTS, config.getData().getApiHosts() == null ? "" : String.valueOf(config.getData().getApiHosts()));//域名
//                    edit.commit();
//                    SPConstants.setListValue(config.getData().getApiHosts());
////                    EventBus.getDefault().postSticky(new MessageEvent("config"));
//
//                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.CONFIG));
//
//
//                }
//
//
//            }
//
//            @Override
//            public void onErr(BaseBean bb) throws IOException {
//
//            }
//
//            @Override
//            public void onFailed(Response<String> response) {
//
//            }
//        });
    }

    private void mDemo() {
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.GUESTLOGIN + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .params("usr", SecretUtils.DESedePassw("!guest!"))//
                .params("pwd", SecretUtils.DESedePassw("!guest!"))//
                .params("sign", SecretUtils.RsaToken())//
                .execute(new StringCallback() {
                    @Override
                    public void onSuccess(Response<String> response) {
                        if (response != null && response.code() == 200 && response.body() != null) {
                            BaseBean bb = null;
                            try {
                                bb = new Gson().fromJson(response.body(), BaseBean.class);
                            } catch (JsonSyntaxException e) {
                                e.printStackTrace();
                            }
                            if (bb != null && bb.getCode() == 0) {
                                try {
                                    LoginInfo li = new Gson().fromJson(response.body(), LoginInfo.class);
                                    if (li != null && li.getCode() == 0) {
                                        SharedPreferences.Editor edit = sp.edit();
                                        edit.putString("SP_USR", li.getData().getUsername());
                                        edit.putString("API-SID", li.getData().getAPISID());
                                        edit.putString("API-TOKEN", li.getData().getAPITOKEN());
                                        edit.putString("name", li.getData().getName());//名字
                                        edit.putString("rebate", li.getData().getRebate());
                                        edit.putString("userType", "guest");   //是否guest
                                        edit.commit();
                                        EventBus.getDefault().postSticky(new MessageEvent("login"));
                                        String token = SPConstants.getValue(MyIntentService.this, SPConstants.SP_API_SID);
                                        if (!token.equals(SPConstants.SP_NULL)) {
                                            getUserInfo(token);
                                        }
                                    }
                                } catch (JsonSyntaxException e) {
                                    e.printStackTrace();

                                }
                            }
                        }
                    }
                });
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }


    @Override
    public void onCreate() {
        super.onCreate();
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            startForeground(1,null);
//        }
    }

}
