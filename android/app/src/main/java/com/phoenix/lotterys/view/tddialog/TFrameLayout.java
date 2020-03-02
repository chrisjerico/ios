package com.phoenix.lotterys.view.tddialog;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.FrameLayout;


public class TFrameLayout extends FrameLayout {
    public TFrameLayout(Context context) {
        super(context);
    }

    public TFrameLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public TFrameLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return true;
    }
}
