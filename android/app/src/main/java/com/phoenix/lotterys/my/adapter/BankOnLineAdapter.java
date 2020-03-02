package com.phoenix.lotterys.my.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.PaymentBean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/21
 */
public class BankOnLineAdapter extends RecyclerView.Adapter{
    private List<PaymentBean.ChannelBean.ParaBean.BankListBean> mData;
    Context context;

    public void setData(List<PaymentBean.ChannelBean.ParaBean.BankListBean> data, Context context) {
        mData = data;
        this.context = context;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.bank_on_line_item,null));
    }

    @SuppressLint("ResourceAsColor")
    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        ViewHolder viewHolder = (ViewHolder) holder;
//        Log.e("mData",""+mData);
        viewHolder.tv_content.setText(""+mData.get(position).getName()+"");
        if(mData.get(position).isSelect())
            viewHolder.tv_content.setTextColor(context.getResources().getColor(R.color.fount1));
        else
            viewHolder.tv_content.setTextColor(context.getResources().getColor(R.color.textColor_center_title));

        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        return mData == null ? 0:mData.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder{
        public TextView tv_content;
        public ViewHolder(View itemView) {
            super(itemView);
            tv_content = (TextView) itemView.findViewById(R.id.tv_content);
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
