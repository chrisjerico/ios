package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import android.graphics.Color;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.ShowItem;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/3.
 */

public class WinNumSecsecAdapter extends RecyclerView.Adapter<WinNumSecsecAdapter.ViewHolder> {
    private List<WinNumber> list;
    private Context context;
    String gameId, typeGame;
    private LayoutInflater inflater;

    public WinNumSecsecAdapter(List<WinNumber> list, String gameId, String typeGame, Context context) {
        this.list = list;
        this.context = context;
        this.gameId = gameId;
        this.typeGame = typeGame;
        inflater = LayoutInflater.from(context);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_number, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        if(!typeGame.equals("jsk3"))   //江苏快三不用
            holder.tvWinNumber.setText(list.get(position).getNum());
        else
//            holder.tvWinNumber.setText("");

        if ((!list.get(position).getNum().equals("+")) && typeGame.equals("lhc")) {
            if (ShowItem.isNumeric(list.get(position).getNum())) {
                holder.tvWinNumber.setBackgroundResource(NumUtil.SixNumColor(Integer.parseInt(list.get(position).getNum())));
            }
        } else if (typeGame.equals("pcdd") && (list.get(position).getNum().equals("="))) {
            holder.tvWinNumber.setBackgroundColor(Color.WHITE);
            holder.tvWinNumber.setTextColor(context.getResources().getColor(R.color.color_787878));
        } else if (typeGame.equals("lhc")) {
            holder.tvWinNumber.setTextColor(context.getResources().getColor(R.color.color_787878));
            holder.tvWinNumber.setBackgroundColor(Color.WHITE);
            holder.tvNumberDesc.setBackgroundColor(Color.WHITE);
        } else if (typeGame.equals("xyft") || typeGame.equals("pk10") || typeGame.equals("pk10nn")) {   //pk10  设置背景颜色
            if(!TextUtils.isEmpty(list.get(position).getNum())){
                if (ShowItem.isNumeric(list.get(position).getNum())) {
                    holder.tvWinNumber.setBackgroundResource(NumUtil.RanColor(Integer.parseInt(list.get(position).getNum())));
                }
            }
        }else if(typeGame.equals("jsk3")){
            if (ShowItem.isNumeric(list.get(position).getNum()))
                holder.tvWinNumber.setBackgroundResource(ShowItem.SelectCrap(list.get(position).getNum()));
        }
        if (list.get(position).getAnimal() != null && !list.get(position).getAnimal().equals("") && !typeGame.equals("bjkl8")) {  //过滤掉北京快乐8
            holder.tvNumberDesc.setText(list.get(position).getAnimal());
            holder.tvNumberDesc.setVisibility(View.VISIBLE);
        }else {
//            holder.tvNumberDesc.setVisibility(View.GONE);
        }
        if (typeGame.equals("pk10nn")) {
            holder.tvNumberDesc.setVisibility(View.GONE);
        }else {
//            holder.tvNumberDesc.setVisibility(View.VISIBLE);
        }
        if (list.get(position).getNum().equals("")) {
            holder.tvWinNumber.setVisibility(View.INVISIBLE);
        }else {
//            holder.tvWinNumber.setVisibility(View.VISIBLE);
        }


        if (!typeGame.equals("lhc")) {
            holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.black1));
            holder.tvNumberDesc.setVisibility(View.GONE);
            LinearLayout.LayoutParams layout=(LinearLayout.LayoutParams)holder.tvWinNumber.getLayoutParams();
            layout.setMargins(0,22,0,0);
            holder.tvWinNumber.setLayoutParams(layout);
        } else {
            holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.color_008000));
            holder.tvNumberDesc.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_win_number)
        TextView tvWinNumber;
        @BindView(R2.id.tv_number_desc)
        TextView tvNumberDesc;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
