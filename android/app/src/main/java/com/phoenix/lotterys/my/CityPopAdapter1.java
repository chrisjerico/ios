package com.phoenix.lotterys.my;

import android.content.Context;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.FundsBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/4 16:10
 */
public class CityPopAdapter1 extends BaseRecyclerAdapter<FundsBean.DataBean.GroupsBean> {

    public CityPopAdapter1(Context context, List<FundsBean.DataBean.GroupsBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, FundsBean.DataBean.GroupsBean item, int position, boolean isScrolling) {
        holder.setText(R.id.city_pop_tex,item.getName());
//        if (item.isSelected()){
//            ((TextView)holder.getView(R.id.city_pop_tex)).setTextColor(context.getResources().
//                    getColor(R.color.color_fe594b));
//
//        }else{
//            ((TextView)holder.getView(R.id.city_pop_tex)).setTextColor(context.getResources().
//                    getColor(R.color.black));
//        }


        if (Uiutils.setBaColor(context,null)){
//            if (item.isSelected()){
//                ((TextView)holder.getView(R.id.city_pop_tex)).setTextColor(context.getResources().
//                        getColor(R.color.color_fe594b));
//
//            }else{
                ((TextView)holder.getView(R.id.city_pop_tex)).setTextColor(context.getResources().
                        getColor(R.color.color_white));
            }
//        }

    }
}
