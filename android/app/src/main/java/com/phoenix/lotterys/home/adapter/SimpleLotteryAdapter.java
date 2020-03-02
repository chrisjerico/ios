package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
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
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.util.CustomsTextView;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class SimpleLotteryAdapter extends RecyclerView.Adapter<SimpleLotteryAdapter.ViewHolder> {
    HomeGame.DataBean.IconsBean.ListBean list;
    private Context context;
    private LayoutInflater inflater;
    private SimpleLotteryAdapter.OnClickListener onClickListener;
    private final ConfigBean config;

    public SimpleLotteryAdapter(HomeGame.DataBean.IconsBean.ListBean list,  Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setListener(SimpleLotteryAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position, HomeGame.DataBean.IconsBean.ListBean list);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.simple_item_home_lottery, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int i) {
            holder.rlItemMain.setVisibility(View.VISIBLE);
            if (!StringUtils.isEmpty(list.getSubType().get(i).getIcon())) {
                if (list.getSubType().get(i).getIcon().endsWith(".gif") || list.getSubType().get(i).getIcon().endsWith(".jpeg"))
                    ImageLoadUtil.ImageLoadGif1(list.getSubType().get(i).getIcon(), context, holder.ivTicketIcon);
                else
                    ImageLoadUtil.cacheRoundCorners(0, context, list.getSubType().get(i).getIcon(), holder.ivTicketIcon);
            } else if (!StringUtils.isEmpty(list.getSubType().get(i).getLogo())) {
                if (list.getSubType().get(i).getLogo().endsWith(".gif") || list.getSubType().get(i).getLogo().endsWith(".jpeg"))
                    ImageLoadUtil.ImageLoadGif1(list.getSubType().get(i).getLogo(), context, holder.ivTicketIcon);
                else
                    ImageLoadUtil.cacheRoundCorners(0, context, list.getSubType().get(i).getLogo(), holder.ivTicketIcon);
            }
            if (BuildConfig.FLAVOR.equals("c085") || BuildConfig.FLAVOR.equals("c091")) {
                RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(MeasureUtil.dip2px(context, 60),
                        MeasureUtil.dip2px(context, 60));
                params.addRule(RelativeLayout.CENTER_HORIZONTAL);
                params.setMargins(0, MeasureUtil.dip2px(context, 5), 0, 0);
                holder.ivTicketIcon.setLayoutParams(params);
            } else {
            }
            if (!TextUtils.isEmpty(list.getSubType().get(i).getTitle()) && !TextUtils.isEmpty(list.getSubType().get(i).getName())) {
                holder.tvName.setText(list.getSubType().get(i).getName());
            } else if (!TextUtils.isEmpty(list.getSubType().get(i).getTitle()) && TextUtils.isEmpty(list.getSubType().get(i).getName())) {
                holder.tvName.setText(list.getSubType().get(i).getTitle());
            } else if (TextUtils.isEmpty(list.getSubType().get(i).getTitle()) && !TextUtils.isEmpty(list.getSubType().get(i).getName())) {
                holder.tvName.setText(list.getSubType().get(i).getName());
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
                if (list.getSubType().get(i).getTipFlag() != null) {
                    if (list.getSubType().get(i).getTipFlag().equals("1")) {
                        holder.iv_hot.setText("热");
                        holder.iv_hot.setVisibility(View.VISIBLE);
                    } else if (list.getSubType().get(i).getTipFlag().equals("2")) {
                        Glide.with(context).asGif().load(R.mipmap.event).into(holder.ivActivity);
                        holder.ivActivity.setVisibility(View.VISIBLE);
                    } else if (list.getSubType().get(i).getTipFlag().equals("3")) {
                        holder.ivRward.setText("大\n奖");
                        holder.ivRward.setVisibility(View.VISIBLE);
                    }
                }
            }


        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                    onClickListener.onClickListener(holder.itemView, i, list.getSubType().get(i));
                    if (!TextUtils.isEmpty(list.getSubType().get(i).getSubId())&&(list.getSubType().get(i).getSubId().equals("0")||list.getSubType().get(i).getSubId().equals("1000")||list.getSubType().get(i).getSubId().equals("10000")||list.getSubType().get(i).getSubId().equals("20000"))) {
                        if (TextUtils.isEmpty(list.getSubType().get(i).getUrl())) {
                            ToastUtil.toastShortShow(context, "未配置跳转链接");
                            return;
                        }
                        String url = list.getSubType().get(i).getUrl();
                        Intent intent = new Intent(context, GoWebActivity.class);
                        intent.putExtra("url", url.startsWith("http") ? url : "http://" + url);
                        context.startActivity(intent);
                    } else
                        try {
                            SkipGameUtil.twoSkipGame(i, context, list.getSubType());
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
            }
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.getSubType()==null?0:list.getSubType().size();
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


        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
