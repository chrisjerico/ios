package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.graphics.Color;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.speech.tts.TextToSpeech;
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
import android.webkit.WebView;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.example.zhouwei.library.CustomPopWindow;
import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.home.activity.ReviewActivity;
import com.phoenix.lotterys.home.adapter.ReplyAdapter;
import com.phoenix.lotterys.home.adapter.SixNumBallAdapter;
import com.phoenix.lotterys.home.bean.BuyContent;
import com.phoenix.lotterys.home.bean.LhcNumBean;
import com.phoenix.lotterys.home.bean.PreiseBean;
import com.phoenix.lotterys.home.bean.ReplyBean;
import com.phoenix.lotterys.home.bean.SixThemeBbsDetailBean;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.PubAttentionSonAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.DetailBean;
import com.phoenix.lotterys.my.fragment.LotteryRecordFrag;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.QrBbsDialog;
import com.phoenix.lotterys.view.ScratchDialog;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.IOException;
import java.io.Serializable;
import java.net.URLDecoder;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * s
 * Greated by Luke
 * on 2019/12/1
 */

//高手论坛、极品专贴、每期资料 详情
@SuppressLint("ValidFragment")
public class SixThemeBbsDetailFrament extends BaseFragments implements BaseRecyclerAdapter.OnItemClickListener, View.OnClickListener {

    String title, id, alias;
    @BindView(R2.id.tv_createtime)
    TextView tvCreatetime;
    @BindView(R2.id.iv_head)
    ImageView ivHead;
    @BindView(R2.id.iv_bottomimg)
    ImageView ivBottomimg;
    @BindView(R2.id.tv_all)
    TextView tvAll;
    @BindView(R2.id.tv_back)
    TextView tvBack;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_date)
    TextView tvDate;
    @BindView(R2.id.iv_redbagbbs)
    ImageView ivRedbagbbs;
    @BindView(R2.id.tv_focus)
    TextView tvFocus;
    @BindView(R2.id.iv_topimg)
    ImageView ivTopimg;
    @BindView(R2.id.tv_content_title)
    TextView tvContentTitle;
    @BindView(R2.id.webview)
    WebView webview;
    @BindView(R2.id.rv_record)
    RecyclerView rvRecord;
    @BindView(R2.id.ll_data)
    LinearLayout llData;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.rl_speak)
    RelativeLayout rlSpeak;
    @BindView(R2.id.tv_praise)
    TextView tvPraise;
    @BindView(R2.id.iv_praise)
    ImageView ivPraise;
    @BindView(R2.id.tv_replay)
    TextView tvReplay;
    @BindView(R2.id.iv_replay)
    ImageView ivReplay;
    @BindView(R2.id.iv_mood)
    ImageView ivMood;
    @BindView(R2.id.ll_bt)
    LinearLayout llBt;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    @BindView(R2.id.ll_img)
    LinearLayout llImg;
    @BindView(R2.id.iv_img1)
    ImageView iv_img1;
    @BindView(R2.id.iv_img2)
    ImageView iv_img2;
    @BindView(R2.id.iv_img3)
    ImageView iv_img3;
    @BindView(R2.id.ll_info)
    LinearLayout llInfo;

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

    @BindView(R2.id.raw_night_rec)
    RecyclerView rawNightRec;
    @BindView(R2.id.vote_tex)
    TextView voteTex;

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

    int page = 1;
    List<ReplyBean.DataBean.ListBean> dataList = new ArrayList<>();
    boolean isMood = false;   //收藏
    boolean isPraise = false;   //点赞
    ReplyAdapter mAdapter;
    private String uid;
    private SixThemeBbsDetailBean.DataBean data;
    private String idPost;
    private SixThemeBbsDetailBean detail;
    boolean isShow = false;
    private PubAttentionSonAdapter tabAdapter3;
    private List<Serializable> tabList3 = new ArrayList<>();

    //    int isLoad = 0;
    @SuppressLint("ValidFragment")
    public SixThemeBbsDetailFrament(String title) {
        super(R.layout.fragment_sixtheme_bbsdetail);
        this.title = title;
    }

    public static SixThemeBbsDetailFrament getInstance(String title, String id, String alias) {
        SixThemeBbsDetailFrament sf = new SixThemeBbsDetailFrament(title);
        sf.title = title;
        sf.id = id;
        sf.alias = alias;
        return sf;
    }

    @Override
    public void initView(View view) {
        Uiutils.setBarStye0(titlebar, getContext());
        if (!TextUtils.isEmpty(alias) && alias.equals("mystery")) {
            llInfo.setVisibility(View.GONE);
        }
        if (title != null) {
            tvTitle.setText(title);
            tvContentTitle.setVisibility(title.equals("论坛详情") ? View.VISIBLE : View.GONE);
        }
        getDetail();
        getComment();
        mConfigSwitch();
        questLotteryNum();
        initListener(cbShow);

        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshLayout) {
                refreshLayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                page = 1;
//                getDetail();
                getComment();
            }
        });
        refreshLayout.setOnLoadMoreListener(new OnLoadMoreListener() {
            @Override
            public void onLoadMore(RefreshLayout refreshLayout) {
                refreshLayout.finishLoadMore(1000);      //加载完成
                page++;
//                getDetail();
                getComment();
            }
        });
        initRrply();

        Uiutils.setBarStye0(titlebar, getActivity());
//投票
        Uiutils.setRec(getContext(), rawNightRec, 2, R.color.white);
        tabAdapter3 = new PubAttentionSonAdapter(getContext(), tabList3, R.layout.vote, 96);
        rawNightRec.setAdapter(tabAdapter3);
        setPop();
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


    private void mConfigSwitch() {
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

    private void initRrply() {
        mAdapter = new ReplyAdapter(dataList, getContext(), true);
        rvRecord.setAdapter(mAdapter);
        if (rvRecord.getItemDecorationCount() == 0) {
            rvRecord.setLayoutManager(new LinearLayoutManager(getContext()));
            rvRecord.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 20, Color.rgb(255, 255, 255)));
        }
        mAdapter.setListener(new ReplyAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (dataList != null && dataList.size() != 0 && dataList.get(position).getId() != null) {
//                    DepositBean.DataBean.ListBean dp = list.get(position);
                    FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailReviewListFrament.getInstance("评论详情", id, dataList.get(position).getId(),
                            dataList.get(position).getHeadImg(), dataList.get(position).getNickname(), dataList.get(position).getActionTime(),
                            dataList.get(position).getContent(), dataList.get(position).getIsLike(), dataList.get(position).getLikeNum()));
                }
//                ToastUtils.ToastUtils("" + position, getContext());
            }

            @Override
            public void onClickItemListener(View view, int position) {
//                ToastUtils.ToastUtils("111" + position, getContext());
                if (dataList != null && dataList.size() > 0) {
                    if (!TextUtils.isEmpty(dataList.get(position).getIsLike())) {
                        if (dataList.get(position).getIsLike().equals("1")) {
                            getpraise("0", "2", dataList.get(position).getId(), position);
                        } else if (dataList.get(position).getIsLike().equals("0")) {
                            getpraise("1", "2", dataList.get(position).getId(), position);
                        }
                        mAdapter.notifyDataSetChanged();
                    }
                }
            }
        });
    }

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;
    private CustomPopWindow mCustomPopWindow;

    @OnClick({R.id.iv_head, R.id.tv_back, R.id.iv_redbagbbs, R.id.tv_focus, R.id.rl_speak, R.id.iv_praise, R.id.iv_replay, R.id.iv_mood, R.id.rl_replay,
            R.id.iv_topimg, R.id.iv_bottomimg, R.id.iv_img1, R.id.iv_img2, R.id.iv_img3, R.id.tv_draw, R.id.vote_tex})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_draw:
                Bundle bundle = new Bundle();
                bundle.putString("id", "70");
                bundle.putString("gameType", "lhc");
                FragmentUtilAct.startAct(getActivity(), new LotteryRecordFrag(false), bundle);
                break;
            case R.id.iv_head:
                if (data != null && data.getUid() != null) {
//                    FragmentUtilAct.startAct(getContext(), SixLotteryUserHomeFrament.getInstance("论坛详情", id));
                    String token = SPConstants.checkLoginInfo(getContext());
                    if (TextUtils.isEmpty(token)) {
                        return;
                    }
                    if (Uiutils.isTourist2(getContext())) {
                        return;
                    }
                    FragmentUtilAct.startAct(getActivity(), new SixLotteryUserHomeFrament(false, data.getUid(), ""));
                }
                break;
            case R.id.tv_back:
                getActivity().finish();
                break;
            case R.id.iv_redbagbbs:
                giveReward();
                break;
            case R.id.tv_focus:
                String focus = tvFocus.getText().toString().trim();
                if (focus.equals(getResources().getString(R.string.lhc_bbs_follow_change))) {
                    getFocus("0");
                } else {
                    getFocus("1");
                }
                break;
            case R.id.rl_speak:
                mJump();
                break;
            case R.id.iv_praise:
                if (isPraise) {
                    getpraise("0", "1", id, -1);
                } else {
                    getpraise("1", "1", id, -1);
                }
                break;
            case R.id.iv_replay:
                mJump();
                break;
            case R.id.iv_mood:
                if (isMood)
                    getMood("2", "0");
                else
                    getMood("2", "1");
                break;
            case R.id.rl_replay:
                mJump();
                break;
            case R.id.iv_topimg:
                if (data != null && data.getTopAdWap() != null && !TextUtils.isEmpty(data.getTopAdWap().getLink())) {
                    Log.e("getTopAdWap", "" + data.getTopAdWap().getLink());
                    SkipGameUtil.loadInnerWebviewUrl(data.getTopAdWap().getLink(), getContext(), "isHideTitle", "");
                }
                break;
            case R.id.iv_bottomimg:
                if (data != null && data.getBottomAdWap() != null && !TextUtils.isEmpty(data.getBottomAdWap().getLink())) {
                    Log.e("getBottomAdWap", "" + data.getBottomAdWap().getLink());
                    SkipGameUtil.loadInnerWebviewUrl(data.getBottomAdWap().getLink(), getContext(), "isHideTitle", "");
                }
                break;
            case R.id.iv_img1:
                mQr(0);
                break;
            case R.id.iv_img2:
                mQr(1);
                break;
            case R.id.iv_img3:
                mQr(2);
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
        }
    }

    private void mQr(int i) {
        if (data.getContentPic().length >= (i + 1)) {
            QrBbsDialog qrDialog = new QrBbsDialog(getActivity(), data.getContentPic()[i]);
            qrDialog.show();
        }
    }

    private void mJump() {
        if (TextUtils.isEmpty(SPConstants.checkLoginInfo(getContext()))) {
            return;
        }
        if (Uiutils.isTourist(getContext()))
            return;
        Bundle build = new Bundle();
        build.putSerializable("cid", id);
        build.putSerializable("rid", "");
        IntentUtils.getInstence().intent(getActivity(), ReviewActivity.class, build);

//        PubAttentionCompileFrag baseFragments = new PubAttentionCompileFrag();
//        Bundle bundle = new Bundle();
//        bundle.putString("cid",id);
//        bundle.putString("rid","");
//        baseFragments.setArguments(bundle);
////        listFrag.add(baseFragments);
//        FragmentUtilAct.startAct(getActivity(),baseFragments);

//        Bundle bundle = new Bundle();
//        bundle.putSerializable("type", 10);
////        build.putString("contentId", 250 + "");
//        bundle.putString("contentId", id);
//        FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), bundle);

    }

    private void getDetail() {
        String url;
        String token = SPConstants.getToken(getContext());
        if (TextUtils.isEmpty(token)) {
            String history = "&id=%s";
            url = Constants.CONTENTDETAIL + String.format(history, SecretUtils.DESede(id)) + "&sign=" + SecretUtils.RsaToken();
        } else {
            String history = "&token=%s&id=%s";
            url = Constants.CONTENTDETAIL + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(id)) + "&sign=" + SecretUtils.RsaToken();
        }
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBbsDetailFrament.this, true, SixThemeBbsDetailBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                detail = (SixThemeBbsDetailBean) o;
                if (detail != null && detail.getCode() == 0 && detail.getData() != null) {
                    data = detail.getData();
                    String content = data.getContent();
                    if (content != null) {
                        String temp = null;
                        for (int c = 0; c < 175; c++) {
                            String img = "<img src=\"file:///android_asset/emoji/" + (c + 1) + ".gif\" >";
                            if (temp != null) {
                                content = temp;
                            }
                            temp = content.replaceAll("\\[em_" + (c + 1) + "" + "\\]", img);
                        }
                        content = content.replaceAll("normal", "nor").replaceAll("nowrap", "nor").replaceAll("width", "wid");
                        Log.e("content", "" + content);
                        if (!content.startsWith("<p>")) {
                            content = "<p>" + content + "</p>";
                        }
                        String html = ReplaceUtil.CSS_STYLE2 + content;
                        webview.setVerticalScrollBarEnabled(false);
                        webview.setHorizontalScrollBarEnabled(false);
                        webview.getSettings().setDefaultTextEncodingName("utf -8");//设置默认为utf-8
//                        webview.loadDataWithBaseURL(null, html, "text/html", "utf-8", null);
                        if (!StringUtils.isEmpty(content) && content.contains("<table")) {
                            webview.loadDataWithBaseURL(null, Uiutils.getHtmlData(content), "text/html", "utf-8", null);
                        } else {
                            webview.loadDataWithBaseURL(null, Uiutils.getHtmlData1(content), "text/html", "utf-8", null);
                        }

                    }
//                    if (data.getCreateTime() != null) {
//                        tvCreatetime.setText("最后更新时间：" + data.getCreateTime());
//                    }

                    if (Uiutils.isSite("l001")) {
                        tvCreatetime.setText("本站备用网址一：www.889777.com" + "\n" + "本站备用网址二：www.668000.com");
                        tvCreatetime.setVisibility(View.VISIBLE);
                    } else if (Uiutils.isSite("l002")) {
                        tvCreatetime.setText("本站备用网址一：www.300777.com" + "\n" + "本站备用网址二：www.400777.com");
                        tvCreatetime.setVisibility(View.VISIBLE);
                    } else {
                        if (StringUtils.isEmpty(data.getCreateTime())) {
                            tvCreatetime.setText("");
                            tvCreatetime.setVisibility(View.GONE);
                        } else {
                            tvCreatetime.setVisibility(View.VISIBLE);
                            tvCreatetime.setText("最后更新时间：" + Uiutils.getDateStr(data.getCreateTime()));
                        }
                    }


                    if (data.getHeadImg() != null) {
                        ImageLoadUtil.loadRoundImage(ivHead, detail.getData().getHeadImg(), 0);
//                        ImageLoadUtil.toRoundCorners(R.drawable.z2,getContext(),detail.getData().getHeadImg(), ivHead);
                        ivHead.setVisibility(View.VISIBLE);
                    } else {
                        ivHead.setVisibility(View.GONE);
                    }
                    if (data.getTopAdWap() != null && data.getTopAdWap().getPic() != null) {
//                        ImageLoadUtil.ImageLoad(data.getTopAdWap().getPic(), getContext(), ivTopimg, "");
                        ImageLoadUtil.toRoundCorners(R.drawable.z2, getContext(), data.getTopAdWap().getPic(), ivTopimg);
                        ivTopimg.setVisibility(View.VISIBLE);
                    } else {
                        ivTopimg.setVisibility(View.GONE);
                    }
                    if (data.getBottomAdWap() != null && data.getBottomAdWap().getPic() != null) {
                        ImageLoadUtil.ImageLoad(data.getBottomAdWap().getPic(), getContext(),
                                ivBottomimg, "");
                        ivBottomimg.setVisibility(View.VISIBLE);
                    } else {
                        ivBottomimg.setVisibility(View.GONE);
                    }
                    if (data.getNickname() != null)
                        tvName.setText(data.getNickname());
                    if (data.getCreateTime() != null) {
                        String time = StampToDate.getlatelyTime(data.getCreateTime());
                        tvDate.setText(time.equals("") ? data.getCreateTime() : time);
                    }
                    if (data.getTitle() != null)
                        tvContentTitle.setText(data.getTitle());
                    if (data.getIsFollow() != null) {
                        if (data.getIsFollow().equals("1"))
                            tvFocus.setText("取消关注");
                        if (data.getIsFollow().equals("0"))
                            tvFocus.setText("关注楼主");
                    }
                    if (data.getIsLike() != null) {
                        if (data.getIsLike().equals("0")) {
                            ivPraise.setBackgroundResource(R.mipmap.praise);
                            isPraise = false;
                        } else {
                            ivPraise.setBackgroundResource(R.mipmap.praise_red);
                            isPraise = true;
                        }
                    }
                    if (data.getLikeNum() != null)
                        tvPraise.setText(data.getLikeNum());
                    if (data.getReplyCount() != null)
                        tvReplay.setText(data.getReplyCount());

                    if (data.getIsFav() != null) {
                        if (data.getIsFav().equals("0")) {
                            isMood = false;
                            ivMood.setBackgroundResource(R.mipmap.mood);
                        } else {
                            isMood = true;
                            ivMood.setBackgroundResource(R.mipmap.mood_red);
                        }
                    }
                    if (data.getIsFollow() != null) {
                        if (data.getIsFollow().equals("0"))
                            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow));
                        else
                            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow_change));
                    }

                    if (data.getContentPic().length > 0) {
                        for (int c = 0; c < data.getContentPic().length; c++) {
                            if (c == 0) {
//                                ImageLoadUtil.ImageLoad(data.getContentPic()[c], getContext(), iv_img1, "");
                                Glide.with(getActivity()).load(data.getContentPic()[c]).into(iv_img1);
                            } else if (c == 1) {
//                                ImageLoadUtil.ImageLoad(data.getContentPic()[c], getContext(), iv_img2, "");
                                Glide.with(getActivity()).load(data.getContentPic()[c]).into(iv_img2);
                            } else if (c == 2) {
//                                ImageLoadUtil.ImageLoad(data.getContentPic()[c], getContext(), iv_img3, "");
                                Glide.with(getActivity()).load(data.getContentPic()[c]).into(iv_img3);
                            }
                        }
                        llImg.setVisibility(View.VISIBLE);
                    } else {
                        llImg.setVisibility(View.GONE);
                    }
                    uid = TextUtils.isEmpty(data.getUid()) ? "" : data.getUid();


                    if (null != detail.getData().getVote() && detail.getData().getVote().size() > 0) {
                        if (tabList3.size() > 0) {
                            tabList3.clear();
                        }

//                        List<DetailBean.DataBean.VoteBean> voteBeans = new ArrayList<>();
//                        voteBeans = detail.getData().getVote();
                        tabList3.addAll(detail.getData().getVote());
                        if (tabList3.size() > 0) {
                            rawNightRec.setVisibility(View.VISIBLE);
                            voteTex.setVisibility(View.VISIBLE);
                        } else {
                            rawNightRec.setVisibility(View.GONE);
                            voteTex.setVisibility(View.GONE);
                        }
                        if (null != tabAdapter3)
                            tabAdapter3.notifyDataSetChanged();
                    }

                } else {
                    llData.setVisibility(View.VISIBLE);
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

    //评论列表
    private void getComment() {
        String url;
        String token = SPConstants.getToken(getContext());
//        if (TextUtils.isEmpty(token)) {
        String history = "&contentId=%s&token=%s&page=%s&rows=%s";
        url = Constants.CONTENTREPLYLIST + String.format(history, SecretUtils.DESede(id), SecretUtils.DESede(token), SecretUtils.DESede(page + ""), SecretUtils.DESede("30")) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SixThemeBbsDetailFrament.this, true, ReplyBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                isShow = true;
                ReplyBean reply = (ReplyBean) o;
                if (reply != null && reply.getCode() == 0 && reply.getData() != null) {
                    if (page == 1 && dataList != null)
                        dataList.clear();
                    dataList.addAll(reply.getData().getList());
                    if (mAdapter != null) {
                        mAdapter.notifyDataSetChanged();
                    }
                    if ((reply.getData().getList() == null || reply.getData().getList().size() < 30) && refreshLayout != null)
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法
                    if ((dataList == null || dataList.size() == 0) && llData != null) {
                        llData.setVisibility(View.VISIBLE);
                    } else if (llData != null) {
                        llData.setVisibility(View.GONE);
                    }
                } else {
                    llData.setVisibility(View.VISIBLE);
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
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBbsDetailFrament.this, true, BaseBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                BaseBean base = (BaseBean) o;
                if (base != null && base.getMsg() != null) {
                    if (base.getCode() == 0) {
                        String focus = tvFocus.getText().toString().trim();
                        if (focus.equals(getResources().getString(R.string.lhc_bbs_follow))) {
                            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow_change));
                        } else if (focus.equals(getResources().getString(R.string.lhc_bbs_follow_change))) {
                            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow));
                        }
                    }
//                    ToastUtil.toastShortShow(getContext(), base.getMsg());
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
                if (bb != null && bb.getMsg() != null) {
                    if (bb.getMsg().equals("您已关注过楼主")) {
                        String focus = tvFocus.getText().toString().trim();
                        if (focus.equals(getResources().getString(R.string.lhc_bbs_follow))) {
                            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow_change));
                        } else if (focus.equals(getResources().getString(R.string.lhc_bbs_follow_change))) {
                            tvFocus.setText(getResources().getString(R.string.lhc_bbs_follow));
                        }
                    }
                }
            }

            @Override
            public void onFailed(Response<String> response) {

            }
        });
    }

    //收藏
    private void getMood(String Favorites, String follow) {
        String url;
        String token = SPConstants.checkLoginInfo(getContext());
        if (TextUtils.isEmpty(token)) {
            return;
        }
        String history = "&token=%s&id=%s&favFlag=%s&type=%s";
        url = Constants.DOFAVORITES + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(id), SecretUtils.DESede(follow), SecretUtils.DESede(Favorites)) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBbsDetailFrament.this, true, BaseBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                BaseBean base = (BaseBean) o;
                if (base != null && base.getMsg() != null) {
//                    ToastUtil.toastShortShow(getContext(), base.getMsg());
                    if (base.getCode() == 0) {
                        isMood = isMood ? false : true;
                        if (isMood) {
                            ivMood.setBackgroundResource(R.mipmap.mood_red);
                        } else
                            ivMood.setBackgroundResource(R.mipmap.mood);
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

    Random random = new Random();

    private void giveReward() {
        String[] array = getResources().getStringArray(R.array.affirm_pay);
        View inflate;
        inflate = LayoutInflater.from(getActivity()).inflate(R.layout.alertext_pay, null);
        ImageView ivHead = (ImageView) inflate.findViewById(R.id.iv_head);
        ImageView ivImg = (ImageView) inflate.findViewById(R.id.iv_img);
        EditText etNum = (EditText) inflate.findViewById(R.id.et_num);
        if (detail != null && detail.getData() != null && detail.getData().getHeadImg() != null) {
            ImageLoadUtil.loadRoundImage(ivHead, detail.getData().getHeadImg(), 0);
        }
        setEdit(etNum);
        TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, getResources().getString(R.string.lhc_bbs_reward),
                "", ""
                , new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int pos) {
                if (pos == 1) {
//                        postContent(id, pos);
                    String money = etNum.getText().toString().trim();
                    if (money == null || money.length() == 0) {
                        ToastUtils.ToastUtils("请输入金额", getContext());
                        return;
                    }
//                    money = money.replaceAll("¥", "");
                    tipContent(money);
                }
            }
        });
        mTDialog.setMsgGravity(Gravity.CENTER);
        mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
        mTDialog.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
        mTDialog.addView(inflate);
        mTDialog.show();

        ivImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setEdit(etNum);
            }
        });
    }

    private void setEdit(EditText etNum) {
        String[] num = {"3.99", "13.14", "7.11", "9.99", "8.88", "19.99", "6.66", "18.88", "5.2", "12.12"};
        int i = random.nextInt(10);
        etNum.setText("" + num[i]);
    }

    //点赞
    private void getpraise(String likeFlag, String type, String rid, int pos) {
        String url;
        String token = SPConstants.checkLoginInfo(getContext());
        if (TextUtils.isEmpty(token)) {
            return;
        }
        String history = "&token=%s&rid=%s&likeFlag=%s&type=%s";
        url = Constants.LIKEPOST + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(rid), SecretUtils.DESede(likeFlag), SecretUtils.DESede(type)) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBbsDetailFrament.this, true, PreiseBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                PreiseBean base = (PreiseBean) o;
                if (base != null && base.getMsg() != null) {
//                    ToastUtil.toastShortShow(getContext(), base.getMsg());
                    if (base.getCode() == 0) {
                        if (type.equals("1")) {
                            isPraise = isPraise ? false : true;
                            if (isPraise) {
                                ivPraise.setBackgroundResource(R.mipmap.praise_red);
                            } else
                                ivPraise.setBackgroundResource(R.mipmap.praise);
                            tvPraise.setText(base.getData().getLikeNum() + "");
                        }
                        if (type.equals("2") && pos != -1) {
                            if (!TextUtils.isEmpty(dataList.get(pos).getIsLike())) {
                                if (dataList.get(pos).getIsLike().equals("0")) {
                                    dataList.get(pos).setIsLike("1");
//                                    dataList.get(pos).setLikeNum("1");
                                } else if (dataList.get(pos).getIsLike().equals("1")) {
                                    dataList.get(pos).setIsLike("0");
//                                    dataList.get(pos).setLikeNum("1");
                                }
                                dataList.get(pos).setLikeNum(base.getData().getLikeNum() + "");
                                if (mAdapter != null)
                                    mAdapter.notifyDataSetChanged();
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

    private void tipContent(String money) {
        String token = SPConstants.checkLoginInfo(getContext());
        if (TextUtils.isEmpty(token)) {
            return;
        }
        if (Uiutils.isTourist(getContext()))
            return;
        BuyContent content = new BuyContent();
        if (Constants.ENCRYPT)
            content.setSign(SecretUtils.RsaToken());
        content.setToken(SecretUtils.DESede(token));
        content.setCid(SecretUtils.DESede(id));
        content.setAmount(SecretUtils.DESede(money));
        Gson gson = new Gson();
        String json = gson.toJson(content);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.TIPCONTENT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getContext(), true, getActivity(),
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        if (li != null && li.getCode() == 0) {
                            ToastUtils.ToastUtils(li.getMsg(), getContext());

                        } else if (li != null && li.getCode() != 0 && li.getMsg() != null) {
                            ToastUtils.ToastUtils(li.getMsg(), getContext());
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
    public void onResume() {
        super.onResume();
        if (isShow) {
            page = 1;
            refreshLayout.setNoMoreData(false);
            getComment();
//            getDetail();
        }
        if (isShowAc) {
            isOpen = true;
        }
        isShowAc = false;
    }

    @Override
    public void onDestroy() {
//        OkGo.getInstance().cancelTag(getActivity());
        EvenBusUtils.setEvenBus(new Even(EvenBusCode.ITEMUPDATA, alias));
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


    private SixNumBallAdapter mSixAdapter;  //六合彩开奖结果
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
                                String[] nums;
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
//                                        String s = nums.length >= (i + 1) ? nums[i] : "0";
//                                        String e = zodiac.length >= (i + 1) ? zodiac[i] : "0";

                                    } else {
                                        winNumberList.add(new WinNumber(nums.length >= (i + 1) ? nums[i] : "", zodiac.length >= (i + 1) ? zodiac[i] : "", false));
                                    }

                                }
//                                Log.e("xxxxxwinNumberList", "" + winNumberList.size());

                                //isSwitch 开关状态
                                if (isSwitch && winNumberList != null && winNumberList.size() == 8) {
                                    winNumberList.get(7).setHide(true);
                                }

                                mSixAdapter = new SixNumBallAdapter(winNumberList, getContext());
                                LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                                layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
                                rvSixNum.setLayoutManager(layoutManager);
                                rvSixNum.setAdapter(mSixAdapter);
                                mSixAdapter.setListener(new SixNumBallAdapter.OnClickListener() {
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

    private void sixInfoResult(LhcNumBean.DataBean data) {
        long lotteryDay = 0;
        if (!StringUtils.isEmpty(data.getLhcdocLotteryNo())) {
            String curIssue;
            curIssue = data.getLhcdocLotteryNo();
            curIssue = "第 <font color='#FB594B'>" + curIssue + "</font>" + "期开奖结果";
            tvResult.setText(Html.fromHtml(curIssue));
        } else if (data.getIssue() != null) {
            String curIssue;
            curIssue = data.getIssue().replaceAll("2019", "").replaceAll("2020", "").replaceAll("2021", "").replaceAll("2022", "");
            curIssue = "第 <font color='#FB594B'>" + curIssue + "</font>" + "期开奖结果";
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
                    if (0 != millisUntilFinished)
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
                    curIssue = data.getIssue().replaceAll("2019", "").replaceAll("2020", "").replaceAll("2021", "").replaceAll("2022", "");
                    if (StringUtils.isEmpty(data.getLhcdocLotteryNo()) && !StringUtils.isEmpty(curIssue)) {
                        int curIssueid = Integer.parseInt(curIssue);
                        curIssue = "第 <font color='#FB594B'>" + String.format("%03d", curIssueid) + "</font>" + "期开奖结果";
                        tvResult.setText(Html.fromHtml(curIssue));
                    }

                    if (TextUtils.isEmpty(data.getNumbers()) || data.isAuto()) {
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
        if (len == length) {  //数据一样证明播放重复  重新请求
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
        if (mSixAdapter != null)
            mSixAdapter.notifyDataSetChanged();
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
        if (isOpen) {
            isShowAc = true;
            isOpen = false;
        }
        super.onStop();
    }

    private PubAttentionSonAdapter tabAdapter4;
    private RecyclerView voteRec;

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
                if (animalFlag != -1)
                    gotoVote();
                break;
        }
    }

    private int animalFlag = -1;

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
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
                getDetail();
            }

            @Override
            public void onError() {

            }
        });

    }

}
