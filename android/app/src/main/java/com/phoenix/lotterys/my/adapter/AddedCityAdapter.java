package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.AddedCityBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/11 13:40
 */
public class AddedCityAdapter extends BaseRecyclerAdapter<AddedCityBean.DataBean> {

    public AddedCityAdapter(Context context, List<AddedCityBean.DataBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, final AddedCityBean.DataBean item,final int position,
                        boolean isScrolling) {

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,
                MeasureUtil.dip2px(context,30));
        if (position!=0&&position!=2){
            params.setMargins(12, 0, 0, 0);
        }else if (position==2){
            params.setMargins(0, 12, 0, 0);
        }else{
            params.setMargins(0, 0, 0, 0);
        }

        if (StringUtils.equals("1",item.getCountry())){
            holder.setText(R.id.context_tex,context.getResources().getString(R.string.foreign_country));
        }else {
            holder.setText(R.id.context_tex,context.getResources().getString(R.string.
                    china)+item.getProvince());
        }

        holder.getView(R.id.added_lin).setLayoutParams(params);

        holder.getView(R.id.clean_img).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.DELETECITIES,item.getId()));
            }
        });
    }
}
