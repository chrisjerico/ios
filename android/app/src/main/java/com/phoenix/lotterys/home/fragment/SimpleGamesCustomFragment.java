package com.phoenix.lotterys.home.fragment;


import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.adapter.SimpleLotteryticketCustomAdapter;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.SignViewPager;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import butterknife.BindView;

/**
 * 彩票.  简约模板
 */
@SuppressLint("ValidFragment")
public class SimpleGamesCustomFragment extends BaseFragment {

    @BindView(R2.id.view)
    View view1;
    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;
    SimpleLotteryticketCustomAdapter lotteryticketAdapter;
    SignViewPager signViewPager;
    SharedPreferences sp;
    HomeGame.DataBean.IconsBean game;
    int pos;   //-1是浏览记录
    private String themeColor ;

    public void setSignViewPager(SignViewPager signViewPager) {
        this.signViewPager = signViewPager;

    }

    public SimpleGamesCustomFragment(HomeGame.DataBean.IconsBean game, int pos) {
        super(R.layout.fragment_lottery_ticket,true,true);
        this.game = game;
        this.pos = pos;
    }

    @Override
    public void initView(View view) {
//        mActivity = (MainActivity) getActivity();
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        if (signViewPager != null) {
            signViewPager.setObjectForPosition(view, pos);
            initRecyclerView();
        }

        view1.setVisibility(View.VISIBLE);
    }

    private void initRecyclerView() {
        backgroupColor();
        if (game == null) {
            return;
        }

        lotteryticketAdapter = new SimpleLotteryticketCustomAdapter(game, getContext(), themeColor,1);
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvTicket.setLayoutManager(layoutManager);
        rvTicket.setAdapter(lotteryticketAdapter);
        setLter();
    }

    private void setLter() {
        lotteryticketAdapter.setListener(new SimpleLotteryticketCustomAdapter.OnClickListener() {
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


//    @Override
//    public void getEvenMsg(Even even) {
//        switch (even.getCode()){
//            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
//                initRecyclerView();
//                break;
//        }
//    }

}
