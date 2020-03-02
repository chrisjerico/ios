package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.speech.tts.TextToSpeech;
import androidx.annotation.NonNull;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.home.adapter.SixNumBallAdapter;
import com.phoenix.lotterys.home.bean.LhcNumBean;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.PubAttentionSonAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.CommentBean;
import com.phoenix.lotterys.my.bean.DetailBean;
import com.phoenix.lotterys.my.bean.PeriodsBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.MaxHeightRecyclerView;
import com.phoenix.lotterys.view.ScratchDialog;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.io.IOException;
import java.io.Serializable;
import java.net.URLDecoder;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 六合公共(例表)(详情)
 * 创建者: IAN
 * 创建时间: 2019/10/18 12:35
 */
public class PubAttentionDetailsFrag extends BaseFragments implements OnRefreshListener, OnLoadMoreListener,
        BaseRecyclerAdapter.OnItemClickListener, View.OnClickListener {
    @BindView(R2.id.head_img)
    ImageView headImg;
    @BindView(R2.id.name_tex)
    TextView nameTex;
    @BindView(R2.id.time_tex)
    TextView timeTex;
    @BindView(R2.id.unfriended_tex)
    TextView unfriendedTex;
    @BindView(R2.id.user_lin)
    LinearLayout userLin;
    @BindView(R2.id.tab_rec)
    RecyclerView tabRec;
    @BindView(R2.id.context_lin1)
    LinearLayout contextLin1;
    @BindView(R2.id.title_tex)
    TextView titleTex;
    @BindView(R2.id.context_tex)
    WebView contextTex;
    @BindView(R2.id.turnover_time_tex)
    TextView turnoverTimeTex;
    @BindView(R2.id.raw_night_rec)
    RecyclerView rawNightRec;
    @BindView(R2.id.vote_tex)
    TextView voteTex;
    @BindView(R2.id.comment_rec)
    RecyclerView commentRec;
    @BindView(R2.id.empty_lin)
    LinearLayout emptyLin;
    @BindView(R2.id.smart_refresh_layout)
    SmartRefreshLayout smartRefreshLayout;
    @BindView(R2.id.go_essayist_tex)
    TextView goEssayistTex;
    @BindView(R2.id.like_tex)
    TextView likeTex;
    @BindView(R2.id.go_essayist_tex1)
    TextView goEssayistTex1;
    @BindView(R2.id.attention_tex)
    TextView attentionTex;
    @BindView(R2.id.img_rec)
    MaxHeightRecyclerView imgRec;
    @BindView(R2.id.main_not_data_tex)
    RelativeLayout mainNotDataTex;
    @BindView(R2.id.data_lin)
    NestedScrollView dataLin;
    @BindView(R2.id.bootm_lin)
    LinearLayout bootmLin;
    @BindView(R2.id.tv_draw)
    TextView tvDraw;
    @BindView(R2.id.cb_show)
    CheckBox cbShow;
    @BindView(R2.id.tv_result)
    TextView tvResult;
    @BindView(R2.id.switch1)
    Switch switch1;
    @BindView(R2.id.rv_six_num)
    RecyclerView rvSixNum;
    @BindView(R2.id.tv_opening)
    TextView tvOpening;
    @BindView(R2.id.tv_nextdata)
    TextView tvNextdata;
    @BindView(R2.id.tv_countdown)
    TextView tvCountdown;
    @BindView(R2.id.ll_result)
    LinearLayout llResult;
    boolean isShow = true;
    private RecyclerView voteRec;

    @BindView(R2.id.iv_1)
    ImageView iv1;
    @BindView(R2.id.tv_content1)
    TextView tvContent1;
    @BindView(R2.id.iv_2)
    ImageView iv2;
    @BindView(R2.id.tv_content2)
    TextView tvContent2;
    @BindView(R2.id.iv_3)
    ImageView iv3;
    @BindView(R2.id.tv_content3)
    TextView tvContent3;

    public PubAttentionDetailsFrag() {
        super(R.layout.pub_attention_details_frag, true, true);
    }

    private int type;
    private PubAttentionSonAdapter tabAdapter;
    private PubAttentionSonAdapter tabAdapter1;
    private PubAttentionSonAdapter tabAdapter2;
    private PubAttentionSonAdapter tabAdapter3;
    private PubAttentionSonAdapter tabAdapter4;
    private List<Serializable> tabList = new ArrayList<>();
    private List<Serializable> tabList1 = new ArrayList<>();
    private List<Serializable> tabList2 = new ArrayList<>();
    private List<Serializable> tabList3 = new ArrayList<>();

    @Override
    public void initView(View view) {
        type2 = (String) getArguments().getString("type2");
        typeid = (String) getArguments().getString("typeid");
        id = (String) getArguments().getString("id");
        type = getArguments().getInt("type");
        initview(view);
        setPubSty();

        if (!StringUtils.isEmpty(typeid) && StringUtils.equals("4", typeid)) {
            if (type != 18) {
                id = type2;
            } else {
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.SETTITLE, "贴子详情"));
            }
            getData(true);
            getComment(true);
            dataLin.setVisibility(View.VISIBLE);
            bootmLin.setVisibility(View.VISIBLE);
            mainNotDataTex.setVisibility(View.GONE);
        } else {
            getPeriods();
        }
        setweb();
        questLotteryNum();
        llResult.setVisibility(View.VISIBLE);
        initListener(cbShow);

        //各平台定制
        showCustomized();
    }

    private void showCustomized() {
        ImageLoadUtil.ImageLoadGif(R.drawable.jt,getContext(),iv1);
        ImageLoadUtil.ImageLoadGif(R.drawable.laba,getContext(),iv2);
        ImageLoadUtil.ImageLoadGif(R.drawable.laba,getContext(),iv3);
        if(BuildConfig.FLAVOR.equals("L001")){
            tvContent1.setText( "推荐下载4988.com六合宝典APP,体验全网最快开奖查询!" );
            tvContent2.setText( "一个发帖就能赚钱的论坛,你们还在等什么呢!!!" );
            String data = "本站备用网址一:<font color='#fa0022' >" + "889777.com" + "</font>"+"本站备用网址二:<font color='#fa0022' >" + "668000.com" + "</font>截图保存相册" ;
            Spanned spanned = com.zzhoujay.html.Html.fromHtml(data);
            tvContent3.setText( spanned );
        }else if(BuildConfig.FLAVOR.equals("L002")){
            tvContent1.setText( "推荐下载70333.com王中王APP,体验全网最快开奖查询!" );
            tvContent2.setText( "一个发帖就能赚钱的论坛,你们还在等什么呢!!!" );
            String data = "本站备用网址一:<font color='#fa0022' >" + "300777.com" + "</font>"+"本站备用网址二:<font color='#fa0022' >" + "400777.com" + "</font>截图保存相册" ;
            Spanned spanned = com.zzhoujay.html.Html.fromHtml(data);
            tvContent3.setText( spanned );
        }
    }

    private void setweb() {

        WebSettings webSettings = contextTex.getSettings();
        webSettings.setJavaScriptEnabled(true);//设置java与js交互
        webSettings.setLoadWithOverviewMode(true);
        webSettings.setSupportZoom(true);
        webSettings.setBuiltInZoomControls(true);
        webSettings.setDisplayZoomControls(false);
        webSettings.setDefaultTextEncodingName("utf-8");
        webSettings.setDomStorageEnabled(true);
        contextTex.addJavascriptInterface(new MJavascriptInterface(getActivity()), "imagelistener");//将js对象与java对象进行映射
        contextTex.setWebViewClient(new WebViewClient() {
            // url拦截
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (!StringUtils.isEmpty(url)) {
                    Bundle build = new Bundle();
                    build.putString("url", url.startsWith("http") ? url : "http://" + url);
                    build.putString("title", "");
                    FragmentUtilAct.startAct(getContext(), new PubWebviewFrag(), build);
                }
                return true;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                view.getSettings().setJavaScriptEnabled(true);
                super.onPageFinished(view, url);
                view.getSettings().setBlockNetworkImage(false);
                addImageClickListener(view);//待网页加载完全后设置图片点击的监听方法
            }
        });
    }

    /**
     * 设置图片点击事件
     *
     * @param webView
     */
    private void addImageClickListener(WebView webView) {
        webView.loadUrl("javascript:(function(){" +
                "var objs = document.getElementsByTagName(\"img\"); " +
                "for(var i=0;i<objs.length;i++)  " +
                "{"
                + "    objs[i].onclick=function()  " +
                "    {  "
                + "        window.imagelistener.openImage(this.src);  " +//通过js代码找到标签为img的代码块，设置点击的监听方法与本地的openImage方法进行连接
                "    }  " +
                "}" +
                "})()");
    }

    private void setPubSty() {
        if (type == 12 || type == 13 || type == 14 || type == 15|| type == 19) {
            contextLin1.setVisibility(View.VISIBLE);
            userLin.setVisibility(View.GONE);
            voteTex.setVisibility(View.VISIBLE);
        }

        if (type == 18)
            userLin.setVisibility(View.GONE);

        if (!StringUtils.isEmpty(typeid) && (StringUtils.equals("5", typeid) || StringUtils.equals("4", typeid)
                || StringUtils.equals("8", typeid))) {
            userLin.setVisibility(View.GONE);
            titleTex.setVisibility(View.GONE);

            if (StringUtils.equals("4", typeid)) {
                tabRec.setVisibility(View.GONE);
            }
        }
//        else if (!StringUtils.isEmpty(typeid)&&StringUtils.equals("8",typeid)){
//            userLin.setVisibility(View.GONE);
//            titleTex.setVisibility(View.GONE);
//        }
    }

    private void setPop() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.vote1, null);
        contentView.findViewById(R.id.clear_tex).setOnClickListener(this);
        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);

        voteRec = contentView.findViewById(R.id.vote_rec);
        Uiutils.setRec(getContext(), voteRec, 3, R.color.white);
        tabAdapter4 = new PubAttentionSonAdapter(getContext(), tabList3, R.layout.text1, 95);
        tabAdapter4.setOnItemClickListener(this);
        voteRec.setAdapter(tabAdapter4);

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 330),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);
    }

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;
    private CustomPopWindow mCustomPopWindow;

    private String typeid;
    private String type2;
    private String id;
    private String mainId;

    private PeriodsBean periodsBean;

    private void getPeriods() {
        Map<String, Object> map = new HashMap<>();
        map.put("type", typeid);
        map.put("type2", type2);

        NetUtils.get(Constants.LHCNOLIST, map, false, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                periodsBean = Uiutils.stringToObject(object, PeriodsBean.class);

                if (null != periodsBean && null != periodsBean.getData() && null != periodsBean.getData().getList()
                        && periodsBean.getData().getList().size() > 0) {
                    if (tabList.size() > 0)
                        tabList.clear();

                    tabList.addAll(periodsBean.getData().getList());


                    if (null != tabAdapter)
                        tabAdapter.notifyDataSetChanged();

                    dataLin.setVisibility(View.VISIBLE);
                    bootmLin.setVisibility(View.VISIBLE);
                    mainNotDataTex.setVisibility(View.GONE);

//                    dataLin.setVisibility(View.GONE);
//                    bootmLin.setVisibility(View.GONE);
//                    mainNotDataTex.setVisibility(View.VISIBLE);
                }

                if (null == periodsBean || null == periodsBean.getData() || periodsBean.getData().getList().size() == 0) {
                    dataLin.setVisibility(View.GONE);
                    bootmLin.setVisibility(View.GONE);
                    mainNotDataTex.setVisibility(View.VISIBLE);
                }

                if (type == 18) {
                    if (tabList.size() > 0) {
                        if (tabList.get(0) instanceof PeriodsBean.DataBean.ListBean) {
                            for (int i = 0; i < tabList.size(); i++) {
                                PeriodsBean.DataBean.ListBean listBean = (PeriodsBean.DataBean.ListBean) tabList.get(i);
                                if (StringUtils.equals(id, listBean.getId())) {
                                    index = i;
                                    ((PeriodsBean.DataBean.ListBean) tabList.get(i)).setSelected(true);
                                    break;
                                }
                            }
                        }
                    }
                    if (null != periodsBean.getData() && !StringUtils.isEmpty(periodsBean.getData().getTitle()))
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.SETTITLE, periodsBean.getData().getTitle()));
                } else if (type == 4) {
                    if (null != periodsBean.getData() && !StringUtils.isEmpty(periodsBean.getData().getTitle()))
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.SETTITLE, periodsBean.getData().getTitle()));
                    if (tabList.size() > 0) {
                        id = periodsBean.getData().getList().get(0).getId();
                        ((PeriodsBean.DataBean.ListBean) tabList.get(0)).setSelected(true);
                    }
                } else {
                    if (tabList.size() > 0) {
                        id = periodsBean.getData().getList().get(0).getId();
                        ((PeriodsBean.DataBean.ListBean) tabList.get(0)).setSelected(true);
                    }
                }

                if (tabList.size() > 0) {
                    getData(true);
                    getComment(true);
                }
            }

            @Override
            public void onError() {
                dataLin.setVisibility(View.GONE);
                bootmLin.setVisibility(View.GONE);
                mainNotDataTex.setVisibility(View.VISIBLE);
            }
        });

    }

    private int index;

    private void initview(View view) {
        smartRefreshLayout.setOnRefreshListener(this);
        smartRefreshLayout.setOnLoadMoreListener(this);
        smartRefreshLayout.setEnableLoadMore(false);
        smartRefreshLayout.setEnableRefresh(true);

        Uiutils.setRec(getContext(), tabRec, 1, true);
        tabAdapter = new PubAttentionSonAdapter(getContext(), tabList, R.layout.tob_title_lay, 99);
        tabRec.setAdapter(tabAdapter);
        tabAdapter.setOnItemClickListener(this);

        Uiutils.setRec(getContext(), imgRec, 1);
        tabAdapter1 = new PubAttentionSonAdapter(getContext(), tabList1, R.layout.img, 98);
        imgRec.setAdapter(tabAdapter1);
        tabAdapter1.setOnItemClickListener(this::onItemClick);

        Uiutils.setRec(getContext(), commentRec, 1);
        tabAdapter2 = new PubAttentionSonAdapter(getContext(), tabList2, R.layout.comment_item1, 94);
        commentRec.setAdapter(tabAdapter2);
        commentRec.setNestedScrollingEnabled(false);

        Uiutils.setRec(getContext(), rawNightRec, 2, R.color.white);
        tabAdapter3 = new PubAttentionSonAdapter(getContext(), tabList3, R.layout.vote, 96);
        rawNightRec.setAdapter(tabAdapter3);

        setPop();
    }

    private void setSele(List<TextView> listView, int id) {
        if (null != listView && listView.size() > 0) {
            for (int i = 0; i < listView.size(); i++) {
                if (id == i) {
                    listView.get(i).setSelected(true);
                } else {
                    listView.get(i).setSelected(false);
                }
            }
        }
    }

    private DetailBean detailBean;

    private void getData(boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CONTENTDETAIL, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }

                detailBean = Uiutils.stringToObject(object, DetailBean.class);

                if (null != detailBean && null != detailBean.getData()) {

                    id = detailBean.getData().getId();

                    if (StringUtils.isEmpty(detailBean.getData().getContent()) ||
                            (!StringUtils.isEmpty(typeid) && StringUtils.equals("5", typeid))) {
                        contextTex.setVisibility(View.GONE);
                    } else {
                        contextTex.setVisibility(View.VISIBLE);
                    }
                    if (!StringUtils.isEmpty(detailBean.getData().getContent())) {
                        if (detailBean.getData().getContent().contains("<table")) {
                            contextTex.loadDataWithBaseURL(null, Uiutils.getHtmlData(detailBean.
                                    getData().getContent()), "text/html", "utf-8", null);

                        } else {
                            contextTex.loadDataWithBaseURL(null, Uiutils.getHtmlData1(detailBean.
                                    getData().getContent()), "text/html", "utf-8", null);
                        }

                        contextTex.setVisibility(View.VISIBLE);
                    } else {
                        contextTex.setVisibility(View.GONE);
                    }

                    if (!StringUtils.isEmpty(typeid) && StringUtils.equals("5", typeid))
                        contextTex.setVisibility(View.GONE);

                    if (Uiutils.isSite("l001")){
                        turnoverTimeTex.setText("本站备用网址一：www.889777.com"+"\n"+"本站备用网址二：www.668000.com");
                        turnoverTimeTex.setVisibility(View.VISIBLE);
                    }else if(Uiutils.isSite("l002")){
                        turnoverTimeTex.setText("本站备用网址一：www.300777.com"+"\n"+"本站备用网址二：www.400777.com");
                        turnoverTimeTex.setVisibility(View.VISIBLE);
                    }else{
                        if (StringUtils.isEmpty(detailBean.getData().getCreateTime())) {
                            turnoverTimeTex.setText("");
                            turnoverTimeTex.setVisibility(View.GONE);
                        }else{
                            turnoverTimeTex.setVisibility(View.VISIBLE);
                            turnoverTimeTex.setText("最后更新时间：" + Uiutils.getDateStr(detailBean.getData().getCreateTime()));
                        }

                    }

                    if (tabList1.size() > 0)
                        tabList1.clear();
                    if (null != detailBean.getData().getContentPic() && detailBean.getData().getContentPic().size() > 0) {
                        tabList1.addAll(detailBean.getData().getContentPic());

                        if (null != tabAdapter1)
                            tabAdapter1.notifyDataSetChanged();
                    }

                    if (null != detailBean.getData().getVote() && detailBean.getData().getVote().size() > 0) {
                        if (tabList3.size() > 0) {
                            tabList3.clear();
                        }
                        tabList3.addAll(detailBean.getData().getVote());
                        if (tabList3.size() > 0) {
                            rawNightRec.setVisibility(View.VISIBLE);
                            voteTex.setVisibility(View.VISIBLE);
                        } else {
                            rawNightRec.setVisibility(View.GONE);
                            voteTex.setVisibility(View.GONE);
                        }
                        if (null != tabAdapter3)
                            tabAdapter3.notifyDataSetChanged();

                        if (null != tabAdapter4)
                            tabAdapter4.notifyDataSetChanged();
                    }
//                    else{
//                        voteTex.setVisibility(View.GONE);
//                    }

                    setType();
                    if (!StringUtils.isEmpty(typeid) && StringUtils.equals("5", typeid))
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.HEXAGON_WRENCH1, detailBean.getData().getIsBigFav()));
                }
            }

            @Override
            public void onError() {
            }
        });
    }

    private void setType() {
        if (!StringUtils.isEmpty(detailBean.getData().getIsLike()) && StringUtils.equals("1",
                detailBean.getData().getIsLike())) {
            likeTex.setSelected(true);
        } else {
            likeTex.setSelected(false);
        }

        if (!StringUtils.isEmpty(detailBean.getData().getIsFav()) && StringUtils.equals("1",
                detailBean.getData().getIsFav())) {
            attentionTex.setSelected(true);
        } else {
            attentionTex.setSelected(false);
        }


        if (!StringUtils.isEmpty(detailBean.getData().getLikeNum()) && Integer.parseInt(
                detailBean.getData().getLikeNum()) > 0) {
            Uiutils.setText(likeTex, detailBean.getData().getLikeNum());
        } else {
            likeTex.setText("");
        }
        Uiutils.setText(goEssayistTex1, detailBean.getData().getReplyCount());
    }

    @OnClick({R.id.head_img, R.id.unfriended_tex, R.id.vote_tex, R.id.go_essayist_tex, R.id.like_tex,
            R.id.go_essayist_tex1, R.id.attention_tex, R.id.tv_draw})
    public void onClick(View view) {
        Bundle build = new Bundle();
        switch (view.getId()) {
            case R.id.tv_draw:
                Bundle bundle = new Bundle();
                bundle.putString("id", "70");
                bundle.putString("gameType", "lhc");
                FragmentUtilAct.startAct(getActivity(), new LotteryRecordFrag(false), bundle);
                break;
            case R.id.head_img:
                ToastUtil.toastShortShow(getContext(), "头像");
                break;
            case R.id.unfriended_tex:
                ToastUtil.toastShortShow(getContext(), "关注");
                break;
            case R.id.vote_tex:
                if (TextUtils.isEmpty(SPConstants.checkLoginInfo(getContext()))) {
                    return;
                }
                if (Uiutils.isTourist(getContext()))
                    return;

                if(tabAdapter4!=null){
                    tabAdapter4.notifyDataSetChanged();
                }
                if (null != popupWindowBuilder && null != contentView) {
                    mCustomPopWindow = popupWindowBuilder.create();
                    mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                    Uiutils.setStateColor(getActivity());
                }
                break;
            case R.id.go_essayist_tex:
                gotoEssayist(build);
                break;
            case R.id.like_tex:
                if (null != detailBean && null != detailBean.getData() && !StringUtils.isEmpty(
                        detailBean.getData().getIsLike())) {
                    if (StringUtils.equals("1", detailBean.getData().getIsLike())) {
                        setComment("0", "1", id);
                    } else {
                        setComment("1", "1", id);
                    }
                }

                break;
            case R.id.go_essayist_tex1:
                gotoEssayist(build);
                break;
            case R.id.attention_tex:
                if (null != detailBean && null != detailBean.getData()) {
                    if (!StringUtils.isEmpty(detailBean.getData().getIsFav()) && StringUtils.equals("1",
                            detailBean.getData().getIsFav())) {
                        collect(0, 2);
                    } else {
                        collect(1, 2);
                    }
                }
                break;
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
                if (animalFlag != -1)
                    gotoVote();
                break;
        }
    }

    private void gotoVote() {
        Map<String, Object> map = new HashMap<>();
        map.put("cid", id);
        map.put("animalId", animalFlag + "");
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.post(Constants.VOTE, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object, getContext());

                getData(false);
            }

            @Override
            public void onError() {

            }
        });

    }

    private void collect(int favFlag, int type) {
        Map<String, Object> map = new HashMap<>();
        map.put("favFlag", favFlag + "");
        map.put("type", type + "");
        map.put("token", Uiutils.getToken(getContext()));
        if (type == 1) {
            map.put("id", type2);
        } else {
            map.put("id", id);
        }


        NetUtils.get(Constants.DOFAVORITES, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != detailBean && null != detailBean.getData()) {
                    if (type == 1) {
                        if (favFlag == 1) {
                            detailBean.getData().setIsBigFav("1");
                        } else {
                            detailBean.getData().setIsBigFav("0");
                        }
                        if (!StringUtils.isEmpty(typeid) && StringUtils.equals("5", typeid))
                            EvenBusUtils.setEvenBus(new Even(EvenBusCode.HEXAGON_WRENCH1, detailBean.getData().getIsBigFav()));
                    } else {
                        if (favFlag == 1) {
                            detailBean.getData().setIsFav("1");
                        } else {
                            detailBean.getData().setIsFav("0");
                        }
                    }
                    setType();
                }
            }

            @Override
            public void onError() {

            }
        });

    }

    private void gotoEssayist(Bundle build) {
        build.putSerializable("type", 10);
//        build.putString("contentId", 250 + "");
        build.putString("contentId", id);
        FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        getData(false);
        page = 1;
        getComment(false);
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        getComment(false);
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        if (tabRec == parent) {
            if (index == position)
                return;

            ((PeriodsBean.DataBean.ListBean) tabList.get(position)).setSelected(true);
            ((PeriodsBean.DataBean.ListBean) tabList.get(index)).setSelected(false);

            if (null != tabAdapter)
                tabAdapter.notifyDataSetChanged();

            id = ((PeriodsBean.DataBean.ListBean) tabList.get(position)).getId();

            index = position;

            getData(true);

            getComment(true);
        } else if (voteRec == parent) {
            if (tabList3.size() > 0) {
                for (int i = 0; i < tabList3.size(); i++) {
                    if (position == i) {
                        ((DetailBean.DataBean.VoteBean) tabList3.get(i)).setSele(true);
                    } else {
                        ((DetailBean.DataBean.VoteBean) tabList3.get(i)).setSele(false);
                    }
                }
                if (null != tabAdapter4)
                    tabAdapter4.notifyDataSetChanged();

                animalFlag = ((DetailBean.DataBean.VoteBean) tabList3.get(position)).getAnimalFlag();
            }

        } else if (imgRec == parent) {
            if (tabList1.size() > 0) {
                if (tabList1.get(0) instanceof String) {
                    ArrayList<String> imglist = new ArrayList<>();
                    for (int i = 0; i < tabList1.size(); i++) {
                        imglist.add((String) tabList1.get(i));
                    }

                    if (imglist.size() > 0) {
                        Bundle bundle = new Bundle();
                        bundle.putStringArrayList("list", imglist);
                        bundle.putInt("position", position);
                        FragmentUtilAct.startAct(getActivity(), new LoadImgFrag(), bundle);
                    }
                }
            }

        }
    }

    private int animalFlag = -1;

    private int page = 1;
    private int rows = 20;

    private CommentBean commentBean;

    private void getComment(boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("page", "" + page);
        map.put("rows", "" + rows);
//        map.put("contentId",""+270);
        map.put("contentId", "" + id);
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CONTENTREPLYLIST, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }
                commentBean = Uiutils.stringToObject(object, CommentBean.class);

                if (null != commentBean && null != commentBean.getData() && null != commentBean.getData().getList()) {
                    if (page == 1)
                        tabList2.clear();

                    if (commentBean.getData().getList().size() > 0)
                        tabList2.addAll(commentBean.getData().getList());

                    if (null != tabAdapter2) {
                        tabAdapter2.notifyDataSetChanged();
                        tabAdapter2.setId(id);
                    }

                    if (tabList2.size() == 0) {
                        emptyLin.setVisibility(View.VISIBLE);
                    } else {
                        emptyLin.setVisibility(View.GONE);
                    }

                    if (tabList2.size() == commentBean.getData().getTotal()) {
                        smartRefreshLayout.setEnableLoadMore(false);
                    } else {
                        smartRefreshLayout.setEnableLoadMore(true);
                    }
                }
            }

            @Override
            public void onError() {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }
            }
        });
    }

    private void setComment(String likeFlag, String type, String rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("rid", rid);
        map.put("likeFlag", likeFlag);
        map.put("type", type);
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.LIKEPOST, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object, getContext());
                if (!StringUtils.isEmpty(type) && StringUtils.equals("2", type)) {
                    if (tabList2.size() >= commIndex) {
                        if (!StringUtils.isEmpty(((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getIsLike())) {
                            if (StringUtils.equals("1", ((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getIsLike())) {
                                ((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).setIsLike("0");
                                if (!StringUtils.isEmpty(((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getLikeNum()) &&
                                        Integer.parseInt(((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getLikeNum()) > 0) {
                                    int i = Integer.parseInt(((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getLikeNum()) - 1;
                                    ((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).setLikeNum(i + "");
                                } else {
                                    ((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).setLikeNum("");
                                }
                            } else {
                                ((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).setIsLike("1");
                                if (!StringUtils.isEmpty(((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getLikeNum())
                                        && Integer.parseInt(((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getLikeNum()) > 0) {
                                    int i = Integer.parseInt(((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).getLikeNum()) + 1;
                                    ((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).setLikeNum(i + "");
                                } else {
                                    ((CommentBean.DataBean.ListBean) tabList2.get(commIndex)).setLikeNum("1");
                                }
                            }
                        }
                    }

                    if (null != tabAdapter2)
                        tabAdapter2.notifyDataSetChanged();
                } else {
                    if (!StringUtils.isEmpty(likeFlag) && StringUtils.equals("1", likeFlag)) {
                        if (null != detailBean && null != detailBean.getData()) {
                            detailBean.getData().setIsLike("1");
                            if (!StringUtils.isEmpty(detailBean.getData().getLikeNum())) {
                                int likeNum = Integer.parseInt(detailBean.getData().getLikeNum()) + 1;
                                detailBean.getData().setLikeNum(likeNum + "");
                            } else
                                detailBean.getData().setLikeNum(1 + "");
                        }
                    } else {
                        if (null != detailBean && null != detailBean.getData()) {
                            detailBean.getData().setIsLike("0");
                            if (!StringUtils.isEmpty(detailBean.getData().getLikeNum())) {
                                int likeNum = Integer.parseInt(detailBean.getData().getLikeNum()) - 1;
                                detailBean.getData().setLikeNum(likeNum + "");
                            } else
                                detailBean.getData().setLikeNum("");
                        }
                    }
                    setType();
                }
            }

            @Override
            public void onError() {

            }
        });

    }

    private int commIndex;

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.COMMENT:
                Log.e("COMMENT===", "//");
                if (tabList2.size() >= ((Integer) even.getData())) {
                    CommentBean.DataBean.ListBean listBean = (CommentBean.DataBean.ListBean) tabList2.
                            get((Integer) even.getData());

                    if (null != listBean) {
                        commIndex = (Integer) even.getData();
                        setComment((!StringUtils.isEmpty(listBean.getIsLike()) && StringUtils.equals("1", listBean.getIsLike()))
                                ? "0" : "1", "2", listBean.getId());
                    }
                }
                break;
            case EvenBusCode.HEXAGON_WRENCH:
                if (null != detailBean && null != detailBean.getData()) {
                    if (!StringUtils.isEmpty(detailBean.getData().getIsBigFav()) && StringUtils.equals("1",
                            detailBean.getData().getIsBigFav())) {
                        collect(0, 1);
                    } else {
                        collect(1, 1);
                    }
                }
                break;
            case EvenBusCode.COMMENT2:
                page = 1;
                getComment(false);
                break;
        }
    }



    private List<WinNumber> winNumberList; //六合彩开奖数据
    boolean isSwitch = false;
    boolean isOpen = true;
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
//                            if(num.getData().getPreNum()!=null&&num.getData().getPreNumSx()!=null) {

//                            if (!StringUtils.isEmpty(lhcInfo.getData().getLotteryStr())){
//                                tvOpening.setVisibility(View.VISIBLE);
//                                rvSixNum.setVisibility(View.GONE);
//                            }else{
//                                tvOpening.setVisibility(View.GONE);
//                                rvSixNum.setVisibility(View.VISIBLE);
//                            }

                            if (lhcInfo.getData().getNumbers() != null && lhcInfo.getData().getNumSx() != null) {

                                String[] zodiac;
                                String[] colors;
                                String[]  nums;
//                                nums = num.getData().getPreNum().split(",");
//                                zodiac = num.getData().getPreNumSx().split(",");
                                nums = lhcInfo.getData().getNumbers().split(",");
                                zodiac = lhcInfo.getData().getNumSx().split(",");
                                colors = lhcInfo.getData().getNumColor().split(",");
//                                lhcInfo.getData().setAuto(false);
//                                lhcInfo.getData().setIsFinish(0);
                                Log.e("isSpeechisOpenAuto", "||" + isOpen + "||" + lhcInfo.getData().isAuto());
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
                                    Log.e("content", "" + content);
                                    playTTS(content,nums.length);
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
//                                        String s = nums.length >= (i + 1) ? nums[i] : "0";
//                                        String e = zodiac.length >= (i + 1) ? zodiac[i] : "0";

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
    private SixNumBallAdapter mAdapter;  //六合彩开奖结果
    private void sixInfoResult(LhcNumBean.DataBean data) {
        long lotteryDay = 0;
        if (!StringUtils.isEmpty(data.getLhcdocLotteryNo())){
            String curIssue;
            curIssue =data.getLhcdocLotteryNo();
            curIssue = "第 <font color='#FB594B'>" + curIssue + "</font>" + "期开奖结果";
            if (null!=tvResult)
            tvResult.setText(Html.fromHtml(curIssue));
        } else if (data.getIssue() != null) {
            String curIssue;
            curIssue = data.getIssue().replaceAll("2019", "").replaceAll("2020", "").replaceAll("2021", "").replaceAll("2022", "");
            curIssue = "第 <font color='#FB594B'>" + curIssue + "</font>" + "期开奖结果";
            if (null!=tvResult)
            tvResult.setText(Html.fromHtml(curIssue));
        }
        if (data.getLotteryTime() != null) {
            long timeSys = System.currentTimeMillis();
            Log.e("timeSys", "" + timeSys);
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
//            lotterytime = 36000;
            if (lotterytime <= 3600000 && !TextUtils.isEmpty(data.getLotteryStr())) {
                tvOpening.setVisibility(View.VISIBLE);
                rvSixNum.setVisibility(View.GONE);
//                Log.e("xxxx", "tvOpeningVISIBLE");
            } else {
                tvOpening.setVisibility(View.GONE);
                rvSixNum.setVisibility(View.VISIBLE);
            }

//            Log.e("lotterytime", "" + lotterytime);
            countdownView = new CountDownTimer(lotterytime, 1000) {
                public void onTick(long millisUntilFinished) {
                    if (0!=millisUntilFinished)
                        tvCountdown.setText(StampToDate.getMinuteSecond(millisUntilFinished));
                }

                public void onFinish() {
//                    isSpeech = true;
                    handler.postDelayed(runnable, 6000);
//                    if(isShow){
                    if (winNumberList != null) {
//                            winNumberList.clear();
//                        Log.e("lottery", "" + lotterytime);
                    }
//                    if (mAdapter != null) {
//                        mAdapter.notifyDataSetChanged();
//                    }
//                        isShow = false;
//                    }

                    tvCountdown.setText("开奖中");
                    tvOpening.setText(TextUtils.isEmpty(data.getLotteryStr()) ? "准备开奖中..." : data.getLotteryStr());

                    String curIssue;
                    curIssue =data.getIssue().replaceAll("2019", "").replaceAll("2020", "").replaceAll("2021", "").replaceAll("2022", "");
                    if (StringUtils.isEmpty(data.getLhcdocLotteryNo())&&!StringUtils.isEmpty(curIssue)) {
                        int curIssueid = Integer.parseInt(curIssue);
                        curIssue = "第 <font color='#FB594B'>" + String.format("%03d", curIssueid) + "</font>" + "期开奖结果";
                        if (null!=tvResult)
                        tvResult.setText(Html.fromHtml(curIssue));
                    }

                    if (TextUtils.isEmpty(data.getNumbers())||data.isAuto()) {
////                        Log.e("xxxx", "tvOpeningVISIBLE");
                        tvOpening.setVisibility(View.VISIBLE);
                        rvSixNum.setVisibility(View.GONE);
                    } else {
//                        Log.e("xxxx1", "tvOpeningGONE");
                        tvOpening.setVisibility(View.GONE);
                        rvSixNum.setVisibility(View.VISIBLE);
                    }
                }
            }.start();
            tvOpening.setText(TextUtils.isEmpty(data.getLotteryStr()) ? "" : data.getLotteryStr());
        }
    }
    private TextToSpeech mSpeech;
    private CountDownTimer countdownView;
    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            if (handler != null)
                handler.removeCallbacks(runnable);
            questLotteryNum();
//            handler.postDelayed(runnable, 6000);
        }
    };

    int len;
    private void playTTS(String str, int length) {
        if (mSpeech == null) mSpeech = new TextToSpeech(getContext(), new TTSListener());
        Log.i("xxxx1", "播放语音为：" + str);
        if (len==length) {  //数据一样证明播放重复  重新请求
            handler.postDelayed(runnable, 1500);
            return;
        }
        mSpeech.speak(str, TextToSpeech.QUEUE_FLUSH, null);
        len = length;
        Log.i("xxxx2", "播放语音为：" + str);
    }

    private final class TTSListener implements TextToSpeech.OnInitListener {
        @Override
        public void onInit(int status) {
            if (status == TextToSpeech.SUCCESS) {
                Log.e("xxxx1111", "初始化结果：" + (status == TextToSpeech.SUCCESS));
                int result = mSpeech.setLanguage(Locale.CHINESE);
                //如果返回值为-2，说明不支持这种语言
                Log.e("xxxx1111", "是否支持该语言：" + (result != TextToSpeech.LANG_NOT_SUPPORTED));
            }
        }
    }

    //显示隐藏刮奖
    private void showScratch(boolean b) {
        if (winNumberList != null && winNumberList.size() == 8) {
            winNumberList.get(7).setHide(b);
        }
        if (mAdapter != null)
            mAdapter.notifyDataSetChanged();
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
    private void mSwitch() {
        switch1.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                isSwitch = b;
                showScratch(b);
            }
        });
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

    private boolean isShowAc;
    @Override
    public void onStop() {
        if (isOpen){
            isShowAc =true;
            isOpen=false;
        }
        super.onStop();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (isShowAc){
            isOpen =true;
        }
        isShowAc =false;
    }


    public class MJavascriptInterface {
        private Activity context;
        private static final String TAG="SIMON";
        public MJavascriptInterface(Activity context) {
            this.context = context;
        }

        @android.webkit.JavascriptInterface
        public void openImage(String img) {
            Log.e("img==",img+"///");
            Bundle bundle = new Bundle();
            ArrayList<String> imglist = new ArrayList<>();
            imglist.add(img);
            bundle.putStringArrayList("list", imglist);
            bundle.putInt("position", 0);
            FragmentUtilAct.startAct(getActivity(), new LoadImgFrag(), bundle);
        }
    }
}
