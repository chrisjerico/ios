package com.phoenix.lotterys.main;

import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.ShareUtils;
import com.wanxiangdai.commonlibrary.base.BaseFragment;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2020/01/08 10:21
 * @description :
 */
public class SlidingRightParentFragment extends BaseFragment {
    public SlidingRightParentFragment() {
        super(R.layout.fragment_sliding_right_parent);
    }

    @Override
    public void initView(View view) {
//        if ("6".equals(ShareUtils.getString(getContext(), "themetyp", ""))) {
//            getChildFragmentManager().beginTransaction()
//                    .add(R.id.fl_parent, new SlidingRightJinShaFragment())
//                    .commit();
//        } else {
            getChildFragmentManager().beginTransaction()
                    .add(R.id.fl_parent, new SlidingRight_Fragment())
                    .commit();
//        }
    }
}
