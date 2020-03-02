package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.BankCardInfo;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/21
 */
public class BankCardAdapter extends RecyclerView.Adapter {
    private List<BankCardInfo.DataBean> mData;
    Context context;
    private final ConfigBean config;

    public BankCardAdapter(Context context) {
        this.context = context;
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setData(List<BankCardInfo.DataBean> data) {
        mData = data;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.bank_item, null));
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        ViewHolder viewHolder = (ViewHolder) holder;
        viewHolder.tv_bank_name.setText(mData.get(position).getBankName());
        viewHolder.tv_name.setText("持卡姓名 : " + mData.get(position).getOwnerName());
        viewHolder.tv_address.setText("开卡地址 : " + mData.get(position).getBankAddr());
        viewHolder.tv_card_num.setText("银行账户 : " + mData.get(position).getBankCard());
        if (onItemClickListener != null) {
            viewHolder.iv_change.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }

        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(context, viewHolder.ll_main);
//                Uiutils.setBaColor(context, viewHolder.card_main);
                Uiutils.setBaColor(context, viewHolder.card_main, false, null);
                viewHolder.tv_bank_name.setTextColor(context.getResources().getColor(R.color.white));
                viewHolder.tv_name.setTextColor(context.getResources().getColor(R.color.white));
                viewHolder.tv_address.setTextColor(context.getResources().getColor(R.color.white));
                viewHolder.tv_card_num.setTextColor(context.getResources().getColor(R.color.white));
                viewHolder.iv_change.setColorFilter(Color.WHITE);
            }
        }
    }

    @Override
    public int getItemCount() {
        return mData == null ? 0 : mData.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public TextView tv_bank_name;
        public ImageView iv_change;
        public TextView tv_name;
        public TextView tv_card_num;
        public TextView tv_address;
        public LinearLayout ll_main;
        public CardView card_main;

        public ViewHolder(View itemView) {
            super(itemView);
            tv_bank_name = (TextView) itemView.findViewById(R.id.tv_bank_name);
            iv_change = (ImageView) itemView.findViewById(R.id.iv_change);
            tv_name = (TextView) itemView.findViewById(R.id.tv_name);
            tv_card_num = (TextView) itemView.findViewById(R.id.tv_card_num);
            tv_address = (TextView) itemView.findViewById(R.id.tv_address);
            ll_main = (LinearLayout) itemView.findViewById(R.id.ll_main);
            card_main = (CardView) itemView.findViewById(R.id.card_main);
        }
    }

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    private BankCardAdapter.OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(BankCardAdapter.OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }
}
