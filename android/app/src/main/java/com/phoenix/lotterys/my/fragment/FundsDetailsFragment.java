package com.phoenix.lotterys.my.fragment;

import android.graphics.Color;
import android.graphics.drawable.Drawable;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.CityPopAdapter1;
import com.phoenix.lotterys.my.adapter.FundsAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.FundsBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
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
import butterknife.OnClick;

/**
 * Created by Luke
 * on 2019/6/28
 */
public class FundsDetailsFragment extends BaseFragments implements BaseRecyclerAdapter.OnItemClickListener {
    @BindView(R2.id.rv_funds)
    RecyclerView rvFunds;
    @BindView(R2.id.tv_titleblance)
    TextView tvTitleblance;
    @BindView(R2.id.tv_titletype)
    TextView tvTitletype;
    @BindView(R2.id.tv_titlemoney)
    TextView tvTitlemoney;
    @BindView(R2.id.tv_titledata)
    TextView tvTitledata;

    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.card)
    CardView card;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    int page = 1;
    int rows = 20;
    String url;
    @BindView(R2.id.main_rel)
    RelativeLayout mainRel;
    private String group = "0";
    String startDate = Uiutils.getFetureDate(-1000);
    String endDate = Uiutils.getFetureDate(0);
    private List<FundsBean.DataBean.ListBean> list = new ArrayList<>();

    private String FUNDS = "?c=user&a=fundLogs&group=%s&startDate=%s&endDate=%s&page=%s&rows=%s&token=%s";
    private FundsAdapter mAdapter;

    public FundsDetailsFragment() {
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
        setTheme();

        showPopMenu();

        if (Uiutils.setBaColor(getContext(),null)){
            Drawable drawable =getContext().getResources().getDrawable(R.drawable.white_down);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            tvTitletype.setCompoundDrawables(null, null, drawable, null);
        }

    }

    private CustomPopWindow mCustomPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;

    private void showPopMenu() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.city_pop, null);
        if (Uiutils.setBaColor(getContext(),null)){
            contentView.findViewById(R.id.main_lin).setBackgroundColor(getContext().getResources().getColor(R.color.black1));
        }

        setPopView();
        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT,
                true, false, 1f);
    }

    private RecyclerView popRec;
    private CityPopAdapter1 adapterCity;
    private List<FundsBean.DataBean.GroupsBean> listPop = new ArrayList<>();

    private void setPopView() {
        if (null == contentView)
            return;

        popRec = contentView.findViewById(R.id.pop_rec);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        popRec.setLayoutManager(linearLayoutManager);
        popRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));

        adapterCity = new CityPopAdapter1(getContext(), listPop, R.layout.city_pop_adapter);
        popRec.setAdapter(adapterCity);
        adapterCity.setOnItemClickListener(this);
    }


    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), card, false, null);
                Uiutils.setBaColor(getContext(), rlMain);
                tvTitleblance.setTextColor(getResources().getColor(R.color.font));
                tvTitlemoney.setTextColor(getResources().getColor(R.color.font));
                tvTitletype.setTextColor(getResources().getColor(R.color.font));
                tvTitledata.setTextColor(getResources().getColor(R.color.font));
                tvData.setTextColor(getResources().getColor(R.color.font));
            }
        }
    }


    public static FundsDetailsFragment getInstance(String title) {
        FundsDetailsFragment sf = new FundsDetailsFragment();
        return sf;
    }

    private void getDeposit() {

        String token = SPConstants.checkLoginInfo(getContext());
        url = Constants.BaseUrl() + Constants.FUNDRECORD + String.format(FUNDS, SecretUtils.DESede(group), SecretUtils.DESede(startDate), SecretUtils.DESede(endDate), SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + ""), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken();
        if (TextUtils.isEmpty(url))
            return;
        OkGo.<String>get(URLDecoder.decode(url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, FundsDetailsFragment.this, true, FundsBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                FundsBean fundsBean = (FundsBean) o;
                if (fundsBean != null && fundsBean.getCode() == 0 && fundsBean.getData() != null && fundsBean.getData().getList() != null) {
                    if (page == 1) {
                        list.clear();
                        listPop.clear();

                        FundsBean.DataBean.GroupsBean groupsBean = new FundsBean.DataBean.GroupsBean();
                        groupsBean.setId(0);
                        groupsBean.setName("全部类型");
                        listPop.add(groupsBean);
                        if (null != fundsBean.getData().getGroups() && fundsBean.getData().getGroups().size() > 0) {
                            listPop.addAll(fundsBean.getData().getGroups());
                        }
                        if (null != adapterCity)
                            adapterCity.notifyDataSetChanged();
                    }

                    list.addAll(fundsBean.getData().getList());
                    mAdapter.notifyDataSetChanged();
//                    if (fundsBean.getData().getList() == null || fundsBean.getData().getList().size() == 0) {
//                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法
//                    }else{
                        if (list.size()!=fundsBean.getData().getTotal())
                        refreshLayout.setEnableLoadMore(true);//是否启用上拉加载功能
                        else
                            refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
//                    }
                    if (list == null || list.size() == 0) {
                        tvData.setVisibility(View.VISIBLE);
                    } else {
                        tvData.setVisibility(View.GONE);
                    }
                }else{
                    refreshLayout.setEnableLoadMore(false);
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

    @OnClick({R.id.tv_titletype})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.tv_titletype:
                popupWindowBuilder.enableBackgroundDark(true);
                mCustomPopWindow = popupWindowBuilder.create();
                mCustomPopWindow.showAsDropDown(mainRel, 0, 0);
                Uiutils.setStateColor(getActivity());
                break;
        }
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        if (null != mCustomPopWindow) {
            mCustomPopWindow.dissmiss();
            Uiutils.setStateColor(getActivity());
        }
        page = 1;

        Uiutils.setText(tvTitletype, listPop.get(position).getName());
        group = listPop.get(position).getId() + "";
        getDeposit();

    }
}
