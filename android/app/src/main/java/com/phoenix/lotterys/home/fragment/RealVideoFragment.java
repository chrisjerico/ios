package com.phoenix.lotterys.home.fragment;


import android.content.Intent;

import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.LinearLayout;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.adapter.GameHallTypeAdapter;
import com.phoenix.lotterys.home.activity.ElectronicActivity;
import com.phoenix.lotterys.home.bean.GameUrlBean;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.GameType;
import com.phoenix.lotterys.main.webview.AgentWebActivity;
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * 真人视讯  六合模板
 */
public class RealVideoFragment extends BaseFragments {
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.rv_ticket_type)
    RecyclerView rvTicketType;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    List<GameType.DataBean.GamesBean> list =new ArrayList<>();
    ;
    private static String name0;
    public static RealVideoFragment getInstance(String name) {
        name0 =name;
        return new RealVideoFragment();
    }

    public RealVideoFragment() {
        super(R.layout.realvideo_frament, true, true);
    }

    @Override
    public void initView(View view) {
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                initData();
            }
        });
        if (!StringUtils.isEmpty(name0))
            titlebar.setText(name0);

        initData();
        Uiutils.setBaColor(getContext(), titlebar, false, null);
        Uiutils.setBarStye0(titlebar,getContext());
        setTheme();  //黑色模板
    }
    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), llMain);
            }
        }
    }
    private void initData() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GAMETYPE))//
                .tag(getActivity())//
                .execute(new NetDialogCallBack(getContext(), true, getActivity(),
                        true, GameType.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameType gameType = (GameType) o;
                        if (gameType != null && gameType.getCode() == 0) {

/*                            if (list != null && gameType.getData() != null) {
                                list.clear();
//                                list.addAll(gameType.getData());
                                if (buytypeadapter != null) {
                                    buytypeadapter.notifyDataSetChanged();
                                }
                            } else */if (gameType.getData() != null) {
//                                list.addAll(gameType.getData().get(1).getGames());
//                                list.addAll(gameType.getData().get(3).getGames());
                                if(list!=null){
                                    list.clear();
                                }
                                for (int i = 0; i < gameType.getData().size(); i++) {
                                    if (gameType.getData().get(i).getCategory().equals("real")) {
                                        list.addAll(gameType.getData().get(i).getGames());
                                    }
                                    if (gameType.getData().get(i).getCategory().equals("sport")) {
                                        list.addAll(gameType.getData().get(i).getGames());
                                    }
                                }
                                GameHallTypeAdapter gametypeadapter = new GameHallTypeAdapter(list, getContext());
                                rvTicketType.setAdapter(gametypeadapter);
                                rvTicketType.setLayoutManager(new GridLayoutManager(getContext(), 2));
                                gametypeadapter.setOnItemClickListener(new GameHallTypeAdapter.OnItemClickListener() {
                                    @Override
                                    public void onItemClick(View view, int position) {
                                        if (ButtonUtils.isFastDoubleClick())
                                            return;
                                        if (list.get(position).getIsPopup() == 0) {
                                            goGame(position);
                                        } else if (list.get(position).getIsPopup() == 1) {
                                            Intent intent = new Intent();
                                            intent.putExtra("id", list.get(position).getId());
                                            intent.putExtra("title", list.get(position).getTitle());
                                            intent.putExtra("supportTrial", list.get(position).getSupportTrial() + "");
                                            intent.setClass(getContext(), ElectronicActivity.class);
                                            startActivity(intent);
                                        }
                                    }
                                });
                            }

                        } else if (gameType != null && gameType.getCode() == 1) {

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
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                Uiutils.setBarStye0(titlebar,getContext());
                break;
        }
    }
    private static String UrlModel = "id=%s&token=%s";

    private void goGame(int position) {
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
        if (token.equals("Null")) {
            Uiutils.login(getActivity());
            return;
        }
        String id = list.get(position).getId();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GOTOGAMEREAL + String.format(UrlModel, SecretUtils.DESede(list.get(position).getId()), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken()))//
                .tag(this)//
                .execute(new NetDialogCallBack(getActivity(), true, getActivity(),
                        true, GameUrlBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameUrlBean url = (GameUrlBean) o;
                        if (url != null && url.getCode() == 0 && url.getData() != null) {
                            Intent intent;
                            if (list.get(position).getId().equals("58")) {  //
                                intent = new Intent(getActivity(), GoWebActivity.class);
                            } else {
                                intent = new Intent(getActivity(), AgentWebActivity.class);
                            }
                            String gameUrl = "";
                            if (Constants.ENCRYPT) {
                                gameUrl = (Constants.BaseUrl() + Constants.GOTOGAME + String.format(UrlModel, SecretUtils.DESede(id),
                                        SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken());
                            } else {
                                gameUrl = url.getData();
                            }
                            gameUrl = gameUrl.replaceAll("\n", "");
                            intent.putExtra("url", gameUrl);
                            intent.putExtra("show", "");
                            startActivity(intent);
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
        name0="";
        super.onDestroy();
    }
}
