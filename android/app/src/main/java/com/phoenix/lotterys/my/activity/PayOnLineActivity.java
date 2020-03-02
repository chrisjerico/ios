package com.phoenix.lotterys.my.activity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Spanned;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.baoyz.actionsheet.ActionSheet;
import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.BankOnLineAdapter;
import com.phoenix.lotterys.my.adapter.LimitItemAdapter;
import com.phoenix.lotterys.my.adapter.SelectPayOnLineAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.OffLineBean;
import com.phoenix.lotterys.my.bean.OnLinePayBean;
import com.phoenix.lotterys.my.bean.PaymentBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.CRequest;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.SpacesItemDecoration1;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.MoneyTextWatcher;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.zzhoujay.html.Html;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;


/**
 * Greated by Luke
 * on 2019/8/27
 */

//在线支付
public class PayOnLineActivity extends BaseActivitys implements ActionSheet.ActionSheetListener {
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.et_money)
    EditText etMoney;
    @BindView(R2.id.rv_money)
    RecyclerView rvMoney;
    @BindView(R2.id.tv_hint)
    TextView tvHint;
    @BindView(R2.id.rv_select)
    RecyclerView rvSelect;
    @BindView(R2.id.bt_topup)
    Button btTopup;
    LinearLayoutManager layoutManager;
    @BindView(R2.id.tv_bank)
    TextView tvBank;
    @BindView(R2.id.bank_line)
    View bank_line;
    @BindView(R2.id.tv_recharge)
    TextView tvRecharge;
    @BindView(R2.id.view_line)
    View viewLine;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    @BindView(R2.id.ll_money)
    LinearLayout llMoney;

    @BindView(R2.id.ll_bank)
    LinearLayout llBank;
    private LimitItemAdapter adapter;
    private BankOnLineAdapter popadapter;
    private PaymentBean pay;
    int posPay;
    List<PaymentBean.ChannelBean.ParaBean.BankListBean> bankList = new ArrayList<>();
    private List<My_item> limit = new ArrayList<>();
    private String thirdPartyPayment = "&payId=%s&gateway=%s&money=%s&token=%s";

    public PayOnLineActivity() {
        super(R.layout.activity_pay_on_line);
    }

    public void getIntentData() {
        Bundle bundle = getIntent().getExtras();
        pay = (PaymentBean) bundle.getSerializable("Channel");
    }

    @Override
    public void initView() {
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        etMoney.addTextChangedListener(new MoneyTextWatcher(etMoney));
        setEdit(etMoney, btTopup);
        initlimit();
        checkData();
        setTheme();


        Uiutils.setBarStye0(titlebar, this);
    }

    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(PayOnLineActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(getContext(), card, false, null);
                Uiutils.setBaColor(PayOnLineActivity.this, rlMain);
//                tvTitledate.setTextColor(getResources().getColor(R.color.font));
                tvHint.setTextColor(getResources().getColor(R.color.font));
                tvRecharge.setTextColor(getResources().getColor(R.color.fount1));
                tvBank.setTextColor(getResources().getColor(R.color.font));
                tvBank.setHintTextColor(getResources().getColor(R.color.font));
            }
        }
    }

    private void checkData() {
        if (pay == null)
            return;
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
        if (!TextUtils.isEmpty(pay.getRecharge_alarm()))
            tvRecharge.setText(pay.getRecharge_alarm());
        if (pay.getPrompt() != null){
            Spanned spanned = Html.fromHtml(pay.getPrompt());
            tvHint.setText(spanned);
//            tvHint.setText(pay.getPrompt());
        }
        setMoney(0);
        if (pay.getChannel() != null && pay.getChannel().size() > 0)
            initRecycler();
        if (pay.getChannel() == null || pay.getChannel().size() == 0)
            return;
        if (pay.getChannel().get(0).getPara() != null && pay.getChannel().get(0).getPara().getBankList() != null && pay.getChannel().get(0).getPara().getBankList().size() > 0) {
            llBank.setVisibility(View.VISIBLE);
            bank_line.setVisibility(View.VISIBLE);
            bankList.addAll(pay.getChannel().get(0).getPara().getBankList());
        }
    }

    private void setMoney(int i) {
        etMoney.setText("");
        if (pay.getChannel() != null && pay.getChannel() != null && pay.getChannel().size() > 0 && pay.getChannel().get(i).getPara() != null && !TextUtils.isEmpty(pay.getChannel().get(i).getPara().getFixedAmount())) {
            addData(true, i);
            rvMoney.setVisibility(View.VISIBLE);
            if (BuildConfig.FLAVOR.equals("c200")) {
                llMoney.setVisibility(View.GONE);
            }
        } else if (pay.getChannel() != null && pay.getChannel() != null && pay.getChannel().size() > 0 && pay.getChannel().get(i).getPara() != null && TextUtils.isEmpty(pay.getChannel().get(i).getPara().getFixedAmount()) && pay.getQuickAmount() != null && pay.getQuickAmount().size() > 0) {
            addData(false, 0);
            rvMoney.setVisibility(View.VISIBLE);
            if (BuildConfig.FLAVOR.equals("c200")) {
                llMoney.setVisibility(View.GONE);
            }
        } else {
            rvMoney.setVisibility(View.GONE);
            if (BuildConfig.FLAVOR.equals("c200")) {
                llMoney.setVisibility(View.VISIBLE);
            }
        }
    }

    private void addData(boolean isShare, int position) {
        if (limit != null) {
            limit.clear();
        }
        if (isShare) {
            if (!TextUtils.isEmpty(pay.getChannel().get(position).getPara().getFixedAmount())) {
                String fixedAmount = pay.getChannel().get(position).getPara().getFixedAmount();
                String[] arr = fixedAmount.split("\\s+");
                for (String s : arr) {
                    limit.add(new My_item(s, false));
                }
            }
        } else {
            for (int i = 0; i < pay.getQuickAmount().size(); i++) {
                limit.add(new My_item(pay.getQuickAmount().get(i), false));
            }
        }
        if (adapter != null)
            adapter.notifyDataSetChanged();
    }


    private void initlimit() {
        layoutManager = new GridLayoutManager(this, 3);
        rvMoney.setLayoutManager(layoutManager);
        rvMoney.setItemAnimator(new DefaultItemAnimator());
        int space = 8;
        rvMoney.addItemDecoration(new SpacesItemDecoration1(space));
//        if (pay != null && pay.getQuickAmount() != null)
        adapter = new LimitItemAdapter(limit, this);
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
                etMoney.setText(limit.get(position).getTitle());
                etMoney.setSelection(limit.get(position).getTitle().length());
            }
        });
    }

    private void initRecycler() {
        pay.getChannel().get(0).setSelect(true);
        SelectPayOnLineAdapter selectPayType = new SelectPayOnLineAdapter(pay.getChannel(), this);
        layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvSelect.setLayoutManager(layoutManager);
        rvSelect.setAdapter(selectPayType);
        rvSelect.addItemDecoration(new SpacesItemDecoration(PayOnLineActivity.this));
        selectPayType.setListener(new SelectPayOnLineAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                posPay = position;
                selectPayType.ClearItem(position);

                tvBank.setHint(getResources().getString(R.string.select_bank));
                tvBank.setText("");
                if (llBank.getVisibility() == View.VISIBLE && bankList != null && bankList.size() > 0) {
                    bankList.clear();
                    pos = -1;
                    bankList.addAll(pay.getChannel().get(position).getPara().getBankList());
                    for (PaymentBean.ChannelBean.ParaBean.BankListBean bank : bankList) {
                        bank.setSelect(false);
                    }
                    if (popadapter != null)
                        popadapter.notifyDataSetChanged();
                }
                setMoney(position);
            }
        });
    }

    int pos = -1;

    @OnClick({R.id.ll_bank, R.id.bt_topup})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.ll_bank:
//                showPopMenu();
                showTDialog();
                break;
            case R.id.bt_topup:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                try {
                    getOnLine();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
        }
    }

    private void showTDialog() {
        List<String> items = new ArrayList<>();
        if (bankList != null && bankList.size() > 0) {
            for (int i = 0; i < bankList.size(); i++) {
                items.add(bankList.get(i).getName());
            }
            TDialog mTDialog = new TDialog(PayOnLineActivity.this, TDialog.Style.DownSheet, items,
                    "请选择银行", "", "", new TDialog.onItemClickListener() {
                @Override
                public void onItemClick(Object object, int position) {
                    pos = position;
                    if (bankList != null && bankList.size() != 0) {
                        tvBank.setText(bankList.get(position).getName());
                    }
                }
            });
            mTDialog.setCancelable(true);
            mTDialog.show();
        }
    }

    String payId = "";
    String gateway = "";

    private void getOnLine() {
        String money = etMoney.getText().toString().trim();
        if (money == null || money.length() == 0) {
            if(llMoney.getVisibility()==View.GONE)
                ToastUtils.ToastUtils("请选择存款金额", PayOnLineActivity.this);
            else
                ToastUtils.ToastUtils(getResources().getString(R.string.deposit_money), PayOnLineActivity.this);
            return;
        }

        if (bank_line.getVisibility() == View.VISIBLE) {
            String bank = tvBank.getText().toString().trim();
            if (TextUtils.isEmpty(bank)) {
                ToastUtils.ToastUtils(getResources().getString(R.string.select_bank), PayOnLineActivity.this);
                return;
            }
        }
        String token = SPConstants.checkLoginInfo(PayOnLineActivity.this);
        OffLineBean ol = new OffLineBean();
        ol.setMoney(SecretUtils.DESede(money));
        if (!TextUtils.isEmpty(token)) {
            ol.setToken(SecretUtils.DESede(token));
        }
        ol.setSign(SecretUtils.RsaToken());
        if (pay.getChannel() != null && pay.getChannel().size() > 0 && posPay != -1 && !TextUtils.isEmpty(pay.getChannel().get(posPay).getId())) {
            payId = SecretUtils.DESede(pay.getChannel().get(posPay).getId());
            ol.setPayId(payId);
        }
        if (bank_line.getVisibility() == View.VISIBLE && posPay != -1 && !TextUtils.isEmpty(pay.getChannel().get(posPay).getPara().getBankList().get(pos).getCode())) {
            gateway = SecretUtils.DESede(pay.getChannel().get(posPay).getPara().getBankList().get(pos).getCode());
            ol.setGateway(gateway);
        }
        Gson gson = new Gson();
        String json = gson.toJson(ol);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.ONLINE + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(PayOnLineActivity.this, true, PayOnLineActivity.this, true, OnLinePayBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        OnLinePayBean bb = (OnLinePayBean) o;
                        if (bb != null && bb.getCode() == 0 && bb.getData() != null) {
//                            String strRequestKeyAndValues = "";
//                            Map<String, String> mapRequest = CRequest.URLRequest(bb.getData().getUrl());
//                            for (String strRequestKey : mapRequest.keySet()) {
//                                String strRequestValue = mapRequest.get(strRequestKey);
//                                strRequestKeyAndValues += "key:" + strRequestKey + ",Value:" + strRequestValue + ";";
////                                Log.e("xxxxkey", "" + strRequestKeyAndValues);
//                                if (strRequestKey.equals("gateway")) {
//                                    gateway = strRequestValue;
//                                }
//                            }
//                            String url ="";
//                            if(Constants.ENCRYPT){
//                                url = Constants.BaseUrl() + Constants.THIRDPAY + String.format(thirdPartyPayment, SecretUtils.DESede(bb.getData().getParams().getPayId()==null?"":bb.getData().getParams().getPayId()),
//                                        SecretUtils.DESede(bb.getData().getParams().getGateway()==null?"":bb.getData().getParams().getGateway())
//                                        , SecretUtils.DESede(bb.getData().getParams().getMoney()==null?"":bb.getData().getParams().getMoney()),
//                                        SecretUtils.DESede(bb.getData().getParams().getToken()==null?"":bb.getData().getParams().getToken())) + "&sign=" + SecretUtils.RsaToken();
//                            }else {
//                                url = bb.getData().getUrl();
//                            }


//                            Uri webdress = Uri.parse(bb.getData());
                            String strRequestKeyAndValues = "";
                            Map<String, String> mapRequest = CRequest.URLRequest(bb.getData());
                            for (String strRequestKey : mapRequest.keySet()) {
                                String strRequestValue = mapRequest.get(strRequestKey);
                                strRequestKeyAndValues += "key:" + strRequestKey + ",Value:" + strRequestValue + ";";
//                                Log.e("xxxxkey", "" + strRequestKeyAndValues);
                                if (strRequestKey.equals("gateway")) {
                                    gateway = strRequestValue;
                                }
                            }
                            String url = "";
                            if (Constants.ENCRYPT) {
                                url = Constants.BaseUrl() + Constants.THIRDPAY + String.format(thirdPartyPayment, payId, SecretUtils.DESede(gateway)
                                        , SecretUtils.DESede(money), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken();
                            } else {
                                url = bb.getData();
                            }


////                            Uri webdress = Uri.parse(bb.getData().getUrl());
//                            Uri webdress = Uri.parse(url);
//                            Intent intent = new Intent(Intent.ACTION_VIEW, webdress);
//                            startActivity(intent);
                            String str = url.replaceAll("\n", "");
                            String payUrl = URLDecoder.decode(str, "UTF-8");
//                            String newStr = payUrl.replaceAll("\\+","%20");
//                            Log.e("xxxxpay", "" + newStr);
                            Intent intent = new Intent();
                            intent.setAction(Intent.ACTION_VIEW);
                            Uri content_url = Uri.parse(str);
                            intent.setData(content_url);
                            startActivity(intent);

                            finish();
                        } else if (bb != null && bb.getCode() != 0 && bb.getMsg() != null) {
                            ToastUtils.ToastUtils(bb.getMsg(), PayOnLineActivity.this);

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
    public void onDismiss(ActionSheet actionSheet, boolean isCancel) {

    }

    @Override
    public void onOtherButtonClick(ActionSheet actionSheet, int index) {

    }
}
