package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.NoteRecordBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:注单记录
 * 创建者: IAN
 * 创建时间: 2019/7/6 21:03
 */
public class NoteRecordAdapter extends BaseRecyclerAdapter<NoteRecordBean.DataBean.ListBean> {

    public NoteRecordAdapter(Context context, List<NoteRecordBean.DataBean.ListBean> list,
                             int itemLayoutId) {
        super(context, list, itemLayoutId);

    }
    private ConfigBean configBean;
    private int type;

    public NoteRecordAdapter(Context context, List<NoteRecordBean.DataBean.ListBean> list,
                             int itemLayoutId,int type) {
        super(context, list, itemLayoutId);
        this.type=type;
        configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setType(int type) {
        this.type = type;
    }

    @Override
    public void convert(BaseRecyclerHolder holder, NoteRecordBean.DataBean.ListBean item,
                        int position, boolean isScrolling) {

        if (type!=5&&type!=6) {
            holder.getView(R.id.note_record_adapter_lin).setVisibility(View.VISIBLE);
            holder.getView(R.id.real_person_lin).setVisibility(View.GONE);
            if (position % 2 == 1) {
                holder.getView(R.id.note_record_adapter_lin).setBackgroundColor(context.getResources()
                        .getColor(R.color.color_white));
            } else {
                holder.getView(R.id.note_record_adapter_lin).setBackgroundColor(Color.parseColor("#f3f3f3"));
            }

            holder.setText(R.id.name_tex1, "彩种:" + item.getGameName());
            holder.setText(R.id.issue_tex, "期数:" + item.getIssue());

            StringBuffer gameName =new StringBuffer();
            if (!StringUtils.isEmpty(item.getPlayGroupName()))
                gameName.append(item.getPlayGroupName());

            if(!StringUtils.isEmpty(item.getPlayName())) {
                if (!StringUtils.isEmpty(gameName)) {
                    gameName.append(" " + item.getPlayName());
                } else {
                    gameName.append(item.getPlayName());
                }
            }

            if(!StringUtils.isEmpty(item.getBetInfo())) {
                if (!StringUtils.isEmpty(gameName)) {
                    gameName.append(" " + item.getBetInfo());
                } else {
                    gameName.append(item.getBetInfo());
                }
            }
//
            holder.setText(R.id.odds_tex, Uiutils.setSype(
                    "赔率:" + item.getOdds(), 3, ("赔率:" +
                            item.getOdds()).length(), "#008000"));

            holder.setText(R.id.play_name_tex, Uiutils.setSype(
                    "玩法:" + gameName.toString(), 3, ("玩法:" +
                            gameName).length(), "#2F9CF3"));

            holder.setText(R.id.betAmount_tex, Uiutils.setSype(
                    "注单金额:" + Uiutils.getTwo(item.getBetAmount())+"元", 5,
                    ("注单金额:" + Uiutils.getTwo(item.getBetAmount())+"元").length(), "#FB594B"));
            holder.setText(R.id.id_tex, Uiutils.setSype(
                    "注单单号:" + item.getId(), 5,  ("注单单号:" + item.getId()).
                            length(),"#008000"));

            switch (type) {
                case 0:

                    if (!StringUtils.isEmpty(item.getSettleAmount())) {
                        double money =Double.parseDouble(item.getSettleAmount());

                        if (!item.getSettleAmount().contains("-")) {
                            holder.setText(R.id.win_amount_tex, Uiutils.setSype(
                                    "盈亏:" + "+" + money + "元",
                                    3, ("盈亏:" + "+" + money + "元").
                                            length(), "#FB594B"));
                        } else {
                            holder.setText(R.id.win_amount_tex, Uiutils.setSype(
                                    "盈亏:" + money + "元",
                                    3, ("盈亏:" +money + "元").
                                            length(), "#008000"));
                        }
                    }
                    StringBuilder sb = new StringBuilder( item.getLotteryNo());//构造一个StringBuilder对象
                    if (sb.length()>40){
                        sb.insert(30, "\n");//在指定的位置1，插入指定的字符串
                    }
                    holder.setText(R.id.lotteryNo_tex, Uiutils.setSype(
                            sb.toString(),
                            0, ( sb.toString()).
                                    length(), "#2F9CF3"));

                    holder.getView(R.id.cancel_order_tex).setVisibility(View.GONE);
                    holder.getView(R.id.win_amount_tex).setVisibility(View.VISIBLE);
                    break;
                case 1:
//                        if (!item.getSettleAmount().contains("-")) {
//                            holder.setText(R.id.win_amount_tex, Uiutils.setSype(
//                                    "盈亏:" + "" + Uiutils.getTwo(item.getBetAmount()) + "元",
//                                    3, ("盈亏:" + "+" + Uiutils.getTwo(item.getBetAmount()) + "元").
//                                            length(), "#FB594B"));
////                        }
//                        else {
                    if (!StringUtils.isEmpty(item.getSettleAmount())) {
                        double money = Double.parseDouble(item.getSettleAmount());
                        holder.setText(R.id.win_amount_tex, Uiutils.setSype(
                                "盈亏:" + money+ "元",
                                4, ("盈亏:" + money + "元").
                                        length(), "#008000"));
//                        }
                    }

                    StringBuilder sb1 = new StringBuilder( item.getLotteryNo());//构造一个StringBuilder对象
                    if (sb1.length()>40){
                        sb1.insert(30, "\n");//在指定的位置1，插入指定的字符串
                    }
                    holder.setText(R.id.lotteryNo_tex, Uiutils.setSype(
                            sb1.toString(),
                            0, ( sb1.toString()).
                                    length(), "#2F9CF3"));

                    holder.getView(R.id.cancel_order_tex).setVisibility(View.GONE);
                    holder.getView(R.id.win_amount_tex).setVisibility(View.VISIBLE);
                    break;
                case 2:
                    holder.setText(R.id.win_amount_tex, Uiutils.setSype(
                            "可赢: +" + Uiutils.getTwo(item.getExpectAmount()) + "元", 3,
                            ("可赢: +" + Uiutils.getTwo(item.getExpectAmount()) + "元").length(),
                            "#FB594B")
                    );

                    holder.setText(R.id.lotteryNo_tex,
                            "未开奖");


                    holder.setText(R.id.lotteryNo_tex, Uiutils.setSype(
                            "未开奖",
                            0, ("未开奖").
                                    length(), "#2F9CF3"));

                    if (null!=configBean&&null!=configBean.getData()&&
                            configBean.getData().getAllow_member_cancel_bet())
                        holder.getView(R.id.cancel_order_tex).setVisibility(View.VISIBLE);
                    break;
                case 3:

                    holder.setText(R.id.lotteryNo_tex, Uiutils.setSype(
                            "已撤单",
                            0, ( "已撤单").
                                    length(), "#2F9CF3"));

                    holder.getView(R.id.cancel_order_tex).setVisibility(View.GONE);
                    holder.getView(R.id.win_amount_tex).setVisibility(View.GONE);
                    break;
            }

            holder.getView(R.id.cancel_order_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.CANCEL_ORDER, position));
                }
            });
        }else{
            if (position % 2 == 1) {
                holder.getView(R.id.real_person_lin).setBackgroundColor(context.getResources()
                        .getColor(R.color.color_white));
            } else {
                holder.getView(R.id.real_person_lin).setBackgroundColor(Color.parseColor("#f3f3f3"));
            }

            if (type==6)
                holder.getView(R.id.happiness_tex_5).setVisibility(View.VISIBLE);

            holder.getView(R.id.real_person_lin).setVisibility(View.VISIBLE);
            holder.getView(R.id.note_record_adapter_lin).setVisibility(View.GONE);
            holder.getView(R.id.happiness_tex0).setVisibility(View.VISIBLE);
            holder.getView(R.id.happiness_tex).setVisibility(View.GONE);

            holder.getView(R.id.name_text1).setVisibility(View.VISIBLE);
            holder.getView(R.id.name_tex).setVisibility(View.GONE);
            holder.getView(R.id.name_tex_lin).setVisibility(View.GONE);
            holder.getView(R.id.happiness_tex_lin).setVisibility(View.GONE);
            holder.getView(R.id.happy_balance_tex_lin).setVisibility(View.GONE);

            LinearLayout.LayoutParams topContentTextView_lp = new LinearLayout.LayoutParams(
                    0, LinearLayout.LayoutParams.MATCH_PARENT, 1.5f);
            holder.getView(R.id.full_date_lin).setLayoutParams(topContentTextView_lp);
            ((TextView)holder.getView(R.id.name_text1)).setMaxLines(2);
            if (StringUtils.isEmpty(item.getGameTypeName())){
                holder.setText(R.id.name_text1, item.getGameName());
            }else{
                holder.setText(R.id.name_text1, item.getGameName()+"\n"+item.getGameTypeName());
            }
            holder.setText(R.id.happiness_tex0, item.getBetTime().replace(" ","\n"));
            holder.setText(R.id.happy_balance_tex, item.getBetAmount());
            holder.setText(R.id.full_date_tex, item.getWinAmount());


        }
    }
}
