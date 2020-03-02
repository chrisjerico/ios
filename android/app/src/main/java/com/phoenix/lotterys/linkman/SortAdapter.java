package com.phoenix.lotterys.linkman;

import android.content.Context;
import android.os.Bundle;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.bean.MailFragBean;
import com.phoenix.lotterys.my.fragment.PubAttentionFrag;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.List;

/**
 * @author: xp
 * @date: 2017/7/19
 */

public class SortAdapter extends RecyclerView.Adapter<SortAdapter.ViewHolder> {
    private LayoutInflater mInflater;
    private List<MailFragBean.DataBean.ListBean> mData;
    private Context mContext;

    public SortAdapter(Context context, List<MailFragBean.DataBean.ListBean> data) {
        mInflater = LayoutInflater.from(context);
        mData = data;
        this.mContext = context;
    }

    @Override
    public SortAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.link_item, parent,false);
        ViewHolder viewHolder = new ViewHolder(view);
        viewHolder.tvTag = (TextView) view.findViewById(R.id.tag);
        viewHolder.tvName = (TextView) view.findViewById(R.id.name);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(final SortAdapter.ViewHolder holder, final int position) {
        int section = getSectionForPosition(position);
        //如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        int section1 = getPositionForSection(section);
        if (position == section1) {
            holder.tvTag.setVisibility(View.VISIBLE);
            if (StringUtils.isEmpty(mData.get(position).getLetters())){
                holder.tvTag.setText("热门推荐");
            }else{
                holder.tvTag.setText(mData.get(position).getLetters().toUpperCase());
            }
        } else {
            holder.tvTag.setVisibility(View.GONE);
        }

        if (mOnItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mOnItemClickListener.onItemClick(holder.itemView, position);
                }
            });

        }

        holder.tvName.setText(this.mData.get(position).getName());

        holder.tvName.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Bundle  build = new Bundle();
                build.putInt("type", 4);
                build.putString("main_id", "5");
                build.putString("id", ((MailFragBean.DataBean.ListBean) mData.get(position)).getId());
                FragmentUtilAct.startAct(mContext, new PubAttentionFrag(), build);

            }
        });

    }

    @Override
    public int getItemCount() {
        if (null!=mData&&mData.size()>0){
            return mData.size();
        }else {
            return 0;
        }
    }

    //**********************itemClick************************
    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    private OnItemClickListener mOnItemClickListener;

    public void setOnItemClickListener(OnItemClickListener mOnItemClickListener) {
        this.mOnItemClickListener = mOnItemClickListener;
    }
    //**************************************************************

    public static class ViewHolder extends RecyclerView.ViewHolder {
        TextView tvTag, tvName;

        public ViewHolder(View itemView) {
            super(itemView);
        }
    }

    /**
     * 提供给Activity刷新数据
     * @param list
     */
    public void updateList(List<MailFragBean.DataBean.ListBean> list){
        this.mData = list;
        notifyDataSetChanged();
    }

    public Object getItem(int position) {
        return mData.get(position);
    }

    /**
     * 根据ListView的当前位置获取分类的首字母的char ascii值
     */
    public int getSectionForPosition(int position) {
        if (StringUtils.isEmpty(mData.get(position).getLetters())){
            return "!".charAt(0);
        }else{
            return mData.get(position).getLetters().toUpperCase().charAt(0);
        }

    }

    /**
     * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
     */
    public int getPositionForSection(int section) {
        for (int i = 0; i < mData.size(); i++) {
            String sortStr = mData.get(i).getLetters();

            if (StringUtils.isEmpty(sortStr)){
                char firstChar = "!".charAt(0);
                if (firstChar == section) {
                    return i;
                }
            }else{
                char firstChar = sortStr.toUpperCase().charAt(0);
                if (firstChar == section) {
                    return i;
                }
            }
        }
        return -1;
    }

}
