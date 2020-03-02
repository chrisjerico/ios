package com.phoenix.lotterys.view;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.Shader;
import android.graphics.Xfermode;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

import java.lang.ref.WeakReference;

public class AutoPollRecyclerView extends RecyclerView {
    private static final long TIME_AUTO_POLL = 16;
    private static final long TIME_AUTO_POLL_1 = 1500;
    AutoPollTask autoPollTask;
    AutoPollTask1 autoPollTask1;
    private int index = 0;
    private boolean running; //标示是否正在自动轮询
    private boolean canRun;//标示是否可以自动轮询,可在不需要的是否置false
    private final int mTouchSlop;

    Paint mPaint;
    private int layerId;
    private LinearGradient linearGradient;
    private int preWidth = 0;// Recyclerview宽度动态变化时，监听每一次的宽度

    public AutoPollRecyclerView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
//         autoPollTask = new AutoPollTask(this);
        autoPollTask1 = new AutoPollTask1(this);
        mTouchSlop = ViewConfiguration.get(context).getScaledTouchSlop();
    }

    /**
     * 持续滑动（走马灯）
     */
    static class AutoPollTask implements Runnable {
        private final WeakReference mReference;

        //使用弱引用持有外部类引用->防止内存泄漏
        public AutoPollTask(AutoPollRecyclerView reference) {
            this.mReference = new WeakReference(reference);
        }

        @Override
        public void run() {
            AutoPollRecyclerView recyclerView = (AutoPollRecyclerView) mReference.get();
            if (recyclerView != null && recyclerView.running && recyclerView.canRun) {
                recyclerView.scrollBy(2, 2);
                recyclerView.postDelayed(recyclerView.autoPollTask, recyclerView.TIME_AUTO_POLL);
            }
        }
    }

    /***
     * 一次只能滑一个item（轮播图）
     */
    static class AutoPollTask1 implements Runnable {
        private final WeakReference mReference;

        //使用弱引用持有外部类引用->防止内存泄漏
        public AutoPollTask1(AutoPollRecyclerView reference) {
            this.mReference = new WeakReference(reference);
        }

        @Override
        public void run() {
            AutoPollRecyclerView recyclerView = (AutoPollRecyclerView) mReference.get();
            if (recyclerView != null && recyclerView.running && recyclerView.canRun) {
                recyclerView.smoothScrollToPosition(++recyclerView.index);
                recyclerView.postDelayed(recyclerView.autoPollTask1, TIME_AUTO_POLL_1);
            }
        }
    }

    //开启:如果正在运行,先停止->再开启
    public void start() {
        if (running)
            stop();
        canRun = true;
        running = true;
//         postDelayed(autoPollTask,TIME_AUTO_POLL);
        postDelayed(autoPollTask1, TIME_AUTO_POLL_1);
    }

    public void stop() {
        running = false;
//         removeCallbacks(autoPollTask);
        removeCallbacks(autoPollTask1);
    }

    //取消RecyclerView的惯性，使每次手动只能滑一个
    int lastY = 0;

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        int action = ev.getAction();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                lastY = (int) ev.getRawY();
                if (running)
                    stop();
                break;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_OUTSIDE:
                int nowY = (int) ev.getRawY();
                if (nowY - lastY > mTouchSlop) {//向下滑动
                    smoothScrollToPosition(index == 0 ? 0 : --index);
                    if (canRun)
                        start();
                    return true;
                } else if (lastY - nowY > mTouchSlop) {//向上滑动
                    smoothScrollToPosition(++index);
                    if (canRun)
                        start();
                    return true;
                }
                break;
        }
        return super.dispatchTouchEvent(ev);
    }

    // 实现渐变效果
    public void doTopGradualEffect(final int itemViewWidth) {
        mPaint = new Paint();
        // dst_in 模式，实现底层透明度随上层透明度进行同步显示（即上层为透明时，下层就透明，并不是上层覆盖下层)
        final Xfermode xfermode = new PorterDuffXfermode(PorterDuff.Mode.DST_IN);
        mPaint.setXfermode(xfermode);
        addItemDecoration(new RecyclerView.ItemDecoration() {

            @Override

            public void onDrawOver(Canvas canvas, RecyclerView parent, RecyclerView.State state) {
                super.onDrawOver(canvas, parent, state);
                // 当linearGradient为空即第一次绘制 或 Recyclerview宽度发生改变时，重新计算透明位置
                if (linearGradient == null || preWidth != parent.getWidth()) {
                    // 透明位置从最后一个 itemView 的一半处到 Recyclerview 的最右边
                    linearGradient = new LinearGradient(parent.getWidth() - (itemViewWidth / 2), 0.0f, parent.getWidth(), 0.0f, new int[]{Color.BLACK, 0}, null, Shader.TileMode.CLAMP);
                    preWidth = parent.getWidth();
                }
                mPaint.setXfermode(xfermode);
                mPaint.setShader(linearGradient);
                canvas.drawRect(0.0f, 0.0f, parent.getRight(), parent.getBottom(), mPaint);
                mPaint.setXfermode(null);
                canvas.restoreToCount(layerId);
            }

            @Override

            public void onDraw(Canvas c, RecyclerView parent, RecyclerView.State state) {
                super.onDraw(c, parent, state);
                // 此处 Paint的参数这里传的null， 在传入 mPaint 时会出现第一次打开黑屏闪现的问题
                // 注意 saveLayer 不能省也不能移动到onDrawOver方法里
                layerId = c.saveLayer(0.0f, 0.0f, (float) parent.getWidth(), (float) parent.getHeight(), null, Canvas.ALL_SAVE_FLAG);

            }

            @Override

            public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
                // 该方法作用自行百度
                super.getItemOffsets(outRect, view, parent, state);
            }
        });
    }
}
