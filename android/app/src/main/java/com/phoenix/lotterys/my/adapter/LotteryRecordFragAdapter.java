package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.LotteryRecordBean;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/10 19:05
 */
public class LotteryRecordFragAdapter extends BaseRecyclerAdapter<LotteryRecordBean.DataBean.ListBean> {

    private String type;

    public void setType(String type) {
        this.type = type;
    }

    public LotteryRecordFragAdapter(Context context, List<LotteryRecordBean.DataBean.ListBean> list,
                                    int itemLayoutId) {
               super(context, list, itemLayoutId);
    }
    private List<String> listsUP =new ArrayList<>();
    private List<String> listsDown=new ArrayList<>();


    private LotteryRecordFragSonAdapter adapterUP;
    private LotteryRecordFragSonAdapter adapterDown;
    @Override
    public void convert(BaseRecyclerHolder holder, LotteryRecordBean.DataBean.ListBean item, int position, boolean isScrolling) {
        Uiutils.setRec(context,holder.getView(R.id.lottery_up_rec),1,true);
        Uiutils.setRec(context,holder.getView(R.id.lottery_down_rec),1,true);

        holder.setText(R.id.num_tex,item.getIssue());
        try {
            holder.setText(R.id.time_tex, StampToDate.stampToDate2(StampToDate.dateToStamp(item.getOpenTime())));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        setUP(item);
        if (!StringUtils.equals("bjkl8", item.getGameType())){
            setDown(item);
        }

        if (!StringUtils.isEmpty(item.getGameType())) {
            if (StringUtils.equals("lhc", item.getGameType())) {
                setAda(11,12);
            } else if (StringUtils.equals("pk10", item.getGameType())) {
                setAda(1,90);
            } else if ( StringUtils.equals("jsk3", item.getGameType())) {
//                setThree(item);
                setDown(item);
                setAda(2,89);
            } else if (StringUtils.equals("cqssc", item.getGameType())) {
                setAda(3,88);
            } else if ( StringUtils.equals("qxc", item.getGameType())) {
                setAda(3,86);
            } else if (StringUtils.equals("pk10nn", item.getGameType())) {
                adapterUP=new LotteryRecordFragSonAdapter(context,listsUP,R.layout.
                        lottery_record_frag_son_adapter,1);

                adapterDown=new LotteryRecordFragSonAdapter(context,listsDown,R.layout.
                        lottery_record_frag_son_adapter,87,item.getWinningPlayers());

//                setAda(1,87);
            } else if (StringUtils.equals("xyft", item.getGameType())) {
                setAda(1,90);
            } else if (StringUtils.equals("pcdd", item.getGameType())) {
                if (listsUP.size()>0){
                    int  id = 0;
                    for (String str :listsUP){
                        id +=Integer.parseInt(str);
                    }
                    listsUP.add(id+"");
                }
                setAda(10,90);
            } else if (StringUtils.equals("gd11x5", item.getGameType())) {
                setAda(3,85);
            } else if (StringUtils.equals("gdkl10", item.getGameType())) {
                setAda(3,86);
            } else if (StringUtils.equals("bjkl8", item.getGameType())) {
                setAda(9,9);
            }else{
                setAda(3,88);
            }
        }

        ((RecyclerView)holder.getView(R.id.lottery_up_rec)).setAdapter(adapterUP);
        ((RecyclerView)holder.getView(R.id.lottery_down_rec)).setAdapter(adapterDown);


        if (Uiutils.setBaColor(context,null)){
            ((TextView)holder.getView(R.id.num_tex)).setTextColor(context.getResources()
            .getColor(R.color.color_white));
        }

    }

    private void setThree(LotteryRecordBean.DataBean.ListBean item) {
        int downClose=0;
        if (listsUP.size()>0){
            for (String s :listsUP){
                downClose +=Integer.parseInt(s);
            }
        }

        if (listsDown.size()>0)
            listsDown.clear();

        listsDown.add(downClose+"");
        if (downClose>=11){
            listsDown.add("大");
        }else {
            listsDown.add("小");
        }
        if (null!=item&&!StringUtils.isEmpty(item.getResult())&&item.getResult().contains(",")){
            String result [] =item.getResult().split(",");
            listsDown =Arrays.asList(result);
            Log.e("aaaa","///1");
        }else{
            Log.e("aaaa","///2");
            listsDown.add(downClose+"");
            if (downClose>=11){
                listsDown.add("大");
            }else {
                listsDown.add("小");
            }

            if( downClose %2 ==0){
                listsDown.add("双");
            }else{
                listsDown.add("单");
            }
        }
    }


    private void setAda(int up,int down) {
            adapterUP=new LotteryRecordFragSonAdapter(context,listsUP,R.layout.
                    lottery_record_frag_son_adapter,up);

        adapterDown=new LotteryRecordFragSonAdapter(context,listsDown,R.layout.
                lottery_record_frag_son_adapter,down);
    }

    private void setDown(LotteryRecordBean.DataBean.ListBean item) {
        if (!StringUtils.isEmpty(item.getResult())&&item.getResult().contains(",")){
            String numsx [] =item.getResult().split(",");
            if (listsDown.size()>0)
                listsDown.clear();
            if (null!=numsx&&numsx.length>0)
            listsDown.addAll(Arrays.asList(numsx));
        }
    }

    private void setUP(LotteryRecordBean.DataBean.ListBean item) {
        if (!StringUtils.isEmpty(item.getNum())&&item.getNum().contains(",")){
            String num [] =item.getNum().split(",");

            if (listsUP.size()>0)
                listsUP.clear();

            if (null!=num&&num.length>0)
                if (item.getGameType().equals("bjkl8")){
                    if (listsDown.size()>0)
                        listsDown.clear();
                    for (int i =0;i<num.length;i++){
                        if (i<10){
                            listsUP.add(num[i]);
                        }else {
                            listsDown.add(num[i]);
                        }
                    }
                }else{
                    listsUP.addAll(Arrays.asList(num));
                }
        }
    }
}
