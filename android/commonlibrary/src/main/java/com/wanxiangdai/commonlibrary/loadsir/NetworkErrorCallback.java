package com.wanxiangdai.commonlibrary.loadsir;


import com.kingja.loadsir.callback.Callback;
import com.wanxiangdai.commonlibrary.R;


public class NetworkErrorCallback extends Callback {
    @Override
    protected int onCreateView() {
        return R.layout.inflate_network_error_view;
    }
}
