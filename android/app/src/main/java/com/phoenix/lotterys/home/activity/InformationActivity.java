package com.phoenix.lotterys.home.activity;

import android.content.Intent;
import android.graphics.Color;
import android.os.Handler;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.buyhall.activity.TicketDetailsActivity;
import com.phoenix.lotterys.buyhall.adapter.NiuNumberAdapter;
import com.phoenix.lotterys.buyhall.adapter.WinNumberAdapter;
import com.phoenix.lotterys.buyhall.bean.LotteryNumBean;
import com.phoenix.lotterys.buyhall.bean.TicketDetails;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.helper.OpenHelper;
import com.phoenix.lotterys.home.adapter.BbsListAdapter;
import com.phoenix.lotterys.home.adapter.BbsTypeAdapter;
import com.phoenix.lotterys.home.bean.Bbs;
import com.phoenix.lotterys.home.bean.BbsDetails;
import com.phoenix.lotterys.home.bean.BbsInfoListBean;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.MyitemAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.MyLayoutManager;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import cn.iwgang.countdownview.CountdownView;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/9/12
 */
public class InformationActivity extends BaseActivitys {
    @BindView(R2.id.rl_title)
    RelativeLayout rlTitle;
    @BindView(R2.id.tv_titleopen)
    TextView tvTitleopen;
    @BindView(R2.id.tv_titleclose)
    TextView tvTitleclose;
    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.et_search)
    EditText etSearch;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.tv_ticket_number)
    TextView tvTicketNumber;
    @BindView(R2.id.rv_win_number)
    RecyclerView rvWinNumber;
    @BindView(R2.id.rv_niu_number)
    RecyclerView rvNiuNumber;
    @BindView(R2.id.tv_ticket_number_next)
    TextView tvTicketNumberNext;
    @BindView(R2.id.tv_close_count_down)
    CountdownView tvCloseCountDown;
    @BindView(R2.id.tv_open_time)
    CountdownView tvOpenTime;
    @BindView(R2.id.tv_close)
    TextView tvClose;
    @BindView(R2.id.tv_opening)
    TextView tvOpening;
    WinNumberAdapter winNumberAdapter;
    List<WinNumber> winNumberList;
    @BindView(R2.id.ll_left)
    LinearLayout llLeft;
    @BindView(R2.id.rv_info)
    RecyclerView rvInfo;
    @BindView(R2.id.main_rel)
    RelativeLayout mainRel;
    @BindView(R2.id.ll_titleseek)
    LinearLayout llTitleseek;
    @BindView(R2.id.ll_titlebg)
    LinearLayout llTitlebg;
    private TicketDetails td;
    private long lastClickTime = 0L;
    private long lotterytime = 0L;
    private LotteryNumBean lotteryNum;
    int page = 1;
    private String URLPATH = "page=%s&rows=%s&category=%s";
    private String KEYWORD = "page=%s&rows=%s&title=%s";
    List<BbsInfoListBean.DataBean.ListBean> bbsList = new ArrayList<>();
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    private BbsListAdapter mAdapter;
    boolean isType;
    String search;
    private WebView webview;

    public InformationActivity() {
        super(R.layout.activity_information);
    }

    @Override
    public void getIntentData() {
        String ticketDetails = getIntent().getStringExtra("ticketDetails");
        td = new Gson().fromJson(ticketDetails, TicketDetails.class);
    }

    @Override
    public void initView() {
        if (StringUtils.equals("0",ShareUtils.getString(this, "themetyp", ""))){
            mainRel.setBackgroundColor(getResources().getColor(R.color.my_line));
        }
        if (td == null)
            return;
        tvTitle.setText(td.getTitle() == null ? "" : td.getTitle());
        mAdapter = new BbsListAdapter(bbsList, InformationActivity.this);
        LinearLayoutManager layoutManager = new LinearLayoutManager(InformationActivity.this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvInfo.addItemDecoration(new SpacesItemDecoration(InformationActivity.this));
        rvInfo.setLayoutManager(layoutManager);
        rvInfo.setAdapter(mAdapter);
        mAdapter.setListener(new BbsListAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                getReadDetail(bbsList.get(position).getId());
            }
        });
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(true);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                isType = true;
                search = "";
                page = 1;
                getBbsData();
                etSearch.setText("");
            }
        });
        refreshLayout.setOnLoadMoreListener(new OnLoadMoreListener() {
            @Override
            public void onLoadMore(RefreshLayout refreshLayout) {
                refreshLayout.finishLoadMore(1000);      //加载完成
                page++;
                getBbsData();
            }
        });
        isType = true;
        search = "";
        getBbsData();
        questLotteryNum(true);
        setTheme();
    }

    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(InformationActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(InformationActivity.this, llTitleseek, false, null);
                Uiutils.setBaColor(InformationActivity.this, llTitlebg, false, null);
                Uiutils.setBaColor(InformationActivity.this, mainRel);
                tvTicketNumber.setTextColor(getResources().getColor(R.color.font));
                tvTitleopen.setTextColor(getResources().getColor(R.color.font));
                tvTitleclose.setTextColor(getResources().getColor(R.color.font));
                tvTicketNumberNext.setTextColor(getResources().getColor(R.color.font));
                tvData.setTextColor(getResources().getColor(R.color.font));
                etSearch.setTextColor(getResources().getColor(R.color.font));
                etSearch.setHintTextColor(getResources().getColor(R.color.ba_bottom_21));
            }else {
                mainRel.setBackgroundColor(getResources().getColor(R.color.white));
            }
        }else {
            mainRel.setBackgroundColor(getResources().getColor(R.color.white));
        }
    }

    private void getBbsData() {
        if (td.getId() != null) {
            if (!isType && TextUtils.isEmpty(search))
                return;
            OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.BBSLIST + (isType ? String.format(URLPATH, SecretUtils.DESede(page + ""), SecretUtils.DESede("20"), SecretUtils.DESede(td.getId())) : String.format(KEYWORD, SecretUtils.DESede(page + ""), SecretUtils.DESede("20"), SecretUtils.DESede(search))) + "&sign=" + SecretUtils.RsaToken()))//
                    .tag(this)//
                    .execute(new NetDialogCallBack(this, false, this, true, BbsInfoListBean.class) {
                        @Override
                        public void onUi(Object o) throws IOException {
                            BbsInfoListBean bbslist = (BbsInfoListBean) o;
                            if (bbslist != null && bbslist.getCode() == 0 && bbslist.getData() != null && bbslist.getData().getList() != null) {

                                if (page == 1 && bbsList != null)
                                    bbsList.clear();
                                bbsList.addAll(bbslist.getData().getList());
                                if (mAdapter != null)
                                    mAdapter.notifyDataSetChanged();

                                if (bbslist.getData().getList() == null || bbslist.getData().getList().size() == 0)
                                    refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法

                                if (bbsList == null || bbsList.size() == 0) {
                                    tvData.setVisibility(View.VISIBLE);
                                } else {
                                    tvData.setVisibility(View.GONE);
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
    }

    private void getReadDetail(String id) {
        String token = SPConstants.checkLoginInfo(InformationActivity.this);
        String readDetail = "id=%s&token=%s";
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.BBSDETAILS + String.format(readDetail, SecretUtils.DESede(id), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken()))//
                .tag(this)//
                .execute(new NetDialogCallBack(this, true, this, true, BbsDetails.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BbsDetails bbsdetails = (BbsDetails) o;
                        if (bbsdetails != null && bbsdetails.getCode() == 0 && bbsdetails.getData() != null) {
                            bbsDialog(bbsdetails.getData(), id);
//                            Log.e("xxxxxbbsdetails", "bbsdetails");
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

    private void getPayBbsInfo(String id) {
        String token = SPConstants.checkLoginInfo(InformationActivity.this);
        Bbs bbs = new Bbs();
        bbs.setId(SecretUtils.DESede(id));
        if (!TextUtils.isEmpty(token)) {
            bbs.setToken(SecretUtils.DESede(token));
        }
        bbs.setSign(SecretUtils.RsaToken());
        Gson gson = new Gson();
        String json = gson.toJson(bbs);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.BBSDETAILSPAY + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(this, true, InformationActivity.this,
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        if (li != null && li.getCode() == 0 && !TextUtils.isEmpty(li.getMsg())) {
                            ToastUtils.ToastUtils(li.getMsg(), InformationActivity.this);
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

    private void bbsDialog(BbsDetails.DataBean data, String id) {
        int type = -1;
        String[] array = getResources().getStringArray(R.array.affirm_change);
        String[] hint_list = getResources().getStringArray(R.array.hint_list);
        View inflate;
        if (data.getCode() == 0) {
            inflate = LayoutInflater.from(InformationActivity.this).inflate(R.layout.alertext_web, null);
            webview = (WebView) inflate.findViewById(R.id.webview);
            webview.loadDataWithBaseURL(null, ReplaceUtil.getHtmlFormat1(data.getContent() == null ? "" : data.getContent(), data.getHeader() == null ? "" : data.getHeader(), data.getFooter() == null ? "" : data.getFooter(), data.isHasPay() ? data.getHasPayTip() == null ? "" : data.getHasPayTip() : ""), "text/html", "utf-8", null);
        } else {
            inflate = LayoutInflater.from(InformationActivity.this).inflate(R.layout.alertext_bbs, null);
//            if (TextUtils.isEmpty(data.getReason()))
//                return;
            if (data.getReason() != null && data.getReason().equals("needLogin")) {  //需要登录：但没有登录
                ((LinearLayout) inflate.findViewById(R.id.ll_reason)).setVisibility(View.VISIBLE);
                ((LinearLayout) inflate.findViewById(R.id.ll_reward)).setVisibility(View.GONE);
                TextView tvReason = (TextView) inflate.findViewById(R.id.tv_reason);
                tvReason.setText(getResources().getText(R.string.login_readbbs));
                type = 1;
            } else if (data.getReason() != null && data.getReason().equals("needReg")) {// 已登录：但非正式会员
                ((LinearLayout) inflate.findViewById(R.id.ll_reason)).setVisibility(View.VISIBLE);
                ((LinearLayout) inflate.findViewById(R.id.ll_reward)).setVisibility(View.GONE);
                TextView tvReason = (TextView) inflate.findViewById(R.id.tv_reason);
                tvReason.setText(getResources().getText(R.string.due_readbbs));
                type = 1;
            } else if (data.getReason() != null && data.getReason().equals("needPay")) { // 已登录、且是正式会员，但需要支付
                ((LinearLayout) inflate.findViewById(R.id.ll_reason)).setVisibility(View.GONE);
                ((LinearLayout) inflate.findViewById(R.id.ll_reward)).setVisibility(View.VISIBLE);
                WebView webview_pay = (WebView) inflate.findViewById(R.id.webview_nopay);
                TextView tvContent = (TextView) inflate.findViewById(R.id.tv_content);
//                TextView tvNotpay = (TextView) inflate.findViewById(R.id.tv_notpay);
                tvContent.setText("打赏" + data.getAmount() == null ? "" : data.getAmount() + "元");
                webview_pay.loadDataWithBaseURL(null, ReplaceUtil.getHtmlFormat("", data.getNotPayTip() == null ? "" : data.getNotPayTip(), "", ""), "text/html", "utf-8", null);
                type = 2;
            }
        }
        int finalType = type;
        TDialog mTDialog = new TDialog(InformationActivity.this, TDialog.Style.Center, array, hint_list[0],
                "", ""
                , new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int pos) {
                if (finalType == 1 && pos == 1)
//                    startActivity(new Intent(InformationActivity.this, LoginActivity.class));
                Uiutils.login(InformationActivity.this);
                else if (finalType == 2 && pos == 1)
                    getPayBbsInfo(id);
                if (webview != null) {
                    webview.destroy();
                    webview = null;
                }

            }
        });
        mTDialog.setMsgGravity(Gravity.CENTER);
        mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
        mTDialog.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
        mTDialog.addView(inflate);
        mTDialog.show();

    }

    private void questLotteryNum(boolean isRefresh) {
        if (handler != null)
            handler.removeCallbacks(runnable);

        tvClose.setVisibility(View.GONE);
        tvCloseCountDown.setVisibility(View.VISIBLE);
        tvOpening.setVisibility(View.GONE);
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.LOTTERYNUM + SecretUtils.DESede(td.getGameId()) + "&sign=" + SecretUtils.RsaToken()))//
                .tag(this)//
                .execute(new NetDialogCallBack(this, false, this, true, LotteryNumBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        lotteryNum = (LotteryNumBean) o;
                        setNumData(isRefresh);
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }


    private void setNumData(boolean isRefresh) {
        try {
            if (lotteryNum != null && lotteryNum.getCode() == 0 && lotteryNum.getData() != null) {
//                tvTitle.setText(lotteryNum.getData().getTitle() == null ? "" : lotteryNum.getData().getTitle());
                setLotteryData();
                winNumberAdapter = new WinNumberAdapter(winNumberList, td.getGameId(), td.getGameType(), InformationActivity.this);
                MyLayoutManager layout = new MyLayoutManager();
                //必须，防止recyclerview高度为wrap时测量item高度0
                layout.setAutoMeasureEnabled(true);
                rvWinNumber.setLayoutManager(layout);
                rvWinNumber.setAdapter(winNumberAdapter);
                tvTicketNumberNext.setText(lotteryNum.getData().getCurIssue() + " 期");
                tvTicketNumber.setText(lotteryNum.getData().getPreIssue() + " 期");
                //倒计时
                mCountdown(isRefresh);

                if (td.getGameType().equals("pk10nn")) {
                    String[] niu = lotteryNum.getData().getPreResult().split(","); // 分割字符串
                    NiuNumberAdapter rvNiuAdapter = new NiuNumberAdapter(niu, lotteryNum.getData().getWinningPlayers(), InformationActivity.this);
                    LinearLayoutManager layoutManager = new LinearLayoutManager(InformationActivity.this);
                    layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
                    rvNiuNumber.setLayoutManager(layoutManager);
                    rvNiuNumber.setAdapter(rvNiuAdapter);
                    rvNiuNumber.setVisibility(View.VISIBLE);
                } else {
                    rvNiuNumber.setVisibility(View.GONE);
                }

            } else if (lotteryNum != null && lotteryNum.getCode() != 0 && lotteryNum.getMsg() != null) {
                ToastUtils.ToastUtils(lotteryNum.getMsg(), InformationActivity.this);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //倒计时
    private long timeSys;

    private void mCountdown(boolean isRefresh) {
        timeSys = System.currentTimeMillis();
        StampToDate st = new StampToDate();
        lotterytime = st.StampToDate(lotteryNum.getData().getCurOpenTime(), lotteryNum.getData().getServerTimestamp()==null?"0":lotteryNum.getData().getServerTimestamp(), timeSys);    //开奖时间
        lastClickTime = st.StampToDate(lotteryNum.getData().getCurCloseTime(), lotteryNum.getData().getServerTimestamp()==null?"0":lotteryNum.getData().getServerTimestamp(), timeSys);   //封盘时间
        //封盘时间
        if (lastClickTime > 0) {
            tvCloseCountDown.start(lastClickTime);
            tvCloseCountDown.setOnCountdownEndListener(new CountdownView.OnCountdownEndListener() {
                @Override
                public void onEnd(CountdownView cv) {
                    tvClose.setVisibility(View.VISIBLE);
                    tvCloseCountDown.setVisibility(View.GONE);
//                    llMc.setVisibility(View.VISIBLE);

                }
            });
        } else {
            tvCloseCountDown.setVisibility(View.GONE);
            tvClose.setVisibility(View.VISIBLE);
//            llMc.setVisibility(View.VISIBLE);
        }

        //开奖时间
        if (lotterytime > 0) {
            tvOpenTime.start(lotterytime);
            tvOpening.setVisibility(View.GONE);
            tvOpenTime.setVisibility(View.VISIBLE);
            tvOpenTime.setOnCountdownEndListener(new CountdownView.OnCountdownEndListener() {
                @Override
                public void onEnd(CountdownView cv) {
                    tvOpening.setVisibility(View.VISIBLE);
                    tvOpenTime.setVisibility(View.GONE);
                    handler.postDelayed(runnable, 2000);
                }
            });
        } else {
            tvOpening.setVisibility(View.GONE);
            tvOpenTime.setVisibility(View.VISIBLE);
            if (lotteryNum != null && lotteryNum.getData() != null && lotteryNum.getData().getIsClose() != null && lotteryNum.getData().getIsClose().equals("0"))
                handler.postDelayed(runnable, 100);
//            llMc.setVisibility(View.VISIBLE);

        }

    }

    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            questLotteryNum(false);
        }
    };
    //设置彩票开奖数据
    String[] animal;
    String[] temp1;

    private void setLotteryData() {
        winNumberList = new ArrayList<>();
        String delimeter1 = ",";
        //添加号码
        if (lotteryNum.getData() != null && lotteryNum.getData().getPreNum() != null && !lotteryNum.getData().getPreNum().equals("")) {
            temp1 = lotteryNum.getData().getPreNum().split(delimeter1); // 分割字符串
        }
        if (lotteryNum.getData() != null && lotteryNum.getData().getPreResult() != null && !lotteryNum.getData().getPreResult().equals("")) {
            animal = lotteryNum.getData().getPreResult().split(delimeter1); // 分割字符串
        }
        if (td.getGameType().equals("lhc")) {
            for (int i = 0; i < temp1.length; i++) {
                if (temp1.length - 1 == i) {
                    winNumberList.add(new WinNumber("+", "+"));
                    winNumberList.add(new WinNumber(temp1[i], animal[i]));
                } else {
                    winNumberList.add(new WinNumber(temp1[i], animal[i]));
                }
            }
        } else if (td.getGameType().equals("pcdd")) {
            int sum = 0;
            for (int i = 0; i < temp1.length; i++) {
                winNumberList.add(new WinNumber(temp1[i], animal[i]));
                if (ShowItem.isNumeric(temp1[i]))
                    sum += Integer.parseInt(temp1[i]);
            }
            winNumberList.add(new WinNumber("=", ""));
            winNumberList.add(new WinNumber(sum + "", ""));
        } else if (animal.length > temp1.length) {
            if (animal != null) {
                for (int i = 0; i < animal.length; i++) {
                    winNumberList.add(new WinNumber("", animal[i]));
                }
            }
            if (lotteryNum.getData().getPreNum() != null && temp1 != null) {
                for (int t = 0; t < temp1.length; t++) {
                    winNumberList.get(t).setNum(temp1[t]);
                }
            }
        } else if (temp1 != null) {
            for (int i = 0; i < temp1.length; i++) {
                winNumberList.add(new WinNumber(temp1[i], ""));
            }
            if (lotteryNum.getData().getPreResult() != null && animal != null) {
                for (int t = 0; t < animal.length; t++) {
                    winNumberList.get(t).setAnimal(animal[t]);
                }
            }
        }
    }

    @OnClick({R.id.iv_left, R.id.tv_title, R.id.iv_search, R.id.iv_chat})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_left:
                finish();
                break;
            case R.id.tv_title:
                showPopMenu(tvTitle);
                break;
            case R.id.iv_chat:
//                Intent intent = new Intent(this, WebActivity.class);
//                intent.putExtra("url", Constants.BaseUrl + "/dist/index.html#/chatRoomList?id=" + td.getGameId());
//                startActivity(intent);
//                String sid = SPConstants.getValue(this, SPConstants.SP_API_SID);
//                String apiToken = SPConstants.getValue(this, SPConstants.SP_API_TOKEN);
//                Intent intent = new Intent(this, WebActivity.class);
//                intent.putExtra("url", Constants.BaseUrl() + Constants.CHAT + "logintoken=" + apiToken + "&sessiontoken=" + sid);
//                intent.putExtra("type", "chat");
//                startActivity(intent);

                Intent intent = new Intent(this, TicketDetailsActivity.class);
                TicketDetails td = new TicketDetails();
                td.setGameId("70");
                td.setGameType("lhc");
                td.setIsChar(1);
                td.setIsInstant("0");
                ShareUtils.putString(this, "isInstant", "0");
                td.setLotteryTime("-1");
                Gson gson = new Gson();
                String ticketDetails = gson.toJson(td);
                intent.putExtra("ticketDetails", ticketDetails);
                OpenHelper.startActivity(this, intent);
                break;
            case R.id.iv_search:
                String searchs = etSearch.getText().toString().trim();
                if (searchs == null || searchs.length() == 0) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.search), InformationActivity.this);
                    return;
                }
                page = 1;
                isType = false;
                search = searchs;
                getBbsData();
                break;
        }
    }

    private CustomPopWindow mCustomPopWindow;

    private void showPopMenu(View view) {
        View contentView = LayoutInflater.from(this).inflate(R.layout.pop_bbs_list, null);
        //处理popWindow 显示内容
        handleLogic(contentView);
        //创建并显示popWindow
        mCustomPopWindow = new CustomPopWindow.PopupWindowBuilder(this)
                .setView(contentView)
                .size(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)//显示大小
                .enableBackgroundDark(true) //弹出popWindow时，背景是否变暗
                .setBgDarkAlpha(0.7f) // 控制亮度
                .create()
                .showAsDropDown(view, 0, 0);
        Uiutils.setStateColor(InformationActivity.this);
    }

    private void handleLogic(View contentView) {
        RecyclerView recyclerView = (RecyclerView) contentView.findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new GridLayoutManager(InformationActivity.this, 3));
        if (recyclerView.getItemDecorationCount() == 0) {
            recyclerView.addItemDecoration(new DividerGridItemDecoration(InformationActivity.this,
                    DividerGridItemDecoration.BOTH_SET, 5, Color.rgb(255, 255, 255)));
        }
        BbsTypeAdapter adapter = new BbsTypeAdapter();
        recyclerView.setAdapter(adapter);
        adapter.setData(td.getBbsBean());
        adapter.notifyDataSetChanged();
        adapter.setOnItemClickListener(new MyitemAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (mCustomPopWindow != null) {
                    mCustomPopWindow.dissmiss();
                    Uiutils.setStateColor(InformationActivity.this);
                }
                if (!TextUtils.isEmpty(td.getBbsBean().get(position).getId()))
                    td.setId(td.getBbsBean().get(position).getId());
                if (!TextUtils.isEmpty(td.getBbsBean().get(position).getGameId()))
                    td.setGameId(td.getBbsBean().get(position).getGameId());
                if (!TextUtils.isEmpty(td.getBbsBean().get(position).getName()))
                    td.setTitle(td.getBbsBean().get(position).getName());
                if (!TextUtils.isEmpty(td.getBbsBean().get(position).getGameType()))
                    td.setGameType(td.getBbsBean().get(position).getGameType());
                tvTitle.setText(td.getTitle() == null ? "" : td.getTitle());
                page = 1;
                search = "";
                isType = true;
                getBbsData();
                questLotteryNum(true);
            }
        });
    }

    @Override
    protected void onDestroy() {
        if (webview != null)
            webview.destroy();
        if (handler != null)
            handler.removeCallbacks(runnable);

        super.onDestroy();
    }

}
