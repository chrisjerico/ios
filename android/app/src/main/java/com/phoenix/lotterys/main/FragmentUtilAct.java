package com.phoenix.lotterys.main;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import android.util.Log;

import com.lzy.okgo.OkGo;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.UpdataUtil;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

/**
 * 文件描述: 共用启用类
 * 创建者: IAN
 * 创建时间: 2019/7/2 14:33
 */
public class FragmentUtilAct extends BaseActivity {

    private boolean aBoolean;

    public FragmentUtilAct() {
        super(R.layout.fragment_util_act, true, true,type,1);
    }

    private static BaseFragment tClass;
    private static boolean type;

    private static Class<Fragment> aClass;

    public static void startAct(Context context, BaseFragment tClass) {
        FragmentUtilAct.tClass = tClass;
        context.startActivity(new Intent(context, FragmentUtilAct.class));
    }
    public static void startAct(Context context, BaseFragment tClass,boolean isall,int id) {
        FragmentUtilAct.tClass = tClass;
        FragmentUtilAct.type = true;
        context.startActivity(new Intent(context, FragmentUtilAct.class));
    }

    public static void startAct(Context context, BaseFragment tClass, Bundle bundle) {
        FragmentUtilAct.tClass = tClass;
        tClass.setArguments(bundle);
        context.startActivity(new Intent(context, FragmentUtilAct.class));
    }

    public static void startAct(Context context, Class<Fragment> aClass) {
        FragmentUtilAct.aClass = aClass;
        context.startActivity(new Intent(context, FragmentUtilAct.class));
    }

    @Override
    public void initView() {
        FragmentManager fm = getSupportFragmentManager();
        if (FragmentUtilAct.tClass != null) {
            fm.beginTransaction().add(R.id.fragment_lin, FragmentUtilAct.tClass)
                    .commit();
        }
    }

    @Override
    protected void onDestroy() {
        FragmentUtilAct.tClass = null;
        FragmentUtilAct.type = false;
        OkGo.getInstance().cancelTag(this);
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (null != tClass)
            tClass.onResume();

    }

    //下载apk
    private UpdataUtil updata;

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        Log.e("onRequestPermis", "/");

        if (requestCode == 100) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                //先判断是否有安装未知来源应用的权限
                boolean haveInstallPermission;
                haveInstallPermission = getPackageManager().canRequestPackageInstalls();
                if (haveInstallPermission) {
//                if (isok){

                    updata.installApk(url);
                }
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    private String url;

    public void setDown(String url) {
        updata = new UpdataUtil(this, url + "", 1);
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.GOOGLE_APK_ok:
                url = (String) even.getData();
                break;
        }
    }

    @Override
    public void onBackPressed() {
        if (isFrament) {
            ConfigBean config = (ConfigBean) ShareUtils.getObject(FragmentUtilAct.this, SPConstants.CONFIGBEAN, ConfigBean.class);
            if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
                if (config.getData().getMobileTemplateCategory().equals("5")) {
                    startActivity(new Intent(FragmentUtilAct.this, BlackMainActivity.class));
                }else {
                    startActivity(new Intent(FragmentUtilAct.this, MainActivity.class));
                }
            }else {
                startActivity(new Intent(FragmentUtilAct.this, MainActivity.class));
            }
        } else {
            super.onBackPressed();
        }
    }

    boolean isFrament = false;
    public void isFramentType(boolean b) {
        isFrament = b;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1003) {
            try {
                if (tClass != null) {
                    tClass.onActivityResult(requestCode, resultCode, data);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
    }
}
