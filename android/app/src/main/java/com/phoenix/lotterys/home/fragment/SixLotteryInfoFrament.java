package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.flyco.tablayout.SegmentTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.activity.PostMessageActivity;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.RoundShadowLayout;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/10/4
 */

@SuppressLint("ValidFragment")
public class SixLotteryInfoFrament extends BaseFragments {
    @BindView(R2.id.rs_postmsg)
    RoundShadowLayout rsPostmsg;
    @BindView(R2.id.tab_seg)
    SegmentTabLayout tabSeg;
    @BindView(R2.id.vp)
    ViewPager vp;
    @BindView(R2.id.tv_back)
    TextView tvBack;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.iv_write)
    ImageView ivWrite;
    @BindView(R2.id.iv_search1)
    ImageView ivSearch1;
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;

    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private String[] mTitles;
    boolean isHide = false;
    private TabPagerAdapter mAdapter;
    String title = "";
    private String page;
    private String alias;

    @SuppressLint("ValidFragment")
    public SixLotteryInfoFrament(boolean isHide, String title, String alias) {
        super(R.layout.sixlottery_frament, true, true);
        this.isHide = isHide;
        this.title = title;
        this.alias = alias;
    }

    @Override
    public void initView(View view) {
        Uiutils.setBarStye0(titlebar,getContext());
        tvTitle.setText(title != null ? title : "");
        mTitles = getResources().getStringArray(R.array.sixThemeBetter);
        mFragments.add(SixThemeBetterFragment.getInstance(mTitles[0],alias));
        mFragments.add(SixThemeBetterFragment.getInstance(mTitles[1],alias));
        mFragments.add(SixThemeBetterFragment.getInstance(mTitles[2],alias));
        initVp();

        Uiutils.setBarStye0(titlebar,getActivity());
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
//                Uiutils.setBaColor(getContext(),titlebar, false, null);
                Uiutils.setBarStye0(titlebar,getActivity());
                break;
        }
    }

    private void initVp() {
        vp.setAdapter(new TabPagerAdapter(getChildFragmentManager(), mFragments));
//         String[] mTitles = {"综合", "精华帖", "最新"};
        tabSeg.setTabData(mTitles);
        tabSeg.setOnTabSelectListener(new OnTabSelectListener() {
            @Override
            public void onTabSelect(int position) {
                vp.setCurrentItem(position);
            }

            @Override
            public void onTabReselect(int position) {
            }
        });

        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                tabSeg.setCurrentTab(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        vp.setCurrentItem(0);
    }


    @OnClick({R.id.tv_back, R.id.iv_write, R.id.iv_search1,R.id.rs_postmsg})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_back:
                getActivity().finish();
                break;
            case R.id.iv_write:
//                Intent intent = new Intent(getContext(), PostMessageActivity.class);
//                startActivity(intent);
                jumpMessage();
                break;
            case R.id.iv_search1:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                FragmentUtilAct.startAct(getContext(),  SixThemeBetterFragment.getInstance("搜索帖子",alias));
                break;
            case R.id.rs_postmsg:
                jumpMessage();
                break;
        }
    }

    private void jumpMessage() {
        if (ButtonUtils.isFastDoubleClick())
            return;
        String token = SPConstants.checkLoginInfo(getContext());
        if(TextUtils.isEmpty(token)){
            return;
        }
                if (Uiutils.isTourist(getContext()))
                    return;
        Bundle build = new Bundle();
        build.putSerializable("alias", alias);
        IntentUtils.getInstence().intent(getActivity(), PostMessageActivity.class, build);
    }

}
