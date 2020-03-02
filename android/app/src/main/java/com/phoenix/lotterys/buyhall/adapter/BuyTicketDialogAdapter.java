package com.phoenix.lotterys.buyhall.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.LotteryNewDetails;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.util.EditInputFilter;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;

import java.util.Arrays;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class BuyTicketDialogAdapter extends RecyclerView.Adapter<BuyTicketDialogAdapter.ViewHolder> {
    private List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list;
    private Context context;
    private LayoutInflater inflater;
    String name, type, rightTitle, betCount;
    String[] selectNum;
    private OnClickListener onClickListener;
    List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> playGroupsBean;
    //输入法
//    InputMethodManager inputMethodManager = (InputMethodManager)context. getSystemService(Context.INPUT_METHOD_SERVICE);
    int etFocusPos = -1;
    private String edit;
    private ViewHolder viewHolder;
    private final ConfigBean config;

    //整体修改的金额
    public void inputAllAmount(String allMoney) {
        for (LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean bean : list) {
            bean.setAmount(allMoney);
        }
        notifyDataSetChanged();
    }

    public void setListener(OnClickListener onClickListener) {
        this.onClickListener = onClickListener;
    }

    public void setTypename(String leftTitle, String rightTitle, String type) {
        this.rightTitle = rightTitle;
        this.name = leftTitle;
        this.type = type;
        addShareAlias();
    }

    public void setTypename(String leftTitle, String type, String[] selectNum, List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean> playGroups) {
        this.name = leftTitle;
        this.type = type;
        this.selectNum = selectNum;
        this.playGroupsBean = playGroups;
        addShareAlias();
    }

    public void setTypename(String leftTitle, String type, String[] selectNum, String rightTitle, String betCount) {
        this.name = leftTitle;
        this.type = type;
        this.selectNum = selectNum;
        this.betCount = betCount;
        this.rightTitle = rightTitle;
        addShareAlias();
    }

    public interface OnClickListener {
        void onClickListener(View view, int position, String s);
    }

    public BuyTicketDialogAdapter(List<LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean> list, Context context) {
        this.list = list;
        this.context = context;
//        this.leftTitle = leftTitle;
        inflater = LayoutInflater.from(context);
        config = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = inflater.inflate(R.layout.item_buy_ticket_dialog, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public synchronized void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
//        holder.setIsRecyclable(false);
        setTheme(holder);
        editable( holder);
        String odds = null;
        if (type != null && name != null && selectNum != null && (type.equals("lhc") || type.equals("gd11x5") || type.equals("gdkl10") || type.equals("xync")) && (name.equals("自选不中") || name.equals("合肖") || name.equals("连码")) && selectNum.length != 0) {
            if (name.equals("自选不中")) {
                String text = playGroupsBean.get(0).getPlays().get(0).getTitleRight()+"<font color='#2F9CF3'>" + Arrays.toString(selectNum) + "</font>";
                holder.tvTicketName.setText(Html.fromHtml(text));
//                list.get(position).setShareAlias(name+Arrays.toString(selectNum));
//                odds = list.get(ShowItem.selectNum(selectNum.length) - 1).getSelectOdds();
                for (int i = 0; i < playGroupsBean.get(0).getPlays().size(); i++) {
                    if (playGroupsBean.get(0).getPlays().get(i).getAlias() != null && playGroupsBean.get(0).getPlays().get(i).getAlias().equals("" + selectNum.length)) {
                        odds = playGroupsBean.get(0).getPlays().get(i).getSelectOdds();
                    }
                }
            } else if (name.equals("合肖")) {
                String text ="合肖"+ "-合肖"+selectNum.length+"<font color='#2F9CF3'>" + Arrays.toString(selectNum) + "</font>";
                holder.tvTicketName.setText(Html.fromHtml(text));
//                list.get(position).setShareAlias(name+Arrays.toString(selectNum));
//                odds = playGroupsBean.get(0).getPlays().get(ShowItem.selectZxNum(selectNum.length)).getOdds();
                for (int i = 0; i < playGroupsBean.get(0).getPlays().size(); i++) {
                    if (playGroupsBean.get(0).getPlays().get(i).getAlias() != null && playGroupsBean.get(0).getPlays().get(i).getAlias().equals("" + selectNum.length)) {
                        odds = playGroupsBean.get(0).getPlays().get(i).getOdds();
                    }
                }

            } else if (name.equals("连码")) {
                String text = "连码 - " + rightTitle + "<font color='#2F9CF3'>" + Arrays.toString(selectNum) + "</font>组合数:" + betCount;
                holder.tvTicketName.setText(Html.fromHtml(text));
//                list.get(position).setShareAlias(name+Arrays.toString(selectNum));
                odds = list.get(0).getOdds();
            }
            if (position == 0) {
                holder.rlMain.setVisibility(View.VISIBLE);
            } else {
                holder.rlMain.setVisibility(View.GONE);
            }
        } else if (!TextUtils.isEmpty(rightTitle) && (rightTitle.equals("前二直选") || rightTitle.equals("前三直选"))) {
            String text = rightTitle + "<font color='#2F9CF3'>" + list.get(position).getName() + "</font>";
            holder.tvTicketName.setText(Html.fromHtml(text));
//            list.get(position).setShareAlias(rightTitle+list.get(position).getName());
//            Log.e("xxxx前二直选",""+rightTitle+list.get(position).getName());
            odds = list.get(position).getOdds();
        } else {
            String text = (TextUtils.isEmpty(list.get(position).getTitleRight()) ? "" : (list.get(position).getTitleRight() + " ")) + "<font color='#2F9CF3'>" + list.get(position).getName() + "</font>";
            holder.tvTicketName.setText(Html.fromHtml(text));
//            list.get(position).setShareAlias(name+list.get(position).getName());
            odds = list.get(position).getOdds();
        }
        if (odds != null) {
            boolean status = odds.contains("/");
            if (!status) {
                holder.tvOdds.setText("@" + ShowItem.subZeroAndDot(odds));
            } else {
                holder.tvOdds.setText("@" + odds);
            }
        }
        holder.tvAmount.setText(list.get(position).getAmount());
        holder.tvDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onClickListener != null)
                    onClickListener.onClickListener(holder.tvDelete, position, null);
            }
        });

        holder.tvAmount.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean b) {
                if (b) {
                    etFocusPos = position;
                    edit = holder.tvAmount.getText().toString();
                } else {
                    if (etFocusPos != -1) {
                        String s = holder.tvAmount.getText().toString().trim();
                        if (s == null || s.equals("")) {
                            holder.tvAmount.setText(edit);
                        }
                    }
                }
            }
        });
        holder.tvAmount.setTag(position);
        holder.tvAmount.setSelection(holder.tvAmount.getText().length());

    }

    private void editable(ViewHolder holder) {
        if(type==null||name==null){
            return;
        }
        if ((type.equals("lhc") && (name.equals("连肖") || name.equals("连尾")))||
                (type.equals("gd11x5") && (name.equals("直选")))/*||(type.equals("xync") && (name.equals("连码")))*/) {
            holder.tvAmount.setFocusable(false);
            holder.tvAmount.setFocusableInTouchMode(false);
        }else {
//            holder.tvAmount.setFocusableInTouchMode(true);
//            holder.tvAmount.setFocusable(true);
//            holder.tvAmount.requestFocus();
        }
    }

    private void addShareAlias() {
//        Log.e("xxxxxlist", "" + list.size());
        for (int pos = 0; pos < list.size(); pos++) {
            if (type != null && name != null && selectNum != null && (type.equals("lhc") || type.equals("gd11x5") || type.equals("gdkl10") || type.equals("xync")) && (name.equals("自选不中") || name.equals("合肖") || name.equals("连码")) && selectNum.length != 0) {
                if (name.equals("自选不中")) {
                    list.get(pos).setShareAlias(name + Arrays.toString(selectNum));
                } else if (name.equals("合肖")) {
                    list.get(pos).setShareAlias(name + Arrays.toString(selectNum));
                } else if (name.equals("连码")) {
                    list.get(pos).setShareAlias(name + Arrays.toString(selectNum));
                }
            } else if (!TextUtils.isEmpty(rightTitle) && (rightTitle.equals("前二直选") || rightTitle.equals("前三直选"))) {
                list.get(pos).setShareAlias(rightTitle + list.get(pos).getName());
            } else {
                list.get(pos).setShareAlias(list.get(pos).getTitleAlias() + list.get(pos).getName());
            }
        }
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R2.id.tv_ticket_name)
        TextView tvTicketName;
        @BindView(R2.id.tv_odds)
        TextView tvOdds;
        @BindView(R2.id.tv_amount)
        EditText tvAmount;
        @BindView(R2.id.tv_delete)
        TextView tvDelete;
        @BindView(R2.id.rl_main)
        RelativeLayout rlMain;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    @Override
    public void onViewDetachedFromWindow(@NonNull final ViewHolder holder) {
        super.onViewDetachedFromWindow(holder);
        ViewHolder viewHolder = (ViewHolder) holder;
        viewHolder.tvAmount.removeTextChangedListener(textWatcher);
        viewHolder.tvAmount.clearFocus();
        if (etFocusPos == holder.getAdapterPosition()) {
//            inputMethodManager.hideSoftInputFromWindow(((ViewHolder) holder).tvAmount.getWindowToken(), 0);
        }
    }


    @Override
    public void onViewAttachedToWindow(@NonNull final ViewHolder holder) {
        super.onViewAttachedToWindow(holder);
        viewHolder = (ViewHolder) holder;
        viewHolder.tvAmount.addTextChangedListener(textWatcher);
        InputFilter[] filters = {new EditInputFilter()};
        viewHolder.tvAmount.setFilters(filters);
        if (etFocusPos == holder.getAdapterPosition()) {

//            viewHolder.tvAmount.requestFocus();
            viewHolder.tvAmount.setSelection(viewHolder.tvAmount.getText().length());
        }

    }

    TextWatcher textWatcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {

        }

        @Override
        public void afterTextChanged(Editable s) {
//            Log.e("xxxxxafterTextChanged",""+s);
            if (viewHolder.getAdapterPosition() == etFocusPos) {
                if (s.toString().startsWith(" ")) {
                    viewHolder.tvAmount.setText("");
                }
            }

//            if (s.toString() != null && !s.toString().equals("0")) {
            if (onClickListener != null) {
                onClickListener.onClickListener(null, etFocusPos, s.toString());
                list.get(etFocusPos).setAmount(s.toString());
            }
//            } else if (s.toString().equals("0")) {
//                list.get(etFocusPos).setAmount("");
//                notifyDataSetChanged();
//            }
        }
    };


    private void setTheme(ViewHolder holder) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(context, tvTitle, false, null);
//                Uiutils.setBaColor(context, llMain);
//                Uiutils.setBaColor(context, view);
                holder.tvTicketName.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvOdds.setTextColor(context.getResources().getColor(R.color.font));
                holder.tvAmount.setTextColor(context.getResources().getColor(R.color.font));
//                tvTitle.setBackground(context.getResources().getDrawable(R.drawable.black_shape_ticket_dialog_title_bg));
            }
        }
    }

}
