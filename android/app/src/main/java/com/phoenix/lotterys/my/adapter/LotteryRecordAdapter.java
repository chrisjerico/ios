package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/10 16:31
 */
public class LotteryRecordAdapter extends BaseRecyclerAdapter<My_item> {

    private String name;

    public LotteryRecordAdapter(Context context, List<My_item> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    public LotteryRecordAdapter(Context context, List<My_item> list, int itemLayoutId,String name) {
        super(context, list, itemLayoutId);
        this.name=name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public void convert(BaseRecyclerHolder holder, My_item item, int position, boolean isScrolling) {


        if (Uiutils.setBaColor(context,null)){
            holder.getView(R.id.main_lin).setBackgroundColor(context.getResources()
                    .getColor(R.color.black1));
            if (!StringUtils.isEmpty(name) && StringUtils.equals(name, item.getTitle())) {
//                holder.getView(R.id.city_pop_tex).setBackgroundColor(context.getResources()
//                        .getColor(R.color.colorPrimary));

                ((TextView) holder.getView(R.id.city_pop_tex)).setTextColor(Color.
                        parseColor("#F06393"));
            } else {
//                holder.getView(R.id.city_pop_tex).setBackgroundColor(context.getResources()
//                        .getColor(R.color.white));

                ((TextView) holder.getView(R.id.city_pop_tex)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
            }
        }else {
            if (!StringUtils.isEmpty(name) && StringUtils.equals(name, item.getTitle())) {
                holder.getView(R.id.city_pop_tex).setBackgroundColor(context.getResources()
                        .getColor(R.color.colorPrimary));

                ((TextView) holder.getView(R.id.city_pop_tex)).setTextColor(Color.
                        parseColor("#F06393"));
            } else {
                holder.getView(R.id.city_pop_tex).setBackgroundColor(context.getResources()
                        .getColor(R.color.white));

                ((TextView) holder.getView(R.id.city_pop_tex)).setTextColor(context.getResources()
                        .getColor(R.color.fount2));
            }
        }
        holder.setText(R.id.city_pop_tex,item.getTitle());

    }
}
