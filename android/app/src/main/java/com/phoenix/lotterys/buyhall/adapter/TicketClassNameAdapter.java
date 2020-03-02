package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import android.graphics.Color;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/3.
 */

public class TicketClassNameAdapter extends RecyclerView.Adapter<TicketClassNameAdapter.ViewHolder> {
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> list;
    private Context context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;
    private int count;
    private int typeCount;
    String id, typeGame;
    boolean mSelect = false;

    int showItem = 1;  //控制要显示的item数量
    private String[] mPosition;
    String leftTitle = "";
    boolean isShow = false;  //
    private String rightTitle, alias, leftName;
    List<Integer> ballCount = new ArrayList<>();
    String palyIng; //分享注单玩法名字
    private final ConfigBean config;

    //boolean show  显示条目
    public void setSelect(Boolean mSelect) {
        this.mSelect = mSelect;
    }

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public void setCount(int count) {
        this.count = count;
        this.moreSelect = count;
    }

    public void setTypeCount(int typeCount) {
        this.typeCount = typeCount;
    }

    public interface OnClickListener {
        void onClickListener(View view, int i, LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean data, boolean isSelect, int position, int count, int typeCount);
    }

    public TicketClassNameAdapter(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> list, String id, String typeGame, Context context, String leftName) {
        this.list = list;
        this.context = context;
        this.id = id;
        this.typeGame = typeGame;
        this.leftName = leftName;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_ticket_class_name, viewGroup, false);
        return new ViewHolder(view);
    }

    int mPos = 0;

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        if (leftTitle.equals("1")) {
            holder.rvClass.setVisibility(View.VISIBLE);
            holder.tvClassName.setVisibility(View.VISIBLE);
            holder.llMain.setVisibility(View.VISIBLE);
        } else {
            holder.rvClass.setVisibility(View.GONE);
            holder.tvClassName.setVisibility(View.GONE);
            holder.llMain.setVisibility(View.GONE);
        }
        ShowItem.ShowItem(leftTitle, holder.rvClass, holder.tvClassName, holder.llMain, position, mPosition);
        typeCount = 0;
        if (list.size() <= position) {
            Log.e("xx数组越界", "数组越界");
            return;
        }
        if (TextUtils.isEmpty(list.get(position).getAlias()))
            palyIng = list.get(position).getName();
        else {
            if (leftTitle.equals("连肖") || leftTitle.equals("连尾")) {
                palyIng = TextUtils.isEmpty(list.get(position).getName()) ? "" : list.get(position).getName();
                palyIng = list.get(position).getName();
            } else
                palyIng = list.get(position).getAlias();
        }

        rightTitle = list.get(position).getAlias();
        //设置右上标题
        if (typeGame.equals("lhc") && rightTitle.equals("合肖") && count >= 2 && position == 0) {
//            holder.tvClassName.setText("赔率：" + ShowItem.subZeroAndDot(list.get(position).getPlays().get(ShowItem.selectZxNum(count)).getOdds()));
            for (int i = 0; i < list.get(position).getPlays().size(); i++) {
                if (list.get(position).getPlays().get(i).getAlias() != null && list.get(position).getPlays().get(i).getAlias().equals("" + count)) {
                    holder.tvClassName.setText("赔率：" + ShowItem.subZeroAndDot(list.get(position).getPlays().get(i).getOdds()));
                }
            }

        } else if (typeGame.equals("lhc") && rightTitle.equals("自选不中") && count >= 5) {
            for (int i = 0; i < list.get(position).getPlays().size(); i++) {
                if (list.get(position).getPlays().get(i).getAlias() != null && list.get(position).getPlays().get(i).getAlias().equals("" + count)) {
                    holder.tvClassName.setText("赔率：" + ShowItem.subZeroAndDot(list.get(position).getPlays().get(i).getSelectOdds()));
                }
            }

//            holder.tvClassName.setText("赔率：" + ShowItem.subZeroAndDot(list.get(position).getPlays().get(ShowItem.selectNum(count) - 1).getSelectOdds()));
        } else if (typeGame.equals("gd11x5") && rightTitle.equals("前二直选")) {
            if (position == 0) {
                holder.tvClassName.setText("第一球  (赔率：" + list.get(position).getPlays().get(0).getOdds() + ")");
            } else if (position == 2) {
                holder.tvClassName.setText("第二球  (赔率：" + list.get(position).getPlays().get(0).getOdds() + ")");
            }

        } else if (typeGame.equals("gd11x5") && rightTitle.equals("前三直选")) {
            if (position == 1) {
                holder.tvClassName.setText("第一球  (赔率：" + list.get(position).getPlays().get(1).getOdds() + ")");
            } else if (position == 4) {
                holder.tvClassName.setText("第二球  (赔率：" + list.get(position).getPlays().get(1).getOdds() + ")");
            } else if (position == 5) {
                holder.tvClassName.setText("第三球  (赔率：" + list.get(position).getPlays().get(1).getOdds() + ")");
            }
        } else if ((typeGame.equals("gdkl10") || typeGame.equals("gd11x5") || typeGame.equals("xync")) && ShowItem.ItemOdds(rightTitle, typeGame)) {
            holder.tvClassName.setText("赔率：" + list.get(position).getPlays().get(0).getOdds());
        } else {
            holder.tvClassName.setText(rightTitle);
        }
        int row = ShowItem.RowItem(rightTitle);
        holder.rvClass.setLayoutManager(new GridLayoutManager(context, row));
        String theme = "";
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(context, holder.tvClassName, false, null);
                holder.tvClassName.setTextColor(context.getResources().getColor(R.color.font));
                holder.view.setVisibility(View.GONE);
                holder.tvClassName.setBackgroundColor(context.getResources().getColor(R.color.black));
                theme = "gbk";
            } else {
//                Uiutils.setBa(context, holder.main_lin);
//                holder.tv_title.setTextColor(context.getResources().getColor(R.color.black));
                theme = "";
            }
        } else {
//            Uiutils.setBa(context, holder.main_lin);
//            holder.tv_title.setTextColor(context.getResources().getColor(R.color.black));
            theme = "";
        }

        if (holder.rvClass.getItemDecorationCount() == 0)   //解决刷新recyclerview刷新 item间距变大问题
        {
            DividerGridItemDecoration dividerGridItemDecoration = new DividerGridItemDecoration(context, DividerGridItemDecoration.BOTH_SET, 2, theme.equals("gbk") ? Color.rgb(0, 0, 0) : Color.rgb(200, 200, 200));
            holder.rvClass.addItemDecoration(dividerGridItemDecoration);
        }
//        holder.rvClass.removeItemDecoration(dividerGridItemDecoration);
        if (typeGame.equals("jsk3")) {   //骰宝
            final CrapAdapter ticketNameAdapter = new CrapAdapter(list.get(position).getPlays(), list.get(position).getAlias(), id, typeGame, context, palyIng);
            holder.rvClass.setAdapter(ticketNameAdapter);
            ticketNameAdapter.setListener(new CrapAdapter.OnClickListener() {
                @Override
                public void onClickListener(View view, int i) {
                    if (onClickListener != null) {
                        mListener(position, i, view, palyIng);
//                        ticketNameAdapter.notifyItemChanged(i);
                        ticketNameAdapter.notifyDataSetChanged();
                    }
                }
            });
        } else if (typeGame.equals("lhc")) {
            final SixNumAdapter sixnumadapter = new SixNumAdapter(list.get(position).getPlays(), list.get(position).getAlias(), id, typeGame, context, row, palyIng);
            holder.rvClass.setAdapter(sixnumadapter);
            sixnumadapter.setListener(new SixNumAdapter.OnClickListener() {
                @Override
                public void onClickListener(View view, int i) {
                    if (onClickListener != null) {
                        mListener(position, i, view, palyIng);
//                        sixnumadapter.notifyItemChanged(i);
                        sixnumadapter.notifyDataSetChanged();
                    }
                }
            });
        } else {
            final TicketNameAdapter ticketNameAdapter = new TicketNameAdapter(list.get(position).getPlays(), rightTitle, id, typeGame, context, leftName, palyIng);
            holder.rvClass.setAdapter(ticketNameAdapter);
            ticketNameAdapter.setListener(new TicketNameAdapter.OnClickListener() {
                @Override
                public void onClickListener(View view, int i) {
                    if (onClickListener != null) {
                        mListener(position, i, view, palyIng);
//                        ticketNameAdapter.notifyItemChanged(i);
                        ticketNameAdapter.notifyDataSetChanged();
                    }
                }
            });
        }
    }

    int moreSelect = 0;
    int moreType = 0;

    private void mListener(int position, int i, View view, String rightTitle) {
//        Log.e("list1111", "" + list.get(position).getPlays());
        if (typeGame.equals("lhc") && alias != null) {
            moreType = ShowItem.selectMoreSix(alias);
        } else if (typeGame.equals("gd11x5") && alias != null) {
            moreType = ShowItem.selectMoregd(alias);
        } else if (typeGame.equals("gdkl10") && alias != null) {
            moreType = ShowItem.selectMoreHappy(alias);
        } else if (typeGame.equals("xync") && alias != null) {
            moreType = ShowItem.selectMoreHappy(alias);
        }
        LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean data = list.get(position).getPlays().get(i);

        if (data.isSelect()) {
            data.setSelect(false);
            count--;
            typeCount--;
            if (mSelect) {
                if (typeGame.equals("gd11x5") && (this.rightTitle.equals("前三直选") || this.rightTitle.equals("前二直选"))) {
                    for (int b = 0; b < ballCount.size(); b++) {
                        if (ballCount.get(b) == i) {
                            ballCount.remove(b);
                        }
                    }
                }
                moreSelect--;
            }

            onClickListener.onClickListener(view, i, data, false, position, count, typeCount);
        } else {
            if (mSelect) {
                if (typeGame.equals("gd11x5") && (this.rightTitle.equals("前三直选") || this.rightTitle.equals("前二直选"))) {
                    for (int b = 0; b < ballCount.size(); b++) {
                        if (ballCount.get(b) == i) {
                            ToastUtil.toastShortShow(context, "不能选择相同球号");
                            return;
                        }
                    }
                }
                if (moreSelect >= moreType) {
                    ToastUtil.toastShortShow(context, "玩法不能超过" + moreType + "个选项");
                    return;
                } else {
                    moreSelect++;
                    if (typeGame.equals("gd11x5") && (this.rightTitle.equals("前三直选") || this.rightTitle.equals("前二直选"))) {
                        ballCount.add(i);
                    }
                }
            }
            data.setSelect(true);
            count++;
            typeCount++;
            onClickListener.onClickListener(view, i, data, true, position, count, typeCount);
        }
//        notifyDataSetChanged();
//        notifyItemChanged(0);   //刷新导致点击不灵敏
    }

    public void cleBallCount() {
        if (ballCount != null)
            ballCount.clear();
    }

    public void showCount(int showItem, String leftTitle, String[] mPosition, String alias) {
        this.showItem = showItem;
        this.leftTitle = leftTitle;
        this.mPosition = mPosition;
        this.alias = alias;
        if (typeGame != null && rightTitle != null && typeGame.equals("gd11x5") && (rightTitle.equals("前三直选") || rightTitle.equals("前二直选")) && ballCount != null) {
            ballCount.clear();
        }
    }

    @Override
    public int getItemCount() {
        if ((typeGame.equals("lhc") || typeGame.equals("gd11x5") || typeGame.equals("gdkl10") || typeGame.equals("xync")) && leftTitle != null && !leftTitle.equals("") &&
                (leftTitle.equals("特码") || leftTitle.equals("正特") || (leftTitle.equals("连码")) || leftTitle.equals("连肖") || leftTitle.equals("连尾"))) {
            isShow = true;
        }
        isShow = false;
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_class_name)
        TextView tvClassName;
        @BindView(R2.id.ll_main)
        LinearLayout llMain;
        @BindView(R2.id.rv_class)
        RecyclerView rvClass;
        @BindView(R2.id.view)
        View view;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
