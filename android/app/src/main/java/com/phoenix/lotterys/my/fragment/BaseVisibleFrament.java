package com.phoenix.lotterys.my.fragment;

import android.content.Intent;
import androidx.fragment.app.Fragment;
import android.view.View;

import com.phoenix.lotterys.application.BaseFragments;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/28
 */
public abstract class BaseVisibleFrament extends BaseFragments {
    public static final String TAG = BaseVisibleFrament.class.getSimpleName();
    private boolean hasLoaded = false;

    private boolean isCreated = false;

    private boolean isVisibleToUser = false;
    private View view;

    protected BaseVisibleFrament(int resId) {
        super(resId);
    }

    @Override
    public void initView(View view) {
        isCreated = true;
        this.view = view;
        lazyLoad(this.view);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        this.isVisible = isVisibleToUser;
        super.setUserVisibleHint(isVisibleToUser);
        lazyLoad(view);
    }

    private void lazyLoad(View view) {
        if (!isVisibleToUser || hasLoaded || !isCreated) {
            return;
        }
        lazyInitView(view);
        hasLoaded = true;
    }
    public abstract void lazyInitView(View view);

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        isCreated = false;
        hasLoaded = false;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (getChildFragmentManager().getFragments() != null && getChildFragmentManager().getFragments().size() > 0){
            List<Fragment> fragments = getChildFragmentManager().getFragments();
            for (Fragment mFragment: fragments) {
                mFragment.onActivityResult(requestCode, resultCode, data);
            }
        }
    }

}
