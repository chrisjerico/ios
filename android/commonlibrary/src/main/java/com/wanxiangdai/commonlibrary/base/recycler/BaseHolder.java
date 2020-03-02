package com.wanxiangdai.commonlibrary.base.recycler;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import butterknife.ButterKnife;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/10/15 10:52
 * @description :
 */
public abstract class BaseHolder<T> extends RecyclerView.ViewHolder {

    public static final int ID_PARENT = 0x55342119;

    protected Context mContext;
    protected View mParentView;

    public BaseHolder(@NonNull View itemView) {
        super(itemView);

        mContext = itemView.getContext();
        mParentView = itemView;
        ButterKnife.bind(this, itemView);
        if (mParentView.getId() == -1) {
            mParentView.setId(ID_PARENT);
        }
    }

    public abstract void setData(T data, int position);

    public void setChangeData(T data, int position) {
        //Ignore
    }
}