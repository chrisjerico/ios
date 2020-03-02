package com.phoenix.lotterys.my.fragment;

import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import butterknife.BindView;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/20 23:12
 */
public class InTheBuildingFrag extends BaseFragment {


    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;

    public InTheBuildingFrag() {
        super(R.layout.in_the_building_frag, true, true);
    }


    @Override
    public void onResume() {
        super.onResume();
        titlebar.setText(getArguments().getString("title"));
    }

    @Override
    public void initView(View view) {
        titlebar.setText(getArguments().getString("title"));
//        titlebar.setLeft(0);
//        titlebar.setRight(0);

        Uiutils.setBarStye(titlebar, getActivity());
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.SETTITLE0:
                if (!StringUtils.isEmpty((String) even.getData()))
                titlebar.setText((String) even.getData());
                break;
        }
    }
}
