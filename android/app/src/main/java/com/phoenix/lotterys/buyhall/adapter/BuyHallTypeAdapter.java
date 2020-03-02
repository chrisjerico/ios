package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.GameType;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;

import java.util.List;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class BuyHallTypeAdapter extends RecyclerView.Adapter {
    List<GameType.DataBean> list;
    Context context;
    private final ConfigBean config;

    public BuyHallTypeAdapter(List<GameType.DataBean> list, Context context) {
        this.list = list;
        this.context = context;
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_hall_type, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        GameType.DataBean item = list.get(position);
        holder.tv_title.setText(item.getCategoryName()+"系列");
//        holder.iv_img.setImageResource(item.getImg());
        if (item.getCategory().equals("lottery")) {
            if (Uiutils.isSite("c190"))
                holder.iv_img.setImageResource(R.drawable.lottery_ticket190);
            else
                holder.iv_img.setImageResource(R.drawable.lottery_ticket);
        }
        else if (item.getCategory().equals("game")) {
            if (Uiutils.isSite("c190"))
                holder.iv_img.setImageResource(R.drawable.game190);
            else
            holder.iv_img.setImageResource(R.drawable.game);
        }
        else if (item.getCategory().equals("fish")) {
            if (Uiutils.isSite("c190"))
                holder.iv_img.setImageResource(R.drawable.fish190);
            else
            holder.iv_img.setImageResource(R.drawable.fish);
        }
        else if (item.getCategory().equals("card")) {
            if (Uiutils.isSite("c190"))
                holder.iv_img.setImageResource(R.drawable.chess190);
            else
            holder.iv_img.setImageResource(R.drawable.chess);
        }
        else if (item.getCategory().equals("sport")) {
            if (Uiutils.isSite("c190"))
                holder.iv_img.setImageResource(R.drawable.sports190);
            else
            holder.iv_img.setImageResource(R.drawable.sports);
        }
        else if (item.getCategory().equals("real")) {
            if (Uiutils.isSite("c190"))
                holder.iv_img.setImageResource(R.drawable.real_person190);
            else
            holder.iv_img.setImageResource(R.drawable.real_person);
        }
        else if (item.getCategory().equals("esport")) {
            if (Uiutils.isSite("c190"))
                holder.iv_img.setImageResource(R.drawable.dj190);
            else
            holder.iv_img.setImageResource(R.drawable.dj);
        }

//        Uiutils.setBa(context,holder.main_lin);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(context, holder.main_lin);
                holder.tv_title.setTextColor(context.getResources().getColor(R.color.font));
            } else {
                Uiutils.setBa(context, holder.main_lin);
                holder.tv_title.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            Uiutils.setBa(context, holder.main_lin);
            holder.tv_title.setTextColor(context.getResources().getColor(R.color.black));
        }
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
        public CardView main_lin;


        public MyHolder(View itemView) {
            super(itemView);
            tv_title = (TextView) itemView.findViewById(R.id.tv_title);
            iv_img = (ImageView) itemView.findViewById(R.id.iv_img);
            main_lin = (CardView) itemView.findViewById(R.id.main_lin);
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
