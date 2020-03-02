package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.view.BadgeHelper;

import java.util.List;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class MyitemBadgeAdapter extends RecyclerView.Adapter {
    public List<My_item> list;
    Context context;
    BadgeHelper badgeHelperC;

    public MyitemBadgeAdapter(List<My_item> list, Context context) {
        this.list = list;
        this.context = context;
        badgeHelperC = new BadgeHelper(context)
                .setBadgeType(BadgeHelper.Type.TYPE_TEXT)
                .setBadgeCenterVertical()//红点居中
//            .setBadgeOverlap(false)
                .setBadgeTextSize(8)
                .setBadgeSize(100, 100);
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_my_2, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        My_item item = list.get(position);
        holder.tv_title.setText(item.getTitle());
        holder.iv_img.setImageResource(item.getImg());
        if (onItemClickListener != null){
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }
        if (list.get(position).getAlias().equals("znx")&&! TextUtils.isEmpty(item.getMess())&& ShowItem.isNumeric(item.getMess())) {
            badgeHelperC.bindToTargetView(holder.tv_badge);
            badgeHelperC.setBadgeNumber(Integer.parseInt(item.getMess()));//数字模式
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }


    public class MyHolder extends RecyclerView.ViewHolder {
        public TextView tv_title;
        public ImageView iv_img;
        public TextView tv_badge;

        public MyHolder(View itemView) {
            super(itemView);
            tv_title = (TextView) itemView.findViewById(R.id.tv_title);
            iv_img = (ImageView) itemView.findViewById(R.id.iv_img);
            tv_badge = (TextView) itemView.findViewById(R.id.tv_badge);
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
