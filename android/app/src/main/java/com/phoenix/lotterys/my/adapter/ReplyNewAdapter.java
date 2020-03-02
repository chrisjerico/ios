package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.CommentBean;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2020/1/4 14:09
 */
public class ReplyNewAdapter extends BaseRecyclerAdapter<CommentBean.DataBean.SecReplyList> {

    public ReplyNewAdapter(Context context, List<CommentBean.DataBean.SecReplyList> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, CommentBean.DataBean.SecReplyList item,
                        int position, boolean isScrolling) {

        if (position>2) {
            holder.getView(R.id.main_lin).setVisibility(View.GONE);
            return;
        }

        if (!StringUtils.isEmpty(item.getHeadImg())){
            ImageLoadUtil.loadRoundImage0(holder.getView(R.id.head_img),
                    item.getHeadImg(), 0);
        }else{
            ImageLoadUtil.ImageLoad(context,
                    R.drawable.head, holder.getView(R.id.head_img));
        }
        holder.setText(R.id.name_tex,item.getNickname()+" : ");
        holder.setText(R.id.context_tex,item.getContent());
    }
}
