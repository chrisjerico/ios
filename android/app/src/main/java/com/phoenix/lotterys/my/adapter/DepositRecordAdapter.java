package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.ProfitReportBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class DepositRecordAdapter extends RecyclerView.Adapter<DepositRecordAdapter.ViewHolder> {
    List<ProfitReportBean.DataBean.ListBean> list;
    private Context context;
    private LayoutInflater inflater;
    ConfigBean config;
    private DepositRecordAdapter.OnClickListener onClickListener;

    public DepositRecordAdapter(List<ProfitReportBean.DataBean.ListBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }
    public DepositRecordAdapter( Context context) {
        this.context = context;
        inflater = LayoutInflater.from(context);
    }
    public void setListener(DepositRecordAdapter.OnClickListener onClickListener) {
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
        String[] spString = list.get(position).getSettleTime().split("\\s+");
        for (int i = 0; i < spString.length; i++) {
            if (i == 0){
                text = spString[i];
            }else {
                text +="\n"+ spString[i] ;
            }
        }

        holder.tvData.setText(text);
        holder.tvMoney.setText(list.get(position).getProfitAmount());
        holder.tvStatus.setText(list.get(position).getSettleBalance());
//        holder.itemView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                if (onClickListener != null)
//                    onClickListener.onClickListener(holder.itemView, position);
//            }
//        });

        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                holder.tvData.setTextColor(context.getResources().getColor(R.color.white));
                holder.tvMoney.setTextColor(context.getResources().getColor(R.color.white));
                holder.tvStatus.setTextColor(context.getResources().getColor(R.color.white));
            }
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {

        @BindView(R2.id.tv_data)
        TextView tvData;
        @BindView(R2.id.tv_money)
        TextView tvMoney;
        @BindView(R2.id.tv_status)
        TextView tvStatus;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
