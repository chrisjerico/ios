package com.phoenix.lotterys.util;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Base64;

import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.view.MyIntentService;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.StreamCorruptedException;
import java.util.List;

public class SPConstants {

    public static final String SP_User = "User";
    public static final String SP_SixNum = "SixNum";
    public static final String SP_CONFIG = "config";
    public static final String SP_NULL = "Null";
    public static final String SP_API_SID = "API-SID";
    public static final String SP_API_TOKEN = "API-TOKEN";

    public static final String SP_COIN = "coin";
    public static final String SP_USERNAME = "username";
    public static final String SP_NAME = "name";
    public static final String SP_REBATE = "rebate";
    public static final String SP_LEVEL_ID = "level_id";
    public static final String SP_PARENTID = "parentId";
    public static final String SP_PASSWORD = "password";
    public static final String SP_USERTYPE = "userType";

    //个人信息
    public static final String SP_BALANCE = "balance";  //余额
    public static final String SP_USR = "usr";  //账号名字
    public static final String SP_HASBANKCARD = "hasBankCard";  //银行卡
    public static final String SP_HASFUNDPWD = "hasFundPwd";  //支付密码
    public static final String SP_CURLEVELGRADE = "curLevelGrade";   //新手  钻石等级vip1
    public static final String SP_NEXTLEVELGRADE = "nextLevelGrade";  //下一等级  钻石等级 青铜
    public static final String SP_CURLEVELINT = "curLevelInt";  //当前等级值  0
    public static final String SP_NEXTLEVELINT = "nextLevelInt";  //下一等级  100
    public static final String SP_TASKREWARDTITLE = "taskRewardTitle";  //分数类型  积分/开心乐
    public static final String SP_TASKREWARDTOTAL = "taskRewardTotal";  //分数  0.0000
    public static final String SP_TASKREWARD = "taskReward";  //分数  0.0000
    public static final String AVATAR = "avatar";  //头像
    public static final String SP_ISTEST = "isTest";  //是否测试账号
    public static final String SP_UNREADMSG = "unreadMsg";  //未读消息
    public static final String SP_CURLEVELTITLE = "curLevelTitle";  //新手

    //    配置文件
    public static final String SP_ALLOWREG = "allowreg";   //会员注册
    public static final String SP_RECO = "hide_reco";    //代理人
    public static final String SP_REG_NAME = "reg_name";    //真实姓名
    public static final String SP_REG_FUNDPWD = "reg_fundpwd";  //取款密码
    public static final String SP_REG_QQ = "reg_qq";   //QQ
    public static final String SP_REG_WX = "reg_wx";    //微信
    public static final String SP_REG_PHONE = "reg_phone";  //手机
    public static final String SP_REG_EMAIL = "reg_email";  //邮箱
    public static final String SP_SMSVERIFY = "smsVerify";  //手机短信验证
    public static final String SP_REG_VCODE = "reg_vcode";  //手机端注册验证类型   验证码  滑动验证
    public static final String SP_LOGIN_TO = "login_to";  //跳转首页1会员中心0

    public static final String SP_PASS_LENGTH_MIN = "pass_length_min";  //密码长度最小
    public static final String SP_PASS_LENGTH_MAX = "pass_length_max";  //密码长度最大
    public static final String SP_PASS_LIMIT = "pass_limit";  //密码长度最大
    public static final String SP_ZXKFURL = "zxkfUrl";  //在线客服
    public static final String SP_CLOSEREGREASON = "closeregreason";  //关闭注册原因
    public static final String SP_MEMBERASPARENT = "memberAsParent";  //允许会员成为上线
    public static final String SP_MOBILE_LOGO = "mobile_logo";  //手机logo

    public static final String CONFIGBEAN = "configBean";  //配制实体
    public static final String USERINFO = "userInfo";  //个人信息实体

    public static final String SP_MINWITHDRAWMONEY = "minWithdrawMoney";  //下注单笔限额最小
    public static final String SP_MAXWITHDRAWMONEY = "maxWithdrawMoney";  //下注单笔限额最大
    public static final String SP_YUEBAONAME = "yuebaoName";  //动态利息宝名字

    public static final String SP_YUEBAOSHUTDOWN = "yuebaoSwitch";  //动态利息宝开关

    public static final String SP_APIHOSTS = "apiHosts";  //手机logo
    //    启动页
    public static final String SP_LAUNCH = "launch";  //动态利息宝名字

    public static final String SP_TASKHALL = "taskHall";  //任务大厅别名  适配c134

    public static String getValue(Context context, String s) {
        SharedPreferences sp = context.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        String value = sp.getString(s, SPConstants.SP_NULL);
        return value;
    }


    public static Boolean getValue(String s, Context context) {
        SharedPreferences sp = context.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        boolean value = sp.getBoolean(s, false);
        return value;
    }

    //配置文件   0隐藏 1 选填  2 必填
    public static String getConfigValue(Context context, String s, String name) {
        SharedPreferences sp = context.getSharedPreferences(name, Context.MODE_PRIVATE);
        String value = sp.getString(s, SPConstants.SP_NULL);
        return value;
    }


    //获取token
    public static String checkLoginInfo(Context context) {
        SharedPreferences sp = context.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        String token = sp.getString(SP_API_SID, SPConstants.SP_NULL);
        if (!token.equals(SPConstants.SP_NULL)) {
            return token;
        } else {
//            ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
//            if (configBean != null && configBean.getData() != null && configBean.getData().getMobileTemplateCategory().equals("5")) {
//                context.startActivity(new Intent(context, BlackLoginActivity.class));
//            } else {
//                context.startActivity(new Intent(context, LoginActivity.class));
//            }
            Uiutils.login(context);
        }
        return "";
    }

    public static String getToken(Context context) {
        SharedPreferences sp = context.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        String token = sp.getString(SP_API_SID, SPConstants.SP_NULL);
        if (!token.equals(SPConstants.SP_NULL)) {
            return token;
        } else {
            return "";
        }
    }

    public static void setValue(Context context, String title, String name, String value) {
        SharedPreferences sp = context.getSharedPreferences(title, Context.MODE_PRIVATE);
        SharedPreferences.Editor edit = sp.edit();
        edit.putString(name, value);
        edit.commit();
    }

    public static boolean isTourist(Activity context) {
        SharedPreferences sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
        String userType = sp.getString("userType", "Null");
        if (!StringUtils.isEmpty(userType) && StringUtils.equals("guest", userType)) {
            return true;
        }
        return false;
    }

    public static String SceneList2String(List SceneList)
            throws IOException {
        // 实例化一个ByteArrayOutputStream对象，用来装载压缩后的字节文件。
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        // 然后将得到的字符数据装载到ObjectOutputStream
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(
                byteArrayOutputStream);
        // writeObject 方法负责写入特定类的对象的状态，以便相应的 readObject 方法可以还原它
        objectOutputStream.writeObject(SceneList);
        // 最后，用Base64.encode将字节文件转换成Base64编码保存在String中
        String SceneListString = new String(Base64.encode(
                byteArrayOutputStream.toByteArray(), Base64.DEFAULT));
        // 关闭objectOutputStream
        objectOutputStream.close();
        return SceneListString;

    }


    @SuppressWarnings("unchecked")
    public static List String2SceneList(String SceneListString)
            throws StreamCorruptedException, IOException,
            ClassNotFoundException {
        byte[] mobileBytes = Base64.decode(SceneListString.getBytes(),
                Base64.DEFAULT);
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(
                mobileBytes);
        ObjectInputStream objectInputStream = new ObjectInputStream(
                byteArrayInputStream);
        List SceneList = (List) objectInputStream
                .readObject();
        objectInputStream.close();
        return SceneList;
    }
    static Application mApp;

    public static void setListValue( List<String> list) {
//        SharedPreferences sp = context.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        mApp = (Application) Application.getContextObject();
        SharedPreferences mySharedPreferences = mApp.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        SharedPreferences.Editor edit = mySharedPreferences.edit();
        try {
            String liststr = SceneList2String(list);
            edit.putString(SP_APIHOSTS, liststr);
            edit.commit();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static List<String> getListValue() {
        mApp = (Application) Application.getContextObject();
        List<String> list = null;
        SharedPreferences sharedPreferences = mApp.getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        String liststr = sharedPreferences.getString(SP_APIHOSTS, "");
        try {
            list = String2SceneList(liststr);
        } catch (StreamCorruptedException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }


    public  static void saveData(UserInfo li,Context context){
        SharedPreferences sp = null;
        sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
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
        edit.commit();
    }
}
