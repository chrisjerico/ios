package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/10 19:25
 */
public class LotteryRecordFragSonAdapter extends BaseRecyclerAdapter<String> {

    public LotteryRecordFragSonAdapter(Context context, List<String> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    private List<Integer> listsColour;
    private int type;

    public LotteryRecordFragSonAdapter(Context context, List<String> list, int itemLayoutId,int type) {
        super(context, list, itemLayoutId);
        this.type =type ;
    }

    public LotteryRecordFragSonAdapter(Context context, List<String> list, int itemLayoutId,int type
    , List<Integer> listsColour) {
        super(context, list, itemLayoutId);
        this.type =type ;
        this.listsColour =listsColour ;
    }

    @Override
    public void convert(BaseRecyclerHolder holder, String item, int position, boolean isScrolling) {
        setSype(holder,2);
        switch (type){
            case 0:
            holder.setText(R.id.text_view,item);
            setAddVG(holder, position,0);
                setSype(holder,22,22);
                setSype(holder,2);
                ((TextView)holder.getView(R.id.text_view)).setTextColor(Color.parseColor
                        ("#FF000000"));
                holder.getView(R.id.text_view).setBackgroundResource(NumUtil.NumColor(Integer.
                        parseInt(item)));

            holder.getView(R.id.text_view).setSelected(true);
            break;
            case 1:
                holder.setText(R.id.text_view,item);
                setSype(holder,22,22);
                setSype(holder,2);

                if (!StringUtils.isEmpty(item))
                switch (Integer.parseInt(item)-1){
                    case 0:  setbac(holder,R.drawable.lottery_bck_1);break;
                    case 1:  setbac(holder,R.drawable.lottery_bck_2);break;
                    case 2:  setbac(holder,R.drawable.lottery_bck_3);break;
                    case 3:  setbac(holder,R.drawable.lottery_bck_4);break;
                    case 4:  setbac(holder,R.drawable.lottery_bck_5);break;
                    case 5:  setbac(holder,R.drawable.lottery_bck_6);break;
                    case 6:  setbac(holder,R.drawable.lottery_bck_7);break;
                    case 7:  setbac(holder,R.drawable.lottery_bck_8);break;
                    case 8:  setbac(holder,R.drawable.lottery_bck_9);break;
                    case 9:  setbac(holder,R.drawable.lottery_bck_10);break;
                }
                break;
            case 2:
                holder.setText(R.id.text_view,"");
                setSype(holder,22,22);
                setSype(holder,2);
                if (!StringUtils.isEmpty(item))
                switch (Integer.parseInt(item)){
                    case 1:
                       holder.getView(R.id.text_view).setBackground(context.getResources().
                               getDrawable(R.mipmap.sz_1));
                        break;
                    case 2:
                        holder.getView(R.id.text_view).setBackground(context.getResources().
                                getDrawable(R.mipmap.sz_2));
                        break;
                    case 3:
                        holder.getView(R.id.text_view).setBackground(context.getResources().
                                getDrawable(R.mipmap.sz_3));
                        break;
                    case 4:
                        holder.getView(R.id.text_view).setBackground(context.getResources().
                                getDrawable(R.mipmap.sz_4));
                        break;
                    case 5:
                        holder.getView(R.id.text_view).setBackground(context.getResources().
                                getDrawable(R.mipmap.sz_5));
                        break;
                    case 6:
                        holder.getView(R.id.text_view).setBackground(context.getResources().
                                getDrawable(R.mipmap.sz_6));
                        break;
                }
                break;
            case 3:
                setSype(holder,22,22);
                setSype(holder,2);
                holder.setText(R.id.text_view,item);
                holder.getView(R.id.text_view).setBackground(context.getResources().getDrawable(R.
                        drawable.win_other));
                holder.getView(R.id.text_view).setSelected(true);
                break;
            case 4:
                if (position ==getList().size()-1) {
                    holder.getView(R.id.add_tex).setVisibility(View.VISIBLE);
                }else {
                    holder.getView(R.id.add_tex).setVisibility(View.GONE);
                }

                setbac(holder,R.drawable.lottery_bck_4);
                break;
            case 7:
                setSype(holder,22,22);
                setSype(holder,2);
                holder.setText(R.id.text_view,item);
                holder.getView(R.id.text_view).setBackground(context.getResources().getDrawable(R.
                        drawable.win_other));
                holder.getView(R.id.text_view).setSelected(true);
                setAddVG(holder,position,0);
                holder.setText(R.id.add_tex,"=");
                break;
            case 9:
                holder.setText(R.id.text_view,item);
                holder.getView(R.id.text_view).setBackground(context.getResources().getDrawable(R.
                        drawable.win_other));
                holder.getView(R.id.text_view).setSelected(true);
                break;
            case 85:
                holder.setText(R.id.text_view,item);
                setSype(holder,22,22);
                setSype(holder,2);

                setbac(holder,R.drawable.shape_ticket_name_grayt);
                holder.getView(R.id.text_view).setSelected(false);
                break;
            case 86:
                holder.setText(R.id.text_view,item);
                setSype(holder,25,25);
                setSype(holder,2);

                setbac(holder,R.drawable.shape_ticket_name_grayt);
                holder.getView(R.id.text_view).setSelected(false);
                break;
            case 87:
//                LinearLayout.LayoutParams layoutParams =  new LinearLayout.LayoutParams(MeasureUtil.
//                        dip2px(context,35),MeasureUtil.dip2px(context,50));
//                layoutParams.leftMargin= MeasureUtil.dip2px(context,2);
//                holder.getView(R.id.lottery_lin).setLayoutParams(layoutParams);

                setSype(holder,35,40);
                setSype(holder,3);
//                holder.setText(R.id.text_view,item);
//                holder.getView(R.id.add_tex).setVisibility(View.VISIBLE);
                ((TextView)holder.getView(R.id.text_view)).setTextColor(Color.parseColor
                        ("#2196f3"));

                switch (position){
                    case 0:
                        if (null!=listsColour&&listsColour.size()>0){
                            holder.getView(R.id.text_view).setBackground(context.getResources()
                                    .getDrawable(R.drawable.shape_ticket_name_select));
                        }else{
                            holder.getView(R.id.text_view).setBackground(context.getResources()
                                    .getDrawable(R.drawable.shape_ticket_name_select4));
                        }
                        break;
                        default:
                            if (listsColour.contains(position)){
                                holder.getView(R.id.text_view).setBackground(context.getResources()
                                        .getDrawable(R.drawable.shape_ticket_name_select4));
                            }else {
                                holder.getView(R.id.text_view).setBackground(context.getResources()
                                        .getDrawable(R.drawable.shape_ticket_name_select));
                            }
                            break;
                }

                switch (position){
                    case 0: holder.setText(R.id.text_view,"庄家");break;
                    case 1: holder.setText(R.id.text_view,"闲一");break;
                    case 2: holder.setText(R.id.text_view,"闲二");break;
                    case 3: holder.setText(R.id.text_view,"闲三");break;
                    case 4: holder.setText(R.id.text_view,"闲四");break;
                    case 5: holder.setText(R.id.text_view,"闲五");break;
                }


                Drawable drawable =null;
                if (!StringUtils.isEmpty(item)){
                    if (StringUtils.equals("没牛",item)){
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.wn));
                        drawable =context.getResources()
                                .getDrawable(R.drawable.wn);
                    }else if (StringUtils.equals("牛1",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n1);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n1));
                    }else if (StringUtils.equals("牛2",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n2);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n2));
                    }else if (StringUtils.equals("牛3",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n3);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n3));
                    }else if (StringUtils.equals("牛4",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n4);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n4));
                    }else if (StringUtils.equals("牛5",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n5);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n5));
                    }else if (StringUtils.equals("牛6",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n6);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n6));
                    }else if (StringUtils.equals("牛7",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n7);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n7));
                    } else if (StringUtils.equals("牛8",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n8);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n8));
                    } else if (StringUtils.equals("牛9",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.n9);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.n9));
                    }else if (StringUtils.equals("牛牛",item)){
                        drawable =context.getResources()
                                .getDrawable(R.drawable.nn);
//                        holder.getView(R.id.text_view).setBackground(context.getResources()
//                                .getDrawable(R.drawable.nn));
                    }

//                    drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());

                    ((TextView)holder.getView(R.id.text_view)).setCompoundDrawablesWithIntrinsicBounds
                            (null, null,null,drawable);
                }

//                ((TextView)holder.getView(R.id.text_view)).setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL);
//                ((TextView)holder.getView(R.id.text_view)).setTextSize(12);
//                ((TextView)holder.getView(R.id.text_view)).setTextColor(Color.parseColor
//                        ("#4583fc"));
//
//                switch (position){
//                    case 2:
//                        setbac(holder,R.drawable.shape_ticket_name_select4);
//                        break;
//                    case 4:
//                        setbac(holder,R.drawable.shape_ticket_name_select4);
//                        break;
//                        default:
//                            setbac(holder,R.drawable.shape_ticket_name_select);
//                            break;
//                }
                break;
            case 88:
                holder.setText(R.id.text_view,item);
                setSype(holder,25,25);
                setSype(holder,2);

                setbac(holder,R.drawable.shape_ticket_name_grayt);
                holder.getView(R.id.text_view).setSelected(false);

                ((TextView)holder.getView(R.id.text_view)).setTextColor(Color.parseColor
                        ("#4caf50"));
                break;
            case 89:
                holder.setText(R.id.text_view,item);
                setSype(holder,25,25);
                setSype(holder,2);

                setbac(holder,R.drawable.shape_ticket_name_grayt);
                holder.getView(R.id.text_view).setSelected(false);
                break;
            case 90:
                holder.setText(R.id.text_view,item);
                setSype(holder,25,25);
                setSype(holder,2);

                setbac(holder,R.drawable.shape_ticket_name_grayt);
                holder.getView(R.id.text_view).setSelected(false);
                break;
            case 99:
                holder.setText(R.id.text_view,item);
                setAddVG(holder, position,0);
                setSype(holder,25,25);
                setSype(holder,2);

                setbac(holder,R.drawable.shape_ticket_name_grayt);
                holder.getView(R.id.text_view).setSelected(false);
                break;
            case 10:
                if (position!=getList().size()-1) {
                    setSype(holder, 22, 22);
                    setSype(holder, 2);
                    holder.setText(R.id.text_view, item);
                    holder.getView(R.id.text_view).setBackground(context.getResources().getDrawable(R.
                            drawable.win_other));
                    holder.getView(R.id.text_view).setSelected(true);
                    setAddVG(holder, position, 0);
                    holder.setText(R.id.add_tex, "=");
                }else{
                    holder.setText(R.id.text_view,item);
                    setAddVG(holder, position,0);
                    setSype(holder,22,22);
                    setSype(holder,2);

                    if (0==NumUtil.NumColor1(Integer.parseInt(item))){
                        ((TextView)holder.getView(R.id.text_view)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
                        holder.getView(R.id.text_view).setBackground(context.getResources()
                                .getDrawable(R.drawable.ba_esh_50));
                    }else{
                        ((TextView)holder.getView(R.id.text_view)).setTextColor(Color.parseColor
                                ("#FF000000"));
                        holder.getView(R.id.text_view).setBackgroundResource(NumUtil.NumColor1(Integer.
                                parseInt(item)));
                    }

                    holder.getView(R.id.text_view).setSelected(true);
                    holder.setText(R.id.add_tex,"=");
                }
                break;
            case 11:
                holder.setText(R.id.text_view,item);
                setAddVG(holder, position,0);
                setSype(holder,30,30);
                setSype(holder,2);
                ((TextView)holder.getView(R.id.text_view)).setTextColor(context.getResources().getColor(R.color.white));
                holder.getView(R.id.text_view).setBackgroundResource(NumUtil.NumColorSolid(Integer.
                        parseInt(item)));

                holder.getView(R.id.text_view).setSelected(true);
                break;
            case 12:
                holder.setText(R.id.text_view,item);
                setAddVG(holder, position,0);
                setSype(holder,30,30);
                setSype(holder,2);

                setbac(holder,R.drawable.shape_ticket_name_grayt);
                holder.getView(R.id.text_view).setSelected(false);
                break;
        }

        if (Uiutils.setBaColor(context,null)){
            ((TextView)holder.getView(R.id.add_tex)).setTextColor(context.getResources()
            .getColor(R.color.color_white));
            ((TextView)holder.getView(R.id.text_view)).setTextColor(context.getResources()
                    .getColor(R.color.color_white));
        }

    }

    /**
     * 设置 边距
     * @param holder
     * @param num
     */
    private void setSype(BaseRecyclerHolder holder,int num) {
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) holder.getView(
                R.id.text_view).getLayoutParams();
        layoutParams.leftMargin= MeasureUtil.dip2px(context,num);
        holder.getView(R.id.text_view).setLayoutParams(layoutParams);

        LinearLayout.LayoutParams layoutParams1 = (LinearLayout.LayoutParams) holder.getView(
                R.id.add_tex).getLayoutParams();
        layoutParams1.leftMargin= MeasureUtil.dip2px(context,num);
        holder.getView(R.id.add_tex).setLayoutParams(layoutParams1);
    }

    /**
     * 设置 边距
     * @param holder
     * @param num
     */
    private void setSype(BaseRecyclerHolder holder,int num,boolean is) {
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) holder.getView(
                R.id.text_view).getLayoutParams();
        layoutParams.leftMargin= MeasureUtil.dip2px(context,num);
        holder.getView(R.id.text_view).setLayoutParams(layoutParams);
        holder.getView(R.id.add_tex).setLayoutParams(layoutParams);
    }

    /**
     * 设置 宽高
     * @param holder
     * @param
     */
    private void setSype(BaseRecyclerHolder holder,int width,int heigth) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MeasureUtil.
                dip2px(context,width),MeasureUtil.dip2px(context,heigth));
        holder.getView(R.id.text_view).setLayoutParams(layoutParams);
    }

    /**
     * 设置 宽高
     * @param holder
     * @param
     */
    private void setSype(BaseRecyclerHolder holder,int width,int heigth,int left) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MeasureUtil.
                dip2px(context,width),MeasureUtil.dip2px(context,heigth));
        layoutParams.setMargins(MeasureUtil.
                dip2px(context,left),0,0,0);
        holder.getView(R.id.text_view).setLayoutParams(layoutParams);
    }

    /**
     * 设置是否展示+
     * @param holder
     * @param position
     */
    private void setAddVG(BaseRecyclerHolder holder, int position,int num) {
        if (position == getList().size() - 1) {
            holder.getView(R.id.add_tex).setVisibility(View.VISIBLE);
        } else {
            holder.getView(R.id.add_tex).setVisibility(View.GONE);
        }

    }

    private void setbac(BaseRecyclerHolder holder,int id ) {
        holder.getView(R.id.text_view).setBackground(context.getResources().getDrawable(id));
        holder.getView(R.id.text_view).setSelected(true);
    }
}
