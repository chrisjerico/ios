package com.phoenix.lotterys.buyhall.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/3.
 */
//广东11选5
public class GdAdapter extends RecyclerView.Adapter<GdAdapter.ViewHolder> {
    //    List<TicketNameBean> list;
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list;
    Context context;
    LayoutInflater inflater;
    String title;
    String id,typeGame;
    private OnClickListener onClickListener;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }


    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public GdAdapter(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list, String title, String id, String typeGame, Context context) {
        this.list = list;
        this.context = context;
        this.title = title;
        this.id = id;
        this.typeGame = typeGame;
        inflater = LayoutInflater.from(context);
    }


    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_ticket_name, viewGroup, false);
        return new ViewHolder(view);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        holder.tvName.setText(list.get(position).getOdds());
            holder.tvTitle.setText(list.get(position).getName());
        if (list.get(position).isSelect())
            holder.ll_main.setBackgroundResource(R.drawable.shape_ticket_name_select);
        else
            holder.ll_main.setBackgroundResource(R.color.color_white);
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
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
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.ll_main)
        LinearLayout ll_main;
        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
