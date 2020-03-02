package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.coupons.activity.RichTextActivity;
import com.phoenix.lotterys.coupons.bean.CouponsBean;
import com.phoenix.lotterys.home.adapter.BlackLastReadAdapter;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by Luke
 * on 2019/6/23
 */
@SuppressLint("ValidFragment")
public class BlackLastReadFragment extends BaseFragments {
    @BindView(R2.id.rv_coup)
    RecyclerView rvCoup;
    BlackLastReadAdapter mAdapter;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;

    String template = "";
    public BlackLastReadFragment() {
        super(R.layout.fragment_coupons, true, true);

    }

    public static BlackLastReadFragment getInstance() {
        return new BlackLastReadFragment();
    }

    @Override
    public void initView(View view) {

        initdata();
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                initdata();
            }
        });

        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {

                template= "5";
            }
        }
    }

    private void initdata() {

        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.COUPONS))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), true, BlackLastReadFragment.this,
                        true, CouponsBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        refreshLayout.finishRefresh();
                        CouponsBean coupons = (CouponsBean) o;
                        List<CouponsBean.DataBean.ListBean> list = new ArrayList<>();
                        if (coupons != null && coupons.getCode() == 0) {
                            for (CouponsBean.DataBean.ListBean db : coupons.getData().getList()) {
                                list.add(db);
                            }
                            mAdapter = new BlackLastReadAdapter(list, getContext(),template);
                            LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                            layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
                            rvCoup.setLayoutManager(layoutManager);
                            rvCoup.setAdapter(mAdapter);
                            mAdapter.setListener(new BlackLastReadAdapter.OnClickListener() {
                                @Override
                                public void onClickListener(View view, int position) {
                                    if (TextUtils.isEmpty(list.get(position).getContent()))
                                        return;
                                    Intent intent = null;
                                    if (NumUtil.isContain(list.get(position).getContent(), "img src=")) {
                                        intent = new Intent(getContext(), GoWebActivity.class);
                                    } else {
                                        intent = new Intent(getContext(), RichTextActivity.class);
                                    }
                                    intent.putExtra("url", list.get(position).getContent());
                                    Log.e("url", list.get(position).getContent() + "");
                                    startActivityForResult(intent, 1);

                                }
                            });
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

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
//                Uiutils.setBaColor(getContext(), titlebar, false, null);
                break;
        }
    }
}
