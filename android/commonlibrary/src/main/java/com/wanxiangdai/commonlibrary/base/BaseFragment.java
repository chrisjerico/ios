package com.wanxiangdai.commonlibrary.base;

import android.os.Bundle;
import androidx.annotation.Nullable;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.kingja.loadsir.core.LoadService;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.ViewUtil;
import com.wanxiangdai.commonlibrary.view.TitleBar;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import butterknife.ButterKnife;
import butterknife.Unbinder;
import rx.Subscription;

/**
 * Created by lottery on 2018/3/3
 */

public abstract class BaseFragment extends BaseKtFragment {
    protected int resId;
    protected TitleBar mTitle;
    //当前fragment是否可见
    protected boolean isVisible = false;
    //RxBus
    protected Subscription rxBusSubscription;

    protected LoadService mLoadService;

    private Unbinder unbinder;
    /**
     * 是否开启EvenBus
     */
    public boolean isOpenEvenBus;
    /**
     * 是否开启ButterKnife
     */
    public boolean isButterKnife;

    protected BaseFragment(int resId) {
        this.resId = resId;
    }
    protected BaseFragment(int resId,boolean isOpenEvenBus) {
        this.resId = resId;
        this.isOpenEvenBus = isOpenEvenBus;
    }

    protected BaseFragment(int resId,boolean isButterKnife,boolean isOpenEvenBus) {
        this.resId = resId;
        this.isButterKnife = isButterKnife;
        this.isOpenEvenBus = isOpenEvenBus;
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(resId, container, false);

//        if (isButterKnife){
            unbinder = ButterKnife.bind(this,view);
//        }

        if (isOpenEvenBus){
            if(!EventBus.getDefault().isRegistered(this)){
                EventBus.getDefault().register(this);
            }
        }

        initLoadSir(view);
        initView(view);
        return getFragmentReturnLayout(view);
    }

    //如需要替换为loadSir  则重写该方法
    public View getFragmentReturnLayout(View view) {
        return view;
    }

    //界面是否需要loadSir 需要则重写
    public void initLoadSir(View view) {

    }


    /**
     * 初始化页面布局
     * @param view
     */
    public void  initView(View view) {

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        //取消RxBus订阅
        if(rxBusSubscription != null){
            rxBusSubscription.unsubscribe();
            rxBusSubscription=null;
        }

//        if (isButterKnife && null!=unbinder){
            unbinder.unbind();
//        }

        if (isOpenEvenBus){
            if (EventBus.getDefault().isRegistered(this))
                EventBus.getDefault().unregister(this);
        }

        ViewUtil.fixInputMethodManagerLeak(getContext());
    }

    /**
     * initTitle:初始化标题. <br/>
     *
     * @param id 标题资源文件id
     */
    public void initTitle(int id, View view, int bgcolor, int titlecolor) {
        if (mTitle == null) {
            mTitle = new TitleBar(getActivity(), view, id,bgcolor,titlecolor);
        }
    }

    /**
     * initTitle:初始化标题. <br/>
     *
     * @param name 标题文本
     */
    public void initTitle(String name, View view, int bgcolor, int titlecolor) {
        if (mTitle == null) {
            mTitle = new TitleBar(getActivity(), view, name,bgcolor,titlecolor);
        }
    }
    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
        if (hidden) {
            isVisible = false;
            this.onTransformPause();
        } else {
            isVisible = true;
            this.onTransformResume();
        }
    }
    /**
     * fragment隐藏时做的事情
     */
    protected void onTransformPause() {

    }

    /**
     * fragment显示时做的事情
     */
    protected void onTransformResume() {

    }

    /**
     * 公共接收msg
     * @param even msg 数据
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onGetMessage(Even even) {
        getEvenMsg(even);
    }

    /**
     * 统一处理
     * @param even
     */
    public void getEvenMsg(Even even){
    }


}
