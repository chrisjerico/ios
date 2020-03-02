package com.phoenix.lotterys.my.fragment;

import android.graphics.Typeface;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.NoteRecordPopAdapter;
import com.phoenix.lotterys.my.bean.MyBetBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:  注单详情
 * 创建者: IAN
 * 创建时间: 2019/7/14 16:01
 */
public class NoteDetailsFragB extends BaseFragments implements View.OnClickListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.img)
    ImageView img;
    @BindView(R2.id.name_tex)
    TextView nameTex;
    @BindView(R2.id.num_tex)
    TextView numTex;
    @BindView(R2.id.cancellations_tex)
    TextView cancellationsTex;
    @BindView(R2.id.playing_method_tex)
    TextView playingMethodTex;
    @BindView(R2.id.will_be_amount_tex)
    TextView willBeAmountTex;
    @BindView(R2.id.status_tex)
    TextView statusTex;

    private View spendTimeLin;
    private TextView spendTimeTex1;
    private TextView spendTimeTex2;

    private View spendNumLin;
    private TextView spendNumTex1;
    private TextView spendNumTex2;

    private View spendMoneyLin;
    private TextView spendMoneyTex1;
    private TextView spendMoneyTex2;

    private View sendAmountLin;
    private TextView sendAmountTex1;
    private TextView sendAmountTex2;

    private View lotterynumberLin;
    private TextView lotterynumberTex1;
    private TextView lotterynumberTex2;

    private View oddsLin;
    private TextView oddsLinTex1;
    private TextView oddsLinTex2;

    private MyBetBean.DataBean dataBean;
    private String id;

    public NoteDetailsFragB() {
        super(R.layout.note_details_frag_b, true, true);
    }
    private UserInfo configBean;
    @Override
    public void initView(View view) {
        configBean = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, UserInfo.class);
        Uiutils.setBarStye(titlebar, getActivity());

        if (null != getArguments())
            id = getArguments().getString("id");

        titlebar.setText("注单详情");
        serView(view);
        getData();
    }

    private MyBetBean myBetBean;

    private void getData() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("betId", id);

        NetUtils.get(Constants.GETUSERRECENTBET ,map, true, getContext()
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        myBetBean = GsonUtil.fromJson(object, MyBetBean.class);


                        if (null != myBetBean && null != myBetBean.getData()
                                && myBetBean.getData().size()
                                > 0) {
                            dataBean = myBetBean.getData().get(0);
                            setData();
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });

    }

    private void setData() {
        if (null == dataBean) return;

        Uiutils.setText(oddsLinTex1, "赔率");
        Uiutils.setText(oddsLinTex2, dataBean.getOdds());

        ImageLoadUtil.ImageLoad(getContext(), dataBean.getLogo(), img);
        Uiutils.setText(nameTex, dataBean.getTitle());
        Uiutils.setText(numTex, "第" + dataBean.getIssue() + "期");

        Uiutils.setText(spendTimeTex1, "投注时间");
        Uiutils.setText(spendTimeTex2, dataBean.getAddTime());
        Uiutils.setText(spendNumTex1, "投注单号");
        Uiutils.setText(spendNumTex2, dataBean.getId());
        Uiutils.setText(spendMoneyTex1, "投注金额");
        Uiutils.setText(spendMoneyTex2, dataBean.getMoney() + "元");
        spendMoneyTex2.setTextColor(getContext().getResources().getColor(R.color.fount1));
        spendMoneyTex2.setTypeface(Typeface.DEFAULT_BOLD);
        Uiutils.setText(sendAmountTex1, "派送金额");
        Uiutils.setText(sendAmountTex2, dataBean.getResultMoney() + "元");
        Uiutils.setText(lotterynumberTex1, "开奖号码");

        StringBuilder sb1 = new StringBuilder( dataBean.getLotteryNo());//构造一个StringBuilder对象
        if (sb1.length()>40){
            sb1.insert(30, "\n");//在指定的位置1，插入指定的字符串
        }

        Uiutils.setText(lotterynumberTex2, sb1.toString());
        lotterynumberTex2.setTextColor(getContext().getResources().getColor(R.color.fount1));


        Uiutils.setText(playingMethodTex, dataBean.getGroup_name()+"  "+dataBean.getPlay_name());
        willBeAmountTex.setText(Uiutils.setSype(
                "奖金: " + dataBean.getResultMoney() + "元", 4,
                ("奖金: " + dataBean.getResultMoney() + "元").length(), "#f57c00"));


        switch (dataBean.getStatus()) {
            case "0":  //未开将
                Uiutils.setText(statusTex, "待开奖");
                if (null!=configBean&&null!=configBean.getData()&&
                        configBean.getData().isAllowMemberCancelBet())
                cancellationsTex.setVisibility(View.VISIBLE);
                else
                    cancellationsTex.setVisibility(View.GONE);

                Uiutils.setText(lotterynumberTex2, "等待开奖");
                double money =0.0;
                if (!StringUtils.isEmpty(dataBean.getResultMoney()))
                    money+=Double.parseDouble(dataBean.getResultMoney());

                if (!StringUtils.isEmpty(dataBean.getMoney()))
                    money+=Double.parseDouble(dataBean.getMoney());

//                Uiutils.setText(playingMethodTex, dataBean.getGroup_name());
                willBeAmountTex.setText(Uiutils.setSype(
                        "奖金: " + money + "元", 4,
                        ("奖金: " + money + "元").length(), "#f57c00"));
                Uiutils.setText(sendAmountTex2, money + "元");
                break;
            case "1":
                if (StringUtils.equals("1", dataBean.getIsWin())) { //中将
                    Uiutils.setText(statusTex, "已中奖");
                    Uiutils.setText(sendAmountTex2, dataBean.getBonus() + "元");

                    willBeAmountTex.setText(Uiutils.setSype(
                            "奖金: " + dataBean.getBonus() + "元", 4,
                            ("奖金: " + dataBean.getBonus() + "元").length(), "#f57c00"));
                } else {  //未中将
                    Uiutils.setText(statusTex, "未中奖");
                    willBeAmountTex.setText("奖金:未中奖");

                    Uiutils.setText(sendAmountTex2, "未中奖");


                }
                break;
        }
    }

    private void serView(View view) {
        spendTimeLin = view.findViewById(R.id.spend_time_lin);
        spendTimeTex1 = spendTimeLin.findViewById(R.id.text1);
        spendTimeTex2 = spendTimeLin.findViewById(R.id.text2);

        spendNumLin = view.findViewById(R.id.spend_num_lin);
        spendNumTex1 = spendNumLin.findViewById(R.id.text1);
        spendNumTex2 = spendNumLin.findViewById(R.id.text2);

        spendMoneyLin = view.findViewById(R.id.spend_money_lin);
        spendMoneyTex1 = spendMoneyLin.findViewById(R.id.text1);
        spendMoneyTex2 = spendMoneyLin.findViewById(R.id.text2);

        sendAmountLin = view.findViewById(R.id.send_amount_lin);
        sendAmountTex1 = sendAmountLin.findViewById(R.id.text1);
        sendAmountTex2 = sendAmountLin.findViewById(R.id.text2);

        lotterynumberLin = view.findViewById(R.id.lottery_number_lin);
        lotterynumberTex1 = lotterynumberLin.findViewById(R.id.text1);
        lotterynumberTex2 = lotterynumberLin.findViewById(R.id.text2);

        oddsLin = view.findViewById(R.id.odds_lin);
        oddsLinTex1 = oddsLin.findViewById(R.id.text1);
        oddsLinTex2 = oddsLin.findViewById(R.id.text2);


    }

    @OnClick(R.id.cancellations_tex)
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.cancellations_tex:
                setPop();
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
    private View revokePop;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private NoteRecordPopAdapter popAdapter;
    private CustomPopWindow mCustomPopWindow;

    private void setPop() {

        revokePop = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop, null);
        revokePop.findViewById(R.id.clear_tex).setOnClickListener(this);
        revokePop.findViewById(R.id.commit_tex).setOnClickListener(this);

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), revokePop,
                MeasureUtil.dip2px(getContext(), 80), ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

        ((TextView) revokePop.findViewById(R.id.context_tex)).setText("您要撤销注单号" +
                id + "订单吗？");

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

    /**
     * 取消定单
     */
    private void clearOrders() {
        Map<String, Object> map = new HashMap<>();
        map.put("orderId", id);
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.post(Constants.CANCELBET, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object,getContext());
                getActivity().finish();
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_SINGLE_INJECTION));
            }

            @Override
            public void onError() {

            }
        });

    }

}
