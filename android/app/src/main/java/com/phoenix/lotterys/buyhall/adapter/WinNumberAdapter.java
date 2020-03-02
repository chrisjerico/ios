package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import android.graphics.Color;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.Uiutils;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Ykai on 2019/6/3.
 */

public class WinNumberAdapter extends RecyclerView.Adapter<WinNumberAdapter.ViewHolder> {
    private List<WinNumber> list;
    private Context context;
    String gameId, typeGame;
    private LayoutInflater inflater;
    private final ConfigBean config;

    public WinNumberAdapter(List<WinNumber> list, String gameId, String typeGame, Context context) {
        this.list = list;
        this.context = context;
        this.gameId = gameId;
        this.typeGame = typeGame;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_win_number, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {


        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                holder.tvNumberDesc.setBackgroundColor(context.getResources().getColor(R.color.white));
                if (typeGame.equals("cqssc") || typeGame.equals("gd11x5") || typeGame.equals("gdkl10")|| typeGame.equals("bjkl8")|| typeGame.equals("xync")|| typeGame.equals("fc3d")|| typeGame.equals("qxc")) {
                    if (holder.tvWinNumber.getText().toString().equals("+")) {
                        holder.tvWinNumber.setBackgroundColor(context.getResources().getColor(R.color.black));
                    } else {
                        holder.tvWinNumber.setBackground(context.getResources().getDrawable(R.drawable.black_num));
                        holder.tvWinNumber.setTextColor(context.getResources().getColor(R.color.black));
                    }
                }

            } else {
//                holder.tvWinNumber.setTextColor(context.getResources().getColor(R.color.white));
            }
        } else {
//            holder.tvWinNumber.setTextColor(context.getResources().getColor(R.color.white));
        }
            if(BuildConfig.FLAVOR.equals("c048")){  //c048需要把字体改为黑色
                holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.black));
            }


        WinNumber wNumber = list.get(position);
        if (!typeGame.equals("jsk3"))   //江苏快三不用
            holder.tvWinNumber.setText(wNumber.getNum());
        else
            holder.tvWinNumber.setText("");
        if (!typeGame.equals("lhc")) {
            holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.black1));
        } else {
//            holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.color_008000));
        }
        if ((!wNumber.getNum().equals("+")) && typeGame.equals("lhc")) {
            if (ShowItem.isNumeric(wNumber.getNum())) {
//                if(BuildConfig.FLAVOR.equals("c200")||BuildConfig.FLAVOR.equals("c208")||BuildConfig.FLAVOR.equals("c212")) {
                    holder.tvWinNumber.setBackgroundResource(NumUtil.SixNumImg(Integer.parseInt(wNumber.getNum())));
                    holder.tvBallnum.setText(wNumber.getNum());
                    holder.tvBallnum.setTextColor(context.getResources().getColor(R.color.black));

                if (Uiutils.isSite("c199")) {
                    holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.black));
                } else {
                    holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.white));
                }
//                }else
//                    holder.tvWinNumber.setBackgroundResource(NumUtil.SixNumColor(Integer.parseInt(list.get(position).getNum())));
            } else {
            }
        } else if (typeGame.equals("pcdd")) {
//            if ((list.size() - 1 == position) && ShowItem.isNumeric(list.get(position).getNum())) {


            if (!wNumber.getNum().equals("+")||!wNumber.getNum().equals("=")){
                if(ShowItem.isNumeric(wNumber.getNum())){
                    holder.tvWinNumber.setBackgroundResource(NumUtil.circleColor(Integer.parseInt(wNumber.getNum())));
                    holder.tvWinNumber.setTextColor(Color.WHITE);
                }else {
                    holder.tvWinNumber.setBackgroundResource(0);
                    holder.tvWinNumber.setTextColor(Color.BLACK);
                }

            }

//            } else if (ShowItem.isNumeric(list.get(position).getNum())) {
//            } else {
//                holder.tvWinNumber.setBackgroundColor(Color.WHITE);
//                holder.tvWinNumber.setTextColor(context.getResources().getColor(R.color.color_787878));
//            }

        } else if (typeGame.equals("lhc")) {
            holder.tvWinNumber.setTextColor(context.getResources().getColor(R.color.color_787878));
            holder.tvWinNumber.setBackgroundColor(0);
            holder.tvNumberDesc.setBackgroundColor(0);
        } else if (typeGame.equals("xyft") || typeGame.equals("pk10") || typeGame.equals("pk10nn")) {   //pk10  设置背景颜色
            if (!TextUtils.isEmpty(wNumber.getNum())) {
                if (ShowItem.isNumeric(wNumber.getNum())) {
                    holder.tvWinNumber.setBackgroundResource(NumUtil.RanColor(Integer.parseInt(wNumber.getNum())));
                }
            } else {
//
            }
        } else if (typeGame.equals("jsk3")) {
            if (ShowItem.isNumeric(wNumber.getNum()))
                holder.tvWinNumber.setBackgroundResource(ShowItem.SelectCrap(wNumber.getNum()));
        }
        if (wNumber.getAnimal() != null && !wNumber.getAnimal().equals("") && !typeGame.equals("bjkl8")) {  //过滤掉北京快乐8
            holder.tvNumberDesc.setText(wNumber.getAnimal());
            holder.tvNumberDesc.setVisibility(View.VISIBLE);
        } else {
//
        }
        if (typeGame.equals("pk10nn")) {
            holder.tvNumberDesc.setVisibility(View.GONE);
        } else {
//
        }
        if (wNumber.getNum().equals("")) {
            holder.tvWinNumber.setVisibility(View.INVISIBLE);
        } else {

        }

        if (typeGame.equals("lhc")) {
            if(holder.tvNumberDesc.getText().toString().trim().equals("+")){
                holder.tvNumberDesc.setVisibility(View.GONE);
            }else {
                holder.tvNumberDesc.setVisibility(View.VISIBLE);
            }
        }
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                if (holder.tvNumberDesc.getText().toString().equals("+")) {
                    holder.tvNumberDesc.setBackgroundColor(context.getResources().getColor(R.color.black));
                } else {
                    holder.tvNumberDesc.setBackground(context.getResources().getDrawable(R.drawable.black_shape_win_number_desc));
                    holder.tvNumberDesc.setTextColor(context.getResources().getColor(R.color.white));
                }
                if (typeGame.equals("pcdd")&&holder.tvWinNumber.getText().toString().equals("=")) {
                    holder.tvWinNumber.setBackgroundResource(0);
                    holder.tvWinNumber.setTextColor(Color.WHITE);
                }
            }
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
        @BindView(R2.id.tv_ballnum)
        TextView tvBallnum;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }
}
