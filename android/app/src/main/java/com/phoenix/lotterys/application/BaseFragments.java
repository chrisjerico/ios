package com.phoenix.lotterys.application;

import android.annotation.SuppressLint;

import com.lzy.okgo.OkGo;
import com.wanxiangdai.commonlibrary.base.BaseFragment;

/**
 * Greated by Luke
 * on 2019/8/27
 */
@SuppressLint("ValidFragment")
public class BaseFragments extends BaseFragment {
    
    protected BaseFragments(int resId) {
        super(resId);
    }
    protected BaseFragments(int resId, boolean isOpenEvenBus) {
        super(resId);
        super.isOpenEvenBus = isOpenEvenBus;
    }
    protected BaseFragments(int resId, boolean isButterKnife,boolean isOpenEvenBus) {
        super(resId);
        super.isButterKnife = isButterKnife;
        super.isOpenEvenBus = isOpenEvenBus;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        OkGo.getInstance().cancelTag(getContext());
        OkGo.getInstance().cancelTag(getActivity());
        OkGo.getInstance().cancelTag(this);
    }
}
