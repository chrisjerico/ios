package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.ApplyMosaicGoldBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/3 16:54
 */
public class ApplyMosaicGoledapterB extends BaseRecyclerAdapter<ApplyMosaicGoldBean.DataBean.ListBean> {

    public ApplyMosaicGoledapterB(Context context, List<ApplyMosaicGoldBean.DataBean.ListBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    private int type;
    public ApplyMosaicGoledapterB(Context context, List<ApplyMosaicGoldBean.DataBean.ListBean> list,
                                  int itemLayoutId, int type) {
        super(context, list, itemLayoutId);
        this.type=type;
    }

    @Override
    public void convert(BaseRecyclerHolder holder, ApplyMosaicGoldBean.DataBean.ListBean item,
                        int position, boolean isScrolling) {

        switch (type){
            case 1:
                if (!StringUtils.isEmpty(item.getParam().getWin_apply_image())) {
                    ImageLoadUtil.ImageLoad(context, item.getParam().getWin_apply_image(), (ImageView) holder
                            .getView(R.id.apply_img), R.drawable.winapply_default);
                    holder.getView(R.id.title_tex).setVisibility(View.GONE);
                }else{
                    ImageLoadUtil.ImageLoad(context, R.drawable.winapply_default, (ImageView) holder
                            .getView(R.id.apply_img), R.drawable.winapply_default);
                    holder.setText(R.id.title_tex,item.getName());
                    holder.getView(R.id.title_tex).setVisibility(View.VISIBLE);
                }

                holder.getView(R.id.apply_tex).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Log.e("onClick===","////");
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.APPLY_MOSAIC_GOLD,position));
                    }
                });
                break;
            case 2:
                holder.getView(R.id.apply_gold_lin).setVisibility(View.GONE);
                holder.getView(R.id.apply_lin).setVisibility(View.VISIBLE);

                holder.setText(R.id.text1,item.getUpdateTime());
                holder.setText(R.id.text2,item.getAmount());
                holder.setText(R.id.text3,item.getState());

                ((TextView)holder.getView(R.id.text1)).setTextColor(context.getResources()
                .getColor(R.color.color_white));
                ((TextView)holder.getView(R.id.text2)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
                ((TextView)holder.getView(R.id.text3)).setTextColor(context.getResources()
                        .getColor(R.color.color_white));
                break;
        }

    }
}
