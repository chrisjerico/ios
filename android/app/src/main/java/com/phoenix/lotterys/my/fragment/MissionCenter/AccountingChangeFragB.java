package com.phoenix.lotterys.my.fragment.MissionCenter;

import android.graphics.drawable.Drawable;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.AccountingChangeAdapter;
import com.phoenix.lotterys.my.adapter.AccountingChangePopAdapter;
import com.phoenix.lotterys.my.bean.AccountingChangeBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:  开心乐账变
 * 创建者: IAN
 * 创建时间: 2019/7/3 12:56
 */
public class AccountingChangeFragB extends BaseFragments implements OnRefreshListener, OnLoadMoreListener{


    @BindView(R2.id.name_tex)
    TextView nameTex;
    @BindView(R2.id.name_tex_lin)
    TextView nameTexLin;
    @BindView(R2.id.happiness_tex)
    TextView happinessTex;
    @BindView(R2.id.happiness_tex_lin)
    TextView happinessTexLin;
    @BindView(R2.id.happy_balance_tex)
    TextView happyBalanceTex;
    @BindView(R2.id.happy_balance_tex_lin)
    TextView happyBalanceTexLin;
    @BindView(R2.id.full_date_tex)
    TextView fullDateTex;
    @BindView(R2.id.accounting_rec)
    RecyclerView accountingRec;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.name_text1)
    TextView nameText1;
    @BindView(R2.id.happiness_tex0)
    TextView happinessTex0;
    @BindView(R2.id.full_date_lin)
    LinearLayout fullDateLin;
    @BindView(R2.id.mission_refresh)
    SmartRefreshLayout missionRefresh;

    public AccountingChangeFragB() {
        super(R.layout.accounting_change_frag_b, true, true);
    }

    private ConfigBean configBean;
    private String name;

    @Override
    public void initView(View view) {

        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        name = StringUtils.isEmpty(configBean.getData()
                .getMissionName())?"开心乐":configBean.getData()
                .getMissionName();

        missionRefresh.setEnableRefresh(true);//是否启用下拉刷新功能
        missionRefresh.setEnableLoadMore(false);//是否启用上拉加载功能

        missionRefresh.setOnRefreshListener(this);
        missionRefresh.setOnLoadMoreListener(this);

//        mainLin.setBackgroundColor(getContext().getResources().getColor(R.color.bac_ash));

        nameTexLin.setVisibility(View.GONE);
        happinessTexLin.setVisibility(View.GONE);
        happyBalanceTexLin.setVisibility(View.GONE);

        nameTex.setText(R.string.accounting_variance_type);
        happinessTex.setText(name);
        happyBalanceTex.setText(name+"余额");
        fullDateTex.setText(R.string.full_date);

        Drawable drawable = getResources().getDrawable(R.drawable.white_down);
        drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
        fullDateTex.setCompoundDrawables(null, null, drawable, null);


        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        accountingRec.setLayoutManager(linearLayoutManager);
        accountingRec.addItemDecoration(new SpacesItemDecoration(getContext()));

        listarray = getContext().getResources().getStringArray(R.array.accounting_ecent_time);
        if (null != listarray && listarray.length > 0) {
            for (int i = 0; i < listarray.length; i++) {
                listDate.add(new My_item(i, listarray[i]));
            }
        }

         adapter = new AccountingChangeAdapter(getContext(), list, R.layout.pubglidstye_b, 1);
        accountingRec.setAdapter(adapter);

//        showPopMenu();
        setPopView();

        getData(true);

    }
    private AccountingChangeBean accountingChangeBean;
    private AccountingChangeAdapter adapter;
    private List<AccountingChangeBean.DataBean.ListBean> list =new ArrayList<>();
    private int page = 1;
    private int rows = 20;
    private int tim = 0;
    private void getData(boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("page", page+"");
        map.put("time", tim+"");
        map.put("rows", rows+"");
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CREDITSLOG ,map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                missionRefresh.finishRefresh();
                missionRefresh.finishLoadMore();

                accountingChangeBean = GsonUtil.fromJson(object, AccountingChangeBean.class);

                if (page == 1) {
                    if (list.size() > 0)
                        list.clear();
                }

                if (null != accountingChangeBean && null != accountingChangeBean.getData() && null != accountingChangeBean.
                        getData().getList() && accountingChangeBean.getData().getList().size() > 0) {
                    list.addAll(accountingChangeBean.getData().getList());
                }

                if (null != accountingChangeBean && list.size() != accountingChangeBean.getData().getTotal()) {
                    missionRefresh.setEnableLoadMore(true);
                } else {
                    missionRefresh.setEnableLoadMore(false);
                }

                adapter.notifyDataSetChanged();
            }

            @Override
            public void onError() {
            missionRefresh.finishRefresh();
            missionRefresh.finishLoadMore();
            }
        });
    }

    private AccountingChangePopAdapter popAdapter;
    private List<My_item> listDate = new ArrayList<>();
    private String[] listarray;
    private CustomPopWindow mCustomPopWindow;
    private View contentView;
    private RecyclerView popRec;

    private void showPopMenu() {

        mCustomPopWindow = new CustomPopWindow.PopupWindowBuilder(getActivity())
                .size(ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT)
                .setView(contentView)
                .enableOutsideTouchableDissmiss(true)
                .enableBackgroundDark(true)
                .setOnDissmissListener(new PopupWindow.OnDismissListener() {
                    @Override
                    public void onDismiss() {
                            Uiutils.setStateColor(getActivity());
                    }
                })
                .setBgDarkAlpha(0.5f) // 控制亮度
                .create();

        mCustomPopWindow.showAtLocation(contentView, Gravity.BOTTOM, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private void setPopView() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.city_pop, null);
        //处理popWindow c
//        setPopView();

        if (Uiutils.setBaColor(getContext(),null)){
            contentView.findViewById(R.id.main_lin).setBackgroundColor(getContext().getResources()
                    .getColor(R.color.black1));
            ((TextView)contentView.findViewById(R.id.tis_tex)).setTextColor(getContext().getResources()
                    .getColor(R.color.color_white));
        }

        popRec = contentView.findViewById(R.id.pop_rec);
        Uiutils.setRec(getContext(), popRec, 0);

        contentView.findViewById(R.id.tis_tex).setVisibility(View.VISIBLE);
        contentView.findViewById(R.id.tis_tex_lin).setVisibility(View.VISIBLE);

        popAdapter = new AccountingChangePopAdapter(getContext(), listDate,
                R.layout.item_title_no_background);

        popRec.setAdapter(popAdapter);

        popAdapter.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {
                fullDateTex.setText(listDate.get(position).getTitle());
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                tim =position;
                page=1;
                getData(true);
            }
        });
    }

    @OnClick(R.id.full_date_lin)
    public void onClick() {

        showPopMenu();
//        mCustomPopWindow.showAsDropDown(contentView,0,0, Gravity.BOTTOM);


    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        getData(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page = 1;
        getData(false);
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.REFRESH_ACCOUNT_CHANGE:
                getData(true);
                break;
            case EvenBusCode.LOGIN :
                page =1;
                getData(false);
                break;
        }
    }
}
