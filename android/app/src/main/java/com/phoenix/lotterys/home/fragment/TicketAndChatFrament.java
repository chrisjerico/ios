package com.phoenix.lotterys.home.fragment;

import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.cache.CacheMode;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.activity.SecsecActivity;
import com.phoenix.lotterys.buyhall.activity.SelectGroupActivity;
import com.phoenix.lotterys.buyhall.activity.SelectLotteryTicketActivity;
import com.phoenix.lotterys.buyhall.adapter.MoneyAdapter;
import com.phoenix.lotterys.buyhall.adapter.NiuNumberAdapter;
import com.phoenix.lotterys.buyhall.adapter.TicketClassAdapter;
import com.phoenix.lotterys.buyhall.adapter.TicketClassNameAdapter;
import com.phoenix.lotterys.buyhall.adapter.TitleAdapter;
import com.phoenix.lotterys.buyhall.adapter.WinNumberAdapter;
import com.phoenix.lotterys.buyhall.adapter.ZodiacAdapter;
import com.phoenix.lotterys.buyhall.bean.BetBean;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;
import com.phoenix.lotterys.buyhall.bean.LotteryNumBean;
import com.phoenix.lotterys.buyhall.bean.PlaysBean;
import com.phoenix.lotterys.buyhall.bean.RoomListBean;
import com.phoenix.lotterys.buyhall.bean.TicketClassBean;
import com.phoenix.lotterys.buyhall.bean.TicketDetails;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.buyhall.bean.Zodiac;
import com.phoenix.lotterys.buyhall.entity.ShareBetInfoEntity;
import com.phoenix.lotterys.chat.entity.TicketListEntity;
import com.phoenix.lotterys.chat.fragment.NewWebChatFragment;
import com.phoenix.lotterys.coupons.activity.WebActivity;
import com.phoenix.lotterys.event.SendShareEvent;
import com.phoenix.lotterys.helper.OpenHelper;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.BlackMainActivity;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.InterestDoteyActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.StringBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.DragonAssistantFrag;
import com.phoenix.lotterys.my.fragment.MissionCenterFrag;
import com.phoenix.lotterys.my.fragment.PubWebviewFrag;
import com.phoenix.lotterys.net.GsonObjectCallback;
import com.phoenix.lotterys.net.ObjectCallback;
import com.phoenix.lotterys.net.OkHttp3Utils;
import com.phoenix.lotterys.util.Arrangement;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.EditInputFilter;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SpacesItem;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.ZodiacUtil;
import com.phoenix.lotterys.view.BuyTicketDialog;
import com.phoenix.lotterys.view.ChatRoomListWindow;
import com.phoenix.lotterys.view.ChatRoomPasswordDialog;
import com.phoenix.lotterys.view.MoneyPopupWindow;
import com.phoenix.lotterys.view.MyLayoutManager;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.phoenix.lotterys.BuildConfig;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;
import com.zzhoujay.html.Html;

import org.greenrobot.eventbus.EventBus;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import butterknife.BindView;
import butterknife.OnClick;
import cn.iwgang.countdownview.CountdownView;
import cn.iwgang.countdownview.DynamicConfig;
import okhttp3.Call;

import static android.content.Context.MODE_PRIVATE;
import static androidx.core.provider.FontsContractCompat.FontRequestCallback.RESULT_OK;

/**
 * Greated by Luke
 * on 2020/2/5
 */
@SuppressLint("ValidFragment")
public class TicketAndChatFrament extends BaseFragments implements View.OnClickListener {
    boolean isHide = false;
    boolean isHidetitle = false;  //隐藏标题

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
    @BindView(R2.id.rv_ticket_class)
    RecyclerView rvTicketClass;
    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;
    @BindView(R2.id.tv_select_number)
    TextView tvSelectNumber;
    @BindView(R2.id.et_number)
    EditText etNumber;
    @BindView(R2.id.tv_chip)
    TextView tvChip;
    @BindView(R2.id.iv_refresh)
    ImageView ivRefresh;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.tv_amount)
    TextView tvAmount;
    @BindView(R2.id.tv_bet)
    TextView tvBet;
    @BindView(R2.id.tv_reset)
    TextView tvReset;
    @BindView(R2.id.tv_close)
    TextView tvClose;
    @BindView(R2.id.rv_zodiac)
    RecyclerView rvZodiac;

//    @BindView(R2.id.tv_chat)
//    TextView tvChat;
    @BindView(R2.id.iv_mmc)
    ImageView ivMmc;
    @BindView(R2.id.ll_countdown)
    LinearLayout llCountdown;
    @BindView(R2.id.ll_num)
    LinearLayout llNum;
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.tv_title_open)
    TextView tvTitleOpen;
    @BindView(R2.id.tv_title_close)
    TextView tvTitleClose;
    @BindView(R2.id.ll_titlerv)
    LinearLayout llTitlerv;

    WinNumberAdapter winNumberAdapter;
    List<WinNumber> winNumberList;
    TicketClassAdapter ticketClassAdapter;
    List<TicketClassBean> ticketClassList;
    TicketClassNameAdapter ticketClassNameAdapter;
    String type;
    @BindView(R2.id.long_queue_img)
    ImageView longQueueImg;
    @BindView(R2.id.lottery_network_img)
    ImageView lotteryNetworkImg;
    @BindView(R2.id.lottery_live_img)
    ImageView lotteryLiveImg;
    @BindView(R2.id.action_bar_lin)
    LinearLayout actionBarLin;

    private boolean isSee = true;
    private TicketDetails td ;

    private int leftPosition = 0;
    private long lastClickTime = 0L;
    private long lotterytime = 0L;
    private ObjectAnimator objectAnimator;
    @BindView(R2.id.dl_drawerLayout)
    DrawerLayout dlDrawerLayout;
    @BindView(R2.id.ll_mc)
    LinearLayout llMc;
    private LotteryNumBean lotteryNum;
    private SharedPreferences sp;
    boolean mSelect;
    @BindView(R2.id.rv_title)
    RecyclerView rvTitle;
    @BindView(R2.id.tv_opening)
    TextView tvOpening;
//    @BindView(R2.id.iv_chat)
//    ImageView ivChat;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.main_lin)
    RelativeLayout main_lin;
    @BindView(R2.id.ll_bet)
    LinearLayout llBet;

    @BindView(R2.id.rb_ticket)
    RadioButton rbTicket;
    @BindView(R2.id.rb_chat)
    RadioButton rbChat;
    @BindView(R2.id.ll_ticket)
    LinearLayout llTicket;
    @BindView(R2.id.fl_chat)
    FrameLayout flChat;
    @BindView(R2.id.fl_input)
    FrameLayout flInput;
    @BindView(R2.id.ib_select_room)
    ImageView ibSelectRoom;
    @BindView(R2.id.rg_tab)
    RadioGroup rgTab;
    @BindView(R2.id.fl_radio)
    FrameLayout flRadio;
    @BindView(R2.id.tv_betarea)
    TextView tvBetarea;
    @BindView(R2.id.rl_chatarea)
    ViewGroup rlChatarea;
    @BindView(R2.id.tv_chatarea)
    TextView tvChatarea;
    @BindView(R2.id.ll_left)
    LinearLayout llLeft;
    @BindView(R2.id.iv_more)
    ImageView ivMore;

    private TitleAdapter titleAdapter;
    List<String> ids = new ArrayList<>();
    //设置彩票开奖数据
    String[] animal;
    String[] temp1;
    private long timeSys;
    private LotteryNewDetails lotteryNewDetails;
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> playList = new ArrayList<>();
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> playOddsList = new ArrayList<>();
    private String title;  //右边标题
    private long selectNumber;  //连码 连肖投注数量
    private ZodiacAdapter zodiacAdapter;
    int rightTitlePosition;
    ZodiacUtil aod = new ZodiacUtil();
    List<Zodiac> list = aod.aodiac();
    private Handler mHandler = null;
    private MoneyPopupWindow moneyPopupWindow;
    String numNext = "";  //网络延迟返回数据上一期做标识判断
    Application mApp;

    private NewWebChatFragment mChatFragment;
    private ChatRoomListWindow mRoomWindow;
    private RoomListBean.DataBean.ChatAryBean chatRoomBean = null;
    private RoomListBean roomListbean;

//    public TicketDetailsActivity() {
//        super(R.layout.activity_ticket_details, true, true);
//    }

    @SuppressLint("ValidFragment")
    public TicketAndChatFrament(boolean isHide, boolean isHidetitle) {
        super(R.layout.activity_ticket_details, true, true);
        this.isHide = isHide;
        this.isHidetitle = isHidetitle;
    }

    public static TicketAndChatFrament getInstance(boolean isHide, boolean isHidetitle) {
        return new TicketAndChatFrament(isHide,isHidetitle);
    }


    public void getIntentData() {

        String ticketDetails = getActivity().getIntent().getStringExtra("ticketDetails");
        td = new Gson().fromJson(ticketDetails, TicketDetails.class);
        Log.e("GameType", "" + td.getGameType());
    }

    @Override
    public void initView(View view) {
        sp = getContext().getSharedPreferences(SPConstants.SP_User, MODE_PRIVATE);
        mApp = (Application) Application.getContextObject();
        addOnSoftKeyBoardVisibleListener();
        td = new TicketDetails();
        if(BuildConfig.FLAVOR.equals("c084")) {
            td.setGameId("164");
            td.setTitle("分分六合彩");
        }else  if(BuildConfig.FLAVOR.equals("c208")){
            td.setGameId("78");
            td.setTitle("一分六合彩");
        }else{
            td.setGameId("70");
            td.setTitle("香港六合彩");
        }
        td.setGameType("lhc");
        td.setIsInstant("0");
        td.setTitle("香港六合彩");
        td.setLotteryTime("-1");
        llLeft.setVisibility(View.INVISIBLE);
        ivMore.setVisibility(View.INVISIBLE);

        initInfo();
        //edittext如果输入小数的话，小数点后边最多两位
        InputFilter[] filters = {new EditInputFilter()};
        etNumber.setFilters(filters);
        initData(false);
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(500/*,false*/);//传入false表示刷新失败
                numNext = "";
                if (td.getIsInstant() != null && td.getIsInstant().equals("0"))
                    questLotteryNum(false);
                else
                    llMc.setVisibility(View.GONE);
                if (playOddsList == null || playOddsList.size() == 0)
                    questNewLotteryDetails();
            }
        });
        setTheme();
        //c048  开奖颜色修改
        openLotteryColor();

        Uiutils.setBarStye0(main_lin, getContext());
        lhcTheme();


        if (Uiutils.isSixBa(getContext())) {
            Uiutils.setMyBa(getContext(), llMain);
            tvTicketNumber.setTextColor(getResources().getColor(R.color.color_white));
//            tvChat.setTextColor(getResources().getColor(R.color.color_white));
            tvTicketNumberNext.setTextColor(getResources().getColor(R.color.color_white));
            tvTitleClose.setTextColor(getResources().getColor(R.color.color_white));
            tvTitleOpen.setTextColor(getResources().getColor(R.color.color_white));

            tvOpening.setTextColor(getResources().getColor(R.color.color_white));
            DynamicConfig.Builder dynamicConfigBuilder = new DynamicConfig.Builder();
            dynamicConfigBuilder/*.setTimeTextSize(getResources().getDimension(R.dimen.sp_14))*/
                    .setTimeTextColor(getResources().getColor(R.color.color_white))
                    .setTimeTextBold(false)
                    .setSuffixTextColor(getResources().getColor(R.color.color_white))
                    /*                .setSuffixTextSize(getResources().getDimensionPixelSize(R.dimen.sp_7))*/
                    .setSuffixTextBold(false)
                    .setSuffixHour(":")
                    .setSuffixMinute(":")
//                .setSuffixMinuteLeftMargin(5)
//                .setSuffixMinuteRightMargin(5)
                    .setSuffixGravity(DynamicConfig.SuffixGravity.CENTER)
            /*.setShowDay(true).setShowHour(true).setShowMinute(true).setShowSecond(true).setShowMillisecond(false)*/;
            tvOpenTime.dynamicShow(dynamicConfigBuilder.build());
        } else {
//            llMain.setBackgroundResource(R.color.white);
        }

        if (Uiutils.isSite("c190")) {
            actionBarLin.setVisibility(View.VISIBLE);
            longQueueImg.setColorFilter(getResources().getColor(R.color.color_white));
            lotteryNetworkImg.setColorFilter(getResources().getColor(R.color.color_white));
            lotteryLiveImg.setColorFilter(getResources().getColor(R.color.color_white));
        }

        if (null != td && !StringUtils.isEmpty(td.getGameType()) && StringUtils.equals("lhc",
                td.getGameType()) && (Uiutils.isSite("c085") || Uiutils.isSite("c200"))) {
            actionBarLin.setVisibility(View.VISIBLE);
            longQueueImg.setVisibility(View.GONE);
            ImageLoadUtil.ImageLoad(getContext(), R.drawable.kjw_01, lotteryNetworkImg);
            lotteryLiveImg.setVisibility(View.INVISIBLE);
        }

        mChatFragment = NewWebChatFragment.getInstance();

        getChildFragmentManager().beginTransaction()
                .add(R.id.fl_chat, mChatFragment)
//                .add(R.id.fl_sliding, new SlidingRight_Fragment())
                .commit();
//        flRadio.setVisibility(View.GONE);

        initChatRoomList();
        rlChatarea.setBackgroundColor(0);
        selectTab(false);
    }

    private void initChatRoomList() {
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);

        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.GET_TOKEN + (Constants.ENCRYPT ? Constants.SIGN : "")))
                .params("token", SecretUtils.DESede(token))
                .params("t", SecretUtils.DESede(String.valueOf(System.currentTimeMillis())))
                .params("sign", SecretUtils.RsaToken())
                .tag(this)
                .execute(new NetDialogCallBack(getContext(), true, getContext(),
                        false, RoomListBean.class,110) {
                    @Override
                    public void onUi(Object o) {
                        roomListbean = (RoomListBean) o;
                        if (roomListbean.getCode() == 0&& roomListbean.getData()!=null&& roomListbean.getData().getChatAry()!=null) {
                            mRoomWindow = new ChatRoomListWindow(getContext(), roomListbean.getData().getChatAry());
                            RoomListBean.DataBean.ChatAryBean b = mRoomWindow.setCheck(td.getRoomId());
                            if (b != null) {
                                chatRoomBean = b;
                                mChatFragment.checkRoom(chatRoomBean);
                                mRoomWindow.setCheck(chatRoomBean.getRoomId());
//                                rbChat.setText(chatRoomBean.getRoomName());
                                tvChatarea.setText(chatRoomBean.getRoomName());
                            } else {
                                if (mRoomWindow.getFirstChatBean() == null) {
                                    mRoomWindow.setCheck("0");
                                } else {
                                    chatRoomBean = mRoomWindow.getFirstChatBean();
                                    mChatFragment.checkRoom(mRoomWindow.getFirstChatBean());
                                    mRoomWindow.setCheck(mRoomWindow.getFirstChatBean().getRoomId());
//                                    rbChat.setText(mRoomWindow.getFirstChatBean().getRoomName());
                                    tvChatarea.setText(mRoomWindow.getFirstChatBean().getRoomName());
                                }
                            }
                            ibSelectRoom.setVisibility(View.VISIBLE);
                            roomListener();
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

    private void lhcTheme() {
        //5 黑色模板   4 六合模板

    }

    private void setTheme() {

        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), llMain);
                Uiutils.setBaColor(getContext(), llNum);
                Uiutils.setBaColor(getContext(), llCountdown);
                Uiutils.setBaColor(getContext(), llTitlerv);
                Uiutils.setBaColor(getContext(), rvZodiac);
//                tvChat.setTextColor(getContext().getResources().getColor(R.color.font));
                tvTitleOpen.setTextColor(getContext().getResources().getColor(R.color.font));
                tvTitleClose.setTextColor(getContext().getResources().getColor(R.color.font));
                tvTicketNumberNext.setTextColor(getContext().getResources().getColor(R.color.font));
                tvTicketNumber.setTextColor(getContext().getResources().getColor(R.color.font));
//                rvZodiac.setBackgroundResource(R.color.color_4D4D4D);
                llBet.setBackgroundResource(R.color.black);
            }
        } else {

        }

    }

    private void initData(boolean b) {
        currentExpect = "";
        upExpect = "";
        numNext = "";
        leftPosition = 0;
        if (td == null)
            return;

        if (!TextUtils.isEmpty(td.getIsInstant()) && td.getIsInstant().equals("1")) {
            ivMmc.setVisibility(View.VISIBLE);
            llCountdown.setVisibility(View.GONE);
            llNum.setVisibility(View.GONE);
            llMc.setVisibility(View.GONE);
//            tvClose.setVisibility(View.GONE);
        } else {
            ivMmc.setVisibility(View.GONE);
            llCountdown.setVisibility(View.VISIBLE);
            llNum.setVisibility(View.VISIBLE);
        }

        if (td != null && td.getTitle() != null) {
            tvTitle.setText(td.getTitle());
        }
        rvZodiac.setVisibility(View.GONE);
        rvTitle.setVisibility(View.GONE);
        if (td != null && td.getGameId() != null) {
            if (b) {  //okgo自动取消请求
                changeLotteryData();
                if (td.getIsInstant() != null && td.getIsInstant().equals("0"))
                    changeLotteryNum(true);
            } else {
                questNewLotteryDetails();
                if ((td.getIsInstant() != null && td.getIsInstant().equals("0")) || (td.getLotteryTime() != null && td.getLotteryTime().equals("-1")))  //getLotteryTime 为轮播图传过来的秒秒彩要加载一次-1
                    questLotteryNum(true);

            }

        }
    }

    private void changeLotteryNum(boolean isRefresh) {
        OkHttp3Utils.doGet(URLDecoder.decode(Constants.BaseUrl() + Constants.LOTTERYNUM + SecretUtils.DESede(td.getGameId()) + "&sign=" + SecretUtils.RsaToken()), new ObjectCallback() {
            @Override
            public void onUi(boolean b, String t) {
                String data = t;
                BaseBean bb = new Gson().fromJson(data, BaseBean.class);
                if (bb != null && bb.getCode() == 0) {
                    lotteryNum = new Gson().fromJson(data, LotteryNumBean.class);
                    try {
                        setNumData(isRefresh);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            @Override
            public void onFailed(Call call, IOException e) {

            }
        });
    }

    //生肖及点中选择
    private void initrvZodiac(List<LotteryNewDetails.DataBean.SettingBean.ZodiacNumsBean> zodiacNums) {
        zodiacAdapter = new ZodiacAdapter(list, getContext());
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        rvZodiac.setLayoutManager(layoutManager);
        rvZodiac.setAdapter(zodiacAdapter);
        zodiacAdapter.setListener(new ZodiacAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position, List<Zodiac> list) {
                try {
                    if (playList != null) {
                        playList.clear();
                    }
                    if (playOddsList != null || playOddsList.size() != 0) {
                        for (Zodiac l : list) {
                            if (zodiacNums != null && zodiacNums.size() != 0) {
                                for (LotteryNewDetails.DataBean.SettingBean.ZodiacNumsBean zod : zodiacNums) {
                                    if (zod.getName().equals(l.getZodiac())) {
                                        for (int i = 0; i < playOddsList.size(); i++) {
                                            if (playOddsList.get(i).getName().equals("特码")) {
                                                int plays = playOddsList.get(i).getPlays().size();
                                                for (int n = 0; n < plays; n++) {
                                                    if (playOddsList.get(i).getPlays().get(n).getAlias().equals("特码A") && playOddsList.get(rightTitlePosition).getAlias().equals("特码A")) {
                                                        for (int z = 0; z < zod.getNums().size(); z++) {
                                                            if (ShowItem.isNumeric(playOddsList.get(i).getPlays().get(n).getName())) {
                                                                int code = Integer.parseInt(playOddsList.get(i).getPlays().get(n).getName());
                                                                if (zod.getNums().get(z).equals(code + "")) {
                                                                    if (l.isSelect()) {
                                                                        playOddsList.get(i).getPlays().get(n).setSelect(true);
                                                                        playOddsList.get(i).getPlays().get(n).setSelectName("2");
                                                                        playOddsList.get(i).getPlays().get(n).setTitleAlias(ticketClassList.get(leftPosition).getName());
                                                                        playList.add(playOddsList.get(i).getPlays().get(n));
                                                                        playOddsList.get(i).getPlays().get(n).setZodiac(zod.getName() + "");
                                                                    } else {
                                                                        if (playOddsList.get(i).getPlays().get(n).getSelectName() != null && playOddsList.get(i).getPlays().get(n).getSelectName().equals("2")) {
                                                                            playOddsList.get(i).getPlays().get(n).setSelect(false);
                                                                            playOddsList.get(i).getPlays().get(n).getSelectName().equals("0");
                                                                        }
                                                                    }
                                                                    if (playOddsList.get(i).getPlays().get(n).isSelect() && playOddsList.get(i).getPlays().get(n).getSelectName().equals("1")) {
                                                                        playOddsList.get(i).getPlays().get(n).setTitleAlias(ticketClassList.get(leftPosition).getName());
                                                                        playList.add(playOddsList.get(i).getPlays().get(n));
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } else if (playOddsList.get(i).getPlays().get(n).getAlias().equals("特码B") && playOddsList.get(rightTitlePosition).getAlias().equals("特码B")) {
                                                        for (int z = 0; z < zod.getNums().size(); z++) {
                                                            if (ShowItem.isNumeric(playOddsList.get(i).getPlays().get(n).getName())) {
                                                                int code = Integer.parseInt(playOddsList.get(i).getPlays().get(n).getName());
                                                                if (zod.getNums().get(z).equals(code + "")) {
                                                                    if (l.isSelect()) {
                                                                        playOddsList.get(i).getPlays().get(n).setSelect(true);
                                                                        playOddsList.get(i).getPlays().get(n).setSelectName("2");
                                                                        playOddsList.get(i).getPlays().get(n).setTitleAlias(ticketClassList.get(leftPosition).getName());
                                                                        playList.add(playOddsList.get(i).getPlays().get(n));
                                                                        playOddsList.get(i).getPlays().get(n).setZodiac(zod.getName() + "");
                                                                    } else {
                                                                        if (playOddsList.get(i).getPlays().get(n).getSelectName() != null && playOddsList.get(i).getPlays().get(n).getSelectName().equals("2")) {
                                                                            playOddsList.get(i).getPlays().get(n).setSelect(false);
                                                                            playOddsList.get(i).getPlays().get(n).getSelectName().equals("0");
                                                                        }
                                                                    }
                                                                    if (playOddsList.get(i).getPlays().get(n).isSelect() && playOddsList.get(i).getPlays().get(n).getSelectName().equals("1")) {
                                                                        playOddsList.get(i).getPlays().get(n).setTitleAlias(ticketClassList.get(leftPosition).getName());
                                                                        playList.add(playOddsList.get(i).getPlays().get(n));
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (ticketClassNameAdapter != null) {
                        ticketClassNameAdapter.notifyDataSetChanged();
                    }
                    if (playList != null || playList.size() != 0) {
                        tvSelectNumber.setText(playList.size() + "");
                    }
                    selectLeftTitle();
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    //设置左标题是否选中状态
    private void selectLeftTitle() {
        if (playOddsList != null) {
            int num = 0;
            int lotteryType = playOddsList.size();
            for (int cunt = 0; cunt < lotteryType; cunt++) {
                int lotteryDet = playOddsList.get(cunt).getPlays().size();
                for (int cun = 0; cun < lotteryDet; cun++) {
                    if (playOddsList.get(cunt).getPlays().get(cun).isSelect()) {
                        num++;
                    }
                }
            }
            if (num > 0)
                ticketClassList.get(leftPosition).setHave(true);
            else
                ticketClassList.get(leftPosition).setHave(false);
            if (ticketClassAdapter != null) {
                ticketClassAdapter.notifyItemChanged(leftPosition);
            }
        }
    }

    private void questLotteryNum(boolean isRefresh) {
        if (handler != null)
            handler.removeCallbacks(runnable);

        tvCloseCountDown.setVisibility(View.GONE);
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.LOTTERYNUM + SecretUtils.DESede(td.getGameId()) + "&sign=" + SecretUtils.RsaToken()))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), false, getContext(), true, LotteryNumBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        lotteryNum = (LotteryNumBean) o;
//                        Log.e("xxxxlotteryNum",""+lotteryNum);
                        tvClose.setVisibility(View.GONE);
                        tvCloseCountDown.setVisibility(View.VISIBLE);
                        setNumData(isRefresh);
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
//                        Log.e("onFailedonErrTicke", "onErronFailed");
                    }

                    @Override
                    public void onFailed(Response<String> response) {
//                        Log.e("onFailedTicke", "onFailed");
                    }
                });


    }

    String currentExpect;   //当前期
    String upExpect;    //上一期

    private void setNumData(boolean isRefresh) {
        try {
            if (lotteryNum != null && lotteryNum.getCode() == 0 && lotteryNum.getData() != null) {
                tvTitle.setText(lotteryNum.getData().getTitle() == null ? "" : lotteryNum.getData().getTitle());
                if (lotteryNum.getData().getPreIssue() != null && lotteryNum.getData().getPreIssue().equals(upExpect) && lotteryNum.getData().getCurIssue() != null && !lotteryNum.getData().getCurIssue().equals(currentExpect)) {

                    handler.postDelayed(runnable, 2000);
                } else {

                    currentExpect = lotteryNum.getData().getCurIssue() == null ? "" : lotteryNum.getData().getCurIssue();
                    upExpect = lotteryNum.getData().getPreIssue() == null ? "" : lotteryNum.getData().getPreIssue();
                }


                setLotteryData();
                winNumberAdapter = new WinNumberAdapter(winNumberList, td.getGameId(), td.getGameType(), getContext());
                MyLayoutManager layout = new MyLayoutManager();
                //必须，防止recyclerview高度为wrap时测量item高度0
                layout.setAutoMeasureEnabled(true);
                rvWinNumber.setLayoutManager(layout);
                rvWinNumber.setAdapter(winNumberAdapter);

                numNext = lotteryNum.getData().getCurIssue();
                tvTicketNumberNext.setText(lotteryNum.getData().getCurIssue() == null ? "" : (lotteryNum.getData().getCurIssue() + " 期"));
                tvTicketNumber.setText(lotteryNum.getData().getPreIssue() == null ? "" : (lotteryNum.getData().getPreIssue() + " 期"));
                //倒计时
                try {
                    mCountdown(isRefresh);
                } catch (Exception e) {
                    e.printStackTrace();
                }

//                //是否弹窗
//                if (!StringUtils.isEmpty(lotteryNum.getData().getAdPic()) && !StringUtils.isEmpty(lotteryNum.getData().getAdEnable()) && StringUtils.equals(
//                        "1", lotteryNum.getData().getAdEnable()
//                )) {
//                    boolean isAdd = false;
//                    if (mApp.getGameId() != null && mApp.getGameId().size() > 0) {
//                        for (String s : mApp.getGameId()) {
//                            if (s.equals(td.getGameId())) {
//                                isAdd = true;
//                            }
//                        }
//                    }
//                    if (!isAdd) {
//                        setAdvertisementPop();
//                        mApp.gameId.add(td.getGameId());
//                    }
//                }

                if (td.getGameType().equals("pk10nn")) {
                    String[] niu = lotteryNum.getData().getPreResult().split(","); // 分割字符串
                    NiuNumberAdapter rvNiuAdapter = new NiuNumberAdapter(niu, lotteryNum.getData().getWinningPlayers(), getContext());
                    LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                    layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
                    rvNiuNumber.setLayoutManager(layoutManager);
                    rvNiuNumber.setAdapter(rvNiuAdapter);
                    rvNiuNumber.setVisibility(View.VISIBLE);
                } else {
                    rvNiuNumber.setVisibility(View.GONE);
                }
                if (!TextUtils.isEmpty(lotteryNum.getData().getIsSeal())) {
                    if (lotteryNum.getData().getIsSeal().equals("1")) {
                        llMc.setVisibility(View.VISIBLE);

                    } else if (lotteryNum.getData().getIsSeal().equals("0") && lastClickTime > 0) {
                        llMc.setVisibility(View.GONE);

                    }
                }
            } else if (lotteryNum != null && lotteryNum.getCode() != 0 && lotteryNum.getMsg() != null) {
                ToastUtil.toastShortShow(getContext(), lotteryNum.getMsg());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void openLotteryColor() {
//        if (BuildConfig.FLAVOR.equals("c048")) {
            tvOpening.setTextColor(getResources().getColor(R.color.color_FBC506));
            DynamicConfig.Builder dynamicConfigBuilder = new DynamicConfig.Builder();
            dynamicConfigBuilder/*.setTimeTextSize(getResources().getDimension(R.dimen.sp_14))*/
                    .setTimeTextColor(getResources().getColor(R.color.color_FBC506))
                    .setTimeTextBold(false)
                    .setSuffixTextColor(getResources().getColor(R.color.color_FBC506))
                    /*                .setSuffixTextSize(getResources().getDimensionPixelSize(R.dimen.sp_7))*/
                    .setSuffixTextBold(false)
                    .setSuffixHour(":")
                    .setSuffixMinute(":")
//                .setSuffixMinuteLeftMargin(5)
//                .setSuffixMinuteRightMargin(5)
                    .setSuffixGravity(DynamicConfig.SuffixGravity.CENTER)
            /*.setShowDay(true).setShowHour(true).setShowMinute(true).setShowSecond(true).setShowMillisecond(false)*/;
            tvOpenTime.dynamicShow(dynamicConfigBuilder.build());
//        }
    }

    long timeDelayed = 0;

    //倒计时
    private void mCountdown(boolean isRefresh) {
        timeSys = System.currentTimeMillis();
        StampToDate st = new StampToDate();
        lotterytime = st.StampToDate(lotteryNum.getData().getCurOpenTime(), lotteryNum.getData().getServerTimestamp() == null ? "0" : lotteryNum.getData().getServerTimestamp(), timeSys);    //开奖时间
        lastClickTime = st.StampToDate(lotteryNum.getData().getCurCloseTime(), lotteryNum.getData().getServerTimestamp() == null ? "0" : lotteryNum.getData().getServerTimestamp(), timeSys);   //封盘时间
        timeDelayed = lotterytime < 0 ? 0 : lotterytime;
//        Log.e("lotterytimetimeDelayed", "" + lastClickTime+"|1|"+timeSys+"|1|"+lotteryNum.getData().getServerTime());


        //封盘时间
        if (lastClickTime > 0) {
            tvCloseCountDown.start(lastClickTime);
            tvCloseCountDown.setOnCountdownEndListener(new CountdownView.OnCountdownEndListener() {
                @Override
                public void onEnd(CountdownView cv) {
                    tvClose.setVisibility(View.VISIBLE);
                    tvCloseCountDown.setVisibility(View.GONE);
                    llMc.setVisibility(View.VISIBLE);

                }
            });
        } else {
            tvCloseCountDown.setVisibility(View.GONE);
            tvClose.setVisibility(View.VISIBLE);
            llMc.setVisibility(View.VISIBLE);
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
            llMc.setVisibility(View.VISIBLE);
        }
    }

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

    private void questNewLotteryDetails() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.LOTTERYGAMEODDS + SecretUtils.DESede(td.getGameId()) + "&sign=" + SecretUtils.RsaToken()))//
                .cacheKey("recommend" + td.getGameId())
                .cacheMode(CacheMode.FIRST_CACHE_THEN_REQUEST)  //缓存模式先使用缓存,然后使用网络数据
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), true, getContext(), true, LotteryNewDetails.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        Object oj = o;
                        lotteryNewDetails = (LotteryNewDetails) oj;
                        if (lotteryNewDetails != null && lotteryNewDetails.getCode() == 0 && lotteryNewDetails.getData() != null && lotteryNewDetails.getData().getPlayOdds().size() != 0) {
                            try {
                                playRule();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        } else if (lotteryNewDetails != null && lotteryNewDetails.getCode() != 0 && lotteryNewDetails.getMsg() != null) {
                            ToastUtil.toastShortShow(getContext(), lotteryNewDetails.getMsg());

                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onCacheSuccess(Response<String> response) {
                        onSuccess(response);
                        if (response != null && response.body() != null) {
                            BaseBean bb = null;
                            try {
                                bb = new Gson().fromJson(response.body(), BaseBean.class);
                            } catch (JsonSyntaxException e) {
                                e.printStackTrace();
                            }
                            if (bb != null && bb.getCode() == 0) {
                                try {
                                    Object o = new Gson().fromJson(response.body(), LotteryNewDetails.class);
                                    if (o == null) {
                                        return;
                                    }
                                    try {
                                        onUi(o);
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                } catch (JsonSyntaxException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }

                    @Override
                    public void onFinish() {
                        super.onFinish();
                    }
                });
    }

//    int i = 0;

    //玩法添加数据
    private void playRule() {
        int playOdds = 0;
        int groups = 0;
        playOdds = lotteryNewDetails.getData().getPlayOdds().size();

        if (td.getGameType().equals("lhc") && lotteryNewDetails.getData().getPlayOdds().get(0).getName().equals("特码")) {
            LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean PlayGroupsA = lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().get(0);
            LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean PlayGroupsAl = lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().get(1);
            LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean PlayGroupsAs = lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().get(2);
            LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean PlayGroupsB = lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().get(3);
            LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean PlayGroupsBl = lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().get(4);
            LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean PlayGroupsBs = lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().get(5);
            lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().set(0, PlayGroupsB);
            lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().set(1, PlayGroupsBl);
            lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().set(2, PlayGroupsBs);
            lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().set(3, PlayGroupsA);
            lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().set(4, PlayGroupsAl);
            lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups().set(5, PlayGroupsAs);
        }

        //增加数据
//        if (td.getGameType().equals("lhc") || td.getGameType().equals("gd11x5") || td.getGameType().equals("gdkl10") || td.getGameType().equals("xync")) {   //快乐十分  六合彩   11选5要添加数据
        playOdds = lotteryNewDetails.getData().getPlayOdds().size();
        for (int t = 0; t < playOdds; t++) {
            if (lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups() == null || lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().size() == 0)
                continue;
            if (lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups() != null) {
                groups = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().size();
                String title = lotteryNewDetails.getData().getPlayOdds().get(t).getName();
                for (int i = 0; i < groups; i++) {
                    if (lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays() == null || lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().size() == 0)
                        continue;
                    int plays = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().size();
                    for (int e = 0; e < plays; e++) {
                        if (lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(e).getEnable().equals("1")) {
//                            lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(e).getEnable()
//                            Log.e("xxxxxgetAlias",lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(e).getEnable());
                        }
                    }
                    if (td.getGameType().equals("lhc") || td.getGameType().equals("gd11x5") || td.getGameType().equals("gdkl10") || td.getGameType().equals("xync")) {
                        if (title.equals("连码") || title.equals("自选不中")) {
                            String odds = ShowItem.subZeroAndDot(lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(0).getOdds());
                            String betId = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(0).getId();
                            List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> pb = new ArrayList<>();
                            if (td.getGameType().equals("gd11x5")) {
                                for (int num = 0; num < 11; num++) {
                                    pb.add(new PlaysBean((num + 1) + "", odds, betId));
                                }
                                lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).setPlays(pb);
                            } else if (td.getGameType().equals("gdkl10")) {
                                for (int num = 0; num < 20; num++) {
                                    pb.add(new PlaysBean((num + 1) + "", odds, betId));
                                }
                                lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).setPlays(pb);
                            } else if (td.getGameType().equals("xync")) {
                                for (int num = 0; num < 20; num++) {
                                    pb.add(new PlaysBean((num + 1) + "", odds, betId));
                                }
                                lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).setPlays(pb);
                            } else if (td.getGameType().equals("lhc") && title.equals("连码")) {
                                String oddss = null;
                                if (lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().size() > 1) {
                                    oddss = ShowItem.subZeroAndDot(lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(1).getOdds());
                                }
                                for (int num = 0; num < 49; num++) {
                                    pb.add(new PlaysBean((num + 1) + "", odds + "" + (oddss == null ? "" : "/" + oddss), betId));
                                }
                                lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).setPlays(pb);
                            } else if (td.getGameType().equals("lhc") && title.equals("自选不中")) {
                                int selectPlay = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().size();
                                for (int num = 0; num < 49; num++) {
                                    String selectOdds = null;
                                    String selectName = null;
                                    String selectId = null;
                                    String alias = null;
                                    if (num < selectPlay) {
                                        ids.add(lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getId());
                                        selectOdds = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getOdds();
                                        selectName = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getName();
                                        selectId = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getId();
                                        alias = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getName();
                                    }
                                    pb.add(new PlaysBean((num + 1) + "", "", selectId, selectOdds, selectName, alias));
                                }
                                lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).setPlays(pb);
                            }
                        } else if (title.equals("合肖") && td.getGameType().equals("lhc")) {
                            List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> pb = new ArrayList<>();
                            int play = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().size();
                            for (int num = 0; num < 12; num++) {
                                String hxOdds = null;
                                String hxId = null;
                                String alias = null;
                                if (num < play) {
                                    hxOdds = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getOdds();
                                    hxId = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getId();
                                    alias = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(num).getName().replaceAll("合肖", "");
                                }
                                int zod = lotteryNewDetails.getData().getSetting().getZodiacNums().size();
                                for (int n = 0; n < zod; n++) {
                                    if (lotteryNewDetails.getData().getSetting().getZodiacNums().get(n).getName().equals(lotteryNewDetails.getData().getSetting().getZodiacs().get(num))) {
                                        pb.add(new PlaysBean((lotteryNewDetails.getData().getSetting().getZodiacs().get(num)), hxOdds, hxId, lotteryNewDetails.getData().getSetting().getZodiacNums().get(n).getNums(), alias));
                                    }
                                }
                            }
                            lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).setPlays(pb);
                        } else if (td.getGameType().equals("lhc") && (title.equals("平特一肖") || title.equals("特肖") || title.equals("连肖") || title.equals("正肖"))) {
                            int play = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().size();
                            for (int g = 0; g < play; g++) {
                                String name = title.equals("连肖") ? lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(g).getAlias() :
                                        lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(g).getName();
                                for (LotteryNewDetails.DataBean.SettingBean.ZodiacNumsBean s : lotteryNewDetails.getData().getSetting().getZodiacNums()) {
                                    if (s.getName().equals(name)) {
                                        lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(g).setNums(s.getNums());
                                    }
                                }
                            }
                        } else if (td.getGameType().equals("gd11x5") && title.equals("直选")) {
                            String odds = ShowItem.subZeroAndDot(lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(0).getOdds());
                            String selectAlias = ShowItem.subZeroAndDot(lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(0).getAlias());
                            String betIds = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getPlays().get(0).getId();
                            String betId = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getId();
                            String name = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getName();
                            String alias = lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).getAlias();
                            List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> pb = new ArrayList<>();
                            List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> pb1 = new ArrayList<>();
                            List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> pb2 = new ArrayList<>();
                            for (int num = 0; num < 11; num++) {
                                pb.add(new PlaysBean((num + 1) + "", odds, betIds, alias, Collections.singletonList("0"), 0));
                            }
                            for (int num = 0; num < 11; num++) {
                                pb1.add(new PlaysBean((num + 1) + "", odds, betIds, alias, Collections.singletonList("1"), 1));
                            }
                            for (int num = 0; num < 11; num++) {
                                pb2.add(new PlaysBean((num + 1) + "", odds, betIds, alias, Collections.singletonList("2"), 2));
                            }

                            lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().add(new LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean(name, betId, alias, pb1));
                            lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().add(new LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean(name, betId, alias, pb2));
                            lotteryNewDetails.getData().getPlayOdds().get(t).getPlayGroups().get(i).setPlays(pb);
                        }
                    }


                }
            }
        }
//        }
        initRecycler();
        if (lotteryNewDetails.getData() != null && lotteryNewDetails.getData().getSetting() != null && lotteryNewDetails.getData().getSetting().getZodiacNums() != null) {
            initrvZodiac(lotteryNewDetails.getData().getSetting().getZodiacNums());
        }
    }

    private void initRecycler() {
        ticketClassList = new ArrayList<>();
        if (lotteryNewDetails.getData() != null && lotteryNewDetails.getData().getPlayOdds() != null && lotteryNewDetails.getData().getPlayOdds().size() != 0) {
            if (playOddsList != null) {
                playOddsList.clear();
            }
            playOddsList.addAll(lotteryNewDetails.getData().getPlayOdds().get(0).getPlayGroups());
            type = lotteryNewDetails.getData().getPlayOdds().get(0).getName();
        }
        for (LotteryNewDetails.DataBean.PlayOddsBean po : lotteryNewDetails.getData().getPlayOdds()) {
            ticketClassList.add(new TicketClassBean(po.getName(), false, false));
        }
        ticketClassList.get(0).setSelect(true);
        ticketClassAdapter = new TicketClassAdapter(ticketClassList, getContext());
        rvTicketClass.setAdapter(ticketClassAdapter);
        rvTicketClass.setLayoutManager(new LinearLayoutManager(getContext()));
        rvTicketClass.addItemDecoration(new DividerGridItemDecoration(getContext(),
                DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(200, 200, 200)));
        ticketClassAdapter.setListener(new TicketClassAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if ((td.getGameType().equals("gd11x5") || td.getGameType().equals("gdkl10") || td.getGameType().equals("xync")) && (ticketClassList.get(leftPosition).getName().equals("连码") || ticketClassList.get(leftPosition).getName().equals("直选"))) {
                    mClear(false);
                }
                leftPosition = position;
                zodiacRecyler();
                if (!ticketClassList.get(position).isSelect()) {
                    ticketClassList.get(position).setSelect(true);
                    type = ticketClassList.get(position).getName();
                    for (int i = 0; i < ticketClassList.size(); i++) {
                        if (i != position)
                            ticketClassList.get(i).setSelect(false);
                    }
                    if (ticketClassAdapter != null) {
                        ticketClassAdapter.notifyDataSetChanged();
                    }
                    if (playOddsList != null) {
                        playOddsList.clear();
                    }
                    try {
                        playOddsList.addAll(lotteryNewDetails.getData().getPlayOdds().get(position).getPlayGroups());
                    } catch (Exception e) {
//                        Log.e("无数据", "无数据");
                        e.printStackTrace();
                    }
//                    去掉选中状态  六合彩 11选5 ，快乐10分
                    if (td.getGameType().equals("lhc") || ((td.getGameType().equals("gd11x5") || td.getGameType().equals("gdkl10") || td.getGameType().equals("xync")) && (ticketClassList.get(position).getName().equals("连码")) || ticketClassList.get(position).getName().equals("直选"))) {
                        mClear(false);
                        showItem(0);
                        if (rvTicket != null) {
                            rvTicket.scrollToPosition(0);
                        }
                        if (titleAdapter != null) {
                            titleAdapter.notifyDataSetChanged();
                        }
                    } else {
                        //让getItemCount方法正常判断
                        ticketClassNameAdapter.showCount(0, "1", null, null);
                        rvTitle.setVisibility(View.GONE);
                    }
                    if ((td.getGameType().equals("lhc") || td.getGameType().equals("gd11x5") || td.getGameType().equals("gdkl10") || td.getGameType().equals("xync")) &&
                            (ticketClassList.get(leftPosition).getName().equals("自选不中") || ticketClassList.get(leftPosition).getName().equals("连码")
                                    || ticketClassList.get(leftPosition).getName().equals("合肖") || ticketClassList.get(leftPosition).getName().equals("直选"))) {
                        ticketClassNameAdapter.setSelect(true);
                    } else {
                        ticketClassNameAdapter.setSelect(false);
                    }
                    rvTicket.scrollToPosition(0);
                    if (playOddsList != null && playOddsList.size() != 0) {
                        title = playOddsList.get(0).getAlias();
                    }
                    //右上标题
                    if (titleAdapter != null) {
                        titleAdapter.setTitle(ticketClassList.get(leftPosition).getName());
                    }
                    ticketClassNameAdapter.notifyDataSetChanged();
                }
            }
        });

        ticketClassNameAdapter = new TicketClassNameAdapter(playOddsList, td.getGameId(), td.getGameType(), getContext(), ticketClassList.get(leftPosition).getName());
        //六合彩第一个位置有右标题第一个需要调（11选5   快乐十分不用）
        if (td.getGameType().equals("lhc")) {
            showItem(0);
            rvZodiac.setVisibility(View.VISIBLE);
        } else {
            ticketClassNameAdapter.showCount(0, "1", null, playOddsList.get(0).getAlias());
        }
        rvTicket.setLayoutManager(new LinearLayoutManager(getContext()));
        if (rvTicket.getItemDecorationCount() == 0)   //解决刷新recyclerview刷新 item间距变大问题
        {
            rvTicket.addItemDecoration(new SpacesItem(-2));
        }
        rvTicket.setAdapter(ticketClassNameAdapter);
        ticketClassNameAdapter.setListener(new TicketClassNameAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int i, LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean data, boolean isSelect, int position, int count, int typeCount) {
//                Log.e("xx3323position",""+position);
                try {
                    if (data.isSelect()) {
//                        Log.e("dataisSelect", "" + data);
                        data.setTitleAlias(ticketClassList.get(leftPosition).getName());
                        data.setPos(leftPosition + "" + i + "" + position); //生成唯一标识 来增加删除
                        playList.add(data);
                        playOddsList.get(position).getPlays().get(i).setSelect(isSelect);
                        playOddsList.get(position).getPlays().get(i).setSelectName("1");
                        ticketClassNameAdapter.notifyDataSetChanged();
                        // 六合彩系列如果选中号码包含生肖所有数字设置生肖为选中状态
                        if (td.getGameType().equals("lhc") && ticketClassList.get(leftPosition).getName().equals("特码")) {
//                            Log.e("dataisSelect1", "dataisSelect1");
                            for (LotteryNewDetails.DataBean.SettingBean.ZodiacNumsBean zo : lotteryNewDetails.getData().getSetting().getZodiacNums()) {
                                int selects = 0;
                                for (int z = 0; z < zo.getNums().size(); z++) {
                                    for (int p = 0; p < playOddsList.get(position).getPlays().size(); p++) {
                                        if (playOddsList.get(position).getPlays().get(p).isSelect()) {
                                            if (zo.getNums().get(z).equals((p + 1) + "")) {
                                                selects++;
                                            }
                                        }
                                    }
                                    if (selects == zo.getNums().size()) {
                                        for (int zot = 0; zot < zo.getNums().size(); zot++) {
                                            int t = Integer.parseInt(zo.getNums().get(zot)) - 1;
                                            playOddsList.get(position).getPlays().get(t).setSelectName("2");
                                        }
                                        zodiacAdapter.ZodiacSelectItem(zo.getName());
                                    }
                                }
                            }
                        }
                    } else {
//                        Log.e("dataisSelect2", "dataisSelect1");
                        for (int j = 0; j < playList.size(); j++) {
                            if (td.getGameType().equals("lhc") && (ticketClassList.get(leftPosition).getName().equals("连肖") || ticketClassList.get(leftPosition).getName().equals("连尾"))) {
                                if (data.getAlias().equals(playList.get(j).getAlias())) {
                                    playList.remove(j);
                                }
                            } else {
                                if (data.getName().equals(playList.get(j).getName())) {
                                    //用生肖选中的号码  取消掉一个号码生肖跟着取消掉
                                    if (td.getGameType().equals("lhc") && ticketClassList.get(leftPosition).getName().equals("特码")) {
                                        if (playOddsList.get(position).getPlays().get(i).getSelectName().equals("2") && playOddsList.get(position).getPlays().get(i).getZodiac() != null) {
                                            zodiacAdapter.ZodiacClearItem(playOddsList.get(position).getPlays().get(i).getZodiac());
                                            for (LotteryNewDetails.DataBean.SettingBean.ZodiacNumsBean zo : lotteryNewDetails.getData().getSetting().getZodiacNums()) {
                                                if (playOddsList.get(position).getPlays().get(i).getZodiac().equals(zo.getName())) {
                                                    for (int y = 0; y < zo.getNums().size(); y++) {
                                                        for (int p = 0; p < playOddsList.get(position).getPlays().size(); p++) {
                                                            if (p == Integer.parseInt(zo.getNums().get(y)) - 1) {
                                                                playOddsList.get(position).getPlays().get(p).setSelectName("1");
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
//                                    playList.remove(j);
//                                    playOddsList.get(position).getPlays().get(i).setSelect(isSelect);
//                                    playOddsList.get(position).getPlays().get(i).setSelectName("0");
//                                    break;
                                }

                                try {
                                    if (data.getPos().equals(playList.get(j).getPos())) {
                                        playList.remove(j);
                                        playOddsList.get(position).getPlays().get(i).setSelect(isSelect);
                                        playOddsList.get(position).getPlays().get(i).setSelectName("0");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                        ticketClassNameAdapter.notifyDataSetChanged();
                    }
                    if (td.getGameType().equals("lhc") && ticketClassList.get(leftPosition).getName().equals("自选不中")) {
                        if (count >= 5) {
                            tvSelectNumber.setText("1");
                        } else {
                            tvSelectNumber.setText("0");
                        }
                    } else if (td.getGameType().equals("lhc") && ticketClassList.get(leftPosition).getName().equals("合肖")) {
                        if (count > 1) {
                            tvSelectNumber.setText("1");
                        } else {
                            tvSelectNumber.setText("0");
                        }
                    } else if (td.getGameType().equals("lhc") && ticketClassList.get(leftPosition).getName().equals("连码")) {
                        if (playOddsList.get(position).getAlias().equals("四全中") && count > 3) {
                            tvSelectNumber.setText("1");
                        } else if (playOddsList.get(position).getAlias().equals("四全中") && count <= 3) {
                            tvSelectNumber.setText("0");
                        } else if (!playOddsList.get(position).getAlias().equals("四全中")) {
                            int betCount = ShowItem.selectBetCount(playOddsList.get(position).getAlias());
                            long s = Arrangement.combination(betCount, count);
                            tvSelectNumber.setText("" + s);
                        }
                    } else if (td.getGameType().equals("lhc") && (ticketClassList.get(leftPosition).getName().equals("连肖") || ticketClassList.get(leftPosition).getName().equals("连尾"))) {
                        if (playOddsList.get(position).getAlias().equals("二连肖") || playOddsList.get(position).getAlias().equals("二连尾")) {
                            if (count >= 2) {
                                int betCount = ShowItem.selectBetCount(playOddsList.get(position).getAlias());
                                long s = Arrangement.combination(betCount, count);
                                tvSelectNumber.setText("" + s);
                            }
                        } else if (playOddsList.get(position).getAlias().equals("三连肖") || playOddsList.get(position).getAlias().equals("三连尾")) {
                            if (count >= 3) {
                                int betCount = ShowItem.selectBetCount(playOddsList.get(position).getAlias());
                                long s = Arrangement.combination(betCount, count);
                                tvSelectNumber.setText("" + s);
                            }
                        } else if (playOddsList.get(position).getAlias().equals("四连肖") || playOddsList.get(position).getAlias().equals("四连尾")) {
                            if (count >= 4) {
                                int betCount = ShowItem.selectBetCount(playOddsList.get(position).getAlias());
                                long s = Arrangement.combination(betCount, count);
                                tvSelectNumber.setText("" + s);
                            }
                        } else if (playOddsList.get(position).getAlias().equals("五连肖") || playOddsList.get(position).getAlias().equals("五连尾")) {
                            if (count >= 5) {
                                int betCount = ShowItem.selectBetCount(playOddsList.get(position).getAlias());
                                long s = Arrangement.combination(betCount, count);
                                tvSelectNumber.setText("" + s);
                            }
                        }
                    } else if ((td.getGameType().equals("gd11x5")) && (ticketClassList.get(leftPosition).getName().equals("连码") || ticketClassList.get(leftPosition).getName().equals("直选"))) {
                        if (ticketClassList.get(leftPosition).getName().equals("直选")) {
                            int x = 0;
                            int y = 0;
                            int z = 0;
                            for (int q = 0; q < playList.size(); q++) {
                                if (playList.get(q).getBall() == 0) {
                                    x++;
                                } else if (playList.get(q).getBall() == 1) {
                                    y++;
                                } else if (playList.get(q).getBall() == 2) {
                                    z++;
                                }
                            }
                            int all = 0;
                            if (z != 0) {
                                all = x * y * z;
                            } else {
                                all = x * y;
                            }
                            tvSelectNumber.setText(all + "");
                        } else if (ticketClassList.get(leftPosition).getName().equals("连码")) {
//                            tvSelectNumber.setText((ShowItem.selectGdCount(playOddsList.get(position).getAlias(), count)) + "");
                            if (count >= 2 && playOddsList.get(position).getAlias().equals("前二组选")) {
//                                tvSelectNumber.setText(Arrangement.combination(2, count) + "");
                                tvSelectNumber.setText(Arrangement.combination(2, count) + "");
                            } else if (count >= 3 && playOddsList.get(position).getAlias().equals("前三组选")) {
                                tvSelectNumber.setText(Arrangement.combination(3, count) + "");
                            } else if (playOddsList.get(position).getAlias().equals("前二组选") || playOddsList.get(position).getAlias().equals("前三组选")) {
                                tvSelectNumber.setText("0");
                            } else {
                                tvSelectNumber.setText((ShowItem.selectGdCount(playOddsList.get(position).getAlias(), count)) + "");
                            }
                        }
                    } else if ((td.getGameType().equals("gdkl10") || td.getGameType().equals("xync")) && ticketClassList.get(leftPosition).getName().equals("连码")) {
                        if (playOddsList.get(position).getAlias().equals("任选二") || playOddsList.get(position).getAlias().equals("选二连组")) {
                            if (count > 1) {
                                tvSelectNumber.setText(Arrangement.combination(2, count) + "");
                            } else {
                                tvSelectNumber.setText("0");
                            }
                        } else if (playOddsList.get(position).getAlias().equals("任选三") || playOddsList.get(position).getAlias().equals("选三前组")) {
                            if (count > 2) {
                                tvSelectNumber.setText(Arrangement.combination(3, count) + "");
                            } else {
                                tvSelectNumber.setText("0");
                            }
                        } else if (playOddsList.get(position).getAlias().equals("任选四")) {
                            if (count > 3) {
                                tvSelectNumber.setText(Arrangement.combination(4, count) + "");
                            } else {
                                tvSelectNumber.setText("0");
                            }
                        } else if (playOddsList.get(position).getAlias().equals("任选五")) {
                            if (count > 4) {
                                tvSelectNumber.setText(Arrangement.combination(5, count) + "");
                            } else {
                                tvSelectNumber.setText("0");
                            }
                        }
                    } else if (ticketClassList.get(leftPosition).getName().equals("特码")) {
                        if (playList != null || playList.size() != 0) {
                            tvSelectNumber.setText(playList.size() + "");
                        }
                    } else {
                        tvSelectNumber.setText(String.valueOf(count));
                    }
                    selectLeftTitle();    //设置左边标题
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        });
        //        //右边顶部标题
        if (!td.getGameType().equals("lhc") && !td.getGameType().equals("gdkl10") && !td.getGameType().equals("gd11x5") && !td.getGameType().equals("xync")) {
            return;
        }
        playOddsList.get(0).setTitle(true);
        title = playOddsList.get(0).getAlias();
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        rvTitle.setLayoutManager(layoutManager);
        titleAdapter = new TitleAdapter(playOddsList, ticketClassList.get(leftPosition).getName(), "", getContext());
        rvTitle.setAdapter(titleAdapter);
        titleAdapter.setListener(new TitleAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if (!playOddsList.get(position).isTitle()) {
                    playOddsList.get(position).setTitle(true);
                    for (int i = 0; i < playOddsList.size(); i++) {
                        if (i != position)
                            playOddsList.get(i).setTitle(false);
                    }
                }
                title = playOddsList.get(position).getAlias();
                if (ticketClassList.get(leftPosition).getName().equals("连码") || ticketClassList.get(leftPosition).getName().equals("连肖") || ticketClassList.get(leftPosition).getName().equals("连尾") ||
                        ticketClassList.get(leftPosition).getName().equals("直选") || ticketClassList.get(leftPosition).getName().equals("正特") || ticketClassList.get(leftPosition).getName().equals("特码")) {
                    mClear(true);
                }

                //设置全局变量   右二标题需要用到
                if (ticketClassList.get(leftPosition).getName().equals("特码")) {
                    rightTitlePosition = position;
                }
                showItem(position);
                //去掉选中状态
                if (titleAdapter != null) {
                    titleAdapter.notifyDataSetChanged();
                }
                if (ticketClassNameAdapter != null) {
                    ticketClassNameAdapter.notifyDataSetChanged();
                }
                rvTicket.scrollToPosition(0);
            }
        });
    }


    //清除数据
    private void mClear(boolean isTitle) {
        tvSelectNumber.setText("0");
        if (playList != null && playList.size() != 0) {
            playList.clear();
        }
        if (ticketClassList == null || ticketClassNameAdapter == null || ticketClassAdapter == null) {
            return;
        }
        for (int i = 0; i < ticketClassList.size(); i++) {
            if (ticketClassList.get(i).isHave()) {
                ticketClassList.get(i).setHave(false);
            }
        }
        if (lotteryNewDetails.getData() != null && lotteryNewDetails.getData().getPlayOdds() != null) {
            int lotteryType = lotteryNewDetails.getData().getPlayOdds().size();
            for (int cunt = 0; cunt < lotteryType; cunt++) {
                if (lotteryNewDetails.getData().getPlayOdds().get(cunt).getPlayGroups() != null) {
                    int lotteryDet = lotteryNewDetails.getData().getPlayOdds().get(cunt).getPlayGroups().size();
                    for (int cun = 0; cun < lotteryDet; cun++) {
                        if (lotteryNewDetails.getData().getPlayOdds().get(cunt).getPlayGroups().get(cun).getPlays() != null) {
                            int play = lotteryNewDetails.getData().getPlayOdds().get(cunt).getPlayGroups().get(cun).getPlays().size();
                            if (!isTitle) {   //右边标题点击不需要清除标题点中状态
                                lotteryNewDetails.getData().getPlayOdds().get(cunt).getPlayGroups().get(cun).setTitle(false);
                            }
                            for (int c = 0; c < play; c++) {
                                lotteryNewDetails.getData().getPlayOdds().get(cunt).getPlayGroups().get(cun).getPlays().get(c).setSelect(false);
                            }
                        }
                    }
                    ticketClassNameAdapter.setCount(0);
                    ticketClassNameAdapter.setTypeCount(0);
                }
            }
        }
        if (!isTitle && playOddsList != null && playOddsList.size() != 0) {
            playOddsList.get(0).setTitle(true);
        }
        ticketClassAdapter.notifyDataSetChanged();

        //清除掉右2标题生肖选中状态
        if (rvZodiac.getVisibility() == View.VISIBLE) {
            if (zodiacAdapter != null) {
                zodiacAdapter.ZodiacClear();
            }
        }
    }

    //设置右上recyle
    private void showItem(int position) {
        if ((!td.getGameType().equals("lhc") && !td.getGameType().equals("gd11x5") && !td.getGameType().equals("gdkl10") && !td.getGameType().equals("xync")) || ticketClassNameAdapter == null) {
            return;
        }
        if (playOddsList != null && playOddsList.size() != 0) {
            ShowItem details = new ShowItem(playOddsList.get(position).getAlias(), td.getGameType());
            String[] num = details.itemCount();
            String mName = lotteryNewDetails.getData().getPlayOdds().get(leftPosition).getName();
            if (mName.equals("特码")) {
                ticketClassNameAdapter.showCount(num.length, mName, num, playOddsList.get(position).getAlias());
                rvTitle.setVisibility(View.VISIBLE);
            } else if (mName.equals("正特") || mName.equals("连肖") || mName.equals("连尾")) {
                rvTitle.setVisibility(View.VISIBLE);
                ticketClassNameAdapter.showCount(num.length, mName, num, playOddsList.get(position).getAlias());
            } else if (mName.equals("连码")) {
                rvTitle.setVisibility(View.VISIBLE);
                ticketClassNameAdapter.showCount(num.length, mName, num, playOddsList.get(position).getAlias());
            } else if (mName.equals("直选")) {
                rvTitle.setVisibility(View.VISIBLE);
                ticketClassNameAdapter.showCount(num.length, mName, num, playOddsList.get(position).getAlias());
            } else {
                rvTitle.setVisibility(View.GONE);
                ticketClassNameAdapter.showCount(0, "1", null, playOddsList.get(position).getAlias());
            }
        }
    }

    //设置右二
    private void zodiacRecyler() {
        if (td.getGameType().equals("lhc") && ticketClassList.get(leftPosition).getName().equals("特码")) {
            rvZodiac.setVisibility(View.VISIBLE);
            //清除掉右2标题生肖选中状态
            if (zodiacAdapter != null) {
                zodiacAdapter.ZodiacClear();
            }
        } else {
            rvZodiac.setVisibility(View.GONE);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @OnClick({R.id.tv_chip, R.id.tv_bet, R.id.tv_reset, R.id.ll_left, R.id.tv_title, R.id.tv_amount, R.id.iv_refresh, R.id.iv_more, /*R.id.iv_chat,*/ R.id.ll_mc, /*R.id.rl_chat,*/ R.id.tv_betarea, R.id.rl_chatarea})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_chip:
                moneyPopupWindow = new MoneyPopupWindow(getContext());
                moneyPopupWindow.showLocation(tvChip);
                moneyPopupWindow.moneyAdapter.setListener(new MoneyAdapter.OnClickListener() {
                    @Override
                    public void onClickListener(View view, int position) {
                        if (moneyPopupWindow.list.get(position).equals("清除"))
                            etNumber.setText("");
                        else
                            etNumber.setText(moneyPopupWindow.list.get(position));
                        moneyPopupWindow.dismiss();
                    }
                });
                break;
            case R.id.tv_bet:
                if (td == null)
                    return;
                if (td.getGameType() == null)
                    return;
                if (ticketClassList != null && ticketClassList.size() > 0 && (td.getGameType().equals("lhc") || td.getGameType().equals("gd11x5") || td.getGameType().equals("gdkl10") || td.getGameType().equals("xync")) && (ticketClassList.get(leftPosition).getName().equals("连码")
                        || ticketClassList.get(leftPosition).getName().equals("自选不中") || ticketClassList.get(leftPosition).getName().equals("合肖") || ticketClassList.get(leftPosition).getName().equals("连肖")
                        || ticketClassList.get(leftPosition).getName().equals("连尾")) && ShowItem.ItemCount(title, td.getGameType()) != 0) {
                    if (playList.size() < ShowItem.ItemCount(title, td.getGameType())) {
                        ToastUtil.toastShortShow(getContext(), "最少选中" + ShowItem.ItemCount(title, td.getGameType()) + "种");
                    } else {
                        gpBet();
                    }
                } else if (td.getGameType().equals("gd11x5") && ticketClassList != null && ticketClassList.size() > 0 && ticketClassList.get(leftPosition).getName().equals("直选")) {
                    if (playList.size() == 0) {
                        ToastUtil.toastShortShow(getContext(), "请选择玩法");
                        return;
                    }
                    Set<Integer> ballCount = new HashSet<>();
                    String name = null;
                    for (int i = 0; i < playOddsList.size(); i++) {
                        int play = playOddsList.get(i).getPlays().size();
                        for (int n = 0; n < play; n++) {
                            if (playOddsList.get(i).getPlays().get(n).getAlias().equals("前二直选")) {
                                if (playOddsList.get(i).getPlays().get(n).isSelect()) {
                                    name = playOddsList.get(i).getPlays().get(n).getAlias();
                                    ballCount.add(i);
                                }
                            } else if (playOddsList.get(i).getPlays().get(n).getAlias().equals("前三直选")) {
                                if (playOddsList.get(i).getPlays().get(n).isSelect()) {
                                    name = playOddsList.get(i).getPlays().get(n).getAlias();
                                    ballCount.add(i);
                                }
                            }
                        }
                    }
                    if (name != null && name.equals("前三直选")) {
                        if (ballCount.size() < 3) {
                            ToastUtil.toastShortShow(getContext(), "最少选中3种球类玩法");
                        } else {
                            gpBet();
                        }
                    } else if (name != null && name.equals("前二直选")) {
                        if (ballCount.size() < 2) {
                            ToastUtil.toastShortShow(getContext(), "最少选中2种球类玩法");
                        } else {
                            gpBet();
                        }
                    }
                } else {
                    gpBet();
                }
                break;
            case R.id.tv_reset:
                etNumber.setText("");
                try {
                    ticketClassNameAdapter.cleBallCount();
                    mClear(false);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (ticketClassNameAdapter != null) {
                    ticketClassNameAdapter.notifyDataSetChanged();
                }
                break;
            case R.id.ll_left:
//                finish();
                break;
            case R.id.tv_title:
                Intent intent = new Intent(getContext(), SelectLotteryTicketActivity.class);
                OpenHelper.startActivity(getContext(), intent, 1001);
                getActivity().overridePendingTransition(R.anim.activity_bottom_in, 0);

                break;
            case R.id.tv_amount:
                isSee = !isSee;
                if (isSee) {//¥
                    tvAmount.setTransformationMethod(PasswordTransformationMethod.getInstance());   //暗文
                    ivRefresh.setVisibility(View.GONE);
                } else {
                    tvAmount.setTransformationMethod(HideReturnsTransformationMethod.getInstance()); //明文
                    ivRefresh.setVisibility(View.VISIBLE);
                }

                break;
            case R.id.iv_refresh:
                objectAnimator = ObjectAnimator.ofFloat(ivRefresh, "rotation", 0f, 360f);
                objectAnimator.setDuration(2000);
                objectAnimator.start();
//                tvAmount.setText("..");
                String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
                if (!token.equals(SPConstants.SP_NULL)) {
                    getUserInfo(token);
                } else {
//                    startActivity(new Intent(TicketDetailsActivity.this, LoginActivity.class));
                    Uiutils.login(getContext());
                }
                break;
            case R.id.iv_more:
                dlDrawerLayout.openDrawer(Gravity.RIGHT);
                break;
            case R.id.ll_mc:

                break;
//            case R.id.rl_chat:
//                skipChat(Constants.BaseUrl() + Constants.CHATROOM + td.getGameId(), "", "");
//                break;
//            case R.id.iv_chat:
//                skipChat(Constants.BaseUrl() + Constants.CHATROOM + td.getGameId(), "", "");
//                break;

            case R.id.tv_betarea:  //投注区和聊天室选择
                selectTab(true);
                break;
            case R.id.rl_chatarea: //投注区和聊天室选择
                selectTab(false);
                break;
        }
    }

    private void shareToRoom(String shareBetJson, String shareBetInfoJson) {
        if (mRoomWindow == null || mRoomWindow.getRoomNum() <= 1) {
            mChatFragment.share("0", shareBetJson, shareBetInfoJson);
        } else {
            mRoomWindow.setOnItemClickListener((position, b) -> {
                try {
                    RoomListBean.DataBean.ChatAryBean tempBean = (RoomListBean.DataBean.ChatAryBean) chatRoomBean.clone();
                    chatRoomBean = b;
                    enterChatRoom(new TicketAndChatFrament.EnterChatRoomListener() {
                        @Override
                        public void onPasswordSuccess() {
                            mRoomWindow.setCheck(b.getRoomId());
//                            rbChat.setText(b.getRoomName());
//                            rgTab.check(R.id.rb_chat);

                            mChatFragment.share(b.getRoomId(), shareBetJson, shareBetInfoJson);
                            mChatFragment.checkRoom(b);

                            rbChat.setText(b.getRoomName());
                            rlChatarea.setBackgroundColor(getResources().getColor(R.color.color_33FFF));
                            tvBetarea.setBackgroundColor(0);
                            llTicket.setVisibility(View.GONE);
                            flInput.setVisibility(View.GONE);
                            flChat.setVisibility(View.VISIBLE);
                        }

                        @Override
                        public void onPasswordError() {
                            chatRoomBean = tempBean;
                        }
                    });
                } catch (CloneNotSupportedException e) {
                    e.printStackTrace();
                }
            });
            mRoomWindow.show(llMain, 0, 0);
        }
    }
    private void skipChat(String url, String shareBetJson, String shareBetInfoJson) {
        Intent intent2 = new Intent(getContext(), WebActivity.class);
        intent2.putExtra("url", url);
        intent2.putExtra("type", "chat");
        intent2.putExtra("shareBetJson", shareBetJson);
        intent2.putExtra("shareBetInfoJson", shareBetInfoJson);
//        Log.e("xxxxxurl", url);
//        Log.e("shareBetJson", shareBetJson);
//        Log.e("shareBetInfoJson", shareBetInfoJson);
        startActivity(intent2);
    }

    //下注
    boolean istest = false;

    private void gpBet() {

        UserInfo userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        if (userInfo != null && userInfo.getData() != null) {
            istest = userInfo.getData().isIsTest();
        }
//        Log.e("xxxxxxistest", "" + istest);
//        boolean istest = SPConstants.getValue(this, SPConstants.SP_ISTEST);
        String number = etNumber.getText().toString().trim();
        String betCount = tvSelectNumber.getText().toString().trim();

        if (playList.size() == 0)
            ToastUtil.toastShortShow(getContext(), getResources().getString(R.string.select_play));
        else if (TextUtils.isEmpty(number))
            ToastUtil.toastShortShow(getContext(), getResources().getString(R.string.select_money));
        else if ((lotteryNum != null && lotteryNum.getData() != null) || (td.getIsInstant() != null && td.getIsInstant().equals("1"))) {
            for (int i = 0; i < playList.size(); i++) {
                playList.get(i).setAmount(number);
            }
            try {
                final BuyTicketDialog buyTicketDialog = new BuyTicketDialog(getActivity());
                buyTicketDialog.show();
                buyTicketDialog.allData(playOddsList, tvTitle.getText().toString(), lotteryNewDetails.getData().getPlayOdds().get(leftPosition).getCode());
                if (td.getIsInstant() != null && td.getIsInstant().equals("1"))
                    buyTicketDialog.setTitle("即买即开，期期精彩");
                else
                    buyTicketDialog.setTitle(lotteryNum.getData().getCurIssue() + getResources().getString(R.string.issue) + tvTitle.getText().toString() + getResources().getString(R.string.bet_detail));

//                String curClose = lotteryNum==null?"":lotteryNum.getData().getCurCloseTime()
                buyTicketDialog.setList(istest, playList, lotteryNum == null ? "0" : lotteryNum.getData().getCurCloseTime(), lotteryNum == null ? 0 : lastClickTime - (System.currentTimeMillis() - timeSys),
                        td.getGameId(), lotteryNum == null ? "0" : lotteryNum.getData().getCurIssue() + "", ticketClassList.get(leftPosition).getName() + "",
                        td.getGameType() + "", betCount, title, ids, td.getIsInstant());
                double d;
                if (td.getGameType().equals("lhc") && (ticketClassList.get(leftPosition).getName().equals("自选不中") || ticketClassList.get(leftPosition).getName().equals("合肖"))) {
                    d = Double.valueOf(number);
                } else if (td.getGameType().equals("lhc") && ticketClassList.get(leftPosition).getName().equals("连码")) {
                    d = Double.valueOf(number) * Double.parseDouble(betCount);
                } else if (td.getGameType().equals("lhc") && (ticketClassList.get(leftPosition).getName().equals("连肖")) || ticketClassList.get(leftPosition).getName().equals("连尾")) {
                    d = Double.valueOf(number) * Double.parseDouble(betCount);
                } else if (td.getGameType().equals("gd11x5") && ticketClassList.get(leftPosition).getName().equals("连码")) {
                    d = Double.valueOf(number) * Double.parseDouble(betCount);
                } else if (td.getGameType().equals("gdkl10") && ticketClassList.get(leftPosition).getName().equals("连码")) {
                    d = Double.valueOf(number) * Double.parseDouble(betCount);
                } else if (td.getGameType().equals("xync") && ticketClassList.get(leftPosition).getName().equals("连码")) {
                    d = Double.valueOf(number) * Double.parseDouble(betCount);
                } else if (td.getGameType().equals("gd11x5") && ticketClassList.get(leftPosition).getName().equals("直选")) {

                    int x = 0;
                    int y = 0;
                    int z = 0;
                    for (int i = 0; i < playList.size(); i++) {
                        if (playList.get(i).getBall() == 0) {
                            x++;
                        } else if (playList.get(i).getBall() == 1) {
                            y++;
                        } else if (playList.get(i).getBall() == 2) {
                            z++;
                        }
                    }
                    if (z != 0) {
                        d = x * y * z * Double.parseDouble(number);
                        tvSelectNumber.setText((x * y * z) + "");
                    } else {
                        d = x * y * Double.parseDouble(number);
                        tvSelectNumber.setText((x * y) + "");
                    }

                } else {
                    d = Double.valueOf(number) * playList.size();
                }
                buyTicketDialog.setTotalAmount(d);
                buyTicketDialog.setOnClickListener(new BuyTicketDialog.OnClickListener() {

                    private String[] array;
                    String title = "";
                    String content = "";

                    @Override
                    public void onClickListener(View view, int s, String json, BetBean betData, String shareBetJson, String shareBetInfoJson, String allAmount) {
                        if (s == 0) {
//                            ToastUtil.toastShortShow(TicketDetailsActivity.this,"下注成功");
                            if (td.getIsInstant() != null && td.getIsInstant().equals("1")) {
                                Bundle build = new Bundle();
                                build.putString("json", json == null ? "Null" : json);
                                build.putInt("code", betData.getCode());
                                build.putString("type", td.getGameType());
                                build.putString("gameId", td.getGameId());
                                build.putString("openNum", betData.getData().getOpenNum() == null ? "Null" : betData.getData().getOpenNum());
                                build.putString("result", betData.getData().getResult() == null ? "Null" : betData.getData().getResult());
                                build.putString("bonus", betData.getData().getBonus() == null ? "Null" : betData.getData().getBonus());
                                IntentUtils.getInstence().startActivityForResult(getActivity(), SecsecActivity.class, 1004, build);
                            } else {
                                ConfigBean configBean = (ConfigBean) ShareUtils.getObject(getActivity(),
                                        SPConstants.CONFIGBEAN, ConfigBean.class);
                                if (!istest && configBean != null && configBean.getData() != null && configBean.getData().isChatRoomSwitch() && configBean.getData().isChatFollowSwitch() && !TextUtils.isEmpty(configBean.getData().getChatMinFollowAmount())) {
                                    if (ShowItem.isNumeric(ShowItem.subZeroAndDot(configBean.getData().getChatMinFollowAmount()))) {
                                        double minAmount = Double.parseDouble(configBean.getData().getChatMinFollowAmount());
                                        double amount = 0;
                                        if (ShowItem.isNumeric(ShowItem.subZeroAndDot(allAmount))) {
                                            amount = Double.parseDouble(allAmount);
                                        }
                                        if (amount >= minAmount) {
                                            array = new String[]{getResources().getString(R.string.cancel), "分享"};
                                            title = "分享注单";
                                            content = "是否分享到聊天室";
                                        } else {
                                            title = "提示信息";
                                            content = "下注成功";
                                            array = new String[]{getResources().getString(R.string.affirm)};
                                        }
                                    } else {
                                        array = new String[]{getResources().getString(R.string.cancel), "分享"};
                                        title = "分享注单";
                                        content = "是否分享到聊天室";
                                    }
                                } else {
                                    title = "提示信息";
                                    content = "下注成功";
                                    array = new String[]{getResources().getString(R.string.affirm)};
                                }

                                TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, title, content, "", new TDialog.onItemClickListener() {
                                    @Override
                                    public void onItemClick(Object object, int position) {
                                        String token = SPConstants.getValue(getActivity(), SPConstants.SP_API_SID);
                                        if (!token.equals(SPConstants.SP_NULL)) {
                                            getUserInfo(token);
                                            if (ticketClassNameAdapter != null)
                                                ticketClassNameAdapter.cleBallCount();
                                        } else {
//                                            startActivity(new Intent(TicketDetailsActivity.this, LoginActivity.class));
                                            Uiutils.login(getActivity());
                                        }
//Log.e("shareBetJson",""+shareBetJson);
//Log.e("shareBetInfoJson",""+shareBetInfoJson);
//                                        if (position == 1 && shareBetJson != null && shareBetInfoJson != null && configBean != null && configBean.getData() != null) {
//
//                                            String roomName = TextUtils.isEmpty(configBean.getData().getChatRoomName()) ? "" : configBean.getData().getChatRoomName();
//                                            skipChat(Constants.BaseUrl() + Constants.SHARECHATROOM + roomName, shareBetJson, shareBetInfoJson);
//
//                                        }
                                        if (Uiutils.isSite("chat")) {
                                            if (shareBetJson != null && shareBetInfoJson != null && configBean != null && configBean.getData() != null) {
                                                switch (array[position]) {
                                                    case "分享到朋友圈":
                                                        shareToFriends(json, shareBetInfoJson);
                                                        break;
                                                    case "分享到聊天":
                                                        shareToChat(json, shareBetInfoJson);
                                                        break;
                                                }
                                            }
                                        } else {
                                            if (position == 1 && shareBetJson != null && shareBetInfoJson != null && configBean != null && configBean.getData() != null) {
                                                shareToRoom(shareBetJson, shareBetInfoJson);
                                            }
                                        }
                                    }
                                });
                                mClear(false);
                                ticketClassNameAdapter.notifyDataSetChanged();
                                mTDialog.setCancelable(false);
                                mTDialog.show();
                            }
                        } else {
//                              ToastUtils.ToastUtils("请登录后再访问",TicketDetailsActivity.this);
                        }
                        buyTicketDialog.dismiss();
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            ToastUtil.toastShortShow(getContext(), getResources().getString(R.string.getdata_failed));
        }
    }

    @SuppressLint("RestrictedApi")
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == 1001 ) {
            assert data != null;
            String ticketDetails = data.getStringExtra("ticketDetails");
            td = new Gson().fromJson(ticketDetails, TicketDetails.class);
            if (playOddsList != null)
                playOddsList.clear();
            if (ticketClassNameAdapter != null)
                ticketClassNameAdapter.notifyDataSetChanged();
            if (playList != null)
                playList.clear();
            tvSelectNumber.setText("0");
            if (mCustomPopWindow != null)
                mCustomPopWindow = null;
            if (ticketClassList != null)
                ticketClassList.clear();
            if (ticketClassAdapter != null)
                ticketClassAdapter.notifyDataSetChanged();
            etNumber.setText("");
            initData(true);
        } else if (requestCode == 1004) {
            try {
                mClear(false);
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (ticketClassNameAdapter != null) {
                ticketClassNameAdapter.notifyDataSetChanged();
            }
            String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
            if (!token.equals(SPConstants.SP_NULL)) {
                getinfo(token);
            } else {
//                startActivity(new Intent(TicketDetailsActivity.this, LoginActivity.class));
                Uiutils.login(getContext());
            }
        } else {
            if (mChatFragment != null) {
                mChatFragment.onActivityResult(requestCode, resultCode, data);
            }
        }
    }

    private void changeLotteryData() {
        OkHttp3Utils.doGet(URLDecoder.decode(Constants.BaseUrl() + Constants.LOTTERYGAMEODDS + SecretUtils.DESede(td.getGameId()) + "&sign=" + SecretUtils.RsaToken()), new ObjectCallback() {
            @Override
            public void onUi(boolean b, String t) {
                String data = t;
                BaseBean bb = new Gson().fromJson(data, BaseBean.class);
                if (bb != null && bb.getCode() == 0) {
                    lotteryNewDetails = new Gson().fromJson(data, LotteryNewDetails.class);
                    try {
                        playRule();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            @Override
            public void onFailed(Call call, IOException e) {

            }
        });
    }

    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            questLotteryNum(false);
        }
    };


    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelTag(this);
        handler.removeCallbacks(runnable);
        if (tvCloseCountDown != null) {
            tvCloseCountDown.stop();
        }
        super.onDestroy();
    }


    //侧滑菜单调用
    public void closeSlidingMenu() {
        dlDrawerLayout.closeDrawer(Gravity.RIGHT);
    }

    //获取登录信息
    private void getUserInfo(String s) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(s) + "&sign=" + SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(getContext(), true, getContext(), true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                UserInfo li = (UserInfo) o;
                saveSp(li);
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
            }

            @Override
            public void onFailed(Response<String> response) {
            }
        });
    }

    private void saveSp(UserInfo li) {
        if (li != null && li.getCode() == 0 && li.getData() != null) {
            SharedPreferences.Editor edit = sp.edit();
            edit.putString(SPConstants.SP_BALANCE, li.getData().getBalance() == null ? "0" : FormatNum.amountFormat(li.getData().getBalance(), 4));   //金额
            edit.putString(SPConstants.SP_USR, li.getData().getUsr() == null ? "" : li.getData().getUsr());

            edit.putString(SPConstants.SP_CURLEVELGRADE, li.getData().getCurLevelGrade() == null ? "" : li.getData().getCurLevelGrade());
            edit.putString(SPConstants.SP_NEXTLEVELGRADE, li.getData().getNextLevelGrade() == null ? "" : li.getData().getNextLevelGrade());

            edit.putString(SPConstants.SP_CURLEVELINT, li.getData().getCurLevelInt() == null ? "" : li.getData().getCurLevelInt());
            edit.putString(SPConstants.SP_NEXTLEVELINT, li.getData().getNextLevelInt() == null ? "" : li.getData().getNextLevelInt());

            edit.putString(SPConstants.SP_TASKREWARDTITLE, li.getData().getTaskRewardTitle() == null ? "" : li.getData().getTaskRewardTitle());
            edit.putString(SPConstants.SP_TASKREWARDTOTAL, li.getData().getTaskRewardTotal() == null ? "" : li.getData().getTaskRewardTotal());

            edit.putString(SPConstants.SP_HASBANKCARD, li.getData().isHasBankCard() + "");
            edit.putString(SPConstants.SP_HASFUNDPWD, li.getData().isHasFundPwd() + "");
            edit.putString(SPConstants.SP_TASKREWARD, li.getData().getTaskReward() == null ? "" : li.getData().getTaskReward());
            edit.putString(SPConstants.SP_ISTEST, li.getData().isIsTest() + "");
            //头像
            edit.putString(SPConstants.AVATAR, li.getData().getAvatar() == null ? "" : li.getData().getAvatar());
            edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, li.getData().isYuebaoSwitch());
            edit.commit();
            ShareUtils.saveObject(getContext(), SPConstants.USERINFO, li);
            EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
            if (tvAmount != null)
                tvAmount.setText(FormatNum.amountFormat(li.getData().getBalance(), 4));
        }
    }

    private void initInfo() {
        String amount = SPConstants.getValue(getContext(), SPConstants.SP_BALANCE);
        if (tvAmount != null)
            tvAmount.setText(amount);
    }

    private View contentView;
    private CustomPopWindow mCustomPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;

    /**
     * 广告pop
     */
    private void setAdvertisementPop() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.bet_pop_lay, null);
        contentView.findViewById(R.id.bet_pop_close_tex).setOnClickListener(this);
        contentView.findViewById(R.id.bet_pop_goto_tex).setOnClickListener(this);

        ImageLoadUtil.ImageLoad(lotteryNum.getData().getAdPic(), getContext(),
                contentView.findViewById(R.id.bet_pop_img), "");
        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);
        if (mCustomPopWindow == null) {
            mCustomPopWindow = popupWindowBuilder.create();
            mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
            Uiutils.setStateColor(getActivity());
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.RULES_OF_COLOR_SEED:
                getLotteryrule();
                break;
            case EvenBusCode.LONG_REFRESH_AMOUNT:
                getinfo(Uiutils.getToken(getActivity()));
                break;
        }
    }

    private StringBean stringBean;

    private void getLotteryrule() {
        Map<String, Object> map = new HashMap<>();
        map.put("id", td.getGameId());

        NetUtils.get(Constants.LOTTERYRULE1, map, true,
                getContext(), new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        stringBean = Uiutils.stringToObject(object, StringBean.class);
                        rulePop();
                    }

                    @Override
                    public void onError() {

                    }
                });
    }

    /**
     * 规则POP
     */
    private void rulePop() {
        if (null != stringBean) {
            String[] array = {getResources().getString(R.string.affirm)};
            View inflate = LayoutInflater.from(getContext()).inflate(R.layout.alertext_from, null);
            ((EditText) inflate.findViewById(R.id.from_et)).setVisibility(View.GONE);
            TextView tv_tv = (TextView) inflate.findViewById(R.id.tv_tv);
            tv_tv.setVisibility(View.VISIBLE);

            String data = "<font color='#fffefe' size='50px'>" + stringBean.getData() + "</font>";
//            data = data.replaceAll("ff0000", "fffefe");
            Spanned spanned = Html.fromHtml(data);
            tv_tv.setText(spanned);
            tv_tv.setMovementMethod(ScrollingMovementMethod.getInstance());
            tv_tv.setFocusable(false);
            TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, "", "", ""
                    , new TDialog.onItemClickListener() {
                @Override
                public void onItemClick(Object object, int pos) {

                }
            });
            mTDialog.setMsgGravity(Gravity.CENTER);
            mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
            mTDialog.setItemTextColorAt(0,
                    0 == ShareUtils.getInt(getContext(), "ba_top", 0)
                            ? getResources().getColor(R.color.textColor_alert_button_cancel) : getResources().getColor(ShareUtils.
                            getInt(getContext(), "ba_top", 0)));
            mTDialog.addView(inflate);
            mTDialog.setItemVisibility();
            mTDialog.show();
        }
    }

    @OnClick({R.id.long_queue_img, R.id.lottery_network_img, R.id.lottery_live_img})
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.commit_tex:
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.bet_pop_close_tex:
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.bet_pop_goto_tex:
//                if (lotteryNum.getData().getAdLink() != null && !lotteryNum.getData().getAdLink().equals("-1") && lotteryNum.getData().getAdLinkType() != null) {
//                    td.setGameType(lotteryNum.getData().getAdLinkType());
//                    td.setGameId(lotteryNum.getData().getAdLink());
//                    initView();
//                } else
                if (lotteryNum.getData().getAdLink() != null && lotteryNum.getData().getAdLink().equals("-1")) {
                    startActivity(new Intent(getContext(), InterestDoteyActivity.class));
                } else if (lotteryNum.getData().getAdLink() != null && lotteryNum.getData().getAdLink().equals("-2")) {
//                    if (Uiutils.isTourist(this))
//                        return;
                    FragmentUtilAct.startAct(getContext(), new MissionCenterFrag(false));
                } else if (lotteryNum.getData().getAdLink() != null && lotteryNum.getData().getAdLinkType() != null) {
                    td.setGameType(lotteryNum.getData().getAdLinkType());
                    td.setGameId(lotteryNum.getData().getAdLink());
                    initView(null);
                }
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.long_queue_img:
                FragmentUtilAct.startAct(getContext(), new DragonAssistantFrag(false));
                break;
            case R.id.lottery_network_img:
                Bundle build = new Bundle();
                build.putString("url", Constants.BaseUrl() + "/open_prize/index.mobile.html?navhidden=1");
                build.putString("title", "");
                FragmentUtilAct.startAct(getContext(), new PubWebviewFrag(), build);
                break;
            case R.id.lottery_live_img:
                Bundle build0 = new Bundle();
                build0.putString("url", Constants.BaseUrl() + "/open_prize/video.html?id=" + td.getGameId() + "&&gameType=" + td.getGameType() + "&&navhidden=1");
                build0.putString("title", "");
                FragmentUtilAct.startAct(getContext(), new PubWebviewFrag(), build0);
                break;
        }
    }

//    public String getId() {
//        return td.getGameId();
//    }
//
//    public String getGameType() {
//        return null != td && !StringUtils.isEmpty(td.getGameType()) ? td.getGameType() : "";
//    }

    public String getisInstant() {
        return null != td && !StringUtils.isEmpty(td.getIsInstant()) ? td.getIsInstant() : "";
    }

    private void getinfo(String token) {
        OkHttp3Utils.doGet(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken()), new GsonObjectCallback<UserInfo>() {
            @Override
            public String onUi(boolean b, UserInfo userInfo) {
                saveSp(userInfo);
                return null;
            }

            @Override
            public void onFailed(Call call, IOException e) {

            }
        });
    }


    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        handler.removeCallbacks(runnable);
    }

    private boolean isKeyBoardOpen = false;


    MainActivity mActivity;
    BlackMainActivity mBlackActivity;
    private void addOnSoftKeyBoardVisibleListener() {
        if (getActivity() instanceof MainActivity)
            mActivity = (MainActivity) getActivity();
        if (getActivity() instanceof BlackMainActivity)
            mBlackActivity = (BlackMainActivity) getActivity();
        final View decorView = getActivity().getWindow().getDecorView();
        decorView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                Rect rect = new Rect();
                decorView.getWindowVisibleDisplayFrame(rect);
                isKeyBoardOpen = (double) (rect.bottom - rect.top) / decorView.getHeight() < 0.8;
//                Log.e("xxxx","虚拟按键隐藏时的处理"+isKeyBoardOpen);
                if (!isKeyBoardOpen && moneyPopupWindow != null){
                    moneyPopupWindow.dismiss();
                }
                if (isKeyBoardOpen){
                    if (getActivity() instanceof MainActivity)
                        mActivity.setRadioGroup(View.GONE);
                    if (getActivity() instanceof BlackMainActivity)
                        mBlackActivity.setRadioGroup(View.GONE);
                }else{
                    if (getActivity() instanceof MainActivity)
                        mActivity.setRadioGroup(View.VISIBLE);
                    if (getActivity() instanceof BlackMainActivity)
                        mBlackActivity.setRadioGroup(View.VISIBLE);
                }
            }
        });
    }

    private void shareToFriends(String json, String shareJson) {
        try {
            String usr = SPConstants.getValue(getContext(), SPConstants.SP_USR);
            String pwd = SPConstants.getValue(getContext(), SPConstants.SP_PASSWORD);
            String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);

            JsonObject object = JsonParser.parseString(json).getAsJsonObject();
            SecretUtils.encodeJson(object);
            {
                object.addProperty("usr", usr);
                object.addProperty("pwd", pwd);
            }
            JsonObject shareObject = JsonParser.parseString(shareJson).getAsJsonObject();
            {
                shareObject.addProperty("is_instant", td.getIsInstant());
            }
            object.add("share_data", shareObject);

            OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.SHARE_TO_FRIENDS))
                    .tag(this)
                    .params("usr", SecretUtils.DESede(usr))
                    .params("pwd", SecretUtils.DESede(pwd))
                    .params("token", SecretUtils.DESede(token))
                    .params("msgType", SecretUtils.DESede("1"))
                    .params("content", SecretUtils.DESede("注单分享吧"))
                    .params("otherData", SecretUtils.DESede(object.toString()))
                    .params("sign", SecretUtils.RsaToken())
                    .execute(new NetDialogCallBack(getContext(), true, this, true, BaseBean.class) {
                        @Override
                        public void onUi(Object o) {
                            BaseBean bean = (BaseBean) o;
                            if (bean != null && bean.getCode() == 0) {
                                ToastUtils.ToastUtils(bean.getMsg(), getContext());
                                EventBus.getDefault().post(new SendShareEvent());
                            }
                        }

                        @Override
                        public void onErr(BaseBean bb) {
                        }

                        @Override
                        public void onFailed(Response<String> response) {
                        }

                        @Override
                        public void onFinish() {
                        }
                    });
        } catch (JsonParseException e) {
            e.printStackTrace();
            ToastUtils.ToastUtils("数据结构错误", getContext());
        }
    }

    private void shareToChat(String json, String shareBetInfoJson) {
        try {
            TicketListEntity.DataBean bean = new Gson().fromJson(json, TicketListEntity.DataBean.class);
            ShareBetInfoEntity betInfoEntity = new Gson().fromJson(shareBetInfoJson, ShareBetInfoEntity.class);

            bean.setGameName(betInfoEntity.getGameName());
            bean.setTotalNums(betInfoEntity.getTotalNums());
            bean.setTurnNum(betInfoEntity.getTurnNum());

            for (TicketListEntity.DataBean.BetBeanBean betBean : bean.getBetBean()) {
                for (ShareBetInfoEntity.BetParamsBean betParams : betInfoEntity.getBetParams()) {
                    if (betBean.getPlayId().equals(betParams.getPlayId())) {
                        betBean.setName(betParams.getName());
                        betBean.setBetNum("1");
                        break;
                    }
                }
            }

            SelectGroupActivity.start(getContext(), bean);
        } catch (Exception e) {
            e.printStackTrace();
            ToastUtils.ToastUtils("分享数据格式错误", getContext());
        }
    }

    interface EnterChatRoomListener {
        void onPasswordSuccess();

        void onPasswordError();
    }

    private void enterChatRoom(TicketAndChatFrament.EnterChatRoomListener enterChatRoomListener) {
        if (chatRoomBean == null) {
            enterChatRoomListener.onPasswordSuccess();
        } else {
            String keyName = chatRoomBean.getRoomId() + "|" + chatRoomBean.getRoomName();
            //MainActivity onCreate中清除保存的密码不想改了
            if (TextUtils.isEmpty(chatRoomBean.getPassword()) || getActivity().getSharedPreferences("SP_CHAT_ROOM", MODE_PRIVATE).getString(keyName, "").equals(chatRoomBean.getPassword())) {
                enterChatRoomListener.onPasswordSuccess();
            } else {
                ChatRoomPasswordDialog dialog = new ChatRoomPasswordDialog(getContext());
                dialog.setOnPasswordListener(new ChatRoomPasswordDialog.OnPasswordListener() {
                    @Override
                    public void onSureClick(String password) {
                        if (password.equals(chatRoomBean.getPassword())) {
                            getContext().getSharedPreferences("SP_CHAT_ROOM", MODE_PRIVATE).edit()
                                    .putString(keyName, chatRoomBean.getPassword())
                                    .apply();
                            enterChatRoomListener.onPasswordSuccess();
                        } else {
                            ToastUtils.ToastUtils("密码错误", getContext());
                            enterChatRoomListener.onPasswordError();
                        }
                    }

                    @Override
                    public void onDismiss() {
//                        ToastUtil.toastShortShow(TicketDetailsActivity.this,"1111111222");
                        enterChatRoomListener.onPasswordError();
                    }
                });
                dialog.show();
            }
        }
    }


    private void selectTab(boolean b) {
        if (b) {
            tvBetarea.setBackgroundColor(getResources().getColor(R.color.color_33FFF));
            rlChatarea.setBackgroundColor(0);
            llTicket.setVisibility(View.VISIBLE);
            flInput.setVisibility(View.VISIBLE);
            flChat.setVisibility(View.GONE);
        }else {
            ColorDrawable colorDrawable= (ColorDrawable) rlChatarea.getBackground();
            if(colorDrawable.getColor()==getResources().getColor(R.color.color_33FFF)&&chatRoomBean!=null){
                mRoomWindow.show(llMain, 0, 0);
            }
//            initChatRoomList();
            rlChatarea.setBackgroundColor(getResources().getColor(R.color.color_33FFF));
            tvBetarea.setBackgroundColor(0);
            llTicket.setVisibility(View.GONE);
            flInput.setVisibility(View.GONE);
            flChat.setVisibility(View.VISIBLE);
//            if(mRoomWindow!=null){
//                enterChatRoomListener(mRoomWindow.getFirstChatBean());
//            }
        }
    }

    private void roomListener() {
        mRoomWindow.setOnItemClickListener((position, b) -> {
            try {
                RoomListBean.DataBean.ChatAryBean tempBean = (RoomListBean.DataBean.ChatAryBean) chatRoomBean.clone();
                chatRoomBean = b;
                enterChatRoom(new TicketAndChatFrament.EnterChatRoomListener() {
                    @Override
                    public void onPasswordSuccess() {
                        mChatFragment.checkRoom(b);
                        mRoomWindow.setCheck(b.getRoomId());
                        tvChatarea.setText(b.getRoomName());
                    }

                    @Override
                    public void onPasswordError() {
                        chatRoomBean = tempBean;
                    }
                });
            } catch (CloneNotSupportedException e) {
                e.printStackTrace();
            }
        });
    }
}
