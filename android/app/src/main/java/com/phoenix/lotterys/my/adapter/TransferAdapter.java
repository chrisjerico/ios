package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.WalletBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/21
 */
public class TransferAdapter extends RecyclerView.Adapter{
    List<WalletBean.DataBean> mData;
    Context context;
    private final ConfigBean config;

    public void setData(List<WalletBean.DataBean> data) {
        mData = data;
    }
    public  TransferAdapter(Context context){
        this.context= context;
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);

    }
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.gamename_item,null));
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        ViewHolder viewHolder = (ViewHolder) holder;
        viewHolder.mTextView.setText(mData.get(position).getTitle());
        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }

        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                viewHolder.mTextView.setTextColor(context.getResources().getColor(R.color.white));
                viewHolder.rlMain.setBackgroundColor(context.getResources().getColor(R.color.black));
            }else {
                viewHolder.mTextView.setTextColor(context.getResources().getColor(R.color.black));
                viewHolder.rlMain.setBackgroundColor(context.getResources().getColor(R.color.white));
            }
        }else {
            viewHolder.mTextView.setTextColor(context.getResources().getColor(R.color.black));
            viewHolder.rlMain.setBackgroundColor(context.getResources().getColor(R.color.white));
        }

    }

    @Override
    public int getItemCount() {
        return mData == null ? 0:mData.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder{
        public TextView mTextView;
        public RelativeLayout rlMain;
        public ViewHolder(View itemView) {
            super(itemView);
            mTextView = (TextView) itemView.findViewById(R.id.name);
            rlMain = (RelativeLayout) itemView.findViewById(R.id.rl_main);
        }
    }

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    private MyitemAdapter.OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(MyitemAdapter.OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }
}
