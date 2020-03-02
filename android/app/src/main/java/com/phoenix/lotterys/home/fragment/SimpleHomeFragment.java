package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.TypedArray;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.speech.tts.TextToSpeech;
import androidx.annotation.RequiresApi;
import com.google.android.material.tabs.TabLayout;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.example.zhouwei.library.CustomPopWindow;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.cache.CacheMode;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.coupons.CouponsFragment;
import com.phoenix.lotterys.coupons.adapter.CouponsAdapter;
import com.phoenix.lotterys.coupons.bean.CouponsBean;
import com.phoenix.lotterys.home.adapter.MyViewpagerPagerAdapter;
import com.phoenix.lotterys.home.adapter.SimpleOneLevelNavigationAdapter;
import com.phoenix.lotterys.home.adapter.SixInfoAdapter;
import com.phoenix.lotterys.home.adapter.SixNumBallAdapter;
import com.phoenix.lotterys.home.adapter.WinUserAdapter;
import com.phoenix.lotterys.home.bean.BannerBean;
import com.phoenix.lotterys.home.bean.BannerBean1;
import com.phoenix.lotterys.home.bean.FloatAdBean;
import com.phoenix.lotterys.home.bean.LhcDocBean;
import com.phoenix.lotterys.home.bean.LhcNumBean;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.home.bean.NoticeBean;
import com.phoenix.lotterys.home.bean.OnLineBean;
import com.phoenix.lotterys.home.bean.RedBagBean;
import com.phoenix.lotterys.home.bean.RedBagDetailBean;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.main.bean.RanklistBean;
import com.phoenix.lotterys.main.webview.CouponWebActivity;
import com.phoenix.lotterys.my.activity.LoginActivity;
import com.phoenix.lotterys.my.activity.RegeditActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.DetailBean;
import com.phoenix.lotterys.my.fragment.LinkSixFrag;
import com.phoenix.lotterys.my.fragment.LotteryRecordFrag;
import com.phoenix.lotterys.my.fragment.PubAttentionFrag;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GlideImageLoader;
import com.phoenix.lotterys.util.GlideImageLoaderRound;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.HomeDialog;
import com.phoenix.lotterys.view.MarqueTextView;
import com.phoenix.lotterys.view.MarqueeView;
import com.phoenix.lotterys.view.MyIntentService;
import com.phoenix.lotterys.view.RedBagDetilDialog;
import com.phoenix.lotterys.view.ScratchDialog;
import com.phoenix.lotterys.view.SignViewPager;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.youth.banner.Banner;
import com.youth.banner.listener.OnBannerListener;

import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.io.IOException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

import static com.phoenix.lotterys.application.Application.getContextObject;
import static com.phoenix.lotterys.util.StampToDate.getMinuteSecond;

/**
 * 简约模板首页
 */
public class SimpleHomeFragment extends BaseFragment implements View.OnClickListener {
    Application mApp;
    @BindView(R2.id.tv_rankinglist)
    TextView tvRankinglist;
    @BindView(R2.id.tv_on_line)
    TextView tvOnLine;

    @BindView(R2.id.rl_float_ad_1)
    ViewGroup rlFloatAd1;
    @BindView(R2.id.iv_float_ad_1)
    ImageView ivFloatAd1;
    @BindView(R2.id.iv_ad_close_1)
    ImageView ivAdClose1;
    @BindView(R2.id.rl_float_ad_2)
    ViewGroup rlFloatAd2;
    @BindView(R2.id.iv_float_ad_2)
    ImageView ivFloatAd2;
    @BindView(R2.id.iv_ad_close_2)
    ImageView ivAdClose2;
    @BindView(R2.id.rl_float_ad_3)
    ViewGroup rlFloatAd3;
    @BindView(R2.id.iv_float_ad_3)
    ImageView ivFloatAd3;
    @BindView(R2.id.iv_ad_close_3)
    ImageView ivAdClose3;
    @BindView(R2.id.rl_float_ad_4)
    ViewGroup rlFloatAd4;
    @BindView(R2.id.iv_float_ad_4)
    ImageView ivFloatAd4;
    @BindView(R2.id.iv_ad_close_4)
    ImageView ivAdClose4;
    private HomeGame gametype;


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.clear_tex:
                if (null != mCustomPopWindow) {
                    mCustomPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                }
                break;
            case R.id.commit_tex:
                if (null != mCustomPopWindow) {
                    mCustomPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                }
                goPlay();
                break;
        }
    }


    private void goPlay() {
        if (StringUtils.isEmpty(Uiutils.getToken(getContext()))) {
            getActivity().startActivity(new Intent(getContext(), LoginActivity.class));
            return;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("cid", cid);
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.post(Constants.BUYCONTENT, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object, getContext());
                goparticulars2();
            }

            @Override
            public void onError() {
            }
        });
    }

    @BindView(R2.id.bt_select)
    Button btSelect;
    @BindView(R2.id.home_banner)
    Banner homeBanner;
    @BindView(R2.id.marquee)
    MarqueTextView tvNotice;
    @BindView(R2.id.tb_ticket_type)
    TabLayout tbTicketType;
    @BindView(R2.id.vp_ticket_type)
    SignViewPager vpTicketType;
    @BindView(R2.id.ll_ranking)
    LinearLayout llRanking;
    @BindView(R2.id.recycleAuto)
    MarqueeView recycleAuto;
    WinUserAdapter winUserAdapter;

    List<String> mNotice;
    @BindView(R2.id.seniority_lin)
    LinearLayout seniorityLin;
    @BindView(R2.id.img_brain)
    ImageView imgBrain;
    @BindView(R2.id.img_act)
    ImageView imgAct;
    @BindView(R2.id.cb_show)
    CheckBox cbShow;
    @BindView(R2.id.tv_result)
    TextView tvResult;
    @BindView(R2.id.switch1)
    Switch switch1;
    @BindView(R2.id.tv_nextdata)
    TextView tvNextdata;
    @BindView(R2.id.tv_countdown)
    TextView tvCountdown;
    @BindView(R2.id.tb_ticket_type_lin)
    LinearLayout tbTicketTypeLin;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.rl_redbag)
    RelativeLayout rlRedbag;
    @BindView(R2.id.rv_navigation)
    RecyclerView rvNavigation;
    HomeDialog homeDialog;
    List<RanklistBean.DataBean.ListBean> list = new ArrayList<>();
    @BindView(R2.id.iv_rebbag)
    ImageView ivRebbag;
    @BindView(R2.id.iv_close)
    ImageView ivClose;
    @BindView(R2.id.view_1)
    View view_1;
    @BindView(R2.id.view_2)
    View view_2;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.ll_coup)
    LinearLayout llCoup;
    @BindView(R2.id.ll_coupons_list)
    LinearLayout llCouponsList;
    @BindView(R2.id.tv_brain)
    TextView tvBrain;
    @BindView(R2.id.tv_act)
    TextView tvAct;
    @BindView(R2.id.tv_server_name)
    TextView tvServerName;
    boolean isRedBag = false;
    MainActivity mActivity;
    GamesCustomFragment gamesfragment;
    List<Fragment> fragmentList;
    @BindView(R2.id.rv_six_info)
    RecyclerView rvSixInfo;
    @BindView(R2.id.rv_six_num)
    RecyclerView rvSixNum;
    @BindView(R2.id.ll_marquee)
    LinearLayout ll_marquee;
    String themeColor;
    @BindView(R2.id.rv_coup)
    RecyclerView rvCoup;
    @BindView(R2.id.iv_banner)
    Banner iv_banner;
    @BindView(R2.id.ll_result)
    LinearLayout llResult;
    @BindView(R2.id.tv_opening)
    TextView tvOpening;
    @BindView(R2.id.rl_banner)
    RelativeLayout rlBanner;
    List<LhcDocBean.DataBean> sixInfoList = new ArrayList<>();
    private BannerBean banner;
    private RedBagDetailBean redbagdetail;
    private RedBagDetilDialog redBagDetilDialog;
    //    private SharedPreferences sp;
    private SimpleOneLevelNavigationAdapter navig;
    private ConfigBean config;
    private String[] title;
    private String[] content;
    private TypedArray icons;
    private SixInfoAdapter sixInfoAdapter;
    private CountDownTimer countdownView;
    private SixNumBallAdapter mAdapter;  //六合彩开奖结果
    private List<WinNumber> winNumberList; //六合彩开奖数据
    private LhcDocBean lhcDocBean;
    boolean isOpen = true;
    boolean isShow = true;    //六合模板第一次开奖结束清空list数据

    int navPosition = 0;

    public SimpleHomeFragment() {
        super(R.layout.fragment_home_simple, true);
    }

    public static SimpleHomeFragment getInstance() {
        return new SimpleHomeFragment();
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @SuppressLint("SetTextI18n")
    @Override
    public void initView(View view) {
        mApp = (Application) getContextObject();
        mActivity = (MainActivity) getActivity();
        speechInit();
        getNotice(); //公告
        getFloatAD();
        if (BuildConfig.FLAVOR.equals("L001") || BuildConfig.FLAVOR.equals("L001gbhy")) {
            rlBanner.setVisibility(View.GONE);
            llRanking.setVisibility(View.GONE);
            imgAct.setVisibility(View.GONE);
            tvAct.setVisibility(View.GONE);
        } else if (BuildConfig.FLAVOR.equals("L002")) {
            rlBanner.setVisibility(View.GONE);
            llRanking.setVisibility(View.GONE);
            imgAct.setVisibility(View.GONE);
            tvAct.setVisibility(View.GONE);
        } else {
            initBanner();//
            getRanklist();//中奖金额排行
            getOnLine();
        }

        getRedbagdetail(false); //红包
        initCoupons();
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(100/*,false*/);//传入false表示刷新失败
                if (BuildConfig.FLAVOR.equals("L001")) {
                } else if (BuildConfig.FLAVOR.equals("L002")) {
                } else if (BuildConfig.FLAVOR.equals("L001gbhy")) {
                } else {
                    initBanner();
                    getRanklist();//中奖金额排行
                    getOnLine();
                }
                getNotice(); //公告
                getFloatAD();
                template(true);
//                getGameType(); //真人电子体育
                isRedBag = false;
                getRedbagdetail(false); //红包
                isShow = true;
                mActivity.getConfig(false, false);
            }
        });
//        initRank();
        titleClick();
        mState();
        setTheme();
        setConfig();
        showCustomized(); //各平台定制样式
//        getGameType(); //真人电子体育
        template(false);  //模板

        initListener(cbShow);
        isShow = true;
        Uiutils.setBarStye0(titlebar, getContext());

        String themetyp = ShareUtils.getString(getContext(), "themetyp", "");
        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("4", themetyp)) {
            tvAct.setVisibility(View.GONE);
            imgAct.setVisibility(View.GONE);
        }

    }

    //六合模板 声音播报
    private void initListener(CheckBox cb) {
        cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    isOpen = true;
                } else {
                    isOpen = false;
                }
            }
        });
    }

    private BannerBean1 bannerBean1;

    @SuppressLint("ResourceType")
    private void showCustomized() {   //c134 增加轮播图
        Map<String, Object> map = new HashMap<>();
        NetUtils.get(Constants.HOMEADS, map, false, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                bannerBean1 = Uiutils.stringToObject(object, BannerBean1.class);
                if (null != bannerBean1 && null != bannerBean1.getData() && bannerBean1.getData().size() > 0) {
                    List<String> list = new ArrayList<>();
                    for (BannerBean1.DataBean db : bannerBean1.getData()) {
                        list.add(db.getImage());
                        iv_banner.setImageLoader(new GlideImageLoaderRound());
                    }

                    int higth = 0;
                    if (Uiutils.isSite("c091") || Uiutils.isSite("c165")) {
//                        higth =   Uiutils.getWiht(getActivity(),0.207);
                        double higth1 = (Uiutils.getWiht(getActivity(), 1) - 20) * 0.207;
                        higth = Integer.parseInt(new java.text.DecimalFormat("0").format(higth1));
                    } else {
                        higth = Uiutils.getWiht(getActivity(), 0.25);
                        double higth1 = (Uiutils.getWiht(getActivity(), 1) - 20) * 0.25;
                        higth = Integer.parseInt(new java.text.DecimalFormat("0").format(higth1));
                    }

                    LinearLayout.LayoutParams Params = (LinearLayout.LayoutParams) iv_banner.getLayoutParams();
                    Params.height = higth;
                    iv_banner.setLayoutParams(Params);

                    Params.setMargins(MeasureUtil.dip2px(getContext(), 6), 0,
                            MeasureUtil.dip2px(getContext(), 6), MeasureUtil.dip2px(getContext(), 6));
//                    if (list.size()>1)
                    iv_banner.setImages(list).setDelayTime(3 * 1000).start();
//                    iv_banner.setImages(list);

                    iv_banner.setVisibility(View.VISIBLE);
                } else {
                    iv_banner.setVisibility(View.GONE);
                }

            }

            @Override
            public void onError() {

            }
        });


//        if (BuildConfig.FLAVOR.equals("c134")) {
//            iv_banner.setVisibility(View.VISIBLE);
//            Glide.with(getContext()).load(R.mipmap.banner_c134).into(iv_banner);
//        } else {
//            iv_banner.setVisibility(View.GONE);
//        }
//
        if (BuildConfig.FLAVOR.equals("c073") || BuildConfig.FLAVOR.equals("c213") || BuildConfig.FLAVOR.equals("c200")) {
            tbTicketType.setTabMode(1);
//            Log.e("xxxxTabMode",tbTicketType.getTabMode()+"");
        } else {
            tbTicketType.setTabMode(0);
        }

        iv_banner.setOnBannerListener(onBannerListener);

    }

    public void mState() {
        if (SPConstants.getValue(getContext(), SPConstants.SP_API_SID).equals(SPConstants.SP_NULL)) {
            if (mActivity != null)
                mActivity.lockedSlidingMenu();
            titlebar.setRIghtImgVisibility(0x00000008);
            titlebar.setRIghtTvVisibility(0x00000000);
            titlebar.setRIghtTvDemoVisibility(0x00000000);
            titlebar.setRIghtTvLoginVisibility(0x00000000);
            titlebar.setRightMoveImg();
        } else {
            if (mActivity != null)
                mActivity.enabledSlidingMenu();
            titlebar.setRIghtImgVisibility(0x00000000);
            titlebar.setRIghtTvVisibility(0x00000000);
            titlebar.setRIghtTvDemoVisibility(0x00000008);
            titlebar.setRIghtTvLoginVisibility(0x00000008);
            titlebar.setRightMove("", false);
            if (SPConstants.getValue(getContext(), SPConstants.SP_USERTYPE).equals("guest")) {
                titlebar.setRightMove("游客", false);

            } else if (!SPConstants.getValue(getContext(), SPConstants.SP_USERTYPE).equals("Null")) {
                if (!SPConstants.getValue(getContext(), SPConstants.SP_USR).equals("Null"))
                    titlebar.setRightMove(SPConstants.getValue(getContext(), SPConstants.SP_USR), false);
            }

        }
    }

    //标题点击事件
    private void titleClick() {
        if (titlebar == null) {
            return;
        }
        titlebar.setRightIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mActivity.openSliding();
            }
        });

        //试玩
        titlebar.setRightTextDemoOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mApp, MyIntentService.class);
                intent.putExtra("type", "2000");
                getContext().startService(intent);
            }
        });
        //注册
        titlebar.setRightTextOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getContext(), RegeditActivity.class));
            }
        });
        //登录
        titlebar.setRightTextLoginOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                startActivity(new Intent(getContext(), LoginActivity.class));
                Uiutils.login(getContext());
            }
        });

    }

    private void getRedbagdetail(boolean isLogin) {
        String token = SPConstants.getToken(getActivity());
        String url = null;
        if (TextUtils.isEmpty(token)) {
            url = Constants.REDBAGDETAIL;
        } else
            url = Constants.REDBAGDETAIL + "&token=" + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SimpleHomeFragment.this,
                true, RedBagDetailBean.class, 110) {
            @Override
            public void onUi(Object o) throws IOException {
                redbagdetail = (RedBagDetailBean) o;
                try {
                    redbagShow(isLogin);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
                rlRedbag.setVisibility(View.GONE);
            }

            @Override
            public void onFailed(Response<String> response) {
                rlRedbag.setVisibility(View.GONE);
            }
        });
    }

    private void redbagShow(boolean isLogin) {
        if (redbagdetail != null && redbagdetail.getCode() == 0 && redbagdetail.getData() != null) {
            if (redbagdetail.getData().getShow_time() != null && ShowItem.isNumeric(redbagdetail.getData().getShow_time())) {
                long time = Long.parseLong(redbagdetail.getData().getShow_time());
                if ((System.currentTimeMillis() - (time * 1000) >= 0)) {
                    if (!isRedBag)
                        rlRedbag.setVisibility(View.VISIBLE);
                    ImageLoadUtil.rightRoundCorners(0, getActivity(), redbagdetail.getData().getRedBagLogo(), ivRebbag);
                    if (redBagDetilDialog == null && isLogin) {
                        redBagDetilDialog = new RedBagDetilDialog(getContext(), redbagdetail.getData(), new RedBagDetilDialog.onItemClickListener() {
                            @Override
                            public void onItemClick(Object object) {
                                try {
                                    getRedBag();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        });
                        redBagDetilDialog.show();
                    }
                } else {
                    rlRedbag.setVisibility(View.GONE);
//                    if (isLogin)
//                        ToastUtils.ToastUtils(getResources().getString(R.string.loginaddactivt), getContext());
                }
            }

        }
    }

    //领红包
    private void getRedBag() {
        String token = SPConstants.getToken(getActivity());
        if (TextUtils.isEmpty(token))
            return;
        RedBagBean red = new RedBagBean();
        red.setId(SecretUtils.DESede(redbagdetail.getData().getId()));
        red.setToken(SecretUtils.DESede(token));
        if (Constants.ENCRYPT)
            red.setSign(SecretUtils.RsaToken());
        Gson gson = new Gson();
        String json = gson.toJson(red);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.GETREDBAG + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getActivity(), true, getActivity(),
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean bb = (BaseBean) o;
                        if (bb != null && bb.getCode() == 0 && bb.getData() != null) {
                            String[] array = {getResources().getString(R.string.affirm)};
                            String msg = "恭喜您获得了 " + bb.getData() + " 元红包";
                            TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, getResources().getString(R.string.info), msg, "", new TDialog.onItemClickListener() {
                                @Override
                                public void onItemClick(Object object, int position) {

                                }
                            });
                            mTDialog.setCancelable(false);
                            mTDialog.show();
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

    private void getNotice() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.NOTICE)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SimpleHomeFragment.this,
                true, NoticeBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                NoticeBean notice = (NoticeBean) o;
                if (notice != null && notice.getCode() == 0 && notice.getData() != null && notice.getData() != null) {
                    if (notice.getData().getScroll() != null && notice.getData().getScroll().size() != 0) {
                        ll_marquee.setVisibility(View.VISIBLE);
                        mNotice = new ArrayList<>();
                        for (NoticeBean.DataBean.Scroll db : notice.getData().getScroll()) {
                            mNotice.add(db.getTitle());
                        }
                        if (notice.getData().getScroll().size() == 1) {
                            mNotice.add(notice.getData().getScroll().get(0).getTitle());
                        }
                        if ((mNotice == null || mNotice.size() == 0) && tvNotice == null)
                            return;
                        tvNotice.setContentList((ArrayList<String>) mNotice);
                        tvNotice.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                int pos = notice.getData().getScroll().size() == 1 ? 0 : tvNotice.getCurrentPos();
                                String[] array = {getResources().getString(R.string.affirm)};

                                StringBuffer sb = new StringBuffer();

                                for (int i = 0; i < notice.getData().getScroll().size(); i++) {
                                    if (StringUtils.isEmpty(sb.toString())) {
                                        sb.append(notice.getData().getScroll().get(i).getContent());
                                    } else {
                                        sb.append("\n" + "\n" + notice.getData().getScroll().get(i).getContent());
                                    }
                                }

                                TDialog mTDialog = new TDialog(1, getActivity(), TDialog.Style.Center, array,
                                        getResources().getString(R.string.notice), "", sb.toString(), new TDialog.onItemClickListener() {
                                    @Override
                                    public void onItemClick(Object object, int position) {

                                    }
                                });
                                mTDialog.setCancelable(false);
                                mTDialog.show();
                            }
                        });
                    } else {
                        ll_marquee.setVisibility(View.GONE);
                    }

                    if (notice.getData().getPopup() != null && notice.getData().getPopup().size() != 0) {
                        if (!BuildConfig.FLAVOR.equals("c085"))
                            notice.getData().getPopup().get(0).setOpen(true);

                        if (homeDialog == null) {
                            homeDialog = new HomeDialog(getActivity(), notice.getData().getPopup());
                            homeDialog.show();
                        } else {
                            homeDialog.dismiss();
                            homeDialog = new HomeDialog(getActivity(), notice.getData().getPopup());
                            homeDialog.show();
                        }
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

    private void getFloatAD() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.FLOAT_AD)).tag(getActivity()).execute(
                new NetDialogCallBack(getContext(),
                        false,
                        SimpleHomeFragment.this,
                        true,
                        FloatAdBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        FloatAdBean notice = (FloatAdBean) o;

                        if (notice != null && notice.getCode() == 0 && notice.getData() != null && notice.getData() != null) {
                            for (FloatAdBean.DataBean datum : notice.getData()) {
                                switch (datum.getPosition()) {
                                    case 1:
                                        showFloatAd(rlFloatAd1, ivFloatAd1, ivAdClose1, datum);
                                        break;
                                    case 2:
                                        showFloatAd(rlFloatAd2, ivFloatAd2, ivAdClose2, datum);
                                        break;
                                    case 3:
                                        showFloatAd(rlFloatAd3, ivFloatAd3, ivAdClose3, datum);
                                        break;
                                    case 4:
                                        showFloatAd(rlFloatAd4, ivFloatAd4, ivAdClose4, datum);
                                        break;
                                }

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

    private void showFloatAd(ViewGroup rl, ImageView ivImage, ImageView ivClose, FloatAdBean.DataBean datum) {
        rl.setVisibility(View.VISIBLE);
        ivClose.setOnClickListener(v -> rl.setVisibility(View.INVISIBLE));
        ivImage.setOnClickListener(v -> {
//            rl.setVisibility(View.INVISIBLE);
            SkipGameUtil.SkipNavig(datum.getLinkCategory(),
                    datum.getLinkPosition(),
                    datum.getImage(),
                    getContext(),
                    datum.getLotteryGameType(),
                    datum.getRealIsPopup(),
                    datum.getRealSupportTrial());

        });
        Glide.with(getContext())
                .load(datum.getImage())
                .into(ivImage);
    }

    private void initBanner() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.BANNER)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SimpleHomeFragment.this,
                true, BannerBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                banner = (BannerBean) o;
                if (banner != null && banner.getCode() == 0 && banner.getData() != null && banner.getData().getList() != null && banner.getData().getList().size() != 0) {
                    List<String> list = new ArrayList<>();
                    for (BannerBean.DataBean.ListBean db : banner.getData().getList()) {
                        list.add(db.getPic());
                        homeBanner.setImageLoader(new GlideImageLoader());
                    }
                    int interval = 5000;
                    if(!TextUtils.isEmpty(banner.getData().getInterval())){
                        interval = (Integer.parseInt(banner.getData().getInterval()))*1000;
                    }
                    homeBanner.setImages(list).setDelayTime(interval).start();
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
            }

            @Override
            public void onFailed(Response<String> response) {
            }
        });
        homeBanner.setOnBannerListener(new OnBannerListener() {
            @Override
            public void OnBannerClick(int position) {
                if (banner != null && banner.getCode() == 0 && banner.getData() != null && banner.getData().getList().size() != 0) {
                    String linkCategory = "";
                    String linkPosition = "";
                    String url = "";
                    String lotteryGameType = "";
                    String realIsPopup = "";
                    String realSupportTrial = "";
                    if (banner.getData().getList().get(position).getLinkCategory() != null) {
                        linkCategory = banner.getData().getList().get(position).getLinkCategory();
                    }
                    if (banner.getData().getList().get(position).getLinkPosition() != null) {
                        linkPosition = banner.getData().getList().get(position).getLinkPosition();
                    }
                    if (banner.getData().getList().get(position).getUrl() != null) {
                        url = banner.getData().getList().get(position).getUrl();
                    }

                    if (banner.getData().getList().get(position).getLotteryGameType() != null) {
                        lotteryGameType = banner.getData().getList().get(position).getLotteryGameType();
                    }
                    if (banner.getData().getList().get(position).getRealIsPopup() != null) {
                        realIsPopup = banner.getData().getList().get(position).getRealIsPopup();
                    }
                    if (banner.getData().getList().get(position).getRealSupportTrial() != null) {
                        realSupportTrial = banner.getData().getList().get(position).getRealSupportTrial();
                    }
                    if ((linkCategory.equals("0") && url.equals("")) || url.equals("/")) {
                        return;
                    }

                    SkipGameUtil.SkipNavig(linkCategory, linkPosition, url, getContext(), lotteryGameType, realIsPopup, realSupportTrial);
                }
            }
        });
    }

    private OnBannerListener onBannerListener = new OnBannerListener() {
        @Override
        public void OnBannerClick(int position) {

            if (null != bannerBean1 && null != bannerBean1.getData() && bannerBean1.getData().size() > 0) {
                String linkCategory = "";
                String linkPosition = "";
                String url = "";
                String lotteryGameType = "";
                String realIsPopup = "";
                String realSupportTrial = "";
                if (bannerBean1.getData().get(position).getLinkCategory() != null) {
                    linkCategory = bannerBean1.getData().get(position).getLinkCategory();
                }
                if (bannerBean1.getData().get(position).getLinkPosition() != null) {
                    linkPosition = bannerBean1.getData().get(position).getLinkPosition();
                }
//                if (bannerBean1.getData().get(position).getUrl() != null) {
//                    url = bannerBean1.getData().get(position).getUrl();
//                }

                if (bannerBean1.getData().get(position).getLotteryGameType() != null) {
                    lotteryGameType = bannerBean1.getData().get(position).getLotteryGameType();
                }
                if (bannerBean1.getData().get(position).getRealIsPopup() != null) {
                    realIsPopup = bannerBean1.getData().get(position).getRealIsPopup();
                }
                if (bannerBean1.getData().get(position).getRealSupportTrial() != null) {
                    realSupportTrial = bannerBean1.getData().get(position).getRealSupportTrial();
                }
                if ((linkCategory.equals("0") && url.equals("")) || url.equals("/")) {
                    return;
                }

                SkipGameUtil.SkipNavig(linkCategory, linkPosition, url, getContext(), lotteryGameType, realIsPopup, realSupportTrial);
            }
        }
    };

    private void initFragment() {
        fragmentList = new ArrayList<>();
        for (int t = 0; t < gametype.getData().getIcons().size(); t++) {
            if (gametype.getData().getIcons().get(t).getStyle().equals("0")) {
//                SimpleLotteryCustomFragment lotteryfragment = new SimpleLotteryCustomFragment(gametype.getData().getIcons().get(t), t);
                GamesCustomFragment lotteryfragment = new GamesCustomFragment(gametype.getData().getIcons().get(t), t);
                lotteryfragment.setSignViewPager(vpTicketType);
                fragmentList.add(lotteryfragment);
            } else {
                SimpleGamesCustomFragment gamesfragment = new SimpleGamesCustomFragment(gametype.getData().getIcons().get(t), t);
                gamesfragment.setSignViewPager(vpTicketType);
                fragmentList.add(gamesfragment);
            }

        }
        MyViewpagerPagerAdapter myViewpagerPagerAdapter = new MyViewpagerPagerAdapter(this.getChildFragmentManager(), fragmentList, getActivity(), gametype, 1);
        myViewpagerPagerAdapter.setSignViewPager(vpTicketType);
        vpTicketType.setAdapter(myViewpagerPagerAdapter);

        tbTicketType.setupWithViewPager(vpTicketType);
        for (int i = 0; i < gametype.getData().getIcons().size(); i++) {
            tbTicketType.getTabAt(i).setCustomView(myViewpagerPagerAdapter.getCustomView(i));
        }
        if (tbTicketType.getTabCount() != 0) {
            tbTicketType.getTabAt(0).getCustomView().findViewById(R.id.tv_name).setSelected(true);
            vpTicketType.setOffscreenPageLimit(5);
            setShowGame(View.VISIBLE);
        } else {
            setShowGame(View.GONE);
        }
        vpTicketType.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int position) {
                vpTicketType.resetHeight(position);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
        vpTicketType.resetHeight(0);


        if (null != gametype && null != gametype.getData() && null != gametype.getData().getNavs() && gametype.getData().getNavs().size() > 0) {
            rvNavigation.setVisibility(View.VISIBLE);
        } else {
            rvNavigation.setVisibility(View.GONE);
        }
    }

    private void getGameType() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.HOMEGAMES)).
                tag(getActivity()).
                cacheKey("homeGames").
                cacheMode(CacheMode.FIRST_CACHE_THEN_REQUEST).
                execute(new NetDialogCallBack(getContext(), false, SimpleHomeFragment.this,
                        true, HomeGame.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        gametype = (HomeGame) o;
                        if (gametype != null && gametype.getCode() == 0) {
                            initFragment();
                            initNavigation();
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onCacheSuccess(Response<String> response) {
                        try {
                            gametype = new Gson().fromJson(response.body(), HomeGame.class);
                            if (gametype != null && gametype.getCode() == 0) {
                                initFragment();
                                initNavigation();
                            }
                        } catch (JsonSyntaxException e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }


    private void initNavigation() {
        if (gametype != null && gametype.getData() != null && gametype.getData().getNavs() != null && gametype.getData().getNavs().size() != 0) {
            setShow(View.VISIBLE);
            backgroupColor();
            rvNavigation.setLayoutManager(new LinearLayoutManager(getContext(), RecyclerView.HORIZONTAL, false));
            gametype.getData().getNavs().get(0).setColor(true);
            navig = new SimpleOneLevelNavigationAdapter(gametype.getData().getNavs(), getContext(), true);
            rvNavigation.setAdapter(navig);
            if (rvNavigation.getItemDecorationCount() == 0) {
                rvNavigation.addItemDecoration(new DividerGridItemDecoration(getContext(),
                        DividerGridItemDecoration.BOTH_SET, 5, 0));
            }
            navig.setListener(new SimpleOneLevelNavigationAdapter.OnClickListener() {
                @Override
                public void onClickListener(View view, int position) {
                    navPosition = position;
                    setNavPos(position);

                }
            });
        } else {
            setShow(View.GONE);
        }
    }

    private void setNavPos(int position) {

        if (position + 1 > gametype.getData().getNavs().size()) {
            return;
        }
        for (HomeGame.DataBean.NavsBean nav : gametype.getData().getNavs()) {
            nav.setColor(false);
        }
        gametype.getData().getNavs().get(position).setColor(true);
        navig.notifyDataSetChanged();
        rvNavigation.scrollToPosition(position);
    }

    //显示虚线
    private void setShow(int i) {
        view_1.setVisibility(i);
        view_2.setVisibility(i);
    }

    //显示虚线
    private void setShowGame(int i) {
        rvNavigation.setVisibility(i);
        tbTicketType.setVisibility(i);
        vpTicketType.setVisibility(i);
    }

    @Override
    public void onDestroy() {
//        OkGo.getInstance().cancelTag(getActivity());
        if (countdownView != null) {
            countdownView.cancel();
            countdownView = null;
        }
        if (mSpeech != null) {
            mSpeech.stop();
            mSpeech.shutdown();
            mSpeech = null;
        }
        super.onDestroy();
    }

    private void getOnLine() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.ONLINECOUNT)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SimpleHomeFragment.this, true, OnLineBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                OnLineBean online = (OnLineBean) o;
                if (online != null && online.getCode() == 0 && online.getData() != null && !TextUtils.isEmpty(online.getData().getOnlineSwitch()) && online.getData().getOnlineSwitch().equals("1")) {
                    if (!TextUtils.isEmpty(online.getData().getOnlineUserCount()))
                        tvOnLine.setVisibility(View.VISIBLE);
                    tvOnLine.setText("当前在线人数：" + online.getData().getOnlineUserCount());
                } else {
                    tvOnLine.setVisibility(View.GONE);
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

    private void getRanklist() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.RANKINGLIST)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SimpleHomeFragment.this, true, RanklistBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                RanklistBean rank = (RanklistBean) o;
                if (rank != null && rank.getCode() == 0 && rank.getData() != null && rank.getData().getList() != null && rank.getData().getList().size() > 0) {
                    if (llRanking.getVisibility() == View.GONE)
                        llRanking.setVisibility(View.VISIBLE);
                    if (list != null && list.size() > 0) {
                        if (recycleAuto != null)
                            recycleAuto.stopScroll();
                        list.clear();
                    }
                    if (rank.getData().getList() != null) {
                        list.addAll(rank.getData().getList());
                        for (int i = 0; i < list.size(); i++) {
                            if (i == 0) {
                                list.get(i).setImg(R.drawable.win_first);
                                list.get(i).setNum("");
                            } else if (i == 1) {
                                list.get(i).setImg(R.drawable.win_second);
                                list.get(i).setNum("");
                            } else if (i == 2) {
                                list.get(i).setImg(R.drawable.win_third);
                                list.get(i).setNum("");
                            } else {
                                list.get(i).setImg(R.drawable.win_other);
                                list.get(i).setNum(i + 1 + "");
                            }
                            list.get(i).setCoin(list.get(i).getCoin() + "元");
                        }

                        RanklistBean.DataBean.ListBean listRank = new RanklistBean.DataBean.ListBean();
                        listRank.setImg(0);
                        listRank.setCoin("");
                        listRank.setNum("");
                        listRank.setUsername("");
                        listRank.setActionTime("");
                        list.add(listRank);
                        list.add(listRank);
                        list.add(listRank);
                        list.add(listRank);
                        winUserAdapter = new WinUserAdapter(getActivity());
                        winUserAdapter.setWinUserA(list);
                        recycleAuto.setAdapter(winUserAdapter);
                        recycleAuto.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL, false));
                        recycleAuto.startScroll();
                    }
                } else {

                    llRanking.setVisibility(View.GONE);
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
    public void onStart() {
        super.onStart();
    }

    @SuppressLint("NewApi")
    @OnClick({R.id.iv_rebbag, R.id.iv_close, R.id.ll_coup, R.id.img_brain, R.id.tv_brain, R.id.tv_act, R.id.img_act, R.id.tv_draw, R.id.bt_select})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_rebbag:
                if (redBagDetilDialog != null) {
                    redBagDetilDialog.dismiss();
                    redBagDetilDialog = null;
                }
                getRedbagdetail(true);
                break;
            case R.id.iv_close:
                isRedBag = true;
                rlRedbag.setVisibility(View.GONE);
                break;
            case R.id.ll_coup:
                goFavourableActivity();
                break;
            case R.id.img_brain:
                onclickBrain();
                break;
            case R.id.tv_brain:
                onclickBrain();
                break;
            case R.id.tv_act:
                onClickAct();
//                playTTS("第1球,12号,红波,生肖鼠");
                break;
            case R.id.img_act:
                onClickAct();
                break;
            case R.id.tv_draw:
                Bundle bundle = new Bundle();
                bundle.putString("id", "70");
                bundle.putString("gameType", "lhc");
                FragmentUtilAct.startAct(getActivity(), new LotteryRecordFrag(false), bundle);
                break;
            case R.id.bt_select:
                setNavPos(navPosition += 1);
                break;
        }
    }

    private void goFavourableActivity() {
        if ((Uiutils.isSite("c049") || Uiutils.isSite("c008")) &&
                StringUtils.isEmpty(Uiutils.getToken(getContext()))) {
            getActivity().startActivity(new Intent(getActivity(), LoginActivity.class));
        } else {
            FragmentUtilAct.startAct(getActivity(), new CouponsFragment(false, false));
        }
    }

    private void onclickBrain() {
        config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null != config && null != config.getData()) {
            if (config.getData() != null && config.getData().getHost() != null) {
                Intent intent = new Intent();
                intent.setAction("android.intent.action.VIEW");
                Uri content_url = Uri.parse(config.getData().getHost().startsWith("http") ? config.getData().getHost() : "http://" + config.getData().getHost());
                intent.setData(content_url);
                startActivity(intent);
            }
        }
    }

    private void onClickAct() {
        goFavourableActivity();
    }

    @Subscribe(threadMode = ThreadMode.MAIN, sticky = true)
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("login")) {
            isRedBag = false;
            getRedbagdetail(false);
        } else if (messageEvent.getMessage().equals("config")) {
            setConfig();
        } else if (messageEvent.getMessage().equals("2")) {  //退出成功
            mState();
            checkMsg();
        } else if (messageEvent.getMessage().equals("userinfo")) {
            mState();
            checkMsg();
        }
    }


    //c085更新消息数量
    private void checkMsg() {
        if (BuildConfig.FLAVOR.equals("c085") && navig != null) {
            navig.notifyDataSetChanged();
        }
    }

    public void setTheme() {
//        Uiutils.setBa(getContext(), rvNavigation);
//        Uiutils.setBa(getContext(), rvCoup);
//        Uiutils.setBa(getContext(), seniorityLin);

        String themetyp = ShareUtils.getString(getContext(), "themetyp", "");
        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("0", themetyp) &&
                Uiutils.isSite("c203"))
            tbTicketTypeLin.setBackgroundResource(R.drawable.lottery_bck_19);
        else
            rvNavigation.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.BOTH_SET, 5,
                    0));

        if (!StringUtils.isEmpty(ShareUtils.getString(getContext(), "themetyp", ""))) {
            switch (ShareUtils.getString(getContext(), "themetyp", "")) {
                case "0":
                    setcolor(R.color.white);
                    break;
                case "2":
                    setcolor(R.color.black);
                    break;
                case "3":
                    setcolor(R.color.black);
                    break;
            }
        }

        if (null != homeDialog)
            homeDialog.setv();

        backgroupColor();
        if (navig != null)
            navig.notifyDataSetChanged();

        if (0 != ShareUtils.getInt(getContext(), "ba_top", 0)) {
            titlebar.setBackgroundColor(getResources().getColor(ShareUtils.getInt(getContext(), "ba_top", 0)));
            ivClose.setColorFilter(getResources().getColor(ShareUtils.getInt(getContext(), "ba_top", 0)));
        }

        String themeid = ShareUtils.getString(getContext(), "themetyp", "");
        if (!StringUtils.isEmpty(themeid) && StringUtils.equals("4", themeid)) {
            seniorityLin.setBackground(null);
        }


        Uiutils.setBarStye0(titlebar, getContext());

        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("0", themetyp)) {
            if (0 != ShareUtils.getInt(getContext(), "ba_tbottom", 0))
                ll_marquee.setBackgroundResource(ShareUtils.getInt(getContext(), "ba_tbottom", 0));
        }


    }

    private void setcolor(int id) {
        tvBrain.setTextColor(getContext().getResources().getColor(id));
        tvAct.setTextColor(getContext().getResources().getColor(id));

        Drawable drawable = imgBrain.getDrawable();
        drawable.setColorFilter(getContext().getResources().getColor(id), PorterDuff.Mode.SRC_ATOP);
        imgBrain.setImageDrawable(drawable);

        Drawable drawable1 = imgAct.getDrawable();
        drawable1.setColorFilter(getContext().getResources().getColor(id), PorterDuff.Mode.SRC_ATOP);
        imgAct.setImageDrawable(drawable1);
    }

    @Subscribe(sticky = true)
    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                setTheme();
                setConfig();
                break;
            case EvenBusCode.CONFIG:
                ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
                if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
                    if (config.getData().getMobileTemplateCategory().equals("4")) {
                        mSwitch();//监听开关状态
                        if (config != null && config.getData() != null) {
                            if (config.getData().isLhcdocMiCard()) {
                                switch1.setChecked(true);
                            } else {
                                switch1.setChecked(false);
                            }
                        }
                    }
                }
                break;
        }
    }

    private void backgroupColor() {
        if (0 == ShareUtils.getInt(getContext(), "ba_top", 0))
            return;

        themeColor = Integer.toHexString(getResources().getColor(ShareUtils.getInt(getContext(), "ba_top", 0)));
        if (themeColor.length() > 7) {
            themeColor = "#" + themeColor.substring(2, themeColor.length());
        } else {
            themeColor = "#" + themeColor;
        }
    }

    private void setConfig() {
        config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null != config && null != config.getData()) {
            if (config.getData() != null && config.getData().getRankingListSwitch() != null) {
                String ranking = config.getData().getRankingListSwitch();
                if (ranking.equals("1")) {   //中奖
                    llRanking.setVisibility(View.VISIBLE);
                    tvRankinglist.setText("中奖排行榜");
                } else if (ranking.equals("2")) {  //投注
                    llRanking.setVisibility(View.VISIBLE);
                    tvRankinglist.setText("投注排行榜");
                } else if (ranking.equals("0")) {
                    llRanking.setVisibility(View.GONE);
                }
            }
            if (config.getData().getM_promote_pos() != null && config.getData().getM_promote_pos().equals("1") && config.getData().getMobileMenu() != null) {
                llCouponsList.setVisibility(View.VISIBLE);
                tvAct.setText("优惠活动");
            } else if (config.getData().getM_promote_pos() != null && (config.getData().getM_promote_pos().equals("0") || config.getData().getM_promote_pos().equals("1")) && config.getData().getMobileMenu() == null) {
                llCouponsList.setVisibility(View.GONE);
            } else {
                llCouponsList.setVisibility(View.GONE);
            }
            if (config.getData().getWebName() != null) {
                tvServerName.setText("COPYRIGHT © " + config.getData().getWebName() + " RESERVED");
            }
        }
        titlebar.setTitleLeftImg(getActivity(), SPConstants.getValue(getContext(), SPConstants.SP_MOBILE_LOGO));
        mState();
    }

    private void initCoupons() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.COUPONS))//
                .tag(getActivity())//
                .execute(new NetDialogCallBack(getContext(), true, SimpleHomeFragment.this,
                        true, CouponsBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        CouponsBean coupons = (CouponsBean) o;
                        List<CouponsBean.DataBean.ListBean> list = new ArrayList<>();
                        if (coupons != null && coupons.getCode() == 0) {
                            for (int i = 0; i < coupons.getData().getList().size(); i++) {
                                int count = 5;
                                if (i >= count) {
                                    break;
                                }
                                list.add(coupons.getData().getList().get(i));
                            }

                            if (coupons.getData() != null && (coupons.getData().getList() == null || (coupons.getData().getList() != null && coupons.getData().getList().size() == 0))) {
                                llCoup.setVisibility(View.GONE);
                                rvCoup.setVisibility(View.GONE);
                            } else {
                                llCoup.setVisibility(View.VISIBLE);
                                rvCoup.setVisibility(View.VISIBLE);
                            }

                            CouponsAdapter mAdapter = new CouponsAdapter(list, getContext(), "", true);
                            LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                            layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
                            rvCoup.setLayoutManager(layoutManager);
                            rvCoup.setAdapter(mAdapter);
                            mAdapter.setListener(new CouponsAdapter.OnClickListener() {
                                @Override
                                public void onClickListener(View view, int position) {
                                    if ((Uiutils.isSite("c049") || Uiutils.isSite("c008")) &&
                                            StringUtils.isEmpty(Uiutils.getToken(getContext()))) {
                                        getActivity().startActivity(new Intent(getActivity(), LoginActivity.class));
                                        return;
                                    }

                                    CouponsBean.DataBean.ListBean bean = list.get(position);
                                    if (TextUtils.isEmpty(bean.getContent()))
                                        return;

                                    String style = coupons.getData().getStyle();
                                    if (CouponsBean.CouponStyle.popup.name().equals(style)) { //弹出窗口
                                        String[] array = {getResources().getString(R.string.affirm)};
                                        TDialog mTDialog = new TDialog(1,
                                                getActivity(),
                                                TDialog.Style.Center,
                                                array,
                                                getResources().getString(R.string.coupons),
                                                "",
                                                bean.getContent(),
                                                (object, position1) -> {

                                                });
                                        mTDialog.setCancelable(false);
                                        mTDialog.show();

                                    } else if (CouponsBean.CouponStyle.page.name().equals(style)) { //跳转界面
                                        Intent intent = null;
//                                        if (NumUtil.isContain(bean.getContent(), "img src=")) {
                                            intent = new Intent(getContext(), CouponWebActivity.class);
//                                        } else {
//                                            intent = new Intent(getContext(), RichTextActivity.class);
//                                        }
                                        intent.putExtra("url", bean.getContent());
                                        intent.putExtra(CouponsBean.DataBean.ListBean.TAG, bean);
                                        startActivityForResult(intent, 1);

                                    } else if (CouponsBean.CouponStyle.slide.name().equals(style)) { //内嵌处理
                                        bean.setSlide(!bean.isSlide());
                                        mAdapter.notifyItemChanged(position);

                                    }

                                }
                            });
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        llCoup.setVisibility(View.VISIBLE);
                        rvCoup.setVisibility(View.VISIBLE);
                    }

                    @Override
                    public void onFailed(Response<String> response) {
                        llCoup.setVisibility(View.VISIBLE);
                        rvCoup.setVisibility(View.VISIBLE);
                    }
                });
    }

    @SuppressLint("NewApi")
    private void questLotteryNum() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.LHCNUM))
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), false, this, true, LhcNumBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        LhcNumBean lhcInfo = (LhcNumBean) o;
                        if (lhcInfo != null && lhcInfo.getCode() == 0 && lhcInfo.getData() != null) {
                            sixInfoResult(lhcInfo.getData());
                            if (lhcInfo.getData().getNumbers() != null && lhcInfo.getData().getNumSx() != null) {
                                String[] zodiac;
                                String[] colors;
                                String[] nums;
                                nums = lhcInfo.getData().getNumbers().split(",");
                                zodiac = lhcInfo.getData().getNumSx().split(",");
                                colors = lhcInfo.getData().getNumColor().split(",");
                                if (isOpen && !lhcInfo.getData().isAuto()) {
                                    String content = null;
                                    String color = colors[colors.length - 1].equals("red") ? "红" : colors[colors.length - 1].equals("blue") ? "蓝" : colors[colors.length - 1].equals("green") ? "绿" : "";
                                    if (nums.length == 7) {
                                        if (isSwitch) {
                                            content = "特码已开出,请前去刮一刮";
                                        } else {
                                            content = "特码" + nums[nums.length - 1] + "号," + color + "波,生肖" + zodiac[zodiac.length - 1];
                                        }
                                    } else {
                                        content = "第" + nums.length + "球," + nums[nums.length - 1] + "号," + color + "波,生肖" + zodiac[zodiac.length - 1];
                                    }
                                    playTTS(content, nums.length);
                                }

                                if (lhcInfo.getData().getIsFinish() == 1) {  //1结束
                                    if (handler != null)
                                        handler.removeCallbacks(runnable);
                                } else if (lhcInfo.getData().getIsFinish() == 0) {
//                                    handler.postDelayed(runnable, 6000);
                                }
                                winNumberList = new ArrayList<>();
                                for (int i = 0; i < nums.length; i++) {
                                    if (i == 6) {
                                        winNumberList.add(new WinNumber("+", "", false));
                                        winNumberList.add(new WinNumber(nums.length >= (i + 1) ? nums[i] : "0", zodiac.length >= (i + 1) ? zodiac[i] : "0", false));
                                    } else {
                                        winNumberList.add(new WinNumber(nums.length >= (i + 1) ? nums[i] : "", zodiac.length >= (i + 1) ? zodiac[i] : "", false));
                                    }
                                }
                                //isSwitch 开关状态
                                if (isSwitch && winNumberList != null && winNumberList.size() == 8) {
                                    winNumberList.get(7).setHide(true);
                                }
                                mAdapter = new SixNumBallAdapter(winNumberList, getContext());
                                LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                                layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
                                rvSixNum.setLayoutManager(layoutManager);
                                rvSixNum.setAdapter(mAdapter);
                                mAdapter.setListener(new SixNumBallAdapter.OnClickListener() {
                                    @Override
                                    public void onClickListener(View view, int position) {
                                        if (position == 7 && winNumberList.get(position).isHide()) {
                                            ScratchDialog scratchDialog = new ScratchDialog(getActivity(), winNumberList.get(position).getNum(), winNumberList.get(position).getAnimal());
                                            scratchDialog.show();
                                            scratchDialog.setClicklistener(new ScratchDialog.ClickListenerInterface() {
                                                @Override
                                                public void doConfirm(Boolean isShow) {
//                                                    ToastUtil.toastShortShow(getContext(), "" + isShow);
                                                    if (isShow) {
                                                        switch1.setChecked(false);
                                                        showScratch(false);
                                                    }
                                                }
                                            });
                                        }
                                    }
                                });
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


    private void sixInfoResult(LhcNumBean.DataBean data) {
        long lotteryDay = 0;
        if (!StringUtils.isEmpty(data.getLhcdocLotteryNo())) {
            String curIssue;
            curIssue = data.getLhcdocLotteryNo();
            curIssue = "第 <font color='#FB594B'>" + curIssue + "</font>" + "期开奖结果";
            tvResult.setText(Html.fromHtml(curIssue));
        } else if (null != data.getIssue()) {
            String curIssue;
            curIssue = data.getIssue().replaceAll("2019", "").replaceAll("2020", "").replaceAll("2021", "").replaceAll("2022", "");
            curIssue = "第 <font color='#FB594B'>" + curIssue + "</font>" + "期开奖结果";
            tvResult.setText(Html.fromHtml(curIssue));
        }
        if (data.getLotteryTime() != null) {
            long timeSys = System.currentTimeMillis();
            StampToDate st = new StampToDate();
            long lotterytime = st.StampToDate(timeSys, data.getEndtime(), data.getServerTime() == null ? "0" : data.getServerTime());
            try {
                lotteryDay = StampToDate.dateToStamp(data.getEndtime());
            } catch (ParseException e) {
                e.printStackTrace();
            }
            String nextdata = "下期开奖日期：<font color='#FB594B'>" + StampToDate.stampToDates(lotteryDay, 3) + "</font>";
            if (countdownView != null) {
                countdownView.cancel();
                countdownView = null;
            }
            tvNextdata.setText(Html.fromHtml(nextdata));
            if (lotterytime <= 3600000 && !TextUtils.isEmpty(data.getLotteryStr())) {
                tvOpening.setVisibility(View.VISIBLE);
                rvSixNum.setVisibility(View.GONE);
            } else {
                tvOpening.setVisibility(View.GONE);
                rvSixNum.setVisibility(View.VISIBLE);
            }
            countdownView = new CountDownTimer(lotterytime, 1000) {
                public void onTick(long millisUntilFinished) {
                    tvCountdown.setText(getMinuteSecond(millisUntilFinished));
                }
                public void onFinish() {
                    handler.postDelayed(runnable, 6000);
                    if (mAdapter != null) {
                        mAdapter.notifyDataSetChanged();
                    }
                    tvCountdown.setText("开奖中");
                    tvOpening.setText(TextUtils.isEmpty(data.getLotteryStr()) ? "准备开奖中..." : data.getLotteryStr());

                    String curIssue;
                    curIssue = data.getIssue().replaceAll("2019", "").replaceAll("2020", "").replaceAll("2021", "").replaceAll("2022", "");
                    if (StringUtils.isEmpty(data.getLhcdocLotteryNo()) && !StringUtils.isEmpty(curIssue)) {
                        int curIssueid = Integer.parseInt(curIssue);
                        curIssue = "第 <font color='#FB594B'>" + String.format("%03d", curIssueid) + "</font>" + "期开奖结果";
                        tvResult.setText(Html.fromHtml(curIssue));
                    }
                    if (TextUtils.isEmpty(data.getNumbers()) || data.isAuto()) {
                        tvOpening.setVisibility(View.VISIBLE);
                        rvSixNum.setVisibility(View.GONE);
                    } else {
                        tvOpening.setVisibility(View.GONE);
                        rvSixNum.setVisibility(View.VISIBLE);
                    }
                }
            }.start();
            tvOpening.setText(TextUtils.isEmpty(data.getLotteryStr()) ? "" : data.getLotteryStr());
        }
    }


    boolean isSwitch = false;

    //5 黑色模板   4 六合模板
    private void template(boolean isRefresh) {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("4")) {
                mSwitch();//监听开关状态
                if (config != null && config.getData() != null) {
                    if (config.getData().isLhcdocMiCard()) {
                        switch1.setChecked(true);
                    } else {
                        switch1.setChecked(false);
                    }
                }
                llResult.setVisibility(View.VISIBLE);
                rvSixInfo.setVisibility(View.VISIBLE);
                rvNavigation.setVisibility(View.GONE);
                tbTicketTypeLin.setVisibility(View.GONE);
                vpTicketType.setVisibility(View.GONE);
                getLhcList(isRefresh);
                questLotteryNum();

                tvBrain.setTextColor(getResources().getColor(R.color.black));
                tvAct.setTextColor(getResources().getColor(R.color.black));
            } else {
                llResult.setVisibility(View.GONE);
                rvSixInfo.setVisibility(View.GONE);
                rvNavigation.setVisibility(View.VISIBLE);
                tbTicketTypeLin.setVisibility(View.VISIBLE);
                vpTicketType.setVisibility(View.VISIBLE);
                getGameType(); //真人电子体育
            }
        } else {
            llResult.setVisibility(View.GONE);
            rvSixInfo.setVisibility(View.GONE);
            rvNavigation.setVisibility(View.VISIBLE);
            tbTicketTypeLin.setVisibility(View.VISIBLE);
            vpTicketType.setVisibility(View.VISIBLE);
            getGameType(); //真人电子体育
        }
    }

    private void mSwitch() {
        switch1.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                isSwitch = b;
                showScratch(b);
            }
        });
    }

    //显示隐藏刮奖
    private void showScratch(boolean b) {
        if (winNumberList != null && winNumberList.size() == 8) {
            winNumberList.get(7).setHide(b);
        }
        if (mAdapter != null)
            mAdapter.notifyDataSetChanged();
    }

    private void getLhcList(boolean isRefresh) {
        if (!isRefresh) {
            Uiutils.setRec(getContext(), rvSixInfo, 2, R.color.my_line1);
            sixInfoAdapter = new SixInfoAdapter(getContext());
            rvSixInfo.setAdapter(sixInfoAdapter);
            sixInfoAdapter.setOnItemClickListener(new SixInfoAdapter.OnItemClickListener() {
                @Override
                public void onItemClick(View view, int position) {
                    if (!Uiutils.isFastClick())
                        return;

                    if (lhcDocBean != null && lhcDocBean.getData() != null && lhcDocBean.getData().get(position).getName() != null) {
                        Bundle build = new Bundle();
                        switch (lhcDocBean.getData().get(position).getAlias()) {
                            case "rule":
//                                if (Uiutils.getToken0(getActivity()))
//                                    return;
                                build.putInt("type", 11);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            case "sixpic":
//                                if (Uiutils.getToken0(getActivity()))
//                                    return;
                                build.putString("name", lhcDocBean.getData().get(position).getName());
//                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);

                                FragmentUtilAct.startAct(getActivity(), new LinkSixFrag(), build);
                                break;
                            case "humorGuess":
//                                if (Uiutils.getToken0(getActivity()))
//                                    return;
                                build.putInt("type", 13);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            case "rundog":
//                                if (Uiutils.getToken0(getActivity()))
//                                    return;
                                build.putInt("type", 14);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            case "fourUnlike":
//                                if (Uiutils.getToken0(getActivity()))
//                                    return;
                                build.putInt("type", 15);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            case "yellowCale":
//                                if (Uiutils.isTourist2(getActivity()))
//                                    return;
                                build.putInt("type", 16);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            case "forum":
                                FragmentUtilAct.startAct(getActivity(), new SixLotteryInfoFrament(false, lhcDocBean.getData().get(position).getName() == null ? "" : lhcDocBean.getData().get(position).getName(),
                                        lhcDocBean.getData().get(position).getAlias() == null ? "" : lhcDocBean.getData().get(position).getAlias()));
                                break;
                            case "gourmet":
                                FragmentUtilAct.startAct(getActivity(), new SixLotteryInfoFrament(false, lhcDocBean.getData().get(position).getName() == null ? "" : lhcDocBean.getData().get(position).getName(),
                                        lhcDocBean.getData().get(position).getAlias() == null ? "" : lhcDocBean.getData().get(position).getAlias()));
                                break;
                            case "mystery":
//                                FragmentUtilAct.startAct(getContext(), EachDataListFrament.getInstance(lhcDocBean.getData().get(position).getName() == null ? "" : lhcDocBean.getData().get(position).getName(),
//                                        lhcDocBean.getData().get(position).getAlias() == null ? "" : lhcDocBean.getData().get(position).getAlias()));
                                build.putInt("type", 11);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            case "sxbm":  //四肖八码
//                                private String cid;
//                                private String name00;
//                                private String id00;
//                                private String s00;


                                cid = lhcDocBean.getData().get(position).getContent_id();
                                name00 = lhcDocBean.getData().get(position).getName();
//                                cid = lhcDocBean.getData().get(position).getId();
                                s00 = "899";

                                if (!StringUtils.isEmpty(cid) && !StringUtils.equals("0", cid)) {
                                    getParticulars();
                                } else {
                                    String type;
                                    String url;
                                    String code = lhcDocBean.getData().get(position).getAppLinkCode() == null ? "" : lhcDocBean.getData().get(position).getAppLinkCode();
                                    if (TextUtils.isEmpty(code)) {
                                        type = "0";
                                    } else {
                                        type = "7";
                                    }
                                    url = lhcDocBean.getData().get(position).getAppLink() == null ? "" : lhcDocBean.getData().get(position).getAppLink();
                                    SkipGameUtil.SkipNavig(type, code, url, getContext(), "", "", "");
                                }

                                break;
                            case "tjym":  //六合寳典
                                cid = lhcDocBean.getData().get(position).getContent_id();
                                name00 = lhcDocBean.getData().get(position).getName();
//                                cid = lhcDocBean.getData().get(position).getId();
                                s00 = "907";
//                                if (!StringUtils.isEmpty(cid)&&!StringUtils.equals("0",cid))
                                if (!StringUtils.isEmpty(cid) && !StringUtils.equals("0", cid)) {
                                    getParticulars();
                                } else {
                                    String type;
                                    String url;
                                    String code = lhcDocBean.getData().get(position).getAppLinkCode() == null ? "" : lhcDocBean.getData().get(position).getAppLinkCode();
                                    if (TextUtils.isEmpty(code)) {
                                        type = "0";
                                    } else {
                                        type = "7";
                                    }
                                    url = lhcDocBean.getData().get(position).getAppLink() == null ? "" : lhcDocBean.getData().get(position).getAppLink();
                                    SkipGameUtil.SkipNavig(type, code, url.startsWith("http") ? url : BuildConfig.DOMAIN_NAME + url, getContext(), "", "", "");
                                }
//                                else
//                                    goparticulars2();
//                                goparticulars2(position, build, "907");
                                break;
                            case "ptyx":  //平特一肖
                                cid = lhcDocBean.getData().get(position).getContent_id();
                                name00 = lhcDocBean.getData().get(position).getName();
//                                cid = lhcDocBean.getData().get(position).getId();
                                s00 = "2469";
//                                if (!StringUtils.isEmpty(cid)&&!StringUtils.equals("0",cid))
                                if (!StringUtils.isEmpty(cid) && !StringUtils.equals("0", cid)) {
                                    getParticulars();
                                } else {
                                    String type;
                                    String url;
                                    String code = lhcDocBean.getData().get(position).getAppLinkCode() == null ? "" : lhcDocBean.getData().get(position).getAppLinkCode();
                                    if (TextUtils.isEmpty(code)) {
                                        type = "0";
                                    } else {
                                        type = "7";
                                    }
                                    url = lhcDocBean.getData().get(position).getAppLink() == null ? "" : lhcDocBean.getData().get(position).getAppLink();
                                    SkipGameUtil.SkipNavig(type, code, url.startsWith("http") ? url : BuildConfig.DOMAIN_NAME + url, getContext(), "", "", "");
                                }

                                break;
                            case "CvB3zABB":  //香港挂牌
                                build.putInt("type", 13);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            case "E9biHXEx": //l002美女六肖
                            case "n0v3azC0": //l002香港挂牌
                            case "mT303M99": //l002看题找肖
//                                if (Uiutils.getToken0(getActivity()))
//                                    return;
                                build.putInt("type", 19);
                                build.putString("id", lhcDocBean.getData().get(position).getId());
                                build.putString("name", lhcDocBean.getData().get(position).getName());
                                build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                break;
                            default:

                                if (lhcDocBean.getData().get(position).getThread_type() != null && lhcDocBean.getData().get(position).getThread_type().equals("2")) {
                                    build.putInt("type", 19);
                                    build.putString("id", lhcDocBean.getData().get(position).getId());
                                    build.putString("name", lhcDocBean.getData().get(position).getName());
                                    build.putString("alias", lhcDocBean.getData().get(position).getAlias());
                                    FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                    return;
                                }

                                String type;
                                String url;
                                if (!StringUtils.isEmpty(lhcDocBean.getData().get(position).getContent_id()) &&
                                        !StringUtils.equals("0", lhcDocBean.getData().get(position).getContent_id())) {
                                    cid = lhcDocBean.getData().get(position).getContent_id();
                                    name00 = lhcDocBean.getData().get(position).getName();
                                    s00 = "";
                                    if (!StringUtils.isEmpty(cid) && !StringUtils.equals("0", cid))
                                        getParticulars();
                                    else
                                        goparticulars2();
                                    break;
                                } else {
                                    String code = lhcDocBean.getData().get(position).getAppLinkCode() == null ? "" : lhcDocBean.getData().get(position).getAppLinkCode();
                                    if (TextUtils.isEmpty(code)) {
                                        type = "0";
                                    } else {
                                        type = "7";
                                    }
                                    url = lhcDocBean.getData().get(position).getAppLink() == null ? "" : lhcDocBean.getData().get(position).getAppLink();
                                    SkipGameUtil.SkipNavig(type, code, url.startsWith("http") ? url : BuildConfig.DOMAIN_NAME + url, getContext(), "", "", "");
                                }
                                break;
                        }
                    }
                }
            });
        }

        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.LHCLIST)).
                tag(getActivity()).
                cacheKey("lhcdoclist").
                cacheMode(CacheMode.FIRST_CACHE_THEN_REQUEST).
                execute(new NetDialogCallBack(getContext(), false, SimpleHomeFragment.this, true, LhcDocBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        lhcDocBean = (LhcDocBean) o;
                        if (lhcDocBean != null && lhcDocBean.getCode() == 0) {
                            initSixInfoData(lhcDocBean);
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onCacheSuccess(Response<String> response) {
                        try {
                            LhcDocBean lhcDocBean = new Gson().fromJson(response.body(), LhcDocBean.class);
                            if (lhcDocBean != null && lhcDocBean.getCode() == 0) {
                                initSixInfoData(lhcDocBean);
                            }
                        } catch (JsonSyntaxException e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }


    private String cid;
    private String name00;
    private String s00;

    private void goparticulars2() {
        Bundle build = new Bundle();
        build.putInt("type", 4);
        build.putString("main_id", "4");
        build.putString("name", name00);
        if (!StringUtils.isEmpty(cid)) {
            build.putString("id", cid);
        } else {
            build.putString("id", s00);
        }
        FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
    }

    private DetailBean dataBean;

    private void getParticulars() {
        if ((StringUtils.isEmpty(cid) && StringUtils.equals("0", cid)))
            return;

        Map<String, Object> map = new HashMap<>();
        if (StringUtils.isEmpty(cid) || StringUtils.equals("0", cid)) {
            map.put("id", s00);
        } else {
            map.put("id", cid);
        }
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CONTENTDETAIL, map, false, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                dataBean = Uiutils.stringToObject(object, DetailBean.class);

                if (null != dataBean && null != dataBean.getData()) {
                    if ((!StringUtils.isEmpty(dataBean.getData().getHasPay()) && StringUtils.equals
                            ("0", dataBean.getData().getHasPay()) &&
                            (!StringUtils.isEmpty(dataBean.getData().getPrice()) &&
                                    Double.parseDouble(dataBean.getData().getPrice()) > 0))) {
                        show(dataBean.getData().getTitle(), dataBean.getData().getPrice());
                    } else {
                        goparticulars2();
                    }
                }
            }


            @Override
            public void onError() {
            }
        });
    }

    private void show(String title, String money) {
        setPop(title, money);
    }

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;
    private CustomPopWindow mCustomPopWindow;

    private TextView title_tex;
    private TextView money_tex;

    private void setPop(String title, String money) {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.component_pop, null);
        contentView.findViewById(R.id.clear_tex).setOnClickListener(this);
        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);

        title_tex = ((TextView) contentView.findViewById(R.id.title_tex));
        money_tex = ((TextView) contentView.findViewById(R.id.money_tex));

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 300),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

        Uiutils.setText(title_tex, title);
        if (StringUtils.isEmpty(money)) {
            Uiutils.setText(money_tex, "打赏 " + 0 + " 元");
        } else {
            Uiutils.setText(money_tex, "打赏 " + money + " 元");
        }

        mCustomPopWindow = popupWindowBuilder.create();
        mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private void initSixInfoData(LhcDocBean lhcDocBean) {
        if (lhcDocBean.getData() != null && lhcDocBean.getData().size() != 0) {
            if (sixInfoList != null) {
                sixInfoList.clear();
            }
            sixInfoList.addAll(lhcDocBean.getData());
            if (sixInfoAdapter != null) {
                sixInfoAdapter.sixInfoData(sixInfoList);
                sixInfoAdapter.notifyDataSetChanged();
            }
        }
    }

    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            if (handler != null)
                handler.removeCallbacks(runnable);
            questLotteryNum();
        }
    };

    private boolean isShowAc;

    @Override
    public void onStop() {
        if (isOpen) {
            isShowAc = true;
            isOpen = false;
        }
        super.onStop();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (isShowAc) {
            isOpen = true;
        }
        isShowAc = false;
    }

    private TextToSpeech mSpeech;

    /**
     * 初始化TextToSpeech，在onCreate中调用
     */
    private void speechInit() {
        if (mSpeech != null) {
            mSpeech.stop();
            mSpeech.shutdown();
            mSpeech = null;
        }
        // 创建TTS对象
        mSpeech = new TextToSpeech(mActivity, new TTSListener());
    }

    private final class TTSListener implements TextToSpeech.OnInitListener {
        @Override
        public void onInit(int status) {
            if (status == TextToSpeech.SUCCESS) {
                int result = mSpeech.setLanguage(Locale.CHINESE);
                //如果返回值为-2，说明不支持这种语言
            }
        }
    }

    int len;
    private void playTTS(String str, int length) {
        if (mSpeech == null) mSpeech = new TextToSpeech(mActivity, new TTSListener());
        if (len == length) {  //数据一样证明播放重复  重新请求
            handler.postDelayed(runnable, 1500);
            return;
        }
        mSpeech.speak(str, TextToSpeech.QUEUE_FLUSH, null);
        len = length;
    }

}
