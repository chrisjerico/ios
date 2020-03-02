package com.phoenix.lotterys.my.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.MissionHallBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 文件描述:  任务大厅adapter
 * 创建者: IAN
 * 创建时间: 2019/7/3 13:08
 */
public class MissionHallAdapter extends BaseRecyclerAdapter<MissionHallBean.DataBean.ListBean>
        implements View.OnClickListener {


    private CustomPopWindow mCustomPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;
    private TextView contextTex;

    public MissionHallAdapter(Context context, List<MissionHallBean.DataBean.ListBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
        setHead();
    }

    private void setHead() {
        contentView = LayoutInflater.from(context).inflate(R.layout.revoke_pop, null);
        contentView.findViewById(R.id.clear_tex).setVisibility(View.GONE);
        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);
        ((TextView) contentView.findViewById(R.id.title_tex)).setText(R.string.hint);
        contextTex = ((TextView) contentView.findViewById(R.id.context_tex));

        popupWindowBuilder = Uiutils.setPopSetting(context, contentView,
                MeasureUtil.dip2px(context, 300),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, MissionHallBean.DataBean.ListBean item, int position, boolean isScrolling) {

        if (!StringUtils.isEmpty(item.getType())&&StringUtils.equals("1",item.getType())){
            holder.setText(R.id.title_tex,item.getMissionName());
            holder.setText(R.id.status_tex, Uiutils.setSype(
                    "日常", 0,2, "#2F9CF3"));


        }else if (!StringUtils.isEmpty(item.getType())&&StringUtils.equals("0",item.getType())){
            holder.setText(R.id.title_tex,item.getMissionName());
            holder.setText(R.id.status_tex, Uiutils.setSype(
                    "一次性", 0, 3, "#2F9CF3"));
        }else{
            holder.setText(R.id.title_tex,item.getMissionName());
        }

        holder.setText(R.id.integral_tex,"+"+item.getIntegral()+" 积分");
//        holder.setText(R.id.time_tex,"截止时间："+ StampToDate.stampToDates(Long.parseLong(item.getOverTime())*1000,3));
        holder.setText(R.id.time_tex,"截止时间："+ item.getOverTime());
        if (StringUtils.isEmpty(item.getOverTime())||StringUtils.equals("0",item.getOverTime())){
            holder.getView(R.id.time_tex).setVisibility(View.GONE);
        }else{
            holder.getView(R.id.time_tex).setVisibility(View.VISIBLE);
        }

        holder.getView(R.id.onc_tex).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                EvenBusUtils.setEvenBus(new Even(EvenBusCode.MISSION_HALL_POP,item));
                switch (item.getStatus()){
                    case "0":
                        url= Constants.GET_TASK;
//                            contextTex.setText("领任务");
                        break;
                    case "1":
                        url= Constants.REWARD;
//                            contextTex.setText("领任务");
                        break;
                    case "3":
                        url= Constants.REWARD;
//                            contextTex.setText("领任务");
                        break;
                }
                getrequest(item,item.getStatus());
            }

        });

        //0待领取1待完成2已完成3待领取
        switch (item.getStatus()){
            case "0":
                holder.getView(R.id.onc_tex).setBackground(context.getResources().getDrawable(R.drawable
                        .shape_ticket_dialog_title_bg5));
                holder.setText(R.id.onc_tex,"领任务");
                break;
            case "1":
                holder.getView(R.id.onc_tex).setBackground(context.getResources().getDrawable(R.drawable
                        .shape_ticket_dialog_title_bg_5));
                holder.setText(R.id.onc_tex,"去完成");
                break;
            case "2":
                holder.getView(R.id.onc_tex).setBackground(context.getResources().getDrawable(R.drawable
                        .shape_ticket_dialog_title_ask_bg_5));
                holder.setText(R.id.onc_tex,"已领取");
                holder.getView(R.id.onc_tex).setOnClickListener(null);
                break;
            case "3":
                holder.getView(R.id.onc_tex).setBackground(context.getResources().getDrawable(R.drawable
                        .shape_ticket_dialog_title_bg5));
                holder.setText(R.id.onc_tex,"领积分");
                break;
        }




    }

    private String url;

    private void getrequest(MissionHallBean.DataBean.ListBean item,String type) {
        Map<String,Object> map =new HashMap<>();
        map.put("mid" ,item.getId());
        map.put("token" ,Uiutils.getToken(context));

        NetUtils.post(url, map, true, context, new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object,context);
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.MISSION_REFRESH));
                EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_REFRESH_AMOUNT));
            }

            @Override
            public void onError() {
            }
        });
    }


    @Override
    public void onClick(View v) {
        mCustomPopWindow.dissmiss();
        if (context instanceof Activity)
        Uiutils.setStateColor((Activity) context);
    }
}
