package com.phoenix.lotterys.chat.adapter;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.chat.entity.ChatListEntity;
import com.phoenix.lotterys.util.EmojiUtils;
import com.sunhapper.x.spedit.view.SpXTextView;
import com.wanxiangdai.commonlibrary.base.recycler.BaseAdapter;
import com.wanxiangdai.commonlibrary.base.recycler.BaseHolder;
import butterknife.BindView;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/26 10:33
 * @description :
 */
public class ChatListAdapter extends BaseAdapter<ChatListEntity.DataBean.ConversationListBean> {

    public interface OnItemClickListener {
        void onItemClick(ChatListEntity.DataBean.ConversationListBean bean);
    }

    private boolean mIsMessage;
    private OnItemClickListener mOnItemClickListener;

    public ChatListAdapter(RecyclerView rvList, boolean isMessage) {
        super(rvList);
        mIsMessage = isMessage;
    }

    @Override
    protected int bindXML(int viewType) {
        return R.layout.item_chat_normal;
    }

    @Override
    protected BaseHolder<ChatListEntity.DataBean.ConversationListBean> getHolder(View view, int viewType) {
        return new NormalHolder(view);
    }

    public void setOnItemClickListener(OnItemClickListener mOnItemClickListener) {
        this.mOnItemClickListener = mOnItemClickListener;
    }

    public class NormalHolder extends BaseHolder<ChatListEntity.DataBean.ConversationListBean> implements View.OnClickListener {

        @BindView(R2.id.iv_icon)
        ImageView ivIcon;
        @BindView(R2.id.tv_unread_num)
        TextView tvUnreadNum;
        @BindView(R2.id.tv_name)
        TextView tvName;
        @BindView(R2.id.tv_last_message)
        SpXTextView tvLastMessage;
        @BindView(R2.id.tv_time)
        TextView tvTime;

        public NormalHolder(@NonNull View itemView) {
            super(itemView);
        }

        @Override
        public void setData(ChatListEntity.DataBean.ConversationListBean data, int position) {
            switch (data.getType()) {
                case 1:
                    ivIcon.setImageResource(R.mipmap.qzxxhdpi);
                    tvName.setText(data.getRoomName());
                    tvUnreadNum.setText(String.valueOf(data.getUnreadCount()));
                    if (data.getLastMessageInfo() != null) {
                        if (data.getLastMessageInfo().isBetFollowFlag()) {
                            tvLastMessage.setText("[投注分享]");
                        } else if (data.getLastMessageInfo().getData_type().equals("image")) {
                            tvLastMessage.setText("[图片]");
                        } else if (data.getLastMessageInfo().getData_type().equals("redBag")) {
                            tvLastMessage.setText("[红包]");
                        } else {
                            tvLastMessage.setText(EmojiUtils.convert(mContext, data.getLastMessageInfo().getMsg()));
                        }
                        tvTime.setText(data.getLastMessageInfo().getTime());

                        tvLastMessage.setVisibility(View.VISIBLE);
                        tvTime.setVisibility(View.VISIBLE);
                    } else {
                        tvLastMessage.setVisibility(View.GONE);
                        tvTime.setVisibility(View.GONE);
                    }
                    break;
                default:
                    if (data.getType() == 2) {
                        ivIcon.setImageResource(R.mipmap.glyxxhdpi);
                    } else {
                        ivIcon.setImageResource(R.mipmap.kfxxhdpi);
                    }
                    tvName.setText(data.getNickname());
                    tvLastMessage.setVisibility(View.GONE);
                    tvTime.setVisibility(View.GONE);
            }
            if (mIsMessage) {
                tvUnreadNum.setVisibility(data.getUnreadCount() == 0 ? View.GONE : View.VISIBLE);
            } else {
                tvUnreadNum.setVisibility(View.GONE);
            }

            mParentView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            if (getAdapterPosition() != -1 && mOnItemClickListener != null) {
                switch (v.getId()) {
                    case ID_PARENT:
                        mOnItemClickListener.onItemClick(getItem(getAdapterPosition()));
                        break;
                }
            }
        }
    }
}
