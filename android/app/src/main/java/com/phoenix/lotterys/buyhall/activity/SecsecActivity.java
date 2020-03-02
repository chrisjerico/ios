package com.phoenix.lotterys.buyhall.activity;

import android.os.Bundle;
import android.os.CountDownTimer;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.adapter.WinNumSecsecAdapter;
import com.phoenix.lotterys.buyhall.bean.BetBean;
import com.phoenix.lotterys.buyhall.bean.WinNumber;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.view.MyLayoutManager;
import com.wanxiangdai.commonlibrary.base.BaseActivity;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/9/7
 */
public class SecsecActivity extends BaseActivity {
    String json;
    @BindView(R2.id.cb_auto)
    CheckBox cbAuto;
    @BindView(R2.id.iv_close)
    ImageView ivClose;
    @BindView(R2.id.tv_bonus)
    TextView tvBonus;
    @BindView(R2.id.tv_countDown)
    TextView tvCountDown;
    @BindView(R2.id.iv_bunko)
    ImageView ivBunko;
    @BindView(R2.id.rv_win_number)
    RecyclerView rvWinNumber;
        @BindView(R2.id.rv_niu_number)
    RecyclerView rvNiuNumber;
    private int code;
    private String type;
    private String openNum,result;
    private String bonus;
    private String gameId;
    private CountDownTimer timer;
    boolean isSuspend = false;
    List<WinNumber> winNumberList;
    List<WinNumber> NumList;
    String[] animal;
    String[] temp1;
    private WinNumSecsecAdapter winNumberAdapter;

    public SecsecActivity() {
        super(R.layout.activity_secsec, true, true,1);
    }

    public void getIntentData() {
        Bundle bundle = getIntent().getExtras();
        json = bundle.getString("json");
        code = bundle.getInt("code", 0);
        type = bundle.getString("type");
        openNum = bundle.getString("openNum");
        result = bundle.getString("result");
        bonus = bundle.getString("bonus");
        gameId = bundle.getString("gameId");
//        Log.e("json", "" + json);
//        Log.e("json",""+json);
    }

    @Override
    public void initView() {
        showBunko(bonus);
        initListener(cbAuto);
        setLotteryData();
    }

    private void showBunko(String bonus) {
        if (ShowItem.isNumeric(bonus)) {
            double bon = Double.parseDouble(bonus);
            if (bon > 0) {
                tvBonus.setText("+" + bonus);
                ivBunko.setBackgroundResource(R.mipmap.mmczjl);
            } else {
                tvBonus.setText("再接再厉");
                ivBunko.setBackgroundResource(R.mipmap.mmcwzj);
            }
        }
    }

    private void countDown(int i, boolean b) {
        timer = new CountDownTimer(i * 1000, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                if(tvCountDown!=null){
                    tvCountDown.setText("倒计时" + millisUntilFinished / 1000 + "秒");
                }
            }

            @Override
            public void onFinish() {
                if (b){
                    initData();
                }
                tvCountDown.setVisibility(View.GONE);
            }
        }.start();
    }

    private void initData() {
        String url = Constants.BaseUrl()+Constants.INSTANTLOTTERYBET + (Constants.ENCRYPT ? Constants.SIGN : "");
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(url))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(this, true, this, true, BetBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BetBean bet = (BetBean) o;
                        if (bet != null && bet.getCode() == 0 && bet.getData() != null) {
                            if (!isSuspend) {
                                tvCountDown.setVisibility(View.VISIBLE);
                                countDown(4, true);
                                showBunko(bet.getData().getBonus());
                            }
                            openNum = bet.getData().getOpenNum();
                            result = bet.getData().getResult();
                            setLotteryData();
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        isSuspend = true;
                        tvCountDown.setVisibility(View.GONE);
                        cbAuto.setChecked(false);
                    }

                    @Override
                    public void onFailed(Response<String> response) {
                        isSuspend = true;
                        tvCountDown.setVisibility(View.GONE);
                        cbAuto.setChecked(false);
                    }
                });


    }

    @OnClick({/*R.id.cb_auto,*/ R.id.iv_close})
    public void onViewClicked(View view) {
        switch (view.getId()) {
//            case R.id.cb_auto:
//                break;
            case R.id.iv_close:
                finish();
                break;
        }
    }

    @Override
    protected void onDestroy() {
        if (timer != null)
            timer.cancel();
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }


    private long mLastClickTime = 0;
    public static final long TIME_INTERVAL = 3000L;
    private void initListener(CheckBox cb) {
        cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                long nowTime = System.currentTimeMillis();
                if (isChecked) {
                    if (nowTime - mLastClickTime > TIME_INTERVAL) {
                        initData();
                        mLastClickTime = nowTime;
                    }
                    tvCountDown.setVisibility(View.VISIBLE);
                    isSuspend = false;
                } else {

                    isSuspend = true;
                    tvCountDown.setVisibility(View.GONE);
                    OkGo.getInstance().cancelTag(this);
                }
            }
        });
    }

    private void setLotteryData() {
        winNumberList = new ArrayList<>();
        String delimeter1 = ",";
        //添加号码
        if (!TextUtils.isEmpty(openNum)) {
            temp1 = openNum.split(delimeter1); // 分割字符串
        }
        if (!TextUtils.isEmpty(result)) {
            animal = result.split(delimeter1); // 分割字符串
        }
        if (type.equals("lhc")) {
            for (int i = 0; i < temp1.length; i++) {
                if (temp1.length - 1 == i) {
                    winNumberList.add(new WinNumber("+", "+"));
                    winNumberList.add(new WinNumber(temp1[i], animal[i]));
                } else {
                    winNumberList.add(new WinNumber(temp1[i], animal[i]));
                }
            }
        } else if (type.equals("pcdd")) {
            int sum = 0;
            for (int i = 0; i < temp1.length; i++) {
                winNumberList.add(new WinNumber(temp1[i], animal[i]));
                if (ShowItem.isNumeric(temp1[i]))
                    sum += Integer.parseInt(temp1[i]);
            }
            winNumberList.add(new WinNumber("=", ""));
            winNumberList.add(new WinNumber(sum + "", ""));
        } else if (animal.length > temp1.length) {
            if (animal != null) {
                for (int i = 0; i < animal.length; i++) {
                    winNumberList.add(new WinNumber("", animal[i]));
                }
            }
            if (openNum != null && temp1 != null) {
                for (int t = 0; t < temp1.length; t++) {
                    winNumberList.get(t).setNum(temp1[t]);
                }
            }
        } else if (temp1 != null) {
            for (int i = 0; i < temp1.length; i++) {
                winNumberList.add(new WinNumber(temp1[i], ""));
            }
            if (result != null && animal != null) {
                for (int t = 0; t < animal.length; t++) {
                    winNumberList.get(t).setAnimal(animal[t]);
                }
            }
        }

//        if (winNumberAdapter == null) {
//            NumList = winNumberList;
            winNumberAdapter = new WinNumSecsecAdapter(winNumberList, gameId, type, SecsecActivity.this);
            MyLayoutManager layout = new MyLayoutManager();
            //必须，防止recyclerview高度为wrap时测量item高度0
            layout.setAutoMeasureEnabled(true);
            rvWinNumber.setLayoutManager(layout);
            rvWinNumber.setAdapter(winNumberAdapter);

    }


}
