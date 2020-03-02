package com.wanxiangdai.commonlibrary.util;

import android.content.Context;
import android.util.DisplayMetrics;
import android.view.WindowManager;

import java.lang.ref.WeakReference;

/**
 * Created by W on 2016/8/12 0012.
 */
public class NewUiUtils {
    private static WeakReference<Context> mContext;

    private static int screenWidth = 0;
    private static int screenHeight = 0;
    private static float screenDensity = 0;
    private static int densityDpi = 0;
    private static int statusBarHeight = 0;
    private static int navigationBarHeight = 0;

    public static void init(Context context) {
        if (mContext == null) {
            if (context == null) {
                return;
            }
            mContext = new WeakReference<>(context);
            DisplayMetrics metrics = new DisplayMetrics();
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            if (wm != null) {
                wm.getDefaultDisplay().getMetrics(metrics);
                screenWidth = metrics.widthPixels;
                screenHeight = metrics.heightPixels;
                screenDensity = metrics.density;
                densityDpi = metrics.densityDpi;
                statusBarHeight = context.getResources().getDimensionPixelSize(context.getResources().getIdentifier("status_bar_height", "dimen", "android"));
                int resIdNavigationBar = context.getResources().getIdentifier("navigation_bar_height", "dimen", "android");
                if (resIdNavigationBar > 0) {
                    navigationBarHeight = context.getResources().getDimensionPixelSize(resIdNavigationBar);
                }
            }
        }
    }

    public static int dip2px(float dipValue) {
        return (int) (dipValue * screenDensity + 0.5f);
    }

    public static int px2dip(float pxValue) {
        return (int) (pxValue / screenDensity + 0.5f);
    }

    public static int sp2px(float spValue) {
        final float fontScale = mContext.get().getResources().getDisplayMetrics().scaledDensity;
        return (int) (spValue * fontScale + 0.5f);
    }

    public static int px2sp(float pxValue) {
        final float fontScale = mContext.get().getResources().getDisplayMetrics().scaledDensity;
        return (int) ((pxValue - 0.5f) / fontScale);
    }

    public static int getScreenWidth() {
        return screenWidth;
    }

    public static int getScreenHeight() {
        return screenHeight;
    }

    public static int getStatusBarHeight() {
        return statusBarHeight;
    }

    public static int getNavigationBarHeight() {
        return navigationBarHeight;
    }
}
