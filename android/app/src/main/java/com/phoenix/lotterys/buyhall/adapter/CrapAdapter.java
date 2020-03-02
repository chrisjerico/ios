package com.phoenix.lotterys.buyhall.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Typeface;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;
import com.phoenix.lotterys.main.bean.ConfigBean;
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

public class CrapAdapter extends RecyclerView.Adapter<CrapAdapter.ViewHolder> {

    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list;
    Context context;
    LayoutInflater inflater;
    String title;
    String id,typeGame,palyIng;
    int t = 0;
    private OnClickListener onClickListener;
    private final ConfigBean config;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public CrapAdapter(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list, String title, String id, String typeGame, Context context, String palyIng) {
        this.list = list;
        this.context = context;
        this.title = title;
        this.id = id;
        this.typeGame = typeGame;
        this.palyIng = palyIng;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }


    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_crap, viewGroup, false);
        return new ViewHolder(view);
    }

    //骰宝
    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        String odds = list.get(position).getOdds();
        String s = ShowItem.subZeroAndDot(odds);
        holder.tvName.setText(s);

        if (title.equals("围骰") || title.equals("长牌") || title.equals("短牌")) {
            //notfi导致点击重复添加控件先清除掉所有控件在添加
            if (t == 1) {
                holder.ll_main.removeAllViews();
                t = 0;
            }
            holder.tvTitle.setVisibility(View.GONE);
            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            lparams.setMargins(10, 0, 0, 0);
            String[] temp1 = list.get(position).getName().split("_");
            for (int i = 0; i < temp1.length; i++) {
                TextView tv1 = new TextView(context);
                    tv1.setBackgroundResource(SelectCrap(temp1[i], holder, position));
                    tv1.setLayoutParams(lparams);
                setTextTheme(tv1);
                    holder.ll_main.addView(tv1, i);
            }
        } else if (title.equals("三军")) {
            holder.tvTitle.setBackgroundResource(SelectCrap(list.get(position).getName(), holder, position));
        } else if (title.equals("点数")) {
            holder.tvTitle.setText(list.get(position).getName());
        }else if(title.equals("大小单双")){
            if (!ShowItem.isNumeric(list.get(position).getName())) {
                holder.tvTitle.setText(list.get(position).getName());
            }
        }else if(title.equals("全骰")){
            holder.tvTitle.setText(title);
        }
        setmTheme(holder, position);
//        if (list.get(position).isSelect())
//            holder.itemView.setBackgroundResource(R.drawable.shape_ticket_name_select);
//        else
//            holder.itemView.setBackgroundResource(R.color.color_white);

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (onClickListener != null)
                    t = 1;
                onClickListener.onClickListener(holder.itemView, position);
            }
        });
        if(palyIng!=null)
        list.get(position).setTitleRight(palyIng);
        else
            list.get(position).setTitleRight("");


        if (Uiutils.isSite("c169")||Uiutils.isSite("a002")){
            holder.tvTitle.setTextSize(TypedValue.COMPLEX_UNIT_SP, 17);
            holder.tvTitle.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
        }

    }
    private void setTextTheme(TextView tv1) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                tv1.setTextColor(context.getResources().getColor(R.color.font));
            }else {
                tv1.setTextColor(context.getResources().getColor(R.color.black));
            }
        }else {
            tv1.setTextColor(context.getResources().getColor(R.color.black));
        }



//        if(BuildConfig.FLAVOR.equals("085")){
//        if (list.get(position).isSelect()) {
//            holder.itemView.setBackgroundResource(R.drawable.select_num_all1);
//            holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
//        }else{
//            holder.itemView.setBackgroundResource(0);
//            holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//        }
//        }
    }

    private void setmTheme(ViewHolder holder, int position) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvName.setTextColor(context.getResources().getColor(R.color.font));
                if (list.get(position).isSelect())
                    holder.itemView.setBackgroundResource(R.drawable.select_num_black);
                else
//                    Uiutils.setBaColor(context, holder.itemView);
                holder.itemView.setBackgroundColor(context.getResources().getColor(R.color.color_212121));
            } else {
                if (list.get(position).isSelect()) {
//                    if(BuildConfig.FLAVOR.equals("c194")||BuildConfig.FLAVOR.equals("c048")||BuildConfig.FLAVOR.equals("c175")||BuildConfig.FLAVOR.equals("c011")){
                        holder.itemView.setBackgroundResource(R.drawable.select_num);
                        if(BuildConfig.FLAVOR.equals("c011")){
                            holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
                        }else {
                            holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                        }

//                    }else {
//                        holder.itemView.setBackgroundResource(R.drawable.select_num_all);
//                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//                    }

                }else{
                    holder.itemView.setBackgroundResource(0);
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
                    holder.itemView.setBackgroundResource(R.drawable.select_num);
                    if(BuildConfig.FLAVOR.equals("c011")){
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
                    }else {
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                    }
//                }else {
//                    holder.itemView.setBackgroundResource(R.drawable.select_num_all);
//                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//                }

            }else{
                holder.itemView.setBackgroundResource(0);
                if(BuildConfig.FLAVOR.equals("c194")){
                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                }else {
                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
                }
            }

        }




//        if(Uiutils.isSixBa(context)){
//        if (list.get(position).isSelect()) {
//            holder.itemView.setBackgroundResource(R.drawable.select_num_all1);
//            holder.tvTitle.setTextColor(context.getResources().getColor(R.color.white));
//            holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
//        }else{
//            holder.itemView.setBackgroundResource(0);
//            holder.tvTitle.setTextColor(context.getResources().getColor(R.color.color_333333));
//            holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//        }
//        }

    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.ll_main)
        LinearLayout ll_main;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    private int SelectCrap(String s, ViewHolder holder, int pos) {
        int img = 0;
        switch (s) {
            case "1":
                img = R.mipmap.sz_1;
                break;
            case "2":
                img = R.mipmap.sz_2;
                break;
            case "3":
                img = R.mipmap.sz_3;
                break;
            case "4":
                img = R.mipmap.sz_4;
                break;
            case "5":
                img = R.mipmap.sz_5;
                break;
            case "6":
                img = R.mipmap.sz_6;
                break;
            default:
                holder.tvTitle.setText(list.get(pos).getName());
                break;
        }
        return img;
    }


}
