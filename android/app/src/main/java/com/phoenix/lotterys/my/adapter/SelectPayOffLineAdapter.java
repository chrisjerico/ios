package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.PaymentBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.RoundCheckBox;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class SelectPayOffLineAdapter extends RecyclerView.Adapter<SelectPayOffLineAdapter.ViewHolder> {
    List<PaymentBean.ChannelBean> list;
    private Context context;
    private LayoutInflater inflater;
    private SelectPayOffLineAdapter.OnClickListener onClickListener;
    private SparseBooleanArray mCheckStates = new SparseBooleanArray();
    String type;
    private final ConfigBean config;

    public SelectPayOffLineAdapter(List<PaymentBean.ChannelBean> list, Context context, String type) {
        this.list = list;
        this.context = context;
        this.type = type;
        inflater = LayoutInflater.from(context);
        mCheckStates.put(0, true);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    public void setListener(SelectPayOffLineAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position, List<PaymentBean.ChannelBean> list);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.pay_off_line_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        holder.setIsRecyclable(false);

        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                holder.cb.setTextColor(context.getResources().getColor(R.color.font));

                Uiutils.setBaColor(context, holder.itemView,false,null);
            }else {
                holder.cb.setTextColor(context.getResources().getColor(R.color.black));
            }
        }else {
            holder.cb.setTextColor(context.getResources().getColor(R.color.black));
        }
        holder.cb.setText(list.get(position).getPayeeName());
        holder.cb.setTag(position);//在最开始适配的时候，将每一个CheckBox设置一个当前的Tag值，这样每个CheckBox都有了一个固定的标识
        holder.cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isCheckBox) {
                int pos = (int) buttonView.getTag();//得到当前CheckBox的Tag值，由于之前保存过，所以不会出现索引错乱
                if (isCheckBox) {
                    //点击时将当前CheckBox的索引值和Boolean存入SparseBooleanArray中
                    mCheckStates.put(pos, true);
                    list.get(position).setSelect(true);
                } else {
                    //否则将 当前CheckBox对象从SparseBooleanArray中移除
                    mCheckStates.delete(pos);
                    list.get(position).setSelect(false);
                }
            }
        });

//得到CheckBox的Boolean值后，将当前索引的CheckBox状态改变
        holder.cb.setChecked(mCheckStates.get(position, false));
        holder.cb.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position, list);
            }
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.cb)
        RoundCheckBox cb;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    public void ClearItem(int pos) {
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                if (pos == i) {
                    list.get(i).setSelect(true);
                    mCheckStates.put(i, true);
                } else {
                    list.get(i).setSelect(false);
                    mCheckStates.delete(i);
                }
            }
        }
        notifyDataSetChanged();
    }


}
