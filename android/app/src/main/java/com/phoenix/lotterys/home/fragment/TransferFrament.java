package com.phoenix.lotterys.home.fragment;

import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;

import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.LimitTransformActivity;
import com.phoenix.lotterys.my.adapter.GameNameAdapter;
import com.phoenix.lotterys.my.adapter.MyitemAdapter;
import com.phoenix.lotterys.my.adapter.TransferAdapter;
import com.phoenix.lotterys.my.bean.BalanceBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.OneKeyTransferBean;
import com.phoenix.lotterys.my.bean.QuickTransferOutBean;
import com.phoenix.lotterys.my.bean.TransformBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.bean.WalletBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

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
 * on 2019/10/4
 */
@SuppressLint("ValidFragment")
public class TransferFrament extends BaseFragments {

    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.et_out)
    EditText etOut;
    @BindView(R2.id.cb_out)
    ImageView cbOut;
    @BindView(R2.id.et_in)
    EditText etIn;
    @BindView(R2.id.cb_in)
    ImageView cbIn;
    @BindView(R2.id.et_money)
    EditText etMoney;
    @BindView(R2.id.bt_login)
    Button btLogin;
    @BindView(R2.id.tv_money)
    TextView tvMoney;
    @BindView(R2.id.tv_refresh)
    ImageView tvRefresh;
    @BindView(R2.id.rv)
    RecyclerView rv;
    @BindView(R2.id.card)
    CardView card;
    @BindView(R2.id.card2)
    CardView card2;

    List<WalletBean.DataBean> data = new ArrayList<>();
    List<WalletBean.DataBean> dataPop = new ArrayList<>();
    int in = -1, out = -1;
    int id;
    @BindView(R2.id.tv_title_out)
    TextView tvTitleOut;
    @BindView(R2.id.tv_title_in)
    TextView tvTitleIn;
    @BindView(R2.id.tv_title_money)
    TextView tvTitleMoney;
    @BindView(R2.id.tv_bl)
    TextView tv_bl;

    private String balance = "?c=real&a=checkBalance&id=%s&token=%s";   //真人游戏余额
    private GameNameAdapter popadapter;
    boolean isHide = false;

    @SuppressLint("ValidFragment")
    public TransferFrament(boolean isHide) {
        super(R.layout.activity_transfer, true, true);
        this.isHide = isHide;
    }

    @Override
    public void initView(View view) {
        dataPop.add(new WalletBean.DataBean("中心钱包", "0"));
        mEditText(etOut);
        mEditText(etIn);
        getGameList();

        titlebar.setRightMove("转换记录", true);
        tvMoney.setText(SPConstants.getValue(getActivity(), SPConstants.SP_BALANCE));
        tvMoney.setTransformationMethod(PasswordTransformationMethod.getInstance());
        tvRefresh.setVisibility(View.VISIBLE);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                getActivity().finish();
            }
        });
        titlebar.setRightTextOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                IntentUtils.getInstence().intent(getActivity(), LimitTransformActivity.class);
            }
        });

        setTheme();
        if (isHide)
            titlebar.setIvBackHide(View.GONE);

        Uiutils.setBarStye0(titlebar,getContext());
    }

    private void getBalance(String id, int pos) {
        String token = SPConstants.checkLoginInfo(getActivity());
        String url = Constants.BaseUrl() + Constants.CHECKBALANCE + String.format(balance, SecretUtils.DESede(id), SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken());
        OkGo.<String>get(URLDecoder.decode(url)).tag(this).execute(new NetDialogCallBack(getActivity(), false, getActivity(), true, BalanceBean.class) {
            @SuppressLint("SetTextI18n")
            @Override
            public void onUi(Object o) throws IOException {
                BalanceBean balance = (BalanceBean) o;
                if (balance != null && balance.getCode() == 0 && balance.getData() != null && !TextUtils.isEmpty(balance.getData().getBalance())) {
                    data.get(pos).setBalance(balance.getData().getBalance());
                    popadapter.notifyItemChanged(pos);
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

    private void getGameList() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.WALLETLIST)).tag(this).execute(new NetDialogCallBack(getActivity(), true, getActivity(), true, WalletBean.class) {
            @SuppressLint("SetTextI18n")
            @Override
            public void onUi(Object o) throws IOException {
                WalletBean wallet = (WalletBean) o;
                if (wallet != null && wallet.getCode() == 0 && wallet.getData() != null) {

//                    for (WalletBean.DataBean wb : wallet.getData()) {
                    data.addAll(wallet.getData());
                    dataPop.addAll(wallet.getData());
//                    }
                    initBankRecycler();
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

    private void mEditText(EditText et) {
        et.setFocusableInTouchMode(false);//不可编辑
        et.setKeyListener(null);//不可粘贴，长按不会弹出粘贴框
        et.setFocusable(false);//不可编辑
    }

    private void initBankRecycler() {
        popadapter = new GameNameAdapter();
        rv.setAdapter(popadapter);
        popadapter.setData(data, getActivity());
        rv.addItemDecoration(new SpacesItemDecoration(getActivity()));
        rv.setLayoutManager(new LinearLayoutManager(getActivity()));
        popadapter.setOnItemClickListener(new GameNameAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                getBalance(data.get(position).getId(), position);
            }
        });
    }

    private CustomPopWindow mCustomPopWindow;

    private void showPopMenu(Boolean active, EditText et) {
        View contentView = LayoutInflater.from(getActivity()).inflate(R.layout.pop_list, null);
        //处理popWindow 显示内容
        handleLogic(contentView, active);
        //创建并显示popWindow
        mCustomPopWindow = new CustomPopWindow.PopupWindowBuilder(getActivity())
                .setView(contentView)
                .enableBackgroundDark(true) //弹出popWindow时，背景是否变暗
                .setBgDarkAlpha(0.7f) // 控制亮度
                .create()
                .showAsDropDown(et, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private void handleLogic(View contentView, Boolean active) {
        RecyclerView recyclerView = (RecyclerView) contentView.findViewById(R.id.recyclerView);
        LinearLayoutManager manager = new LinearLayoutManager(getActivity());
        manager.setOrientation(LinearLayoutManager.VERTICAL);
        recyclerView.setLayoutManager(manager);
        TransferAdapter adapter = new TransferAdapter(getContext());
        recyclerView.setAdapter(adapter);
        adapter.setData(dataPop);
        adapter.notifyDataSetChanged();
        adapter.setOnItemClickListener(new MyitemAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (mCustomPopWindow != null) {
                    mCustomPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                }
                if (active) {
                    if (position == in) {
                        ToastUtils.ToastUtils(getResources().getString(R.string.out_in), getActivity());
                        return;
                    }
                    out = position;
                    etOut.setText(dataPop.get(position).getTitle());
                } else {
                    if (position == out) {
                        ToastUtils.ToastUtils(getResources().getString(R.string.out_in), getActivity());
                        return;
                    }
                    in = position;
                    etIn.setText(dataPop.get(position).getTitle());
                }
            }
        });
    }

    private boolean isSee = true;

    @OnClick({R.id.bt_login, R.id.tv_refresh, R.id.et_out, R.id.et_in, R.id.tv_money, R.id.bt_onekey})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.bt_login:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (SPConstants.isTourist(getActivity())) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.transfer_user), getActivity());
                    return;
                }
                String money = etMoney.getText().toString().trim();
                String textOut = etOut.getText().toString().trim();
                String textIn = etIn.getText().toString().trim();
                if (TextUtils.isEmpty(textOut)) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.select_out), getActivity());
                    return;
                }
                if (TextUtils.isEmpty(textIn)) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.select_in), getActivity());
                    return;
                }
                if (TextUtils.isEmpty(money)) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.input_money), getActivity());
                    return;
                }
                questManualTransfer(money);
                break;
            case R.id.tv_money:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                isSee = !isSee;
                if (isSee) {//¥
                    tvMoney.setTransformationMethod(PasswordTransformationMethod.getInstance());   //暗文
                    tvRefresh.setVisibility(View.GONE);
                } else {
                    tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance()); //明文
                    tvRefresh.setVisibility(View.VISIBLE);
                }
                break;
            case R.id.tv_refresh:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                ObjectAnimator objectAnimator;
                objectAnimator = ObjectAnimator.ofFloat(tvRefresh, "rotation", 0f, 360f);
                objectAnimator.setDuration(1500);
                objectAnimator.start();
                getUserInfo(false);
                break;
            case R.id.et_out:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                showPopMenu(true, etOut);
                break;
            case R.id.et_in:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                showPopMenu(false, etIn);
                break;
            case R.id.bt_onekey:
                questOnekey();
                break;
        }
    }


    //一键转出获取转出的游戏
    private void questOnekey() {
        String token = SPConstants.checkLoginInfo(getActivity());
        TransformBean tf = new TransformBean();
        tf.setSign(SecretUtils.RsaToken());
        if (!TextUtils.isEmpty(token))
            tf.setToken(SecretUtils.DESede(token));
        Gson gson = new Gson();
        String json = gson.toJson(tf);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.ONEKEYTRANSFEROUT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getActivity(), true, getActivity(),
                        true, OneKeyTransferBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        OneKeyTransferBean onekey = (OneKeyTransferBean) o;
                        if (onekey != null && onekey.getCode() == 0 && !TextUtils.isEmpty(onekey.getMsg())&&onekey.getData()!=null) {

//                            String[] array = {getResources().getString(R.string.affirm)};
//                            TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, getResources().getString(R.string.info), rb.getMsg(), "", new TDialog.onItemClickListener() {
//                                @Override
//                                public void onItemClick(Object object, int position) {
//                                }
//                            });
//                            mTDialog.setCancelable(false);
//                            mTDialog.show();
//                            getUserInfo(false);
                            if(onekey.getData().getGames()!=null&&onekey.getData().getGames().size()>0){
                                for(int i = 0;i<onekey.getData().getGames().size();i++){
                                    questOut(onekey.getData().getGames().get(i).getId());
                                }
                            }
//                            onTransformResume();

                            if (data != null && data.size() > 0) {
                                for (WalletBean.DataBean wallet : data) {
                                    wallet.setBalance("");
                                }
                                getUserInfo(false);
                            }
                            if (popadapter != null) {
                                popadapter.notifyDataSetChanged();
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

    private void questOut(String id) {
        String token = SPConstants.checkLoginInfo(getActivity());
        QuickTransferOutBean tf = new QuickTransferOutBean();
        tf.setSign(SecretUtils.RsaToken());
        if (!TextUtils.isEmpty(token))
            tf.setToken(SecretUtils.DESede(token));
        tf.setId(SecretUtils.DESede(id));
        Gson gson = new Gson();
        String json = gson.toJson(tf);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.QUICKTRANSFEROUT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getActivity(), true, getActivity(),
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean onekey = (BaseBean) o;
                        if (onekey != null && onekey.getCode() == 0 && !TextUtils.isEmpty(onekey.getMsg())) {

//                            String[] array = {getResources().getString(R.string.affirm)};
//                            TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, getResources().getString(R.string.info), rb.getMsg(), "", new TDialog.onItemClickListener() {
//                                @Override
//                                public void onItemClick(Object object, int position) {
//                                }
//                            });
//                            mTDialog.setCancelable(false);
//                            mTDialog.show();
//                            getUserInfo(false);
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

    private void questManualTransfer(String money) {
        String token = SPConstants.checkLoginInfo(getActivity());
        String fromId = dataPop.get(out).getId();
        String toId = dataPop.get(in).getId();
        TransformBean tf = new TransformBean();
        tf.setMoney(SecretUtils.DESede(money));
        tf.setFromId(SecretUtils.DESede(fromId));
        tf.setToId(SecretUtils.DESede(toId));
        tf.setSign(SecretUtils.RsaToken());
        if (!TextUtils.isEmpty(token))
            tf.setToken(SecretUtils.DESede(token));
        Gson gson = new Gson();
        String json = gson.toJson(tf);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.MANUALTRANSFER + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getActivity(), true, getActivity(),
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean rb = (BaseBean) o;
                        if (rb != null && rb.getCode() == 0 && !TextUtils.isEmpty(rb.getMsg())) {
//                            ToastUtils.ToastUtils(rb.getMsg(), TransferActivity.this);

                            String[] array = {getResources().getString(R.string.affirm)};
                            TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, getResources().getString(R.string.info), rb.getMsg(), "", new TDialog.onItemClickListener() {
                                @Override
                                public void onItemClick(Object object, int position) {

                                }
                            });
                            mTDialog.setCancelable(false);
                            mTDialog.show();

                            etMoney.setText("");
                            if (out != 0)
                                getBalance(fromId, out - 1);
                            else
                                getUserInfo(false);
                            if (in != 0)
                                getBalance(toId, in - 1);
                            else
                                getUserInfo(false);
                        } else if (rb != null && rb.getCode() != 0 && rb.getMsg() != null) {

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


    //获取登录信息
    private void getUserInfo(boolean b) {
        String token = SPConstants.checkLoginInfo(getContext());
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken())).tag(getActivity()).execute(new NetDialogCallBack(getActivity(), true, getActivity(), true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                UserInfo li = (UserInfo) o;
                if (li != null && li.getCode() == 0) {
                    SharedPreferences sp;
                    sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
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
                    ShareUtils.saveObject(getActivity(), SPConstants.USERINFO, li);
                    EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                    tvMoney.setText(FormatNum.amountFormat(li.getData().getBalance(), 4));
                    if (!b)
                        tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance()); //明文
                    else
                        tvMoney.setTransformationMethod(PasswordTransformationMethod.getInstance()); //暗文

                    if (tvRefresh.getVisibility() == View.GONE)
                        tvRefresh.setVisibility(View.VISIBLE);
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
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                setTheme();
                break;
        }
    }

    private void setTheme() {
        Uiutils.setBaColor(getContext(), titlebar, false, null);
        Uiutils.setBaColor(getContext(), btLogin, false, null);
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), card, false, null);
                Uiutils.setBaColor(getContext(), card2);
                Uiutils.setBaColor(getContext(), llMain);
                tvMoney.setTextColor(getResources().getColor(R.color.white));
                tvTitleOut.setTextColor(getResources().getColor(R.color.white));
                tvTitleIn.setTextColor(getResources().getColor(R.color.white));
                tvTitleMoney.setTextColor(getResources().getColor(R.color.white));
                etOut.setTextColor(getResources().getColor(R.color.white));
                etIn.setTextColor(getResources().getColor(R.color.white));
                etMoney.setTextColor(getResources().getColor(R.color.white));
                tv_bl.setTextColor(getResources().getColor(R.color.white));

            }
        }
    }

    protected void onTransformResume() {
        getUserInfo(true);
        if (data != null && data.size() > 0) {
            for (WalletBean.DataBean wallet : data) {
                wallet.setBalance("");
            }
        }
        if (popadapter != null) {
            popadapter.notifyDataSetChanged();
        }
    }


}
