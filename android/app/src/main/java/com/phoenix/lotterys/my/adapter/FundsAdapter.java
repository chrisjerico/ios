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
import com.phoenix.lotterys.my.bean.FundsBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class FundsAdapter extends RecyclerView.Adapter<FundsAdapter.ViewHolder> {
    List<FundsBean.DataBean.ListBean> list;
    private Context context;
    private LayoutInflater inflater;
    private FundsAdapter.OnClickListener onClickListener;
    private final ConfigBean config;
    public FundsAdapter(List<FundsBean.DataBean.ListBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setListener(FundsAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.funds_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        String text = null;
        String[] spString = list.get(position).getTime().split("\\s+");
        for (int i = 0; i < spString.length; i++) {
            if (i == 0){
                text = spString[i];
            }else {
                text +="\n"+ spString[i] ;
            }
        }
        holder.tvData.setText(text);
        holder.tvMoney.setText(list.get(position).getChangeMoney());
        holder.tvType.setText(list.get(position).getCategory());
        holder.tvBalance.setText(list.get(position).getBalance());
//        holder.itemView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                if (onClickListener != null)
//                    onClickListener.onClickListener(holder.itemView, position);
//            }
//        });


        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(context, holder.llMain);
                holder.tvData.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvMoney.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvType.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvBalance.setTextColor(context.getResources().getColor(R.color.font));
            }else {

//                holder.llMain.setBackgroundColor(context.getResources().getColor(R.color.white));
                holder.tvData.setTextColor(context.getResources().getColor(R.color.color_848484));
                holder.tvMoney.setTextColor(context.getResources().getColor(R.color.color_848484));
                holder.tvType.setTextColor(context.getResources().getColor(R.color.color_848484));
                holder.tvBalance.setTextColor(context.getResources().getColor(R.color.color_848484));
            }
        }else {
//            holder.llMain.setBackgroundColor(context.getResources().getColor(R.color.white));
            holder.tvData.setTextColor(context.getResources().getColor(R.color.color_848484));
            holder.tvMoney.setTextColor(context.getResources().getColor(R.color.color_848484));
            holder.tvType.setTextColor(context.getResources().getColor(R.color.color_848484));
            holder.tvBalance.setTextColor(context.getResources().getColor(R.color.color_848484));
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
        @BindView(R2.id.tv_type)
        TextView tvType;
        @BindView(R2.id.tv_balance)
        TextView tvBalance;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
