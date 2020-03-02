package com.phoenix.lotterys.my.activity;


import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import androidx.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.YuebaoBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.ArcView;
import com.phoenix.lotterys.view.CountDownView;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.IOException;
import java.net.URLDecoder;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/8/23
 */
public class InterestDoteyActivity extends BaseActivity {
    @BindView(R2.id.iv_back)
    ImageView ivBack;
    @BindView(R2.id.tv_data_profit)
    TextView tvDataProfit;
    @BindView(R2.id.tv_allmoney)
    TextView tvAllmoney;
    @BindView(R2.id.tv_week_profit)
    TextView tvWeekProfit;
    @BindView(R2.id.tv_moon_profit)
    TextView tvMoonProfit;
    @BindView(R2.id.tv_all_profit)
    TextView tvAllProfit;
    @BindView(R2.id.iv_gif)
    ImageView ivGif;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.tv_use)
    TextView tvUse;
    @BindView(R2.id.tv_gift_balan)
    TextView tvGiftBalan;

    public boolean isStop = true;
    @BindView(R2.id.cd_view)
    CountDownView cdView;
//    @BindView(R2.id.d_wave)
//    DynamicWave dWave;
//    @BindView(R2.id.ll_wave)
//    LinearLayout llWave;
    @BindView(R2.id.rl_back)
    RelativeLayout rlBack;
    @BindView(R2.id.rl_title)
    RelativeLayout rlTitle;
    @BindView(R2.id.tv_totday)
    TextView tvTotday;
    @BindView(R2.id.tv_week)
    TextView tvWeek;
    @BindView(R2.id.tv_moon)
    TextView tvMoon;
    @BindView(R2.id.tv_all)
    TextView tvAll;
    @BindView(R2.id.ll_profit)
    LinearLayout llProfit;
    @BindView(R2.id.bt_turn_inwards)
    Button btTurnInwards;
    @BindView(R2.id.bt_reporting)
    Button btReporting;
    @BindView(R2.id.bt_reporting_record)
    Button btReportingRecord;
    @BindView(R2.id.ll_jump)
    LinearLayout llJump;
    @BindView(R2.id.arcView)
    ArcView arcView;
    @BindView(R2.id.arcView1)
    ArcView arcView1;
    @BindView(R2.id.sl_view)
    ScrollView slView;
    @BindView(R2.id.rl_botton_rel)
    RelativeLayout rl_botton_rel;

    private YuebaoBean yuebaobean;

    public void getIntentData() {

    }

    public InterestDoteyActivity() {
        super(R.layout.activity_interestdotey,true,true);
    }

    @Override
    public void initView() {
        if (ivGif != null)
            Glide.with(InterestDoteyActivity.this).asGif().load(R.mipmap.yuebaomoney).into(ivGif);
        ivGif.setVisibility(View.GONE);
        cdView.setOnLoadingFinishListener(new CountDownView.OnLoadingFinishListener() {
            @Override
            public void finish() {
                if (!isStop)
                    return;
                getData();
                if (ivGif != null && ivGif.getVisibility() == View.GONE) {
                    ivGif.setVisibility(View.VISIBLE);

                } else {
//                    Glide.with(InterestDoteyActivity.this).asGif().load(R.mipmap.yuebaomoney).into(ivGif);
                }
                handler.postDelayed(runnable, 1500);
                if (isStop) {
                    try {
                        cdView.start();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        });

        try {
            cdView.start();
            getData();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!StringUtils.isEmpty(ShareUtils.getString(this, "themetyp", ""))) {
//            dWave.setVisibility(View.GONE);

        }
        setMtheme();

        if (Uiutils.isTheme(this)) {
            Uiutils.setBarStye0(rlTitle,this);
            Uiutils.setBarStye0(rl_botton_rel,this);
            arcView.setVisibility(View.GONE);
            arcView1.setVisibility(View.VISIBLE);
        }
    }

    private void setMtheme() {
        Uiutils.setBaColor(this,null,true,arcView);
        ConfigBean config = (ConfigBean) ShareUtils.getObject(InterestDoteyActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(InterestDoteyActivity.this, btSubpw, false, null);
                Uiutils.setBaColor(InterestDoteyActivity.this, slView);
                tvUse.setTextColor(getResources().getColor(R.color.white));
                tvWeekProfit.setTextColor(getResources().getColor(R.color.white));
                tvMoonProfit.setTextColor(getResources().getColor(R.color.white));
                tvAllProfit.setTextColor(getResources().getColor(R.color.white));

            }
        }

    }

    private void getData() {
        String token = SPConstants.checkLoginInfo(InterestDoteyActivity.this);
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.YUEBAO + SecretUtils.DESede(token)+"&sign="+SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(InterestDoteyActivity.this, false, InterestDoteyActivity.this, true, YuebaoBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                yuebaobean = (YuebaoBean) o;
                if (yuebaobean != null && yuebaobean.getCode() == 0 && yuebaobean.getData() != null) {
                    if (!TextUtils.isEmpty(yuebaobean.getData().getYuebaoName()))
                        tvTitle.setText(yuebaobean.getData().getYuebaoName());
                    if (!TextUtils.isEmpty(yuebaobean.getData().getTodayProfit()))
                        tvDataProfit.setText(yuebaobean.getData().getTodayProfit());
                    String bal = null;
                    if (!TextUtils.isEmpty(yuebaobean.getData().getBalance())) {
                        bal = yuebaobean.getData().getBalance();
                    }
                    if (!TextUtils.isEmpty(yuebaobean.getData().getAnnualizedRate())) {
                        String rate = yuebaobean.getData().getAnnualizedRate();
                        if (!TextUtils.isEmpty(rate)) {
                            double rates = Double.parseDouble(rate);
                            bal += "   年化率：" + ShowItem.subZeroAndDot((rates * 100) + "") + "%";
                        }
                    }
                    tvAllmoney.setText("总金额：" + bal);

                    if (!TextUtils.isEmpty(yuebaobean.getData().getWeekProfit()))
                        tvWeekProfit.setText(yuebaobean.getData().getWeekProfit());

                    if (!TextUtils.isEmpty(yuebaobean.getData().getMonthProfit()))
                        tvMoonProfit.setText(yuebaobean.getData().getMonthProfit());

                    if (!TextUtils.isEmpty(yuebaobean.getData().getTotalProfit()))
                        tvAllProfit.setText(yuebaobean.getData().getTotalProfit());

                    if (!TextUtils.isEmpty(yuebaobean.getData().getIntro()))
                        tvUse.setText(yuebaobean.getData().getIntro());

                    if (!TextUtils.isEmpty(yuebaobean.getData().getGiftBalance()))
                        tvGiftBalan.setText("体验金：" + yuebaobean.getData().getGiftBalance());

                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
            }

            @Override
            public void onFailed(Response<String> response) {
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        isStop = false;
        OkGo.getInstance().cancelAll();
        handler.removeCallbacks(runnable);
    }


    @Override
    protected void onPause() {
        super.onPause();
//        isStop = false;
    }

    @Override
    protected void onResume() {
        super.onResume();
        isStop = true;
    }

    @OnClick({R.id.rl_back, R.id.bt_turn_inwards, R.id.bt_reporting, R.id.bt_reporting_record})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.rl_back:
                finish();
                break;
            case R.id.bt_turn_inwards:   //转入转出
                if (ButtonUtils.isFastDoubleClick())
                    return;
                Bundle build = new Bundle();
                if (yuebaobean != null && yuebaobean.getData() != null) {
                    build.putSerializable("todayProfit", TextUtils.isEmpty(yuebaobean.getData().getTodayProfit()) ? "Null" : yuebaobean.getData().getTodayProfit());
//                if(!TextUtils.isEmpty(yuebaobean.getData().getBalance()))
                    build.putSerializable("balance", TextUtils.isEmpty(yuebaobean.getData().getBalance()) ? "Null" : yuebaobean.getData().getBalance());
//                if(!TextUtils.isEmpty(yuebaobean.getData().getAnnualizedRate()))
                    build.putSerializable("annualizedRate", TextUtils.isEmpty(yuebaobean.getData().getAnnualizedRate()) ? "Null" : yuebaobean.getData().getAnnualizedRate());
//                if(!TextUtils.isEmpty(yuebaobean.getData().getMinTransferInMoney()))
                    build.putSerializable("minTransferInMoney", TextUtils.isEmpty(yuebaobean.getData().getMinTransferInMoney()) ? "Null" : yuebaobean.getData().getMinTransferInMoney());
//                if(!TextUtils.isEmpty(yuebaobean.getData().getMaxTransferOutMoney()))
                    build.putSerializable("maxTransferOutMoney", TextUtils.isEmpty(yuebaobean.getData().getMaxTransferOutMoney()) ? "Null" : yuebaobean.getData().getMaxTransferOutMoney());
//                if(!TextUtils.isEmpty(yuebaobean.getData().getYuebaoName()))
                    build.putSerializable("yuebaoName", TextUtils.isEmpty(yuebaobean.getData().getYuebaoName()) ? "Null" : yuebaobean.getData().getYuebaoName());
                }
                IntentUtils.getInstence().startActivityForResult(InterestDoteyActivity.this, RollInOutActivity.class, 1003, build);
                break;
            case R.id.bt_reporting:  //受益报表
                if (ButtonUtils.isFastDoubleClick())
                    return;
                IntentUtils.getInstence().intent(InterestDoteyActivity.this,ReportRecordActivity.class);

                break;
            case R.id.bt_reporting_record:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                IntentUtils.getInstence().intent(InterestDoteyActivity.this,ReportingRecordActivity.class);

                break;
        }
    }

    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            if (ivGif != null)
                ivGif.setVisibility(View.GONE);
        }
    };

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == 1003 && resultCode == RESULT_OK) {
            assert data != null;
            String balance = data.getStringExtra("balance");
            String annualizedRate = data.getStringExtra("annualizedRate");
            String todayProfit = data.getStringExtra("todayProfit");
            String weekProfit = data.getStringExtra("weekProfit");
            String monthProfit = data.getStringExtra("monthProfit");
            String totalProfit = data.getStringExtra("totalProfit");
            if (!TextUtils.isEmpty(todayProfit))
                tvDataProfit.setText(todayProfit);
            String bal = null;
            if (!TextUtils.isEmpty(balance)) {
                bal = balance;
            }
            if (!TextUtils.isEmpty(annualizedRate)) {
//                String rate = annualizedRate;
                if (!TextUtils.isEmpty(annualizedRate)) {
                    double rates = Double.parseDouble(annualizedRate);
                    bal += "   年化率：" + ShowItem.subZeroAndDot((rates * 100) + "") + "%";
                }
            }
            tvAllmoney.setText("总金额：" + bal);
            if (!TextUtils.isEmpty(weekProfit))
                tvWeekProfit.setText(weekProfit);
            if (!TextUtils.isEmpty(monthProfit))
                tvMoonProfit.setText(monthProfit);
            if (!TextUtils.isEmpty(totalProfit))
                tvAllProfit.setText(totalProfit);
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(this,null, false, arcView);
                break;
        }
    }

}