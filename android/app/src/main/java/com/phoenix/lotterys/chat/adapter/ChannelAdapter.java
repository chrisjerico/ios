package com.phoenix.lotterys.chat.adapter;

import android.content.Context;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.chat.ChatActivity;
import com.phoenix.lotterys.chat.bean.ChannelBean;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class ChannelAdapter extends RecyclerView.Adapter<ChannelAdapter.ViewHolder> {
    List<ChannelBean> list;
    private Context context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public ChannelAdapter(List<ChannelBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.channel_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        holder.tvTitle.setText(list.get(position).getTitle());
        if (list.get(position).getData() != null ) {
            if (list.get(position).getOpen()) {
                holder.rvPacket.setVisibility(View.VISIBLE);
                holder.iv_next.setBackgroundResource(R.mipmap.up);
            } else {
                holder.rvPacket.setVisibility(View.GONE);
                holder.iv_next.setBackgroundResource(R.mipmap.down);
            }

            RedpacketAdapter redpacketadapter = new RedpacketAdapter(list.get(position).getData(), context);
            holder.rvPacket.setAdapter(redpacketadapter);
            holder.rvPacket.setLayoutManager(new LinearLayoutManager(context));
            redpacketadapter.setListener(new RedpacketAdapter.OnClickListener() {
                @Override
                public void onClickListener(View view, int position) {
                    Intent intent = new Intent(context, ChatActivity.class);
                    intent.putExtra("id", "");
                    context.startActivity(intent);

                }
            });
        }
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
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.iv_next)
        ImageView iv_next;
        @BindView(R2.id.rv_packet)
        RecyclerView rvPacket;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
