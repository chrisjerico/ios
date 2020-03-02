package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.VIPLevelBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.List;

/**
 * 文件描述:  任务大厅adapter
 * 创建者: IAN
 * 创建时间: 2019/7/3 13:08
 */
public class VIPLevelAdapter extends BaseRecyclerAdapter<VIPLevelBean.DataBean> {

    private int type;

    public VIPLevelAdapter(Context context, List<VIPLevelBean.DataBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    public VIPLevelAdapter(Context context, List<VIPLevelBean.DataBean> list, int itemLayoutId,int type) {
        super(context, list, itemLayoutId);
        this.type =type;
    }

    @Override
    public void convert(BaseRecyclerHolder holder, VIPLevelBean.DataBean item, int position, boolean isScrolling) {
//
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(MeasureUtil.px2dip(context,5),
                ViewGroup.LayoutParams.MATCH_PARENT);
//
//        params.setMargins(0,15,0,15);

//        ((TextView)holder.getView(R.id.name_tex_lin)).setLayoutParams(params);
//        ((TextView)holder.getView(R.id.happiness_tex_lin)).setLayoutParams(params);
//        ((TextView)holder.getView(R.id.happy_balance_tex_lin)).setLayoutParams(params);

        holder.getView(R.id.full_date_lin).setVisibility(View.GONE);
        holder.getView(R.id.name_tex).setVisibility(View.GONE);
        holder.getView(R.id.vip_lin).setVisibility(View.VISIBLE);

//        holder.setText(R.id.name_tex,item.getType());

//        switch (item.getLevelName()){
//            case "VIP0":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip0));
//                break;
//            case "VIP1":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip1));
//                break;
//            case "VIP2":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip2));
//                break;
//            case "VIP3":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip3));
//                break;
//            case "VIP4":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip4));
//                break;
//            case "VIP5":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip5));
//                break;
//            case "VIP6":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip6));
//                break;
//            case "VIP7":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip7));
//                break;
//            case "VIP8":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip8));
//                break;
//            case "VIP9":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip9));
//                break;
//            case "VIP10":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip10));
//                break;
//            case "VIP11":
//                holder.getView(R.id.vip_tex).setBackground(context.getResources().getDrawable(R.
//                        mipmap.vip11));
//                break;

//        }

        holder.setText(R.id.vip_tex,item.getLevelName());
        holder.setText(R.id.happiness_tex,item.getLevelTitle());
        holder.setText(R.id.happy_balance_tex,item.getIntegral());

        ((TextView)holder.getView(R.id.name_tex)).setTextSize(MeasureUtil.px2sp(context,32));
        ((TextView)holder.getView(R.id.happiness_tex)).setTextSize(MeasureUtil.px2sp(context,32));
        ((TextView)holder.getView(R.id.happy_balance_tex)).setTextSize(MeasureUtil.px2sp(context,32));
        ((TextView)holder.getView(R.id.full_date_tex)).setTextSize(MeasureUtil.px2sp(context,32));



    }
}
