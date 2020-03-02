package com.wanxiangdai.commonlibrary.base;

import android.os.Bundle;

/**
 * Created by lottery on 2018/3/3
 */

public abstract class LazyFragment extends BaseFragment {

//    protected boolean isViewInitiated; //控件是否初始化完成
//    protected boolean isVisibleToUser; //页面是否可见
//    protected boolean isDataInitiated; //数据是否加载


    private boolean isInit;                  //初始化是否完成
    protected boolean isLoad = false;


    protected LazyFragment(int resId) {
        super(resId);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
//        this.isVisibleToUser = isVisibleToUser;
//        prepareFetchData(false);

        //先判断映射关系再判断 是否可见
        initPrepare();
    }


    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
//        isViewInitiated = true;
//        prepareFetchData(false);

        isInit = true;
        initPrepare();
    }

//    public abstract void loadData();


//    protected void prepareFetchData(boolean forceUpdate) {
//        if (isVisibleToUser && isViewInitiated && (!isDataInitiated || forceUpdate)) {
//            loadData();
//            isDataInitiated = true;
//        }
//    }

    //同步锁
    private synchronized void initPrepare() {
        if (!isInit) {
            return;
        }
        if (getUserVisibleHint()) {
            onUserVisible();
            isLoad = true;
        } else {
            //不可见时执行操作
            if (isLoad) {
                onUserInvisible();
            }
        }
    }

    /**
     * 当视图初始化
     * 并且对用户可见
     * 时候去真正的加载数据
     */
    protected abstract void onUserVisible();

    /**
     * 页面不可见时操作
     */
    protected abstract void onUserInvisible();


    @Override
    public void onDestroyView() {
        super.onDestroyView();
        isInit = false;
        isLoad = false;
    }
}
