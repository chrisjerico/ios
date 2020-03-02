package com.wanxiangdai.commonlibrary.loadsir;

import android.content.Context;
import android.view.View;

import com.kingja.loadsir.callback.Callback;
import com.wanxiangdai.commonlibrary.R;


public class LoadingCallback extends Callback {

    @Override
    protected int onCreateView() {
        return R.layout.inflate_loading_view;
    }

    @Override
    protected boolean onReloadEvent(Context context, View view) {
        return true;
    }

//    @Override
//    protected boolean onRetry(Context context, View view) {
//        return true;
//    }
}
