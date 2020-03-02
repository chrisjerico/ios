package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.fragment.app.Fragment;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.FragmentUitl;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:活动彩金
 * 创建者: IAN
 * 创建时间: 2019/9/5 13:44
 */
public class ActivityFiledFragB extends BaseFragment {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.latest_long_dragon_tex)
    TextView latestLongDragonTex;
    @BindView(R2.id.my_bet)
    TextView myBet;
    @BindView(R2.id.lin_tex)
    TextView linTex;
    @BindView(R2.id.framnent_lin)
    LinearLayout framnentLin;
    private List<Fragment> listFrag = new ArrayList<>();


    public ActivityFiledFragB() {
        super(R.layout.activity_filed_frag_b, true, true);
    }

    private FragmentUitl fragmentUitl;
    private int offset = 0;

    @Override
    public void initView(View view) {
        Uiutils.setBarStye(titlebar, getActivity());
        titlebar.setText("申请彩金");

        DisplayMetrics dm = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
        int screenW = dm.widthPixels; // 获取分辨率宽度
        offset = (screenW / 2 - lineWidth) / 2;  // 计算偏移值
        lineWidth = screenW / 2;
        linTex.setLayoutParams(new LinearLayout.LayoutParams(lineWidth, MeasureUtil.dip2px(
                getContext(), 2
        )));

        ApplyMosaicGoldFragB applyMosaicGoldFrag = new ApplyMosaicGoldFragB();
        ApplyMosaicGoldFragB applyMosaicGoldFrag1 = new ApplyMosaicGoldFragB();
        Bundle bundle = new Bundle();
        Bundle bundle1 = new Bundle();
        bundle.putInt("type", 1);
        applyMosaicGoldFrag.setArguments(bundle);
        listFrag.add(applyMosaicGoldFrag);
        bundle1.putInt("type", 2);
        applyMosaicGoldFrag1.setArguments(bundle1);
        listFrag.add(applyMosaicGoldFrag1);
        fragmentUitl = new FragmentUitl(getActivity(), listFrag, getChildFragmentManager());
        fragmentUitl.setFrag();

        latestLongDragonTex.setSelected(true);
        myBet.setSelected(false);
    }

    private int lineWidth;

    @OnClick({R.id.latest_long_dragon_tex, R.id.my_bet})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.latest_long_dragon_tex:
                latestLongDragonTex.setSelected(true);
                myBet.setSelected(false);
                Animation animation = new TranslateAnimation(lineWidth, 0, 0, 0);
                animation.setFillAfter(true);
                animation.setDuration(500);
                // 给图片添加动画
                linTex.startAnimation(animation);

                fragmentUitl.setFt(getActivity().getSupportFragmentManager().beginTransaction());
                fragmentUitl.showPostion(0);
                break;
            case R.id.my_bet:
                myBet.setSelected(true);
                latestLongDragonTex.setSelected(false);
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_SINGLE_INJECTION));
                Animation animation0 = new TranslateAnimation(0, lineWidth, 0, 0);
                animation0.setFillAfter(true);
                animation0.setDuration(500);
                // 给图片添加动画
                linTex.startAnimation(animation0);
                fragmentUitl.setFt(getActivity().getSupportFragmentManager().beginTransaction());
                fragmentUitl.showPostion(1);
                break;
        }

        EvenBusUtils.setEvenBus(new Even(EvenBusCode.APPLY_MOSAIC_GOLD_RESHRE));
    }
}
