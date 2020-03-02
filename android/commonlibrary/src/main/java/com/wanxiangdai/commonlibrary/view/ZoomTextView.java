package com.wanxiangdai.commonlibrary.view;

import android.content.Context;
import androidx.appcompat.widget.AppCompatTextView;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;

import com.wanxiangdai.commonlibrary.R;


/**
 * Created by Ykai on 2018/7/10.
 * 点击缩放效果
 */

public class ZoomTextView extends AppCompatTextView{
    private Context mContext;

    public ZoomTextView(Context context) {
        super(context);
        mContext = context;
    }

    public ZoomTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        mContext = context;
    }

    public ZoomTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = context;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()){
            case MotionEvent.ACTION_DOWN:
                Animation downanimation = AnimationUtils.loadAnimation(this.mContext, R.anim.anim_action_dwon);
                startAnimation(downanimation);
                break;
            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_UP:
                Animation upanimation = AnimationUtils.loadAnimation(this.mContext, R.anim.anim_action_up);
                startAnimation(upanimation);
                break;
                default:
                    break;
        }
        return super.onTouchEvent(event);
    }


}
