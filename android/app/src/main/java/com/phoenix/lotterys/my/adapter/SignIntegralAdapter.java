package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.SignInBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/13 13:00
 */
public class SignIntegralAdapter extends BaseRecyclerAdapter<SignInBean.DataBean.CheckinBonusBean> {

    public SignIntegralAdapter(Context context, List<SignInBean.DataBean.CheckinBonusBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, SignInBean.DataBean.CheckinBonusBean item,
                        int position, boolean isScrolling) {
        holder.getView(R.id.is_receive_tex).setTag(position);
        if (0 == item.getPostinon()) {
            holder.setText(R.id.integral_tex, "5天礼包（" + item.getIntX() + ")");
            holder.setText(R.id.context_tex, "连续签到5天即可领取");

        } else {
            holder.setText(R.id.integral_tex, "7天礼包（" + item.getIntX() + ")");
            holder.setText(R.id.context_tex, "连续签到7天即可领取");
        }

//        if (position==1){
//            holder.setText(R.id.integral_tex, "7天礼包（" + item.getIntX() + ")");
//            holder.setText(R.id.context_tex, "连续签到7天即可领取");
//        }

        if (item.isCheckin()) {
            holder.setText(R.id.is_receive_tex, "领取");
            holder.getView(R.id.is_receive_tex).setBackground(context.getResources().getDrawable(
                    R.drawable.ba_blue_50));
//            is_receive_tex.se
            holder.getView(R.id.is_receive_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Map<String, Object> map = new HashMap<>();
                    if (item.getPostinon() == 0) {
                        map.put("type", 5 + "");
                    } else {
                        map.put("type", 7 + "");
                    }
                    map.put("token", Uiutils.getToken(context));

                    NetUtils.post(Constants.CHECKINBONUS, map, true, context, new NetUtils.NetCallBack() {
                        @Override
                        public void onSuccess(String object) {
                            holder.getView(R.id.is_receive_tex).setBackground(context.getResources().getDrawable(
                                    R.drawable.ba_esh_50));
                            holder.getView(R.id.is_receive_tex).setOnClickListener(null);
                            EvenBusUtils.setEvenBus(new Even(EvenBusCode.ATTENDANCE_BRUSH_DATA));
                        }

                        @Override
                        public void onError() {

                        }
                    });

                }
            });
        }else {
            holder.getView(R.id.is_receive_tex).setBackground(context.getResources().getDrawable(
                    R.drawable.ba_esh_50));
            holder.getView(R.id.is_receive_tex).setOnClickListener(null);
            if (item.isIsComplete()) {
                holder.setText(R.id.is_receive_tex, "已领取");
            } else {
                holder.setText(R.id.is_receive_tex, "领取");
            }
        }


        if (Uiutils.setBaColor(context,null)){
            ((TextView)holder.getView(R.id.integral_tex)).setTextColor(context.getResources()
                    .getColor(R.color.color_white));
            ((TextView)holder.getView(R.id.context_tex)).setTextColor(context.getResources()
                    .getColor(R.color.color_white));
        }


    }
}
