package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/9/8 13:51
 */
public class TextAdapter extends BaseRecyclerAdapter<String> {

    public TextAdapter(Context context, List<String> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, String item, int position, boolean isScrolling) {
        holder.setText(R.id.text,item);

        if (Uiutils.setBaColor(context,null)){
            ((TextView)holder.getView(R.id.text)).setTextColor(context.getResources()
            .getColor(R.color.color_white));
        }
    }
}
