package com.wanxiangdai.commonlibrary.base;

import android.content.Context;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.wanxiangdai.commonlibrary.loadsir.EmptyCallback;
import com.wanxiangdai.commonlibrary.loadsir.ErrorCallback;
import com.wanxiangdai.commonlibrary.loadsir.NetworkErrorCallback;
import com.wanxiangdai.commonlibrary.mvp.BasePresenter;
import com.wanxiangdai.commonlibrary.mvp.BaseView;


/**
 * Created by xiongchang on 17/7/19.
 */

public abstract class AppLazyBaseFragment<T extends BasePresenter> extends LazyFragment implements BaseView {
    /**
     * 将代理类通用行为抽出来
     */
    protected T mPresenter;

    public AppLazyBaseFragment(int resId) {
        super(resId);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = super.onCreateView(inflater, container, savedInstanceState);
        return view;
    }


//    @RequiresApi(api = Build.VERSION_CODES.GINGERBREAD)
//    public void changeViewAplha(final View view, RecyclerView recyclerView, final int judgeHight){
//        view.getBackground().setAlpha(0);
//
//        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
//            @Override
//            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
//            }
//
//            @Override
//            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
//                int scrollY = recyclerView.computeVerticalScrollOffset();
//                //改变透明度
//                changeAlpha(view,judgeHight,scrollY);
//            }
//        });
//    }

//    private void changeAlpha(View view, int judgeHight, int scrollY) {
//        //快速下拉会引起scollY<0
//        if(scrollY<0){
//            view.getBackground().setAlpha(0);
//            return;
//        }
//        int bannerHeight = MeasureUtil.dip2px(getActivity(),judgeHight);
//        float radio = Math.min(1, scrollY/(bannerHeight - view.getHeight()*1f));
//        view.getBackground().setAlpha((int)(radio*0xFF));
//    }

    @Override
    public void onResume() {
        super.onResume();
//        MobclickAgent.onResume(getActivity());
//        if(mPresenter != null){
//            mPresenter.onResume();
//        }
        getLifecycle().addObserver(mPresenter);
    }

    @Override
    public void onPause() {
        super.onPause();
//        MobclickAgent.onPause(getActivity());
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
//        if(mPresenter != null){
//            mPresenter.onDestroy();
//        }
    }

//    public ProgressDialog showProgressDialog(String message) {
//        ProgressDialog progressDialog = DialogUtil.getProgressDialog(getActivity(),message);
//        progressDialog.show();
//        return progressDialog;
//    }
//
//    public void hideProgressDialog(ProgressDialog progressDialog) {
//        if(progressDialog!=null){
//            progressDialog.dismiss();
//        }
//    }

    @Override
    public Context _getContext() {
        return getContext();
    }

    @Override
    public void showEmptyView() {
        mLoadService.showCallback(EmptyCallback.class);
    }


    @Override
    public void showNetworkErrorView() {
        mLoadService.showCallback(NetworkErrorCallback.class);
    }

    @Override
    public void showSuccessfulView() {
        mLoadService.showSuccess();
    }

    @Override
    public void showErrorView() {
        mLoadService.showCallback(ErrorCallback.class);
    }
}
