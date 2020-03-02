package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.TicketClassBean;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/3.
 */

public class TicketClassAdapter extends RecyclerView.Adapter<TicketClassAdapter.ViewHolder> {
    private List<TicketClassBean> list;
    private Context context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;
    private final ConfigBean config;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public TicketClassAdapter(List<TicketClassBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_ticket_class, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        holder.tvTicketClassName.setText(list.get(position).getName());
//        if (list.get(position).isHave()) {
//            if (true) {
//                holder.ivDent.setImageResource(R.drawable.ba_white_50);
//            } else {
//                holder.ivDent.setImageResource(R.drawable.shape_ident_select);
//            }
//        } else {
//            holder.ivDent.setImageResource(R.drawable.shape_ident);
//        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });

            setmTheme(holder.tvTicketClassName);
            setmTheme(holder);
        if (list.get(position).isSelect()) {
           if(BuildConfig.FLAVOR.equals("c048")){
                holder.tvTicketClassName.setTextColor(context.getResources().getColor(R.color.color_FBC506));
            }else
            holder.tvTicketClassName.setTextColor(context.getResources().getColor(R.color.color_22a6ec));
        } else {
//            holder.tvTicketClassName.setTextColor(context.getResources().getColor(R.color.color_333333));
            setmTheme(holder.tvTicketClassName);
        }

        if (Uiutils.isSixBa(context)){
            if (list.get(position).isSelect()){
                holder.ivDent.setImageResource(R.drawable.ba_white_50);
                holder.tvTicketClassName.setTextColor(context.getResources().getColor(R.color.color_white));
            }else{
                holder.ivDent.setImageResource(R.drawable.shape_ident);
                holder.tvTicketClassName.setTextColor(context.getResources().getColor(R.color.black));
            }
        }else{
            if (list.get(position).isSelect()){
                holder.ivDent.setImageResource(R.drawable.shape_ident_select);
            }else{
                holder.ivDent.setImageResource(R.drawable.shape_ident);
            }


//            if (list.get(position).isHave()) {
//                holder.ivDent.setImageResource(R.drawable.shape_ident_select);
//                } else {
//            holder.ivDent.setImageResource(R.drawable.shape_ident);
//        }

        }

    }

    private void setmTheme(TextView tvTicketClassName) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                tvTicketClassName.setTextColor(context.getResources().getColor(R.color.font));

            } else {
                tvTicketClassName.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            tvTicketClassName.setTextColor(context.getResources().getColor(R.color.black));
        }
    }


    //黑色模板
    private void setmTheme(ViewHolder holder) {

        if (Uiutils.isSixBa(context)){
            holder.llMain.setBackgroundColor(0);
        }else if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                holder.llMain.setBackgroundColor(context.getResources().getColor(R.color.black));
            } else {
//                holder.llMain.setBackgroundColor(context.getResources().getColor(R.color.font));
            }
        } else {
//            holder.llMain.setBackgroundColor(context.getResources().getColor(R.color.font));
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_ticket_class_name)
        TextView tvTicketClassName;
        @BindView(R2.id.iv_ident)
        ImageView ivDent;
        @BindView(R2.id.ll_main)
        LinearLayout llMain;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
