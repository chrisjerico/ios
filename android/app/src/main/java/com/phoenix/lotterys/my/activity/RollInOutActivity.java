package com.phoenix.lotterys.my.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.method.DigitsKeyListener;
import android.text.method.PasswordTransformationMethod;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.LimitItemAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.TransferBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.bean.YuebaoBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SpacesItemDecoration1;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.ArcView;
import com.phoenix.lotterys.view.tddialog.TDialog;

import org.greenrobot.eventbus.EventBus;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/8/24
 */
public class RollInOutActivity extends BaseActivitys {
    String yuebaobean;
    @BindView(R2.id.iv_back)
    ImageView ivBack;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.tv_data_profit)
    TextView tvDataProfit;
    @BindView(R2.id.tv_allmoney)
    TextView tvAllmoney;
    @BindView(R2.id.tv_balance)
    TextView tvBalance;
    @BindView(R2.id.tv_interest)
    TextView tvInterest;
    @BindView(R2.id.et_money)
    EditText etMoney;
    @BindView(R2.id.bt_affirm_in)
    Button btAffirmIn;
    @BindView(R2.id.rv_money)
    RecyclerView rvMoney;
    @BindView(R2.id.bt_in)
    Button btIn;
    @BindView(R2.id.bt_out)
    Button btOut;
    @BindView(R2.id.ll_bt)
    LinearLayout llBt;
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
    @BindView(R2.id.tv_cinterest_balance)
    TextView tvCinterestBalance;
    @BindView(R2.id.ll_profit)
    LinearLayout llProfit;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    private Bundle bundle;
    private String mEtMoney;
    boolean isInOut = true;
    private String minTransferInMoney;
    private String maxTransferOutMoney;
    int pos;
    private List<My_item> limit;
    private LimitItemAdapter adapter;
    private YuebaoBean yuebaobean1;
    @BindView(R2.id.arcView)
    ArcView arcView;
    @BindView(R2.id.tv_titlemoney)
    TextView tvTitlemoney;
    public RollInOutActivity() {
        super(R.layout.roll_in_out);
    }

    public void getIntentData() {
        bundle = getIntent().getExtras();

    }

    @Override
    public void initView() {

        initRecycler();
        tvTitle.setText(TextUtils.isEmpty(bundle.getString("yuebaoName")) ? "" : "转入" + bundle.getString("yuebaoName"));
        tvBalance.setText((SPConstants.getValue(RollInOutActivity.this, SPConstants.SP_BALANCE)));
        tvDataProfit.setText(TextUtils.isEmpty(bundle.getString("todayProfit")) ? "" : bundle.getString("todayProfit"));
        tvInterest.setText(TextUtils.isEmpty(bundle.getString("balance")) ? "" : bundle.getString("balance"));//利息宝余额
//        tvAllmoney.setText((TextUtils.isEmpty(bundle.getString("balance")) ? "" :  bundle.getString("balance"))+"  年化率"+(TextUtils.isEmpty(bundle.getString("annualizedRate")) ? "" :  bundle.getString("annualizedRate")));
        String rate = bundle.getString("annualizedRate");
        if (!TextUtils.isEmpty(rate) && !rate.equals("Null")) {
            double rates = Double.parseDouble(rate);
            tvAllmoney.setText("总金额：" + (TextUtils.isEmpty(bundle.getString("balance")) ? "" : bundle.getString("balance") + "  年化率：" + ShowItem.subZeroAndDot((rates * 100) + "") + "%"));
        }
        minTransferInMoney = TextUtils.isEmpty(bundle.getString("minTransferInMoney")) ? "" : bundle.getString("minTransferInMoney");
        maxTransferOutMoney = TextUtils.isEmpty(bundle.getString("maxTransferOutMoney")) ? "" : bundle.getString("maxTransferOutMoney");
        if (TextUtils.isEmpty(minTransferInMoney))
            etMoney.setHint(getResources().getString(R.string.in_balance) + "");
        else
            etMoney.setHint(getResources().getString(R.string.in_balance) + "(最低转入金额" + minTransferInMoney + ")");
        setEdit(etMoney, llBt);

        setMtheme();
    }

    private void setMtheme() {
        Uiutils.setBaColor(this,null,true,arcView);
        ConfigBean config = (ConfigBean) ShareUtils.getObject(RollInOutActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(InterestDoteyActivity.this, btSubpw, false, null);
                Uiutils.setBaColor(RollInOutActivity.this, rlMain);
                etMoney.setTextColor(getResources().getColor(R.color.white));
                tvBalance.setTextColor(getResources().getColor(R.color.white));
                tvInterest.setTextColor(getResources().getColor(R.color.white));
                tvTitlemoney.setTextColor(getResources().getColor(R.color.white));
                etMoney.setLinkTextColor(getResources().getColor(R.color.white));
            }
        }

    }
    private void initRecycler() {
        limit = new ArrayList<>();
        limit.add(new My_item("100", false));
        limit.add(new My_item("500", false));
        limit.add(new My_item("1000", false));
        limit.add(new My_item("5000", false));
        limit.add(new My_item("10000", false));
        limit.add(new My_item("全部金额", false));

        LinearLayoutManager layoutManager;
        layoutManager = new GridLayoutManager(this, 3);
        rvMoney.setLayoutManager(layoutManager);
        rvMoney.setItemAnimator(new DefaultItemAnimator());
        int space = 8;
        rvMoney.addItemDecoration(new SpacesItemDecoration1(space));
        adapter = new LimitItemAdapter(limit,this);
        rvMoney.setAdapter(adapter);
        adapter.setOnItemClickListener(new LimitItemAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                for (int i = 0; i < limit.size(); i++) {
                    if (i == position) {
                        limit.get(i).setSelected(true);
                    } else {
                        limit.get(i).setSelected(false);
                    }
                }
                adapter.notifyDataSetChanged();
                setEditMoney(position);
                pos = position;
            }
        });
    }

    private void setEditMoney(int position) {
        if (limit.get(position).getTitle().equals("全部金额")) {
            if (isInOut) {
//                String inBal = SPConstants.getValue(RollInOutActivity.this, SPConstants.SP_BALANCE);
                String inBal = tvBalance.getText().toString().trim();
                if (!TextUtils.isEmpty(inBal)) {
                    String bal = inBal.replaceAll(",", "");
                    String[] inBalance = bal.split("\\.");
                    if (inBalance != null && inBalance.length != 0 && ShowItem.isNumeric(inBalance[0])) {
                        if (Integer.parseInt(inBalance[0]) > 0)
                            etMoney.setText(inBalance[0]);
                        else {

                            ToastUtils.ToastUtils("余额必须大于1", RollInOutActivity.this);
                            etMoney.setText("");
                        }
                    }
                }
            } else {
//                String outbal = bundle.getString("balance");
                String outbal = tvInterest.getText().toString().trim();
                if (!TextUtils.isEmpty(outbal)) {
                    String[] outBalance = outbal.split("\\.");
                    if (outBalance != null && outBalance.length != 0 && ShowItem.isNumeric(outBalance[0])) {
                        if (Integer.parseInt(outBalance[0]) > 0)
                            etMoney.setText(outBalance[0]);
                        else {
                            ToastUtils.ToastUtils(bundle.getString("yuebaoName") + "余额必须大于1", RollInOutActivity.this);
                            etMoney.setText("");
                        }
                    }
                }
            }
            etMoney.setSelection(etMoney.length());
        } else {
            etMoney.setText(limit.get(position).getTitle());
            etMoney.setSelection(etMoney.length());
        }
    }

    @OnClick({R.id.rl_back, R.id.bt_affirm_in, R.id.bt_in, R.id.bt_out})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.rl_back:
                intentData();
                finish();
                break;
            case R.id.bt_affirm_in:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                mEtMoney = etMoney.getText().toString().trim();
                if (mEtMoney == null || mEtMoney.length() == 0) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.input_balance), RollInOutActivity.this);
                    return;
                }
                UserInfo userInfo = (UserInfo) ShareUtils.getObject(RollInOutActivity.this, SPConstants.USERINFO, UserInfo.class);
                if (userInfo != null && userInfo.getData() != null) {
                    if (!userInfo.getData().isHasFundPwd()) {
                        ToastUtils.ToastUtils(getResources().getString(R.string.setting_pwd), RollInOutActivity.this);
                        return;
                    }

                    String fundpwd = SPConstants.getValue(this, SPConstants.SP_HASFUNDPWD);
                    if (!fundpwd.equals("Null") && fundpwd.equals("false")) {
                        ToastUtils.ToastUtils(getResources().getString(R.string.setting_pwd), RollInOutActivity.this);
                        return;
                    }
                    try {
                        mdialog();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                    break;
                    case R.id.bt_in:
                        if (ButtonUtils.isFastDoubleClick())
                            return;
                        tvTitle.setText(TextUtils.isEmpty(bundle.getString("yuebaoName")) ? "" : "转入" + bundle.getString("yuebaoName"));
                        btAffirmIn.setText(getResources().getString(R.string.affirm_in));
                        if (TextUtils.isEmpty(minTransferInMoney))
                            etMoney.setHint(getResources().getString(R.string.in_balance) + "");
                        else
                            etMoney.setHint(getResources().getString(R.string.in_balance) + "(最低转入金额" + minTransferInMoney + ")");

                        isInOut = true;
                        etMoney.setText("");
                        for (int i = 0; i < limit.size(); i++) {
                            limit.get(i).setSelected(false);
                        }
                        adapter.notifyDataSetChanged();
                        break;
                    case R.id.bt_out:
                        if (ButtonUtils.isFastDoubleClick())
                            return;
                        tvTitle.setText(TextUtils.isEmpty(bundle.getString("yuebaoName")) ? "" : "转出" + bundle.getString("yuebaoName"));
                        if (TextUtils.isEmpty(maxTransferOutMoney))
                            etMoney.setHint(getResources().getString(R.string.out_balance) + "");
                        else
                            etMoney.setHint(getResources().getString(R.string.out_balance) + "(最高转出金额" + maxTransferOutMoney + ")");
                        btAffirmIn.setText(getResources().getString(R.string.affirm_out));
                        isInOut = false;
                        etMoney.setText("");
                        for (int i = 0; i < limit.size(); i++) {
                            limit.get(i).setSelected(false);
                        }
                        adapter.notifyDataSetChanged();

                        break;
                }
    }

        private void intentData () {
            Intent intent = new Intent();
            if (yuebaobean1 != null && yuebaobean1.getCode() == 0 && yuebaobean1.getData() != null) {
                if (!TextUtils.isEmpty(yuebaobean1.getData().getBalance()))
                    intent.putExtra("balance", yuebaobean1.getData().getBalance());

                if (!TextUtils.isEmpty(yuebaobean1.getData().getAnnualizedRate()))
                    intent.putExtra("annualizedRate", yuebaobean1.getData().getAnnualizedRate());

                if (!TextUtils.isEmpty(yuebaobean1.getData().getTodayProfit()))
                    intent.putExtra("todayProfit", yuebaobean1.getData().getTodayProfit());

                if (!TextUtils.isEmpty(yuebaobean1.getData().getWeekProfit()))
                    intent.putExtra("weekProfit", yuebaobean1.getData().getWeekProfit());

                if (!TextUtils.isEmpty(yuebaobean1.getData().getMonthProfit()))
                    intent.putExtra("monthProfit", yuebaobean1.getData().getMonthProfit());

                if (!TextUtils.isEmpty(yuebaobean1.getData().getTotalProfit()))
                    intent.putExtra("totalProfit", yuebaobean1.getData().getTotalProfit());
                setResult(Activity.RESULT_OK, intent);
            }

        }

        private void mdialog () {
            String[] array = getResources().getStringArray(R.array.affirm_change);
            View inflate = LayoutInflater.from(RollInOutActivity.this).inflate(R.layout.alertext_from, null);
            final EditText et = (EditText) inflate.findViewById(R.id.from_et);
            et.setHint(getResources().getString(R.string.inputpaypw));
            et.setKeyListener(DigitsKeyListener.getInstance("0123456789"));
            et.setTransformationMethod(PasswordTransformationMethod.getInstance());
            et.requestFocus();
            InputFilter[] filters = {new InputFilter.LengthFilter(4)};
            et.setFilters(filters);
            TDialog mTDialog = new TDialog(RollInOutActivity.this, TDialog.Style.Center, array, getResources().getString(R.string.inputpaypw),
                    "", "", new TDialog.onItemClickListener() {
                @Override
                public void onItemClick(Object object, int pos) {
                    String pwd = et.getText().toString().trim();
                    if (pos == 1) {
                        if (TextUtils.isEmpty(pwd)) {
                            ToastUtils.ToastUtils(getResources().getString(R.string.inputpaypw), RollInOutActivity.this);
                        } else {
                            try {
                                questTransfer(pwd);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                        }
                    }
                }
            });
            mTDialog.setMsgGravity(Gravity.CENTER);
            mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
            mTDialog.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
            mTDialog.addView(inflate);
            mTDialog.show();
        }

        private void questTransfer (String pwd){
            String token = SPConstants.checkLoginInfo(RollInOutActivity.this);
            TransferBean tf = new TransferBean();
            tf.setInOrOut(SecretUtils.DESede(isInOut ? "in" : "out"));
            tf.setMoney(SecretUtils.DESede(mEtMoney));
            tf.setPwd(SecretUtils.DESedePassw(pwd));
            tf.setToken(SecretUtils.DESede(token));
            tf.setSign(SecretUtils.RsaToken());
            Gson gson = new Gson();
            String json = gson.toJson(tf);
            RequestBody body = RequestBody.create(Constants.JSON, json);
            OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.TRANSFER + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                    .tag(this)//
                    .upRequestBody(body)
                    .execute(new NetDialogCallBack(this, true, this,
                            true, BaseBean.class) {
                        @Override
                        public void onUi(Object o) throws IOException {
                            BaseBean li = (BaseBean) o;
                            if (li != null && li.getCode() == 0 && !TextUtils.isEmpty(li.getMsg())) {
                                ToastUtils.ToastUtils(li.getMsg(), RollInOutActivity.this);
                                getUserInfo();
                                getData();
                                etMoney.setText("");
                                limit.get(pos).setSelected(false);
                                adapter.notifyItemChanged(pos);
                            } else if (li != null && li.getCode() != 0 && !TextUtils.isEmpty(li.getMsg())) {
                                ToastUtils.ToastUtils(li.getMsg(), RollInOutActivity.this);
                            }
                        }

                        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
                        @Override
                        public void onErr(BaseBean bb) throws IOException {

                        }

                        @Override
                        public void onFailed(Response<String> response) {

                        }
                    });

        }

        //获取登录信息
        private void getUserInfo () {
            String token = SPConstants.checkLoginInfo(RollInOutActivity.this);
            OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO +  SecretUtils.DESede(token)+"&sign="+ SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(this, true, this, true, UserInfo.class) {
                @Override
                public void onUi(Object o) throws IOException {
                    UserInfo li = (UserInfo) o;
                    if (li != null && li.getCode() == 0) {
                        SharedPreferences sp = getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
                        SharedPreferences.Editor edit = sp.edit();
                        edit.putString(SPConstants.SP_BALANCE, FormatNum.amountFormat(li.getData().getBalance(), 4));   //金额
                        edit.putString(SPConstants.SP_USR, li.getData().getUsr());
                        edit.putString(SPConstants.SP_CURLEVELGRADE, li.getData().getCurLevelGrade());
                        edit.putString(SPConstants.SP_NEXTLEVELGRADE, li.getData().getNextLevelGrade());
                        edit.putString(SPConstants.SP_CURLEVELINT, li.getData().getCurLevelInt());
                        edit.putString(SPConstants.SP_NEXTLEVELINT, li.getData().getNextLevelInt());
                        edit.putString(SPConstants.SP_TASKREWARDTITLE, li.getData().getTaskRewardTitle());
                        edit.putString(SPConstants.SP_TASKREWARDTOTAL, li.getData().getTaskRewardTotal());
                        edit.putString(SPConstants.SP_HASBANKCARD, li.getData().isHasBankCard() + "");
                        edit.putString(SPConstants.SP_HASFUNDPWD, li.getData().isHasFundPwd() + "");
                        edit.putString(SPConstants.SP_ISTEST, li.getData().isIsTest() + "");
                        edit.putString(SPConstants.SP_UNREADMSG, li.getData().getUnreadMsg() + "");
                        edit.putString(SPConstants.SP_TASKREWARD, li.getData().getTaskReward());
                        //头像
                        edit.putString(SPConstants.AVATAR, li.getData().getAvatar());
                        edit.putString(SPConstants.SP_CURLEVELTITLE, li.getData().getCurLevelTitle());
                        edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, li.getData().isYuebaoSwitch());
                        edit.commit();
                        EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                        tvBalance.setText((FormatNum.amountFormat(li.getData().getBalance(), 4)));
                        ShareUtils.saveObject(RollInOutActivity.this, SPConstants.USERINFO, li);
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


        private void getData () {
            String token = SPConstants.checkLoginInfo(RollInOutActivity.this);
            OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.YUEBAO + SecretUtils.DESede(token)+"&sign="+SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(RollInOutActivity.this, true, RollInOutActivity.this, true, YuebaoBean.class) {
                @Override
                public void onUi(Object o) throws IOException {
                    yuebaobean1 = (YuebaoBean) o;
                    if (yuebaobean1 != null && yuebaobean1.getCode() == 0 && yuebaobean1.getData() != null) {
                        if (!TextUtils.isEmpty(yuebaobean1.getData().getYuebaoName()))
                            tvTitle.setText((isInOut ? "转入" : "转出") + yuebaobean1.getData().getYuebaoName());
                        if (!TextUtils.isEmpty(yuebaobean1.getData().getTodayProfit()))
                            tvDataProfit.setText(yuebaobean1.getData().getTodayProfit());
                        if (!TextUtils.isEmpty(yuebaobean1.getData().getBalance()))
                            tvInterest.setText(yuebaobean1.getData().getBalance());

                        String bal = null;
                        if (!TextUtils.isEmpty(yuebaobean1.getData().getBalance())) {
                            bal = yuebaobean1.getData().getBalance();
                        }
                        if (!TextUtils.isEmpty(yuebaobean1.getData().getAnnualizedRate())) {
                            double rate = Double.parseDouble(yuebaobean1.getData().getAnnualizedRate());
                            bal += "年化率" + ShowItem.subZeroAndDot((rate * 100) + "") + "%";
                            tvAllmoney.setText("总金额 " + bal);
                        }

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
        protected void onDestroy () {
            super.onDestroy();
            OkGo.getInstance().cancelAll();
        }

        @Override
        public void onBackPressed () {
            intentData();
            super.onBackPressed();
        }

}
