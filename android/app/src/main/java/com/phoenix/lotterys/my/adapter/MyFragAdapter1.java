package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.ImageView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.fragment.MyFragment1;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.phoenix.lotterys.view.BadgeHelper;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/9/25 19:11
 */
public class MyFragAdapter1 extends BaseRecyclerAdapter<My_item> {
    BadgeHelper badgeHelperC;
    public MyFragAdapter1(Context context, List<My_item> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    private List<My_item> listColor =new ArrayList<>();

    public MyFragAdapter1(Context context, List<My_item> list, int itemLayoutId,MyFragment1.
            OnItemListener onItemListener,int type) {
        super(context, list, itemLayoutId);
        this.onItemListener=onItemListener;
        this.type =type;
        addColor();
    }

    private String[] titleAlias;
    private String[] color;
    private void addColor() {
        switch (type){
            case 1:
                 titleAlias = context.getResources().getStringArray(R.array.my_list_alias);
                 color = context.getResources().getStringArray(R.array.color1);
                break;
            case 2 :
                titleAlias = context.getResources().getStringArray(R.array.coloAlias2);
                color = context.getResources().getStringArray(R.array.color2);
                break;
                default:
                    titleAlias = context.getResources().getStringArray(R.array.my_list_alias);
                    color = context.getResources().getStringArray(R.array.color3);
                    break;
        }
        if (titleAlias.length>0&&color.length>0){
            for (int i  =0;i<titleAlias.length;i++){
                listColor.add(new My_item(0,color[i],titleAlias[i]));
            }
        }
    }

    private int type ;
    private MyFragment1.OnItemListener onItemListener;

    @Override
    public void convert(BaseRecyclerHolder holder, My_item item, int position, boolean isScrolling) {



//        if (position==getList().size()-1)
//            holder.getView(R.id.tex).setVisibility(View.GONE);
//        else
//            holder.getView(R.id.tex).setVisibility(View.GONE);

        if (type==2) {
            holder.getView(R.id.main_lin).setBackground(null);
        }else  if (type!=1) {
            if (ShareUtils.getInt(context, "ba_tbottom", 0) != 0) {
                holder.getView(R.id.main_lin).setBackgroundColor(context
                        .getResources().getColor(ShareUtils.getInt(context, "ba_tbottom", 0)));
            }
        }

        holder.setText(R.id.text,item.getTitle());
        if (!StringUtils.isEmpty(item.getLogo())){
            ImageLoadUtil.ImageLoad(context,item.getLogo(),holder.getView(R.id.img));
        } else if (0!=item.getImg()){
            ImageLoadUtil.ImageLoad(context,item.getImg(),holder.getView(R.id.img));
        }else{
            ImageLoadUtil.ImageLoad(context,R.drawable.load_img_failure,holder.getView(R.id.img));
        }

        if (StringUtils.isEmpty(item.getLogo())&&listColor.size()>0&& !StringUtils.isEmpty(item.getAlias())){
            for (My_item my_item :listColor){
                if (StringUtils.equals(my_item.getAlias(),item.getAlias())){
                    ((ImageView)holder.getView(R.id.img)).setColorFilter(
                            Color.parseColor(my_item.getTitle()));
                    break;
                }
            }
        }else{
            ((ImageView)holder.getView(R.id.img)).setColorFilter(0);
        }

        holder.getView(R.id.main_lin).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onItemListener.onItemClick(v,item);
            }
        });

        if (item.getAlias().equals("znx")&&!StringUtils.isEmpty(item.getMess())&&
        !StringUtils.equals("0",item.getMess())){
            holder.getView(R.id.watie_tex).setVisibility(View.VISIBLE);
            try {
                int count = Integer.parseInt(item.getMess());
                if(count>99){
                    Uiutils.setText( holder.getView(R.id.watie_tex),"99+");
                }else {
                    Uiutils.setText( holder.getView(R.id.watie_tex),item.getMess());
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }

        }else{
            holder.getView(R.id.watie_tex).setVisibility(View.GONE);
        }

//        if (item.getAlias().equals("znx")&&! TextUtils.isEmpty(item.getMess())&& ShowItem.isNumeric(item.getMess())) {
//            new QBadgeView(context).bindTarget(holder.getView(R.id.ll_my)).setBadgeGravity(Gravity.TOP|Gravity.END).
//                    setBadgeBackgroundColor(context.getResources().getColor(R.color.color_FF2600)).
//                    setBadgeNumber(Integer.parseInt(item.getMess()));
//        }else {
//            new QBadgeView(context).bindTarget(holder.getView(R.id.ll_my)).setBadgeGravity(Gravity.TOP|Gravity.END).
//                    setBadgeBackgroundColor(context.getResources().getColor(R.color.color_FF2600)).
//                    setBadgeNumber(0);
//        }
    }
}
