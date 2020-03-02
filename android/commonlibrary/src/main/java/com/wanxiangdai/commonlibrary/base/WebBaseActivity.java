//package com.wanxiangdai.commonlibrary.base;
//
//import android.content.Context;
//
//import com.just.agentweb.AgentWeb;
//import com.wanxiangdai.commonlibrary.loadsir.EmptyCallback;
//import com.wanxiangdai.commonlibrary.loadsir.ErrorCallback;
//import com.wanxiangdai.commonlibrary.loadsir.NetworkErrorCallback;
//import com.wanxiangdai.commonlibrary.mvp.BasePresenter;
//import com.wanxiangdai.commonlibrary.mvp.BaseView;
//
//
///**
// * Created by ykai on 2018/4/23.
// */
//
//public abstract class WebBaseActivity<T extends BasePresenter> extends BaseActivity implements BaseView {
//    /**
//     * 将代理类通用行为抽出来
//     */
//    protected T mPresenter;
//
//    public AgentWeb agentWeb;
//
//    public WebBaseActivity(int layoutResID) {
//        super(layoutResID);
//    }
//
//    public WebBaseActivity(int layoutResID, boolean needFinishApp) {
//        super(layoutResID, needFinishApp);
//    }
//
//    @Override
//    protected void onPause() {
//        if (agentWeb != null)
//            agentWeb.getWebLifeCycle().onPause();
//        super.onPause();
//    }
//
//    @Override
//    protected void onResume() {
//        getLifecycle().addObserver(mPresenter);
//        if (agentWeb != null)
//            agentWeb.getWebLifeCycle().onResume();
//        super.onResume();
//
//    }
//
//    @Override
//    protected void onDestroy() {
//        if (agentWeb != null)
//            agentWeb.getWebLifeCycle().onDestroy();
//        super.onDestroy();
//    }
//
//
//    @Override
//    public Context _getContext() {
//        return this;
//    }
//
//    @Override
//    public void showNetworkErrorView() {
//        mLoadService.showCallback(NetworkErrorCallback.class);
//    }
//
//    @Override
//    public void showEmptyView() {
//        mLoadService.showCallback(EmptyCallback.class);
//    }
//
//
//    @Override
//    public void showSuccessfulView() {
//        mLoadService.showSuccess();
//    }
//
//    @Override
//    public void showErrorView() {
//        mLoadService.showCallback(ErrorCallback.class);
//    }
//
//}
