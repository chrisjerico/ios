package com.phoenix.lotterys.my.adapter;

import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;

import java.util.List;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class MyOrientationAdapter extends RecyclerView.Adapter {
    public List<My_item> list;

    public MyOrientationAdapter(List<My_item> list) {
        this.list = list;
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.img_text_bt, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        My_item item = list.get(position);
        holder.tv_title.setText(item.getTitle());
        holder.iv_img.setImageResource(item.getImg());
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
        return list == null ? 0:list.size();
    }


    public class MyHolder extends RecyclerView.ViewHolder {
        public TextView tv_title;
        public ImageView iv_img;
        public MyHolder(View itemView) {
            super(itemView);
            tv_title = (TextView) itemView.findViewById(R.id.textview);
            iv_img = (ImageView) itemView.findViewById(R.id.imgview);
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
