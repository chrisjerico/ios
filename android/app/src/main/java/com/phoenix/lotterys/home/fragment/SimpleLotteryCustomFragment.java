package com.phoenix.lotterys.home.fragment;


import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.view.View;
import android.widget.LinearLayout;

import com.flyco.tablayout.SlidingTabLayout;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.adapter.SimpleLotteryticketCustomAdapter;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.view.SignViewPager;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * 彩票.  简约模板彩票系列
 */
@SuppressLint("ValidFragment")
public class SimpleLotteryCustomFragment extends BaseFragment {

    SimpleLotteryticketCustomAdapter lotteryticketAdapter;
    SignViewPager signViewPager;
    SharedPreferences sp;
    HomeGame.DataBean.IconsBean game;
    int pos;   //-1是浏览记录
    @BindView(R2.id.tab_title)
    SlidingTabLayout tab_title;
    @BindView(R2.id.vp)
    ViewPager vp;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private String[] mTitles;
    private TabPagerAdapter mAdapter;

    public void setSignViewPager(SignViewPager signViewPager) {
        this.signViewPager = signViewPager;

    }

    public SimpleLotteryCustomFragment(HomeGame.DataBean.IconsBean game, int pos) {
        super(R.layout.fragment_lottery_series, true, true);
        this.game = game;
        this.pos = pos;
    }

    @Override
    public void initView(View view) {
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        if (signViewPager != null) {
            signViewPager.setObjectForPosition(view, pos);
        }
        List<HomeGame.DataBean.IconsBean.ListBean> icons = new ArrayList<>();
        for (int i = 0; i < game.getList().size(); i++) {
            if (game.getList().get(i).getSubType()!=null&&game.getList().get(i).getSubType().size()!=0) {
                icons.add(game.getList().get(i));
            }
        }
        if(icons.size()==0){
            return;
        }
        mTitles = new String[icons.size()];
        for(int t = 0;t<mTitles.length;t++){
            mTitles[t]= icons.get(t).getName();
            mFragments.add(SimpleLotteryFrament.getInstance(icons.get(t)));
        }
        mAdapter = new TabPagerAdapter(getChildFragmentManager(), mFragments, mTitles);
        vp.setAdapter(mAdapter);
        tab_title.setViewPager(vp, mTitles);
        setListener(icons);
        setHeight(icons,0);
    }

    public void setListener(List<HomeGame.DataBean.IconsBean.ListBean> icons) {
        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int position) {
                setHeight(icons,position);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
    }

    private void setHeight(List<HomeGame.DataBean.IconsBean.ListBean> icons, int position) {
        int count = icons.get(position).getSubType().size();
        int c = count<=4?1:count%4>0?count/4+1:count/4;
        int mHeight =  MeasureUtil.dip2px(getContext(),c * MeasureUtil.dip2px(getContext(), 50));
        LinearLayout.LayoutParams para1;
        para1 = (LinearLayout.LayoutParams) vp.getLayoutParams();
        para1.height = mHeight;
        vp.setLayoutParams(para1);
    }

}
