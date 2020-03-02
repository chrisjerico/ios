package com.phoenix.lotterys.chat.fragment;

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
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;

import com.phoenix.lotterys.view.CustomTitleBar;
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
public class ChatListFragment extends BaseFragments {
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
    public ChatListFragment(boolean isHide, boolean isHidetitle) {
        super(R.layout.fragment_coupons, true, true);
        this.isHide = isHide;
        this.isHidetitle = isHidetitle;
    }

    public static ChatListFragment getInstance(boolean isHide, boolean isHidetitle) {
        return new ChatListFragment(isHide,isHidetitle);
    }

    @Override
    public void initView(View view) {

        initdata();
//        initChatRoomList();
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

        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.COUPONS))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), true, ChatListFragment.this,
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
                            mAdapter = new CouponsAdapter(list, getContext(),template,true,true);
                            LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
                            layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
                            rvCoup.setLayoutManager(layoutManager);
                            rvCoup.setAdapter(mAdapter);
                            mAdapter.setListener(new CouponsAdapter.OnClickListener() {
                                @Override
                                public void onClickListener(View view, int position) {
                                    if (TextUtils.isEmpty(list.get(position).getContent()))
                                        return;
                                    Intent intent = null;
//                                    if (NumUtil.isContain(list.get(position).getContent(), "img src=")) {
                                        intent = new Intent(getContext(), GoWebActivity.class);
//                                    } else {
//                                        intent = new Intent(getContext(), RichTextActivity.class);
//                                    }
                                   String data = list.get(position).getContent().replaceAll("nowrap", "nowrap1");
                                    intent.putExtra("url", data);
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
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                break;
        }
    }


//    private void initChatRoomList() {
//        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
//        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.GET_TOKEN + (Constants.ENCRYPT ? Constants.SIGN : "")))
//                .params("token", SecretUtils.DESede(token))
//                .params("t", SecretUtils.DESede(String.valueOf(System.currentTimeMillis())))
//                .params("sign", SecretUtils.RsaToken())
//                .tag(this)
//                .execute(new NetDialogCallBack(getContext(), true, this,
//                        false, RoomListEntity.class) {
//                    @Override
//                    public void onUi(Object o) {
//                        RoomListEntity bean = (RoomListEntity) o;
//                        if (bean.getCode() == 0 && bean.getData() != null) {
//Log.e("xxxxx",""+bean);
//                        }
//                    }
//
//                    @Override
//                    public void onErr(BaseBean bb) throws IOException {
//
//                    }
//
//                    @Override
//                    public void onFailed(Response<String> response) {
//
//                    }
//
//                });
//    }


}
