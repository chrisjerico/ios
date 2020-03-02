package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
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
import com.phoenix.lotterys.home.adapter.TransMoneyAdapter;
import com.phoenix.lotterys.home.adapter.TransNewAdapter;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.my.adapter.MyitemAdapter;
import com.phoenix.lotterys.my.adapter.TransferAdapter;
import com.phoenix.lotterys.my.bean.BalanceBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.ToTransferBean;
import com.phoenix.lotterys.my.bean.TransformBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.bean.WalletBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.greenrobot.eventbus.Subscribe;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

import static com.phoenix.lotterys.util.ShowItem.subZeroAndDot;

/**
 * Greated by Luke
 * on 2020/2/15
 */
@SuppressLint("ValidFragment")
public class TransFerListFrament extends BaseFragment {
    List<WalletBean.DataBean> walletdata;
    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;
    @BindView(R2.id.rv_money)
    RecyclerView rvMoney;
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.et_money)
    EditText etMoney;
    @BindView(R2.id.tv_out)
    TextView tvOut;
    @BindView(R2.id.tv_in)
    TextView tvIn;
    @BindView(R2.id.bt_trans)
    Button btTrans;
    @BindView(R2.id.bt_onekey)
    Button btOnekey;
    private TransNewAdapter transAdapter;
    private String balance = "?c=real&a=checkBalance&id=%s&token=%s";   //真人游戏余额
    int in = -1, out = -1;
    TransferNewFrament mContent;
    public TransFerListFrament(TransferNewFrament mContext, List<WalletBean.DataBean> walletdata) {
        super(R.layout.fragment_trans, true, true);
        this.walletdata = walletdata;
        this.mContent = mContext;
    }
//    public static TransFerListFrament getInstance(List<WalletBean.DataBean> walletdata) {
//        TransFerListFrament sf = new TransFerListFrament(walletdata);
//        return sf;
//    }

    @Override
    public void initView(View view) {
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        GradientDrawable drawable = (GradientDrawable) getResources().getDrawable(R.drawable.lottery_bck_13);
        int BankColor = Color.parseColor("#33A1FF");
        drawable.setColor(BankColor);
        btTrans.setBackgroundDrawable(drawable);
        GradientDrawable drawable1 = (GradientDrawable) getResources().getDrawable(R.drawable.lottery_bck_13);
        int BankColor1 = Color.parseColor("#57D56C");
        drawable1.setColor(BankColor1);
        btOnekey.setBackgroundDrawable(drawable1);

        transAdapter = new TransNewAdapter(walletdata, getContext());
        rvTicket.setAdapter(transAdapter);
        if (rvTicket.getItemDecorationCount() == 0) {
            Uiutils.setRec(getContext(), rvTicket, 3, R.color.my_line1);
        }
        transAdapter.setListener(new TransNewAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position, WalletBean.DataBean dataBean) {
                if (position == 0)
                    getUserInfo();
                else
                    getBalance(dataBean.getId(), position);
            }
        });
        List<String> list = new ArrayList<>();
        list.add("全部");
        list.add("100");
        list.add("500");
        list.add("1000");
        list.add("5000");
        list.add("10000");
        TransMoneyAdapter transMoney = new TransMoneyAdapter(list, getContext());
        rvMoney.setAdapter(transMoney);
        if (rvMoney.getItemDecorationCount() == 0) {
            Uiutils.setRec(getContext(), rvMoney, 3, R.color.my_line1);
        }
        transMoney.setListener(new TransMoneyAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position, String s) {
                if (position == 0) {
                    if (userInfo != null && userInfo.getData() != null && userInfo.getData().getBalance() != null)
                        etMoney.setText(subZeroAndDot(userInfo.getData().getBalance()));
                } else {
                    etMoney.setText(subZeroAndDot(s));
                }
                etMoney.setSelection(etMoney.getText().toString().trim().length());
            }
        });

    }

    @OnClick({R.id.tv_out, R.id.tv_in, R.id.bt_trans, R.id.bt_onekey})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_out:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                showPopMenu(true, tvOut);
                break;
            case R.id.tv_in:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                showPopMenu(false, tvIn);
                break;
            case R.id.bt_trans:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (SPConstants.isTourist(getActivity())) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.transfer_user), getActivity());
                    return;
                }
                String money = etMoney.getText().toString().trim();
                String textOut = tvOut.getText().toString().trim();
                String textIn = tvIn.getText().toString().trim();
                if (textOut.equals("请选择钱包 ▼")) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.select_out), getActivity());
                    return;
                }
                if (textIn.equals("请选择钱包 ▼")) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.select_in), getActivity());
                    return;
                }
                if (TextUtils.isEmpty(money)) {
                    ToastUtils.ToastUtils(getResources().getString(R.string.input_money), getActivity());
                    return;
                }
                questManualTransfer(money);
                break;
            case R.id.bt_onekey:
                getAutotransferout();
                break;
        }
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
                    walletdata.get(pos).setBalance(balance.getData().getBalance());
                    transAdapter.notifyItemChanged(pos);
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
    private void getUserInfo() {
        if(getActivity()==null)
            return;
        String token = SPConstants.checkLoginInfo(getActivity());
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken())).tag(getActivity()).execute(new NetDialogCallBack(getActivity(), true, getActivity(), true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                UserInfo li = (UserInfo) o;
                if (li != null && li.getCode() == 0) {
                    ShareUtils.saveObject(getActivity(), SPConstants.USERINFO, li);
                    walletdata.get(0).setBalance(li.getData().getBalance());
                    if (transAdapter != null)
                        transAdapter.notifyItemChanged(0);
                    if(mContent!=null)
                        mContent.upData(true);
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
    public void onResume() {
        super.onResume();
        updata();
    }

    private void updata() {
        getUserInfo();
        for (WalletBean.DataBean d : walletdata) {
            d.setBalance("");
        }
        if (transAdapter != null)
            transAdapter.notifyDataSetChanged();
    }

    //一键转出获取转出的游戏
    private void getAutotransferout() {
        String token = SPConstants.checkLoginInfo(getActivity());
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.AUTOTRANSFEROUT + (Constants.ENCRYPT ? Constants.SIGN : "")))
                .params("token", SecretUtils.DESede(token))
                .params("sign", SecretUtils.RsaToken())//
                .execute(new NetDialogCallBack(getContext(), true, getContext(), true, ToTransferBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        ToTransferBean base = (ToTransferBean) o;
                        if (base != null && base.getCode() == 0) {
                            ToastUtil.toastShortShow(getContext(), "转出成功");
                            updata();
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

    private CustomPopWindow mCustomPopWindow;
    private void showPopMenu(Boolean active, TextView et) {
        View contentView = LayoutInflater.from(getActivity()).inflate(R.layout.pop_list, null);
        //处理popWindow 显示内容
        handleLogic(contentView, active);
        //创建并显示popWindow
        mCustomPopWindow = new CustomPopWindow.PopupWindowBuilder(getActivity())
                .setView(contentView)
                .enableBackgroundDark(true) //弹出popWindow时，背景是否变暗
                .setBgDarkAlpha(0.7f) // 控制亮度
                .create()
                .showAtLocation(et, Gravity.CENTER, 0, 0)
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
        adapter.setData(walletdata);
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
                    tvOut.setText(walletdata.get(position).getTitle());
                } else {
                    if (position == out) {
                        ToastUtils.ToastUtils(getResources().getString(R.string.out_in), getActivity());
                        return;
                    }
                    in = position;
                    tvIn.setText(walletdata.get(position).getTitle());
                }
                if(position>0)
                    getBalance(walletdata.get(position).getId(), position);
            }
        });
    }


    private void questManualTransfer(String money) {
        if(out==-1||in==-1)
            return;
        String token = SPConstants.checkLoginInfo(getActivity());
        String fromId = walletdata.get(out).getId();
        String toId = walletdata.get(in).getId();
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
                                getBalance(fromId, out );
                            else
                                getUserInfo();
                            if (in != 0)
                                getBalance(toId, in );
                            else
                                getUserInfo();
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

    @Subscribe(sticky = true)
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("userinfo")) {
            if(walletdata!=null&&walletdata.size()!=0){
                UserInfo userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
                for (WalletBean.DataBean d : walletdata) {
                    d.setBalance("");
                }
                walletdata.get(0).setBalance(userInfo.getData().getBalance() == null ? "" : userInfo.getData().getBalance());
                if (transAdapter != null)
                    transAdapter.notifyDataSetChanged();
                if(mContent!=null)
                    mContent.upData(false);
            }
        }
    }
}
