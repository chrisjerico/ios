package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.graphics.Color;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.LimitAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.TransferinterestBean;
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
 * Greated by Luke
 * on 2020/2/19
 */
public class LimitTransformNewFrament extends BaseFragments {
    private String transferLogs = "?c=real&a=transferLogs&token=%s&page=%s&rows=%s&startTime=%s&endTime=%s";
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    int page = 1;
    int rows = 20;
    @BindView(R2.id.tv_title_game)
    TextView tvTitleGame;
    @BindView(R2.id.tv_title_money)
    TextView tvTitleMoney;
    @BindView(R2.id.tv_title_data)
    TextView tvTitleData;
    @BindView(R2.id.tv_title_model)
    TextView tvTitleModel;
    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.rv)
    RecyclerView rv;

    private List<TransferinterestBean.DataBean.ListBean> list = new ArrayList<>();
    private LimitAdapter mAdapter;
    @SuppressLint("ValidFragment")
    public LimitTransformNewFrament() {
        super(R.layout.framnet_new_limit_transfrom, true, true);
    }

    @Override
    public void initView(View view) {
        getDeposit();
        mAdapter = new LimitAdapter(list, getContext());
        rv.setAdapter(mAdapter);
        if (rv.getItemDecorationCount() == 0) {
            rv.setLayoutManager(new LinearLayoutManager(getContext()));
            rv.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(200, 200, 200)));
        }
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
                page++;
                getDeposit();
            }
        });
    }

    private void getDeposit() {
        String startDate = Uiutils.getFetureDate(-1000);
        String endDate = Uiutils.getFetureDate(0);
        String token = SPConstants.checkLoginInfo(getContext());
        String url = Constants.BaseUrl() + Constants.TRANSFERINTEREST + String.format(transferLogs, SecretUtils.DESede(token), SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + ""), SecretUtils.DESede(startDate + " 00:00:00"), SecretUtils.DESede(endDate + " 23:59:59")) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(url)).tag(this).execute(new NetDialogCallBack(getContext(), true, getContext(), true, TransferinterestBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                refreshLayout.finishLoadMore(1000);      //加载完成
                TransferinterestBean db = (TransferinterestBean) o;
                if (db != null && db.getCode() == 0 && db.getData() != null && db.getData().getList() != null) {
                    if (page == 1)
                        list.clear();
                    list.addAll(db.getData().getList());
                    mAdapter.notifyDataSetChanged();
                    if (db.getData().getList() == null || db.getData().getList().size() == 0)
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
                refreshLayout.finishLoadMore(1000);      //加载完成
            }

            @Override
            public void onFailed(Response<String> response) {
                refreshLayout.finishLoadMore(1000);      //加载完成
            }
        });
    }
}
