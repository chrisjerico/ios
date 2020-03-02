package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.FeedbackRecordBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述: 反馈记录
 * 创建者: IAN
 * 创建时间: 2019/7/5 20:57
 */
public class FeedbackRecordAdapter extends BaseRecyclerAdapter<FeedbackRecordBean.DataBean.ListBean> {

    public FeedbackRecordAdapter(Context context, List<FeedbackRecordBean.DataBean.ListBean> list,
                                 int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder,FeedbackRecordBean.DataBean.ListBean item, int position,
                        boolean isScrolling) {

        ((TextView)holder.getView(R.id.type_tex)).setTextColor(context.getResources()
        .getColor(R.color.fount2));
        ((TextView)holder.getView(R.id.statre_tex)).setTextColor(context.getResources()
                .getColor(R.color.fount2));
        ((TextView)holder.getView(R.id.context_tex)).setTextColor(context.getResources()
                .getColor(R.color.fount2));

        if (!StringUtils.isEmpty(item.getType())&&StringUtils.equals("1",item.getType())){
            holder.setText(R.id.type_tex,"我要投诉");
        }else{
            holder.setText(R.id.type_tex,"我要建议");
        }

        if (!StringUtils.isEmpty(item.getStatus())&&StringUtils.equals("1",item.getStatus())){
            holder.setText(R.id.statre_tex,"已回复");
        }else{
            holder.setText(R.id.statre_tex,"待回复");
        }

        if (!StringUtils.isEmpty(item.getContent())){
            holder.setText(R.id.context_tex,item.getContent());
        }else{
            holder.setText(R.id.context_tex,"");
        }
    }
}
