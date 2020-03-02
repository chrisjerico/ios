package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.util.CustomsTextView;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class SimpleOneLevelAdapter extends RecyclerView.Adapter<SimpleOneLevelAdapter.ViewHolder> {
    List<HomeGame.DataBean.IconsBean.ListBean> list;
    private Context context;
    private LayoutInflater inflater;
    int pos,item;
    int prior = -1;
    String themeColor;
    private SimpleOneLevelAdapter.OnClickListener onClickListener;
    private final ConfigBean config;

    public SimpleOneLevelAdapter(List<HomeGame.DataBean.IconsBean.ListBean> list, int position, Context context, int item) {
        this.list = list;
        this.context = context;
        this.pos = position;
        this.item = item;
        this.themeColor = themeColor;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setListener(SimpleOneLevelAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position, HomeGame.DataBean.IconsBean.ListBean listBean);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.simple_item_home_lottery_ticket, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        int i = pos + position;
        if (i >= list.size())
            return;

        if(item ==1){
            holder.cvImg.setVisibility(View.VISIBLE);
            holder.rlItemMain.setVisibility(View.GONE);
            ImageLoadUtil.ImageLoadGif1(list.get(i).getIcon()!=null?list.get(i).getIcon():list.get(i).getLogo(), context, holder.ivImg);
        }else {
            holder.cvImg.setVisibility(View.GONE);
            holder.rlItemMain.setVisibility(View.VISIBLE);

            if (!StringUtils.isEmpty(list.get(i).getIcon())) {
                if (list.get(i).getIcon().endsWith(".gif") || list.get(i).getIcon().endsWith(".jpeg"))
                    ImageLoadUtil.ImageLoadGif1(list.get(i).getIcon(), context, holder.ivTicketIcon);
                else
                    ImageLoadUtil.cacheRoundCorners(0, context, list.get(i).getIcon(), holder.ivTicketIcon);
            } else if (!StringUtils.isEmpty(list.get(i).getLogo())) {
                if (list.get(i).getLogo().endsWith(".gif") || list.get(i).getLogo().endsWith(".jpeg"))
                    ImageLoadUtil.ImageLoadGif1(list.get(i).getLogo(), context, holder.ivTicketIcon);
                else
                    ImageLoadUtil.cacheRoundCorners(0, context, list.get(i).getLogo(), holder.ivTicketIcon);
            }
            if (BuildConfig.FLAVOR.equals("c085") || BuildConfig.FLAVOR.equals("c091")) {
                RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(MeasureUtil.dip2px(context, 60),
                        MeasureUtil.dip2px(context, 60));
                params.addRule(RelativeLayout.CENTER_HORIZONTAL);
                params.setMargins(0, MeasureUtil.dip2px(context, 5), 0, 0);
                holder.ivTicketIcon.setLayoutParams(params);
            } else {
            }
            if (!TextUtils.isEmpty(list.get(i).getTitle()) && !TextUtils.isEmpty(list.get(i).getName())) {
                holder.tvName.setText(list.get(i).getName());
            } else if (!TextUtils.isEmpty(list.get(i).getTitle()) && TextUtils.isEmpty(list.get(i).getName())) {
                holder.tvName.setText(list.get(i).getTitle());
            } else if (TextUtils.isEmpty(list.get(i).getTitle()) && !TextUtils.isEmpty(list.get(i).getName())) {
                holder.tvName.setText(list.get(i).getName());
            }

            holder.ivRwardHot.setVisibility(View.GONE);
            holder.iv_hot.setVisibility(View.GONE);
            holder.ivHotHot.setVisibility(View.GONE);
            holder.ivActivity.setVisibility(View.GONE);
            holder.ivRward.setVisibility(View.GONE);

            if (null != config && null != config.getData() && null != config.getData().getMobileTemplateCategory()
                    && config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(context, holder.rlItemMain);
                holder.tvName.setTextColor(context.getResources().getColor(R.color.font));
                if (list.get(i).getTipFlag() != null) {
                    if (list.get(i).getTipFlag().equals("1")) {
                        holder.iv_hot.setText("热");
                        holder.iv_hot.setVisibility(View.VISIBLE);
                    } else if (list.get(i).getTipFlag().equals("2")) {
                        Glide.with(context).asGif().load(R.mipmap.event).into(holder.ivActivity);
                        holder.ivActivity.setVisibility(View.VISIBLE);
                    } else if (list.get(i).getTipFlag().equals("3")) {
                        holder.ivRward.setText("大\n奖");
                        holder.ivRward.setVisibility(View.VISIBLE);
                    }
                }
            } else {
                Uiutils.setBa(context, holder.rlItemMain);
                holder.tvName.setTextColor(context.getResources().getColor(R.color.black));
                if (null != list.get(i).getTipFlag() && !StringUtils.equals("0", list.get(i).getTipFlag())) {
                    if (StringUtils.isEmpty(list.get(i).getHotIcon())) {
                        ImageLoadUtil.ImageLoad(context, R.drawable.hots2, holder.ivRwardHot);
                    } else {
                        ImageLoadUtil.ImageLoadGif2(list.get(i).getHotIcon(), context, holder.ivRwardHot);
                    }
                    holder.ivRwardHot.setVisibility(View.VISIBLE);
                }
            }

            if (list.get(i).isSelect()) {
                Drawable drawable = context.getResources().getDrawable(R.mipmap.memu);
                int color = ShareUtils.getInt(context, "ba_top", 0);
                Log.e("color==", color + "//");
                if (color == 0) {
                    ImageLoadUtil.ImageLoad(context, R.mipmap.memu, holder.ivMemu);
                } else {
                    drawable.setColorFilter(context.getResources().getColor(color), PorterDuff.Mode.SRC_ATOP);
                    holder.ivMemu.setImageDrawable(drawable);
                }
            } else {
                ImageLoadUtil.ImageLoad(context, R.mipmap.memu, holder.ivMemu);
            }

            if (list.get(i).getSubType() != null && list.get(i).getSubType().size() > 0)
                holder.ivMemu.setVisibility(View.VISIBLE);
            else
                holder.ivMemu.setVisibility(View.GONE);
        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, i, list.get(i));
//                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : (list.size() - pos) >= item ? item : (list.size() - pos) % item;
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.iv_ticket_icon)
        ImageView ivTicketIcon;
        @BindView(R2.id.iv_hot)
        CustomsTextView iv_hot;
        @BindView(R2.id.iv_memu)
        ImageView ivMemu;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.rl_item_main)
        RelativeLayout rlItemMain;

        @BindView(R2.id.iv_rward)
        CustomsTextView ivRward;
        @BindView(R2.id.iv_activity)
        ImageView ivActivity;
        @BindView(R2.id.iv_rward_hot)
        ImageView ivRwardHot;
        @BindView(R2.id.iv_hot_hot)
        ImageView ivHotHot;
        @BindView(R2.id.cv_img)
        CardView cvImg;
        @BindView(R2.id.iv_img)
        ImageView ivImg;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
