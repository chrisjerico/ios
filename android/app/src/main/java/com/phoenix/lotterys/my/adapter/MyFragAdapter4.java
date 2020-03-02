package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.fragment.MyFragment1;
import com.phoenix.lotterys.my.fragment.MyFragment2;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.phoenix.lotterys.view.BadgeHelper;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import q.rorbin.badgeview.QBadgeView;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/9/25 19:11
 */
public class MyFragAdapter4 extends BaseRecyclerAdapter<My_item> {
    BadgeHelper badgeHelperC;
    public MyFragAdapter4(Context context, List<My_item> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    private List<My_item> listColor =new ArrayList<>();

    public MyFragAdapter4(Context context, List<My_item> list, int itemLayoutId, MyFragment2.
            OnItemListener onItemListener, int type) {
        super(context, list, itemLayoutId);
        this.onItemListener=onItemListener;
        this.type =type;
//        addColor();
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
            for (int i  =0;i<color.length;i++){
                listColor.add(new My_item(0,color[i],titleAlias[i]));
            }
        }
    }

    private int type ;
    private MyFragment2.OnItemListener onItemListener;

    @Override
    public void convert(BaseRecyclerHolder holder, My_item item, int position, boolean isScrolling) {



        if (position==getList().size()-1)
            holder.getView(R.id.tex).setVisibility(View.GONE);
        else
            holder.getView(R.id.tex).setVisibility(View.GONE);

        if (type==2||type==10) {
            holder.getView(R.id.main_lin).setBackground(null);
        }else  if (type!=1) {
            if (ShareUtils.getInt(context, "ba_tbottom", 0) != 0) {
                holder.getView(R.id.main_lin).setBackgroundColor(context
                        .getResources().getColor(ShareUtils.getInt(context, "ba_tbottom", 0)));
            }
        }

        holder.setText(R.id.text,item.getTitle());
        if (0!=item.getImg()){
            ImageLoadUtil.ImageLoad(context,item.getImg(),holder.getView(R.id.img));
        }else{
            ImageLoadUtil.ImageLoad(context,R.drawable.load_img_failure,holder.getView(R.id.img));
        }

        if (type!=10)
        if (listColor.size()>0&& !StringUtils.isEmpty(item.getAlias())){
            for (My_item my_item :listColor){
                if (StringUtils.equals(my_item.getAlias(),item.getAlias())){
                    ((ImageView)holder.getView(R.id.img)).setColorFilter(
                            Color.parseColor(my_item.getTitle()));
                    break;
                }
            }
        }

        holder.getView(R.id.main_lin).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onItemListener.onItemClick(v,item);
            }
        });

        if (item.getAlias().equals("znx")&&! TextUtils.isEmpty(item.getMess())&& ShowItem.isNumeric(item.getMess())) {
            new QBadgeView(context).bindTarget(holder.getView(R.id.ll_my)).setBadgeGravity(Gravity.CENTER|Gravity.END).
                    setBadgeBackgroundColor(context.getResources().getColor(R.color.color_FF2600)).
                    setBadgeNumber(Integer.parseInt(item.getMess()));
        }else {
            new QBadgeView(context).bindTarget(holder.getView(R.id.ll_my)).setBadgeGravity(Gravity.CENTER|Gravity.END).
                    setBadgeBackgroundColor(context.getResources().getColor(R.color.color_FF2600)).
                    setBadgeNumber(0);
        }
    }
}
