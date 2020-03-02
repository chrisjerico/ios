package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;

import java.util.List;

/**
 * 文件描述:  任务中心 （水平）
 * 创建者: IAN
 * 创建时间: 2019/7/2 22:49
 */
public class RecommenAdapterB extends BaseRecyclerAdapter<My_item> {

    public RecommenAdapterB(Context context, List<My_item> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, My_item item, int position, boolean isScrolling) {
        holder.setText(R.id.name_tex, item.getTitle());

        if (item.isSelected()){
            holder.getView(R.id.lin_tex).setVisibility(View.VISIBLE);
            ((TextView)holder.getView(R.id.name_tex)).setSelected(true);
        }else{
            holder.getView(R.id.lin_tex).setVisibility(View.GONE);
            ((TextView)holder.getView(R.id.name_tex)).setSelected(false);
        }

    }

}
