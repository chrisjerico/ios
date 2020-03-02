package com.wanxiangdai.commonlibrary.util.EvenBusUtil;

import android.content.Context;

import org.greenrobot.eventbus.EventBus;

/**
 * 文件描述:  EvenBusUtils 工具类
 * 创建者: IAN
 * 创建时间: 2019/7/2 12:43
 */
public class EvenBusUtils {

    /**
     * 注册
     * @param context
     */
    public static void register(Object context){
        EventBus.getDefault().register(context);
    }

    /**
     * 注销
     * @param context
     */
    public static void unregister(Object context){
        EventBus.getDefault().unregister(context);
    }

    /**
     * 发送
     * @param even
     */
    public static void setEvenBus(Even even){
        EventBus.getDefault().post(even);
    }
}
