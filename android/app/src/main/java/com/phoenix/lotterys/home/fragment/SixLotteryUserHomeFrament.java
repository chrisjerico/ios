package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import androidx.cardview.widget.CardView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.flyco.tablayout.SegmentTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.SixLotteryUserBean;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.ArcView;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/10/4
 */

@SuppressLint("ValidFragment")
public class SixLotteryUserHomeFrament extends BaseFragments {

    @BindView(R2.id.tab_seg)
    SegmentTabLayout tabSeg;
    @BindView(R2.id.vp)
    ViewPager vp;
    @BindView(R2.id.tv_back)
    TextView tvBack;
    @BindView(R2.id.tv_title)
    TextView tvTitle;

    @BindView(R2.id.arcView)
    ArcView arcView;
    @BindView(R2.id.iv_head)
    ImageView ivHead;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_grade)
    TextView tvGrade;
    @BindView(R2.id.tv_1)
    TextView tv1;
    @BindView(R2.id.tv_2)
    TextView tv2;
    @BindView(R2.id.tv_3)
    TextView tv3;
    @BindView(R2.id.tv_4)
    TextView tv4;
    @BindView(R2.id.tv_praise)
    TextView tvPraise;
    @BindView(R2.id.tv_focus)
    TextView tvFocus;
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;
    @BindView(R2.id.ll_info)
    LinearLayout llInfo;
    @BindView(R2.id.cardView)
    CardView cardView;
    @BindView(R2.id.rl_info)
    RelativeLayout rlInfo;
    @BindView(R2.id.card_tex)
    TextView card_tex;


    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private String[] mTitles;
    boolean isHide = false;
    private TabPagerAdapter mAdapter;
    String title = "";
    private String page;
    private String alias;
    private String uid;

    @SuppressLint("ValidFragment")
    public SixLotteryUserHomeFrament(boolean isHide, String uid, String alias) {
        super(R.layout.sixlottery_userhome_frament, true, true);
        this.isHide = isHide;
        this.title = title;
        this.uid = uid;
        this.alias = alias;
    }

    @Override
    public void initView(View view) {
        mTitles = getResources().getStringArray(R.array.sixThemeUserList);
        mFragments.add(SixThemeBetterHomeFragment.getInstance("", "forum", uid));
        mFragments.add(SixThemeBetterHomeFragment.getInstance("", "gourmet", uid));
        initVp();
        Uiutils.setBaColor(getContext(), null, true, arcView);
        getInfo();
        Uiutils.setBarStye0(titlebar,getActivity());
        Uiutils.setBarStye0(llInfo,getActivity());
//        Uiutils.setBarStye0(arcView,getActivity());
        if (Uiutils.isTheme(getContext())){
            arcView.setVisibility(View.GONE);
            card_tex.setVisibility(View.VISIBLE);
        }

    }

    private void getInfo() {
        String url;
        String token = SPConstants.getToken(getContext());
        if (TextUtils.isEmpty(token)) {
            String history = "&uid=%s";
            url = Constants.SIXTHEMEUSERINFO + String.format(history, SecretUtils.DESede(uid)) + "&sign=" + SecretUtils.RsaToken();
        } else {
            String history = "&token=%s&uid=%s";
            url = Constants.SIXTHEMEUSERINFO + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(uid)) + "&sign=" + SecretUtils.RsaToken();
        }
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixLotteryUserHomeFrament.this, true, SixLotteryUserBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                SixLotteryUserBean user = (SixLotteryUserBean) o;

                if (user != null && user.getCode() == 0 && user.getData() != null) {
                    SixLotteryUserBean.DataBean data = user.getData();
                    if (data.getFace() != null) {
                        ImageLoadUtil.loadRoundImage(ivHead, data.getFace(), 0);
                    }
                    if (data.getNickname() != null) {
                        tvName.setText(data.getNickname());
                    }
                    if (data.getLevelName() != null) {
                        tvGrade.setText(data.getLevelName());
                    }
                    tv1.setText(data.getFollowNum() + "\n关注专家");
                    tv2.setText(data.getFansNum() + "\n关注粉丝");
                    tv3.setText(data.getFavContentNum() + "\n关注帖子");
                    tv4.setText(data.getContentNum() + "\n发布帖子");

                    tvPraise.setText("获赞数：" + data.getLikeNum() + "");

                    if (data.getIsFollow() == 0) {
                        tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow1));
                        tvFocus.setTextColor(getResources().getColor(R.color.color_4));
                        tvFocus.setBackground(getResources().getDrawable(R.drawable.textview_border));
                    } else if (data.getIsFollow() == 1) {
                        tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow_change));
                        tvFocus.setTextColor(getResources().getColor(R.color.black1));
                        tvFocus.setBackgroundColor(getResources().getColor(R.color.fount_ash));
                    }
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
            }

            @Override
            public void onFailed(Response<String> response) {
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
//                Uiutils.setBaColor(getContext(),titlebar, false, null);
                break;
        }
    }

    private void initVp() {
        vp.setAdapter(new TabPagerAdapter(getChildFragmentManager(), mFragments));
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

    @OnClick({R.id.tv_back, R.id.tv_focus})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_back:
                getActivity().finish();
                break;
            case R.id.tv_focus:
                String focus = tvFocus.getText().toString().trim();
                if (focus.equals(getResources().getString(R.string.lhc_bbs_follow1))) {
                    getFocus("1");
                } else if (focus.equals(getResources().getString(R.string.lhc_bbs_follow_change))) {
                    getFocus("0");
                }
                break;
        }
    }

    //关注楼主
    private void getFocus(String follow) {
        String url;
        String token = SPConstants.checkLoginInfo(getContext());
        if (TextUtils.isEmpty(token)) {
            return;
        }
        if (Uiutils.isTourist(getContext()))
            return;
        String history = "&token=%s&followFlag=%s&posterUid=%s";
        url = Constants.FOLLOWPOSTER + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(follow), SecretUtils.DESede(uid)) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixLotteryUserHomeFrament.this, true, BaseBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                BaseBean base = (BaseBean) o;
                if (base != null && base.getMsg() != null) {
                    if (base.getCode() == 0) {
                        mFocus();
                    }
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
                if (bb != null && bb.getMsg() != null) {
                    if (bb.getMsg().equals("您已关注过楼主")) {
                        mFocus();
                    }
                }
            }

            @Override
            public void onFailed(Response<String> response) {

            }
        });
    }

    private void mFocus() {
        String focus = tvFocus.getText().toString().trim();
        if (focus.equals(getResources().getString(R.string.lhc_bbs_follow1))) {
            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow_change));
            tvFocus.setTextColor(getResources().getColor(R.color.black1));
            tvFocus.setBackgroundColor(getResources().getColor(R.color.fount_ash));
        } else if (focus.equals(getResources().getString(R.string.lhc_bbs_follow_change))) {
            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow1));
            tvFocus.setTextColor(getResources().getColor(R.color.color_4));
            tvFocus.setBackground(getResources().getDrawable(R.drawable.textview_border));
        }
    }


}
