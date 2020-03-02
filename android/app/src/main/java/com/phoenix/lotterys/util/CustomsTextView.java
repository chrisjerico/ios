package com.phoenix.lotterys.util;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LinearGradient;
import android.graphics.Matrix;
import android.graphics.Shader;
import android.text.TextPaint;
import android.util.AttributeSet;

/**
 * Greated by Luke
 * on 2019/11/7
 */
public class CustomsTextView extends androidx.appcompat.widget.AppCompatTextView {
    private int mViewWidth = 0;
    private TextPaint mPaint;
    private LinearGradient mLinearGradient;
    private Matrix mGradientMatrix;
    private int mTranslate = 0;

    public CustomsTextView(Context context) {
        this(context,null,0);
    }
    public CustomsTextView(Context context, AttributeSet attrs) {
        this(context, attrs ,0 );
    }
    public CustomsTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (mGradientMatrix != null){
            mTranslate += mViewWidth /7 ;
            if (mTranslate > 2*mViewWidth){
                mTranslate = -mViewWidth;
            }
            mGradientMatrix.setTranslate(mTranslate ,0);
            mLinearGradient.setLocalMatrix(mGradientMatrix);
            postInvalidateDelayed(50);
        }
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        if(mViewWidth == 0){
            mViewWidth = getMeasuredWidth();
            if (mViewWidth > 0 ){
                mPaint = getPaint();
                //Shader.TileMode.MIRROR   镜子，反射，反映
                //Shader.TileMode.REPEAT  重复
                mLinearGradient = new LinearGradient(0,0,mViewWidth,0,new int[]{Color.RED,Color.GREEN,Color.CYAN,0xffffffff,Color.BLUE},null, Shader.TileMode.CLAMP);
                mPaint.setShader(mLinearGradient);
                mGradientMatrix = new Matrix();

            }
        }
    }
}
