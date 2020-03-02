package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.SignInBean;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/13 13:00
 */
public class SignInAdapter extends BaseRecyclerAdapter<SignInBean.DataBean.CheckinListBean> {

    private String date;

    private String minDate;

    public String getMinDate() {
        return minDate;
    }

    public void setMinDate(String minDate) {
        this.minDate = minDate;
    }

    public SignInAdapter(Context context, List<SignInBean.DataBean.CheckinListBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
         date = Uiutils.getFetureDate(0);
         Log.e("date==",date+"///");
    }


    @Override
    public void convert(BaseRecyclerHolder holder, SignInBean.DataBean.CheckinListBean item,
                        int position, boolean isScrolling) {

            holder.setText(R.id.time_tex,setStype(item.getUpdateTime()));
        holder.setText(R.id.week_tex,item.getWeek());
        holder.setText(R.id.num_tex,"+"+item.getIntegral());

//        holder.setText(R.id.time,item.getUpdateTime());
        boolean ispastdue =isTrue(date, item.getUpdateTime());
//
        if (item.isIsCheckin()){
            holder.setText(R.id.is_sign_tex,"已签到");
            holder.getView(R.id.is_sign_tex).setBackground(context.getResources().getDrawable(
                    R.drawable.ba_esh_50));

            holder.getView(R.id.bac_lin).setBackground(context.getResources().getDrawable(
                    R.drawable.signed));
            holder.getView(R.id.is_sign_tex).setOnClickListener(null);

        }else if (!item.isIsMakeup()&& ispastdue){
            holder.setText(R.id.is_sign_tex,"已补签");
            holder.getView(R.id.bac_lin).setBackground(context.getResources().getDrawable(
                    R.drawable.signed));

            holder.getView(R.id.is_sign_tex).setBackground(context.getResources().getDrawable(
                    R.drawable.ba_esh_50));

            holder.getView(R.id.is_sign_tex).setOnClickListener(null);

        } else if (item.isIsMakeup()){
            if (StringUtils.isEmpty(minDate)){
                minDate =item.getUpdateTime();
            }else{
                if (isTrue(minDate,item.getUpdateTime())){
                    minDate =item.getUpdateTime();
                }
            }

            Log.e("minDate==",minDate+"///");

            holder.setText(R.id.is_sign_tex,"补签");
            holder.getView(R.id.bac_lin).setBackground(context.getResources().getDrawable(
                    R.drawable.nosign));

            holder.getView(R.id.is_sign_tex).setBackground(context.getResources().getDrawable(
                    R.drawable.ba_esh1_50));

            holder.getView(R.id.is_sign_tex).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Log.e("minDate==",minDate+"//");
                    if (isTrue(item.getUpdateTime(),minDate)){
                        ToastUtil.toastShortShow(context,"必须从前往后补签");
                    }else{
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.SIGN_IN,
                                new My_item(1,item.getUpdateTime())));

                    }
                }
            });
        }else{
            holder.setText(R.id.is_sign_tex,"签到");
            holder.getView(R.id.bac_lin).setBackground(context.getResources().getDrawable(
                    R.drawable.nosign));

            holder.getView(R.id.is_sign_tex).setBackground(context.getResources().getDrawable(
                    R.drawable.ba_blue_50));

            if (StringUtils.equals(date,item.getUpdateTime())){
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.GO_SIGN,date));

                holder.getView(R.id.is_sign_tex).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.SIGN_IN,
                                new My_item(0,item.getUpdateTime())));
                    }
                });
            }else{
                holder.getView(R.id.is_sign_tex).setOnClickListener(null);
            }

        }



        if (Uiutils.setBaColor(context,null)){
            ((TextView)holder.getView(R.id.time_tex)).setTextColor(context.getResources()
            .getColor(R.color.color_white));
            ((TextView)holder.getView(R.id.week_tex)).setTextColor(context.getResources()
                    .getColor(R.color.color_white));
        }



    }

    private boolean isTrue(String date, String date2) {
        try {
            return StampToDate.dateToStamp(date,2)>StampToDate.dateToStamp(
                    date2,2);
        }catch (Exception e){
        }
        return false;
    }

    private String setStype(String time){
        String date =null;
        String[] dates =null;
        if (time.contains("-")) {
            dates = time.split("-");
        }

        if (null!=dates&&dates.length==3){
            date =dates [1]+"月"+dates [2]+"日";
        }

        return date;
    }
}
