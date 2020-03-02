package com.phoenix.lotterys.buyhall.activity;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.LinearLayout;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.buyhall.adapter.TicketTypeAdapter;
import com.phoenix.lotterys.buyhall.bean.LotteryBuyBean;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;

import java.io.IOException;
import java.net.URLDecoder;

import butterknife.BindView;
import butterknife.OnClick;


public class SelectLotteryTicketActivity extends BaseActivitys {

    @BindView(R2.id.rv_tick_class)
    RecyclerView rvTickClass;
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.finish)
    View finish;

    TicketTypeAdapter ticketTypeAdapter;

    public SelectLotteryTicketActivity() {
        super(R.layout.activity_select_lottery_ticket);
    }

    @Override
    public void initImmersionBar() {
        super.initImmersionBar();
        if (null!=mImmersionBar)
        mImmersionBar.transparentStatusBar().init();
    }

    @Override
    public void initView() {
        getLotteryBuy();
        setTheme();
        Uiutils.setBarStye0(finish,this);

    }

    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(SelectLotteryTicketActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(SelectLotteryTicketActivity.this,llMain ,false,null);
                Uiutils.setBaColor(SelectLotteryTicketActivity.this, rvTickClass);
            }
        }
    }

    private void getLotteryBuy() {

        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.LOTTERYBUY)) .tag(this).execute(new NetDialogCallBack(this, true, SelectLotteryTicketActivity.this,
                true,LotteryBuyBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                    LotteryBuyBean lotteryBuyBean = (LotteryBuyBean)o;
                    if (lotteryBuyBean != null && lotteryBuyBean.getCode() == 0) {
                        ticketTypeAdapter = new TicketTypeAdapter(lotteryBuyBean.getData(), SelectLotteryTicketActivity.this);

                        ticketTypeAdapter.setSelect(1);
                        rvTickClass.setAdapter(ticketTypeAdapter);
                        rvTickClass.setLayoutManager(new LinearLayoutManager(SelectLotteryTicketActivity.this));
                        ticketTypeAdapter.setListener(new TicketTypeAdapter.OnClickListener() {
                            @Override
                            public void onClickListener(View view, int position,int pos) {
//                                ToastUtils.ToastUtils("xxxxxxx",SelectLotteryTicketActivity.this);
//                                EventBus.getDefault().post(new MessageEvent("gameodds", lotteryBuyBean.getData().get(position).getGameType(), lotteryBuyBean.getData().get(position).getList().get(pos).getId()));
//                                finish();
                            }
                        });
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
    @OnClick({R.id.finish, R.id.tv_finish})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.finish:
                finish();
                break;
            case R.id.tv_finish:
                finish();
                break;
        }
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(R.anim.activity_bottom_out, 0);
    }

    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelTag(this);
        super.onDestroy();
    }
}
