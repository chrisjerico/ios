package com.wanxiangdai.commonlibrary.loadsir;

import com.kingja.loadsir.callback.Callback;
import com.wanxiangdai.commonlibrary.R;


public class EmptyCallback extends Callback {

    @Override
    protected int onCreateView() {
        return R.layout.inflate_empty_view;
    }

//    @Override
//    protected boolean onReloadEvent(Context context, View view) {
//        return true;
//    }

}
