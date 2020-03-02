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
import com.phoenix.lotterys.home.bean.GameList;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;


public class ElectronicAdapter extends RecyclerView.Adapter<ElectronicAdapter.ViewHolder> {
        List<GameList.DataBean> list;
        private Context context;
        private LayoutInflater inflater;
        private ElectronicAdapter.OnClickListener onClickListener;
        public ElectronicAdapter(List<GameList.DataBean> list, Context context) {
            this.list = list;
            this.context = context;
            inflater = LayoutInflater.from(context);
        }
        public void setListener(ElectronicAdapter.OnClickListener onClickListener) {
            this.onClickListener = onClickListener;
        }
        public interface OnClickListener {
            void onClickListener(View view, int position);
        }
        @NonNull
        @Override
        public ElectronicAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
            View view = inflater.inflate(R.layout.electronic_item, viewGroup, false);
            return new ElectronicAdapter.ViewHolder(view);
        }

        @Override
        public void onBindViewHolder(@NonNull ElectronicAdapter.ViewHolder holder, final int position) {
            ImageLoadUtil.ImageLoad(holder.ivImg.getContext(),list.get(position).getPic(), holder.ivImg,0);
            holder.tvTitle.setText(list.get(position).getName());
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
            @BindView(R2.id.tv_name)
            TextView tvTitle;

            ViewHolder(View view) {
                super(view);
                ButterKnife.bind(this, view);
            }
        }
    }

