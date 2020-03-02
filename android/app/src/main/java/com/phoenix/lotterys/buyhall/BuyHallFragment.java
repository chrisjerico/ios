package com.phoenix.lotterys.buyhall;


import android.os.Handler;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.View;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.adapter.TicketTypeAdapter;
import com.phoenix.lotterys.buyhall.bean.LotteryBuyBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.ToastUtils;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;

import java.io.IOException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.util.List;

import butterknife.BindView;

import static com.phoenix.lotterys.util.StampToDate.dateToStamp;

/**
 * 购买大厅
 */
public class BuyHallFragment extends BaseFragments {


    @BindView(R2.id.rv_ticket_type)
    RecyclerView rvTicketType;
    TicketTypeAdapter ticketTypeAdapter;
    List<LotteryBuyBean.DataBean> mList;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;

    public static BuyHallFragment getInstance() {
        return new BuyHallFragment();
    }

    public BuyHallFragment() {
        super(R.layout.fragment_buy_hall);
    }

    @Override
    public void initView(View view) {
        getLotteryBuy(true);
//        Constants.setmHidden(false);
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                getLotteryBuy(true);
            }
        });
//        refreshLayout.setOnLoadMoreListener(new OnLoadMoreListener() {
//            @Override
//            public void onLoadMore(RefreshLayout refreshlayout) {
//                refreshlayout.finishLoadMore(2000/*,false*/);//传入false表示加载失败
//            }
//        });
    }

    private void getLotteryBuy(boolean b) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.LOTTERYBUY))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), b, BuyHallFragment.this,
                        true,LotteryBuyBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        long serverTime=0;
//                        refreshLayout.finishRefresh();//结束刷新
                        LotteryBuyBean lotteryBuyBean = (LotteryBuyBean)o;
                        if (lotteryBuyBean != null && lotteryBuyBean.getCode() == 0) {
                            try {
                                if(lotteryBuyBean.getData().get(0).getList().get(0).getServerTime()!=null){
                                    serverTime = System.currentTimeMillis() - dateToStamp(lotteryBuyBean.getData().get(0).getList().get(0).getServerTime());
                                }
                                Log.e("serverTime1",""+serverTime);
                            } catch (ParseException e) {
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
                                ticketTypeAdapter = new TicketTypeAdapter(mList, getActivity());
                                ticketTypeAdapter.setServer(serverTime);
                                rvTicketType.setAdapter(ticketTypeAdapter);
                                rvTicketType.setLayoutManager(new LinearLayoutManager(getActivity()));
                            }
                            ticketTypeAdapter.setListener(new TicketTypeAdapter.OnClickListener() {
                                @Override
                                public void onClickListener(View view, int position,int pos) {
                                    getLotteryBuy(false);
                                }
                            });
                            if (!b) {
                                handler.postDelayed(runnable, 10000);
                            }
                        } else if (lotteryBuyBean != null && lotteryBuyBean.getCode() == 1) {
                            ToastUtils.ToastUtils("数据加载失败", getContext());

                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
//                        refreshLayout.finishRefresh();//结束刷新
                    }

                    @Override
                    public void onFailed(Response<String> response) {
//                        refreshLayout.finishRefresh();//结束刷新
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
        super.onDestroy();
        handler.removeCallbacks(runnable);
        if(ticketTypeAdapter!=null){
            ticketTypeAdapter.notifyDataAt();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        handler.removeCallbacks(runnable);
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onResume() {
        super.onResume();
//        if (Constants.ismHidden()) {
//            handler.postDelayed(runnable, 10000);
//        }
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
//        Constants.setmHidden(hidden);
        if (hidden) {
            handler.removeCallbacks(runnable);
        } else {
            handler.postDelayed(runnable, 10000);
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }
}
