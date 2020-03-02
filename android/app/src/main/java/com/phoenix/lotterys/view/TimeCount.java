package com.phoenix.lotterys.view;

import android.os.CountDownTimer;
import android.widget.TextView;

/**
 * Date:2018/10/11
 * TIME:15:26
 * author：Luke
 */
public class TimeCount extends CountDownTimer {
    private TextView tvCode;
    /**
     * @param millisInFuture    The number of millis in the future from the call
     *                          to {@link #start()} until the countdown is done and {@link #onFinish()}
     *                          is called.
     * @param countDownInterval The interval along the way to receive
     *                          {@link #onTick(long)} callbacks.
     */
    public TimeCount(long millisInFuture, long countDownInterval, TextView tv) {
        super(millisInFuture, countDownInterval);
        this.tvCode = tv;
    }

    @Override
    public void onTick(long millisUntilFinished) {
//        tvCode.setBackgroundResource(R.drawable.regist_suc);
        tvCode.setTextSize(12);
        tvCode.setText(millisUntilFinished / 1000 +"秒");
        tvCode.setClickable(false);
    }

    @Override
    public void onFinish() {
//        tvCode.setBackgroundResource(R.drawable.regist_suc);
        tvCode.setTextSize(12);
        tvCode.setText("再次接收");
        tvCode.setClickable(true);
    }


}
