package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class MyitemAdapterBlack extends RecyclerView.Adapter {
    public List<My_item> list;

    private int type ;
    private Context context;

    public MyitemAdapterBlack(List<My_item> list) {
        this.list = list;
    }


    public MyitemAdapterBlack(List<My_item> list, int type, Context context) {
        this.list = list;
        this.type = type;
        this.context = context;
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_my_2b, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        My_item item = list.get(position);
        holder.tv_badge.setVisibility(View.GONE);
        holder.main_lin.setBackgroundColor(context.getResources().getColor(R.color.black));
        holder.tv_title.setText(item.getTitle());
        holder.blake_img.setVisibility(View.GONE);
        holder.tv_title.setTextColor(context.getResources().getColor(R.color.white));
        holder.iv_img.setImageResource(item.getImg());
        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }

//        if (type==1){
            Drawable drawable =holder.iv_img.getDrawable();
//            int color = ShareUtils.getInt(context,"ba_top",0);
//            Log.e("color==",color+"//");
//            if (color!=0&&!StringUtils.equals("jcxbb",item.getAlias())) {
        if (!StringUtils.equals("jcxbb",item.getAlias())) {
            drawable.setColorFilter(context.getResources().getColor(R.color.white), PorterDuff.Mode.SRC_ATOP);
        }

                holder.iv_img.setImageDrawable(drawable);
//            }


//            Drawable drawable1 =holder.blake_img.getDrawable();
//            int color1 = ShareUtils.getInt(context,"ba_top",0);
//            Log.e("color==",color+"//");
//            if (color1!=0) {
//                drawable1.setColorFilter(context.getResources().getColor(color1), PorterDuff.Mode.SRC_ATOP);
//                holder.blake_img.setImageDrawable(drawable1);
//            }
//
//            if (StringUtils.equals(item.getAlias(),"lxb")||StringUtils.equals(item.getAlias(),"clzs")){
//                holder.blake_img.setVisibility(View.GONE);
//                holder.blake_img1.setVisibility(View.VISIBLE);
//            }else{
//                holder.blake_img1.setVisibility(View.GONE);
//                holder.blake_img.setVisibility(View.VISIBLE);
//            }
//        }

    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }


    public class MyHolder extends RecyclerView.ViewHolder {
        public TextView tv_title;
        public ImageView iv_img;
        public TextView tv_badge;
        public ImageView blake_img;
        public ImageView blake_img1;
        public LinearLayout main_lin;


        public MyHolder(View itemView) {
            super(itemView);
            tv_title = (TextView) itemView.findViewById(R.id.tv_title);
            iv_img = (ImageView) itemView.findViewById(R.id.iv_img);
            blake_img = (ImageView) itemView.findViewById(R.id.blake_img);
            blake_img1 = (ImageView) itemView.findViewById(R.id.blake_img1);
            tv_badge = (TextView) itemView.findViewById(R.id.tv_badge);
            main_lin = (LinearLayout) itemView.findViewById(R.id.main_lin);
        }
    }




    private Uiutils.OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(Uiutils.OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }
}
