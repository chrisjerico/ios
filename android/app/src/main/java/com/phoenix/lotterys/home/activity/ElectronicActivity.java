package com.phoenix.lotterys.home.activity;

import android.content.Context;
import android.content.Intent;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.home.adapter.ElectronicAdapter;
import com.phoenix.lotterys.home.bean.GameList;
import com.phoenix.lotterys.home.bean.GameUrlBean;
import com.phoenix.lotterys.main.webview.AgentWebActivity;
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
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
 * Created by Luke
 * on 2019/6/14
 */
//电子游戏
public class ElectronicActivity extends BaseActivitys {
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.rv_data)
    RecyclerView rvData;
    private String id, type, /*name,*/
            title, supportTrial;
    ElectronicAdapter mAdapter;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    private static String URLMODEL = "?c=real&a=%s&id=%s";

    public ElectronicActivity() {
        super(R.layout.electronicactivity);
    }

    @Override
    public void getIntentData() {
        id = getIntent().getStringExtra("id");
        title = getIntent().getStringExtra("title");
        supportTrial = getIntent().getStringExtra("supportTrial");

    }

    @Override
    public void initView() {

        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        titlebar.setText(title);
        refreshLayout.setEnableRefresh(false);//是否启用下拉刷新功能
        refreshLayout.setEnableLoadMore(false);//是否启用上拉加载功能
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshlayout) {
//                refreshlayout.finishRefresh(2000/*,false*/);//传入false表示刷新失败

            }
        });
        initRecycler();

        Uiutils.setBarStye0(titlebar,this);
    }

    private void initRecycler() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GOTOGAMELIST + SecretUtils.DESede(id) + "&sign=" + SecretUtils.RsaToken()))//
                .tag(this)//
                .execute(new NetDialogCallBack(this, true, this,
                        true, GameList.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        refreshLayout.finishRefresh();
                        GameList gl = (GameList) o;
                        if (gl != null && gl.getCode() == 0) {
                            mAdapter = new ElectronicAdapter(gl.getData(), ElectronicActivity.this);
                            rvData.setLayoutManager(new GridLayoutManager(ElectronicActivity.this, 3));
                            rvData.setAdapter(mAdapter);
                            mAdapter.setListener(new ElectronicAdapter.OnClickListener() {
                                @Override
                                public void onClickListener(View view, int position) {
                                    if (!TextUtils.isEmpty(supportTrial) && supportTrial.equals("1"))
                                        goGame(ElectronicActivity.this, id, gl.getData().get(position).getCode());
                                    else if (!TextUtils.isEmpty(supportTrial) && supportTrial.equals("0"))
                                        if (Uiutils.isTourist(ElectronicActivity.this)) {
                                            return;
                                        } else {
                                            goGame(ElectronicActivity.this, id, gl.getData().get(position).getCode());
                                        }
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

    private static String URLGAMEMODEL = "id=%s&game=%s&token=%s";

    public static void goGame(Context context, String id, String code) {
        String token = SPConstants.getValue(context, SPConstants.SP_API_SID);
        if (token.equals("Null")) {
//            startActivity(new Intent(this, LoginActivity.class));
            Uiutils.login(context);
            return;
        }
        String url = String.format(URLGAMEMODEL, SecretUtils.DESede(id), SecretUtils.DESede(code), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GOTOGAMEREAL + url))//
                .tag(context)//
                .execute(new NetDialogCallBack(context, true, context,
                        true, GameUrlBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameUrlBean url = (GameUrlBean) o;
                        if (url != null && url.getCode() == 0&&url.getData()!=null) {
                            Intent intent;
                            if (id.equals("58")) {  //
                                intent = new Intent(context, GoWebActivity.class);
                            } else {
                                intent = new Intent(context, AgentWebActivity.class);
                            }
                            String goGame = "";
                            if(Constants.ENCRYPT ){
                                goGame = (Constants.BaseUrl() + Constants.GOTOGAME + String.format(URLGAMEMODEL, SecretUtils.DESede(id),
                                        SecretUtils.DESede(code), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken());
                            }else {
                                goGame =url.getData();
                            }
                            goGame=goGame.replaceAll("\n", "");
                            intent.putExtra("url", goGame);
                            intent.putExtra("show", "");
                            context.startActivity(intent);
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
