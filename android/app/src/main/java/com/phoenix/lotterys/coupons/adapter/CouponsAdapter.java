package com.phoenix.lotterys.coupons.adapter;

import android.content.Context;
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
import com.phoenix.lotterys.coupons.bean.CouponsBean;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.MyWebView;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class CouponsAdapter extends RecyclerView.Adapter<CouponsAdapter.ViewHolder> {
    List<CouponsBean.DataBean.ListBean> list;
    CouponsBean coupons;
    private Context context;
    String template;
    private LayoutInflater inflater;
    private CouponsAdapter.OnClickListener onClickListener;
    public CouponsAdapter(List<CouponsBean.DataBean.ListBean> list, Context context, String template) {
        this.list = list;
        this.context = context;
        this.template = template;
        inflater = LayoutInflater.from(context);
    }

    private boolean isreduced;
    public CouponsAdapter(List<CouponsBean.DataBean.ListBean> list, Context context, String template,boolean isreduced) {
        this.list = list;
        this.context = context;
        this.isreduced = isreduced;
        this.template = template;
        inflater = LayoutInflater.from(context);
    }
    private boolean isok;
    public CouponsAdapter(List<CouponsBean.DataBean.ListBean> list, Context context, String template,
                          boolean isreduced,boolean isok) {
        this.list = list;
        this.context = context;
        this.isreduced = isreduced;
        this.template = template;
        this.isok = isok;
        inflater = LayoutInflater.from(context);
    }
    public CouponsAdapter(CouponsBean coupons, Context context, String template,
                          boolean isreduced,boolean isok) {
        this.coupons = coupons;
        this.list = coupons.getData().getList();
        this.context = context;
        this.isreduced = isreduced;
        this.template = template;
        this.isok = isok;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(CouponsAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }
    public interface OnClickListener {
        void onClickListener(View view, int position);
    }
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.coupons_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
//        holder.setIsRecyclable(false);
        holder.myWeb.setVisibility(View.GONE);
        holder.tvWeb.setVisibility(View.GONE);

        CouponsBean.DataBean.ListBean listBean = list.get(position);
        if (isreduced){
            if (!StringUtils.isEmpty(listBean.getPic())&&(listBean.getPic().contains(".gif")||
                    listBean.getPic().contains(".jpg"))) {
                ImageLoadUtil.ImageLoadGifRound(listBean.getPic(),context,holder.ivImg);
            }else{
                ImageLoadUtil.toRoundCorner2(R.drawable.z2,holder.ivImg.getContext(), listBean.getPic(), holder.ivImg);
            }
        }else{
            ImageLoadUtil.toRoundCorner2(R.drawable.z2,holder.ivImg.getContext(), listBean.getPic(), holder.ivImg);
        }
        if(TextUtils.isEmpty(listBean.getTitle())){
            holder.tvTitle.setVisibility(View.GONE);
        }else {
            holder.tvTitle.setVisibility(View.VISIBLE);
            holder.tvTitle.setText(listBean.getTitle());
        }
        if(!TextUtils.isEmpty(template)){
            if(template.equals("5")){
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.white));
            }else {
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.black));
            }
        }

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });

        if (Uiutils.isSite("c190")&& isok){
            LinearLayout.LayoutParams layoutParams =( LinearLayout.LayoutParams )holder.main_lin.getLayoutParams();
            layoutParams.setMargins(0,0,0,0);
            holder.main_lin.setLayoutParams(layoutParams);
        }else{
            Uiutils.setBa(context, holder.main_lin);
        }

        //当前的内容是否需要展开
        if (listBean.isSlide()) {
            if (!StringUtils.isEmpty(listBean.getContent())) {
                holder.myWeb.setVisibility(View.VISIBLE);
                //重新移除掉，再添加，否则重新绘制WEB高度不准确
                ViewGroup.LayoutParams pms = holder.myWeb.getLayoutParams();
                ViewGroup parent = (ViewGroup) holder.myWeb.getParent();
                int index = parent.indexOfChild(holder.myWeb);

                parent.removeView(holder.myWeb);
                holder.myWeb = new MyWebView(context);
                parent.addView(holder.myWeb, index, pms);
                holder.myWeb.loadDataWithBaseURL(null, ReplaceUtil.getHtmlDataNoSpacing(listBean.getContent()), "text/html", "utf-8", null);
//                holder.tvWeb.setVisibility(View.VISIBLE);
//                holder.tvWeb.setText(Html.fromHtml(listBean.getContent()));
            }
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.iv_img)
        ImageView ivImg;
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.main_lin)
        LinearLayout main_lin;
        @BindView(R2.id.my_web)
        MyWebView myWeb;
        @BindView(R2.id.tv_web)
        TextView tvWeb;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);

            myWeb.defaultConfig();
        }
    }
}
