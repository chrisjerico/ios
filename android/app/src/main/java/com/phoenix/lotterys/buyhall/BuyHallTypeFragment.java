package com.phoenix.lotterys.buyhall;


import android.content.Intent;
import android.os.Handler;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.activity.GameGallTypeActivity;
import com.phoenix.lotterys.buyhall.activity.LotteryHallTypeActivity;
import com.phoenix.lotterys.buyhall.adapter.BuyHallTypeAdapter;
import com.phoenix.lotterys.main.bean.GameType;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.List;

import butterknife.BindView;

/**
 * 购买大厅
 */
public class BuyHallTypeFragment extends BaseFragments {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.rv_ticket_type)
    RecyclerView rvTicketType;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    List<GameType.DataBean> mList;
    private BuyHallTypeAdapter buytypeadapter;

    public static BuyHallTypeFragment getInstance() {
        return new BuyHallTypeFragment();
    }

    public BuyHallTypeFragment() {
        super(R.layout.fragment_buy_hall, true, true);
    }

    private String title;
    @Override
    public void initView(View view) {
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                initData();
            }
        });

        initData();

        if (getArguments() == null) {
            titlebar.setVisibility(View.GONE);
        } else {
            Uiutils.setBaColor(getContext(), titlebar, false, null);
            Uiutils.setBarStye0(titlebar,getContext());
            title =getArguments().getString("title");
            if (!StringUtils.isEmpty(title)){
                titlebar.setText(title);
            }
        }

    }

    private void initData() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GAMETYPE))//
                .tag(getActivity())//
                .execute(new NetDialogCallBack(getContext(), true, getActivity(),
                        true, GameType.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameType gameType = (GameType) o;
                        if (gameType != null && gameType.getCode() == 0) {

                            if (mList != null && gameType.getData() != null) {
                                mList.clear();
                                mList.addAll(gameType.getData());
                                if (buytypeadapter != null) {
                                    buytypeadapter.notifyDataSetChanged();
                                }
                            } else if (gameType.getData() != null) {
                                mList = gameType.getData();
                                buytypeadapter = new BuyHallTypeAdapter(mList, getActivity());
                                rvTicketType.setAdapter(buytypeadapter);
                                rvTicketType.setLayoutManager(new GridLayoutManager(getContext(), 2));
                            }
                            buytypeadapter.setOnItemClickListener(new BuyHallTypeAdapter.OnItemClickListener() {
                                @Override
                                public void onItemClick(View view, int position) {
                                    if (ButtonUtils.isFastDoubleClick())
                                        return;
                                    switch (mList.get(position).getCategory()) {
                                        case "lottery":
                                            startActivity(new Intent(getActivity(), LotteryHallTypeActivity.class));
                                            break;
                                        default:
                                            Intent intent = new Intent(getContext(), GameGallTypeActivity.class);
                                            intent.putExtra("dataList", mList.get(position));
                                            startActivity(intent);
                                            break;
                                    }
                                }
                            });
                        } else if (gameType != null && gameType.getCode() == 1) {

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


    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {

        }
    };

    @Override
    public void onDestroy() {
        super.onDestroy();
        handler.removeCallbacks(runnable);

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

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                Uiutils.setBarStye0(titlebar,getContext());
                break;
        }
    }
}
