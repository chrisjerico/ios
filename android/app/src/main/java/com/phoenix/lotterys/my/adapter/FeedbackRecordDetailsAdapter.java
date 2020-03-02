package com.phoenix.lotterys.my.adapter;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.FeedbackRecordBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/12 16:00
 */
public class FeedbackRecordDetailsAdapter extends BaseRecyclerAdapter<FeedbackRecordBean.DataBean.ListBean> {

    private UserInfo userInfo;
    public FeedbackRecordDetailsAdapter(Context context, List<FeedbackRecordBean.DataBean.ListBean>
            list, int itemLayoutId) {
        super(context, list, itemLayoutId);
        this.userInfo =(UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);
    }

    @Override
    public void convert(BaseRecyclerHolder holder, FeedbackRecordBean.DataBean.ListBean item,
                        int position, boolean isScrolling) {
        if (position==0){
            holder.getView(R.id.title_tex).setVisibility(View.VISIBLE);
        }else {
            holder.getView(R.id.title_tex).setVisibility(View.GONE);
        }

        if (!StringUtils.isEmpty(item.getType())&&StringUtils.equals("1",item.getType())){
            holder.setText(R.id.title_tex,"我要投诉");
        }else {
            holder.setText(R.id.title_tex,"我要建议");
        }
//        userInfo.getData().getUsr()
        if (null!=userInfo&&null!=userInfo.getData()&&!StringUtils.isEmpty(userInfo.getData().getUsr())&&
                StringUtils.equals(item.getUserName(),userInfo.getData().getUsr())){
            ((TextView)holder.getView(R.id.context_tex)).setTextColor(context.getResources().getColor(R.
                    color.color_ffbc2e));

            ((TextView)holder.getView(R.id.time_tex)).setTextColor(context.getResources().getColor(R.
                    color.fount2));
        }else{
            ((TextView)holder.getView(R.id.context_tex)).setTextColor(context.getResources().getColor(R.
                    color.color_FF00001));

            ((TextView)holder.getView(R.id.time_tex)).setTextColor(context.getResources().getColor(R.
                    color.fount1));
        }


        holder.setText(R.id.context_tex,item.getContent());
        holder.setText(R.id.time_tex,"提交时间："+ StampToDate.stampToDates(
                Long.parseLong(item.getCreateTime())*1000,1));


    }
}
