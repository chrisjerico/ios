package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.bean.LhcDocBean;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

import static com.phoenix.lotterys.util.Uiutils.viewSloshing;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class SixInfoAdapter extends RecyclerView.Adapter {
    public List<LhcDocBean.DataBean> sixInfoList;
    Context context;

    public void sixInfoData(List<LhcDocBean.DataBean> sixInfoList) {
        this.sixInfoList = sixInfoList;
//        this.context = context;
    }
    public SixInfoAdapter( Context context) {
//        this.list = list;
        this.context = context;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_six_info, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        LhcDocBean.DataBean item = sixInfoList.get(position);
        holder.tv_title.setText(item.getName());
        holder.tv_content.setText(item.getDesc());
        ImageLoadUtil.cacheRoundCorners(context,R.drawable.load_img, item.getIcon(), holder.iv_img);
//        Glide.with(context).asGif().load(R.mipmap.hots).into(holder.iv_hot);
        viewSloshing(holder.tv_hot);
        if (item.getIsHot() != null&&item.getIsHot().equals("1")) {
            holder.tv_hot.setVisibility( View.VISIBLE);
        }else {
            holder.tv_hot.setVisibility( View.INVISIBLE);
        }

        if (onItemClickListener != null){
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
        return sixInfoList == null ? 0 : sixInfoList.size();
    }


    public class MyHolder extends RecyclerView.ViewHolder {
        public TextView tv_title;
        public ImageView iv_img;
//        public ImageView iv_hot;
        public TextView tv_content;
        public TextView tv_hot;

        public MyHolder(View itemView) {
            super(itemView);
            tv_title = (TextView) itemView.findViewById(R.id.tv_title);
            iv_img = (ImageView) itemView.findViewById(R.id.iv_img);
//            iv_hot = (ImageView) itemView.findViewById(R.id.iv_hot);
            tv_content = (TextView) itemView.findViewById(R.id.tv_content);
            tv_hot = (TextView) itemView.findViewById(R.id.tv_hot);
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
