package com.phoenix.lotterys.util;

import android.graphics.Rect;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

public class SpacesItem extends RecyclerView.ItemDecoration{
    private int space;

    public SpacesItem(int space) {
        this.space = space;
    }

    @Override
    public void getItemOffsets(Rect outRect, View view,
                               RecyclerView parent, RecyclerView.State state) {
        outRect.left = space;
        outRect.right = space;
        //解决Item之间总是有空隙的问题,根据需要设置左右间隔为负数解决问题
        outRect.bottom = space;

    }
}
