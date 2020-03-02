
package com.wanxiangdai.commonlibrary.mvp;

import android.content.Context;

public interface BaseView {
    Context _getContext();

    void showNetworkErrorView();

    void showEmptyView();

    void showSuccessfulView();

    void showErrorView();
}
