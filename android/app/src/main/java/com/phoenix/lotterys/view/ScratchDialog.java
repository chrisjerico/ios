package com.phoenix.lotterys.view;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.ShowItem;

public class ScratchDialog extends Dialog {
    ImageView ivClose;
    TextView titleTex,tvNum,tvZodiac;
    ScratchView mScratchView;
    Activity context;
    TextView tvClose;
    String num,animal,mPercentFormat;
    boolean isShow = false;
    int mPercent;
    private ClickListenerInterface clickListenerInterface;
    public ScratchDialog(Activity context, String num, String animal) {
        super(context, R.style.MyDialog);
        this.context = context;
        this.num = num;
        this.animal = animal;
    }

    public interface ClickListenerInterface {
        public void doConfirm(Boolean isShow);
    }
    public void setClicklistener(ClickListenerInterface clickListenerInterface) {
        this.clickListenerInterface = clickListenerInterface;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.dialog_acratch);
        //点击屏幕空白消失
        setCanceledOnTouchOutside(false);
        //点击返回键消失
        setCancelable(false);
        //初始化界面控件
        initView();
        //点击事件
        initEvent();
    }

    private void initView() {
        ivClose = findViewById(R.id.iv_close);
        tvNum = findViewById(R.id.tv_num);
        tvZodiac = findViewById(R.id.tv_title);
        if(num!=null){
            tvNum.setText(num);
        }
        if(animal!=null){
            tvZodiac.setText(animal);
        }
        if (ShowItem.isNumeric(num)) {
            tvNum.setBackgroundResource(NumUtil.NumImg(Integer.parseInt(num)));
        }

        mScratchView = (ScratchView) findViewById(R.id.scratch_view);
        mScratchView.setWatermark(R.drawable.load_img);
        mScratchView.setEraseStatusListener(new ScratchView.EraseStatusListener() {
            @Override
            public void onProgress(int percent) {

                mPercent = percent;
            }

            @Override
            public void onCompleted(View view) {
//                Toast.makeText(ScratchDemoActivity.this, "completed !", Toast.LENGTH_SHORT).show();
//                isShow =
            }
        });

    }

    private void initEvent() {
        ivClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e("mPercent",""+mPercent);
                if(mPercent>5){
                    isShow = true;
                }
                clickListenerInterface.doConfirm(isShow);
                dismiss();
            }
        });
    }
}
