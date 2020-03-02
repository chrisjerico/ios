package com.phoenix.lotterys.my.adapter;

import android.content.Context;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/3 16:54
 */
public class FeedbackAdapter extends BaseRecyclerAdapter<String> {

    public FeedbackAdapter(Context context, List<String> list, int itemLayoutId) {
        super(context, list, itemLayoutId);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, String item, int position, boolean isScrolling) {

        holder.setText(R.id.context_tex, item);

        switch (position){
            case 0: holder.setText(R.id.title_tex, context
                    .getResources().getString(R.string.online_service));

            holder.setImageByUrl(R.id.icon_img,R.drawable.zxkf);
            break;
            case 1: holder.setText(R.id.title_tex,  context
                    .getResources().getString(R.string.recommendation_feedback));

                holder.setImageByUrl(R.id.icon_img,R.drawable.jyfk);
            break;
            case 2: holder.setText(R.id.title_tex, context
                    .getResources().getString(R.string.complaint_suggestions));

                holder.setImageByUrl(R.id.icon_img,R.drawable.tsjy);
            break;
            case 3: holder.setText(R.id.title_tex, context
                    .getResources().getString(R.string.feedback_record));

                holder.setImageByUrl(R.id.icon_img,R.drawable.fkjl);
            break;
        }
    }
}
