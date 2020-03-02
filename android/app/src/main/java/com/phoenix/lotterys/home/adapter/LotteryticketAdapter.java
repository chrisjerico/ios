package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.GameTypeBean;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class LotteryticketAdapter extends RecyclerView.Adapter<LotteryticketAdapter.ViewHolder> {
    List<GameTypeBean.ListBean> list;
    private Context context;
    private LayoutInflater inflater;
    private LotteryticketAdapter.OnClickListener onClickListener;

    public LotteryticketAdapter(List<GameTypeBean.ListBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(LotteryticketAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_home_lottery_ticket, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        ImageLoadUtil.ImageLoad(context, list.get(position).getIcon(), holder.ivTicketIcon);
        holder.tvName.setText(list.get(position).getTitle());
        if (list.get(position).getTipFlag() != null) {
            holder.iv_hot.setVisibility(list.get(position).getTipFlag().equals("1") ? View.VISIBLE : View.GONE);
        }
//        if(list.get(position).getSubType()!=null&&list.get(position).getSubType().size()>0){
//            TwoLevelAdapter twolevel = new TwoLevelAdapter(list.get(position).getSubType(), context);
//            holder.rvTwolevel.setAdapter(twolevel);
//            holder.rvTwolevel.setLayoutManager(new GridLayoutManager(context, 2));
//        }
//        TwoLevelAdapter
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
        @BindView(R2.id.iv_ticket_icon)
        ImageView ivTicketIcon;
        @BindView(R2.id.iv_hot)
        ImageView iv_hot;
        @BindView(R2.id.tv_name)
        TextView tvName;
//        @BindView(R2.id.rv_twolevel)
//        RecyclerView rvTwolevel;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
