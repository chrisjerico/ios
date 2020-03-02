package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.MailFragBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;

import java.util.List;

/**
 * 文件描述:站内信adapter
 * 创建者: IAN
 * 创建时间: 2019/7/3 16:54
 */
public class MailAdapter extends BaseRecyclerAdapter<MailFragBean.DataBean.ListBean> {

    public MailAdapter(Context context, List<MailFragBean.DataBean.ListBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, MailFragBean.DataBean.ListBean item,
                        int position, boolean isScrolling) {

        holder.setText(R.id.title_tex,item.getTitle());
        holder.setText(R.id.time_tex,item.getUpdateTime());

        if (item.getIsRead()==0){
            ((TextView)holder.getView(R.id.title_tex)).setTextColor(context.getResources().getColor(
                    R.color.black));

            ((TextView)holder.getView(R.id.time_tex)).setTextColor(context.getResources().getColor(
                    R.color.black));
        }else{
            ((TextView)holder.getView(R.id.title_tex)).setTextColor(context.getResources().getColor(
                    R.color.my_line));

            ((TextView)holder.getView(R.id.time_tex)).setTextColor(context.getResources().getColor(
                    R.color.my_line));
        }
    }
}
