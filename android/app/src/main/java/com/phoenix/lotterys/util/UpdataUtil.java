package com.phoenix.lotterys.util;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.DialogInterface;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.google.gson.Gson;
import com.maning.updatelibrary.InstallUtils;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.UpdataVersionBean;
import com.phoenix.lotterys.view.updata.UpdataDialog;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;

/**
 * Greated by Luke
 * on 2019/7/18
 */
public class UpdataUtil {
    private int apkVer;
    //检查版本
    UpdataDialog updateDialog;
    private static final int LOADPRE = 3;
    private String downUrl;
    private InstallUtils.DownloadCallBack downloadCallBack;
    private String apkDownloadPath;
    Activity mActivity;
    public UpdataUtil(Activity mActivity, String data){
       this.mActivity=mActivity;
        initCallBack();
        if (data != null) {
            UpdataVersionBean uv = new Gson().fromJson(data, UpdataVersionBean.class);
            if (uv != null && uv.getCode() == 0) {
//                initCallBack();
                update(uv);
                downUrl = uv.getData().getFile();
            }
        }
        this.type=0;
    }

    private int type ;

    public UpdataUtil(Activity mActivity, String data,int type){
        this.mActivity=mActivity;
        initCallBack();
        if (data != null) {
                downUrl = data;
            mInstallGoogle();
        }
        this.type=type;
    }

    private void update(UpdataVersionBean updata) {
        updateDialog = new UpdataDialog(mActivity);
        updateDialog.setMessage(ShowItem.isNumeric(updata.getData().getSwitchUpdate())? Integer.parseInt(updata.getData
                ().getSwitchUpdate()) :0, updata.getData().getUpdateContent(), "最新版本：V" + updata.getData().getVersionCode(), "", "Y");
        updateDialog.show();
        updateDialog.setNoOnclickListener(mActivity.getResources().getString(R.string.cancel), new UpdataDialog.onNoOnclickListener() {
            @Override
            public void onNoClick() {

                updateDialog.dismiss();
            }
        });

        updateDialog.setYesOnclickListener(mActivity.getResources().getString(R.string.updata), new UpdataDialog.onYesOnclickListener() {
            @Override
            public void onYesClick() {
                    mInstall();
//                updateDialog.dismiss();
            }
        });
        updateDialog.setonUpdateOnclickListener(new UpdataDialog.onUpdateOnclickListener() {
            @Override
            public void onUpdateClick() {
                mInstall();
//                updateDialog.dismiss();

            }
        });
    }

    public void mInstallGoogle() {
        if (!PermissionUtils.isGrantSDCardReadPermission(mActivity)) {
            PermissionUtils.requestSDCardReadPermission(mActivity, 100);
        } else {
            InstallUtils.with(mActivity)
                    //必须-下载地址
                    .setApkUrl(downUrl)
                    //非必须-下载保存的文件的完整路径+name.apk
                    .setApkPath(Constants.apkPath(mActivity))
                    //非必须-下载回调
                    .setCallBack(downloadCallBack)
                    //开始下载
                    .startDownload();
        }
    }


    public void mInstall() {
        if (!PermissionUtils.isGrantSDCardReadPermission(mActivity)) {
            PermissionUtils.requestSDCardReadPermission(mActivity, 100);
        } else {
//            ToastUtils.ToastUtils("正在后台下载最新安装包",mActivity);
            updateDialog.setMessage1("1");
            InstallUtils.with(mActivity)
                    //必须-下载地址
                    .setApkUrl(downUrl)
                    //非必须-下载保存的文件的完整路径+name.apk
                    .setApkPath(Constants.apkPath(mActivity))
                    //非必须-下载回调
                    .setCallBack(downloadCallBack)
                    //开始下载
                    .startDownload();
        }
    }

    public void installApk(String path) {
        InstallUtils.installAPK(mActivity, path, new InstallUtils.InstallCallBack() {
            @Override
            public void onSuccess() {
                Log.e("onSuccess=","//");
            }

            @Override
            public void onFail(Exception e) {
                Log.e("onFail=","//");
//                tv_info.setText("安装失败:" + e.toString());
            }
        });
    }

    @SuppressLint("HandlerLeak")
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case LOADPRE:

                    int progress = (int) msg.obj;

                    Log.e("progress==",progress+"//");

                    updateDialog.setProgress(progress);
                    if (100 == progress) {
                        updateDialog.dismiss();

                    }
                    break;
            }
        }
    };
    private void initCallBack() {
        downloadCallBack = new InstallUtils.DownloadCallBack() {
            @Override
            public void onStart() {
                Log.e("onStart=","onStart///");
            }
            @Override
            public void onComplete(String path) {
                if (type==1)
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.GOOGLE_APK_ok,path));

                apkDownloadPath = path;
                InstallUtils.checkInstallPermission(mActivity, new InstallUtils.InstallPermissionCallBack() {
                    @Override
                    public void onGranted() {
                        Log.e("onGranted=",path+"///");
                        installApk(apkDownloadPath);
                    }

                    @Override
                    public void onDenied() {
                        Log.e("onDenied=",path+"///");
                        androidx.appcompat.app.AlertDialog alertDialog = new androidx.appcompat.app.AlertDialog.Builder(mActivity)
                                .setTitle(mActivity.getResources().getString(R.string.hint))
                                .setMessage(mActivity.getResources().getString(R.string.llowedtoinstall))
                                .setNegativeButton(mActivity.getResources().getString(R.string.cancel), null)
                                .setPositiveButton(mActivity.getResources().getString(R.string.setting), new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        InstallUtils.openInstallPermissionSetting(mActivity, new InstallUtils.InstallPermissionCallBack() {
                                            @Override
                                            public void onGranted() {
                                                installApk(apkDownloadPath);
                                            }

                                            @Override
                                            public void onDenied() {

                                            }
                                        });
                                    }
                                })
                                .create();
                        alertDialog.show();
                    }
                });
            }

            @Override
            public void onLoading(long total, long current) {
                Log.e("total==",total+"///");
                Log.e("current==",current+"///");

                Message msg = mHandler.obtainMessage();
                msg.what = LOADPRE;
                msg.obj = (int) (current * 100 / total);
                mHandler.sendMessage(msg);
            }

            @Override
            public void onFail(Exception e) {
                Log.e("e=",e.toString());
            }

            @Override
            public void cancle() {

            }
        };
    }

}
