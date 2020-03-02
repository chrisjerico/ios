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
import com.phoenix.lotterys.home.bean.ReplyBean;
import com.phoenix.lotterys.util.StampToDate;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class ReplyListAdapter extends RecyclerView.Adapter<ReplyListAdapter.ViewHolder> {
    List<ReplyBean.DataBean.ListBean> dataList;

    private Context context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;


    public ReplyListAdapter(List<ReplyBean.DataBean.ListBean> dataList, Context context) {
        this.dataList = dataList;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);

        void onClickItemListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.reply_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        ReplyBean.DataBean.ListBean data = dataList.get(position);
//        ImageLoadUtil.ImageLoad(context, R.drawable.head, holder.ivHead);
        if (data.getHeadImg() != null) {
            ImageLoadUtil.loadRoundImage(holder.ivHead, data.getHeadImg(), 0);
        }else {
            ImageLoadUtil.ImageLoad(context, R.drawable.load_img, holder.ivHead, R.drawable.load_img);
        }
        if (!TextUtils.isEmpty(data.getNickname())) {
            holder.tvName.setText(data.getNickname());
        } else {
            holder.tvName.setText("");
        }
        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_6889AD));

        if (data.getContent() != null) {
            holder.tvTitle.setText(data.getContent());
        }else {
            holder.tvTitle.setText("");
        }
        if (!TextUtils.isEmpty(data.getActionTime())) {
            String time = StampToDate.getlatelyTime(data.getActionTime());
            holder.tvData.setText(time.equals("") ? data.getActionTime() : time);
        } else {
            holder.tvData.setText("");
        }

        holder.tvPraise.setVisibility(View.GONE);
        holder.tvReply.setVisibility(View.GONE);
    }

    @Override
    public int getItemCount() {
        return dataList == null ? 0 : dataList.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.iv_head)
        ImageView ivHead;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.tv_data)
        TextView tvData;
        @BindView(R2.id.tv_praise)
        TextView tvPraise;
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.tv_reply)
        TextView tvReply;


        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }


}
