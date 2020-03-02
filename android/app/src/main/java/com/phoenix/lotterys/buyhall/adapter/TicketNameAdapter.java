package com.phoenix.lotterys.buyhall.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.Uiutils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/3.
 */

public class TicketNameAdapter extends RecyclerView.Adapter<TicketNameAdapter.ViewHolder> {
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list;
    Context context;
    LayoutInflater inflater;
    String title;
    String id, typeGame, leftName, palyIng;
    private OnClickListener onClickListener;
    private final ConfigBean config;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }


    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public TicketNameAdapter(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list, String title, String id, String typeGame, Context context, String leftName, String palyIng) {
        this.list = list;
        this.context = context;
        this.title = title;
        this.id = id;
        this.leftName = leftName;
        this.typeGame = typeGame;
        this.palyIng = palyIng;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }


    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_ticket_name, viewGroup, false);
        return new ViewHolder(view);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        String name = list.get(position).getName();
//        holder.tvName.setText(list.get(position).getOdds());
        holder.tvTitle.setText(name);
        String odds = list.get(position).getOdds();
        String s = ShowItem.subZeroAndDot(odds);
        if ((title != null && !title.equals("前二直选") && !title.equals("前三直选"))) {
            holder.tvName.setText(s);
//        }else if(typeGame.equals("gdkl10") &&ShowItem.ItemOdds(title)){
        } else {
            holder.tvName.setVisibility(View.GONE);
        }
        if (ShowItem.ItemOdds(title, typeGame)) {
            holder.tvName.setVisibility(View.GONE);
        }
        if (typeGame != null && (typeGame.equals("pk10") || typeGame.equals("xyft"))) {
            if (ShowItem.isNumeric(name) && title != null && !title.equals("冠亚军组合")) {
                holder.tvTitle.setBackgroundResource(NumUtil.RanColor(Integer.parseInt(list.get(position).getName())));
                holder.tvTitle.setTextColor(Color.WHITE);
            } else {
//                holder.tvTitle.setBackgroundResource(R.color.white);
//                holder.tvTitle.setTextColor(Color.BLACK);
                setTextTheme(holder.tvTitle);
            }
        } else if (typeGame != null && typeGame.equals("pcdd")) {  //三种颜色的球
            if (ShowItem.isNumeric(name)) {
                holder.tvTitle.setBackgroundResource(NumUtil.circleColor(Integer.parseInt(list.get(position).getName())));
                holder.tvTitle.setTextColor(Color.WHITE);
            } else {
//                holder.tvTitle.setBackgroundResource(R.color.white);
//                holder.tvTitle.setTextColor(Color.BLACK);
                setTextTheme(holder.tvTitle);
            }
        } else {
            if (ShowItem.isNumeric(name)) {   //球类圆形背景
//                holder.tvTitle.setBackgroundResource(R.drawable.circle_fill);
//                holder.tvTitle.setTextColor(Color.WHITE);
                setTextCircle(holder.tvTitle);
            } else {
//                holder.tvTitle.setBackgroundResource(R.color.white);
//                holder.tvTitle.setTextColor(Color.BLACK);
                setTextTheme(holder.tvTitle);
            }

        }

        setmTheme(holder,position);
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });

        if (palyIng != null)
            list.get(position).setTitleRight(palyIng);
        else
            list.get(position).setTitleRight("");


                if (Uiutils.isSite("c169")||Uiutils.isSite("a002")){
        holder.tvTitle.setTextSize(TypedValue.COMPLEX_UNIT_SP, 17);
        holder.tvTitle.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
        }

    }

    private void setTextCircle(TextView tvTitle) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                tvTitle.setTextColor(context.getResources().getColor(R.color.black));
                tvTitle.setBackgroundResource(R.drawable.black_circle_fill);
            }else {
                tvTitle.setBackgroundResource(R.drawable.circle_fill);
                tvTitle.setTextColor(Color.WHITE);
            }
        }else {
            tvTitle.setBackgroundResource(R.drawable.circle_fill);
            tvTitle.setTextColor(Color.WHITE);
        }
    }


    private void setTextTheme(TextView tvTitle) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                tvTitle.setTextColor(context.getResources().getColor(R.color.font));
            }else {
//                tvTitle.setBackgroundResource(R.color.white);
                tvTitle.setTextColor(Color.BLACK);
            }
        }else {
//            tvTitle.setBackgroundResource(R.color.white);
            tvTitle.setTextColor(Color.BLACK);
        }
    }

    private void setmTheme(ViewHolder holder, int position) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvName.setTextColor(context.getResources().getColor(R.color.font));
                if (list.get(position).isSelect())
                    holder.ll_main.setBackgroundResource(R.drawable.select_num_black);
                else
                    holder.ll_main.setBackgroundColor(context.getResources().getColor(R.color.color_212121));
            } else {
                if (list.get(position).isSelect()) {
//                    if(BuildConfig.FLAVOR.equals("c194")||BuildConfig.FLAVOR.equals("c048")||BuildConfig.FLAVOR.equals("c175")||BuildConfig.FLAVOR.equals("c011")){
                        holder.ll_main.setBackgroundResource(R.drawable.select_num);
                        if(BuildConfig.FLAVOR.equals("c011")){
                            holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
                        }else {
                            holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                        }
//                    }else {
//                        holder.ll_main.setBackgroundResource(R.drawable.select_num_all);
//                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//                    }
                }else{
                    holder.ll_main.setBackgroundResource(0);
                    if(BuildConfig.FLAVOR.equals("c194")){
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                    }else {
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
                    }
                }
            }
        } else {
            if (list.get(position).isSelect()) {
//                if(BuildConfig.FLAVOR.equals("c194")||BuildConfig.FLAVOR.equals("c048")||BuildConfig.FLAVOR.equals("c175")||BuildConfig.FLAVOR.equals("c011")){
                    holder.ll_main.setBackgroundResource(R.drawable.select_num);
                    if(BuildConfig.FLAVOR.equals("c011")){
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
                    }else {
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                    }
//                }else {
//                    holder.ll_main.setBackgroundResource(R.drawable.select_num_all);
//                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//                }
            }else{
                holder.ll_main.setBackgroundResource(0);
                if(BuildConfig.FLAVOR.equals("c194")){
                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                }else {
                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
                }
            }
        }


//        if(Uiutils.isSixBa(context)){
//        if (list.get(position).isSelect()) {
//            holder.ll_main.setBackgroundResource(R.drawable.select_num_all1);
//            holder.tvTitle.setTextColor(context.getResources().getColor(R.color.white));
//            holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
//        }else{
//            holder.ll_main.setBackgroundResource(0);
//            holder.tvTitle.setTextColor(context.getResources().getColor(R.color.color_333333));
//            holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//        }
//        }

    }



    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.ll_main)
        RelativeLayout ll_main;
        @BindView(R2.id.ll_main1)
        LinearLayout ll_main1;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }


}
