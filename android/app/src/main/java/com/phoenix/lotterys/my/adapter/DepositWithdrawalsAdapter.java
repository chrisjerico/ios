package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.DepositBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class DepositWithdrawalsAdapter extends RecyclerView.Adapter<DepositWithdrawalsAdapter.ViewHolder> {
    List<DepositBean.DataBean.ListBean> list;
    private Context context;
    private LayoutInflater inflater;
    private DepositWithdrawalsAdapter.OnClickListener onClickListener;
    String title;
    private final ConfigBean config;

    public DepositWithdrawalsAdapter(List<DepositBean.DataBean.ListBean> list, Context context, String title) {
        this.list = list;
        this.title = title;
        this.context = context;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setListener(DepositWithdrawalsAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.depositwithdraw_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        String text = null;
        //存款记录、取款记录共用一个frament
        holder.tvMoney.setText(list.get(position).getAmount());
        holder.tvStatus.setText(list.get(position).getStatus());
        if (!TextUtils.isEmpty(title) && title.equals("存款记录")) {//存款记录
            holder.tvType.setText(TextUtils.isEmpty(list.get(position).getCategory()) ? "--" : list.get(position).getCategory());
            holder.rlType.setVisibility(View.VISIBLE);
            String[] spString = list.get(position).getArriveTime().split("\\s+");
            for (int i = 0; i < spString.length; i++) {
                if (i == 0) {
                    text = spString[i];
                } else {
                    text += "\n" + spString[i];
                }
            }
            holder.tvData.setText(text);
        } else if (!TextUtils.isEmpty(title) && title.equals("取款记录")) {
            holder.tvType.setText("");
            holder.rlType.setVisibility(View.GONE);

            String[] spString = list.get(position).getApplyTime().split("\\s+");
            for (int i = 0; i < spString.length; i++) {
                if (i == 0) {
                    text = spString[i];
                } else {
                    text += "\n" + spString[i];
                }
            }
            holder.tvData.setText(text);
        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });


        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(context, holder.llMain);
                holder.tvData.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvMoney.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvStatus.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvType.setTextColor(context.getResources().getColor(R.color.font));
            }else {

//                holder.llMain.setBackgroundColor(context.getResources().getColor(R.color.white));
                holder.tvData.setTextColor(context.getResources().getColor(R.color.color_848484));
                holder.tvMoney.setTextColor(context.getResources().getColor(R.color.color_848484));
                holder.tvStatus.setTextColor(context.getResources().getColor(R.color.color_848484));
                holder.tvType.setTextColor(context.getResources().getColor(R.color.color_848484));
            }
        }else {
//            holder.llMain.setBackgroundColor(context.getResources().getColor(R.color.white));
            holder.tvData.setTextColor(context.getResources().getColor(R.color.color_848484));
            holder.tvMoney.setTextColor(context.getResources().getColor(R.color.color_848484));
            holder.tvStatus.setTextColor(context.getResources().getColor(R.color.color_848484));
            holder.tvType.setTextColor(context.getResources().getColor(R.color.color_848484));
        }

    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {

        @BindView(R2.id.tv_data)
        TextView tvData;
        @BindView(R2.id.tv_money)
        TextView tvMoney;
        @BindView(R2.id.tv_status)
        TextView tvStatus;
        @BindView(R2.id.tv_type)
        TextView tvType;
        @BindView(R2.id.rl_type)
        RelativeLayout rlType;
        @BindView(R2.id.ll_main)
        LinearLayout llMain;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
