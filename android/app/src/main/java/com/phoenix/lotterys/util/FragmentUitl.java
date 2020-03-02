package com.phoenix.lotterys.util;

import android.content.Context;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

import java.util.ArrayList;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/8 15:31
 */
public class FragmentUitl  {

    private Context context;
    private List<Fragment> listFra=new ArrayList<>();

    private FragmentManager fm;
    private FragmentTransaction ft;

    public FragmentUitl(Context context) {
        this.context = context;
    }

    public FragmentUitl(Context context,List<Fragment> listFra) {
        this.listFra = listFra;
        this.context = context;
    }

    public FragmentUitl(Context context,List<Fragment> listFra,FragmentManager fm) {
        this.listFra = listFra;
        this.context = context;
        this.fm = fm;
    }

    public List<Fragment> getListFra() {
        return listFra;
    }

    public void setListFra(List<Fragment> listFra) {
        this.listFra = listFra;
    }

    public void setFt(FragmentTransaction ft) {
        this.ft = ft;
    }

    public void setFrag() {
        if (null==fm)
            fm = ((FragmentActivity)context).getSupportFragmentManager();

        ft = fm.beginTransaction();

        if (listFra.size()>0){
            for (Fragment fragment :listFra){
                ft.add(R.id.framnent_lin, fragment);
            }
        }
        showPostion(0);
    }

    public void showPostion(int index){
        if (listFra.size()>0 && listFra.size()>index) {
            hideFragment(listFra);
            if (listFra.get(index) != null) {
                ft.show(listFra.get(index));
            }
            if (null!=ft)
            ft.commit();
        }
    }

    public void hideFragment(List<Fragment> list) {
        if (list.size()>0){
            for (Fragment fragment :list){
                ft.hide(fragment);
            }
        }
    }
}
