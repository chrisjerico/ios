package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Html;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.MailAdapterB;
import com.phoenix.lotterys.my.bean.MailFragBean;
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
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;

import org.greenrobot.eventbus.EventBus;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;

/**
 * 文件描述:站内信
 * 创建者: IAN
 * 创建时间: 2019/7/3 19:51
 */
@SuppressLint("ValidFragment")
public class MailFragB extends BaseFragments implements BaseRecyclerAdapter.OnItemClickListener,
        View.OnClickListener, OnRefreshListener, OnLoadMoreListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.iv_back)
    ImageView iv_back;

    @BindView(R2.id.mail_rec)
    RecyclerView mailRec;
    @BindView(R2.id.smart_refresh_layout)
    SmartRefreshLayout smartRefreshLayout;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;

    private int postion;
    private TextView contextTex;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;
    private MailAdapterB adapter;
    private int page = 1;
    private int rows = 20;
    private MailFragBean mailFragBean;
    private List<MailFragBean.DataBean.ListBean> list = new ArrayList<>();
    private CustomPopWindow mCustomPopWindow;
    Boolean isRead = false;
    boolean isHide = false;

    @SuppressLint("ValidFragment")
    public MailFragB(boolean isHide) {
        super(R.layout.mail_act_b, true, true);
        this.isHide = isHide;
    }

    @Override
    public void initView(View v) {
        Uiutils.setBaColor(getContext(),mainLin);

        titlebar.setText(getResources().getString(R.string.mail));
        titlebar.setRIghtTvVisibility(0x00000008);

        iv_back.setOnClickListener(this);

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        mailRec.setLayoutManager(linearLayoutManager);
        mailRec.addItemDecoration(new SpacesItemDecoration(getContext(), 2));

        adapter = new MailAdapterB(getContext(), list, R.layout.mail_adapter);

        adapter.setOnItemClickListener(this);
        mailRec.setAdapter(adapter);

        smartRefreshLayout.setOnRefreshListener(this);
        smartRefreshLayout.setOnLoadMoreListener(this);

        smartRefreshLayout.setEnableLoadMore(false);
        smartRefreshLayout.setEnableRefresh(true);

        contentView = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop_b, null);
        contentView.findViewById(R.id.clear_tex).setOnClickListener(this);
        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);
        ((TextView) contentView.findViewById(R.id.title_tex)).setText(R.string.message_content);
        contextTex = ((TextView) contentView.findViewById(R.id.context_tex));

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 300),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

        requestData(true);
        if (isHide)
            titlebar.setIvBackHide(View.GONE);

        Uiutils.setBaColor(getContext(), titlebar, false, null);

        Uiutils.setBarStye0(titlebar,getContext());
    }

    private void requestData(boolean isShow) {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("page", page + "");
        map.put("rows", rows + "");

        NetUtils.get(Constants.MSGLIST, map, true, getContext()
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        smartRefreshLayout.finishRefresh();
                        smartRefreshLayout.finishLoadMore();

                        mailFragBean = GsonUtil.fromJson(object, MailFragBean.class);

                        if (page == 1) {
                            if (list.size() > 0)
                                list.clear();
                        }


                        if (null != mailFragBean && null != mailFragBean.getData() && null != mailFragBean.
                                getData().getList() && mailFragBean.getData().getList().size() > 0) {
                            list.addAll(mailFragBean.getData().getList());
                        }

                        if (null != mailFragBean && list.size() != mailFragBean.getData().getTotal()) {
                            smartRefreshLayout.setEnableLoadMore(true);
                        } else {
                            smartRefreshLayout.setEnableLoadMore(false);
                        }

                        adapter.notifyDataSetChanged();
                    }

                    @Override
                    public void onError() {
                        smartRefreshLayout.finishRefresh();
                        smartRefreshLayout.finishLoadMore();
                    }
                });
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        //防止快速点击
        if (!Uiutils.isFastClick()) {
            return;
        }
        this.postion = position;
//        contextTex.setText(list.get(position)
//                .getContent());
        contextTex.setText(Html.fromHtml(list.get(position)
                .getContent()));
        ((TextView) contentView.findViewById(R.id.title_tex)).setText(list.get(position)
                .getTitle());


        mCustomPopWindow = popupWindowBuilder.create();
        mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
        setRead();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.clear_tex:
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.commit_tex:
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.iv_back:
                if (isRead) {
                    EventBus.getDefault().post(new Even(EvenBusCode.READ));
                }
                if (!isHide)
                    getActivity().finish();
                break;

        }
    }


    @Override
    public void onResume() {
        super.onResume();
        getFocus();
    }

    //主界面获取焦点
    private void getFocus() {
        getView().setFocusableInTouchMode(true);
        getView().requestFocus();
        getView().setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (event.getAction() == KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_BACK) {
                    // 监听到返回按钮点击事件
                    if (isRead) {
                        EventBus.getDefault().post(new Even(EvenBusCode.READ));
                    }
                    if (!isHide)
                        getActivity().finish();
                    return true;
                }
                return false;
            }
        });


    }

    private void setRead() {
        Map<String, Object> httpParams = new HashMap<>();
        httpParams.put("token", Uiutils.getToken(getContext()));
        httpParams.put("id", list.get(postion).getId());

        NetUtils.post(Constants.READMSG, httpParams, true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        list.get(postion).setIsRead(1);
                        adapter.notifyDataSetChanged();
                        isRead = true;


                    }

                    @Override
                    public void onError() {
                    }
                });
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        requestData(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page = 1;
        requestData(false);
    }

    @Override
    public void onDestroy() {
//        if (isRead) {
//            EventBus.getDefault().post(new Even(EvenBusCode.READ));
//        }
        super.onDestroy();

    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                break;
        }
    }

    protected void onTransformResume() {
        page = 1;
        requestData(false);
    }
}
