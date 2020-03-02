package com.phoenix.lotterys.home.adapter;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.WalletBean;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class TransNewAdapter extends RecyclerView.Adapter<TransNewAdapter.ViewHolder> {
    List<WalletBean.DataBean> list;
    private Context context;
    private LayoutInflater inflater;
    private TransNewAdapter.OnClickListener onClickListener;


    public TransNewAdapter(List<WalletBean.DataBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);

    }

    public void setListener(TransNewAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position, WalletBean.DataBean dataBean);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.trans_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int i) {
        holder.tvName.setText(list.get(i).getTitle());
        if(!TextUtils.isEmpty(list.get(i).getBalance())){
            holder.tvBalance.setText(list.get(i).getBalance());
            holder.tvBalance.setBackgroundColor(0);
        }else {
            holder.tvBalance.setText("点击加载");
//            holder.tvBalance.getContext().getResources().getDrawable(R.drawable.lottery_bck_14);
            holder.tvBalance.setBackgroundResource(R.drawable.lottery_bck_14);
        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(onClickListener!=null)
                    onClickListener.onClickListener(holder.itemView, i, list.get(i));
            }
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_balance)
        TextView tvBalance;
        @BindView(R2.id.tv_name)
        TextView tvName;
        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
