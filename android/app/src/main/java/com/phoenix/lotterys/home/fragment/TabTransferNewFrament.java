package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;

import com.google.android.material.tabs.TabLayout;
import androidx.fragment.app.Fragment;

import android.view.View;
import android.widget.FrameLayout;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.WalletBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Greated by Luke
 * on 2019/10/4
 */

/*额度转换 新界面*/
@SuppressLint("ValidFragment")
public class TabTransferNewFrament extends BaseFragments {

    @BindView(R2.id.tabLayout)
    TabLayout tabLayout;
    @BindView(R2.id.fl_change)
    FrameLayout flChange;
    TransferNewFrament mContext;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    List<WalletBean.DataBean> cardData = new ArrayList<>();//棋牌
    List<WalletBean.DataBean> esportData = new ArrayList<>();//电竞
    List<WalletBean.DataBean> realData = new ArrayList<>(); //视讯
    List<WalletBean.DataBean> gameData = new ArrayList<>();//电子
    List<WalletBean.DataBean> fishData = new ArrayList<>();   //捕鱼
    List<WalletBean.DataBean> sportData = new ArrayList<>();  //体育
    List<WalletBean> walletList = new ArrayList<>();

    TransFerListFrament  transFerListFrament;
    @SuppressLint("ValidFragment")
    public TabTransferNewFrament(TransferNewFrament mContext) {
        super(R.layout.frament_tab_new_transfer, true, true);
        this.mContext= mContext;
    }

    @Override
    public void initView(View view) {
        getGameList();
    }

    private void getGameList() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.WALLETLIST)).tag(this).execute(new NetDialogCallBack(getActivity(), true, getActivity(), true, WalletBean.class) {
            @SuppressLint("SetTextI18n")
            @Override
            public void onUi(Object o) throws IOException {
                WalletBean wallet = (WalletBean) o;
                if (wallet != null && wallet.getCode() == 0 && wallet.getData() != null) {
                    for (WalletBean.DataBean walletdata : wallet.getData()) {
                        if (walletdata.getCategory().equals("card")) {
                            cardData.add(walletdata);
                        }
                        if (walletdata.getCategory().equals("esport")) {
                            esportData.add(walletdata);
                        }
                        if (walletdata.getCategory().equals("real")) {
                            realData.add(walletdata);
                        }
                        if (walletdata.getCategory().equals("game")) {
                            gameData.add(walletdata);
                        }
                        if (walletdata.getCategory().equals("fish")) {
                            fishData.add(walletdata);
                        }
                        if (walletdata.getCategory().equals("sport")) {
                            sportData.add(walletdata);
                        }
                    }
                    WalletBean.DataBean data = new WalletBean.DataBean("中心钱包", "0");
                    if (realData.size() != 0) {
                        realData.add(0,data);
                        WalletBean r = new WalletBean();
                        r.setData(realData);
                        r.setTitle("视讯");
                        walletList.add(r);
                    }
                    if (cardData.size() != 0) {
                        cardData.add(0,data);
                        WalletBean c = new WalletBean();
                        c.setData(cardData);
                        c.setTitle("棋牌");
                        walletList.add(c);
                    }
                    if (gameData.size() != 0) {
                        gameData.add(0,data);
                        WalletBean g = new WalletBean();
                        g.setData(gameData);
                        g.setTitle("电子");
                        walletList.add(g);
                    }
                    if (esportData.size() != 0) {
                        esportData.add(0,data);
                        WalletBean e = new WalletBean();
                        e.setData(esportData);
                        e.setTitle("电竞");
                        walletList.add(e);
                    }
                    if (fishData.size() != 0) {
                        fishData.add(0,data);
                        WalletBean f = new WalletBean();
                        f.setData(fishData);
                        f.setTitle("捕鱼");
                        walletList.add(f);
                    }
                    if (sportData.size() != 0) {
                        sportData.add(0,data);
                        WalletBean s = new WalletBean();
                        s.setData(sportData);
                        s.setTitle("体育");
                        walletList.add(s);
                    }
                    for(int t = 0;t<walletList.size();t++){
                        tabLayout.addTab(tabLayout.newTab().setText(walletList.get(t).getTitle()));
                        mFragments.add(transFerListFrament = new TransFerListFrament(mContext,walletList.get(t).getData()));
                    }

                    replaceFragment(mFragments.get(0));
                    tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
                        @Override
                        public void onTabSelected(TabLayout.Tab tab) {
                            replaceFragment(mFragments.get(tab.getPosition()));
                        }

                        @Override
                        public void onTabUnselected(TabLayout.Tab tab) {

                        }

                        @Override
                        public void onTabReselected(TabLayout.Tab tab) {

                        }
                    });
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

    private void replaceFragment(Fragment fragment){
        getActivity().getSupportFragmentManager().beginTransaction().replace(R.id.fl_change,fragment).commit();
    }

}
