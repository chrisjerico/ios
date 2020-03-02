package com.phoenix.lotterys.view.tddialog;

import android.content.Context;
import androidx.annotation.ColorInt;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

import java.util.HashMap;
import java.util.Map;


public class DialogAdapter extends BaseAdapter<String> {
    private onItemClickListener mListener;
    private
    @ColorInt
    int mTextColor;
    private int mTextSize;
    private Map<Integer, Integer> mColorMap;
    private Map<Integer, Integer> mSizeMap;

    public DialogAdapter(Context context) {
        super(context);
    }

    public void setOnItemClickListener(onItemClickListener listener) {
        mListener = listener;
    }

    @Override
    public int getLayoutId() {
        return R.layout.dialog_item;
    }

    @Override
    public void onBindItemHolder(BaseViewHolder holder, final int position) {
        TextView contentTV = holder.getView(R.id.dialog_item_tv);
        if (mTextColor != 0) {
            contentTV.setTextColor(mTextColor);
        }
        if (mColorMap != null && mColorMap.get(position) != null) {
            Log.i("itemcolor",position+"            "+mColorMap.get(position));
            contentTV.setTextColor(mColorMap.get(position));
        }
        if (mTextSize != 0) {
            contentTV.setTextSize(mTextSize);
        }
        if (mSizeMap != null && mSizeMap.get(position) != null) {
            contentTV.setTextSize(mSizeMap.get(position));
        }
        if (position == getItemCount() - 1)
            contentTV.setBackgroundResource(R.drawable.bg_item_bottom);
        else contentTV.setBackgroundResource(R.drawable.bg_item);
        String text = mList.get(position);
        contentTV.setText(TextUtils.isEmpty(text) ? "" : text);
        contentTV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mListener != null) {
                    mListener.onItemClick(position);
                }
            }
        });
    }

    public interface onItemClickListener {
        void onItemClick(int position);
    }
    //------------------------------------样式扩展---------------------------------

    public void setTextColor(int textColor) {
        mTextColor = textColor;
        notifyDataSetChanged();
    }

    public void setTextSize(int textSize) {
        mTextSize = textSize;
        notifyDataSetChanged();
    }

    public void setTextColorAt(int position, int textColor) {
        if (mColorMap == null) {
            mColorMap = new HashMap<>();
        }
        mColorMap.put(position, textColor);
        notifyDataSetChanged();
    }

    public void setTextSizeAt(int position, int textSize) {
        if (mSizeMap == null) {
            mSizeMap = new HashMap<>();
        }
        mSizeMap.put(position, textSize);
        notifyDataSetChanged();
    }
}
