package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import android.os.CountDownTimer;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.LotteryBuyBean;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.text.ParseException;

import butterknife.BindView;
import butterknife.ButterKnife;

import static com.phoenix.lotterys.util.StampToDate.dateToStamp;
import static com.phoenix.lotterys.util.StampToDate.getMinuteSecond;

public class BuyHallTicketAdapter extends RecyclerView.Adapter<BuyHallTicketAdapter.ViewHolder> {
    LotteryBuyBean.DataBean list;
    private Context context;
    private LayoutInflater inflater;
    private OnClickListener onClickListener;
    private long lastTouchTime = 0L;
    private long time;

    //退出activity时关闭所有定时器，避免造成资源泄漏。
    private SparseArray<CountDownTimer> countDownMap;
    private final ConfigBean config;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }


    public BuyHallTicketAdapter(LotteryBuyBean.DataBean list, long lastTouchTime, Context context) {
        this.list = list;
        this.context = context;
        this.lastTouchTime = lastTouchTime;
        countDownMap = new SparseArray<>();
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_buy_hall_ticket, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        if (list == null && list.getList() == null && list.getList().get(position) == null && list.getList().get(position).getTitle() == null && list.getList().get(position).getOpenCycle() == null && list.getList().get(position).getPic() == null) {
            return;
        }
        holder.setIsRecyclable(false);
        holder.tvTicketName.setText(list.getList().get(position).getTitle());
        holder.tv_interval.setText(list.getList().get(position).getOpenCycle());

        if (!StringUtils.isEmpty(list.getList().get(position).getPic())){
//            ImageLoadUtil.loadRoundImage(holder.iv_img, list.getList().get(position).getPic(),0 );
//            ImageLoadUtil.ImageLoad(context,list.getList().get(position).getPic(),holder.iv_img);
            ImageLoadUtil.cacheRoundCorners(R.drawable.load_img,context, list.getList().get(position).getPic(), holder.iv_img);
        } else
            ImageLoadUtil.ImageLoad(context,R.drawable.load_img,holder.iv_img );

        if(list.getList().get(position).getIsInstant().equals("0")) {
            //记录时间点
            try {
                time = dateToStamp(list.getList().get(position).getCurOpenTime()) - System.currentTimeMillis() + lastTouchTime;
            } catch (ParseException e) {
                e.printStackTrace();
            }
            //将前一个缓存清除
            if (holder.countdownView != null) {
                holder.countdownView.cancel();
            }
            if (time > 0) { //判断倒计时是否结束
                holder.countdownView = new CountDownTimer(time, 1000) {
                    public void onTick(long millisUntilFinished) {
                        holder.tv_time.setText(getMinuteSecond(millisUntilFinished));
                    }

                    public void onFinish() {
                        //倒计时结束
                        nextExpect(holder, position);
                    }
                }.start();

                countDownMap.put(holder.tv_time.hashCode(), holder.countdownView);
            } else {
                nextExpect(holder, position);
            }
        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });
//        Uiutils.setBa(context,holder.main_lin);


        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(context, holder.main_lin,false,null);
                holder.tvTicketName.setTextColor(context.getResources().getColor(R.color.font));
            } else {
                Uiutils.setBa(context, holder.main_lin);
                holder.tvTicketName.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            Uiutils.setBa(context, holder.main_lin);
            holder.tvTicketName.setTextColor(context.getResources().getColor(R.color.black));
        }

    }

    private void nextExpect(ViewHolder holder, int position) {
        holder.tv_time.setText("获取下一期");
        holder.tv_time.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.tv_time, position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return list.getList() == null ? 0 : list.getList().size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_ticket_name)
        TextView tvTicketName;
        @BindView(R2.id.iv_img)
        ImageView iv_img;
        @BindView(R2.id.tv_time)
        TextView tv_time;
        @BindView(R2.id.tv_interval)
        TextView tv_interval;
        @BindView(R2.id.main_lin)
        RelativeLayout main_lin;
        //        @BindView(R2.id.countdown_view)
        CountDownTimer countdownView;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    @Override
    public int getItemViewType(int position) {
        return position;
    }


    /**
     * 清空资源
     */
    public void cancelAllTimers() {
        if (countDownMap == null) {
            return;
        }
        for (int i = 0, length = countDownMap.size(); i < length; i++) {
            CountDownTimer cdt = countDownMap.get(countDownMap.keyAt(i));
            if (cdt != null) {
                cdt.cancel();
            }
        }
    }

}
