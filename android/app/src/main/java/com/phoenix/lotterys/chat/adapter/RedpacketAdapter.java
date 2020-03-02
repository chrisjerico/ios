package com.phoenix.lotterys.chat.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.chat.bean.ChannelBean;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Greated by Luke
 * on 2019/7/11
 */

public class RedpacketAdapter extends RecyclerView.Adapter<RedpacketAdapter.ViewHolder> {
    List<ChannelBean.DataBean> list;
    private Context context;
    private LayoutInflater inflater;
    private RedpacketAdapter.OnClickListener onClickListener;

    public RedpacketAdapter(List<ChannelBean.DataBean> data, Context context) {
                this.list = data;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(RedpacketAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }
    public interface OnClickListener {
        void onClickListener(View view, int position);
    }
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.redpacket_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
//        holder.ivImg.setImageResource(list.get(position).getPic());

        holder.tvTitle.setText(list.get(position).getContent());
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
        return list == null ? 0:list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.iv_img)
        ImageView ivImg;
        @BindView(R2.id.tv_title)
        TextView tvTitle;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
