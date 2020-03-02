package com.wanxiangdai.commonlibrary.util;

import android.content.Context;
import android.text.TextUtils;
import android.view.Gravity;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 弹出框工具类
 */
public class ToastUtil {


    /**
     * @param context 内容器实体
     * @param text    提示文字内容
     */
    public static void toastShortShow(Context context, String text) {

        if (null==context)
            return;

        if (!TextUtils.isEmpty(text)) {
            final Toast toast = Toast.makeText(context, text, Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER, 0, 0);
            toast.show();
            final Timer timer = new Timer();
            new Timer().schedule(new TimerTask() {
                @Override
                public void run() {
                    toast.cancel();
                    timer.cancel();
                }
            }, 1000);
        }

    }


    /**
     * @param context 内容器实体
     * @param text    提示文字内容
     */
    public static void toastShortShow(Context context, String text,long time) {

        if (null==context)
            return;

        if (!TextUtils.isEmpty(text)) {
            final Toast toast = Toast.makeText(context, text, Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER, 0, 0);
            toast.show();
            final Timer timer = new Timer();
            new Timer().schedule(new TimerTask() {
                @Override
                public void run() {
                    toast.cancel();
                    timer.cancel();
                }
            }, time);
        }

    }
}
