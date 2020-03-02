package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/3.
 */

public class NiuNumberAdapter extends RecyclerView.Adapter<NiuNumberAdapter.ViewHolder> {
    private Context context;
    private LayoutInflater inflater;
    String[] niu;
    List<String> winningPlayers;

    public NiuNumberAdapter(String[] niu, List<String> winningPlayers, Context context) {
        this.niu = niu;
        this.context = context;
        this.winningPlayers = winningPlayers;
        inflater = LayoutInflater.from(context);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.niu_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.tvNiu.setText(niu[position]);
        if (niu[position].equals("牛9")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n9);
        } else if (niu[position].equals("牛8")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n8);
        } else if (niu[position].equals("牛7")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n7);
        } else if (niu[position].equals("牛6")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n6);
        } else if (niu[position].equals("牛5")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n5);
        } else if (niu[position].equals("牛4")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n4);
        } else if (niu[position].equals("牛3")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n3);
        } else if (niu[position].equals("牛2")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n2);
        } else if (niu[position].equals("牛1")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.n1);
        } else if (niu[position].equals("牛牛")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.nn);
        } else if (niu[position].equals("没牛")) {
            holder.ivNiu.setBackgroundResource(R.mipmap.wn);
        }

        if (position == 0) {
            holder.tvNiu.setText("庄家");
        } else if (position == 1) {
            holder.tvNiu.setText("闲一");
        } else if (position == 2) {
            holder.tvNiu.setText("闲二");
        } else if (position == 3) {
            holder.tvNiu.setText("闲三");
        } else if (position == 4) {
            holder.tvNiu.setText("闲四");
        } else if (position == 5) {
            holder.tvNiu.setText("闲五");
        }

        holder.rlNiu.setBackgroundResource(R.drawable.shape_niu_off);
        if (position == 0 && (winningPlayers == null||winningPlayers.size()==0)) {
            holder.rlNiu.setBackgroundResource(R.drawable.shape_niu_select);
        }

        if (winningPlayers != null||(winningPlayers!=null&&winningPlayers.size()!=0)) {
            for (int i = 0; i < winningPlayers.size(); i++) {
//                Log.e("xxxx11",""+ winningPlayers.get(i));
                if (winningPlayers.get(i).equals(position + "")) {
                    holder.rlNiu.setBackgroundResource(R.drawable.shape_niu_select);
                }
            }
        }

    }

    @Override
    public int getItemCount() {
        return niu == null ? 0 : niu.length;
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_niu)
        TextView tvNiu;
        @BindView(R2.id.iv_niu)
        ImageView ivNiu;
        @BindView(R2.id.rl_niu)
        RelativeLayout rlNiu;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
