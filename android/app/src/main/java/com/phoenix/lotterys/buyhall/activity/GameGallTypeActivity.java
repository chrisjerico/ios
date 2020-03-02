package com.phoenix.lotterys.buyhall.activity;

import android.content.Intent;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.buyhall.adapter.GameHallTypeAdapter;
import com.phoenix.lotterys.home.activity.ElectronicActivity;
import com.phoenix.lotterys.home.bean.GameUrlBean;
import com.phoenix.lotterys.main.bean.GameType;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.main.webview.AgentWebActivity;
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;

import java.io.IOException;
import java.net.URLDecoder;

import butterknife.BindView;

/**
 * Greated by Luke
 * on 2019/9/25
 */
public class GameGallTypeActivity extends BaseActivitys {
    GameType.DataBean mData;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.rv_ticket_type)
    RecyclerView rvTicketType;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;

    public void getIntentData() {
        mData = (GameType.DataBean) getIntent().getSerializableExtra("dataList");

    }

    public GameGallTypeActivity() {
        super(R.layout.activity_buy_hall);
    }


    @Override
    public void initView() {
//        getLotteryBuy(true);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        if (mData == null)
            return;
        initRecyle();
        titlebar.setText(TextUtils.isEmpty(mData.getCategoryName()) ? "" : mData.getCategoryName());
        refreshLayout.setEnableRefresh(true);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
                refreshlayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
//                getLotteryBuy(true);
            }
        });
        Uiutils.setBarStye0(titlebar,this);
    }

    private void initRecyle() {
        GameHallTypeAdapter gametypeadapter = new GameHallTypeAdapter(mData.getGames(), GameGallTypeActivity.this);
        rvTicketType.setAdapter(gametypeadapter);
        rvTicketType.setLayoutManager(new GridLayoutManager(GameGallTypeActivity.this, 2));
        gametypeadapter.setOnItemClickListener(new GameHallTypeAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (mData.getGames().get(position).getIsPopup() == 0) {
                    saveLastData(mData, position);
                    goGame(position);
                } else if (mData.getGames().get(position).getIsPopup() == 1) {
                    saveLastData(mData, position);
                    Intent intent = new Intent();
                    intent.putExtra("id", mData.getGames().get(position).getId());
//                    intent.putExtra("name",mData.getGames().get(position).getCategory());
                    intent.putExtra("title", mData.getGames().get(position).getTitle());
                    intent.putExtra("supportTrial", mData.getGames().get(position).getSupportTrial() + "");
                    intent.setClass(GameGallTypeActivity.this, ElectronicActivity.class);
                    startActivity(intent);
                }
            }
        });
    }

    private void saveLastData(GameType.DataBean mData, int position) {
        try {
            HomeGame.DataBean.IconsBean.ListBean data;
            data = new HomeGame.DataBean.IconsBean.ListBean();
            data.setGameId(mData.getGames().get(position).getId());
            data.setSeriesId(mData.getCategory().equals("real") ? "2" : mData.getCategory().equals("game") ? "4" : mData.getCategory().equals("card") ? "5" : mData.getCategory().equals("sport") ? "6" : mData.getCategory().equals("fish") ? "3" : "1");
            data.setIcon(mData.getGames().get(position).getPic());
            data.setTipFlag(mData.getGames().get(position).getIsHot());
            data.setIsPopup(mData.getGames().get(position).getIsPopup() + "");
            data.setTitle(mData.getGames().get(position).getTitle());
            data.setSupportTrial(mData.getGames().get(position).getSupportTrial());
            Constants.addLastReadList(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String UrlModel = "id=%s&token=%s";

    private void goGame(int position) {
        String token = SPConstants.getValue(GameGallTypeActivity.this, SPConstants.SP_API_SID);
        if (token.equals("Null")) {
//            startActivity(new Intent(GameGallTypeActivity.this, LoginActivity.class));
            Uiutils.login(this);
            return;
        }
        String id = mData.getGames().get(position).getId();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GOTOGAMEREAL + String.format(UrlModel, SecretUtils.DESede(mData.getGames().get(position).getId()), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken()))//
                .tag(this)//
                .execute(new NetDialogCallBack(GameGallTypeActivity.this, true, GameGallTypeActivity.this,
                        true, GameUrlBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameUrlBean url = (GameUrlBean) o;
                        if (url != null && url.getCode() == 0 && url.getData() != null) {
                            Intent intent;
                            if (mData.getGames().get(position).getId().equals("58")) {  //
                                intent = new Intent(GameGallTypeActivity.this, GoWebActivity.class);
                            } else {
                                intent = new Intent(GameGallTypeActivity.this, AgentWebActivity.class);
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
}
