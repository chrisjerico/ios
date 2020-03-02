package com.phoenix.lotterys.my.fragment;

import android.app.DatePickerDialog;
import android.graphics.Color;
import android.icu.util.Calendar;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.DatePicker;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.NoteRecordAdapter;
import com.phoenix.lotterys.my.adapter.NoteRecordAdapter1;
import com.phoenix.lotterys.my.adapter.NoteRecordPopAdapter;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.NoteRecordBean;
import com.phoenix.lotterys.my.bean.NoteRecordBean1;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:注单记录
 * 创建者: IAN
 * 创建时间: 2019/7/6 20:07
 */
public class NoteRecordFrag extends BaseFragments implements BaseRecyclerAdapter.
        OnItemClickListener, View.OnClickListener, OnRefreshListener, OnLoadMoreListener,
        DatePickerDialog.OnDateSetListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.tv01)
    TextView tv01;
    @BindView(R2.id.tv02)
    TextView tv02;
    @BindView(R2.id.tv03)
    TextView tv03;
    @BindView(R2.id.tv04)
    TextView tv04;
    @BindView(R2.id.tv05)
    TextView tv05;

    @BindView(R2.id.iv_tab_bottom_img)
    TextView ivTabBottomImg;
    @BindView(R2.id.name_tex)
    TextView nameTex;
    @BindView(R2.id.name_tex_lin)
    TextView nameTexLin;
    @BindView(R2.id.happiness_tex)
    TextView happinessTex;
    @BindView(R2.id.happiness_tex_lin)
    TextView happinessTexLin;
    @BindView(R2.id.happy_balance_tex)
    TextView happyBalanceTex;
    @BindView(R2.id.happy_balance_tex_lin)
    TextView happyBalanceTexLin;
    @BindView(R2.id.full_date_tex)
    TextView fullDateTex;
    @BindView(R2.id.full_date_lin)
    LinearLayout fullDateLin;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.note_record_rec)
    RecyclerView noteRecordRec;
    @BindView(R2.id.note_record_refresh)
    SmartRefreshLayout noteRecordRefresh;
    @BindView(R2.id.navigation_bar_lin)
    LinearLayout navigationBarLin;
    @BindView(R2.id.no_more_records_tex)
    TextView noMoreRecordsTex;
    @BindView(R2.id.total_money_tex)
    TextView totalMoneyTex;
    @BindView(R2.id.win_lose_tex)
    TextView winLoseTex;
    @BindView(R2.id.win_lose_lin)
    LinearLayout winLoseLin;
    @BindView(R2.id.iv_tab_bottom_lin)
    LinearLayout ivTabBottomLin;
    @BindView(R2.id.vip_tex)
    TextView vipTex;
    @BindView(R2.id.vip_lin)
    RelativeLayout vipLin;
    @BindView(R2.id.name_text1)
    TextView nameText1;
    @BindView(R2.id.happiness_tex0)
    TextView happinessTex0;
    @BindView(R2.id.happiness_tex_lin5)
    TextView happinessTexLin5;
    @BindView(R2.id.happiness_tex_5)
    TextView happinessTex5;
    @BindView(R2.id.note_record_rec1)
    RecyclerView noteRecordRec1;
    @BindView(R2.id.left_texaa)
    TextView leftTex;
    @BindView(R2.id.right_tex)
    TextView rightTex;

    private ImageView iv_more;

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private NoteRecordPopAdapter popAdapter;
    private List<My_item> listDate = new ArrayList<>();
    private List<My_item> noteList = new ArrayList<>();
    private List<My_item> listPop = new ArrayList<>();
    private CustomPopWindow mCustomPopWindow;
    private View contentView;
    private View contentViewDialog;
    private RecyclerView popRec;
    private List<NoteRecordBean.DataBean.ListBean> list = new ArrayList<>();
    private List<NoteRecordBean1.DataBean.TicketsBean> list1 = new ArrayList<>();
    private NoteRecordAdapter adapter;
    private NoteRecordAdapter1 adapter1;
    private TextView[] titles;
    private float toX;
    /**
     * 偏移量（手机屏幕宽度 / 选项卡总数 - 选项卡长度） / 2
     */
    private int offset = 0;

    /**
     * 下划线图片宽度
     */
    private int lineWidth;

    /**
     * 当前选项卡的位置
     */
    private int current_index = 0;

    /**
     * 选项卡总数
     */
    private static final int TAB_COUNT = 4;

    private static final int TAB_0 = 0;

    private static final int TAB_1 = 1;

    private static final int TAB_2 = 2;

    private static final int TAB_3 = 3;

    private int type;
    private int indexs;
    private View revokePop;
    private int index;
    private String[] recentTime;
    private String[] noteArray;
    private String[] noteArrayV;
    private DatePicker datePicker;
    private int page = 1;
    private int rows = 20;
    private String gameType = "lottery";
    private int status = 1;
    private String startDate = Uiutils.getFetureDate(0);
    private String endDate = Uiutils.getFetureDate(0);

    private NoteRecordBean noteRecordBean;
    private NoteRecordBean1 noteRecordBean1;
    private int tabIndex;

    public NoteRecordFrag() {
        super(R.layout.note_record_frag, true, true);
    }

    @Override
    public void initView(View view) {

        iv_more = view.findViewById(R.id.iv_more);

        Bundle bundle = getArguments();
        if (null != bundle) {
            type = bundle.getInt("type");
            indexs = bundle.getInt("index");
        }

        recentTime = getContext().getResources().getStringArray(R.array.recent_time);
        addData(recentTime, listDate, 2);

        noteArray = getContext().getResources().getStringArray(R.array.note_list);
        noteArrayV = getContext().getResources().getStringArray(R.array.note_list_v);
        Uiutils.setBarStye(titlebar, getActivity());

        titlebar.setRIghtImg(R.drawable.calendar_white, View.VISIBLE);

        nameTex.setText(R.string.period_note_number);
        happinessTex.setText(R.string.game_name);
        happyBalanceTex.setText(R.string.subscription_amount);
        fullDateTex.setText(R.string.winnable_amount);

        if (type == 2) {
            gameType = "real";
            titlebar.getView().findViewById(R.id.tv_title).setOnClickListener(this);
            titlebar.setTitleRightImg(getContext().getResources().getDrawable(R.drawable.white_down));
            navigationBarLin.setVisibility(View.GONE);
            view.findViewById(R.id.iv_tab_bottom_lin).setVisibility(View.GONE);
            ivTabBottomImg.setVisibility(View.GONE);
            addData(noteArray, noteList, 4);
            nameTex.setText(R.string.game);
            happinessTex.setText(R.string.time);
            fullDateTex.setText(R.string.win_or_lose);
        } else {
            status = 2;

            if (Uiutils.isSite("c084")) {
                tv04.setVisibility(View.GONE);
            } else {
                tv04.setVisibility(View.VISIBLE);
            }

//            if (Uiutils.isSite("c001")) {
//                if (Uiutils.isSite("c083")) {
            tv05.setVisibility(View.VISIBLE);
            titles = new TextView[]{tv01, tv02, tv03, tv04, tv05};
            happinessTex5.setVisibility(View.VISIBLE);
            happinessTex5.setText("输赢");
            happyBalanceTex.setText("中奖笔数");
            nameTex.setText(R.string.time);
            happinessTex.setText("笔数");
            fullDateTex.setText("中奖金额");

//            }else{
//                tv05.setVisibility(View.GONE);
//                titles = new TextView[]{tv01, tv02, tv03, tv04};
//            }


            addData(noteArray, noteList, 3);
            navigationBarLin.setVisibility(View.VISIBLE);
            ivTabBottomImg.setVisibility(View.VISIBLE);
            initImageView();
            mainLin.setVisibility(View.GONE);
            view.findViewById(R.id.line_view).setVisibility(View.GONE);
        }
        titlebar.setText(noteList.get(0).getTitle());

        nameTexLin.setVisibility(View.GONE);
        happinessTexLin.setVisibility(View.GONE);
        happyBalanceTexLin.setVisibility(View.GONE);

        LinearLayout.LayoutParams topContentTextView_lp = new LinearLayout.LayoutParams(
                0, LinearLayout.LayoutParams.MATCH_PARENT, 1.5f);
        fullDateLin.setLayoutParams(topContentTextView_lp);

        Uiutils.setRec(getContext(), noteRecordRec, 0);

        if (type == 2) {
            adapter = new NoteRecordAdapter(getContext(), list, R.layout.note_record_adapter, 5);
        } else {
            adapter = new NoteRecordAdapter(getContext(), list, R.layout.note_record_adapter, tabIndex);
        }
        noteRecordRec.setAdapter(adapter);

        Uiutils.setRec(getContext(), noteRecordRec1, 0);
        adapter1 = new NoteRecordAdapter1(getContext(), list1, R.layout.note_record_adapter);
        noteRecordRec1.setAdapter(adapter1);

        adapter.setOnItemClickListener(this);

        noteRecordRefresh.setEnableLoadMore(false);
        noteRecordRefresh.setEnableRefresh(true);
        noteRecordRefresh.setOnRefreshListener(this);
        noteRecordRefresh.setOnLoadMoreListener(this);

        setPopView();
        setDateDialog();

        if (indexs == 2) {
            tabIndex = 2;
            winLoseLin.setVisibility(View.GONE);
            setLister(2);
        } else {
            repuestData(true);
        }
    }

    private void setDateDialog() {
        java.util.Calendar c = java.util.Calendar.getInstance();
        contentViewDialog = LayoutInflater.from(getContext()).inflate(R.layout.date_picker_layout, null);
        datePicker = contentViewDialog.findViewById(R.id.datePicker);

        datePicker.init(c.get(Calendar.YEAR), c.get(Calendar.MONTH), c.get(Calendar.DAY_OF_MONTH),
                new DatePicker.OnDateChangedListener() {
                    @Override
                    public void onDateChanged(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                        c.set(year, monthOfYear, dayOfMonth);
                        String strFormat = "yyyy-MM-dd";  //格式设定
                        SimpleDateFormat sdf = new SimpleDateFormat(strFormat, Locale.CHINA);
                        startDate = sdf.format(c.getTime());
                        page = 1;
                        repuestData(true);
                        mCustomPopWindow.dissmiss();
                        Uiutils.setStateColor(getActivity());
                    }
                });
    }

    private void repuestData(boolean isShow) {
        Map<String, Object> map = new HashMap<>();
        map.put("page", page + "");
        map.put("rows", rows + "");
        map.put("category", gameType);

        if (tabIndex != 4) {
            if (type == 1) {
                map.put("status", status + "");
                map.put("endDate", endDate);
            } else {
                map.put("endDate", startDate);
            }
            map.put("startDate", startDate);
        } else {
            map.put("status", status + "");
            map.put("startDate", Uiutils.getFetureDate(-30));
            map.put("endDate", Uiutils.getFetureDate(0));
        }

        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.HISTORY, map, isShow, getContext()
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        noteRecordRefresh.finishLoadMore();
                        noteRecordRefresh.finishRefresh();
                        noteRecordRefresh.setEnableRefresh(true);

                        if (!StringUtils.isEmpty(object)) {
                            noteRecordBean = GsonUtil.fromJson(object, NoteRecordBean.class);
                        }
                        if (page == 1)
                            list.clear();

                        if (null != noteRecordBean && null != noteRecordBean.getData() &&
                                null != noteRecordBean.getData().getList() && noteRecordBean.getData()
                                .getList().size() > 0) {
                            list.addAll(noteRecordBean.getData()
                                    .getList());
                        }

                        if (null != noteRecordBean && null != noteRecordBean.getData() && !StringUtils
                                .isEmpty(noteRecordBean.getData().getTotal_money()) &&
                                Double.parseDouble(noteRecordBean.getData().getTotal_money()) > 0) {
                            totalMoneyTex.setText(Uiutils.getTwo(noteRecordBean.getData().getTotal_money()) +
                                    getContext().getResources().getString(R.string.element));
                        } else {
                            totalMoneyTex.setText("0.00" +
                                    getContext().getResources().getString(R.string.element));
                        }

                        if (null != noteRecordBean && null != noteRecordBean.getData() &&
                                list.size() == noteRecordBean.getData().getTotal()) {
                            noteRecordRefresh.setEnableLoadMore(false);
                        } else {
                            noteRecordRefresh.setEnableLoadMore(true);
                        }
                        if (null != noteRecordBean && null != noteRecordBean.getData() && !StringUtils.isEmpty(
                                noteRecordBean.getData().getSettleAmount()
                        )) {
                            double win_lose = Double.parseDouble(noteRecordBean.getData().getSettleAmount());
                            if (tabIndex <= 1) {
                                if (win_lose > 0) {
                                    winLoseTex.setTextColor(getResources().getColor(R.color.color_white));
                                    winLoseTex.setText("+" + Uiutils.getTwo(noteRecordBean.getData().getSettleAmount()) +
                                            getContext().getResources().getString(R.string.element));
                                } else if (win_lose == 0) {
                                    winLoseTex.setTextColor(getResources().getColor(R.color.color_white));
                                    winLoseTex.setText(
                                            getContext().getResources().getString(R.string.not_amount));
                                } else {
                                    winLoseTex.setTextColor(getResources().getColor(R.color.color_008000));
                                    winLoseTex.setText(Uiutils.getTwo(noteRecordBean.getData().getSettleAmount()) +
                                            getContext().getResources().getString(R.string.element));
                                }
                            }
                        }

                        if (page==1){
                            if (type == 2) {
                                adapter = new NoteRecordAdapter(getContext(), list, R.layout.note_record_adapter, 5);
                            } else {
                                adapter = new NoteRecordAdapter(getContext(), list, R.layout.note_record_adapter, tabIndex);
                            }
                            noteRecordRec.setAdapter(adapter);
                        }else{
                            adapter.notifyDataSetChanged();
                        }

                        if (list.size() == 0) {
                            noMoreRecordsTex.setVisibility(View.VISIBLE);
                        } else {
                            noMoreRecordsTex.setVisibility(View.GONE);
                        }
                        noMoreRecordsTex.setText("没有更多记录");
                    }

                    @Override
                    public void onError() {
                        if (null!=noteRecordRefresh) {
                            noteRecordRefresh.finishRefresh();
                            noteRecordRefresh.finishLoadMore();
                        }
                    }
                });
    }


    private void repuestData1(boolean isShow) {
        Map<String, Object> map = new HashMap<>();
        map.put("startDate", Uiutils.getFetureDate(-6));
        map.put("endDate", Uiutils.getFetureDate(0));

        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.LOTTERYSTATISTICS, map, isShow, getContext()
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        noteRecordRefresh.finishLoadMore();
                        noteRecordRefresh.finishRefresh();

                        if (!StringUtils.isEmpty(object)) {
                            noteRecordBean1 = GsonUtil.fromJson(object, NoteRecordBean1.class);
                        }
                        if (list1.size() > 0)
                            list1.clear();

                        if (null != noteRecordBean1 && null != noteRecordBean1.getData() &&
                                null != noteRecordBean1.getData().getTickets() && noteRecordBean1.getData()
                                .getTickets().size() > 0) {
                            list1.addAll(noteRecordBean1.getData()
                                    .getTickets());
                        }

                        if (null != noteRecordBean1 && null != noteRecordBean1.getData() && !StringUtils
                                .isEmpty(noteRecordBean1.getData().getTotalBetCount()) &&
                                Double.parseDouble(noteRecordBean1.getData().getTotalBetCount()) > 0) {
                            totalMoneyTex.setText(Uiutils.getTwo(noteRecordBean1.getData().getTotalBetCount()) );
                        } else {
                            totalMoneyTex.setText("0.00" );
                        }

                        leftTex.setText("总笔数：");

                        noteRecordRefresh.setEnableLoadMore(false);
                        noteRecordRefresh.setEnableRefresh(false);

                        if (null != noteRecordBean1 && null != noteRecordBean1.getData() && !StringUtils.isEmpty(
                                noteRecordBean1.getData().getTotalWinAmount())) {
                            winLoseTex.setText(noteRecordBean1.getData().getTotalWinAmount()+
                                    getContext().getResources().getString(R.string.element));
                        }else{
                            winLoseTex.setText(0.00+
                                    getContext().getResources().getString(R.string.element));
                        }
                        adapter1.notifyDataSetChanged();
                        noMoreRecordsTex.setVisibility(View.GONE);
                        noMoreRecordsTex.setText("点击日期可查看下注详情");

                    }

                    @Override
                    public void onError() {
                        if (null!=noteRecordRefresh) {
                            noteRecordRefresh.finishRefresh();
                            noteRecordRefresh.finishLoadMore();
                        }
                    }
                });
    }


    private void addData(String[] strarray, List<My_item> lis, int type) {
        if (null != strarray && strarray.length > 0) {
            for (int i = 0; i < strarray.length; i++) {
                if (type != 2) {
                    if (type == 4 && i == 0) {
                    } else {
                        lis.add(new My_item(noteArrayV[i], strarray[i]));
                    }

                } else {
                    if (i == 0) {
                        lis.add(new My_item(2, strarray[i]));
                    } else if (i == 1) {
                        lis.add(new My_item(3, strarray[i]));
                    } else if (i == 2) {
                        lis.add(new My_item(1, strarray[i]));
                    } else if (i == 3) {
                        lis.add(new My_item(4, strarray[i]));
                    }

                }
            }
        }
    }

    private void showPopMenu() {
        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 80), ViewGroup.LayoutParams.WRAP_CONTENT,
                true, false, 0.5f);
    }

    private void setPopView() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.city_pop, null);
        popRec = contentView.findViewById(R.id.pop_rec);
        Uiutils.setRec(getContext(), popRec, 0);

        popAdapter = new NoteRecordPopAdapter(getContext(), listPop,
                R.layout.item_title_no_background);

        popRec.setAdapter(popAdapter);
        popAdapter.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {
                if (index == 1) {
                    titlebar.setText(noteList.get(position).getTitle());
                    gameType = noteList.get(position).getV();
                } else {

                    switch (position) {
                        case 0:
                            startDate = Uiutils.getFetureDate(0);
                            break;
                        case 1:
                            startDate = Uiutils.getFetureDate(-3);
                            break;
                        case 2:
                            startDate = Uiutils.getFetureDate(-7);
                            break;
                        case 3:
                            startDate = Uiutils.getFetureDate(-30);
                            break;
                    }
                }
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                page = 1;
                repuestData(true);
            }
        });
        showPopMenu();
    }

    @OnClick({R.id.tv01, R.id.tv02, R.id.tv03, R.id.tv04, R.id.tv05, R.id.iv_more})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.tv01:
                if (0==tabIndex)
                    return;
                tabIndex = 0;
                winLoseLin.setVisibility(View.VISIBLE);
                setLister(0);
                break;
            case R.id.tv02:
                if (1==tabIndex)
                    return;
                winLoseLin.setVisibility(View.VISIBLE);
                tabIndex = 1;
                setLister(1);
                break;
            case R.id.tv03:
                if (2==tabIndex)
                    return;
                tabIndex = 2;
                winLoseLin.setVisibility(View.GONE);
                setLister(2);
                break;
            case R.id.tv04:
                if (3==tabIndex)
                    return;
                tabIndex = 3;
                winLoseLin.setVisibility(View.GONE);
                setLister(3);
                break;
            case R.id.tv05:
                if (4==tabIndex)
                    return;
                tabIndex = 4;
                winLoseLin.setVisibility(View.VISIBLE);
                setLister(4);
                break;
            case R.id.iv_more:
                if (type == 1) {
                    setPopList(listDate);
//                    popupWindowBuilder.setView(contentView);
//                    popupWindowBuilder.enableOutsideTouchableDissmiss(true);
//                    popupWindowBuilder.enableBackgroundDark(false);
//                    popupWindowBuilder.size(MeasureUtil.dip2px(getContext(), 80),
//                            ViewGroup.LayoutParams.WRAP_CONTENT);

                    popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                            MeasureUtil.dip2px(getContext(), 80),
                            ViewGroup.LayoutParams.WRAP_CONTENT,
                            true, false, 0.5f);

                    mCustomPopWindow = popupWindowBuilder.create();
                    mCustomPopWindow.showAsDropDown(titlebar.ivMore, 0, 0);
                    Uiutils.setStateColor(getActivity());
                } else {
//                    popupWindowBuilder.setView(contentViewDialog);
//                    popupWindowBuilder.enableOutsideTouchableDissmiss(true);
//                    popupWindowBuilder.enableBackgroundDark(true);
//                    popupWindowBuilder.size(MeasureUtil.dip2px(getContext(), 300),
//                            ViewGroup.LayoutParams.WRAP_CONTENT);

                    popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentViewDialog,
                            MeasureUtil.dip2px(getContext(), 300),
                            ViewGroup.LayoutParams.WRAP_CONTENT,
                            true, true, 0.5f);

                    mCustomPopWindow = popupWindowBuilder.create();
                    mCustomPopWindow.showAtLocation(contentViewDialog, Gravity.CENTER, 0, 0);
                    Uiutils.setStateColor(getActivity());
//                    if (null != datePickerDialog && !datePickerDialog.isShowing())
//                        datePickerDialog.show();
                }
                index = 2;
                break;
            case R.id.tv_title:
                setPopList(noteList);

//                popupWindowBuilder.setView(contentView);
//                popupWindowBuilder.enableOutsideTouchableDissmiss(true);
//                popupWindowBuilder.enableBackgroundDark(true);
//                popupWindowBuilder.setBgDarkAlpha(0.5f);
//                popupWindowBuilder.size(ViewGroup.LayoutParams.MATCH_PARENT,
//                        ViewGroup.LayoutParams.WRAP_CONTENT);

                popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT,
                        true, true, 0.5f);

                mCustomPopWindow = popupWindowBuilder.create();
                mCustomPopWindow.showAtLocation(contentView, Gravity.BOTTOM, 0, 0);
                Uiutils.setStateColor(getActivity());
                index = 1;
                break;
            case R.id.clear_tex:
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.commit_tex:
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                clearOrders();
                break;
        }
    }

    /**
     * 取消定单
     */
    private void clearOrders() {
        Map<String, Object> map = new HashMap<>();
        map.put("orderId", list.get(clearnPosi).getId());
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.post(Constants.CANCELBET, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                list.remove(clearnPosi);
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onError() {

            }
        });

    }

    private void setPopList(List<My_item> lis) {
        if (listPop.size() > 0)
            listPop.clear();
        if (lis.size() > 0) {
            listPop.addAll(lis);
        }
        popAdapter.notifyDataSetChanged();
    }

    private void setLister(int position) {
        if (position != 4) {
            noteRecordRec.setVisibility(View.VISIBLE);
            noteRecordRec1.setVisibility(View.GONE);
            leftTex.setText("下注总金额：");
            rightTex.setText("输赢金额：");
        } else {
            noteRecordRec1.setVisibility(View.VISIBLE);
            noteRecordRec.setVisibility(View.GONE);
            leftTex.setText("总笔数：");
            rightTex.setText("总输赢：");
        }

        adapter.setType(tabIndex);
        winLoseTex.setText(
                getContext().getResources().getString(R.string.not_amount));
        totalMoneyTex.setText(
                getContext().getResources().getString(R.string.not_amount));
        if (position == 0) {
            toX = 0;
        } else {
            toX = position * lineWidth;
        }
        int one = offset * 2 + lineWidth;
//        // 下划线开始移动前的位置
        float fromX = one * current_index;
        // 下划线移动完毕后的位置
//        float toX = lineWidth * position;
        Animation animation = new TranslateAnimation(fromX, toX, 0, 0);
        animation.setFillAfter(true);
        animation.setDuration(500);
        // 给图片添加动画
        ivTabBottomImg.startAnimation(animation);
        // 当前Tab的字体变成红色
        titles[position].setTextColor(getResources().getColor(ShareUtils.getInt(getActivity(), "ba_top",
                Color.parseColor("#ff4081"))));
        titles[current_index].setTextColor(getContext().getResources().getColor(R.color.fount2));
        current_index = position;

        if (position != 4) {
            if (type == 1) {
                status = listDate.get(position).getImg();
            }
            page = 1;
            repuestData(true);
            mainLin.setVisibility(View.GONE);
            iv_more.setVisibility(View.VISIBLE);
            adapter.setType(0);
        } else {
            status = 3;
            adapter.setType(6);
            mainLin.setVisibility(View.VISIBLE);
            iv_more.setVisibility(View.GONE);

            page = 1;
            repuestData1(true);
        }
    }

    /**
     * 初始化底部下划线
     */
    private void initImageView() {
        DisplayMetrics dm = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
        int screenW = dm.widthPixels; // 获取分辨率宽度
        if (Uiutils.isSite("c084")) {
            lineWidth = screenW / 3;
        } else {
//            if (Uiutils.isSite("c001")){
//                if (Uiutils.isSite("c083")){
            lineWidth = screenW / 5;
//            }else{
//                lineWidth = screenW / 4;
//            }
        }
        ivTabBottomImg.setLayoutParams(new LinearLayout.LayoutParams(lineWidth, MeasureUtil.dip2px(
                getContext(), 2
        )));
    }

    private int clearnPosi;

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
//        if (tabIndex == 2) {
//            setPop(position);
//        }else
//            if (tabIndex==4) {
//                Bundle bundle =new Bundle();
//                bundle.putInt("type",1);
//                FragmentUtilAct.startAct(getActivity(), new BetOnDetailFrag(),bundle);
//            }
    }

    private void setPop(int position) {
        popupWindowBuilder.enableBackgroundDark(true);
        revokePop = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop, null);
        revokePop.findViewById(R.id.clear_tex).setOnClickListener(this);
        revokePop.findViewById(R.id.commit_tex).setOnClickListener(this);

        clearnPosi = position;

        ((TextView) revokePop.findViewById(R.id.context_tex)).setText("您要撤销注单号" +
                list.get(position).getId() + "订单吗？");

//        popupWindowBuilder.setView(revokePop);
//        popupWindowBuilder.enableOutsideTouchableDissmiss(true);
//        popupWindowBuilder.setBgDarkAlpha(0.5f);
//        popupWindowBuilder.size(MeasureUtil.dip2px(getContext(), 300),
//                ViewGroup.LayoutParams.WRAP_CONTENT);

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), revokePop,
                MeasureUtil.dip2px(getContext(), 300),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);


        mCustomPopWindow = popupWindowBuilder.create();
        mCustomPopWindow.showAtLocation(revokePop, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        repuestData(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page = 1;
        repuestData(false);
    }

    @Override
    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {

    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CANCEL_ORDER:
                setPop((Integer) even.getData());
                break;
        }
    }
}
