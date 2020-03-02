package com.phoenix.lotterys.view;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

public class QrBbsDialog extends Dialog {
    ImageView ivqr;
    String url;
    Activity context;

    private long mLastClickTime = 0;
    public static final long TIME_INTERVAL = 400L;

    public QrBbsDialog(Activity context, String url) {
        super(context, R.style.MyDialog);
        this.context = context;
        this.url = url;

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.dialog_qr_bbs);
        //点击屏幕空白消失
        setCanceledOnTouchOutside(true);
        //点击返回键消失
        setCancelable(true);
        //初始化界面控件
        initView();
        //点击事件
        initEvent();
    }

    private void initView() {
        ivqr = findViewById(R.id.iv_qr);
//        ImageLoadUtil.ImageLoadNoCaching(url,context,  ivqr, R.drawable.load_img);
        Glide.with(context).load( url).into(ivqr);
    }

    private void initEvent() {
        ivqr.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
    }
}
