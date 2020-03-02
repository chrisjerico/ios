package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.view.View;

import com.flyco.tablayout.SegmentTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.coupons.CouponsFragment;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import java.util.ArrayList;

import butterknife.BindView;

/**
 * Greated by Luke
 * on 2019/10/4
 */

@SuppressLint("ValidFragment")
public class BlackLastReadFrament extends BaseFragments{
    @BindView(R2.id.tab_seg)
    SegmentTabLayout tabSeg;
    @BindView(R2.id.vp)
    ViewPager vp;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private  String[] mTitles ;
    boolean isHide = false;
    private TabPagerAdapter mAdapter;
    private String page;
    HomeGame gametype;
//    @Override
//    public void getIntentData() {
//        Bundle bundle = getIntent().getExtras();
//        page = bundle.getString("page");
//    }
HomeGame.DataBean.IconsBean game =new HomeGame.DataBean.IconsBean();
    @SuppressLint("ValidFragment")
    public BlackLastReadFrament(boolean isHide) {
        super(R.layout.lastread_frament,true,true);
        this.isHide = isHide;
    }
    public static BlackLastReadFrament getInstance(boolean isHide) {
        return new BlackLastReadFrament(isHide);
    }
    @Override
    public void initView(View view) {
        titlebar.setText("最近浏览");
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                finish();
            }
        });
        HomeGame.DataBean.IconsBean game ;

        game  = Constants.getGame();
        mTitles =getResources().getStringArray(R.array.titlerecord_list);

        mFragments.add(new GamesCustomFragment(game, -1));
        mFragments.add(CouponsFragment.getInstance(true,true));
        initVp();

        if(isHide)
            titlebar.setIvBackHide(View.GONE);

        Uiutils.setBaColor(getContext(),titlebar, false, null);
    }
    public void setmTitle(){
        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int position) {
                titlebar.setText(mTitles[position]);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
    }



    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(),titlebar, false, null);
                break;
        }
    }
    private void initVp() {
        vp.setAdapter(new TabPagerAdapter(getChildFragmentManager(),mFragments));
         String[] mTitles_3 = {"最近浏览", "最近活动"};
        tabSeg.setTabData(mTitles_3);
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

}
