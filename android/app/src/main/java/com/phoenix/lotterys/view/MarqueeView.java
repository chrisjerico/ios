package com.phoenix.lotterys.view;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import androidx.recyclerview.widget.RecyclerView;
import android.util.AttributeSet;
import android.view.MotionEvent;

/**
 * @author: sq
 * @date: 2017/9/19
 * @corporation:
 * @description: 自定义RecyclerView，显示跑马灯效果
 */
public class MarqueeView extends RecyclerView {

    private Context mContext;
    private Runnable mRunnable;
    private static final Handler HANDLER = new Handler(Looper.getMainLooper());

    public MarqueeView(Context context) {
        this(context, null);
    }

    public MarqueeView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public MarqueeView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    private void init(Context context) {
        mContext = context;
        mRunnable = new Runnable() {
            @Override
            public void run() {
                scrollBy(2, 2);
                HANDLER.postDelayed(this, 100);
            }
        };
    }

    public void startScroll() {
        HANDLER.postDelayed(mRunnable, 100);
    }

    public void stopScroll() {
        HANDLER.removeCallbacks(mRunnable);
    }

    /**
     * 重写该方法，使其touch事件被分发，以致不可被触摸滑动和点击
     *
     * @param e
     * @return
     */
    @Override
    public boolean onTouchEvent(MotionEvent e) {
        return true;
    }
}
