package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.RanklistBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class WinUserAdapter extends RecyclerView.Adapter<WinUserAdapter.ViewHolder> {
    private List<RanklistBean.DataBean.ListBean> list;
    private Context context;
    private LayoutInflater inflater;
    private final ConfigBean config;

    public WinUserAdapter( Context context) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }
    public void setWinUserA(List<RanklistBean.DataBean.ListBean> list) {
        this.list = list;
    }
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_home_winning, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
//        holder.ivRank.setImageResource(position==0?R.drawable.win_first:position==1?R.drawable.win_second:position==2?R.drawable.win_third:0);
        holder.ivRank.setBackgroundResource(list.get(position % list.size()).getImg());
        holder.ivRank.setText(list.get(position % list.size()).getNum());
        holder.tvName.setText(list.get(position % list.size()).getUsername());
        holder.tvAmount.setText(list.get(position % list.size()).getCoin());
        holder.tvTicketName.setText(list.get(position % list.size()).getType());
        setTextTheme(holder.tvTicketName);
    }

    private void setTextTheme(TextView tv1) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                tv1.setTextColor(context.getResources().getColor(R.color.font));
            }else {
                tv1.setTextColor(context.getResources().getColor(R.color.black));
            }
        }else {
            tv1.setTextColor(context.getResources().getColor(R.color.black));
        }
    }

    @Override
    public int getItemCount() {
        return (list == null||list.size()==0) ? 0 :Integer.MAX_VALUE;
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.bt_rank)
        Button ivRank;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.tv_ticket_name)
        TextView tvTicketName;
        @BindView(R2.id.tv_amount)
        TextView tvAmount;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
