package com.phoenix.lotterys.my.activity;

import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import android.view.View;

import com.flyco.tablayout.SlidingTabLayout;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.my.fragment.DepositFragment;
import com.phoenix.lotterys.my.fragment.DepositRecordFragment;
import com.phoenix.lotterys.my.fragment.FundsDetailsFragment;
import com.phoenix.lotterys.my.fragment.WithdrawalsFragment;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import java.util.ArrayList;

import butterknife.BindView;

/**
 * Created by Luke
 * on 2019/6/28
 */


public class DepositActivity extends BaseActivitys {

    @BindView(R2.id.tab_title)
    SlidingTabLayout tab_title;
    @BindView(R2.id.vp)
    ViewPager vp;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private  String[] mTitles ;

    private TabPagerAdapter mAdapter;
    private String page;
    @Override

    public void getIntentData() {
        Bundle bundle = getIntent().getExtras();
        page = bundle.getString("page");
    }
    public DepositActivity() {
        super(R.layout.activity_deposit,true,true);
    }

    @Override
    public void initView() {
        mApp = (Application) Application.getContextObject();
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        mTitles =getResources().getStringArray(R.array.titlerecord_list);
        mFragments.add(DepositFragment.getInstance(mTitles[0]));
        mFragments.add(WithdrawalsFragment.getInstance(mTitles[1]));
        mFragments.add(DepositRecordFragment.getInstance(mTitles[2]));
        mFragments.add(DepositRecordFragment.getInstance(mTitles[3]));
        mFragments.add(FundsDetailsFragment.getInstance(mTitles[4]));

        mAdapter = new TabPagerAdapter(getSupportFragmentManager(), mFragments, mTitles);
        vp.setAdapter(mAdapter);
        tab_title.setViewPager(vp, mTitles);
        if (page == null) {
            vp.setCurrentItem(0);
            titlebar.setText(mTitles[0]);
        } else if ("1".equals(page)) {
            vp.setCurrentItem(1);
            titlebar.setText(mTitles[1]);
        } else if ("2".equals(page)) {
            vp.setCurrentItem(2);
        } else if ("3".equals(page)) {
            vp.setCurrentItem(3);
        }
        setmTitle();

        Uiutils.setBaColor(this,titlebar, false, null);

        Uiutils.setBarStye0(titlebar,this);
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


    public void setTab(int i){
        tab_title.setCurrentTab(i);
    }

    Application mApp;
    @Override
    protected void onDestroy() {
//        Intent intent = new Intent(mApp, MyIntentService.class);
//        intent.putExtra("type", "3000");
//        startService(intent);
        super.onDestroy();
    }


    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(this,titlebar, false, null);
                break;
        }
    }
}
