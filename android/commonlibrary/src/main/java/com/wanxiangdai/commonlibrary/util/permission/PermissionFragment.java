package com.wanxiangdai.commonlibrary.util.permission;

import android.app.Fragment;
import android.content.pm.PackageManager;
import android.os.Build;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/4 14:16
 */
public class PermissionFragment extends Fragment {
    private static final int PERMISSIONS_REQUEST_BACK =142 ;
    private PermissionUtil.PermissionsListener permissionsListener;

    @RequiresApi(api = Build.VERSION_CODES.M)
    public void fetchPermisson(String[] permissonList, final PermissionUtil.PermissionsListener permissionsListener){
        this.permissionsListener=permissionsListener;
        List<String> mPermissionList = new ArrayList<>();
        for (int i=0;i<permissonList.length;i++){
            if ((ContextCompat.checkSelfPermission(getContext(), permissonList[i]) != PackageManager.PERMISSION_GRANTED)
                    || shouldShowRequestPermissionRationale(permissonList[i])){
                mPermissionList.add(permissonList[i]);
            }
        }

        if (mPermissionList.size()>0) {
            requestPermissions(permissonList, PERMISSIONS_REQUEST_BACK);
        }else {
            permissionsListener.permissonApplied();
        }
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        permissionsListener.accept(requestCode, permissions, grantResults);
    }
}
