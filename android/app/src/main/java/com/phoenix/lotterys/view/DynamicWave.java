package com.phoenix.lotterys.view;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.DrawFilter;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.PaintFlagsDrawFilter;
import android.graphics.Shader;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.StringUtils;


public class DynamicWave extends View {
    private static final int WAVE_PAINT_COLOR = 0x880000aa;
    // y = Asin(wx+b)+h
    private static final float STRETCH_FACTOR_A = 20;
    private static final int OFFSET_Y = 0;
    private static final int TRANSLATE_X_SPEED_ONE = 2;
    private static final int TRANSLATE_X_SPEED_TWO = 1;
    private float mCycleFactorW;
    private int mTotalWidth, mTotalHeight;
    private float[] mYPositions;
    private float[] mResetOneYPositions;
    private float[] mResetTwoYPositions;
    private int mXOffsetSpeedOne;
    private int mXOffsetSpeedTwo;
    private int mXOneOffset;
    private int mXTwoOffset;

    private Paint mWavePaint;
    private DrawFilter mDrawFilter;

    public DynamicWave(Context context, AttributeSet attrs) {
        super(context, attrs);

        mXOffsetSpeedOne = Uiutils.dipToPx(context, TRANSLATE_X_SPEED_ONE);
        mXOffsetSpeedTwo = Uiutils.dipToPx(context, TRANSLATE_X_SPEED_TWO);


        mWavePaint = new Paint();

        mWavePaint.setAntiAlias(true);

        mWavePaint.setStyle(Paint.Style.FILL);

//        mWavePaint.setColor(WAVE_PAINT_COLOR);
        try {
//            String themetyp = ShareUtils.getString(context,"themetyp","");
//            String themid = ShareUtils.getString(context,"themid","");
//            if (!StringUtils.isEmpty(themetyp)&&StringUtils.equals("4",themetyp)&&
//                    !StringUtils.isEmpty(themetyp)&&StringUtils.equals("25",themid)){
////                theme_tex.setBackground(this.getResources().getDrawable(R.drawable.theme_ba25));
////                LinearGradient linearGradient=new LinearGradient(getWidth(),400,0,0,Color.RED,Color.GREEN, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
//                LinearGradient linearGradient = new LinearGradient(0,0,getMeasuredWidth(),0,
//                        getResources().getColor(R.color.ba_top_25),
//                        getResources().getColor(R.color.color_white), Shader.TileMode.CLAMP);
//
//                //new float[]{},中的数据表示相对位置，将150,50,150,300，划分10个单位，.3，.6，.9表示它的绝对位置。300到400，将直接画出rgb（0,232,210）
//                mWavePaint.setShader(linearGradient);
//
//            }else{
                mWavePaint.setColor(getResources().getColor( ShareUtils.getInt(context,"ba_top",Color.rgb(33, 150, 243))));
//            }
        } catch (Resources.NotFoundException e) {
            e.printStackTrace();
        }
        mDrawFilter = new PaintFlagsDrawFilter(0, Paint.ANTI_ALIAS_FLAG | Paint.FILTER_BITMAP_FLAG);
    }



    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        //获取屏幕高度
        DisplayMetrics dm = getResources().getDisplayMetrics();
       int heigth = dm.heightPixels;
        canvas.setDrawFilter(mDrawFilter);
        resetPositonY();
        for (int i = 0; i < mTotalWidth; i++) {
            canvas.drawLine(i, mTotalHeight - mResetOneYPositions[i] - 30, i,
                    mTotalHeight,
                    mWavePaint);
            canvas.drawLine(i, mTotalHeight - mResetTwoYPositions[i] - 30, i,
                    mTotalHeight,
                    mWavePaint);
        }
        mXOneOffset += mXOffsetSpeedOne;
        mXTwoOffset += mXOffsetSpeedTwo;
        if (mXOneOffset >= mTotalWidth) {
            mXOneOffset = 0;
        }
        if (mXTwoOffset > mTotalWidth) {
            mXTwoOffset = 0;
        }
        postInvalidate();
    }

    private void resetPositonY() {

        int yOneInterval = mYPositions.length - mXOneOffset;

        System.arraycopy(mYPositions, mXOneOffset, mResetOneYPositions, 0, yOneInterval);
        System.arraycopy(mYPositions, 0, mResetOneYPositions, yOneInterval, mXOneOffset);

        int yTwoInterval = mYPositions.length - mXTwoOffset;
        System.arraycopy(mYPositions, mXTwoOffset, mResetTwoYPositions, 0,
                yTwoInterval);
        System.arraycopy(mYPositions, 0, mResetTwoYPositions, yTwoInterval, mXTwoOffset);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);

        mTotalWidth = w;
        mTotalHeight = h;

        mYPositions = new float[mTotalWidth];

        mResetOneYPositions = new float[mTotalWidth];

        mResetTwoYPositions = new float[mTotalWidth];


        mCycleFactorW = (float) (2 * Math.PI / mTotalWidth);

        for (int i = 0; i < mTotalWidth; i++) {
            mYPositions[i] = (float) (STRETCH_FACTOR_A * Math.sin(mCycleFactorW * i) + OFFSET_Y);
        }
    }
}
