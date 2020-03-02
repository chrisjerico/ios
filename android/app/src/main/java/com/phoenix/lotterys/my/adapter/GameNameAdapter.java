package com.phoenix.lotterys.my.adapter;

import android.animation.ObjectAnimator;
import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.WalletBean;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/21
 */
public class GameNameAdapter extends RecyclerView.Adapter {
    List<WalletBean.DataBean> mData;
    Context context;

    public void setData(List<WalletBean.DataBean> data, Context context) {
        this.mData = data;
        this.context = context;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.game_item, null));
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {

        ViewHolder viewHolder = (ViewHolder) holder;
        viewHolder.mTextView.setText(mData.get(position).getTitle());
        Uiutils.setBaColor(context,viewHolder.ll_main);
        ImageLoadUtil.ImageLoad(context, mData.get(position).getPic(), viewHolder.ivImg);
        if (!TextUtils.isEmpty(mData.get(position).getBalance())) {
            viewHolder.tv_money.setText("¥ "+FormatNum.amountFormat(mData.get(position).getBalance(), 4));
        } else {
            viewHolder.tv_money.setText("¥ ******");
        }


        if (onItemClickListener != null) {
            viewHolder.iv_refresh.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    ObjectAnimator objectAnimator;
                    objectAnimator = ObjectAnimator.ofFloat(viewHolder.iv_refresh, "rotation", 0f, 360f);
                    objectAnimator.setDuration(1000);
                    objectAnimator.start();
                    onItemClickListener.onItemClick(view, position);
                }
            });

        }
    }

    @Override
    public int getItemCount() {
        return mData == null ? 0 : mData.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public TextView mTextView;
        public TextView tv_money;
        public ImageView iv_refresh;
        public ImageView ivImg;
        public LinearLayout ll_main;

        public ViewHolder(View itemView) {
            super(itemView);
            mTextView = (TextView) itemView.findViewById(R.id.tv_name);
            tv_money = (TextView) itemView.findViewById(R.id.tv_money);
            iv_refresh = (ImageView) itemView.findViewById(R.id.iv_refresh);
            ivImg = (ImageView) itemView.findViewById(R.id.iv_img);
            ll_main = (LinearLayout) itemView.findViewById(R.id.ll_main);
        }
    }

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    private OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }
}
