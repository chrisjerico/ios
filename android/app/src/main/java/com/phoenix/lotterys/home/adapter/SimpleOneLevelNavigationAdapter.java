package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import q.rorbin.badgeview.QBadgeView;

/**
 * Created by Ykai on 2019/6/5.
 */

public class SimpleOneLevelNavigationAdapter extends RecyclerView.Adapter<SimpleOneLevelNavigationAdapter.ViewHolder> {
    List<HomeGame.DataBean.NavsBean> list;
    private Context context;
    private LayoutInflater inflater;
    int pos;
    private QBadgeView badge;
    private SimpleOneLevelNavigationAdapter.OnClickListener onClickListener;

    public SimpleOneLevelNavigationAdapter(List<HomeGame.DataBean.NavsBean> list, int position, Context context) {
        this.list = list;
        this.context = context;
        this.pos = position;
        inflater = LayoutInflater.from(context);

    }

    public SimpleOneLevelNavigationAdapter(List<HomeGame.DataBean.NavsBean> navs, Context context) {
        this.list = navs;
        this.context = context;
        inflater = LayoutInflater.from(context);
        if (BuildConfig.FLAVOR.equals("c085")){
            badge = new QBadgeView(context);
            badge.setBadgeGravity(Gravity.END | Gravity.TOP);
        }
    }

    private boolean isHome;
    public SimpleOneLevelNavigationAdapter(List<HomeGame.DataBean.NavsBean> navs, Context context, boolean isHome) {
        this.list = navs;
        this.isHome = isHome;
        this.context = context;
        inflater = LayoutInflater.from(context);
        if (BuildConfig.FLAVOR.equals("c085")){
            badge = new QBadgeView(context);
            badge.setBadgeGravity(Gravity.END | Gravity.TOP);
        }
    }

    public void setListener(SimpleOneLevelNavigationAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.simple_item_home_navig, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        int i = pos + position;
        if (i >= list.size())
            return;

        if (isHome) {
            ImageLoadUtil.ImageLoad(context, list.get(position).getIcon(), holder.ivTicketIcon);
        }else{
            ImageLoadUtil.ImageLoadCircleCrop(context, list.get(position).getIcon(), holder.ivTicketIcon);
        }

        if (!TextUtils.isEmpty(list.get(position).getName())) {
            holder.tvName.setText(list.get(position).getName().equals("APP下载") ? "版本更新" : list.get(position).getName());
        } else if (TextUtils.isEmpty(list.get(position).getName()) && !TextUtils.isEmpty(list.get(position).getTitle())) {
            holder.tvName.setText(list.get(position).getTitle().equals("APP下载") ? "版本更新" : list.get(position).getTitle());
        } else {
            holder.tvName.setText("");
        }

        if (BuildConfig.FLAVOR.equals("c134") && list.get(position).getSubId() != null && list.get(position).getSubId().equals("13")) {   //c134任务大厅
            SPConstants.setValue(context, SPConstants.SP_User, SPConstants.SP_TASKHALL, list.get(position).getName() != null ? list.get(position).getName() : "");
        }

        if (BuildConfig.FLAVOR.equals("c085") && list.get(position).getSubId() != null && list.get(position).getSubId().equals("14")) {      //c085  站内信显示小红点
            String token = SPConstants.getToken(context);
            if (!TextUtils.isEmpty(token)) {
                UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);
                if (userInfo != null && userInfo.getData() != null) {
                    badge.bindTarget(holder.rlItemMain);
                    badge.setBadgeNumber(userInfo.getData().getUnreadMsg());
                }
            }
        }

        if (list.get(position).getTipFlag() != null && list.get(position).getTipFlag().equals("1")) {
            holder.iv_hot.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(list.get(i).getHotIcon())) {
                Glide.with(context).asGif().load(list.get(i).getHotIcon()).into(holder.iv_hot);
            } else {
                Glide.with(context).asGif().load(R.mipmap.hot_act).into(holder.iv_hot);
            }
        } else {
            holder.iv_hot.setVisibility(View.GONE);
        }
        if (list.get(position).isSelect())
            holder.rlItemMain.setBackgroundResource(R.drawable.shape_home_custom_item_bg);
        else
            holder.rlItemMain.setBackgroundResource(0);

        if (list.get(position).getSubType() != null && list.get(position).getSubType().size() > 0)
            holder.ivMemu.setVisibility(View.VISIBLE);
        else
            holder.ivMemu.setVisibility(View.GONE);

        if(list.get(position).isColor()){
            holder.tvName.setTextColor(context.getResources().getColor(R.color.cr_FF9900));
        }else {
            holder.tvName.setTextColor(context.getResources().getColor(R.color.cr_666666));
        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, i);
                try {
                    SkipGameUtil.SkipNavig1(position, context, list);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

//        if (Uiutils.isSite("c200")){
//            holder.tvName.setTypeface(Typeface.defaultFromStyle(Typeface.NORMAL));
//        }

    }

    @Override
    public int getItemCount() {
//        return list == null ? 0 : (list.size()-pos) >= 4 ? 4 : (list.size()-pos) % 4;
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.iv_ticket_icon)
        ImageView ivTicketIcon;
        @BindView(R2.id.iv_hot)
        ImageView iv_hot;
        @BindView(R2.id.iv_memu)
        ImageView ivMemu;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.rl_item_main)
        RelativeLayout rlItemMain;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
