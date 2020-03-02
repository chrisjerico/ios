package com.phoenix.lotterys.view;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;


import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.bean.RoomListBean;
import com.wanxiangdai.commonlibrary.base.recycler.BaseAdapter;
import com.wanxiangdai.commonlibrary.base.recycler.BaseHolder;

import java.lang.ref.WeakReference;
import java.util.List;

import butterknife.BindView;

/**
 * @author : W
 * @e-mail : w
 * @date : 2020/01/07 13:56
 * @description :
 */
public class ChatRoomListWindow extends PopupWindow {

    public interface OnItemClickListener {
        void onItemClick(int position, RoomListBean.DataBean.ChatAryBean bean);
    }

    private WeakReference<Context> mContext;

    private RecyclerView rvList;
    private ListAdapter mAdapter;

    public ChatRoomListWindow(Context context, List<RoomListBean.DataBean.ChatAryBean> list) {
        super(context);

        mContext = new WeakReference<>(context);

        setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        setHeight(ViewGroup.LayoutParams.MATCH_PARENT);

        View view = LayoutInflater.from(context).inflate(R.layout.window_chat_room_list, null, false);
        setContentView(view);

        rvList = view.findViewById(R.id.rv_list);
        rvList.setLayoutManager(new LinearLayoutManager(context));
        mAdapter = new ListAdapter(rvList);
        rvList.setAdapter(mAdapter);
        mAdapter.setDataWithoutAnim(list);

        view.findViewById(R.id.fl_parent).setOnClickListener(v -> dismiss());
        view.findViewById(R.id.btn_cancel).setOnClickListener(v -> dismiss());

        setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        setOutsideTouchable(true);
    }

    public int getRoomNum() {
        return mAdapter.getItemCount();
    }

    public RoomListBean.DataBean.ChatAryBean getFirstChatBean() {
        if (mAdapter.getItemCount() != 0) {
            return mAdapter.getItem(0);
        }
        return null;
    }

    public RoomListBean.DataBean.ChatAryBean setCheck(String roomId) {
        return mAdapter.setCheck(roomId);
    }

    public void setOnItemClickListener(OnItemClickListener mOnItemClickListener) {
        mAdapter.setOnItemClickListener(mOnItemClickListener);
    }

    public void show(View parent, float x, float y) {
        dismiss();
        super.showAtLocation(parent, Gravity.CENTER, 0, 0);
    }

    public class ListAdapter extends BaseAdapter<RoomListBean.DataBean.ChatAryBean> {

        private int checkedPosition = 0;
        private OnItemClickListener mOnItemClickListener;

        public ListAdapter(RecyclerView rvList) {
            super(rvList);
        }

        @Override
        protected int bindXML(int viewType) {
            return R.layout.item_chat_room;
        }

        @Override
        protected BaseHolder<RoomListBean.DataBean.ChatAryBean> getHolder(View view, int viewType) {
            return new NormalHolder(view);
        }

        public void setOnItemClickListener(OnItemClickListener mOnItemClickListener) {
            this.mOnItemClickListener = mOnItemClickListener;
        }

        public RoomListBean.DataBean.ChatAryBean setCheck(String roomId) {
            for (int i = 0; i < getItemCount(); i++) {
                if (getItem(i).getRoomId().equals(roomId)) {
                    int oldPosition = checkedPosition;
                    checkedPosition = i;
                    notifyItemChanged(oldPosition, 1);
                    notifyItemChanged(i, 1);
                    return getItem(i);
                }
            }
            return null;
        }

        public class NormalHolder extends BaseHolder<RoomListBean.DataBean.ChatAryBean> implements View.OnClickListener {

            @BindView(R2.id.iv_checked)
            ImageView ivChecked;
            @BindView(R2.id.tv_name)
            TextView tvName;
            @BindView(R2.id.view_line)
            View viewLine;

            public NormalHolder(@NonNull View itemView) {
                super(itemView);
            }

            @Override
            public void setData(RoomListBean.DataBean.ChatAryBean data, int position) {
//                if (position == getItemCount() - 1) {
//                    viewLine.setVisibility(View.GONE);
//                } else {
//                    viewLine.setVisibility(View.VISIBLE);
//                }

                ivChecked.setVisibility(View.GONE);

                tvName.setText(data.getRoomName());

                mParentView.setOnClickListener(this);
            }

            @Override
            public void setChangeData(RoomListBean.DataBean.ChatAryBean data, int position) {
//                if (checkedPosition == position) {
//                    ivChecked.setVisibility(View.VISIBLE);
//                } else {
//                    ivChecked.setVisibility(View.INVISIBLE);
//                }
            }

            @Override
            public void onClick(View v) {
                if (mOnItemClickListener != null) {
                    mOnItemClickListener.onItemClick(getAdapterPosition(), getItem(getAdapterPosition()));
                }
                dismiss();
            }
        }
    }
}
