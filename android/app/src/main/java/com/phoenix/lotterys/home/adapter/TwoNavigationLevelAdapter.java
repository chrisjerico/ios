package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.GameTypeBean;
import com.phoenix.lotterys.view.RoundShadowLayout;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class TwoNavigationLevelAdapter extends RecyclerView.Adapter<TwoNavigationLevelAdapter.ViewHolder> {
    List<GameTypeBean.ListBean.subTypeBean> list;
    private Context context;
    private LayoutInflater inflater;
    private TwoNavigationLevelAdapter.OnClickListener onClickListener;
    int pos;
String themeColor;
    public TwoNavigationLevelAdapter(List<GameTypeBean.ListBean.subTypeBean> list, Context context, String themeColor) {
        this.list = list;
        this.context = context;
        this.pos = pos;
        this.themeColor = themeColor;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(TwoNavigationLevelAdapter.OnClickListener onClickListener) {
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
                if (TextUtils.isEmpty(list.get(position).getUrl())) {
                    ToastUtil.toastShortShow(context, "未配置跳转");
                    return;
                }
                Intent intent = new Intent();
                intent.setAction("android.intent.action.VIEW");
                String url = list.get(position).getUrl();
                Uri content_url = Uri.parse(url.startsWith("http") ? url : "http://" + url);
                intent.setData(content_url);
                context.startActivity(intent);

            }
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 :list.size();
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
