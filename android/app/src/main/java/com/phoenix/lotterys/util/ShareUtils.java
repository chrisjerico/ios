package com.phoenix.lotterys.util;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;

/**
 * 文件描述: sp
 * 创建者: IAN
 * 创建时间: 2019/7/21 21:08
 */
public class ShareUtils {

    public static final String NAME = "User";


    /**
     * 存储String类型的值
     * @param mContext this
     * @param key      key值
     * @param value    要存储的String值
     */
    public static void putString(Context mContext, String key, String value) {
        SharedPreferences sharedPreferences = mContext.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        sharedPreferences.edit().putString(key, value).commit();
    }

    /**
     * 获取String类型的值
     * @param mContext this
     * @param key      key
     * @param defValue 默认值
     * @return
     */
    public static String getString(Context mContext, String key, String defValue) {
        SharedPreferences sharedPreferences = mContext.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        return sharedPreferences.getString(key, defValue);
    }


    /**
     * 存储Int类型的值
     * @param mContext this
     * @param key      key
     * @param value    要存储的Int值
     */
    public static void putInt(Context mContext, String key, int value) {
        SharedPreferences sharedPreferences = mContext.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        sharedPreferences.edit().putInt(key, value).commit();
    }


    /**
     * 获取Int类型的值
     * @param mContext this
     * @param key      key
     * @param defValue 默认值
     * @return
     */
    public static int getInt(Context mContext, String key, int defValue) {
        SharedPreferences sharedPreferences = mContext.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        return sharedPreferences.getInt(key, defValue);
    }


    /**
     * 存储Boolean类型的值
     * @param mContext this
     * @param key      key
     * @param value    要存储Boolean值
     */
    public static void putBoolean(Context mContext, String key, boolean value) {
        SharedPreferences sharedPreferences = mContext.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        sharedPreferences.edit().putBoolean(key, value).commit();
    }

    /**
     * 获取Boolean类型的值
     * @param mContext this
     * @param key      key
     * @param defValue 默认值
     * @return
     */
    public static boolean getBoolean(Context mContext, String key, Boolean defValue) {
        SharedPreferences sharedPreferences = mContext.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        return sharedPreferences.getBoolean(key, defValue);
    }

    //删除 单个 key
    public static void deleShare(Context context, String key) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        sharedPreferences.edit().remove(key).commit();
    }

    //删除全部 key
    public static void deleAll(Context context) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        sharedPreferences.edit().clear().commit();
    }

    /*
     * 保存对象
     * */
    public static boolean saveObject(Context mContext,String key, Object object) {


        boolean isSuccess = false;
        String v  ="";
        if (null!=object){
            v = GsonUtil.toJson(object);
        }
        putString(mContext,key,v);

        Log.e("saveObject",v+"//");

        if (StringUtils.equals(SPConstants.USERINFO,key))
            EvenBusUtils.setEvenBus(new Even(EvenBusCode.CHANGE_PICTURE));

        return isSuccess;
    }
    /*
     * 获取存储在SP中的对象
     * */
    public static Object getObject(Context mContext,String key,Class c) {
        Object object = null;

        String v = getString(mContext,key,"");

        if (!StringUtils.isEmpty(v))
        object = GsonUtil.fromJson(v,c);

        Log.e("getObject",object+"//");
        return object;
    }

}
