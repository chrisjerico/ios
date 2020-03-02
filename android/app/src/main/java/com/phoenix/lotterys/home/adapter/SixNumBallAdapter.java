package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.ShowItem;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/5.
 */

public class SixNumBallAdapter extends RecyclerView.Adapter<SixNumBallAdapter.ViewHolder> {
    private Context context;
    private LayoutInflater inflater;
    List<WinNumber> winNumberList;
    private SixNumBallAdapter.OnClickListener onClickListener;

    public SixNumBallAdapter(List<WinNumber> winNumberList, Context context) {
        this.winNumberList = winNumberList;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public void setListener(SixNumBallAdapter.OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.sixnumball_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
//        ImageLoadUtil.toRoundCorners(R.drawable.z2,holder.ivImg.getContext(),list.get(position).getPic(), holder.ivImg);

        holder.tvZodiac.setText(winNumberList.get(position).getAnimal());
        holder.tvNum.setText(winNumberList.get(position).getNum());

        if ((!winNumberList.get(position).getNum().equals("+"))) {
            if (ShowItem.isNumeric(winNumberList.get(position).getNum())) {
                holder.tvNum.setBackgroundResource(NumUtil.NumImg(Integer.parseInt(winNumberList.get(position).getNum())));
            }
        }
        if (winNumberList.get(position).isHide()) {
            holder.ivImg.setVisibility(View.VISIBLE);
            holder.tvZodiac.setVisibility(View.GONE);
            holder.tvNum.setVisibility(View.GONE);
        } else {
            holder.ivImg.setVisibility(View.GONE);
            holder.tvZodiac.setVisibility(View.VISIBLE);
            holder.tvNum.setVisibility(View.VISIBLE);
        }

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.itemView, position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return winNumberList == null ? 0 : winNumberList.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_num)
        TextView tvNum;
        @BindView(R2.id.tv_title)
        TextView tvZodiac;
        @BindView(R2.id.iv_img)
        ImageView ivImg;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
