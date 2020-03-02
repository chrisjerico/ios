package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.Uri;
import com.google.android.material.tabs.TabLayout;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.cache.CacheMode;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.coupons.CouponsFragment;
import com.phoenix.lotterys.coupons.adapter.CouponsAdapter;
import com.phoenix.lotterys.coupons.bean.CouponsBean;
import com.phoenix.lotterys.home.adapter.BlackViewpagerPagerAdapter;
import com.phoenix.lotterys.home.adapter.WinUserAdapter;
import com.phoenix.lotterys.home.bean.BannerBean;
import com.phoenix.lotterys.home.bean.OnLineBean;
import com.phoenix.lotterys.home.bean.RedBagBean;
import com.phoenix.lotterys.home.bean.RedBagDetailBean;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.main.bean.RanklistBean;
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GlideImageLoader;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.view.MarqueeView;
import com.phoenix.lotterys.view.RedBagDetilDialog;
import com.phoenix.lotterys.view.SignViewPager;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.youth.banner.Banner;
import com.youth.banner.listener.OnBannerListener;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/10/31
 */
public class BlackHomeFrament extends BaseFragment {

    @BindView(R2.id.tb_ticket_type_lin)
    RelativeLayout tb_ticket_type_lin;
    @BindView(R2.id.tv_on_line)
    TextView tvOnLine;
    @BindView(R2.id.home_banner)
    Banner homeBanner;

    List<Fragment> fragmentList;
    @BindView(R2.id.tb_ticket_type)
    TabLayout tbTicketType;
    @BindView(R2.id.vp_ticket_type)
    SignViewPager vpTicketType;
    @BindView(R2.id.rl_redbag)
    RelativeLayout rlRedbag;
    @BindView(R2.id.iv_rebbag)
    ImageView ivRebbag;
    @BindView(R2.id.iv_close)
    ImageView ivClose;
    private BannerBean banner;
    private RedBagDetailBean redbagdetail;
    private RedBagDetilDialog redBagDetilDialog;
    boolean isRedBag = false;
    @BindView(R2.id.ll_ranking)
    LinearLayout llRanking;
    @BindView(R2.id.recycleAuto)
    MarqueeView recycleAuto;
    WinUserAdapter winUserAdapter;
    @BindView(R2.id.tv_rankinglist)
    TextView tvRankinglist;
    @BindView(R2.id.ll_coupons_list)
    LinearLayout llCouponsList;
    @BindView(R2.id.tv_brain)
    TextView tvBrain;
    @BindView(R2.id.tv_act)
    TextView tvAct;
    ConfigBean config;
    @BindView(R2.id.tv_server_name)
    TextView tvServerName;
    @BindView(R2.id.ll_coup)
    LinearLayout llCoup;
    List<RanklistBean.DataBean.ListBean> list = new ArrayList<>();

    public static BlackHomeFrament getInstance() {
        return new BlackHomeFrament();
    }

    public BlackHomeFrament() {
        super(R.layout.fragment_black_home, true);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void initView(View view) {
        getGameType();
        setConfig();
        initBanner();//
        getOnLine();
        getRanklist();
        getRedbagdetail(false); //红包
        initCoupons();
    }

    private void initBanner() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.BANNER)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, BlackHomeFrament.this,
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
                if (banner != null && banner.getCode() == 0 && banner.getData() != null &&
                        banner.getData().getList().size() != 0 && !TextUtils.isEmpty(banner.getData().getList().get(position).getUrl())) {
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
                    if (linkCategory.equals("0") && url.equals("")) {
                        return;
                    }

                    SkipGameUtil.SkipNavig(linkCategory, linkPosition, url, getContext(), lotteryGameType, realIsPopup, realSupportTrial);
                }
            }
        });
    }

    private void getOnLine() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.ONLINECOUNT)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, BlackHomeFrament.this, true, OnLineBean.class) {
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

    private void getGameType() {
//        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.CUSTOMGAMETYPE)).  //老接口
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.HOMEGAMES)).
                tag(getActivity()).
                cacheKey("homeGames").
                cacheMode(CacheMode.FIRST_CACHE_THEN_REQUEST).
                execute(new NetDialogCallBack(getContext(), false, BlackHomeFrament.this,
                        true, HomeGame.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        HomeGame gametype = (HomeGame) o;
                        if (gametype != null && gametype.getCode() == 0) {
                            initFragment(gametype);
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onCacheSuccess(Response<String> response) {
                        try {
                            HomeGame gt = new Gson().fromJson(response.body(), HomeGame.class);
                            if (gt != null && gt.getCode() == 0) {
                                initFragment(gt);
                            }
                        } catch (JsonSyntaxException e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
//        OkGo.getInstance().cancelTag(this);
    }

    private void initFragment(HomeGame gametype) {
        fragmentList = new ArrayList<>();
        GamesCustomFragment gamesfragment;
        for (int t = 0; t < gametype.getData().getIcons().size(); t++) {
            gamesfragment = new GamesCustomFragment(gametype.getData().getIcons().get(t), t);
            gamesfragment.setSignViewPager(vpTicketType);
            fragmentList.add(gamesfragment);
        }
        BlackViewpagerPagerAdapter myViewpagerPagerAdapter = new BlackViewpagerPagerAdapter(this.getChildFragmentManager(), fragmentList, getActivity(), gametype);
        myViewpagerPagerAdapter.setSignViewPager(vpTicketType);
        vpTicketType.setAdapter(myViewpagerPagerAdapter);
//        Uiutils.setMyBa(getContext(), tbTicketType);
        tbTicketType.setupWithViewPager(vpTicketType);
        for (int i = 0; i < gametype.getData().getIcons().size(); i++) {
            tbTicketType.getTabAt(i).setCustomView(myViewpagerPagerAdapter.getCustomView(i));
        }
        if (tbTicketType.getTabCount() != 0) {
            tbTicketType.getTabAt(0).getCustomView().findViewById(R.id.tv_name).setSelected(true);

            tbTicketType.getTabAt(0).getCustomView().findViewById(R.id.iv_icon1).setVisibility(View.VISIBLE);
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
                showTrigon(gametype, position);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
        vpTicketType.resetHeight(0);
    }

    private void showTrigon(HomeGame gametype, int position) {
        for (int i = 0; i < gametype.getData().getIcons().size(); i++) {
            tbTicketType.getTabAt(i).getCustomView().findViewById(R.id.iv_icon1).setVisibility(View.GONE);
        }
        tbTicketType.getTabAt(position).getCustomView().findViewById(R.id.iv_icon1).setVisibility(View.VISIBLE);
    }

    private void getRedbagdetail(boolean isLogin) {
        String token = SPConstants.getToken(getActivity());
        String url = null;
        if (TextUtils.isEmpty(token)) {
            url = Constants.REDBAGDETAIL;
        } else
            url = Constants.REDBAGDETAIL + "&token=" + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, BlackHomeFrament.this,
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

    //显示虚线
    private void setShowGame(int i) {
        tbTicketType.setVisibility(i);
        vpTicketType.setVisibility(i);
    }

    private void getRanklist() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.RANKINGLIST)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, BlackHomeFrament.this, true, RanklistBean.class) {
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
                            list.get(i).setCoin(list.get(i).getCoin()+"元");
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
                    LinearLayout.LayoutParams linearParams = (LinearLayout.LayoutParams) llRanking.getLayoutParams(); //取控件textView当前的布局参数 linearParams.height = 20;// 控件的高强制设成20
                    linearParams.height = 0;// 控件的宽强制设成30
                    llRanking.setLayoutParams(linearParams); //使设置好的布局参数应用到控件
//                    llRanking.setVisibility(View.GONE);
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
//                tvAct.setText("优惠活动");
            } else if (config.getData().getM_promote_pos() != null && (config.getData().getM_promote_pos().equals("0") || config.getData().getM_promote_pos().equals("1")) && config.getData().getMobileMenu() == null) {
                llCouponsList.setVisibility(View.GONE);
            } else {
                llCouponsList.setVisibility(View.GONE);
            }
            if (config.getData().getWebName() != null) {
                tvServerName.setText("COPYRIGHT © " + config.getData().getWebName() + " RESERVED");
            }
        }

//        titlebar.setTitleLeftImg(getActivity(), SPConstants.getValue(getContext(), SPConstants.SP_MOBILE_LOGO));
//        mState();
    }


    @BindView(R2.id.rv_coup)
    RecyclerView rvCoup;

    private void initCoupons() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.COUPONS))//
                .tag(getActivity())//
                .execute(new NetDialogCallBack(getContext(), true, BlackHomeFrament.this,
                        true, CouponsBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        CouponsBean coupons = (CouponsBean) o;
                        List<CouponsBean.DataBean.ListBean> list = new ArrayList<>();
                        if (coupons != null && coupons.getCode() == 0) {
                            for (int i = 0; i < coupons.getData().getList().size(); i++) {
                                if (i >= 3) {
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

                            CouponsAdapter mAdapter = new CouponsAdapter(list, getContext(), "5");
                            LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                            layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
                            rvCoup.setLayoutManager(layoutManager);
                            rvCoup.setAdapter(mAdapter);
                            mAdapter.setListener(new CouponsAdapter.OnClickListener() {
                                @Override
                                public void onClickListener(View view, int position) {
                                    if (TextUtils.isEmpty(list.get(position).getContent()))
                                        return;
                                    Intent intent = null;
//                                    if (NumUtil.isContain(list.get(position).getContent(), "img src=")) {
                                    intent = new Intent(getContext(), GoWebActivity.class);
//                                    } else {
//                                        intent = new Intent(getContext(), RichTextActivity.class);
//                                    }
                                    String data = list.get(position).getContent().replaceAll("nowrap", "nowrap1");
                                    intent.putExtra("url", data);
//                                    Log.e("url", list.get(position).getContent() + "");
                                    startActivityForResult(intent, 1);

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

    protected void onTransformResume() {
//        Log.e("onTransformResume1", "onTransformResume");
        setConfig();
    }

    @OnClick({R.id.iv_rebbag, R.id.iv_close, R.id.ll_coup, R.id.img_brain, R.id.tv_brain, R.id.tv_act, R.id.img_act})
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
                FragmentUtilAct.startAct(getActivity(), new CouponsFragment(false, false));
                break;
            case R.id.img_brain:
                onclickBrain();
                break;
            case R.id.tv_brain:
                onclickBrain();
                break;
            case R.id.tv_act:
                onClickAct();
                break;
            case R.id.img_act:
                onClickAct();
                break;


        }
    }

    private void onclickBrain() {
        config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null != config && null != config.getData()) {
            if (config.getData() != null && config.getData().getHost() != null) {
//                SkipGameUtil.loadUrl(config.getData().getHost(), getActivity());
                Intent intent = new Intent();
                intent.setAction("android.intent.action.VIEW");
                Uri content_url = Uri.parse(config.getData().getHost().startsWith("http") ? config.getData().getHost() : "http://" + config.getData().getHost());
                intent.setData(content_url);
                startActivity(intent);

            }
        }
    }

    private void onClickAct() {
        FragmentUtilAct.startAct(getActivity(), new CouponsFragment(false, false));
    }


    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.LOGIN:  //登录并获取信息
                setConfig();
                break;
        }
    }


}
