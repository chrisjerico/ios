package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.CheckinhistoryBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/13 13:00
 */
public class SignInPopAdapter extends BaseRecyclerAdapter<CheckinhistoryBean.DataBean> {

    public SignInPopAdapter(Context context, List<CheckinhistoryBean.DataBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }


    @Override
    public void convert(BaseRecyclerHolder holder, CheckinhistoryBean.DataBean item, int position, boolean isScrolling) {
        holder.setText(R.id.sign_in_date_tex,item.getCheckinDate());
        holder.setText(R.id.reward_tex,item.getIntegral());
        holder.setText(R.id.explain_tex,item.getRemark());

        holder.getView(R.id.sign_pop_lay_lin).setLayoutParams(new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, MeasureUtil.dip2px(context,40)
        ));

        ((TextView)holder.getView(R.id.reward_tex)).setTextColor(context.getResources().getColor(R.
                color.message_text_color));
    }
}
