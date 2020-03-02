package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.adapter.CityPopAdapter;
import com.phoenix.lotterys.my.adapter.FeedbackRecordAdapter;
import com.phoenix.lotterys.my.bean.FeedbackRecordBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:  反馈记录
 * 创建者: IAN
 * 创建时间: 2019/7/5 20:12
 */
public class FeedbackRecordFragB extends BaseFragments implements
        BaseRecyclerAdapter.OnItemClickListener, OnRefreshListener, OnLoadMoreListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.time_hoice_tex)
    TextView timeHoiceTex;
    @BindView(R2.id.time_hoice_lin)
    LinearLayout timeHoiceLin;
    @BindView(R2.id.type_sele_tex)
    TextView typeSeleTex;
    @BindView(R2.id.type_lin)
    LinearLayout typeLin;
    @BindView(R2.id.type_tex)
    TextView typeTex;
    @BindView(R2.id.statre_tex)
    TextView statreTex;
    @BindView(R2.id.context_tex)
    TextView contextTex;
    @BindView(R2.id.feedback_record_rec)
    RecyclerView feedbackRecordRec;

    @BindView(R2.id.feedback_record_refresh)
    SmartRefreshLayout feedbackRecordRefresh;

    private  View timeHoiceLi;
    private  View typeLi;

    private FeedbackRecordAdapter adapter;
    private FeedbackRecordBean feedbackRecordBean;
    private List<FeedbackRecordBean.DataBean.ListBean> list = new ArrayList<>();
    private List<My_item> listPop = new ArrayList<>();
    private List<My_item> listPopType = new ArrayList<>();
    private List<My_item> listPopState = new ArrayList<>();

    private CustomPopWindow mCustomPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;

    private RecyclerView popRec;
    private CityPopAdapter adapterCity;
    private int status = 0;
    private int page = 1;
    private int rows = 100;
    private List<String> lists;
    private int index;

    public FeedbackRecordFragB() {
        super(R.layout.feedback_record_frag_b, true,
                true);
    }

    @Override
    public void initView(View view) {
        timeHoiceLi =view.findViewById(R.id.time_hoice_li);
        typeLi =view.findViewById(R.id.type_li);

        titlebar.setText("反馈记录");
        Uiutils.setBarStye(titlebar, getActivity());

        typeTex.setText(R.string.pay_type);
        statreTex.setText(R.string.pay_status);
        contextTex.setText(R.string.content_description);

        feedbackRecordRefresh.setOnRefreshListener(this);
        feedbackRecordRefresh.setOnLoadMoreListener(this);
        feedbackRecordRefresh.setEnableLoadMore(false);
        feedbackRecordRefresh.setEnableRefresh(true);


        setData();
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        feedbackRecordRec.setLayoutManager(linearLayoutManager);
        feedbackRecordRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));
        adapter = new FeedbackRecordAdapter(getContext(), list, R.layout.feedback_record_adapter_b);
        feedbackRecordRec.setAdapter(adapter);


        FeedbackRecordBean.DataBean.ListBean listBean = new FeedbackRecordBean.
                DataBean.ListBean();

        adapter.setOnItemClickListener(this);

        showPopMenu();


    }

    private void setPopView() {
        if (null == contentView)
            return;

        popRec = contentView.findViewById(R.id.pop_rec);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        popRec.setLayoutManager(linearLayoutManager);
        popRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));

        adapterCity = new CityPopAdapter(getContext(), listPop, R.layout.city_pop_adapter);
        popRec.setAdapter(adapterCity);
        adapterCity.setOnItemClickListener(this);
    }

    private void showPopMenu() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.city_pop, null);
        contentView.findViewById(R.id.main_lin).setBackgroundColor(getContext().getResources()
                .getColor(R.color.black1));

        //处理popWindow c
        setPopView();
        //创建并显示popWindow
//        mCustomPopWindow = new CustomPopWindow.PopupWindowBuilder(getContext())
//                .setView(contentView)
//                .setBgDarkAlpha(0.7f) // 控制亮度
//                .create();

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(),120), ViewGroup.LayoutParams.WRAP_CONTENT,
                true, false, 0.5f);

    }

    private void setData() {
        lists = Uiutils.test(7);
        if (null != lists && lists.size() > 0) {
            for (int i = 0; i < lists.size(); i++) {
                if (i == 0) {
                    listPopType.add(new My_item(lists.get(i), true));
                } else {
                    listPopType.add(new My_item(lists.get(i), false));
                }
            }
        }
        timeHoiceTex.setText(listPopType.get(0).getTitle());

        listPopState.add(new My_item(getResources().getString(R.string.whole), true));
        listPopState.add(new My_item(getResources().getString(R.string.to_be_answered),
                false));
        listPopState.add(new My_item(getResources().getString(R.string.replied), false));
        typeSeleTex.setText(listPopState.get(0).getTitle());

        requstData(true);
    }


    private void showPop(View view, List<My_item> currentList, int index) {
        popupWindowBuilder.enableBackgroundDark(true);
        mCustomPopWindow=popupWindowBuilder.create();
        this.index = index;
        if (null != mCustomPopWindow) {
            if (listPop.size() > 0)
                listPop.clear();

            if (null != currentList && currentList.size() > 0) {
                listPop.addAll(currentList);
            }
            adapterCity.notifyDataSetChanged();
        }
        mCustomPopWindow.showAsDropDown(view, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    @OnClick({R.id.time_hoice_lin, R.id.type_lin})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.time_hoice_lin:
                setType(1);
                showPop(timeHoiceLin, listPopType, 1);
                break;
            case R.id.type_lin:
                setType(2);
                showPop(typeLin, listPopState, 2);
                break;
        }
    }

    private void setType( int type) {

        switch (type){
            case 1:
                timeHoiceTex.setSelected(true);
                timeHoiceLi.setBackgroundColor(getContext().getResources().getColor(R.color.title_backgroup));

                typeSeleTex.setSelected(false);
                typeLi.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));
                break;
            case 2:
                typeSeleTex.setSelected(true);
                typeLi.setBackgroundColor(getContext().getResources().getColor(R.color.title_backgroup));

                timeHoiceTex.setSelected(false);
                timeHoiceLi.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));
                break;

            case 3:
                timeHoiceTex.setSelected(false);
                timeHoiceLi.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));

                typeSeleTex.setSelected(false);
                typeLi.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));
                break;
        }
    }

    private void setDatas(int position, List<My_item> list) {
        for (int i = 0; i < list.size(); i++) {
            if (i == position) {
                list.get(i).setSelected(true);
            } else {
                list.get(i).setSelected(false);
            }
        }
    }


    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {

        if (view.getId() == R.id.feedback_lin) {
            Bundle build = new Bundle();
            build.putSerializable("name", list.get(position));

            FragmentUtilAct.startAct(getActivity(), new FeedbackRecordDetailsFragB(), build);
        } else {

//            timeHoiceTex.setSelected(false);
//            typeSeleTex.setSelected(false);

            if (null != mCustomPopWindow) {
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
            }
            switch (index) {
                case 1:
                    resetList(listPopType, position);
                    timeHoiceTex.setText(listPopType.get(position).getTitle());
                    setType(1);
                    break;
                case 2:
                    setType(2);
                    switch (position) {
                        case 0:
                            status = position;
                            break;
                        case 1:
                            status = 2;
                            break;
                        case 2:
                            status = 1;
                            break;
                    }

                    resetList(listPopState, position);
                    typeSeleTex.setText(listPopState.get(position).getTitle());
                    break;
            }

            requstData(true);
        }
    }

    private void requstData(boolean isShow) {

        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("date", timeHoiceTex.getText().toString().trim());
        map.put("isReply", status+"");
        map.put("page", page+"");
        map.put("rows", rows+"");

        NetUtils.get(Constants.MYFEEDBACK ,map,
                isShow, getContext(), new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        feedbackRecordRefresh.finishRefresh();
                        feedbackRecordRefresh.finishLoadMore();

                        if (page == 1) {
                            if (list.size() > 0)
                                list.clear();
                        }

                        if (null != object) {
                            feedbackRecordBean = GsonUtil.fromJson((String) object, FeedbackRecordBean.class);
                        }

                        if (null != feedbackRecordBean && null != feedbackRecordBean.getData() && null != feedbackRecordBean.getData().getList()
                                && feedbackRecordBean.getData().getList().size() > 0) {
                            list.addAll(feedbackRecordBean.getData().getList());

                            if (list.size() == feedbackRecordBean.getData().getTotal()) {
                                feedbackRecordRefresh.setEnableLoadMore(false);
                            } else {
                                feedbackRecordRefresh.setEnableLoadMore(true);
                            }
                        } else {
                            feedbackRecordRefresh.setEnableLoadMore(false);
                        }

                        adapter.notifyDataSetChanged();
                    }

                    @Override
                    public void onError() {
                        feedbackRecordRefresh.finishRefresh();
                        feedbackRecordRefresh.finishLoadMore();
                    }
                });
    }

    private void resetList(List<My_item> list, int position) {
        if (null != list && list.size() > 0 && list.size() > position) {
            for (int i = 0; i < list.size(); i++) {
                if (i == position) {
                    list.get(i).setSelected(true);
                } else {
                    list.get(i).setSelected(false);
                }
            }
        }
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        requstData(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page = 1;
        requstData(false);
    }
}
