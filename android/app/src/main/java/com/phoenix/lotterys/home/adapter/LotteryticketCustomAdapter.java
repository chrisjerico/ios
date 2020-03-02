package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.util.Uiutils;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class LotteryticketCustomAdapter extends RecyclerView.Adapter<LotteryticketCustomAdapter.ViewHolder> {
    List<HomeGame.DataBean.IconsBean.ListBean> list;

    private Context context;
    private LayoutInflater inflater;
    private LotteryticketCustomAdapter.OnClickListener onClickListener;
    HomeGame.DataBean.IconsBean game;
    String themeColor,category;
    List<Boolean> isShow = new ArrayList<>();
    private TwoLevelAdapter twoleveladapter;
    int lastRead;

    public LotteryticketCustomAdapter(HomeGame.DataBean.IconsBean game, Context context, String themeColor, int lastRead, String category) {
        this.game = game;
        this.category = category;
        this.list = game.getList();
        this.context = context;
        this.themeColor = themeColor;
        this.lastRead = lastRead;
        inflater = LayoutInflater.from(context);
        int count = list == null ? 0 : list.size() % 3 == 0 ? (list.size() / 3) : (list.size() / 3) + 1;
        if (isShow != null && isShow.size() > 0)
            isShow.clear();
        for (int i = 0; i < count; i++) {
            isShow.add(false);
        }
    }

    public void setListener(LotteryticketCustomAdapter.OnClickListener onClickListener) {
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

        OneLevelAdapter Onelevel = new OneLevelAdapter(list, position * 3, context,3);
        holder.rvOnelevel.setAdapter(Onelevel);
//        holder.rvOnelevel.setLayoutManager(new GridLayoutManager(context, 3));
        if (holder.rvOnelevel.getItemDecorationCount() == 0) {
            if(category.equals("9"))
                Uiutils.setRec(context, holder.rvOnelevel, 3, R.color.my_line1);
            else
                holder.rvOnelevel.setLayoutManager(new GridLayoutManager(context, 3));
        }
        Onelevel.setListener(new OneLevelAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int pos, HomeGame.DataBean.IconsBean.ListBean listBean) {
                if (lastRead != -1) {
                    Constants.addLastReadList(listBean);
                }
                Log.e("Constants.getLa", "" + Constants.getLastReadList());
                if (sublist != null)
                    sublist.clear();
                for (int i = 0; i < isShow.size(); i++) {
                    isShow.set(i, false);
                }
                isShow.set(position, true);
                if (list.get(pos).getSubType() != null && list.get(pos).getSubType().size() != 0) {
                    twolevel(holder, pos, Onelevel);
                } else {
                    holder.rvTwolevel.setVisibility(View.GONE);
                    try {
                        SkipGameUtil.SkipGame(pos, context, game);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    if (record != -1) {
                        list.get(record).setSelect(false);
                        record = -1;
                    }
                }
                notifyDataSetChanged();
            }
        });

        holder.rvTwolevel.setLayoutManager(new GridLayoutManager(context, 3));
        twoleveladapter = new TwoLevelAdapter(sublist, context, themeColor);
        holder.rvTwolevel.setAdapter(twoleveladapter);

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });
    }

    //    List<GameTypeBean.ListBean.subTypeBean> sublist = new ArrayList<>();
    List<HomeGame.DataBean.IconsBean.ListBean.SubTypeBean> sublist = new ArrayList<>();
    int record = -1;

    private void twolevel(ViewHolder holder, int pos, OneLevelAdapter onelevel) {
        if (pos == record) {
            holder.rvTwolevel.setVisibility(View.GONE);
            record = -1;
            list.get(pos).setSelect(false);
            return;
        } else {
            holder.rvTwolevel.setVisibility(View.VISIBLE);
            list.get(pos).setSelect(true);
            if (record != -1) {
                list.get(record).setSelect(false);
            }
        }
        if (list.get(pos).getSubType() != null && list.get(pos).getSubType().size() > 0) {
            if (sublist != null)
                sublist.clear();
            sublist.addAll(list.get(pos).getSubType());
            if (holder.rvTwolevel.getVisibility() == View.GONE)
                holder.rvTwolevel.setVisibility(View.VISIBLE);
//            holder.rvTwolevel.setLayoutManager(new GridLayoutManager(context, 3));
//            TwoLevelAdapter twoleveladapter = new TwoLevelAdapter(sublist, context);
//            holder.rvTwolevel.setAdapter(twoleveladapter);
//            twoleveladapter.setListener(new TwoLevelAdapter.OnClickListener() {
//                @Override
//                public void onClickListener(View view, int position) {
//
//                }
//            });
//            } else {
            twoleveladapter.notifyDataSetChanged();

        } else {

        }
        record = pos;
    }

    //    isShow = ;
    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size() % 3 == 0 ? (list.size() / 3) : (list.size() / 3) + 1;
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
