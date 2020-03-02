package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.coupons.bean.CouponsBean;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class BlackLastReadAdapter extends RecyclerView.Adapter<BlackLastReadAdapter.ViewHolder> {
    List<CouponsBean.DataBean.ListBean> list;
    private Context context;
    String template;
    private LayoutInflater inflater;
    private BlackLastReadAdapter.OnClickListener onClickListener;
    public BlackLastReadAdapter(List<CouponsBean.DataBean.ListBean> list, Context context, String template) {
        this.list = list;
        this.context = context;
        this.template = template;
        inflater = LayoutInflater.from(context);
    }
    public void setListener(BlackLastReadAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }
    public interface OnClickListener {
        void onClickListener(View view, int position);
    }
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.coupons_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {

        ImageLoadUtil.toRoundCorners(R.drawable.z2,holder.ivImg.getContext(),list.get(position).getPic(), holder.ivImg);
        if(TextUtils.isEmpty(list.get(position).getTitle())){
            holder.tvTitle.setVisibility(View.GONE);
        }else {
            holder.tvTitle.setVisibility(View.VISIBLE);
            holder.tvTitle.setText(list.get(position).getTitle());
        }
        if(!TextUtils.isEmpty(template)){
            if(template.equals("5")){
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.white));
            }else {
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.black));
            }
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
