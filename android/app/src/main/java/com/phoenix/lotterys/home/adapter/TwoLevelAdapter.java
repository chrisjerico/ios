package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.view.RoundShadowLayout;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class TwoLevelAdapter extends RecyclerView.Adapter<TwoLevelAdapter.ViewHolder> {
    List<HomeGame.DataBean.IconsBean.ListBean.SubTypeBean> list;
    private Context context;
    private LayoutInflater inflater;
    private TwoLevelAdapter.OnClickListener onClickListener;
    int pos;
    String themeColor;

    public TwoLevelAdapter(List<HomeGame.DataBean.IconsBean.ListBean.SubTypeBean> list, Context context, String themeColor) {
        this.list = list;
        this.context = context;
        this.pos = pos;
        this.themeColor = themeColor;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(TwoLevelAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.two_level_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        holder.tvTitle.setText(list.get(position).getTitle());
        if(!TextUtils.isEmpty(themeColor))
        holder.rs_shadow.setBackground(Color.parseColor(themeColor));
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!TextUtils.isEmpty(list.get(position).getSubId())&&(list.get(position).getSubId().equals("0")||list.get(position).getSubId().equals("1000")||list.get(position).getSubId().equals("10000")||list.get(position).getSubId().equals("20000"))) {
                    if (TextUtils.isEmpty(list.get(position).getUrl())) {
                        ToastUtil.toastShortShow(context, "未配置跳转链接");
                        return;
                    }
//                    Intent intent = new Intent();
//                    intent.setAction("android.intent.action.VIEW");
                    String url = list.get(position).getUrl();
//                    Uri content_url = Uri.parse(url.startsWith("http") ? url : "http://" + url);
//                    intent.setData(content_url);
//                    context.startActivity(intent);
                    Intent intent = new Intent(context, GoWebActivity.class);
                    intent.putExtra("url", url.startsWith("http") ? url : "http://" + url);
                    context.startActivity(intent);
                } else
                    try {
                        SkipGameUtil.twoSkipGame(position, context, list);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
            }
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.rs_shadow)
        RoundShadowLayout rs_shadow;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
