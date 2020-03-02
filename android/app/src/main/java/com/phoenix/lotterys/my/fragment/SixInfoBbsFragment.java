package com.phoenix.lotterys.my.fragment;

import android.graphics.Color;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.FundsAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.FundsBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
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
public class SixInfoBbsFragment extends BaseFragments {
    @BindView(R2.id.rv_funds)
    RecyclerView rvFunds;
    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;

    int page = 1;
    int rows = 20;
    String url;
    String startDate = Uiutils.getFetureDate(-1000);
    String endDate = Uiutils.getFetureDate(0);
    private List<FundsBean.DataBean.ListBean> list = new ArrayList<>();

    private  String FUNDS = "?c=user&a=fundLogs&group=1&startDate=%s&endDate=%s&page=%s&rows=%s&token=%s";
    private FundsAdapter mAdapter;

    public SixInfoBbsFragment() {
        super(R.layout.fragment_funds);
    }


    @Override
    public void initView(View view) {
        if (refreshLayout != null) {
            refreshLayout.setOnRefreshListener(new OnRefreshListener() {
                @Override
                public void onRefresh(RefreshLayout refreshLayout) {
                    refreshLayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                    page = 1;
                    getDeposit();
                }
            });
            refreshLayout.setOnLoadMoreListener(new OnLoadMoreListener() {
                @Override
                public void onLoadMore(RefreshLayout refreshLayout) {
                    refreshLayout.finishLoadMore();      //加载完成
                    page++;
                    getDeposit();
                }
            });
        }
        mAdapter = new FundsAdapter(list, getContext());
        rvFunds.setAdapter(mAdapter);
        if (rvFunds.getItemDecorationCount() == 0) {
            rvFunds.setLayoutManager(new LinearLayoutManager(getContext()));
            rvFunds.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(200, 200, 200)));
        }
        getDeposit();

    }

    public static SixInfoBbsFragment getInstance(String title) {
        SixInfoBbsFragment sf = new SixInfoBbsFragment();
        return sf;
    }

    private void getDeposit() {

        String token = SPConstants.checkLoginInfo(getContext());
        url = Constants.BaseUrl()+Constants.FUNDRECORD + String.format(FUNDS, SecretUtils.DESede(startDate), SecretUtils.DESede(endDate), SecretUtils.DESede(page+""), SecretUtils.DESede(rows+""), SecretUtils.DESede(token))+"&sign="+SecretUtils.RsaToken();
        if (TextUtils.isEmpty(url))
            return;
        OkGo.<String>get(URLDecoder.decode(url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SixInfoBbsFragment.this, true, FundsBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                FundsBean fundsBean = (FundsBean) o;
                if (fundsBean != null && fundsBean.getCode() == 0 && fundsBean.getData() != null && fundsBean.getData().getList() != null) {
                    if (page == 1)
                        list.clear();
                    list.addAll(fundsBean.getData().getList());
                    mAdapter.notifyDataSetChanged();
                    if (fundsBean.getData().getList() == null||fundsBean.getData().getList().size()==0)
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法
                    if (list == null || list.size() == 0) {
                        tvData.setVisibility(View.VISIBLE);
                    } else {
                        tvData.setVisibility(View.GONE);
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

    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }
}
