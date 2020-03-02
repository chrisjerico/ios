package com.phoenix.lotterys.home.fragment;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.RelativeLayout;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.BlackMainActivity;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.PayOffLineActivity;
import com.phoenix.lotterys.my.activity.PayOnLineActivity;
import com.phoenix.lotterys.my.adapter.PayTypeAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.PayAisleBean;
import com.phoenix.lotterys.my.bean.PaymentBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by Luke
 * on 2019/6/28
 */
public class FundDepositFragment extends BaseFragments {
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.rv_pay_type)
    RecyclerView rvPay;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;

    PayTypeAdapter mAdapter;
    MainActivity mActivity;
    BlackMainActivity mBlackActivity;
    private PayAisleBean payAisle;

    public FundDepositFragment() {
        super(R.layout.fragment_deposit);
    }

    List<PaymentBean> payList = new ArrayList<PaymentBean>();

    @Override
    public void initView(View view) {
        if (getActivity() instanceof MainActivity) {
            mActivity = (MainActivity) getActivity();
        }else if(getActivity() instanceof BlackMainActivity){
            mBlackActivity = (BlackMainActivity) getActivity();
        }
        refreshLayout.setEnableLoadMore(false);
        if (refreshLayout != null) {
            refreshLayout.setOnRefreshListener(new OnRefreshListener() {
                @Override
                public void onRefresh(RefreshLayout refreshLayout) {
                    refreshLayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                    getDeposit();
                }
            });

        }
        mAdapter = new PayTypeAdapter(payList, getContext());
        rvPay.setAdapter(mAdapter);
        if (rvPay.getItemDecorationCount() == 0) {
            rvPay.setLayoutManager(new LinearLayoutManager(getContext()));
            rvPay.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(200, 200, 200)));
        }
        mAdapter.setListener(new PayTypeAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                PaymentBean pb = new PaymentBean();
                pb.setPrompt(payList.get(position).getPrompt());
                pb.setChannel(payList.get(position).getChannel());
                pb.setName(payList.get(position).getName());
                pb.setCode(payList.get(position).getCode());
                pb.setType(payList.get(position).getId());
                if(payAisle!=null&&payAisle.getData()!=null){
                    pb.setRecharge_alarm(payAisle.getData().getTransferPrompt()!=null?payAisle.getData().getTransferPrompt():"");//充值提示
                    pb.setBankPayPrompt(payAisle.getData().getDepositPrompt()!=null?payAisle.getData().getDepositPrompt():"");//银行提示
                }
                if(payAisle!=null&&payAisle.getData()!=null&&payAisle.getData().getQuickAmount()!=null)
                    pb.setQuickAmount(payAisle.getData().getQuickAmount());
                Bundle bundle = new Bundle();
                bundle.putSerializable("Channel", pb);
                Intent intent;
                boolean payIstype = payList.get(position).getId().contains("transfer");
                if(payList.get(position).getId().equals("alihb_online"))
                    payIstype=true;
                if (payIstype) {
                    intent = new Intent(getActivity(), PayOffLineActivity.class);
                } else {
                    intent = new Intent(getActivity(), PayOnLineActivity.class);
                }
                intent.putExtras(bundle);
                startActivityForResult(intent, 1005);
            }
        });
        getDeposit();
        setTheme();
    }

    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), rlMain);
            }
        }
    }

    private void getDeposit() {
        String token = SPConstants.checkLoginInfo(getContext());
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.PAYAISLE + SecretUtils.DESede(token)+"&sign="+SecretUtils.RsaToken())).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, FundDepositFragment.this, true, PayAisleBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                payAisle = (PayAisleBean) o;
                if (payAisle != null && payAisle.getCode() == 0 && payAisle.getData() != null && payAisle.getData().getPayment() != null) {
                    if (payList != null || payList.size() > 0)
                        payList.clear();
                    for (PaymentBean db : payAisle.getData().getPayment()) {
                        if (db.getChannel() != null && db.getChannel().size() != 0) {
//                            payList.addAll(payAisle.getData().getPayment());
                            payList.add(db);
                        }
                    }
                    if(mAdapter!=null)
                    mAdapter.notifyDataSetChanged();
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


    public static FundDepositFragment getInstance(String title) {
        FundDepositFragment sf = new FundDepositFragment();
        return sf;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == 1005 ) {
            try {
                if(data!=null&&data.getStringExtra("payState")!=null){
                    String payState = data.getStringExtra("payState");
                    if (!TextUtils.isEmpty(payState) && payState.equals("1"))
                    if (getActivity() instanceof MainActivity) {
                        mActivity.setTab(2);
                    }else if(getActivity() instanceof BlackMainActivity){
                        mBlackActivity .setTab(2);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}
