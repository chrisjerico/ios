package com.phoenix.lotterys.view;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

public class ChatDialog extends Dialog {
    ImageView ivImg;
    TextView tvQq;
    Button btOk;
    Context context;
    String chat;
    String imgUrl;
    private onItemClickListener mItemClickListener;

    public interface onItemClickListener {
        void onItemClick(Object object);
    }

    public ChatDialog(Context context, String chat, String imgUrl, onItemClickListener onItemClickListener) {
        super(context, R.style.MyDialog);
        this.context = context;
        this.chat = chat;
        this.imgUrl = imgUrl;
        mItemClickListener = onItemClickListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.dialog_chat);
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
        ivImg = findViewById(R.id.iv_img);
        tvQq = findViewById(R.id.tv_qq);
        btOk = findViewById(R.id.bt_ok);
        tvQq.setText(chat);
        ImageLoadUtil.ImageLoad(imgUrl, context,
                ivImg, "");
    }

    private void initEvent() {
        btOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
    }
}
