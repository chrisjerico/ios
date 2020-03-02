package com.phoenix.lotterys.coupons;

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
import com.phoenix.lotterys.coupons.adapter.CouponsAdapter;
import com.phoenix.lotterys.coupons.bean.CouponsBean;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.webview.CouponWebActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.tddialog.TDialog;
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
public class CouponsFragment extends BaseFragments {
    @BindView(R2.id.view1)
    View view1;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.rv_coup)
    RecyclerView rvCoup;
    CouponsAdapter mAdapter;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    boolean isHide = false;
    boolean isHidetitle = false;  //隐藏标题
    String template = "";
    public CouponsFragment(boolean isHide, boolean isHidetitle) {
        super(R.layout.fragment_coupons, true, true);
        this.isHide = isHide;
        this.isHidetitle = isHidetitle;
    }

    public static CouponsFragment getInstance(boolean isHide, boolean isHidetitle) {
        return new CouponsFragment(isHide,isHidetitle);
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
        Uiutils.setBarStye(titlebar, getActivity());
        if (isHide)
            titlebar.setIvBackHide(View.GONE);
        if (isHidetitle)
            titlebar.setVisibility(View.GONE);
        Uiutils.setBaColor(getContext(), titlebar, false, null);


        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                titlebar.setText("优惠专区");
                if (isHidetitle)
                view1.setVisibility(View.GONE);
                else
                view1.setVisibility(View.VISIBLE);
                template= "5";
            }
        }

        if (Uiutils.isSite("190"))
        Uiutils.setBa(getContext(), rvCoup);
    }

    private void initdata() {
//        Log.e("xxxxBaseUrl",""+Constants.BaseUrl()+Constants.COUPONS);
        String type = getArguments() != null ? "&category="+getArguments().getString("type") : "";
        String deUrl = URLDecoder.decode(Constants.BaseUrl() + Constants.COUPONS + type);
        OkGo.<String>get(deUrl)
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), true, CouponsFragment.this,
                        true, CouponsBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        refreshLayout.finishRefresh();
                        CouponsBean coupons = (CouponsBean) o;
                        if (coupons != null && coupons.getCode() == 0) {
                            List<CouponsBean.DataBean.ListBean> list = new ArrayList<>(coupons.getData().getList());
//                            for (CouponsBean.DataBean.ListBean db : coupons.getData().getList()) {
//                                list.add(db);
//                            }
                            mAdapter = new CouponsAdapter(list, getContext(),template,true,true);
                            LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                            layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
                            rvCoup.setLayoutManager(layoutManager);
                            rvCoup.setAdapter(mAdapter);
                            mAdapter.setListener((view, position) -> {
                                CouponsBean.DataBean.ListBean bean = list.get(position);
                                if (TextUtils.isEmpty(bean.getContent()))
                                    return;


                                if (CouponsBean.CouponStyle.popup.name().equals(coupons.getData().getStyle())) { //弹出窗口
                                    String[] array = {getResources().getString(R.string.affirm)};
                                    TDialog mTDialog = new TDialog(1,
                                            getActivity(),
                                            TDialog.Style.Center,
                                            array,
                                            getResources().getString(R.string.coupons),
                                            "",
                                            bean.getContent(),
                                            (object, position1) -> {

                                            });
                                    mTDialog.setCancelable(false);
                                    mTDialog.show();

                                } else if (CouponsBean.CouponStyle.page.name().equals(coupons.getData().getStyle())) { //跳转界面
                                    Intent intent = null;
//                                    if (NumUtil.isContain(list.get(position).getContent(), "img src=")) {
                                    intent = new Intent(getContext(), CouponWebActivity.class);
//                                    } else {
//                                        intent = new Intent(getContext(), RichTextActivity.class);
//                                    }
                                    String data = bean.getContent().replaceAll("nowrap", "nowrap1");
                                    intent.putExtra("url", data);
                                    intent.putExtra(CouponsBean.DataBean.ListBean.TAG, bean);
                                    Log.e("url", bean.getContent() + "");
                                    startActivityForResult(intent, 1);

                                } else if (CouponsBean.CouponStyle.slide.name().equals(coupons.getData().getStyle())) { //内嵌处理
                                    bean.setSlide(!bean.isSlide());
                                    mAdapter.notifyItemChanged(position);

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
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                break;
        }
    }
}
