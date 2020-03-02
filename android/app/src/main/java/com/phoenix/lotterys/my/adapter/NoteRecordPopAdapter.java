package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.List;

/**
 * 文件描述:注单记录pop
 * 创建者: IAN
 * 创建时间: 2019/7/6 21:33
 */
public class NoteRecordPopAdapter extends BaseRecyclerAdapter<My_item> {

    public NoteRecordPopAdapter(Context context, List<My_item> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, My_item item, int position, boolean isScrolling) {
        holder.setText(R.id.tv_title,item.getTitle());
        ((TextView)holder.getView(R.id.tv_title)).setVisibility(View.VISIBLE);
        ((RelativeLayout)holder.getView(R.id.rl_main)).setVisibility(View.VISIBLE);

        ((RelativeLayout)holder.getView(R.id.rl_main)).setLayoutParams(new
                RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                MeasureUtil.dip2px(context,40)));


        if (Uiutils.setBaColor(context,null)){
            holder.getView(R.id.rl_main).setBackgroundColor(0);
            ((TextView)holder.getView(R.id.tv_title)).setTextColor(context.getResources().getColor(
                    R.color.color_white));
        }


    }
}
