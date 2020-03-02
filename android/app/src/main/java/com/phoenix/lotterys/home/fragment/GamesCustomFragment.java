package com.phoenix.lotterys.home.fragment;


import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.adapter.LotteryticketCustomAdapter;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.SignViewPager;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import butterknife.BindView;

/**
 * 彩票.
 */
@SuppressLint("ValidFragment")
public class GamesCustomFragment extends BaseFragment {

    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;
    LotteryticketCustomAdapter lotteryticketAdapter;
    SignViewPager signViewPager;
    SharedPreferences sp;
    HomeGame.DataBean.IconsBean game;
    int pos;   //-1是浏览记录
    private String themeColor ;
String category = "";
    public void setSignViewPager(SignViewPager signViewPager) {
        this.signViewPager = signViewPager;

    }

    public GamesCustomFragment(HomeGame.DataBean.IconsBean game, int pos) {
        super(R.layout.fragment_lottery_ticket,true,true);
        this.game = game;
        this.pos = pos;
    }

    @Override
    public void initView(View view) {
//        mActivity = (MainActivity) getActivity();
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            category =  config.getData().getMobileTemplateCategory();
        }
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        if (signViewPager != null) {
            signViewPager.setObjectForPosition(view, pos);
            initRecyclerView();
        }
        if(pos == -1){
            initRecyclerView();
        }
    }

    private void initRecyclerView() {
        backgroupColor();
        if (game == null) {
            return;
        }
        lotteryticketAdapter = new LotteryticketCustomAdapter(game, getContext(), themeColor,pos,category);
        if(!category.equals("9")){
            rvTicket.setLayoutManager(new GridLayoutManager(getActivity(), 1));
            rvTicket.addItemDecoration(new DividerGridItemDecoration(getActivity(),
            DividerGridItemDecoration.BOTH_SET, 10,  0));
        }
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvTicket.setLayoutManager(layoutManager);
        rvTicket.setAdapter(lotteryticketAdapter);
        setLter();
    }

    private void setLter() {
        lotteryticketAdapter.setListener(new LotteryticketCustomAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                String token = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
                if (!token.equals(SPConstants.SP_NULL)) {
                } else {
//                    startActivity(new Intent(getContext(), LoginActivity.class));
                    Uiutils.login(getContext());
                }
            }
        });
    }

    private void backgroupColor() {
        if (ShareUtils.getInt(getContext(),"ba_top",0)==0)
            return;

        themeColor = Integer.toHexString(getResources().getColor(ShareUtils.getInt(getContext(),"ba_top",0)));
        if (themeColor.length()>7){
            themeColor ="#"+ themeColor.substring(2, themeColor.length());
        }else{
            themeColor ="#"+ themeColor;
        }
    }


    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:

                initRecyclerView();
                break;
        }
    }

}
