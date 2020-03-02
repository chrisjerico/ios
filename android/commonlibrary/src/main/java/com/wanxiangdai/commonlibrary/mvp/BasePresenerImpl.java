package com.wanxiangdai.commonlibrary.mvp;

import androidx.lifecycle.LifecycleOwner;

import org.jetbrains.annotations.NotNull;

import rx.Subscription;

/**
 * Created by xiongchang on 17/7/8.
 */

public class BasePresenerImpl<T extends BaseView> implements BasePresenter {

    protected Subscription mSubscription;
    protected T mView;

    @Override
    public void onResume(@NotNull LifecycleOwner owner) {
//        Log.e("tag", "BasePresenter.onResume" + this.getClass().toString());
    }

    @Override
    public void onDestroy(@NotNull LifecycleOwner owner) {
//        Log.e("tag", "BasePresenter.onDestroy" + this.getClass().toString());
        if (mSubscription != null && !mSubscription.isUnsubscribed()) {
            mSubscription.unsubscribe();
        }
        mView = null;
    }
}
