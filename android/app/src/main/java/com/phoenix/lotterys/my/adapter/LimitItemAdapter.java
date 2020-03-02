package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.view.ChoiceItemLayout;

import java.util.List;

/**
 * Date:2019/4/23
 * TIME:12:14
 * author：Luke
 */
public class LimitItemAdapter extends RecyclerView.Adapter {
    public List<My_item> list;
    Context context;
    public LimitItemAdapter(List<My_item> list, Context context) {
        this.list = list;
        this.context = context;
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_limit, parent, false);
        return new MyHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        MyHolder holder = (MyHolder) viewHolder;
        My_item  limit = list.get(position);
        holder.tv1.setText(limit.getTitle());
//        BlackChoiceItemLayout layoutBlack = (BlackChoiceItemLayout) holder.itemView;
//        layoutBlack.setChecked(limit.isSelected());
//        ConfigBean config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
//        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
//            if (config.getData().getMobileTemplateCategory().equals("5")) {
//
//            }else {
//                ChoiceItemLayout layout = (ChoiceItemLayout ) holder.itemView;
//                layout.setChecked(limit.isSelected());
//            }
//        }else {
            ChoiceItemLayout layout = (ChoiceItemLayout ) holder.itemView;
            layout.setChecked(limit.isSelected());
//        }
        ConfigBean config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                if(limit.isSelected()){
                    holder. tv1 .setTextColor(context.getResources().getColor(R.color.white));
                }else
                    holder. tv1 .setTextColor(context.getResources().getColor(R.color.black));
            }
        }


        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onItemClickListener.onItemClick(view, position);
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0:list.size();
    }


    public class MyHolder extends RecyclerView.ViewHolder {
        public TextView tv1;
        public MyHolder(View itemView) {
            super(itemView);
            tv1 = (TextView) itemView.findViewById(R.id.tv1);

        }
    }


    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    private OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }
}
