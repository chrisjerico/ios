package com.phoenix.lotterys.my.fragment.MissionCenter;

import android.graphics.Typeface;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.MissionHallAdapter;
import com.phoenix.lotterys.my.bean.MissionHallBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;

/**
 * 文件描述:  任务大厅
 * 创建者: IAN
 * 创建时间: 2019/7/3 12:56
 */
public class MissionHallFrag extends BaseFragments implements
        OnRefreshListener, OnLoadMoreListener, View.OnClickListener,
        BaseRecyclerAdapter.OnItemClickListener {

    @BindView(R2.id.mission_hall_rec)
    RecyclerView missionHallRec;

    @BindView(R2.id.mission_refresh)
    SmartRefreshLayout missionRefresh;

    private MissionHallAdapter adapter;

    public MissionHallFrag() {
        super(R.layout.mission_hall_frag, true, true);
    }

    @Override
    public void initView(View view) {

        missionRefresh.setEnableRefresh(true);//是否启用下拉刷新功能
        missionRefresh.setEnableLoadMore(false);//是否启用上拉加载功能

        missionRefresh.setOnRefreshListener(this);
        missionRefresh.setOnLoadMoreListener(this);

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        missionHallRec.setLayoutManager(linearLayoutManager);
        missionHallRec.addItemDecoration(new SpacesItemDecoration(getContext()));

        setPop();

        adapter = new MissionHallAdapter(getContext(), list, R.layout.mission_hall_adapter);
        missionHallRec.setAdapter(adapter);
        adapter.setOnItemClickListener(this);
        getData(true);

    }
    private List<MissionHallBean.DataBean.ListBean> list =new ArrayList<>();
    private MissionHallBean missionHallBean;
    private int page=1;
    private int rows=20;
    private void getData(boolean b) {
        Map<String,Object> map =new HashMap<>();
        map.put("page",page+"");
        map.put("rows",rows+"");
        if (getArguments() != null) {
            map.put("category",getArguments().getString("type"));
        }
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CENTER ,map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                missionRefresh.finishRefresh();
                missionRefresh.finishLoadMore();

                missionHallBean = GsonUtil.fromJson(object, MissionHallBean.class);

                if (page == 1) {
                    if (list.size() > 0)
                        list.clear();
                }

                if (null != missionHallBean && null != missionHallBean.getData() && null != missionHallBean.
                        getData().getList() && missionHallBean.getData().getList().size() > 0) {
                    list.addAll(missionHallBean.getData().getList());
                }

                if (null != missionHallBean && list.size() != missionHallBean.getData().getTotal()) {
                    missionRefresh.setEnableLoadMore(true);
                } else {
                    missionRefresh.setEnableLoadMore(false);
                }

                adapter.notifyDataSetChanged();
            }

            @Override
            public void onError() {
                if (null!=missionRefresh) {
                    missionRefresh.finishRefresh();
                    missionRefresh.finishLoadMore();
                }
            }
        });
    }

    private CustomPopWindow customPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private  View contentView;
    private TextView contextTex;
    private  void  setPop(){
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop, null);
        contentView.findViewById(R.id.clear_tex).setVisibility(View.GONE);
        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);
        ((TextView) contentView.findViewById(R.id.title_tex)).setText("任务详情");
        ((TextView) contentView.findViewById(R.id.title_tex)).
                setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
        contextTex=((TextView) contentView.findViewById(R.id.context_tex));
        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 300),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, false, 0.5f);

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.clear_tex:
                if (null!=customPopWindow) {
                    customPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                }
                break;
            case R.id.commit_tex:
                if (null!=customPopWindow) {
                    customPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                }
                break;
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.MISSION_HALL_POP:
                popupWindowBuilder.enableBackgroundDark(true);
                customPopWindow = popupWindowBuilder.create();
                customPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                Uiutils.setStateColor(getActivity());
                break;

            case EvenBusCode.MISSION_REFRESH :
                page =1;
                getData(false);
                break;
            case EvenBusCode.LOGIN :
                page =1;
                getData(false);
                break;

        }
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        getData(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page =1;
        getData(false);
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        //防止快速点击
        if (!Uiutils.isFastClick()) {
            return;
        }
        contextTex.setText(list.get(position)
                .getMissionDesc());
        popupWindowBuilder.enableBackgroundDark(true);
        customPopWindow = popupWindowBuilder.create();
        customPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
    }
//    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;


}
