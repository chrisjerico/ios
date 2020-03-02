package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.my.fragment.DepositRecordFragment;
import com.phoenix.lotterys.my.fragment.FundsDetailsFragment;
import com.phoenix.lotterys.my.fragment.WithdrawalsFragment;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/10/4
 */
//资金管理
@SuppressLint("ValidFragment")
public class FundFrament extends BaseFragments {
    @BindView(R2.id.tv_finance)
    TextView tvFinance;
    @BindView(R2.id.tv_draw)
    TextView tvDraw;
    @BindView(R2.id.tv_finance_record)
    TextView tvFinanceRecord;
    @BindView(R2.id.tv_draw_record)
    TextView tvDrawRecord;
    @BindView(R2.id.tv_detail)
    TextView tvDetail;
//    @BindView(R2.id.view1)
//    View view1;

    @BindView(R2.id.ll_fund)
    LinearLayout llFund;
    @BindView(R2.id.tab_title)
    SlidingTabLayout tab_title;
    @BindView(R2.id.vp)
    ViewPager vp;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private String[] mTitles;
    boolean isHide = false;
    private TabPagerAdapter mAdapter;
    private String page;

    //    @Override
//    public void getIntentData() {
//        Bundle bundle = getIntent().getExtras();
//        page = bundle.getString("page");
//    }
    @SuppressLint("ValidFragment")
    public FundFrament(boolean isHide) {
        super(R.layout.activity_deposit, true, true);
        this.isHide = isHide;
    }
    public void setPos(String  page) {
        this.page = page;
    }
    @Override
    public void initView(View view) {
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                finish();
            }
        });
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {

                if(page!=null){
                    setFundBackgroup(Integer.parseInt(page));
                    titlebar.setVisibility(View.GONE);
                    tab_title.setVisibility(View.GONE);
                    llFund.setVisibility(View.VISIBLE);
                }
            }else {
                titlebar.setVisibility(View.VISIBLE);
                tab_title.setVisibility(View.VISIBLE);
                llFund.setVisibility(View.GONE);
            }
        }else {
            titlebar.setVisibility(View.VISIBLE);
            tab_title.setVisibility(View.VISIBLE);
            llFund.setVisibility(View.GONE);
        }

        mTitles = getResources().getStringArray(R.array.titlerecord_list);
        mFragments.add(FundDepositFragment.getInstance(mTitles[0]));
        mFragments.add(WithdrawalsFragment.getInstance(mTitles[1]));
        mFragments.add(DepositRecordFragment.getInstance(mTitles[2]));
        mFragments.add(DepositRecordFragment.getInstance(mTitles[3]));
        mFragments.add(FundsDetailsFragment.getInstance(mTitles[4]));

        mAdapter = new TabPagerAdapter(getChildFragmentManager(), mFragments, mTitles);
        vp.setAdapter(mAdapter);
        tab_title.setViewPager(vp, mTitles);

        setCurrItem();
        setmTitle();

        if (isHide)
            titlebar.setIvBackHide(View.GONE);
        Uiutils.setBaColor(getContext(), titlebar, false, null);
        Uiutils.setBarStye0(titlebar,getContext());
    }

    private void setCurrItem() {
        if(page == null){
            vp.setCurrentItem(0);
            titlebar.setText(mTitles[0]);
            return;
        }

        if (page.equals("0")) {
            vp.setCurrentItem(0);
            titlebar.setText(mTitles[0]);
        } else if ("1".equals(page)) {
            vp.setCurrentItem(1);
            titlebar.setText(mTitles[1]);
        } else if ("2".equals(page)) {
            vp.setCurrentItem(2);
        } else if ("3".equals(page)) {
            vp.setCurrentItem(3);
        }else if ("4".equals(page)) {
            vp.setCurrentItem(4);
        }

    }

    private void setFundBackgroup(int pos) {
        switch (pos) {
            case 0:
                tvFinance.setBackgroundResource(R.mipmap.black_bank);
                tvDraw.setBackgroundResource(0);
                tvFinanceRecord.setBackgroundResource(0);
                tvDrawRecord.setBackgroundResource(0);
                tvDetail.setBackgroundResource(0);
                break;
            case 1:

                tvFinance.setBackgroundResource(0);
                tvDraw.setBackgroundResource(R.mipmap.black_bank);
                tvFinanceRecord.setBackgroundResource(0);
                tvDrawRecord.setBackgroundResource(0);
                tvDetail.setBackgroundResource(0);

                break;
            case 2:
                tvFinance.setBackgroundResource(0);
                tvDraw.setBackgroundResource(0);
                tvFinanceRecord.setBackgroundResource(R.mipmap.black_bank);
                tvDrawRecord.setBackgroundResource(0);
                tvDetail.setBackgroundResource(0);
                break;
            case 3:
                tvFinance.setBackgroundResource(0);
                tvDraw.setBackgroundResource(0);
                tvFinanceRecord.setBackgroundResource(0);
                tvDrawRecord.setBackgroundResource(R.mipmap.black_bank);
                tvDetail.setBackgroundResource(0);
                break;
            case 4:
                tvFinance.setBackgroundResource(0);
                tvDraw.setBackgroundResource(0);
                tvFinanceRecord.setBackgroundResource(0);
                tvDrawRecord.setBackgroundResource(0);
                tvDetail.setBackgroundResource(R.mipmap.black_bank);
                break;
        }
    }

    public void setmTitle() {
        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int position) {
                titlebar.setText(mTitles[position]);
                setFundBackgroup(position);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
    }


    public void setTab(int i) {
        tab_title.setCurrentTab(i);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                break;
        }
    }

    protected void onTransformResume() {
//        if(!"4".equals(page)){
//            if (vp != null)
//                vp.setCurrentItem(0);
//            if (titlebar != null && mTitles != null && mTitles.length > 0)
//                titlebar.setText(mTitles[0]);
//        }else {
//            setCurrItem();
//            setFundBackgroup(4);
//        }
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")&&page!=null) {
                setCurrItem();
                setFundBackgroup(Integer.parseInt(page));

            }else {
                if (vp != null)
                    vp.setCurrentItem(0);
                if (titlebar != null && mTitles != null && mTitles.length > 0)
                    titlebar.setText(mTitles[0]);
            }
        }else {
            if (vp != null)
                vp.setCurrentItem(0);
            if (titlebar != null && mTitles != null && mTitles.length > 0)
                titlebar.setText(mTitles[0]);
        }

    }

    @OnClick({R.id.tv_finance, R.id.tv_draw, R.id.tv_finance_record, R.id.tv_draw_record, R.id.tv_detail})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_finance:
                setFundBackgroup(0);
                vp.setCurrentItem(0);

                break;
            case R.id.tv_draw:
                setFundBackgroup(1);
                vp.setCurrentItem(1);
                break;
            case R.id.tv_finance_record:
                setFundBackgroup(2);
                vp.setCurrentItem(2);
                break;
            case R.id.tv_draw_record:
                setFundBackgroup(3);
                vp.setCurrentItem(3);
                break;
            case R.id.tv_detail:
                setFundBackgroup(4);
                vp.setCurrentItem(4);
                break;
        }
    }
}
