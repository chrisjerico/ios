package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
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
import com.phoenix.lotterys.my.adapter.BankCardAdapter;
import com.phoenix.lotterys.my.adapter.MyitemAdapter;
import com.phoenix.lotterys.my.adapter.PopWindowAdapter;
import com.phoenix.lotterys.my.bean.BankCardInfo;
import com.phoenix.lotterys.my.bean.BankInfo;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.PayPwBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;

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
public class BankManageFrament extends BaseFragments {
    @BindView(R2.id.rv)
    RecyclerView rv;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.et_open_bank)
    EditText etOpenBank;
    @BindView(R2.id.et_address)
    EditText etAddress;
    @BindView(R2.id.et_bank_num)
    EditText etBankNum;
    @BindView(R2.id.et_bank_name)
    EditText etBankName;
    @BindView(R2.id.bt_sub)
    Button btSub;
    @BindView(R2.id.ll_bank)
    LinearLayout llBank;
    @BindView(R2.id.et_loginpw)
    EditText etLoginpw;
    @BindView(R2.id.et_paypwd)
    EditText etPaypwd;
    @BindView(R2.id.et_paypwd2)
    EditText etPaypwd2;
    @BindView(R2.id.bt_subpw)
    Button btSubpw;
    @BindView(R2.id.ll_pay_pw)
    LinearLayout llPayPw;
//    @BindView(R2.id.tv_img1)
//    TextView tvImg1;
    @BindView(R2.id.tv_password)
    TextView tvPassword;
//    @BindView(R2.id.tv_img)
//    TextView tvImg;
    @BindView(R2.id.tv_user)
    TextView tvUser;
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.tv_title_draw)
    TextView tvTitleDraw;
    @BindView(R2.id.tv_title_loginpw)
    TextView tvTitleLoginpw;
    @BindView(R2.id.tv_title_depositpw)
    TextView tvTitleDepositpw;
    @BindView(R2.id.tv_title_affirmpw)
    TextView tvTitleAffirmpw;
    @BindView(R2.id.tv_title_bankinfo)
    TextView tvTitleBankinfo;
    @BindView(R2.id.tv_title_openbank)
    TextView tvTitleOpenbank;
    @BindView(R2.id.tv_title_address)
    TextView tvTitleAddress;
    @BindView(R2.id.tv_title_bankcard)
    TextView tvTitleBankcard;
    @BindView(R2.id.tv_title_cardname)
    TextView tvTitleCardname;

    private BankCardAdapter mAdapter;
    private PopWindowAdapter popadapter;
    private BankInfo bankInfo;
    String bankId;

    boolean fundpwd;
    boolean bankCard;
    private SharedPreferences sp;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    boolean isHide = false;

    @SuppressLint("ValidFragment")
    public BankManageFrament(boolean isHide) {
        super(R.layout.activity_bank_manage, true, true);
        this.isHide = isHide;
    }

    @Override
    public void initView(View view) {
        sp = getActivity().getSharedPreferences("User", Context.MODE_PRIVATE);
        initBankRecycler();
        etOpenBank.setFocusableInTouchMode(false);
        etOpenBank.setKeyListener(null);
        etOpenBank.setFocusable(false);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                getActivity().finish();
            }
        });
        getBank();//获取银行
        showIten();

        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
//                refreshlayout.finishRefresh(2000/*,false*/);//传入false表示刷新失败
                showIten();
            }
        });
        setTheme();
        if (isHide)
            titlebar.setIvBackHide(View.GONE);

        Uiutils.setBarStye0(titlebar,getContext());
    }

    private void setTheme() {
        Uiutils.setBaColor(getContext(), titlebar, false, null);
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), btSubpw, false, null);
                Uiutils.setBaColor(getContext(), btSub, false, null);
                Uiutils.setBaColor(getContext(), llBank, false, null);
                Uiutils.setBaColor(getContext(), llPayPw, false, null);
//                Uiutils.setBaColor(getContext(), card2);
                Uiutils.setBaColor(getContext(), llMain);
                tvTitleDraw.setTextColor(getResources().getColor(R.color.white));
                tvTitleLoginpw.setTextColor(getResources().getColor(R.color.white));
                tvTitleDepositpw.setTextColor(getResources().getColor(R.color.white));
                tvTitleAffirmpw.setTextColor(getResources().getColor(R.color.white));
                tvTitleBankinfo.setTextColor(getResources().getColor(R.color.white));
                tvTitleOpenbank.setTextColor(getResources().getColor(R.color.white));
                tvTitleAddress.setTextColor(getResources().getColor(R.color.white));
                tvTitleBankcard.setTextColor(getResources().getColor(R.color.white));
                tvTitleCardname.setTextColor(getResources().getColor(R.color.white));

                etOpenBank.setTextColor(getResources().getColor(R.color.white));
                etAddress.setTextColor(getResources().getColor(R.color.white));
                etBankNum.setTextColor(getResources().getColor(R.color.white));
                etBankName.setTextColor(getResources().getColor(R.color.white));
                etLoginpw.setTextColor(getResources().getColor(R.color.white));
                etPaypwd.setTextColor(getResources().getColor(R.color.white));
                etPaypwd2.setTextColor(getResources().getColor(R.color.white));

            }
        }


    }

    private void showIten() {
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(getActivity(), SPConstants.USERINFO, UserInfo.class);
        if (userInfo != null && userInfo.getData() != null) {
            fundpwd = userInfo.getData().isHasFundPwd();
            bankCard = userInfo.getData().isHasBankCard();
            String fullName = userInfo.getData().getFullName() == null ? "" : userInfo.getData().getFullName();
            if (TextUtils.isEmpty(fullName)) {
//                etBankName.setFocusableInTouchMode(true);
//                etBankName.setFocusable(true);
//                etBankName.requestFocus();
//                etBankName.setLongClickable(true);
//                etBankName.setTextIsSelectable(true);
            } else {
                etBankName.setFocusable(false);
                etBankName.setFocusableInTouchMode(false);
                etBankName.setLongClickable(false);
                etBankName.setTextIsSelectable(false);
                etBankName.setText(fullName);
            }
        }

        if (!fundpwd) {
            llPayPw.setVisibility(View.VISIBLE);
            llBank.setVisibility(View.GONE);
            rv.setVisibility(View.GONE);
            refreshLayout.finishRefresh();
        } else if (fundpwd) {
            if (bankCard) {
                getBankList(); //获取银行卡
            } else {
                llBank.setVisibility(View.VISIBLE);
                rv.setVisibility(View.GONE);
                llPayPw.setVisibility(View.GONE);
                refreshLayout.finishRefresh();
            }
        } else {
            checkToken(true);
        }
    }

    private void checkToken(boolean b) {
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
        if (!token.equals(SPConstants.SP_NULL)) {
            getUserInfo(token, b);
            refreshLayout.finishRefresh();
        } else {
            Uiutils.login(getContext());
//            startActivity(new Intent(getContext(), LoginActivity.class));
        }
    }

    private void getUserInfo(String s, boolean b) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(s) + "&sign=" + SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(getActivity(), true, this, true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                UserInfo li = (UserInfo) o;
                if (li != null && li.getCode() == 0) {
                    refreshLayout.finishRefresh();
                    ShareUtils.saveObject(getContext(), SPConstants.USERINFO, li);
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
                    edit.putString(SPConstants.SP_TASKREWARD, li.getData().getTaskReward());
                    edit.putString(SPConstants.SP_HASFUNDPWD, li.getData().isHasFundPwd() + "");
                    edit.putString(SPConstants.SP_ISTEST, li.getData().isIsTest() + "");
                    //头像
                    edit.putString(SPConstants.AVATAR, li.getData().getAvatar());
                    edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, li.getData().isYuebaoSwitch());
                    edit.commit();
                    EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                    if (b) {
                        showIten();
                    }
//                    if(li.getData()!=null&&!TextUtils.isEmpty(li.getData().getFullName()))
//                    etBankName.setText(li.getData().getFullName());
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
                refreshLayout.finishRefresh();
            }

            @Override
            public void onFailed(Response<String> response) {
                refreshLayout.finishRefresh();
            }
        });
    }

    private void bindBank() {
        String address = etAddress.getText().toString().trim();
        String bankNum = etBankNum.getText().toString().trim();
        String bankName = etBankName.getText().toString().trim();
        if (bankId == null || bankId.length() == 0 || bankId.equals("")) {
            ToastUtils.ToastUtils(getResources().getString(R.string.bank_select), getContext());
            return;
        }
        if (address == null || address.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.bank_input_address), getContext());
            return;
        }
        if (address.length() < 5) {
            ToastUtils.ToastUtils(getResources().getString(R.string.bank_address), getContext());
            return;
        }
        if (bankNum == null || bankNum.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.bank_input_card), getContext());
            return;
        }
        if (bankNum.length() < 16 || bankNum.length() > 20) {
            ToastUtils.ToastUtils(getResources().getString(R.string.bank_card_length), getContext());
            return;
        }
        if (bankName == null || bankName.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.bank_input_name), getContext());
            return;
        }
        if (bankName.length() < 2) {
            ToastUtils.ToastUtils(getResources().getString(R.string.bank_name_length), getContext());
            return;
        }
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.BANDBANKCARDLIST))
                .tag(this)
                .params("sign", SecretUtils.RsaToken())
                .params("bank_id", SecretUtils.DESede(bankId))
                .params("bank_addr", SecretUtils.DESede(address))
                .params("bank_card", SecretUtils.DESede(bankNum))
                .params("owner_name", SecretUtils.DESede(bankName))
                .params("token", SecretUtils.DESede(SPConstants.getValue(getActivity(), SPConstants.SP_API_SID)))
                .execute(new NetDialogCallBack(getContext(), true, getContext(), true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        UserInfo userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
                        if (userInfo != null && userInfo.getData() != null) {
                            userInfo.getData().setHasBankCard(true);
                            ShareUtils.saveObject(getActivity(), SPConstants.USERINFO, userInfo);
                        }
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.BINDCARD));
                        getBankList();
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }

    private void getBank() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.BANKLIST))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), true, getContext(),
                        true, BankInfo.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        bankInfo = (BankInfo) o;
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }

    private void getBankList() {
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
        String url = Constants.BaseUrl() + Constants.BANKCARDLIST + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(url))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), true, getContext(),
                        true, BankCardInfo.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        refreshLayout.finishRefresh();
                        rv.setVisibility(View.VISIBLE);
                        llBank.setVisibility(View.GONE);
                        llPayPw.setVisibility(View.GONE);
                        BankCardInfo bankcard = (BankCardInfo) o;
                        if (bankcard != null && bankcard.getCode() == 0 && bankcard.getData() != null) {
                            List<BankCardInfo.DataBean> list = new ArrayList<>();
                            list.add(bankcard.getData());
                            mAdapter.setData(list);
                            mAdapter.notifyDataSetChanged();
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        llBank.setVisibility(View.VISIBLE);
                        rv.setVisibility(View.GONE);
                        llPayPw.setVisibility(View.GONE);
                        refreshLayout.finishRefresh();
                    }

                    @Override
                    public void onFailed(Response<String> response) {
                        refreshLayout.finishRefresh();
                    }
                });

    }

    private void initBankRecycler() {
        mAdapter = new BankCardAdapter(getContext());
        rv.setAdapter(mAdapter);
        rv.setLayoutManager(new LinearLayoutManager(getContext()));
        mAdapter.setOnItemClickListener(new BankCardAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                String[] title = getResources().getStringArray(R.array.server);
                TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, title, getActivity().getResources().getString(R.string.server), getActivity().getResources().getString(R.string.server_info), "", new TDialog.onItemClickListener() {
                    @Override
                    public void onItemClick(Object object, int position) {
                        if (ButtonUtils.isFastDoubleClick())
                            return;
                        if (position == 1) {
                            String zxkfurl = SPConstants.getValue(getContext(), SPConstants.SP_ZXKFURL);
                            if (!TextUtils.isEmpty(zxkfurl)) {
//                                Intent intent = new Intent();
//                                intent.setAction("android.intent.action.VIEW");
//                                Uri content_url = Uri.parse(zxkfurl.startsWith("http")?zxkfurl:"http://"+zxkfurl);
//                                intent.setData(content_url);
//                                startActivity(intent);
                                SkipGameUtil.loadInnerWebviewUrl(zxkfurl, getContext(), "isHideTitle", "");
                            } else {
                                ToastUtils.ToastUtils("客服地址未配置或获取失败", getActivity());
                            }
                        }
                    }
                });
                ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
                if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
                    if (config.getData().getMobileTemplateCategory().equals("5")) {
                        mTDialog.setTitleTextBackgroupColor(R.drawable.blackbg_center);
                        mTDialog.setMsgTextColor(getResources().getColor(R.color.white));
                        mTDialog.setItemTextColor(getResources().getColor(R.color.white));
                        mTDialog.setTitleTextColor(getResources().getColor(R.color.white));
//                            tvText.setTextColor();
                    }
                }

                mTDialog.setCancelable(false);
                mTDialog.show();
            }
        });
    }

    private CustomPopWindow mCustomPopWindow;

    private void showPopMenu() {
        View contentView = LayoutInflater.from(getContext()).inflate(R.layout.pop_list, null);
        //处理popWindow 显示内容
        handleLogic(contentView);
        //创建并显示popWindow
        mCustomPopWindow = new CustomPopWindow.PopupWindowBuilder(getContext())
                .setView(contentView)
                .enableBackgroundDark(true) //弹出popWindow时，背景是否变暗
                .setBgDarkAlpha(0.7f) // 控制亮度
                .create()
                .showAsDropDown(etOpenBank, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private void handleLogic(View contentView) {
        RecyclerView recyclerView = (RecyclerView) contentView.findViewById(R.id.recyclerView);
        LinearLayoutManager manager = new LinearLayoutManager(getContext());
        manager.setOrientation(LinearLayoutManager.VERTICAL);
        recyclerView.setLayoutManager(manager);
        popadapter = new PopWindowAdapter(getContext());
        if (bankInfo != null && bankInfo.getData() != null)
            popadapter.setData(bankInfo.getData());
        recyclerView.setAdapter(popadapter);
        popadapter.setOnItemClickListener(new MyitemAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (mCustomPopWindow != null) {
                    mCustomPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                }
                if (bankInfo != null && bankInfo.getData() != null && bankInfo.getData().size() != 0) {
                    bankId = bankInfo.getData().get(position).getId();
                    etOpenBank.setText(bankInfo.getData().get(position).getName());
                }
            }
        });
    }

    @OnClick({R.id.et_open_bank, R.id.bt_sub, R.id.bt_subpw})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.et_open_bank:
                if (bankInfo != null && bankInfo.getCode() == 0) {
                    showPopMenu();
                } else {
                    ToastUtils.ToastUtils("加载银行列表失败", getContext());
                }
                break;
            case R.id.bt_sub:
                bindBank();//绑定银行卡
                break;
            case R.id.bt_subpw:
                payPw();
                break;
        }
    }

    private void payPw() {
        String loginpw = etLoginpw.getText().toString().trim();
        String paypwd = etPaypwd.getText().toString().trim();
        String pwd = etPaypwd2.getText().toString().trim();
        if (loginpw == null || loginpw.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwd1), getContext());
            return;
        } else if (loginpw.length() < 6) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwd3), getContext());
            return;
        }
        if (paypwd == null || paypwd.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpaypw), getContext());
            return;
        } else if (paypwd.length() < 4) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpaypw), getContext());
            return;
        }
        if (pwd == null || pwd.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpaypw2), getContext());
            return;
        } else if (pwd.length() < 4) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpaypw2), getContext());
            return;
        }
        if (!paypwd.equals(pwd)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwd6), getContext());
            return;
        }
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
        PayPwBean pw = new PayPwBean(SecretUtils.DESede(token), SecretUtils.DESedePassw(loginpw), SecretUtils.DESedePassw(paypwd), SecretUtils.RsaToken());
        Gson gson = new Gson();
        String json = gson.toJson(pw);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.FUNDPWD))//
                .tag(getActivity())//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getActivity(), true, getActivity(), true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        llBank.setVisibility(View.VISIBLE);
                        rv.setVisibility(View.GONE);
                        llPayPw.setVisibility(View.GONE);
//                        SPConstants.setValue(BankManageActivity.this,SPConstants.SP_User,SPConstants.SP_HASFUNDPWD,"true");
                        UserInfo userInfo = (UserInfo) ShareUtils.getObject(getActivity(), SPConstants.USERINFO, UserInfo.class);
                        if (userInfo != null && userInfo.getData() != null) {
                            userInfo.getData().setHasFundPwd(true);
                            ShareUtils.saveObject(getActivity(), SPConstants.USERINFO, userInfo);
                        }

                        checkToken(false);
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
    public void onDestroy() {
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                break;
        }
    }

    protected void onTransformResume() {
        showIten();
    }

}
