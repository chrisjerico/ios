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
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 *
 */
//六合彩的右侧标题
public class TitleAdapter extends RecyclerView.Adapter<TitleAdapter.ViewHolder> {
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> list;
    Context context;
    LayoutInflater inflater;
    String title;
    private OnClickListener onClickListener;
    private final ConfigBean config;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }


    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public TitleAdapter(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> list, String title, String id, Context context) {
        this.list = list;
        this.context = context;
        this.title = title;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_title, viewGroup, false);
        return new ViewHolder(view);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {

        holder.rl_main.setVisibility(View.GONE);
        holder.tvTitle.setVisibility(View.GONE);

//        if(title.equals("特码")&&(position==2||position==0)){
//            holder.rl_main.setVisibility(View.VISIBLE);
//            holder.tvTitle.setVisibility(View.VISIBLE);
//        }else
//            if((title.equals("连码"))){
//            holder.rl_main.setVisibility(View.VISIBLE);
//            holder.tvTitle.setVisibility(View.VISIBLE);
//        }else
//         if(title.equals("连肖")||title.equals("连尾")){
//            holder.rl_main.setVisibility(View.VISIBLE);
//            holder.tvTitle.setVisibility(View.VISIBLE);
//        }else
//            if(title.equals("正特")&&(position==2||position==0||position==4||position==6||position==8||position==10||position==12)){
//            holder.rl_main.setVisibility(View.VISIBLE);
//            holder.tvTitle.setVisibility(View.VISIBLE);
//        }else if(title.equals("直选")&&(position==0||position==1)){
//            holder.rl_main.setVisibility(View.VISIBLE);
//            holder.tvTitle.setVisibility(View.VISIBLE);
//        }

        if (title.equals("特码") && (list.get(position).getAlias().equals("特码A") || list.get(position).getAlias().equals("特码B"))) {
            holder.rl_main.setVisibility(View.VISIBLE);
            holder.tvTitle.setVisibility(View.VISIBLE);
        } else if (title.equals("连码")) {
            holder.rl_main.setVisibility(View.VISIBLE);
            holder.tvTitle.setVisibility(View.VISIBLE);
        } else if (title.equals("连肖") || title.equals("连尾")) {
            holder.rl_main.setVisibility(View.VISIBLE);
            holder.tvTitle.setVisibility(View.VISIBLE);
        } else if (title.equals("正特") && (list.get(position).getAlias().equals("正1特") || list.get(position).getAlias().equals("正2特") || list.get(position).getAlias().equals("正3特") || list.get(position).getAlias().equals("正4特")
                || list.get(position).getAlias().equals("正5特") || list.get(position).getAlias().equals("正6特"))) {
            holder.rl_main.setVisibility(View.VISIBLE);
            holder.tvTitle.setVisibility(View.VISIBLE);
        } else if (title.equals("直选") && (position == 0 || position == 1)) {
            holder.rl_main.setVisibility(View.VISIBLE);
            holder.tvTitle.setVisibility(View.VISIBLE);
        }

        holder.tvTitle.setText(list.get(position).getAlias());
        setmTheme(holder.tvTitle, position);
//        if (list.get(position).isTitle())
//            holder.tvTitle.setBackgroundResource(R.color.color_e2e2e2);
//        else
//            holder.tvTitle.setBackgroundResource(R.color.color_white);

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });
    }

    private void setmTheme(TextView tvTitle, int position) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                tvTitle.setTextColor(context.getResources().getColor(R.color.white));
                if (list.get(position).isTitle())
                    Uiutils.setBaColor(context, tvTitle, false, null);
                else
                    Uiutils.setBaColor(context, tvTitle);
            } else {
//                tvTicketClassName.setTextColor(context.getResources().getColor(R.color.black));
                if (list.get(position).isTitle()) {
                    if (Uiutils.isSixBa(context)){
                        tvTitle.setBackgroundResource(0);
                        tvTitle.setTextColor(context.getResources().getColor(R.color.color_white));
                    }else {
                        tvTitle.setBackgroundResource(R.color.color_e4D2e2e2);
                        tvTitle.setTextColor(context.getResources().getColor(R.color.colorAccent));
                    }
                }else {
                    if (Uiutils.isSixBa(context)){
                        tvTitle.setBackgroundResource(0);
                        tvTitle.setTextColor(context.getResources().getColor(R.color.black));
                    }else{
                        tvTitle.setBackgroundResource(R.color.color_e1A2e2e2);
                        tvTitle.setTextColor(context.getResources().getColor(R.color.black));
                    }

                }
            }
        } else {
//            tvTicketClassName.setTextColor(context.getResources().getColor(R.color.black));
            if (list.get(position).isTitle()) {
                tvTitle.setBackgroundResource(R.color.color_e4D2e2e2);
                tvTitle.setTextColor(context.getResources().getColor(R.color.colorAccent));
            }else{
                tvTitle.setTextColor(context.getResources().getColor(R.color.black));
                tvTitle.setBackgroundResource(R.color.color_e1A2e2e2);
            }
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.rl_main)
        LinearLayout rl_main;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
