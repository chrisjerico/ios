package com.phoenix.lotterys.util;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;

/**
 * Created by Luke
 * on 2019/6/14
 */
public class CookieHelper {
    SharedPreferences sp;
    /**
     * clear Cookie
     *
     * @param context
     */
    public static void clearCookie(Context context) {
        CookieSyncManager.createInstance(context);
        CookieSyncManager.getInstance().startSync();
        CookieManager.getInstance().removeSessionCookie();
    }
    /**
     * Sync Cookie
     */
    public static void syncCookie(Context context, String url) {
        try {
            CookieSyncManager.createInstance(context);
            CookieManager cookieManager = CookieManager.getInstance();
            cookieManager.setAcceptCookie(true);
            cookieManager.removeSessionCookie();// 移除
            cookieManager.removeAllCookie();
//                String cookie = SPUtil.getParam(context, "cookie", "");
//                String domain = SPUtil.getParam(context, "domain", "");
//                String path = SPUtil.getParam(context, "path", "");
//            String cookie = SharedPreferencesUtils.getString(context, "cookie0");//从cookie里取出的值就是ticket
//            String domain = SharedPreferencesUtils.getString(context, "cookie1");//domain
//            String path = SharedPreferencesUtils.getString(context, "cookie4");//path
            SharedPreferences sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
            String token = sp.getString("API-SID", "Null");
            StringBuilder sbCookie = new StringBuilder();
            sbCookie.append("API-TOKEN=2ae43e1270fc6116e5114c409401c7ef");
            sbCookie.append(";"+"API-SID=eN5NdZ3ngN43MhHN35nGGz3R");
//            sbCookie.append(";"+path);
            String cookieValue = sbCookie.toString();
            Log.e("==cookieValue==", cookieValue);
            cookieManager.setCookie(url, cookieValue);

//            sbCookie.append(";"+"API-TOKEN=2ae43e1270fc6116e5114c409401c7ef");
//            cookieManager.setCookie(url, sbCookie+"");

            CookieSyncManager.getInstance().sync();
        } catch (Exception e) {
            Log.e("==异常==", e.toString());
        }
    }




    /**
     * save cookie
     * @param
     */
//    public static void saveCookie(Context context){
//        DbCookieStore instance = DbCookieStore.INSTANCE;
//        List<HttpCookie> cookies = instance.getCookies();
//        String cookie = "";
//        for(int i=0;i<cookies.size();i++){
//            if(cookies.get(i).toString().startsWith("JSESSIONID")){
//                cookie = cookies.get(i).toString();
//                Log.e("==cookies==",cookies.toString());
//                Log.e("==cookie==",cookie);
//                Log.e("==domain==", cookies.get(i).getDomain());
//                Log.e("==path==", cookies.get(i).getPath());
//                //保存cookie
//                SPUtil.setParam(context, "cookie", cookie);
//                SPUtil.setParam(context, "domain", cookies.get(i).getDomain());
//                SPUtil.setParam(context, "path", cookies.get(i).getPath());
//            }
//        }
//    }




//    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public static void setCookies(Activity activity, String url) {
        SharedPreferences sp = activity.getSharedPreferences("User", Context.MODE_PRIVATE);
        String sid = sp.getString("API-SID", "Null");
        String token = sp.getString("API-TOKEN", "Null");
        String cookie = "loginsessid="+sid+";"+"logintoken="+token;
        if (!TextUtils.isEmpty(cookie)) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP){
                CookieSyncManager.createInstance( activity);
            }
            String[] cookieArray = cookie.split(";");
            for (int i = 0; i < cookieArray.length; i++) {
                int position = cookieArray[i].indexOf("=");
                String cookieName = cookieArray[i].substring(0, position);
                String cookieValue = cookieArray[i].substring(position + 1);
                String value = cookieName + "=" + cookieValue;
                CookieManager cookieManager = CookieManager.getInstance();
                cookieManager.setCookie(url, value);
                CookieSyncManager.getInstance().sync();//同步cookie
            }
        }
    }
//    public static void setCookies(Activity activity, String url) {
//        SharedPreferences sp = activity.getSharedPreferences("User", Context.MODE_PRIVATE);
//        String sid = sp.getString("API-SID", "Null");
//        String token = sp.getString("API-TOKEN", "Null");
//        String cookie = "loginsessid="+sid+";"+"logintoken="+token;
//        if (!TextUtils.isEmpty(cookie)) {
//            String[] cookieArray = cookie.split(";");
//            for (int i = 0; i < cookieArray.length; i++) {
//                int position = cookieArray[i].indexOf("=");
//                String cookieName = cookieArray[i].substring(0, position);
//                String cookieValue = cookieArray[i].substring(position + 1);
//                String value = cookieName + "=" + cookieValue;
//                Log.i("cookie", value);
//                CookieManager.getInstance().setCookie(url, value);
//            }
//        }
//    }
}
