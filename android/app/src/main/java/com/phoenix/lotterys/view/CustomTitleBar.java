package com.phoenix.lotterys.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import androidx.constraintlayout.widget.ConstraintLayout;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

/**
 * Created by Luke
 * on 2019/6/8
 */
public class CustomTitleBar extends RelativeLayout {
    private ImageView ivBack;
    private TextView tvTitle;
    private TextView tvMore;
    private TextView tvDemo;
    private TextView tvLogin;
    public ImageView ivMore;
    public ConstraintLayout cl_title;
    public ImageView ivLogo;

    private Context context;

    public CustomTitleBar(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        initView(context, attrs);
    }

    private View inflate;

    //初始化视图
    private void initView(final Context context, AttributeSet attributeSet) {
        inflate = LayoutInflater.from(context).inflate(R.layout.layout_titlebar, this);
        ivBack = inflate.findViewById(R.id.iv_back);
        tvTitle = inflate.findViewById(R.id.tv_title);
        tvMore = inflate.findViewById(R.id.tv_more);
        tvDemo = inflate.findViewById(R.id.tv_demo);
        tvLogin = inflate.findViewById(R.id.tv_login);
        ivMore = inflate.findViewById(R.id.iv_more);
        cl_title = inflate.findViewById(R.id.cl_title);
        ivLogo = inflate.findViewById(R.id.iv_logo);

        init(context, attributeSet);
    }

    public View getView() {
        return inflate;
    }

    //初始化资源文件
    public void init(Context context, AttributeSet attributeSet) {
        TypedArray typedArray = context.obtainStyledAttributes(attributeSet, R.styleable.CustomTitleBar);
        String title = typedArray.getString(R.styleable.CustomTitleBar_title);//标题
        int leftIcon = typedArray.getResourceId(R.styleable.CustomTitleBar_left_icon, R.drawable.finish);//左边图片
        int rightIcon = typedArray.getResourceId(R.styleable.CustomTitleBar_right_icon, R.drawable.finish);//右边图片
        String rightText = typedArray.getString(R.styleable.CustomTitleBar_right_text);//右边文字
        int titleBarType = typedArray.getInt(R.styleable.CustomTitleBar_titlebar_type, 10);//标题栏类型,默认为10
        int titleBt = typedArray.getInteger(R.styleable.CustomTitleBar_left, 0x00000008);

        //赋值进去我们的标题栏
        tvTitle.setText(title);
        ivBack.setImageResource(leftIcon);
        tvMore.setText(rightText);
        ivMore.setImageResource(rightIcon);
        ivBack.setVisibility(titleBt);
        //可以传入type值,可自定义判断值
        if (titleBarType == 10) {//不传入,默认为10,显示更多 文字,隐藏更多图标按钮
            ivMore.setVisibility(View.GONE);
            tvMore.setVisibility(View.VISIBLE);
        } else if (titleBarType == 11) {//传入11,显示更多图标按钮,隐藏更多 文字
            tvMore.setVisibility(View.GONE);
            ivMore.setVisibility(View.VISIBLE);
        } else {
            tvMore.setVisibility(View.GONE);
            ivMore.setVisibility(View.GONE);
        }
    }

    //左边图片点击事件
    public void setLeftIconOnClickListener(OnClickListener l) {
        ivBack.setOnClickListener(l);
    }

    //右边图片点击事件
    public void setRightIconOnClickListener(OnClickListener l) {
        ivMore.setOnClickListener(l);
    }

    //右边文字点击事件
    public void setRightTextOnClickListener(OnClickListener l) {
        tvMore.setOnClickListener(l);
    }

    public void setRightTextDemoOnClickListener(OnClickListener l) {
        tvDemo.setOnClickListener(l);
    }

    public void setRightTextLoginOnClickListener(OnClickListener l) {
        tvLogin.setOnClickListener(l);
    }

    public void setText(String title) {
        tvTitle.setText(title);
    }

    public void setTitleRightImg(Drawable drawable) {
        tvTitle.setCompoundDrawablesWithIntrinsicBounds(null,
                null, drawable, null);
    }

    public void setRIghtImgVisibility(int vb) {
        ivMore.setVisibility(vb);
    }

    public void setRIghtImg(int drawable, int vb) {
        ivMore.setImageResource(drawable);
        ivMore.setVisibility(vb);
    }

    public void setRIghtTvVisibility(int vb) {
        tvMore.setVisibility(vb);
    }

    public void setRIghtTvDemoVisibility(int vb) {
        tvDemo.setVisibility(vb);
    }

    public void setRIghtTvLoginVisibility(int vb) {
        tvLogin.setVisibility(vb);
    }

    public void setRightMove(String s, boolean b) {
        tvMore.setCompoundDrawables(null, null, null, null);
        tvMore.setText(s);
        tvMore.setEnabled(b);
    }

    public void setRightMoveImg() {
        Drawable drawableLeft = getResources().getDrawable(
                R.mipmap.zhuce);
        tvMore.setCompoundDrawablesWithIntrinsicBounds(drawableLeft,
                null, null, null);
//        tvMore.setCompoundDrawablePadding(4);
        tvMore.setText("注册");
        tvMore.setEnabled(true);
    }

    public View getTvMore() {
        return tvMore;
    }

    public void setTitleLeftImg(Context context, String url) {
        if (!TextUtils.isEmpty(url) && !url.equals("Null")) {
            ivLogo.setVisibility(View.VISIBLE);
//            ivLogo.setScaleType(ImageView.ScaleType.CENTER);
            if (BuildConfig.FLAVOR.equals("c085")) {
                ConstraintLayout.LayoutParams params = new ConstraintLayout.LayoutParams(MeasureUtil.dip2px(context, 180),
                        ViewGroup.LayoutParams.MATCH_PARENT);
            params.setMargins(MeasureUtil.dip2px(context, 5),0,0,0);
                ivLogo.setLayoutParams(params);
            }

            ImageLoadUtil.ImageLoadNoCaching(url, context, ivLogo, 0);
        }
    }

    public void setTitleHide(int i) {
        cl_title.setVisibility(i);
    }

    public void setIvBackHide(int i) {
        ivBack.setVisibility(i);
    }
}
