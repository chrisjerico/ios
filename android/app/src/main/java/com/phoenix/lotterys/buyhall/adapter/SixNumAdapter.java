package com.phoenix.lotterys.buyhall.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Typeface;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextPaint;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;
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

public class SixNumAdapter extends RecyclerView.Adapter<SixNumAdapter.ViewHolder> {

    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list;
    Context context;
    LayoutInflater inflater;
    String title;
    String id, typeGame, palyIng;
    int row;
    int t = 0;
    private OnClickListener onClickListener;
    private final ConfigBean config;

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }


    public interface OnClickListener {
        void onClickListener(View view, int position);
    }

    public SixNumAdapter(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list, String title, String id, String typeGame, Context context, int row, String palyIng) {
        this.list = list;
        this.context = context;
        this.title = title;
        this.id = id;
        this.row = row;
        this.typeGame = typeGame;
        this.palyIng = palyIng;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }


    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_six_name, viewGroup, false);
        return new ViewHolder(view);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {

        LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean pyBean = list.get(position);
        if (palyIng != null)
            pyBean.setTitleRight(palyIng);
        else
            pyBean.setTitleRight("");
        if (title.equals("平特尾数") || title.equals("平特一肖")) {
            pyBean.setTitleRight("平特一肖尾数");
        }

        String name = pyBean.getName();
        String alias = pyBean.getAlias();
        String odds = pyBean.getOdds();
        holder.tvName.setVisibility(View.VISIBLE);
        holder.tvNameIgnore.setVisibility(View.INVISIBLE);

        if (odds != null && !title.equals("合肖")) {
            boolean status = odds.contains("/");
            //保证 忽略符号与数据居中对齐
            if ("0".equals(pyBean.getEnable())) {
                holder.tvName.setVisibility(View.INVISIBLE);
                holder.tvNameIgnore.setVisibility(View.VISIBLE);
            }

            if (!status) {
                String s = ShowItem.subZeroAndDot(odds);
                holder.tvName.setText(s);
            } else {
                holder.tvName.setText(odds);
            }
        }
        if (title.equals("特码A") || title.equals("特码B") || title.equals("正码") || title.equals("正1特") ||
                title.equals("正2特") || title.equals("正3特") || title.equals("正4特") || title.equals("正5特") || title.equals("正6特")
                || title.equals("连码") || title.equals("自选不中") || title.equals("三中二") || title.equals("三全中") || title.equals("二全中")
                || title.equals("二中特") || title.equals("特串") || title.equals("四全中")) {
            if (ShowItem.isNumeric(name)) {
//                if(BuildConfig.FLAVOR.equals("c200")||BuildConfig.FLAVOR.equals("c208")||BuildConfig.FLAVOR.equals("c212")) {
                    holder.tvTitle.setBackgroundResource(NumUtil.SixNumImg(Integer.parseInt(name)));
                    holder.tvTitle.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
                    TextPaint paint = holder.tvTitle.getPaint();
                    paint.setFakeBoldText(true);
//                }else {
//                    holder.tvTitle.setBackgroundResource(NumUtil.NumColor(Integer.parseInt(name)));    //
//                }
            }
        }
        if (title.equals("二连肖") || title.equals("三连肖") || title.equals("四连肖") || title.equals("五连肖")) {
            holder.tvTitle.setText(alias);
            pyBean.setTitleRight(title);
        } else if (title.equals("二连尾") || title.equals("三连尾") || title.equals("四连尾") || title.equals("五连尾")) {
            holder.tvTitle.setText(alias + "尾");
        } else {
            holder.tvTitle.setText(name);
        }
        setmTheme(holder, position);
//        if (list.get(position).isSelect())
//            holder.ll_main.setBackgroundResource(R.drawable.shape_ticket_name_select);
//        else
//            holder.ll_main.setBackgroundResource(R.color.color_white);

        if (pyBean.getNums() != null && title.equals("平特一肖") || title.equals("特肖") || title.equals("三连肖") || title.equals("二连肖") || title.equals("四连肖") || title.equals("五连肖") || title.equals("正肖") || title.equals("合肖")) {
            //notfi导致点击重复添加控件先清除掉所有控件在添加
            if (t == 1) {
                holder.llAdd.removeAllViews();
                t = 0;
            }
            holder.llAdd.setVisibility(View.VISIBLE);
            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            lparams.setMargins(10, 0, 0, 0);
            for (int i = 0; i < pyBean.getNums().size(); i++) {

                TextView tv1 = new TextView(context);
                if (ShowItem.isNumeric(pyBean.getNums().get(i))) {
                    if (title.equals("合肖") && pyBean.getNums().get(i).equals("49")) {

                    } else {
//                        if(BuildConfig.FLAVOR.equals("c200")||BuildConfig.FLAVOR.equals("c208")||BuildConfig.FLAVOR.equals("c212")) {
                            tv1.setBackgroundResource(NumUtil.SixNumImg(Integer.parseInt(pyBean.getNums().get(i))));
                            tv1.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
                            TextPaint paint = tv1.getPaint();
                            paint.setFakeBoldText(true);
//                        }else {
//                            tv1.setBackgroundResource(NumUtil.NumColor(Integer.parseInt(pyBean.getNums().get(i))));
//                        }
                        tv1.setText(pyBean.getNums().get(i));
                        tv1.setGravity(Gravity.CENTER);
                        tv1.setLayoutParams(lparams);
                        setTextTheme(tv1);
                        holder.llAdd.addView(tv1, i);
                    }
                }
            }
        }
        if (title.equals("平特尾数") || title.equals("特码尾数")) {
            if (t == 1) {
                holder.llAdd.removeAllViews();
                t = 0;
            }
            holder.llAdd.setVisibility(View.VISIBLE);
            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            lparams.setMargins(10, 0, 0, 0);
            String num = name.substring(0, 1);
            if (ShowItem.isNumeric(num)) {
                String[] tail = ShowItem.tail(Integer.parseInt(num));
                for (int i = 0; i < tail.length; i++) {
                    TextView tv1 = new TextView(context);
//                    if(BuildConfig.FLAVOR.equals("c200")||BuildConfig.FLAVOR.equals("c208")||BuildConfig.FLAVOR.equals("c212")) {
                        tv1.setBackgroundResource(NumUtil.SixNumImg(Integer.parseInt(tail[i])));
                        tv1.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
                        TextPaint paint = tv1.getPaint();
                        paint.setFakeBoldText(true);
//                    }else {
//                        tv1.setBackgroundResource(NumUtil.NumColor(Integer.parseInt(tail[i])));
//                    }
                    tv1.setText(tail[i]);
                    tv1.setGravity(Gravity.CENTER);
                    tv1.setLayoutParams(lparams);
                    setTextTheme(tv1);
                    holder.llAdd.addView(tv1, i);
                }
            }
        } else if (title.equals("二连尾") || title.equals("三连尾") || title.equals("四连尾") || title.equals("五连尾")) {
            pyBean.setTitleRight(title);
            if (t == 1) {
                holder.llAdd.removeAllViews();
                t = 0;
            }
            holder.llAdd.setVisibility(View.VISIBLE);
            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            lparams.setMargins(10, 0, 0, 0);
//            String num = name.substring(0, 1);
            if (ShowItem.isNumeric(alias)) {
                String[] tail = ShowItem.tail(Integer.parseInt(alias));
                for (int i = 0; i < tail.length; i++) {
                    TextView tv1 = new TextView(context);
//                    if(BuildConfig.FLAVOR.equals("c200")||BuildConfig.FLAVOR.equals("c208")||BuildConfig.FLAVOR.equals("c212")){
                        tv1.setBackgroundResource(NumUtil.SixNumImg(Integer.parseInt(tail[i])));
                        tv1.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
                        TextPaint paint = tv1.getPaint();
                        paint.setFakeBoldText(true);
//                    }else {
//                        tv1.setBackgroundResource(NumUtil.NumColor(Integer.parseInt(tail[i])));
//                    }
                    tv1.setText(tail[i]);
                    tv1.setGravity(Gravity.CENTER);
                    tv1.setLayoutParams(lparams);

                    setTextTheme(tv1);
                    holder.llAdd.addView(tv1, i);

                }
            }
        }
//        holder.tvName.setGravity(Gravity.CENTER);
        //六合彩
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if("0".equals(pyBean.getEnable())) {
//                    ToastUtil.toastShortShow(context, "封盘中...");
                    return;
                }

                if (onClickListener != null)
                    t = 1;
                onClickListener.onClickListener(holder.itemView, position);
            }
        });


        if (Uiutils.isSite("c169")||Uiutils.isSite("a002")){
            holder.tvTitle.setTextSize(TypedValue.COMPLEX_UNIT_SP, 17);
            holder.tvTitle.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
        }

    }

    private void setTextTheme(TextView tv1) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                tv1.setTextColor(context.getResources().getColor(R.color.font));
            } else {
                tv1.setTextColor(context.getResources().getColor(R.color.black));
            }
        } else {
            tv1.setTextColor(context.getResources().getColor(R.color.black));
        }
    }

    private void setmTheme(ViewHolder holder, int position) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvName.setTextColor(context.getResources().getColor(R.color.font));
                if (list.get(position).isSelect())
                    holder.ll_main.setBackgroundResource(R.drawable.select_num_black);
                else
//                    Uiutils.setBaColor(context, holder.ll_main);
                    holder.ll_main.setBackgroundColor(context.getResources().getColor(R.color.color_212121));
            } else {
                if (list.get(position).isSelect()) {
//                    if (BuildConfig.FLAVOR.equals("c194") || BuildConfig.FLAVOR.equals("c048") || BuildConfig.FLAVOR.equals("c175") || BuildConfig.FLAVOR.equals("c011")) {
                        holder.ll_main.setBackgroundResource(R.drawable.select_num);
                        if (BuildConfig.FLAVOR.equals("c011")) {
                            holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
                        } else {
                            holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                        }
//                    } else {
//                        holder.ll_main.setBackgroundResource(R.drawable.select_num_all);
//                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//                    }
                } else {
                    holder.ll_main.setBackgroundResource(0);
                    if (BuildConfig.FLAVOR.equals("c194")) {
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                    } else {
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
                    }
                }
            }
        } else {
            if (list.get(position).isSelect()) {
//                if (BuildConfig.FLAVOR.equals("c194") || BuildConfig.FLAVOR.equals("c048") || BuildConfig.FLAVOR.equals("c175") || BuildConfig.FLAVOR.equals("c011")) {
                    holder.ll_main.setBackgroundResource(R.drawable.select_num);
                    if (BuildConfig.FLAVOR.equals("c011")) {
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
                    } else {
                        holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                    }
//                } else {
//                    holder.ll_main.setBackgroundResource(R.drawable.select_num_all);
//                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//                }
            } else {
                holder.ll_main.setBackgroundResource(0);
                if (BuildConfig.FLAVOR.equals("c194")) {
                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_fe594b));
                } else {
                    holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
                }
            }
        }




//        if(Uiutils.isSixBa(context)){
//            if (list.get(position).isSelect()) {
////                if(BuildConfig.FLAVOR.equals("c200")||BuildConfig.FLAVOR.equals("c208")||BuildConfig.FLAVOR.equals("c212")||BuildConfig.FLAVOR.equals("c085")){
//                    holder.ll_main.setBackgroundResource(R.drawable.select_num);
////                }else {
////                    holder.tvTitle.setTextColor(context.getResources().getColor(R.color.white));
////                    holder.ll_main.setBackgroundResource(R.drawable.select_num_all1);
////                }
//                holder.tvName.setTextColor(context.getResources().getColor(R.color.white));
//            }else{
//                holder.ll_main.setBackgroundResource(0);
//                holder.tvTitle.setTextColor(context.getResources().getColor(R.color.color_333333));
//                holder.tvName.setTextColor(context.getResources().getColor(R.color.color_333333));
//            }
//        }

    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_title)
        TextView tvTitle;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.tv_name_ignore)
        TextView tvNameIgnore;

        @BindView(R2.id.ll_main)
        RelativeLayout ll_main;
        @BindView(R2.id.ll_add)
        LinearLayout llAdd;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }


}
