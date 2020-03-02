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
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class GameHallTypeAdapter extends RecyclerView.Adapter {
    List<GameType.DataBean.GamesBean> list;
    Context context;
    private final ConfigBean config;

    public GameHallTypeAdapter(List<GameType.DataBean.GamesBean> list, Context context) {
        this.list = list;
        this.context = context;
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_game_hall_type, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        GameType.DataBean.GamesBean item = list.get(position);
        holder.tv_title.setText(item.getTitle());
//        ImageLoadUtil.ImageLoad(context, item.getPic(), holder.iv_img);
//        holder.iv_img.setImageResource(item.getImg());
        ImageLoadUtil.cacheRoundCorners(R.drawable.load_img,context, item.getPic(), holder.iv_img);
        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }

        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(context, holder.main_lin,false,null);
                holder.tv_title.setTextColor(context.getResources().getColor(R.color.font));
            } else {
                Uiutils.setBa(context, holder.main_lin);
                holder.tv_title.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            Uiutils.setBa(context, holder.main_lin);
            holder.tv_title.setTextColor(context.getResources().getColor(R.color.black));
        }
//        Uiutils.setBa(context,holder.main_lin);
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
