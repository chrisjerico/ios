package com.phoenix.lotterys.buyhall.activity;

import android.os.Handler;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.View;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.buyhall.adapter.TicketTypeAdapter;
import com.phoenix.lotterys.buyhall.bean.LotteryBuyBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.List;

import butterknife.BindView;

import static com.phoenix.lotterys.util.StampToDate.dateToStamp;

/**
 * Greated by Luke
 * on 2019/9/25
 */
public class LotteryHallTypeActivity extends BaseActivitys {
    @BindView(R2.id.rv_ticket_type)
    RecyclerView rvTicketType;
    TicketTypeAdapter ticketTypeAdapter;
    List<LotteryBuyBean.DataBean> mList;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    public void getIntentData() {

    }
    public LotteryHallTypeActivity() {
        super(R.layout.activity_buy_hall);
    }

    @Override
    public void initView() {
        getLotteryBuy(true);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(500/*,false*/);//传入false表示刷新失败
                getLotteryBuy(true);
            }
        });

//        handler.postDelayed(runnable, 10000);
        Uiutils.setBarStye0(titlebar,this);
    }
    private void getLotteryBuy(boolean b) {
        handler.removeCallbacks(runnable);
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.LOTTERYBUY))//
                .tag(this)//
                .execute(new NetDialogCallBack(LotteryHallTypeActivity.this, b, LotteryHallTypeActivity.this,
                        true,LotteryBuyBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        handler.postDelayed(runnable, 20000);
                        long serverTime=0;
//                        refreshLayout.finishRefresh();//结束刷新
                        LotteryBuyBean lotteryBuyBean = (LotteryBuyBean)o;
                        if (lotteryBuyBean != null && lotteryBuyBean.getCode() == 0) {

                            try {
                                if(lotteryBuyBean.getData()!=null&&lotteryBuyBean.getData().get(0).getList().get(0).getServerTimestamp()!=null){
                                    serverTime = System.currentTimeMillis() - Long.parseLong(lotteryBuyBean.getData().get(0).getList().get(0).getServerTimestamp());
                                }
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
                            }

                            if (mList != null&&lotteryBuyBean.getData()!=null) {
                                mList.clear();
                                mList.addAll(lotteryBuyBean.getData());
                                ticketTypeAdapter.setServer(serverTime);
                                if (ticketTypeAdapter != null) {
                                    ticketTypeAdapter.notifyDataSetChanged();
                                }
                            } else if(lotteryBuyBean.getData()!=null){
                                mList = lotteryBuyBean.getData();
                                ticketTypeAdapter = new TicketTypeAdapter(mList, LotteryHallTypeActivity.this);
                                ticketTypeAdapter.setServer(serverTime);
                                rvTicketType.setAdapter(ticketTypeAdapter);
                                rvTicketType.setLayoutManager(new LinearLayoutManager(LotteryHallTypeActivity.this));
                            }
                            ticketTypeAdapter.setListener(new TicketTypeAdapter.OnClickListener() {
                                @Override
                                public void onClickListener(View view, int position, int pos) {
                                    getLotteryBuy(false);
                                }
                            });
//                            if (!b) {
//                                handler.postDelayed(runnable, 10000);
//                            }
                        } else if (lotteryBuyBean != null && lotteryBuyBean.getCode() == 1) {
                            ToastUtils.ToastUtils("数据加载失败", LotteryHallTypeActivity.this);

                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
//                        refreshLayout.finishRefresh();//结束刷新
                        handler.postDelayed(runnable, 20000);
                    }

                    @Override
                    public void onFailed(Response<String> response) {
//                        refreshLayout.finishRefresh();//结束刷新
                        handler.postDelayed(runnable, 20000);
                    }

                });
    }
    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            getLotteryBuy(false);
        }
    };

    @Override
    public void onDestroy() {
        handler.removeCallbacks(runnable);
        if(ticketTypeAdapter!=null){
            ticketTypeAdapter.notifyDataAt();
        }
        super.onDestroy();
        Log.e("xxxxxonDestroy","Pause");

    }

    @Override
    public void onPause() {
        super.onPause();
        Log.e("xxxxxonPause","Pause");
        if(handler!=null)
        handler.removeCallbacks(runnable);
    }
    @Override
    public void onRestart() {
        super.onRestart();
        Log.e("xxxxxonRestart","onRestart");
        if(handler!=null)
            handler.postDelayed(runnable, 100);
    }
}
