package com.wanxiangdai.commonlibrary.base.recycler;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;



/**
 * @author : W
 * @e-mail :
 * @date : 2019/10/15 10:52
 * @description :
 */
public abstract class BaseAdapter<T> extends RecyclerView.Adapter<BaseHolder<T>> {

    public interface OnItemMoveListener {
        void onItemMove(int fromPosition, int toPosition);
    }

    private OnItemMoveListener onItemMoveListener;

    protected RecyclerView mRvList;

    protected Context mContext;

    protected List<T> mList = new ArrayList<>();

    protected abstract int bindXML(int viewType);

    protected abstract BaseHolder<T> getHolder(View view, int viewType);

    public BaseAdapter(RecyclerView rvList) {
        this.mRvList = rvList;
        mContext = mRvList.getContext();
    }

    @NonNull
    @Override
    public BaseHolder<T> onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return getHolder(LayoutInflater.from(parent.getContext()).inflate(bindXML(viewType), parent, false), viewType);
    }


    @Override
    public void onBindViewHolder(@NonNull BaseHolder<T> holder, int position, @NonNull List<Object> payloads) {
        holder.setChangeData(mList.get(position), position);
        if (payloads.isEmpty()) {
            holder.setData(mList.get(position), position);
        }
    }

    @Override
    public void onBindViewHolder(@NonNull BaseHolder<T> holder, int position) {
        //Ignore
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    public void bindRecyclerView(RecyclerView rv) {
        rv.setAdapter(this);
    }

    public List<T> getData() {
        return mList;
    }

    public T getItem(int position) {
        return mList.get(position);
    }

    public void clear() {
        int oldSize = mList.size();
        if (oldSize != 0) {
            mList.clear();
            notifyItemRangeRemoved(0, oldSize);
        }
    }

    public void setData(List<T> list) {
        int oldSize = mList.size();
        if (oldSize != 0) {
            mList.clear();
            notifyItemRangeRemoved(0, oldSize);
        }
        mList.addAll(list);
        notifyItemRangeInserted(0, mList.size());
    }

    public void setDataWithoutAnim(List<T> list) {
        if (list == null) {
            list = new ArrayList<>();
        }
        mList.clear();
        mList.addAll(list);
        notifyDataSetChanged();
    }

    public void addData(List<T> list) {
        addData(list, -1);
    }

    public void addData(List<T> list, int position) {
        if (position == -1) {
            int oldSize = mList.size();
            mList.addAll(list);
            notifyItemRangeInserted(oldSize, list.size());
        } else {
            mList.addAll(position, list);
            notifyItemRangeInserted(position, list.size());
        }
    }

    public void addData(T data) {
        addData(data, -1);
    }

    public void addData(T data, int position) {
        if (position == -1) {
            int size = mList.size();
            mList.add(data);
            notifyItemInserted(size);
        } else {
            mList.add(position, data);
            notifyItemInserted(position);
        }
    }

    public void replaceData(List<T> list) {
        if (list != null && !list.isEmpty()) {
            int oldSize = mList.size();
            mList.clear();
            notifyItemRangeRemoved(0, oldSize);
            mList.addAll(list);
            notifyItemRangeInserted(0, mList.size());
        }
    }

    public void replaceData(int start, List<T> list) {
        if (start < mList.size()) {
            int removeSize = mList.size() - start;
            mList.subList(start, mList.size()).clear();
            notifyItemRangeRemoved(start, removeSize);
        }
        mList.addAll(list);
        notifyItemRangeInserted(start, mList.size());
    }

    public void replaceDataWithOutAnim(int start, List<T> list) {
        if (start < mList.size()) {
            int removeSize = mList.size() - start;
            mList.subList(start, mList.size()).clear();
        }
        mList.addAll(list);
        notifyDataSetChanged();
    }

    public void removeData(int position) {
        if (position > mList.size()) {
            return;
        }
        mList.remove(position);
        notifyItemRemoved(position);
    }

    public void removeAll() {
        int size = mList.size();
        mList.clear();
        notifyItemRangeRemoved(0, size);
    }

    public void moveItem(int fromPosition, int toPosition) {
        Collections.swap(mList, fromPosition, toPosition);
        notifyItemMoved(fromPosition, toPosition);
        if (onItemMoveListener != null) {
            onItemMoveListener.onItemMove(fromPosition, toPosition);
        }
    }
}
