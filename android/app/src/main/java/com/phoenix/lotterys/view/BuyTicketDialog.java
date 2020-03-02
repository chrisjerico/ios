package com.phoenix.lotterys.view;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.adapter.BuyTicketDialogAdapter;
import com.phoenix.lotterys.buyhall.bean.BetBean;
import com.phoenix.lotterys.buyhall.bean.LotteryBetBean;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;
import com.phoenix.lotterys.buyhall.bean.PlaysBean;
import com.phoenix.lotterys.buyhall.bean.ShareBetInfo;
import com.phoenix.lotterys.buyhall.bean.ShareBetList;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.EditInputFilter;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;

import java.io.IOException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import cn.iwgang.countdownview.CountdownView;
import okhttp3.RequestBody;

import static com.phoenix.lotterys.util.StampToDate.dateToStamp;

public class BuyTicketDialog extends Dialog {
    TextView tvTitle;
    RecyclerView rvTicket;
    TextView tvCancel;
    TextView tvSure;
    TextView tvNumber;
    TextView tvTotalAmount;
    TextView tvClose;
    TextView tv_title_num;
    TextView tv_title_odds;
    TextView tv_title_money;
    TextView tv_title_handle;
    TextView tv_tltle_allbet;
    TextView tv_tltle_allmoney;
    TextView tv_all_amount;
    LinearLayout llMain;
    View view;
    CountdownView tvCloseTime;
    BuyTicketDialogAdapter buyTicketDialogAdapter;
    Activity context;
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list;

    String title,gameName;
    double totalAmount;
    private SharedPreferences sp;
    long closeTime;
    String gameId;
    String code;  //分享code
    String betIssue, close, leftTitle, gameType, betCount, rightTitle, instant;
    boolean isTest;
    private OnClickListener onClickListener;
    private String[] selectNum;
    private String[] ids;
    List<String> SelectIds;
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> playOddsList;

    public void allData(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> playOddsList, String gameName,String code) {
        this.playOddsList = playOddsList;
        this.gameName = gameName;
        this.code = code;
    }

    public interface OnClickListener {
        void onClickListener(View view, int state, String json, BetBean bb, String shareBetJson, String shareBetInfoJson,String allAmount);
    }

    public void setOnClickListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public void setList(boolean isTest, List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> ticketNameBeanList, String close,
                        long closeTime, String gameId, String betIssue, String leftTitle, String gameType, String betCount, String rightTitle, List<String> SelectIds, String instant) {
        this.close = close;
        this.closeTime = closeTime;
        this.gameId = gameId;
        this.betIssue = betIssue;
        this.isTest = isTest;
        this.leftTitle = leftTitle;
        this.gameType = gameType;
        this.betCount = betCount;
        this.rightTitle = rightTitle;
        this.SelectIds = SelectIds;
        this.instant = instant;
        tvCloseTime.start(closeTime);
        hideTime(instant);
        //Log.e("xxxxisTest",""+isTest);
        if (ticketNameBeanList == null || ticketNameBeanList.size() == 0 || gameType == null || leftTitle == null) {
            return;
        }
        if (gameType.equals("lhc") && (leftTitle.equals("自选不中") || leftTitle.equals("合肖"))) {
            selectNum = new String[ticketNameBeanList.size()];
            for (int i = 0; i < ticketNameBeanList.size(); i++) {
                selectNum[i] = ticketNameBeanList.get(i).getName();
            }
            list.addAll(ticketNameBeanList);
            if (buyTicketDialogAdapter != null && (playOddsList.get(0).getName().equals("合肖") || playOddsList.get(0).getName().equals("自选不中"))) {
                buyTicketDialogAdapter.setTypename(leftTitle, gameType, selectNum, playOddsList);
            }
            tvNumber.setText("1");
        } else if ((gameType.equals("lhc") || gameType.equals("gd11x5") || gameType.equals("gdkl10") || gameType.equals("xync")) && leftTitle.equals("连码")) {
            selectNum = new String[ticketNameBeanList.size()];
            for (int i = 0; i < ticketNameBeanList.size(); i++) {
                selectNum[i] = ticketNameBeanList.get(i).getName();
                if (i != 0) {
                    ticketNameBeanList.get(i).setAmount("0");
                }
            }
            list.addAll(ticketNameBeanList);
            if (buyTicketDialogAdapter != null) {
                buyTicketDialogAdapter.setTypename(leftTitle, gameType, selectNum, rightTitle, betCount);
            }
            tvNumber.setText(betCount);
        } else if (gameType.equals("lhc") && (leftTitle.equals("连肖") || leftTitle.equals("连尾"))) {
            selectNum = new String[ticketNameBeanList.size()];
            this.ids = new String[ticketNameBeanList.size()];
            for (int i = 0; i < ticketNameBeanList.size(); i++) {
                selectNum[i] = ticketNameBeanList.get(i).getAlias();
                this.ids[i] = ticketNameBeanList.get(i).getId();
            }
            tvNumber.setText(betCount);
            combinationSelect(selectNum, 0, new String[ShowItem.ItemCount(rightTitle, gameType)], 0, ticketNameBeanList.get(0).getOdds(),
                    ticketNameBeanList.get(0).getAmount(), this.ids, new String[ShowItem.ItemCount(rightTitle, gameType)],ticketNameBeanList.get(0).getTitleRight());
            if (buyTicketDialogAdapter != null) {
                buyTicketDialogAdapter.setTypename(leftTitle, gameType, selectNum, rightTitle, betCount);
            }
        } else if (gameType.equals("gd11x5") && leftTitle.equals("直选")) {
            ballSelect(ticketNameBeanList, ticketNameBeanList.get(0).getOdds(), ticketNameBeanList.get(0).getAmount(), ticketNameBeanList.get(0).getId(),ticketNameBeanList.get(0).getTitleRight());
            if (buyTicketDialogAdapter != null) {
                buyTicketDialogAdapter.setTypename(leftTitle, rightTitle,gameType);
            }
        } else {
            tvNumber.setText(String.valueOf(ticketNameBeanList.size()));
            list.addAll(ticketNameBeanList);
            if (buyTicketDialogAdapter != null) {
                buyTicketDialogAdapter.setTypename(leftTitle, gameType, selectNum, rightTitle, betCount);
            }
        }
        if (buyTicketDialogAdapter != null) {
            buyTicketDialogAdapter.notifyDataSetChanged();
            InputFilter[] filters = {new EditInputFilter()};
            tv_all_amount.setFilters(filters);
            tv_all_amount.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {

                }

                @Override
                public void afterTextChanged(Editable s) {
                    if (!TextUtils.isEmpty(s.toString())) {
                        buyTicketDialogAdapter.inputAllAmount(s.toString());
                        try {
                            double total = 0;
                            int count = Integer.parseInt(tvNumber.getText().toString());
//                        for (LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean pyBean : list) {
//                            total += Double.parseDouble(pyBean.getAmount());
//                        }
                            for (int i = 0; i < count; i++) {
                                total += Double.parseDouble(list.get(i).getAmount());
                            }
                            setTotalAmount(total);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });
        }
    }

    private void hideTime(String instant) {
        if (!TextUtils.isEmpty(instant) && instant.equals("1")) {
            tvClose.setVisibility(View.GONE);
            tvCloseTime.setVisibility(View.GONE);
        }
    }

    private void ballSelect(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> ticketNameBeanList, String odds, String amount, String id,String titleRight) {
        List<String> ballOne = new ArrayList<>();
        List<String> ballTwo = new ArrayList<>();
        List<String> ballThree = new ArrayList<>();
        if (rightTitle != null && (rightTitle.equals("前二直选") || rightTitle.equals("前三直选"))) {
            for (int i = 0; i < ticketNameBeanList.size(); i++) {
                if (ticketNameBeanList.get(i).getBall() == 0) {
                    ballOne.add(ticketNameBeanList.get(i).getName());
                } else if (ticketNameBeanList.get(i).getBall() == 1) {
                    ballTwo.add(ticketNameBeanList.get(i).getName());
                } else if (ticketNameBeanList.get(i).getBall() == 2) {
                    ballThree.add(ticketNameBeanList.get(i).getName());
                }
            }
            for (int o = 0; o < ballOne.size(); o++) {
                for (int t = 0; t < ballTwo.size(); t++) {
                    if (rightTitle.equals("前二直选")) {
                        PlaysBean pb = new PlaysBean();
                        pb.setId(id);
                        pb.setAmount(amount);
                        pb.setOdds(odds);
                        pb.setSelectName(ballOne.get(o) + "," + ballTwo.get(t));
                        pb.setName("[" + ballOne.get(o) + "," + ballTwo.get(t) + "]");
                        pb.setTitleRight(titleRight);
                        list.add(pb);
                    }
                    if (rightTitle.equals("前三直选")) {
                        for (int r = 0; r < ballThree.size(); r++) {
                            PlaysBean plb = new PlaysBean();
                            plb.setId(id);
                            plb.setAmount(amount);
                            plb.setOdds(odds);
                            plb.setSelectName(ballOne.get(o) + "," + ballTwo.get(t) + "," + ballThree.get(r));
                            plb.setName("[" + ballOne.get(o) + "," + ballTwo.get(t) + "," + ballThree.get(r) + "]");
                            plb.setTitleRight(titleRight);
                            list.add(plb);
                        }
                    }
                }
            }
        }
        tvNumber.setText(list.size() + "");
    }

    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> playBet;
    List<String> betList = new ArrayList<>();

    private void combinationSelect(String[] dataList, int dataIndex, String[] resultList, int resultIndex, String odds, String amount, String[] ids, String[] resultidsList,String rightTitleAilas) {
        int resultLen = resultList.length;
        int resultCount = resultIndex + 1;
        betList.add(resultList + "");
        if (resultCount > resultLen) { // 全部选择完时，输出组合结果
            PlaysBean pb = new PlaysBean();
            pb.setName(Arrays.asList(resultList) + "");
            pb.setOdds(odds);
            pb.setId(Arrays.asList(resultidsList) + "");
            pb.setAmount(amount);
            pb.setTitleRight(rightTitleAilas);
            list.add(pb);
            return;
        }
        for (int i = dataIndex; i < dataList.length + resultCount - resultLen; i++) {
            resultList[resultIndex] = dataList[i];
            resultidsList[resultIndex] = ids[i];
            combinationSelect(dataList, i + 1, resultList, resultIndex + 1, odds, amount, ids, resultidsList,rightTitleAilas);
        }
    }

    public void setTitle(String title) {
        this.title = title;
        tvTitle.setText(title);
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
        if (leftTitle.equals("自选不中")) {
            tvTotalAmount.setText("¥" + FormatNum.formatCenterMoney1(totalAmount));
        } else {
            tvTotalAmount.setText("¥" + FormatNum.formatCenterMoney1(totalAmount));
        }
    }

    public BuyTicketDialog(@NonNull Activity context) {
        super(context, R.style.MyDialog);
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.dialog_buy_ticket);
        //点击屏幕空白消失
        setCanceledOnTouchOutside(false);
        //点击返回键消失
        setCancelable(false);
        //初始化界面控件
        initView();
        //点击事件
        initEvent();
        setTheme();
    }

    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), tvTitle, false, null);
                Uiutils.setBaColor(getContext(), llMain);
                Uiutils.setBaColor(getContext(), view);
                tv_title_handle.setTextColor(context.getResources().getColor(R.color.font));
                tv_title_money.setTextColor(context.getResources().getColor(R.color.font));
                tv_title_odds.setTextColor(context.getResources().getColor(R.color.font));
                tv_title_num.setTextColor(context.getResources().getColor(R.color.font));
                tv_tltle_allbet.setTextColor(context.getResources().getColor(R.color.font));
                tv_tltle_allmoney.setTextColor(context.getResources().getColor(R.color.font));
                tvCancel.setTextColor(context.getResources().getColor(R.color.font));
                tvClose.setTextColor(context.getResources().getColor(R.color.font));

                tvTitle.setBackground(context.getResources().getDrawable(R.drawable.black_shape_ticket_dialog_title_bg));
                tvSure.setBackground(context.getResources().getDrawable(R.drawable.black_regedit_bg));
            }
        }
    }



    private void initEvent() {
        tvCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (tvCloseTime != null) {
                    tvCloseTime.stop();
                }
                OkGo.getInstance().cancelTag(this);
                dismiss();
            }
        });
        tvSure.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if ((onClickListener != null && tvCloseTime.getVisibility() != View.GONE) || (!TextUtils.isEmpty(instant) && instant.equals("1"))) {
                    try {
                        questBet();
                    } catch (ParseException e) {
                        e.printStackTrace();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    ToastUtils.ToastUtils("彩票封盘中", context);
                }
            }
        });

        tvCloseTime.setOnCountdownEndListener(new CountdownView.OnCountdownEndListener() {
            @Override
            public void onEnd(CountdownView cv) {
                tvCloseTime.setVisibility(View.GONE);
                String s = "封盘时间：  <font color='#2F9CF3'>" + " 封盘中" + "</font>";
                tvClose.setText(Html.fromHtml(s));
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if (tvCloseTime != null) {
                            tvCloseTime.stop();
                        }
                        OkGo.getInstance().cancelTag(this);
                        dismiss();
                    }
                }, 1500);
            }
        });
    }

    private void initView() {
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        tvTitle = findViewById(R.id.tv_title);
        rvTicket = findViewById(R.id.rv_ticket);
        tvCancel = findViewById(R.id.tv_cancel);
        tvSure = findViewById(R.id.tv_sure);
        tvNumber = findViewById(R.id.tv_number);
        tvTotalAmount = findViewById(R.id.tv_total_amount);
        tvCloseTime = findViewById(R.id.cv_close_time);
        tvClose = findViewById(R.id.tv_close_time);

        tv_title_num = findViewById(R.id.tv_title_num);
        tv_title_odds = findViewById(R.id.tv_title_odds);
        tv_title_money = findViewById(R.id.tv_title_money);
        tv_title_handle = findViewById(R.id.tv_title_handle);
        tv_tltle_allbet = findViewById(R.id.tv_tltle_allbet);
        tv_tltle_allmoney = findViewById(R.id.tv_tltle_allmoney);
        tv_all_amount = findViewById(R.id.tv_all_amount);
        llMain = findViewById(R.id.ll_main);
        view = findViewById(R.id.view);

        list = new ArrayList<>();
        buyTicketDialogAdapter = new BuyTicketDialogAdapter(list, context);
        rvTicket.setLayoutManager(new LinearLayoutManager(context));
        rvTicket.setAdapter(buyTicketDialogAdapter);
        buyTicketDialogAdapter.setListener(new BuyTicketDialogAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position, String s) {
                LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean pyBean = list.get(position);
                if (view == null) {
                    if ((gameType.equals("lhc") || gameType.equals("gd11x5") || gameType.equals("gdkl10") || gameType.equals("xync")) && leftTitle.equals("连码")) {
                        if (!TextUtils.isEmpty(pyBean.getAmount())) {
                            totalAmount = 0;
                        }
                        if (!TextUtils.isEmpty(s) && ShowItem.isNumeric(s) && ShowItem.isNumeric(betCount)) {
                            totalAmount = Double.parseDouble(s) * Double.parseDouble(betCount);
                        }
                        if (ShowItem.isNumeric(totalAmount + "")) {
                            tvTotalAmount.setText(FormatNum.formatCenterMoney1(totalAmount));
                        }
                    } else {
                        if (!TextUtils.isEmpty(pyBean.getAmount()) && ShowItem.isNumeric(pyBean.getAmount())) {
                            totalAmount = totalAmount - Double.parseDouble(pyBean.getAmount());
                        }
                        if (!TextUtils.isEmpty(s) && ShowItem.isNumeric(s)) {
                            totalAmount = Double.parseDouble(s) + totalAmount;
                        }
                        if (ShowItem.isNumeric(totalAmount + ""))
                            tvTotalAmount.setText("¥ " + FormatNum.formatCenterMoney1(totalAmount));
                    }
                } else if (!TextUtils.isEmpty(pyBean.getAmount())) {
                    totalAmount = totalAmount - Double.parseDouble(pyBean.getAmount());
                    tvTotalAmount.setText(FormatNum.formatCenterMoney1(totalAmount));
                    if (gameType.equals("lhc") && (leftTitle.equals("自选不中") || leftTitle.equals("合肖"))) {
                        if (list != null)
                            list.clear();
                    } else if (gameType.equals("lhc") && leftTitle.equals("连码")) {
                        if (list != null)
                            list.clear();
                        tvTotalAmount.setText("¥ 0.00");
                    } else {
                        list.remove(position);
                    }
                    tvNumber.setText(String.valueOf(list.size()));
                    buyTicketDialogAdapter.notifyDataSetChanged();
                }
            }
        });
    }

    private void questBet() throws ParseException {
        String url;
        List<LotteryBetBean.BetBeanBean> betList = new ArrayList<>();
        List<ShareBetList> shareBetList = new ArrayList<>();
        List<ShareBetInfo.BetParamsBean> shareBetParams = new ArrayList<>();
        List<ShareBetInfo.PlayNameArrayBean> sharePlayName = new ArrayList<>();
        ShareBetInfo.SelectSubBean select = new ShareBetInfo.SelectSubBean();
        if (gameId == null || betIssue == null || close == null) {
            ToastUtils.ToastUtils(context.getResources().getString(R.string.getdata_failed), context);
            return;
        }
        if (list == null || list.size() == 0) {
            ToastUtils.ToastUtils(context.getResources().getString(R.string.select_bet), context);
            return;
        }
        LotteryBetBean bet = new LotteryBetBean();
        ShareBetInfo shareBetInfo = new ShareBetInfo();
        if ((gameType.equals("lhc") || gameType.equals("gd11x5") || gameType.equals("gdkl10") || gameType.equals("xync")) && (leftTitle.equals("连码") || leftTitle.equals("合肖") || leftTitle.equals("自选不中"))) {
            String num = null;
            for (int i = 0; i < selectNum.length; i++) {
                if (i == 0)
                    num = selectNum[i];
                else
                    num += "," + selectNum[i];
            }
            if (leftTitle.equals("连码")) {
                betList.add(new LotteryBetBean.BetBeanBean(SecretUtils.DESede(list.get(0).getId()), SecretUtils.DESede(FormatNum.amountFormat1(list.get(0).getAmount(), 2, false)), SecretUtils.DESede(num + ""), SecretUtils.DESede(gameId), null));
                shareBetList.add(new ShareBetList("0",FormatNum.amountFormat1(list.get(0).getAmount(), 2, false),num + "",list.get(0).getOdds()));
                shareBetParams.add(new ShareBetInfo.BetParamsBean(list.get(0).getId(),FormatNum.amountFormat1(list.get(0).getAmount(), 2, false),num + "",list.get(0).getOdds(),gameType.equals("gd11x5")?null:gameId));
//                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(list.get(0).getShareAlias(),num));
                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(list.get(0).getTitleRight()+"-["+num+"]",num));
                if(gameType.equals("lhc")&&leftTitle.equals("连码")){
                    select.setId(list.get(0).getId());
                    select.setType("LM");
                    select.setText(rightTitle);
                    select.setMin(ShowItem.selectMinSix(rightTitle)+"");
                    select.setMax(ShowItem.selectMoreSix(rightTitle)+"");
                    shareBetInfo.setSelectSub(select);
                }

                String count = tvNumber.getText().toString().trim();
                bet.setTotalNum(SecretUtils.DESede(count));
                shareBetInfo.setTotalNums(count);
            } else if (leftTitle.equals("合肖") && list.size() >= 2 && playOddsList != null) {
                String id = null;
                String odds = null;
                for (int i = 0; i < playOddsList.get(0).getPlays().size(); i++) {
                    if (playOddsList.get(0).getPlays().get(i).getAlias() != null && playOddsList.get(0).getPlays().get(i).getAlias().equals("" + selectNum.length)) {
                        id = playOddsList.get(0).getPlays().get(i).getId();
                        odds = playOddsList.get(0).getPlays().get(i).getOdds();
                    }
                }

                betList.add(new LotteryBetBean.BetBeanBean(SecretUtils.DESede(id/*playOddsList.get(0).getPlays().get(ShowItem.selectZxNum(selectNum.length)).getId()*/), SecretUtils.DESede(FormatNum.amountFormat1(list.get(0).getAmount(), 2, false)), SecretUtils.DESede(num),
                        SecretUtils.DESede(odds/*playOddsList.get(0).getPlays().get(ShowItem.selectZxNum(selectNum.length)).getOdds()*/), 0));
                shareBetList.add(new ShareBetList("0",FormatNum.amountFormat1(list.get(0).getAmount(), 2, false),num + "",odds));
                shareBetParams.add(new ShareBetInfo.BetParamsBean(id,FormatNum.amountFormat1(list.get(0).getAmount(), 2, false),num + "",odds,null));
//                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(list.get(0).getShareAlias(),num));
                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(list.get(0).getTitleRight()+"-合肖"+selectNum.length+"["+num+"]",num));
                bet.setTotalNum(SecretUtils.DESede("1"));
                shareBetInfo.setTotalNums("1");

            } else if (leftTitle.equals("自选不中") && SelectIds != null) {
                String id = null;
                String odds = null;
                for (int i = 0; i < playOddsList.get(0).getPlays().size(); i++) {
                    if (playOddsList.get(0).getPlays().get(i).getAlias() != null && playOddsList.get(0).getPlays().get(i).getAlias().equals("" + selectNum.length)) {
                        id = playOddsList.get(0).getPlays().get(i).getId();
                        odds = playOddsList.get(0).getPlays().get(i).getSelectOdds();
                    }
                }

                betList.add(new LotteryBetBean.BetBeanBean(SecretUtils.DESede(id), SecretUtils.DESede(FormatNum.amountFormat1(list.get(0).getAmount(), 2, false)), SecretUtils.DESede(num), SecretUtils.DESede(gameId), null));
                shareBetList.add(new ShareBetList("0",FormatNum.amountFormat1(list.get(0).getAmount(), 2, false),num + "",odds));
                shareBetParams.add(new ShareBetInfo.BetParamsBean(id,FormatNum.amountFormat1(list.get(0).getAmount(), 2, false),num + "",odds,null));
                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(list.get(0).getTitleRight()+"-"+num,num));
                bet.setTotalNum(SecretUtils.DESede("1"));
                shareBetInfo.setTotalNums("1");
            }
            shareBetInfo.setSpecialPlay(true);
        } else if (gameType.equals("lhc") && (leftTitle.equals("连肖") || leftTitle.equals("连尾"))) {
            int count = 0;
            for (LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean i : list) {
                String playId = null;
                String temp = i.getName().replace("[", "");
                String bets = temp.replace("]", "");
                String[] betName = bets.split(",");
                for (int c = 0; c < selectNum.length; c++) {
                    for (int t = 0; t < betName.length; t++) {
                        if (selectNum[c].equals(betName[t])) {
                            playId = ids[c];
                        }
                    }
                }
                String playName = null;
                for (int t = 0; t < betName.length; t++) {
                    if (t == 0)
                        playName = betName[t].trim();
                    else
                        playName += "," + betName[t].trim();
                }
                String tempids = i.getId().replace("[", "");
                String ids = tempids.replace("]", "");
                String[] betIds = ids.split(",");
                String id = null;
                for (int d = 0; d < betIds.length; d++) {
                    if (d == 0)
                        id = betIds[d].trim();
                    else
                        id += "," + betIds[d].trim();
                }
                betList.add(new LotteryBetBean.BetBeanBean(SecretUtils.DESede(playId), SecretUtils.DESede(FormatNum.amountFormat1(i.getAmount(), 2, false)), SecretUtils.DESede(playName), SecretUtils.DESede(id), SecretUtils.DESede(i.getOdds())));
                shareBetList.add(new ShareBetList(count+"",FormatNum.amountFormat1(i.getAmount(), 2, false),playName ,i.getOdds()));
                shareBetParams.add(new ShareBetInfo.BetParamsBean(playId,FormatNum.amountFormat1(i.getAmount(), 2, false),playName + "",i.getOdds(),id));
//                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getShareAlias(),playName));
                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getTitleRight()+"-"+playName,playName));
                bet.setTotalNum(SecretUtils.DESede(list.size() + ""));
                shareBetInfo.setTotalNums(list.size()+"");
                count++;
            }
            shareBetInfo.setSpecialPlay(true);
        } else if (gameType.equals("gd11x5") && leftTitle.equals("直选")) {
            int count = 0;
            for (LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean i : list) {
                betList.add(new LotteryBetBean.BetBeanBean(SecretUtils.DESede(i.getId()), SecretUtils.DESede(FormatNum.amountFormat1(i.getAmount(), 2, false)), SecretUtils.DESede(i.getSelectName()), null, SecretUtils.DESede(i.getOdds())));
                shareBetList.add(new ShareBetList(count+"",FormatNum.amountFormat1(i.getAmount(), 2, false),i.getSelectName() ,i.getOdds()));
                shareBetParams.add(new ShareBetInfo.BetParamsBean(i.getId(),FormatNum.amountFormat1(i.getAmount(), 2, false),i.getSelectName(),i.getOdds(),null));
//                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getShareAlias(),i.getSelectName()));
                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getTitleRight()+"-"+i.getSelectName(),i.getSelectName()));
                count++;
            }
            bet.setTotalNum(SecretUtils.DESede(list.size() + ""));
            shareBetInfo.setTotalNums(list.size()+"");
            shareBetInfo.setSpecialPlay(true);
//        } else if(gameType.equals("lhc") && leftTitle.equals("平特一肖")){
//            int count = 0;
//            for (LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean i : list) {
//                betList.add(new LotteryBetBean.BetBeanBean(SecretUtils.DESede(i.getId()), SecretUtils.DESede(FormatNum.amountFormat1(i.getAmount(), 2, false)), null, SecretUtils.DESede(gameId), SecretUtils.DESede(i.getOdds())));
//                shareBetList.add(new ShareBetList(count+"",FormatNum.amountFormat1(i.getAmount(), 2, false),i.getName() ,i.getOdds()));
//                shareBetParams.add(new ShareBetInfo.BetParamsBean(i.getId(),FormatNum.amountFormat1(i.getAmount(), 2, false),i.getName(),i.getOdds()));
////                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getShareAlias(),i.getName()));
//                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getTitleRight(),i.getName()));
//                count++;
//            }
//            bet.setTotalNum(SecretUtils.DESede((list.size()) + ""));
//            shareBetInfo.setTotalNums(list.size()+"");
//            shareBetInfo.setSpecialPlay(false);
        } else {
            int count = 0;
            for (LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean i : list) {
                betList.add(new LotteryBetBean.BetBeanBean(SecretUtils.DESede(i.getId()), SecretUtils.DESede(FormatNum.amountFormat1(i.getAmount(), 2, false)), null, SecretUtils.DESede(gameId), SecretUtils.DESede(i.getOdds())));
                shareBetList.add(new ShareBetList(count+"",FormatNum.amountFormat1(i.getAmount(), 2, false),i.getName() ,i.getOdds()));
                shareBetParams.add(new ShareBetInfo.BetParamsBean(i.getId(),FormatNum.amountFormat1(i.getAmount(), 2, false),i.getName(),i.getOdds(),null));
//                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getShareAlias(),i.getName()));
                sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(i.getTitleRight()+"-"+i.getName(),i.getName()));
                count++;
            }
            bet.setTotalNum(SecretUtils.DESede((list.size()) + ""));
            shareBetInfo.setTotalNums(list.size()+"");
            shareBetInfo.setSpecialPlay(false);
        }
        String token = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
        bet.setToken(SecretUtils.DESede(token));
        bet.setGameId(SecretUtils.DESede(gameId));
        if ((!TextUtils.isEmpty(instant) && instant.equals("0"))) {
            bet.setBetIssue(SecretUtils.DESede(betIssue));
            bet.setEndTime(SecretUtils.DESede(dateToStamp(close) / 1000 + ""));
            //分享
            shareBetInfo.setTurnNum(betIssue);
            shareBetInfo.setFtime(dateToStamp(close) / 1000 + "");
        }
        bet.setTotalMoney(SecretUtils.DESede((FormatNum.amountFormat1(totalAmount + "", 2, false))));
        bet.setBetBean(betList);
        if (Constants.ENCRYPT)
            bet.setSign(SecretUtils.RsaToken());
        Gson gson = new Gson();
        String json = gson.toJson(bet);
//        Log.e("xxxxxx", "" + bet);
//        Log.e("xxxxxx", "" + shareBetList);

        //分享
        shareBetInfo.setBetParams(shareBetParams);
        shareBetInfo.setPlayNameArray(sharePlayName);
        shareBetInfo.setGameId(gameId);
        shareBetInfo.setGameName(gameName);
        shareBetInfo.setCode(code==null?"":code);
        shareBetInfo.setTotalMoney(FormatNum.amountFormat1(totalAmount + "", 2, false));

        String shareBetInfoJson = gson.toJson(shareBetInfo);
        String shareBetJson = gson.toJson(shareBetList);

        RequestBody body = RequestBody.create(Constants.JSON, json);
        if (isTest) {
            if (!TextUtils.isEmpty(instant) && instant.equals("1")) {
                url = Constants.INSTANTLOTTERYBET + (Constants.ENCRYPT ? Constants.SIGN : "");
            } else {
                url = Constants.LOTTERYGUESTBET + (Constants.ENCRYPT ? Constants.SIGN : "");
            }
        } else {
            if (!TextUtils.isEmpty(instant) && instant.equals("1")) {
                url = Constants.INSTANTLOTTERYBET + (Constants.ENCRYPT ? Constants.SIGN : "");
            } else {
                url = Constants.LOTTERYBET + (Constants.ENCRYPT ? Constants.SIGN : "");
            }
        }
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+url))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(context, true, BuyTicketDialog.this, true, BetBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BetBean bb = (BetBean) o;
                        if (bb != null && bb.getCode() == 0 && bb.getMsg() != null) {
                            if (!TextUtils.isEmpty(instant) && instant.equals("1"))
                                onClickListener.onClickListener(tvSure, 0, json, bb,"","","");
                            else
                                onClickListener.onClickListener(tvSure, 0, null, null,shareBetJson,shareBetInfoJson,FormatNum.amountFormat1(totalAmount + "", 2, false));
                        } else if (bb != null && bb.getCode() != 0 && bb.getMsg() != null) {
                            ToastUtils.ToastUtils(bb.getMsg(), getContext());
                            onClickListener.onClickListener(tvSure, 1, null, null,"","","");
                        }
                        if (tvCloseTime != null) {
                            tvCloseTime.stop();
                        }
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_REFRESH_AMOUNT));
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        dismiss();
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }


}
