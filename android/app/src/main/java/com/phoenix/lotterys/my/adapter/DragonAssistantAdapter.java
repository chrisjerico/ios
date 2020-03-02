package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.content.res.Resources;
import android.os.CountDownTimer;
import android.util.Log;
import android.util.SparseArray;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.LatestLongDragonBean;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/8 14:30
 */
public class DragonAssistantAdapter extends BaseRecyclerAdapter<LatestLongDragonBean.DataBean> {

    private SparseArray<CountDownTimer> timerArray;

    public DragonAssistantAdapter(Context context, List<LatestLongDragonBean.DataBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
        timerArray = new SparseArray<>();
    }

    private String id;
    private LatestLongDragonBean.DataBean dataBean;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setDataBean(LatestLongDragonBean.DataBean dataBean) {
        this.dataBean = dataBean;
    }

    public LatestLongDragonBean.DataBean getDataBean() {
        return dataBean;
    }

    @Override
    public void convert(final BaseRecyclerHolder holder, LatestLongDragonBean.DataBean item, int position, boolean isScrolling) {

        if (null!=holder.getCountDownTimer()){
            holder.getCountDownTimer().cancel();
        }

        holder.setText(R.id.title_tex,item.getTitle());
        ImageLoadUtil.ImageLoad(context,item.getLogo(),holder.getView(R.id.head_img));
        holder.setText(R.id.num_tex,item.getIssue());

        holder.setText(R.id.front_name_tex,item.getBetList().get(0).getPlayName());
        holder.setText(R.id.front_num_tex,item.getBetList().get(0).getOdds());

        holder.setText(R.id.after_name_tex,item.getBetList().get(1).getPlayName());
        holder.setText(R.id.after_num_tex,item.getBetList().get(1).getOdds());

        holder.setText(R.id.text1,item.getPlayCateName());
        holder.setText(R.id.text2,item.getPlayName());
        holder.setText(R.id.text3,item.getCount());

        switch (item.getPlayName()){
            case "大":holder.getView(R.id.text2).setBackground(context.getResources().
                    getDrawable(R.drawable.lottery_bck_8));
            break;
            case "小":holder.getView(R.id.text2).setBackground(context.getResources().
                    getDrawable(R.drawable.lottery_bck_10));
            break;
            case "单":holder.getView(R.id.text2).setBackground(context.getResources().
                    getDrawable(R.drawable.lottery_bck_11));
            break;
            case "双":holder.getView(R.id.text2).setBackground(context.getResources().
                    getDrawable(R.drawable.lottery_bck_11));
            break;
            case "龙":holder.getView(R.id.text2).setBackground(context.getResources().
                    getDrawable(R.drawable.lottery_bck_12));
            break;
            case "虎":holder.getView(R.id.text2).setBackground(context.getResources().
                    getDrawable(R.drawable.lottery_bck_8));
            break;
            default:holder.getView(R.id.text2).setBackground(context.getResources().
                    getDrawable(R.drawable.lottery_bck_10));
            break;
        }


        if (!StringUtils.isEmpty(id)){
            if (StringUtils.equals(id,item.getBetList().get(0).getPlayId())){
                setType(holder,1);
                if (map.size()>0)
                    map =new HashMap<>();

                    map.put(id,holder.getView(R.id.latest_adapter_main_lin));
            }else if (StringUtils.equals(id,item.getBetList().get(1).getPlayId())){
                setType(holder,2);
                if (map.size()>0)
                    map =new HashMap<>();

                map.put(id,holder.getView(R.id.latest_adapter_main_lin));
            }else{
                setType(holder,0);
            }
        }else{
            setType(holder,0);
        }

        if (item.getLotteryCountdown()<=0){
            holder.setText(R.id.time_tex, "开奖中");
        }else {
            if (item.getCloseCountdown() > 0) {
                countDown =100000l;
//                isMoreTen =false;
//                if (item.getCloseCountdown()>10){
//                    countDown =item.getCloseCountdown();
//                }else{
//                    isMoreTen =true;
//                    countDown =item.getCloseCountdown() +10;
                countDown =110000;
//                }

                CountDownTimer countDownTimer = new CountDownTimer(countDown*1000, 1000) {
                    public void onTick(long millisUntilFinished) {
                        item.setLotteryCountdown(item.getLotteryCountdown()-1);
                        item.setCloseCountdown(item.getCloseCountdown()-1);

//                        if (isMoreTen){
                            if (item.getLotteryCountdown()<=0){
                                holder.setText(R.id.time_tex, "开奖中");
                            }else if (item.getCloseCountdown()<=0){
                                holder.setText(R.id.time_tex, "已封盘");
                            }else{


                                holder.setText(R.id.time_tex, Uiutils.getMinuteSecond(item.getCloseCountdown()*1000));
                            }
//                        }else{
//
//                            Log.e("setCloseCountdown==",item.getCloseCountdown()+"///0");
//                            Log.e("millisUntilFinished==",millisUntilFinished+"///0");
//                            holder.setText(R.id.time_tex, Uiutils.getMinuteSecond(millisUntilFinished));
//                        }

                    }

                    public void onFinish() {
                        //倒计时结束
                        holder.setText(R.id.time_tex, "已封盘");
                    }
                }.start();
                holder.setCountDownTimer(countDownTimer);
                timerArray.put(holder.getCountDownTimer().hashCode(), holder.getCountDownTimer());
            } else {
                holder.setText(R.id.time_tex, "已封盘");
            }
        }

        holder.getView(R.id.front_lin).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (isOK(holder)) return;

                coloSype();

                boolean isok =false;
                if (null!=dataBean&&dataBean!=item){
                    isok=true;
                }

                if (!StringUtils.isEmpty(id)&&StringUtils.equals(id,item.getBetList().get(0).getPlayId())){
                    id = "";
                    dataBean=null;
                    setType(holder,0);
                    if (map.containsKey(item.getBetList().get(1).getPlayId()))
                        map.remove(item.getBetList().get(1).getPlayId());
                }else{


                    id = item.getBetList().get(0).getPlayId();
                    dataBean=item;
                    setType(holder,1);
                    map.put(id,holder.getView(R.id.latest_adapter_main_lin));
                }

//                if (isok) {
//                    if ()
////                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_REFRESH_DATA));
//                }

                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_QUEUES_REPLACE));
            }
        });
        holder.getView(R.id.after_lin).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isOK(holder)) return;

                coloSype();

                boolean isok =false;
                if (null!=dataBean&&dataBean!=item){
                    isok=true;
                }

                if (!StringUtils.isEmpty(id)&&StringUtils.equals(id,item.getBetList().get(1).getPlayId())){
                    id = "";
                    dataBean=null;
                    setType(holder,0);
                    if (map.containsKey(item.getBetList().get(1).getPlayId()))
                        map.remove(item.getBetList().get(1).getPlayId());
                }else{
                    id = item.getBetList().get(1).getPlayId();
                    dataBean=item;
                    setType(holder,2);
                    map.put(id,holder.getView(R.id.latest_adapter_main_lin));
                }

//                if (isok){
////                 EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_REFRESH_DATA));
//                }

                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_QUEUES_REPLACE));
//                notifyDataSetChanged();

            }
        });


        try {
            if (Uiutils.setBaColor(context,null)){
                holder.getView(R.id.latest_adapter_main_lin).setBackground(context.getResources()
                .getDrawable(R.drawable.lottery_bck_14));

                ((TextView)holder.getView(R.id.title_tex)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));

                ((TextView)holder.getView(R.id.num_tex)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));

            }
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        }


    }
    private  long  countDown =1000000l;
//    private  boolean isMoreTen =false;
    private Map<String,View> map =new HashMap<>();

    private void coloSype() {
        if (map.size()>0) {
            for (Map.Entry<String, View> entry : map.entrySet()) {
                    View views =entry.getValue();
                if (null != views) {
                    Log.e("view", "ksfsfsjfsljfls");
                    views.findViewById(R.id.front_lin).setSelected(false);
                    views.findViewById(R.id.front_name_tex).setSelected(false);
                    views.findViewById(R.id.front_num_tex).setSelected(false);

                    views.findViewById(R.id.after_lin).setSelected(false);
                    views.findViewById(R.id.after_name_tex).setSelected(false);
                    views.findViewById(R.id.after_num_tex).setSelected(false);
                }
            }
        }else{
            Log.e("view","null");
        }
    }
      private boolean isOK(BaseRecyclerHolder holder) {
        if (!StringUtils.isEmpty(((TextView)holder.getView(R.id.time_tex)).getText().
                toString())){
            String name = ((TextView)holder.getView(R.id.time_tex)).getText().
                    toString();
            if (StringUtils.equals("已封盘",name)||StringUtils.equals("开奖中",name)){
                ToastUtil.toastShortShow(context,"封盘或开奖,请等下期");
                return true;
            }
        }
        return false;
    }

    /**
     * 清计时缓存 防内存泄漏
     */
    public void cancelAllTimers(){
        Uiutils.cancelAllTimers(timerArray);
    }

    private void setType(BaseRecyclerHolder holder,int type ) {
            if (type==1) {
                holder.getView(R.id.front_lin).setSelected(true);
                holder.getView(R.id.front_name_tex).setSelected(true);
                holder.getView(R.id.front_num_tex).setSelected(true);

                holder.getView(R.id.after_lin).setSelected(false);
                holder.getView(R.id.after_name_tex).setSelected(false);
                holder.getView(R.id.after_num_tex).setSelected(false);
            }else if (type==2){
                holder.getView(R.id.front_lin).setSelected(false);
                holder.getView(R.id.front_name_tex).setSelected(false);
                holder.getView(R.id.front_num_tex).setSelected(false);

                holder.getView(R.id.after_lin).setSelected(true);
                holder.getView(R.id.after_name_tex).setSelected(true);
                holder.getView(R.id.after_num_tex).setSelected(true);
            }else{
                holder.getView(R.id.front_lin).setSelected(false);
                holder.getView(R.id.front_name_tex).setSelected(false);
                holder.getView(R.id.front_num_tex).setSelected(false);

                holder.getView(R.id.after_lin).setSelected(false);
                holder.getView(R.id.after_name_tex).setSelected(false);
                holder.getView(R.id.after_num_tex).setSelected(false);
            }
    }
}
