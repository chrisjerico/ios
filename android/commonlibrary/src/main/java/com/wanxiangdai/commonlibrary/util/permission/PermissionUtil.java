package com.wanxiangdai.commonlibrary.util.permission;

import android.app.Activity;
import android.app.FragmentManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;
import androidx.core.content.ContextCompat;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/4 14:17
 */
public class PermissionUtil {
    private PermissionFragment permissionFragment;
    private final String TAG = "permissionFragment";

    public PermissionUtil(Activity activity) {
        permissionFragment = getRxPermissionsFragment(activity);
    }

    public PermissionUtil(Fragment fragment) {
        permissionFragment = getRxPermissionsFragment(fragment.getActivity());
    }


    //一次性请求多个
    @RequiresApi(api = Build.VERSION_CODES.M)
    public void fetchPermisson(String[] permissonList, final PermissionsListener permissionsListener) {
        permissionFragment.fetchPermisson(permissonList, permissionsListener);
    }


    private PermissionFragment getRxPermissionsFragment(Activity activity) {
        PermissionFragment rxPermissionsFragment = findRxPermissionsFragment(activity);
        boolean isNewInstance = rxPermissionsFragment == null;
        if (isNewInstance) {
            rxPermissionsFragment = new PermissionFragment();
            FragmentManager fragmentManager = activity.getFragmentManager();
            fragmentManager
                    .beginTransaction()
                    .add(rxPermissionsFragment, TAG)
                    .commitAllowingStateLoss();
            fragmentManager.executePendingTransactions();
        }
        return rxPermissionsFragment;
    }

    private PermissionFragment findRxPermissionsFragment(Activity activity) {
        return (PermissionFragment) activity.getFragmentManager().findFragmentByTag(TAG);
    }

    public interface PermissionsListener {
        //申请权限回调接口
        void accept(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults);

        //权限申请全部通过后的回调接口
        void permissonApplied();
    }


//    /**
//     * 读写权限 自己可以添加需要判断的权限
//     */
//    public static String[]permissionsREAD={
//            Manifest.permission.READ_EXTERNAL_STORAGE,
//            Manifest.permission.WRITE_EXTERNAL_STORAGE };

//    /**
//     * 判断权限集合
//     * permissions 权限数组
//     * return true-表示没有改权限 false-表示权限已开启
//     */
    public static boolean lacksPermissions(Context mContexts, String[] permissionsREAD) {
        for (String permission : permissionsREAD) {
            if (lacksPermission(mContexts,permission)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 判断是否缺少权限
     */
    public static boolean lacksPermission(Context mContexts, String permission) {
        return ContextCompat.checkSelfPermission(mContexts, permission) ==
                PackageManager.PERMISSION_DENIED;
    }
}







