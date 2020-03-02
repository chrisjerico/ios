package com.phoenix.lotterys.my.fragment;

import android.content.Intent;
import androidx.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.fragment.BankManageFrament;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.BankCardInfo;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.DrawBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.net.ObjectCallback;
import com.phoenix.lotterys.net.OkHttp3Utils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import java.io.IOException;
import java.net.URLDecoder;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.Call;
import okhttp3.RequestBody;

/**
 * Created by Luke
 * on 2019/6/28
 */
//取款
public class WithdrawalsFragment extends BaseFragments implements View.OnFocusChangeListener {


    @BindView(R2.id.bt_band_cards)
    Button btBandCards;
    @BindView(R2.id.rl_bank)
    RelativeLayout rlBank;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.et_money)
    EditText etMoney;
    @BindView(R2.id.tv_money_tex)
    TextView tvMoneyTex;
    //    @BindView(R2.id.tv_money_num)
//    TextView tvMoneyNum;
    @BindView(R2.id.ed_pw)
    EditText edPw;
    @BindView(R2.id.tv_bandcard)
    TextView tvBandcard;

    @BindView(R2.id.tv_bank_card)
    TextView tvBankCard;
    @BindView(R2.id.bt_draw_sub)
    Button btDrawSub;
    @BindView(R2.id.ll_money)
    LinearLayout llMoney;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    String token;
    private BankCardInfo bankcard;
    String str = "";

    public WithdrawalsFragment() {
        super(R.layout.fragment_withdrawals, true, true);
    }

    @Override
    public void initView(View view) {

        etMoney.setOnFocusChangeListener(this);
        edPw.setOnFocusChangeListener(this);
//        etMoney.addTextChangedListener(textWatcher);
//        edPw.addTextChangedListener(textWatcher1);
        showBankInfo(true);
        if (refreshLayout != null) {
            refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
            refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
            refreshLayout.setOnRefreshListener(new OnRefreshListener() {
                @Override
                public void onRefresh(RefreshLayout refreshlayout) {
                    refreshlayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                    showBankInfo(true);
                }
            });
        }

        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (configBean != null && configBean.getData() != null) {
            tvMoneyTex.setText("单笔下限" + ShowItem.subZeroAndDot(TextUtils.isEmpty(configBean.getData().getMinWithdrawMoney()) ? "" : configBean.getData().getMinWithdrawMoney()) +
                    ",上限" + ShowItem.subZeroAndDot(TextUtils.isEmpty(configBean.getData().getMaxWithdrawMoney()) ? "" : configBean.getData().getMaxWithdrawMoney()));
        }
        setTheme(configBean);

        if(BuildConfig.FLAVOR.equals("c153")){
            tvBandcard.setText("您还没提现银行卡号");
            btBandCards.setText("提现银行卡");
        }
    }



    private void setTheme(ConfigBean config) {
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), rlMain);
                tvBankCard.setTextColor(getResources().getColor(R.color.font));
                etMoney.setTextColor(getResources().getColor(R.color.font));
                edPw.setTextColor(getResources().getColor(R.color.font));
            }
        }
    }

    private void showBankInfo(boolean b) {
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        if (userInfo == null)
            return;
        if (userInfo.getData() == null)
            return;
        boolean fundpwd = userInfo.getData().isHasFundPwd();
        boolean bankCard = userInfo.getData().isHasBankCard();

        if (!fundpwd || !bankCard) {
            rlBank.setVisibility(View.VISIBLE);
            llMoney.setVisibility(View.GONE);
        } else {
            try {
                if (b)
                    getBankList();
                else
                    backBankList();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void backBankList() {
        token = SPConstants.checkLoginInfo(getContext());
        OkHttp3Utils.doGet(URLDecoder.decode(Constants.BaseUrl() + Constants.BANKCARDLIST + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken()), new ObjectCallback() {
            @Override
            public void onUi(boolean b, String t) {
                String data = t;
                BaseBean bb = new Gson().fromJson(data, BaseBean.class);
                if (bb != null && bb.getCode() == 0) {
                    bankcard = new Gson().fromJson(data, BankCardInfo.class);
                    setTextCard();
                }
            }

            @Override
            public void onFailed(Call call, IOException e) {

            }
        });
    }

    public static WithdrawalsFragment getInstance(String title) {
        WithdrawalsFragment sf = new WithdrawalsFragment();
        return sf;
    }

    private void getBankList() {
        token = SPConstants.checkLoginInfo(getContext());
        String url = Constants.BaseUrl() + Constants.BANKCARDLIST + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(url))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), false, getContext(),
                        true, BankCardInfo.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        bankcard = (BankCardInfo) o;
                        setTextCard();

                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        if (rlBank != null)
                            rlBank.setVisibility(View.VISIBLE);
                        if (llMoney != null)
                            llMoney.setVisibility(View.GONE);
                    }

                    @Override
                    public void onFailed(Response<String> response) {
                        if (rlBank != null)
                            rlBank.setVisibility(View.VISIBLE);
                        if (llMoney != null)
                            llMoney.setVisibility(View.GONE);
                    }
                });
    }

    private void setTextCard() {
        if (rlBank != null)
            rlBank.setVisibility(View.GONE);
        if (llMoney != null)
            llMoney.setVisibility(View.VISIBLE);
        if (bankcard != null && bankcard.getCode() == 0 && bankcard.getData() != null && bankcard.getData().getBankCard() != null) {
            String cardNum = bankcard.getData().getBankCard();
            String result = " 尾号" + cardNum.substring(cardNum.length() - 4, cardNum.length());
            if (tvBankCard != null)
                tvBankCard.setText((bankcard.getData().getBankName() != null ? bankcard.getData().getBankName() : "") + ", " + result + ", " + (bankcard.getData().getOwnerName() != null ? bankcard.getData().getOwnerName() : ""));
        }
    }


    @OnClick({R.id.bt_band_cards, R.id.bt_draw_sub})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.bt_band_cards:
//                Intent intent = new Intent(getActivity(), BankManageActivity.class);
                FragmentUtilAct.startAct(getActivity(), new BankManageFrament(false));
//                startActivityForResult(intent,1002);
                break;
            case R.id.bt_draw_sub:
                questDraw();
                break;
        }
    }

    private void questDraw() {
        String money = etMoney.getText().toString().trim();
        String pw = edPw.getText().toString().trim();
        if (money == null || money.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.money_integer), getContext());
            return;
        }
        if (pw == null || pw.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.pwd_null), getContext());
            return;
        } else if (pw.length() < 4) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_pay_pwd), getContext());
            return;
        }

        String token = SPConstants.checkLoginInfo(getContext());
        DrawBean db = new DrawBean();
        db.setMoney(SecretUtils.DESede(money));
        db.setPwd(SecretUtils.DESedePassw(pw));
        if (!TextUtils.isEmpty(token)) {
            db.setToken(SecretUtils.DESede(token));
        }
        db.setSign(SecretUtils.RsaToken());
        Gson gson = new Gson();
        String json = gson.toJson(db);

        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.WITHDRAW + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getContext(), false, getContext(), true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean bb = (BaseBean) o;
                        if (bb != null && bb.getCode() == 0 && bb.getMsg() != null) {
                            ToastUtils.ToastUtils(bb.getMsg(), getContext());
                            etMoney.setText("");
                            edPw.setText("");
                        } else if (bb != null && bb.getCode() != 0 && bb.getMsg() != null) {
                            ToastUtils.ToastUtils(bb.getMsg(), getContext());
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
    public void onFocusChange(View v, boolean hasFocus) {
        if (hasFocus)
            return;
        switch (v.getId()) {
            case R.id.et_money:  //提款金额
                if (etMoney != null) {
                    String money = etMoney.getText().toString().trim();
                    if (money == null || money.length() == 0) {
//                        tvMoneyTex.setText(getResources().getString(R.string.money_integer));
//                        tvMoneyTex.setVisibility(View.VISIBLE);
                    } else {
//                        tvMoneyTex.setVisibility(View.GONE);
                    }
                }
                break;
            case R.id.ed_pw:    //密码
                if (edPw != null) {
                    String pw = edPw.getText().toString().trim();
                    if (pw == null || pw.length() == 0) {
//                        tvPwTex.setText(getResources().getString(R.string.pwd_null));
//                        tvPwTex.setVisibility(View.VISIBLE);
                    } else if (pw.length() < 4) {
//                        tvPwTex.setText(getResources().getString(R.string.input_pay_pwd));
//                        tvPwTex.setVisibility(View.VISIBLE);
                    } else {
//                        tvPwTex.setVisibility(View.GONE);
                    }
                }
                break;
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == 1002) {
            try {
                showBankInfo(false);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.LOGIN:
//                Log.e("LOGINWithdraw", "LOGIN");
                showBankInfo(true);
                break;
            case EvenBusCode.BINDCARD:
                showBankInfo(false);
                break;
        }
    }

    protected void onTransformResume() {

        showBankInfo(false);
    }

}
