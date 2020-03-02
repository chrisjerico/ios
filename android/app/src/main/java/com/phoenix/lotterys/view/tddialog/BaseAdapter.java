package com.phoenix.lotterys.view.tddialog;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.ImageView;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by 天哥哥 on 2017/1/27 0003.
 */

public abstract class BaseAdapter<T> extends RecyclerView.Adapter<BaseViewHolder> {
    protected Context mContext;
    private LayoutInflater mInflater;
    public VoicePlayListener mListener;
    protected List<T> mList = new ArrayList<>();

    public BaseAdapter(Context context) {
        mContext = context;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public BaseViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new BaseViewHolder(mInflater.inflate(getLayoutId(), parent, false));
    }

    @Override
    public void onBindViewHolder(BaseViewHolder holder, int position) {
        onBindItemHolder(holder, position);
    }

    /**
     * this method is used to partial-refresh ,when picture is changed that will no flash
     *
     * @param holder
     * @param position
     * @param payloads
     */
    @Override
    public void onBindViewHolder(BaseViewHolder holder, int position, List<Object> payloads) {
        super.onBindViewHolder(holder, position, payloads);
        onBindItemHolder(holder, position);
    }

    public List<T> getList() {
        return mList;
    }

    public abstract int getLayoutId();

    public abstract void onBindItemHolder(BaseViewHolder holder, int position);

    @Override
    public int getItemCount() {
        return mList == null ? 0:mList.size();
    }

    public void setList(Collection<T> list) {
        mList.clear();
        mList.addAll(list);
        notifyDataSetChanged();
    }

    public void addAll(Collection<T> list) {
        int lastIndex = mList.size();
        if (mList.addAll(list)) {
            notifyItemRangeInserted(lastIndex, list.size());
        }
    }

    public void remove(int position) {
        if (position < 0 || position > mList.size() - 1) {
            return;
        }
        mList.remove(position);
        notifyItemRemoved(position);
        if (position != mList.size() - 1) { // 如果移除的是最后一个，忽略
            notifyItemRangeChanged(position, mList.size() - position);
        }
    }

    public void clear() {
        mList.clear();
        notifyDataSetChanged();
    }

    protected void myStartActivity(Class<?> tClass) {
        mContext.startActivity(new Intent(mContext, tClass));
    }

    protected void myStartActivity(Intent intent) {
        mContext.startActivity(intent);
    }

    protected void myStartActivity(Class<?> tClass, int enterAnim, int existAnim) {
        mContext.startActivity(new Intent(mContext, tClass));
        if (mContext instanceof Activity) {
            ((Activity) mContext).overridePendingTransition(enterAnim, existAnim);
        }
    }

    protected void myStartActivity(Intent intent, int enterAnim, int existAnim) {
        mContext.startActivity(intent);
        if (mContext instanceof Activity) {
            ((Activity) mContext).overridePendingTransition(enterAnim, existAnim);
        }
    }


    public interface VoicePlayListener {
        void onVoiceIconClick(ImageView imgView, String tag, String path);
    }

    public void setVoicePlayListener(VoicePlayListener listener) {
        mListener = listener;
    }
}
