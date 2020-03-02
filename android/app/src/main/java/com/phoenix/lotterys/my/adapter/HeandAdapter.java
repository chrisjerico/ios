package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.HeandBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/20 15:30
 */
public class HeandAdapter extends BaseRecyclerAdapter<HeandBean.DataBean> {

    public HeandAdapter(Context context, List<HeandBean.DataBean> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, HeandBean.DataBean item, int position,
                        boolean isScrolling) {

        if (!StringUtils.isEmpty(item.getUrl())) {
            ImageLoadUtil.loadRoundImage(holder.getView(R.id.image),
                    item.getUrl(), 0,R.drawable.head);
        } else {
            ImageLoadUtil.ImageLoad(context, R.drawable.head, holder.getView(R.id.image));
        }

        if (position==0){
        holder.getView(R.id.spacing_tex).setVisibility(View.GONE);
        }else{
            holder.getView(R.id.spacing_tex).setVisibility(View.VISIBLE);
        }

    }
}
