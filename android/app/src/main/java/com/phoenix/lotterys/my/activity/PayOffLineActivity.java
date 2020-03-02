package com.phoenix.lotterys.my.activity;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.TextWatcher;
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
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.SelectPayOffLineAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.OffLineBean;
import com.phoenix.lotterys.my.bean.PaymentBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.MoneyTextWatcher;
import com.phoenix.lotterys.view.MyNestedScrollView;
import com.phoenix.lotterys.view.QrDialog;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.ToastUtil;
import com.zzhoujay.html.Html;

import java.io.IOException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/8/27
 */

//线下支付
public class PayOffLineActivity extends BaseActivitys {
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;

    @BindView(R2.id.tv_hint)
    TextView tvHint;
    @BindView(R2.id.rv_select)
    RecyclerView rvSelect;
    @BindView(R2.id.bt_topup)
    Button btTopup;
    LinearLayoutManager layoutManager;
    @BindView(R2.id.tv_warn)
    TextView tvWarn;
    @BindView(R2.id.tv_bank_user)
    TextView tvBankUser;
    @BindView(R2.id.tv_payee)
    TextView tvPayee;
    @BindView(R2.id.tv_user)
    TextView tvUser;
    @BindView(R2.id.tv_site)
    TextView tvSite;
    @BindView(R2.id.tv_payee_copy)
    TextView tvPayeeCopy;
    @BindView(R2.id.tv_user_copy)
    TextView tvUserCopy;
    @BindView(R2.id.tv_site_copy)
    TextView tvSiteCopy;
    @BindView(R2.id.et_deposit_money)
    EditText etDepositMoney;
    @BindView(R2.id.tv_deposit_money_num)
    TextView tvDepositMoneyNum;
    @BindView(R2.id.ed_remark)
    EditText edRemark;
    @BindView(R2.id.tv_remark_num)
    TextView tvRemarkNum;
    @BindView(R2.id.et_transfer_name)
    EditText etTransferName;
    @BindView(R2.id.tv_transfer_name)
    TextView tvTransferName;
    @BindView(R2.id.tv_remark_tex)
    TextView tvRemarkTex;
    @BindView(R2.id.tv_transfer)
    TextView tvTransfer;
    @BindView(R2.id.tv_bank_user_copy)
    TextView tvBankUserCopy;
    @BindView(R2.id.ll_content)
    MyNestedScrollView llContent;
    @BindView(R2.id.tv_text1)
    TextView tvText1;
    @BindView(R2.id.tv_text2)
    TextView tvText2;
    @BindView(R2.id.tv_text3)
    TextView tvText3;
    @BindView(R2.id.tv_text4)
    TextView tvText4;
    @BindView(R2.id.view_line)
    View viewLine;
    @BindView(R2.id.ll_remark)
    LinearLayout llRemark;
    @BindView(R2.id.iv_img)
    ImageView ivImg;   //二维码
    @BindView(R2.id.rl_qr)
    RelativeLayout rlQr;
    @BindView(R2.id.ll_site)
    LinearLayout llSite;
    @BindView(R2.id.ll_bank)
    LinearLayout llBank;
    @BindView(R2.id.view_1)
    View view_1;
    @BindView(R2.id.tv_titleuser)
    TextView tvTitleuser;
    @BindView(R2.id.tv_ewm)
    TextView tvEwm;
    @BindView(R2.id.tv_qr)
    TextView tvQr;

    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    Application mApp;
//    @BindView(R2.id.tv_recharge)
//    TextView tvRecharge;
    private PaymentBean pay;
    int pos = 0;
    private QrDialog qrDialog;

    public PayOffLineActivity() {
        super(R.layout.activity_pay_off_line);
    }

    public void getIntentData() {
        Bundle bundle = getIntent().getExtras();
        pay = (PaymentBean) bundle.getSerializable("Channel");
    }

    @Override
    public void initView() {
        mApp = (Application) Application.getContextObject();
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        if (pay == null)
            return;
        if ((pay.getChannel() != null && pay.getChannel().size() != 0)) {
            setTextContent(0);
            initRecycler();
        }
        etDepositMoney.addTextChangedListener(new MoneyTextWatcher(etDepositMoney));
        etDepositMoney.addTextChangedListener(textWatcher);
        edRemark.addTextChangedListener(textWatcher1);
        etTransferName.addTextChangedListener(textWatcher2);
        if (pay.getName() != null) {
            String[] strs = pay.getName().split("\\[");
            if (strs != null && strs.length > 0){
                Spanned spanned = Html.fromHtml(strs[0]+"");
                titlebar.setText(spanned.toString().trim());
            } else{
                Spanned spanned = Html.fromHtml(pay.getName());
                titlebar.setText(spanned.toString().trim());
            }
        }
//        if (!TextUtils.isEmpty(pay.getBankPayPrompt()))
//            tvRecharge.setText(pay.getBankPayPrompt());
        setTheme();

        Uiutils.setBarStye0(titlebar,this);
    }

    private TextWatcher textWatcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
        }

        @Override
        public void afterTextChanged(Editable s) {
            if (etDepositMoney != null) {
                String pw = etDepositMoney.getText().toString().trim();
                tvDepositMoneyNum.setText(pw.length() + "/20");
            }
        }
    };
    //
    private TextWatcher textWatcher1 = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
        }

        @Override
        public void afterTextChanged(Editable s) {
            if (edRemark != null) {
                String pw = edRemark.getText().toString().trim();
                tvRemarkNum.setText(pw.length() + "/20");
            }

        }
    };
    //
    private TextWatcher textWatcher2 = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
        }

        @Override
        public void afterTextChanged(Editable s) {
            if (etTransferName != null) {
                String pw = etTransferName.getText().toString().trim();
                tvTransferName.setText(pw.length() + "/20");
            }
        }
    };
//

    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(PayOffLineActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(getContext(), card, false, null);
                Uiutils.setBaColor(PayOffLineActivity.this, rlMain);
                tvWarn.setTextColor(getResources().getColor(R.color.font));
                tvHint.setTextColor(getResources().getColor(R.color.font));
//                tvRecharge.setTextColor(getResources().getColor(R.color.fount1));
                tvTitleuser.setTextColor(getResources().getColor(R.color.font));
                tvText1.setTextColor(getResources().getColor(R.color.font));
                tvText2.setTextColor(getResources().getColor(R.color.font));
                tvText3.setTextColor(getResources().getColor(R.color.font));
                tvText4.setTextColor(getResources().getColor(R.color.font));
                tvBankUser.setTextColor(getResources().getColor(R.color.font));
                tvPayee.setTextColor(getResources().getColor(R.color.font));
                tvUser.setTextColor(getResources().getColor(R.color.font));
                tvSite.setTextColor(getResources().getColor(R.color.font));
                tvEwm.setTextColor(getResources().getColor(R.color.font));
                tvQr.setTextColor(getResources().getColor(R.color.font));

                etDepositMoney.setTextColor(getResources().getColor(R.color.font));
                edRemark.setTextColor(getResources().getColor(R.color.font));
                etTransferName.setTextColor(getResources().getColor(R.color.font));
                etDepositMoney.setHintTextColor(getResources().getColor(R.color.fount2));
                edRemark.setHintTextColor(getResources().getColor(R.color.fount2));
                etTransferName.setHintTextColor(getResources().getColor(R.color.fount2));

            }
        }
    }
    private void initRecycler() {
        pay.getChannel().get(0).setSelect(true);
        showQr(0);
        SelectPayOffLineAdapter selectPayType = new SelectPayOffLineAdapter(pay.getChannel(), this, pay.getType());
        layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvSelect.setLayoutManager(layoutManager);
        rvSelect.setAdapter(selectPayType);

        selectPayType.setListener(new SelectPayOffLineAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position, List<PaymentBean.ChannelBean> list) {
                selectPayType.ClearItem(position);
                pos = position;
                setTextContent(position);
                showQr(position);
            }
        });
    }

    private void showQr(int position) {
        if(!TextUtils.isEmpty(pay.getChannel().get(position).getQrcode())&&  pay.getChannel().get(position).getQrcode().startsWith("http")){
            rlQr.setVisibility(View.VISIBLE);
            ImageLoadUtil.ImageLoadNoCaching( pay.getChannel().get(position).getQrcode(), PayOffLineActivity.this,ivImg,R.drawable.load_img);
        }else {
            rlQr.setVisibility(View.GONE);
        }
    }

    private void setTextContent(int position) {
        if (pay.getType().equals("wechat_transfer")) {
            tvText1.setText(getResources().getString(R.string.payee));
            tvText2.setText(getResources().getString(R.string.payuser));
            tvText3.setText(getResources().getString(R.string.bank_user));
            tvText4.setText(getResources().getString(R.string.bankname));
            tvBankUser.setText(pay.getChannel().get(position).getDomain());
            tvPayee.setText(pay.getChannel().get(position).getAccount());
            tvUser.setText(pay.getChannel().get(position).getAddress());
            tvSite.setText(pay.getChannel().get(position).getBranchAddress());
            tvBankUserCopy.setVisibility(View.VISIBLE);
            tvBankUser.setTextColor(getResources().getColor(R.color.color_FE63534));
            tvPayee.setTextColor(getResources().getColor(R.color.color_FE63534));
            tvUser.setTextColor(getResources().getColor(R.color.color_FE63534));
            tvSite.setTextColor(getResources().getColor(R.color.color_FE63534));
//            viewLine.setVisibility(View.GONE);
//            llRemark.setVisibility(View.GONE);
//            edRemark.setVisibility(View.GONE);
//            tvWarn.setText("请先转账成功后再点下一步提交存款信息！！！");
        } else if(pay.getType().equals("tenpay_transfer")||pay.getType().equals("yunshanfu_transfer")||pay.getType().equals("wechat_alipay_transfer")){
            tvText1.setText(getResources().getString(R.string.bank_user));
            tvText2.setText(getResources().getString(R.string.payee));
            tvText3.setText(getResources().getString(R.string.bank_account));
            tvText4.setText(getResources().getString(R.string.bank_site));

            tvPayee.setText(pay.getChannel().get(position).getDomain());
            tvUser.setText(pay.getChannel().get(position).getAccount());
            tvSite.setText(pay.getChannel().get(position).getBranchAddress());
            tvBankUser.setText(pay.getChannel().get(position).getAddress());
//            llSite.setVisibility(View.GONE);
//            llBank.setVisibility(View.GONE);
//            view_1.setVisibility(View.GONE);
        } else if(pay.getType().equals("qqpay_transfer")||pay.getType().equals("jdzz_transfer")||pay.getType().equals("ddhb_transfer")||pay.getType().equals("wxsm_transfer")
                ||pay.getType().equals("dshb_transfer")||pay.getType().equals("xlsm_transfer")||pay.getType().equals("zhifubao_transfer")||pay.getType().equals("alihb_online")){
            tvText1.setText(getResources().getString(R.string.name));
            tvText2.setText(getResources().getString(R.string.account_number));
            tvText3.setText(getResources().getString(R.string.bank_user));
            tvText4.setText(getResources().getString(R.string.bankname));
            tvBankUserCopy.setVisibility(View.VISIBLE);
            tvBankUser.setText(pay.getChannel().get(position).getDomain());
            tvPayee.setText(pay.getChannel().get(position).getAccount());
            tvUser.setText(pay.getChannel().get(position).getAddress());
            tvSite.setText(pay.getChannel().get(position).getBranchAddress());
        } else if(pay.getType().equals("bank_transfer")||pay.getType().equals("alipay_transfer")){
            tvText1.setText(getResources().getString(R.string.bank_user));
            tvText2.setText(getResources().getString(R.string.payee));
            tvText3.setText(getResources().getString(R.string.bank_account));
            tvText4.setText(getResources().getString(R.string.bank_site));
            tvBankUserCopy.setVisibility(View.VISIBLE);
            tvBankUser.setText(pay.getChannel().get(position).getAddress());
            tvPayee.setText(pay.getChannel().get(position).getDomain());
            tvUser.setText(pay.getChannel().get(position).getAccount());
            tvSite.setText(pay.getChannel().get(position).getBranchAddress());
        } else {
            tvText1.setText(getResources().getString(R.string.bank_user));
            tvText2.setText(getResources().getString(R.string.payee));
            tvText3.setText(getResources().getString(R.string.bank_account));
            tvText4.setText(getResources().getString(R.string.bank_site));
            tvBankUser.setText(pay.getChannel().get(position).getPayeeName());
            tvPayee.setText(pay.getChannel().get(position).getDomain());
            tvUser.setText(pay.getChannel().get(position).getAccount());
            tvSite.setText(pay.getChannel().get(position).getAddress());
//            tvWarn.setText(pay.getPrompt() == null ? "" : pay.getPrompt());
        }
        if (!TextUtils.isEmpty(pay.getBankPayPrompt()))
            tvWarn.setText(pay.getBankPayPrompt());
        tvWarn.setVisibility(View.VISIBLE);
        if(!TextUtils.isEmpty(pay.getPrompt())){
            Spanned spanned = Html.fromHtml(pay.getPrompt());
            tvHint.setText(spanned);
                tvHint.setBackgroundColor(getResources().getColor(R.color.fount1));
            tvHint.setTextColor(getResources().getColor(R.color.white));
            tvHint.setVisibility(View.VISIBLE);
        }

        seiHintText();
    }

    private void seiHintText() {
        if(pay.getType().equals("bank_transfer")){
            etTransferName.setHint(getResources().getString(R.string.Transfer_name));
        }else if(pay.getType().equals("tenpay_online")){  //云闪付
            etTransferName.setHint(getResources().getString(R.string.pay_ysf));
        }else if(pay.getType().equals("alipay_transfer")){  //支付宝
            etTransferName.setHint(getResources().getString(R.string.pay_alipay));
        }else if(pay.getType().equals("tenpay_transfer")){  //财付通
            etTransferName.setHint(getResources().getString(R.string.pay_cft));
        }else if(pay.getType().equals("wechat_transfer")){  //微信
            etTransferName.setHint(getResources().getString(R.string.pay_wx));
        }else if(pay.getType().equals("wechat_alipay_transfer")&&pay.getType().equals("alihb_online")){  //微信支付宝
            etTransferName.setHint(getResources().getString(R.string.pay_wx_alipay));
        }else if(pay.getType().equals("wechat_alipay_transfer111")){  //支付宝红包
            etTransferName.setHint(getResources().getString(R.string.pay_alipay_hb));
        }else if(pay.getType().equals("jdzz_transfer")){  //支付宝红包
            etTransferName.setHint(getResources().getString(R.string.pay_jd));
        }else if(pay.getType().equals("ddhb_transfer")){  //支付宝红包
            etTransferName.setHint(getResources().getString(R.string.pay_dd));
        }else if(pay.getType().equals("wxsm_transfer")||pay.getType().equals("dk_online")||pay.getType().equals("xnb_online")){  //
            etTransferName.setHint(getResources().getString(R.string.pay_wxsh));
        }else if(pay.getType().equals("dshb_transfer")){  //多闪
            etTransferName.setHint(getResources().getString(R.string.pay_ds));
        }else if(pay.getType().equals("zhifubao_transfer")){  //支付宝
            etTransferName.setHint(getResources().getString(R.string.pay_alipay_nc));
        }else if(pay.getType().equals("yunshanfu_transfer")){  //云闪付线下
            etTransferName.setHint(getResources().getString(R.string.pay_ysf));
        }else {
            etTransferName.setHint(getResources().getString(R.string.Transfer_name));
        }
    }

//    tvPayee  tvUser  tvSite

    @OnClick({R.id.tv_payee_copy, R.id.tv_user_copy, R.id.tv_site_copy, R.id.tv_bank_user_copy, R.id.bt_topup,R.id.iv_img})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_payee_copy:
                String payee = tvPayee.getText().toString().trim();
                clipText(payee);
                break;
            case R.id.tv_user_copy:
                String user = tvUser.getText().toString().trim();
                clipText(user);
                break;
            case R.id.tv_site_copy:
                String site = tvSite.getText().toString().trim();
                clipText(site);
                break;
            case R.id.tv_bank_user_copy:
                String bank = tvBankUser.getText().toString().trim();
                clipText(bank);
                break;
            case R.id.bt_topup:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                questOffLine();
                break;
            case R.id.iv_img:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if(pay.getChannel()!=null&&pay.getChannel().size()>=pos){
                        QrDialog qrDialog = new QrDialog(PayOffLineActivity.this, pay.getChannel().get(pos).getQrcode());
                        qrDialog.show();
                }
                break;
        }
    }


    private void questOffLine() {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// HH:mm:ss
        Date date = new Date(System.currentTimeMillis());
        String money = etDepositMoney.getText().toString().trim();
        String name = etTransferName.getText().toString().trim();
        String remark = edRemark.getText().toString().trim();
        if (money == null || money.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.deposit_money), PayOffLineActivity.this);
            return;
        }
        if (name == null || name.length() == 0) {
//            ToastUtils.ToastUtils(getResources().getString(R.string.Transfer_name), PayOffLineActivity.this);
            ToastUtils.ToastUtils(etTransferName.getHint().toString().trim(), PayOffLineActivity.this);
            return;
        }
        String token = SPConstants.checkLoginInfo(PayOffLineActivity.this);
        OffLineBean ol = new OffLineBean();
        ol.setAmount(SecretUtils.DESede(money));
        if (!TextUtils.isEmpty(token)) {
            ol.setToken(SecretUtils.DESede(token));
        }
        ol.setSign(SecretUtils.RsaToken());

        if (pay.getChannel() != null && pay.getChannel().get(pos).getId() != null)
            ol.setChannel(SecretUtils.DESede(pay.getChannel().get(pos).getId()));

        if (pay.getChannel() != null && pay.getChannel().get(pos).getAccount() != null)
            ol.setPayee(SecretUtils.DESede(pay.getChannel().get(pos).getAccount()));

        ol.setPayer(SecretUtils.DESede(name));
        if (TextUtils.isEmpty(remark)) ;
        ol.setRemark(SecretUtils.DESede(remark));
        ol.setDepositTime(SecretUtils.DESede(simpleDateFormat.format(date)));

        Gson gson = new Gson();
        String json = gson.toJson(ol);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.PAYOFFLINE + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(PayOffLineActivity.this, true, PayOffLineActivity.this, true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean bb = (BaseBean) o;
                        if (bb != null && bb.getCode() == 0 && bb.getMsg() != null) {
                            ToastUtils.ToastUtils(bb.getMsg(), PayOffLineActivity.this);
                            Intent intent = new Intent();
                            intent.putExtra("payState", "1");
                            setResult(Activity.RESULT_OK, intent);

                            finish();
                        } else if (bb != null && bb.getCode() != 0 && bb.getMsg() != null) {
                            ToastUtils.ToastUtils(bb.getMsg(), PayOffLineActivity.this);

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

    private void clipText(String text) {
        if (!TextUtils.isEmpty(text)) {
            ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
            ClipData mClipData = ClipData.newPlainText("", text);
            cm.setPrimaryClip(mClipData);
            ToastUtil.toastShortShow(PayOffLineActivity.this, "复制成功");
        } else {
            ToastUtil.toastShortShow(PayOffLineActivity.this, "文本无内容");
        }
    }
}
