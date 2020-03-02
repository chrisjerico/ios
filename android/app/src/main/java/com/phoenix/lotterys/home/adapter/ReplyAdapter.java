package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.bean.ReplyBean;
import com.phoenix.lotterys.my.adapter.ReplyNewAdapter;
import com.phoenix.lotterys.my.bean.CommentBean;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class ReplyAdapter extends RecyclerView.Adapter<ReplyAdapter.ViewHolder> {
    List<ReplyBean.DataBean.ListBean> dataList;

    private Context context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;


    public ReplyAdapter(List<ReplyBean.DataBean.ListBean> dataList, Context context) {
        this.dataList = dataList;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    private  boolean isParticulars;
    public ReplyAdapter(List<ReplyBean.DataBean.ListBean> dataList, Context context,boolean isParticulars) {
        this.dataList = dataList;
        this.context = context;
        this.isParticulars = isParticulars;
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
//        String time = StampToDate.getlatelyTime(data.getActionTime());
        if (!TextUtils.isEmpty(data.getActionTime())) {
            String time = StampToDate.getlatelyTime(data.getActionTime());
            holder.tvData.setText(time.equals("") ? data.getActionTime() : time);
        } else {
            holder.tvData.setText("");
        }
        if (!TextUtils.isEmpty(data.getLikeNum())) {
            holder.tvPraise.setText(data.getLikeNum().equals("0") ? "" : data.getLikeNum());
        }else {
            holder.tvPraise.setText("");
        }

        if (!TextUtils.isEmpty(data.getReplyCount())) {
            holder.tvReply.setText(data.getReplyCount().equals("0") ? "" : data.getReplyCount() + context.getResources().getString(R.string.lhc_bbs_reply));
        }else {
            holder.tvReply.setText( context.getResources().getString(R.string.lhc_bbs_reply));
        }

        if (data.getIsLike() != null && data.getIsLike().equals("1")) {
            Drawable drawable = context.getResources().getDrawable(R.mipmap.praise_red);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            holder.tvPraise.setCompoundDrawables(drawable, null, null, null);
        } else if (data.getIsLike() != null) {
            Drawable drawable = context.getResources().getDrawable(R.mipmap.praise);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            holder.tvPraise.setCompoundDrawables(drawable, null, null, null);
        }
        if(data.getContent()!=null){
            holder.tvTitle.setText(data.getContent());
        }else {
            holder.tvTitle.setText("");
        }

        holder.tvPraise.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickItemListener(holder.itemView, position);
            }
        });
        holder.tvReply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });



        if (isParticulars){
            if (null!=data&&null!=data.getSecReplyList()&&data.getSecReplyList().size()>0){
                holder.reply_lin.setVisibility(View.VISIBLE);
                Uiutils.setRec(context, holder.reply_rec, 1);
                ReplyNewAdapter tabAdapter2 =null;

                if (data.getSecReplyList().size()>3) {
                    List<CommentBean.DataBean.SecReplyList> list =new ArrayList<>();
                    for (int i =0 ;i<3;i++){
                        list.add(data.getSecReplyList().get(i));
                    }
                    tabAdapter2 = new ReplyNewAdapter(context,
                            list, R.layout.reply_adatper);
                }else{
                    tabAdapter2 = new ReplyNewAdapter(context,
                            data.getSecReplyList(), R.layout.reply_adatper);
                }
               holder.reply_rec.setAdapter(tabAdapter2);

                if (data.getSecReplyList().size()>3){
                    holder.all_reply_tex.setVisibility(View.VISIBLE);
                    holder.all_reply_tex.setText("查看全部"+data.getReplyCount()+"条回复>");
                    holder.all_reply_tex.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            if (onClickListener != null)
                                onClickListener.onClickListener(holder.itemView, position);
                        }
                    });
                }else{
                    holder.all_reply_tex.setVisibility(View.GONE);
                }
            }else{
                holder.reply_lin.setVisibility(View.GONE);
            }
        }

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


        @BindView(R2.id.reply_lin)
        LinearLayout reply_lin;
        @BindView(R2.id.reply_rec)
        RecyclerView reply_rec;
        @BindView(R2.id.all_reply_tex)
        TextView all_reply_tex;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

}
