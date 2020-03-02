package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.GameTypeBean;
import com.phoenix.lotterys.main.bean.HomeGame;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class NavigationCustomAdapter extends RecyclerView.Adapter<NavigationCustomAdapter.ViewHolder> {
    List<HomeGame.DataBean.NavsBean.SubTypeBean> list;
    private Context context;
    private LayoutInflater inflater;
    private NavigationCustomAdapter.OnClickListener onClickListener;
    HomeGame.DataBean.NavsBean game;
    private TwoNavigationLevelAdapter twoleveladapter;
    List<Boolean> isShow = new ArrayList<>();
    String themeColor;

    public NavigationCustomAdapter(List<HomeGame.DataBean.NavsBean> game, Context context, String themeColor) {
//        this.game = game;
//        this.list = game.getSubType();
        this.context = context;
        this.themeColor = themeColor;
        inflater = LayoutInflater.from(context);
        int count = list == null ? 0 : list.size() % 3 == 0 ? (list.size() / 3) : (list.size() / 3) + 1;
        if (isShow != null && isShow.size() > 0)
            isShow.clear();
        for (int i = 0; i < count; i++) {
            isShow.add(false);
        }
    }

    public void setListener(NavigationCustomAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_home_lottery_custom, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        if (isShow.get(position)) {
            holder.llTwolevel.setVisibility(View.VISIBLE);
        } else {
            holder.llTwolevel.setVisibility(View.GONE);
        }

//        OneLevelNavigationAdapter Onelevel = new OneLevelNavigationAdapter(list, position * 4, context);
//        holder.rvOnelevel.setAdapter(Onelevel);
//        holder.rvOnelevel.setLayoutManager(new GridLayoutManager(context, 4));
//        Onelevel.setListener(new OneLevelNavigationAdapter.OnClickListener() {
//            @Override
//            public void onClickListener(View view, int pos) {
//                for (int i = 0; i < isShow.size(); i++) {
//                    isShow.set(i, false);
//                }
//                isShow.set(position, true);
//                notifyDataSetChanged();
//                if (list != null && list.size() != 0) {
//                    twolevel(holder, pos, Onelevel);
//                } else {
//                    holder.rvTwolevel.setVisibility(View.GONE);
//                    try {
//                        SkipGameUtil.SkipNavig(pos, context, game);
//                    } catch (Exception e) {
//                        e.printStackTrace();
//                    }
//                    if (record != -1) {
//                        list.get(record).setSelect(false);
//                        record = -1;
//                    }
//                }
//            }
//        });

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });
    }

    List<GameTypeBean.ListBean.subTypeBean> sublist = new ArrayList<>();
    int record = -1;

    private void twolevel(ViewHolder holder, int pos, OneLevelNavigationAdapter onelevel) {
//        if (pos == record) {
//            holder.rvTwolevel.setVisibility(View.GONE);
//            record = -1;
//            list.get(pos).setSelect(false);
//            return;
//        } else {
//            holder.rvTwolevel.setVisibility(View.VISIBLE);
//            list.get(pos).setSelect(true);
//            if (record != -1) {
//                list.get(record).setSelect(false);
//            }
//        }
//        if (list.get(pos).getSubType() != null && list.get(pos).getSubType().size() > 0) {
//            if (sublist != null)
//                sublist.clear();
//            sublist.addAll(list.get(pos).getSubType());
//            if (holder.rvTwolevel.getVisibility() == View.GONE)
//                holder.rvTwolevel.setVisibility(View.VISIBLE);
//            twoleveladapter = new TwoNavigationLevelAdapter(sublist, context, themeColor);
//            holder.rvTwolevel.setAdapter(twoleveladapter);
//            holder.rvTwolevel.setLayoutManager(new GridLayoutManager(context, 3));
//
//        } else {
//
//        }
//        record = pos;
    }

    //    isShow = ;
    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size() % 4 == 0 ? (list.size() / 4) : (list.size() / 4) + 1;
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.rv_onelevel)
        RecyclerView rvOnelevel;
        @BindView(R2.id.rv_twolevel)
        RecyclerView rvTwolevel;
        @BindView(R2.id.ll_twolevel)
        LinearLayout llTwolevel;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
