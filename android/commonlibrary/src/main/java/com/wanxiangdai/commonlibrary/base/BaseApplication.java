package com.wanxiangdai.commonlibrary.base;

import android.app.Application;
import android.content.Context;
import androidx.multidex.MultiDex;

import com.kingja.loadsir.core.LoadSir;
import com.wanxiangdai.commonlibrary.config.ProjectConfig;
import com.wanxiangdai.commonlibrary.loadsir.EmptyCallback;
import com.wanxiangdai.commonlibrary.loadsir.ErrorCallback;
import com.wanxiangdai.commonlibrary.loadsir.LoadingCallback;
import com.wanxiangdai.commonlibrary.loadsir.NetworkErrorCallback;
import com.wanxiangdai.commonlibrary.util.ContextUtil;
import com.wanxiangdai.commonlibrary.util.CustomActivityManager;

import java.io.File;


/**
 * Created by lottery on 2018/3/3
 */

public class BaseApplication extends Application {
    private static BaseApplication mApplication = null;

    /**
     * 单例方法
     */
    public static BaseApplication getInstance() {
        return mApplication;
    }

    /**
     * Activity管理器
     */
    private CustomActivityManager mActivityManager = null;


    @Override
    public void onCreate() {
        super.onCreate();
        mApplication = this;
        mActivityManager = new CustomActivityManager();
        initFileDir();// 初始化文件缓存目录
        initOtherLib();//导入第三方SDK包

        ContextUtil.INSTANCE.setContext(this);
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    /**
     * 当系统内存不足时调用
     */
    @Override
    public void onLowMemory() {
        super.onLowMemory();
        Runtime.getRuntime().gc();// 通知Java虚拟机回收垃圾
    }

    /**
     * 程序终止时候调用
     */
    @Override
    public void onTerminate() {
        super.onTerminate();
    }

    /**
     * 获取activity管理器
     *
     * @return CustomActivityManager
     */
    public CustomActivityManager getActivityManager() {
        return mActivityManager;
    }


    /**
     * 初始化SDK
     */
    private void initOtherLib() {
        initLoadSir();
    }

    private void initLoadSir() {
        LoadSir.beginBuilder()
                .addCallback(new ErrorCallback())
                .addCallback(new NetworkErrorCallback())
                .addCallback(new EmptyCallback())
                .addCallback(new LoadingCallback())
                .setDefaultCallback(LoadingCallback.class)
                .commit();
    }



    /**
     * 初始化界面缓存目录
     */
    private void initFileDir() {
        File appFile = new File(ProjectConfig.APP_PATH);
        if (!appFile.exists()) {
            appFile.mkdirs();
        }
        File cacheFile = new File(ProjectConfig.DIR_CACHE);// 其他下载缓存数据目录
        if (!cacheFile.exists()) {
            cacheFile.mkdirs();
        }
        File upDataCacheFile = new File(ProjectConfig.DIR_UPDATE);// 程序在手机SDK中的更新缓存目录.
        if (!upDataCacheFile.exists()) {
            upDataCacheFile.mkdirs();
        }
        File logCacheFile = new File(ProjectConfig.LOGCAT_DIR);// 程序在手机SDK中的日志缓存目录.
        if (!logCacheFile.exists()) {
            logCacheFile.mkdirs();
        }

        File imageCacheFile = new File(ProjectConfig.DIR_IMG);// 程序在手机SDK中的图片缓存目录.
        if (!imageCacheFile.exists()) {
            imageCacheFile.mkdirs();
        }

        File videoCacheFile = new File(ProjectConfig.DIR_VIDEO);// 程序在手机SDK中的视频缓存目录.
        if (!videoCacheFile.exists()) {
            videoCacheFile.mkdirs();
        }
        File audioCacheFile = new File(ProjectConfig.DIR_AUDIO);// 程序在手机SDK中的音频缓存目录.
        if (!audioCacheFile.exists()) {
            audioCacheFile.mkdirs();
        }
    }

//    private String getAppName(int pID) {
//        String processName = null;
//        ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
//        List l = am.getRunningAppProcesses();
//        Iterator i = l.iterator();
//        PackageManager pm = getPackageManager();
//        while (i.hasNext()) {
//            ActivityManager.RunningAppProcessInfo info = (ActivityManager.RunningAppProcessInfo) (i.next());
//            try {
//                if (info.pid == pID) {
//                    CharSequence c = pm.getApplicationLabel(pm.getApplicationInfo(info.processName, PackageManager.GET_META_DATA));
//                    // Log.d("Process", "Id: "+ info.pid +" ProcessName: "+
//                    // info.processName +"  Label: "+c.toString());
//                    // processName = c.toString();
//                    processName = info.processName;
//                    return processName;
//                }
//            } catch (Exception e) {
//                // Log.d("Process", "Error>> :"+ e.toString());
//            }
//        }
//        return processName;
//    }
}
