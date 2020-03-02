package com.phoenix.lotterys.my.fragment;

import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.flyco.tablayout.SlidingTabLayout;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FragmentUitl;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/7 20:48
 */
@SuppressLint("ValidFragment")
public class DragonAssistantFragB extends BaseFragments implements View.OnClickListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
//    @BindView(R2.id.latest_long_dragon_tex)
//    TextView latestLongDragonTex;
//    @BindView(R2.id.my_bet)
//    TextView myBet;
//    @BindView(R2.id.lin_tex)
//    TextView linTex;

    @BindView(R2.id.tab_title)
    SlidingTabLayout tab_title;
    @BindView(R2.id.vp)
    ViewPager vp;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private  String[] mTitles ;
    private TabPagerAdapter mAdapter;

    private View inflate;
    private TextView tvTitle;
    private TextView tvMore;
    private TextView leftTex;

    private ImageView ivMore1;

    private FragmentUitl fragmentUitl;
    private View contentview;

    private int lineWidth;
    private int offset = 0;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private CustomPopWindow customPopWindow;
    boolean isHide = false;

    @SuppressLint("ValidFragment")
    public DragonAssistantFragB(boolean isHide) {
        super(R.layout.dragon_assistant_frag_b, true, true);
        this.isHide = isHide;
    }

    public static DragonAssistantFragB getInstance(boolean isHide) {
        return new DragonAssistantFragB(isHide);
    }

    private List<Fragment> listFrag = new ArrayList<>();
    private UserInfo userInfo;

    private LatestLongDragonFrag latestLongDragonFrag;

    @Override
    public void initView(View view) {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        Log.e("xxxisHide", "" + isHide);
        Uiutils.setBarStye(titlebar, getActivity());
        inflate = titlebar.getView();
        titlebar.setText("长龙助手");
        titlebar.setRIghtImg(R.drawable.warning_tips_w, View.VISIBLE);
        titlebar.setRightIconOnClickListener(this);
        titlebar.setRIghtTvVisibility(View.VISIBLE);
        tvTitle = inflate.findViewById(R.id.tv_title);
        tvTitle.setTextSize(18);
        tvMore = inflate.findViewById(R.id.tv_more);
        ivMore1 = inflate.findViewById(R.id.iv_more1);
        leftTex = inflate.findViewById(R.id.left_tex);
        tvTitle.setVisibility(View.GONE);
        leftTex.setVisibility(View.VISIBLE);
        leftTex.setText("长龙助手");

        if (null != userInfo && null != userInfo.getData())
            if (userInfo != null && userInfo.getData() != null)
                Uiutils.setText(tvMore, "￥" + userInfo.getData().getBalance());

        tvMore.setOnClickListener(this);
        tvMore.setTextSize(16);
        tvMore.setCompoundDrawables(null, null, null, null);
        ivMore1.setImageDrawable(getContext().getResources().getDrawable(R.drawable.refresh));
        ivMore1.setOnClickListener(this);
        DisplayMetrics dm = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
        int screenW = dm.widthPixels; // 获取分辨率宽度
        offset = (screenW / 2 - lineWidth) / 2;  // 计算偏移值
        lineWidth = screenW / 2;
//        linTex.setLayoutParams(new LinearLayout.LayoutParams(lineWidth, MeasureUtil.dip2px(
//                getContext(), 2
//        )));

//        latestLongDragonFrag = new LatestLongDragonFrag();
//        listFrag.add(latestLongDragonFrag);
//        listFrag.add(new MyBetFrag());
//        fragmentUitl = new FragmentUitl(getActivity(), listFrag);
//        fragmentUitl.setFrag();

        contentview = LayoutInflater.from(getContext()).inflate(R.layout.dragon_assistant_pop_b,
                null);
        contentview.findViewById(R.id.determine_pop_tex).setOnClickListener(this);
        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentview,
                Uiutils.getWiht(getActivity(), 0.9),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);
        if (isHide)
            titlebar.setIvBackHide(View.GONE);

        mTitles =getResources().getStringArray(R.array.long_queue);
        mFragments.add(LatestLongDragonFrag.getInstance());
        mFragments.add(MyBetFragB.getInstance());
        mAdapter = new TabPagerAdapter( getChildFragmentManager(), mFragments, mTitles);
        vp.setAdapter(mAdapter);
        tab_title.setViewPager(vp, mTitles);
        vp.setCurrentItem(0);
        titlebar.setText(mTitles[0]);
        setmTitle();


        setTheme();
    }

    @OnClick({/*R.id.latest_long_dragon_tex, R.id.my_bet*/})
    public void onClick(View view) {
        switch (view.getId()) {
//            case R.id.latest_long_dragon_tex:
//                Animation animation = new TranslateAnimation(lineWidth, 0, 0, 0);
//                animation.setFillAfter(true);
//                animation.setDuration(500);
//                // 给图片添加动画
//                linTex.startAnimation(animation);
//
//                fragmentUitl.setFt(getActivity().getSupportFragmentManager().beginTransaction());
//                fragmentUitl.showPostion(0);
//                break;
//            case R.id.my_bet:
//                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_SINGLE_INJECTION));
//                Animation animation0 = new TranslateAnimation(0, lineWidth, 0, 0);
//                animation0.setFillAfter(true);
//                animation0.setDuration(500);
//                // 给图片添加动画
//                linTex.startAnimation(animation0);
//                fragmentUitl.setFt(getActivity().getSupportFragmentManager().beginTransaction());
//                fragmentUitl.showPostion(1);
//                break;
            case R.id.iv_more:
                customPopWindow = popupWindowBuilder.create();
                customPopWindow.showAtLocation(contentview, Gravity.CENTER, 0, 0);
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.determine_pop_tex:
                customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.iv_more1:
                ObjectAnimator objectAnimator = ObjectAnimator.ofFloat(ivMore1, "rotation", 0f, 360f);
                objectAnimator.setDuration(1500);
                objectAnimator.start();

                getInfo();
                break;
            case R.id.tv_more:
                if (tvMore.getText().toString().contains("*")) {
                    tvMore.setText("￥" + userInfo.getData().getBalance());
                    ivMore1.setVisibility(View.VISIBLE);
                } else {
                    tvMore.setText("￥*****");
                    ivMore1.setVisibility(View.GONE);
                }

                break;
        }
    }

    private void getInfo() {
        NetUtils.get(Constants.USERINFO ,Uiutils.getToken(getContext()), true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        if (!StringUtils.isEmpty(object)) {
                            userInfo = Uiutils.stringToObject(object, UserInfo.class);
                            if (null != userInfo && null != userInfo.getData()) {
                                ShareUtils.saveObject(getContext(), SPConstants.USERINFO, userInfo);
                                Uiutils.setText(tvMore, "￥" + userInfo.getData().getBalance());
                            }
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });
    }


    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.LONG_REFRESH_AMOUNT:
                getInfo();
                break;
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                setTheme();
                break;
        }
    }

    private void setTheme() {
        Uiutils.setBaColor(getContext(),titlebar, false, null);
//        Uiutils.setBaColor(getContext(),linTex);
    }


    @Override
    public void onDestroy() {
        if(latestLongDragonFrag!=null){
            latestLongDragonFrag.setHandler();
            latestLongDragonFrag = null;
        }


        if (null!=mFragments&&mFragments.size()>0){
            for (Fragment fragment :mFragments){
                if (fragment instanceof LatestLongDragonFrag){
                    if (null!=fragment){
                        ((LatestLongDragonFrag)fragment).setHandler();
                    }
                }
            }
        }


        super.onDestroy();
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

    protected void onTransformResume() {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        if (null != userInfo && null != userInfo.getData())
            if (userInfo != null && userInfo.getData() != null)
                Uiutils.setText(tvMore, "￥" + userInfo.getData().getBalance());
    }
}
