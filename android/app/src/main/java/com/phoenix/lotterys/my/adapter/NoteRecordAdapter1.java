package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.NoteRecordBean;
import com.phoenix.lotterys.my.bean.NoteRecordBean1;
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
public class NoteRecordAdapter1 extends BaseRecyclerAdapter<NoteRecordBean1.DataBean.TicketsBean> {

    public NoteRecordAdapter1(Context context, List<NoteRecordBean1.DataBean.TicketsBean> list,
                              int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, NoteRecordBean1.DataBean.TicketsBean item,
                        int position, boolean isScrolling) {


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


            holder.setText(R.id.name_text1, item.getDate()+"\n"+item.getDayOfWeek());
            holder.setText(R.id.happiness_tex0, item.getBetCount());
            holder.setText(R.id.happy_balance_tex, item.getWinCount());
            holder.setText(R.id.full_date_tex, item.getWinAmount());
            holder.setText(R.id.happiness_tex_5, item.getWinLoseAmount());


            if (Uiutils.setBaColor(context,null)){
                ((TextView)holder.getView(R.id.name_text1)).setTextColor(context.getResources()
                .getColor(R.color.color_white));
                ((TextView)holder.getView(R.id.happiness_tex0)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
                ((TextView)holder.getView(R.id.happy_balance_tex)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
                ((TextView)holder.getView(R.id.full_date_tex)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
                ((TextView)holder.getView(R.id.happiness_tex_5)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
            }else{
                if (position % 2 == 1) {
                    holder.getView(R.id.real_person_lin).setBackgroundColor(context.getResources()
                            .getColor(R.color.color_white));
                } else {
                    holder.getView(R.id.real_person_lin).setBackgroundColor(Color.parseColor("#f3f3f3"));
                }
            }
    }
}
