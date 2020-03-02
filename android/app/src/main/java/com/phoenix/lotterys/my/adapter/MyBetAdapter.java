package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.MyBetBean;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/8 16:10
 */
public class MyBetAdapter extends BaseRecyclerAdapter<MyBetBean.DataBean> {

    public MyBetAdapter(Context context, List<MyBetBean.DataBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }


    @Override
    public void convert(BaseRecyclerHolder holder, MyBetBean.DataBean item, int position, boolean isScrolling) {

        holder.setText(R.id.name_tex,item.getTitle());
        holder.setText(R.id.bottom_pour_tex,"￥"+item.getMoney());


        if (!item.getResultMoney().contains("-")){
            holder.setText(R.id.air_marshal_tex,"+"+item.getResultMoney()+"元");
        }else{
            holder.setText(R.id.air_marshal_tex,item.getResultMoney()+"元");
        }
        holder.getView(R.id.air_marshal_tex).setVisibility(View.GONE);

        holder.setText(R.id.num_tex,item.getIssue() +" 期");
        holder.setText(R.id.status_tex,item.getMsg());

//        holder.getView(R.id.air_marshal_tex).setVisibility(View.GONE);
        switch (item.getStatus()){
            case "0":  //未开将
                ((TextView)holder.getView(R.id.status_tex)).setTextColor(context.getResources()
                .getColor(R.color.fount1));
                break;
            case "1":
                if (StringUtils.equals("1",item.getIsWin())) { //中将
                    ((TextView)holder.getView(R.id.status_tex)).setTextColor(Color.parseColor("#4caf50"));
                    holder.getView(R.id.air_marshal_tex).setVisibility(View.VISIBLE);

                    if (!item.getResultMoney().contains("-")){
                        holder.setText(R.id.air_marshal_tex,"+"+item.getBonus()+"元");
                    }else{
                        holder.setText(R.id.air_marshal_tex,item.getBonus()+"元");
                    }

                }else{  //未中将
                    if (Uiutils.setBaColor(context,null)){
                        ((TextView)holder.getView(R.id.status_tex)).setTextColor(context.getResources()
                                .getColor(R.color.color_white));
                    }else{
                        ((TextView)holder.getView(R.id.status_tex)).setTextColor(context.getResources()
                                .getColor(R.color.fount2));
                    }

                }
                break;
        }



    }
}
