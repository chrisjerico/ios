package com.phoenix.lotterys.util;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

/**
 * Date:2019/4/18
 * TIME:15:57
 * author：Luke
 */
public class SpacesItemDecoration extends RecyclerView.ItemDecoration{
    private int dividerHeight;
    private Paint dividerPaint;
    private Context context;

    public SpacesItemDecoration(Context context) {
        this.context=context;
        dividerPaint = new Paint();
        dividerPaint.setColor(context.getResources().getColor(R.color.my_line));
        dividerHeight = context.getResources().getDimensionPixelSize(R.dimen.divider_height);
    }

    private int type;//1：为不要分割线; 2: 左右边距16dp ; 其它无边距
    public SpacesItemDecoration(Context context,int type) {
        this.context=context;
        dividerPaint = new Paint();
        dividerPaint.setColor(context.getResources().getColor(R.color.my_line));
        dividerHeight = context.getResources().getDimensionPixelSize(R.dimen.divider_height);
        this.type=type;
    }


    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);
        outRect.bottom = dividerHeight;
    }

    @Override
    public void onDraw(Canvas c, RecyclerView parent, RecyclerView.State state) {
        int childCount = parent.getChildCount();
        int left = parent.getPaddingLeft();
        int right = parent.getWidth() - parent.getPaddingRight();

        for (int i = 0; i < childCount - 1; i++) {
            View view = parent.getChildAt(i);
            float top = view.getBottom();
            float bottom = view.getBottom() + dividerHeight;
            switch (type){
                case 1:
                    c.drawRect(0, 0, 0, 0, dividerPaint);
                    break;
                case 2:
                    c.drawRect(left + MeasureUtil.dip2px(context,16), top,
                            right-MeasureUtil.dip2px(context,16), bottom, dividerPaint);
                    break;

                    default:
                        c.drawRect(left, top, right, bottom, dividerPaint);
                        break;
            }


        }
    }
}
