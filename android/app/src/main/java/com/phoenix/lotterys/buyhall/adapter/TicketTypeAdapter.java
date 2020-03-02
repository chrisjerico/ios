package com.phoenix.lotterys.buyhall.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.gson.Gson;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.activity.SelectLotteryTicketActivity;
import com.phoenix.lotterys.buyhall.activity.TicketDetailsActivity;
import com.phoenix.lotterys.buyhall.bean.LotteryBuyBean;
import com.phoenix.lotterys.buyhall.bean.TicketDetails;
import com.phoenix.lotterys.helper.OpenHelper;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class TicketTypeAdapter extends RecyclerView.Adapter<TicketTypeAdapter.ViewHolder> {
    List<LotteryBuyBean.DataBean> list;
    private Context context;
    private LayoutInflater inflater;
    private int select;
    private OnClickListener onClickListener;
    private BuyHallTicketAdapter buyHallTicketAdapter;
    private int selectedPosition = 0;//初始第一个为选中状态
    private final ConfigBean config;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position,int pos);
    }


    public void setSelect(int select) {
        this.select = select;
    }

    private long serverTime = 0L;

    public TicketTypeAdapter(List<LotteryBuyBean.DataBean> list, Context context) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_ticket_type, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.setIsRecyclable(false);
        holder.tvTicketClass.setText(list.get(position).getGameTypeName()+"");
        if(list!=null&&list.get(position)!=null) {
            buyHallTicketAdapter = new BuyHallTicketAdapter(list.get(position), serverTime, context);
            holder.rvTicketClass.setAdapter(buyHallTicketAdapter);
            holder.rvTicketClass.setLayoutManager(new GridLayoutManager(context, 2));
            if (holder.rvTicketClass.getItemDecorationCount() == 0) {
                holder.rvTicketClass.addItemDecoration(new DividerGridItemDecoration(context,
                        DividerGridItemDecoration.BOTH_SET, 5, 0));
            }
            buyHallTicketAdapter.setListener(new BuyHallTicketAdapter.OnClickListener() {
                @Override
                public void onClickListener(View view, int pos) {
                    switch (view.getId()) {
                        case R.id.tv_time:
                            if (onClickListener != null)
                                onClickListener.onClickListener(holder.tvTicketClass, position,0);
                            break;
                        default:
                            if (ButtonUtils.isFastDoubleClick()) {
                                return;
                            }
                            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                                return;
                            }
                            if (select == 1) {
                                Intent intent = new Intent();
                                intent.putExtra("ticketName", list.get(position).getGameTypeName());
                                setData(position, pos, intent);
                                if (context instanceof SelectLotteryTicketActivity) {
                                    ((SelectLotteryTicketActivity) context).setResult(Activity.RESULT_OK, intent);
                                    ((SelectLotteryTicketActivity) context).finish();
                                }
//                                onClickListener.onClickListener(holder.tvTicketClass, position,pos);
                            } else {
                                Intent intent = new Intent(context, TicketDetailsActivity.class);
                                setData(position, pos, intent);
                                OpenHelper.startActivity(context, intent);
                            }
//                            Constants.setmHidden(true);
                            break;
                    }
                }
            });
        }
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                holder.tvTicketClass.setTextColor(context.getResources().getColor(R.color.font));
            } else {
                holder.tvTicketClass.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            holder.tvTicketClass.setTextColor(context.getResources().getColor(R.color.black));
        }
    }

    private void setData(int position, int pos, Intent intent) {
        try {
            TicketDetails td = new TicketDetails();
            td.setTitle(list.get(position).getList().get(pos).getTitle());
            td.setPreNum(list.get(position).getList().get(pos).getPreNum());
            td.setLotteryTime(list.get(position).getList().get(pos).getCurOpenTime());
            td.setPreLotteryTime(list.get(position).getList().get(pos).getPreOpenTime());
            td.setEndtime(list.get(position).getList().get(pos).getCurCloseTime());
            td.setGameId(list.get(position).getList().get(pos).getId());
            td.setGameType(list.get(position).getGameType());
            td.setIsInstant(list.get(position).getList().get(pos).getIsInstant());

            ShareUtils.putString(context,"isInstant",list.get(position).getList().get(pos).getIsInstant());
            Gson gson = new Gson();
            String ticketDetails = gson.toJson(td);
            intent.putExtra("ticketDetails", ticketDetails);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_ticket_class)
        TextView tvTicketClass;
        @BindView(R2.id.rv_ticket_class)
        RecyclerView rvTicketClass;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    @Override
    public int getItemViewType(int position) {
        return position;
    }

    public void notifyDataAt() {
        if (buyHallTicketAdapter != null) {
            buyHallTicketAdapter.cancelAllTimers();
        }
    }

    public void setServer(long l) {
        this.serverTime = l;
    }
}
