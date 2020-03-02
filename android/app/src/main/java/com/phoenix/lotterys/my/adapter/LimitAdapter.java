package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;

import com.phoenix.lotterys.my.bean.TransferinterestBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class LimitAdapter extends RecyclerView.Adapter<LimitAdapter.ViewHolder> {
    List<TransferinterestBean.DataBean.ListBean> list;
    private Context context;
    private LayoutInflater inflater;
    private LimitAdapter.OnClickListener onClickListener;

    public LimitAdapter(List<TransferinterestBean.DataBean.ListBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public LimitAdapter(Context context) {
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(LimitAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.limit_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
//        Uiutils.setBaColor(context,card, false, null);

        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (configBean != null && configBean.getData() != null && configBean.getData().getMobileTemplateCategory() != null) {
            if (configBean.getData().getMobileTemplateCategory().equals("5")) {
                holder.tvPattern.setTextColor(context.getResources().getColor(R.color.white));
                holder.tvMoney.setTextColor(context.getResources().getColor(R.color.white));
                holder.tvData.setTextColor(context.getResources().getColor(R.color.white));
                holder.tvStatus.setTextColor(context.getResources().getColor(R.color.white));
                Uiutils.setBaColor(context,holder.llMain);
            }
        }
        String text = null;
        String[] spString = list.get(position).getActionTime().split("\\s+");
        for (int i = 0; i < spString.length; i++) {
            if (i == 0) {
                text = spString[i];
            } else {
                text += "\n" + spString[i];
            }
        }
        holder.tvStatus.setText(text);

        if (list.get(position).getIsAuto().equals("1"))
            holder.tvPattern.setText("自动");
        else
            holder.tvPattern.setText("手动");
        holder.tvMoney.setText(list.get(position).getAmount());
        holder.tvData.setText(list.get(position).getGameName());
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });
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
        @BindView(R2.id.tv_pattern)
        TextView tvPattern;
        @BindView(R2.id.ll_main)
        LinearLayout llMain;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
