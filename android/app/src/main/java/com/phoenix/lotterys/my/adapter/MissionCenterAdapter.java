package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;

import java.util.List;

/**
 * 文件描述:  任务中心 （水平）
 * 创建者: IAN
 * 创建时间: 2019/7/2 22:49
 */
public class MissionCenterAdapter extends BaseRecyclerAdapter<My_item> {

    public MissionCenterAdapter(Context context, List<My_item> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, My_item item, int position, boolean isScrolling) {
        holder.setText(R.id.mission_tex,item.getTitle());

            switch (position){
                case 0:
                    setIma(holder,R.mipmap.missions);
                    if (item.isSelected()){
                        setBac(holder,R.drawable.shape_ticket_name_select);
                    }else{
                        setBac(holder,R.drawable.shape_ticket_name_grayt5);
                    }
                    break;
                case 1:
                    if (item.isSelected()){
                        setBac(holder,R.drawable.shape_ticket_name_select1);
                    }else {
                        setBac(holder,R.drawable.shape_ticket_name_grayt5);
                    }
                    setIma(holder,R.mipmap.integral);
                    break;
                case 2:
                    if (item.isSelected()){
                        setBac(holder,R.drawable.shape_ticket_name_select2);
                    }else {
                        setBac(holder,R.drawable.shape_ticket_name_grayt5);
                    }

                    setIma(holder,R.mipmap.integralchange);
                    break;
                case 3:
                    if (item.isSelected()){
                        setBac(holder,R.drawable.shape_ticket_name_select3);
                    }else {
                        setBac(holder,R.drawable.shape_ticket_name_grayt5);
                    }
                    setIma(holder,R.mipmap.vipgrade);
                    break;
            }


            if (Uiutils.isSite("c200")){
                LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams)holder.getView(R.id.mission_lin).getLayoutParams();
                layoutParams.width = ViewGroup.LayoutParams.WRAP_CONTENT;
                layoutParams.setMargins(20,0,0,0);
                holder.getView(R.id.mission_lin).setLayoutParams(layoutParams);
                holder.getView(R.id.mission_tex).setPadding(20,0,20,0);
            }

    }

    private void setBac(BaseRecyclerHolder holder,int id) {
        holder.getView(R.id.mission_lin).setBackground(context.getResources().getDrawable(
                id));
    }

    private void setIma(BaseRecyclerHolder holder,int id) {

        Drawable drawable = context.getResources().getDrawable(
                id);
        if (Uiutils.isSite("c200")){
            ((TextView)holder.getView(R.id.mission_tex)).setCompoundDrawablesWithIntrinsicBounds
                    (null,null,null,null);
        }else{
            ((TextView)holder.getView(R.id.mission_tex)).setCompoundDrawablesWithIntrinsicBounds
                    (drawable,null,null,null);
        }
    }
}
