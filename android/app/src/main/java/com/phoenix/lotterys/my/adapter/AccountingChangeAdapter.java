package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.AccountingChangeBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.List;

/**
 * 文件描述:  任务大厅adapter
 * 创建者: IAN
 * 创建时间: 2019/7/3 13:08
 */
public class AccountingChangeAdapter extends BaseRecyclerAdapter<AccountingChangeBean.DataBean.ListBean> {

    private int type;

    public AccountingChangeAdapter(Context context, List<AccountingChangeBean.DataBean.ListBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    public AccountingChangeAdapter(Context context, List<AccountingChangeBean.DataBean.ListBean> list, int itemLayoutId, int type) {
        super(context, list, itemLayoutId);
        this.type =type;
    }

    @Override
    public void convert(BaseRecyclerHolder holder, AccountingChangeBean.DataBean.ListBean item, int position, boolean isScrolling) {

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(MeasureUtil.px2dip(context,5),
                ViewGroup.LayoutParams.MATCH_PARENT);

        params.setMargins(0,15,0,15);

        ((TextView)holder.getView(R.id.name_tex_lin)).setLayoutParams(params);
        ((TextView)holder.getView(R.id.happiness_tex_lin)).setLayoutParams(params);
        ((TextView)holder.getView(R.id.happy_balance_tex_lin)).setLayoutParams(params);

        holder.setText(R.id.name_tex,item.getType());
        holder.setText(R.id.happiness_tex,item.getIntegral());
        holder.setText(R.id.happy_balance_tex,item.getNewInt());
        holder.setText(R.id.full_date_tex,item.getAddTime());

        ((TextView)holder.getView(R.id.name_tex)).setTextSize(MeasureUtil.px2sp(context,32));
        ((TextView)holder.getView(R.id.happiness_tex)).setTextSize(MeasureUtil.px2sp(context,32));
        ((TextView)holder.getView(R.id.happy_balance_tex)).setTextSize(MeasureUtil.px2sp(context,32));
        ((TextView)holder.getView(R.id.full_date_tex)).setTextSize(MeasureUtil.px2sp(context,32));

    }
}
