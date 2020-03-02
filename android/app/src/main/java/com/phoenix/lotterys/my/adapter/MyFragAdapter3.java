package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/9/25 19:11
 */
public class MyFragAdapter3 extends BaseRecyclerAdapter<My_item> {
    public MyFragAdapter3(Context context, List<My_item> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    private List<My_item> listColor =new ArrayList<>();

    public MyFragAdapter3(Context context, List<My_item> list, int itemLayoutId, Uiutils.
            OnItemListener onItemListener) {
        super(context, list, itemLayoutId);
        this.onItemListener=onItemListener;
    }

    private Uiutils.OnItemListener onItemListener;

    @Override
    public void convert(BaseRecyclerHolder holder, My_item item, int position, boolean isScrolling) {
        ((TextView)holder.getView(R.id.text)).setTextColor(context.getResources().getColor(R.color.white));
        holder.setText(R.id.text,item.getTitle());
        if (!StringUtils.isEmpty(item.getLogo())){
            ImageLoadUtil.ImageLoad(context,item.getLogo(),holder.getView(R.id.img));
        } else if (0!=item.getImg()){
            ImageLoadUtil.ImageLoad(context,item.getImg(),holder.getView(R.id.img));
        }else{
            ImageLoadUtil.ImageLoad(context,R.drawable.load_img_failure,holder.getView(R.id.img));
        }

        if (StringUtils.isEmpty(item.getLogo())) {
            ((ImageView) holder.getView(R.id.img)).setColorFilter(context.getResources().getColor(
                    R.color.white
            ));
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
    }
}
