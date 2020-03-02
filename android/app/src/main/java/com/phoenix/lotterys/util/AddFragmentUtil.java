package com.phoenix.lotterys.util;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/3 14:52
 */
public class AddFragmentUtil {

//    public static void initialization(FragmentManager fm, List<Fragment> list  ,int layID) {
//        FragmentTransaction ft = fm.beginTransaction();
//        if (list.size()>0){
//            for (Fragment fragment :list){
//                ft.add(layID, fragment);
//            }
//        }
//        showPostion(fm,0,list);
//    }

    public static void showPostion( FragmentManager fm , int index , List<Fragment> list ){
        FragmentTransaction ft = fm.beginTransaction();
        if (list.size()>0 && list.size()>index) {
            hideFragment(list,fm,index);
        }
    }

    public static void hideFragment(List<Fragment> list, FragmentManager fm,int index) {
        FragmentTransaction ft = fm.beginTransaction();
        if (list.size()>0){
            for (Fragment fragment :list){
                ft.hide(fragment);
            }

            if (list.get(index) != null) {
                ft.show(list.get(index));
            }
            ft.commit();
        }
    }
}
