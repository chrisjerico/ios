package com.phoenix.lotterys.home.adapter;

import android.content.Context;

import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.GameType;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class BlackGameAdapter extends RecyclerView.Adapter {
    List<GameType.DataBean.GamesBean> list;
    Context context;

    public BlackGameAdapter(List<GameType.DataBean.GamesBean> list, Context context) {
        this.list = list;
        this.context = context;

    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.black_item_game, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        GameType.DataBean.GamesBean item = list.get(position);
        holder.tv_title.setText(item.getTitle());

        ImageLoadUtil.cacheRoundCorners(R.drawable.load_img,context, item.getPic(), holder.iv_img);
        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }

    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }


    public class MyHolder extends RecyclerView.ViewHolder {
        public TextView tv_title;
        public ImageView iv_img;
        public RelativeLayout main_lin;


        public MyHolder(View itemView) {
            super(itemView);
            tv_title = (TextView) itemView.findViewById(R.id.tv_title);
            iv_img = (ImageView) itemView.findViewById(R.id.iv_img);
            main_lin = (RelativeLayout) itemView.findViewById(R.id.main_lin);
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
