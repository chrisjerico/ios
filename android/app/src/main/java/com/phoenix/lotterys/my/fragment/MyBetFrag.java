package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.just.agentweb.LogUtils;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.adapter.MyBetAdapter;
import com.phoenix.lotterys.my.bean.MyBetBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 我的投注（长龙）
 * 创建者: IAN
 * 创建时间: 2019/7/8 15:39
 */
public class MyBetFrag extends BaseFragments implements BaseRecyclerAdapter.OnItemClickListener {
    @BindView(R2.id.my_bet_rec)
    RecyclerView myBetRec;

    private MyBetAdapter adapter;

    private List<MyBetBean.DataBean> list = new ArrayList<>();

    public MyBetFrag() {
        super(R.layout.my_bet_frag, true, true);
    }
    public static MyBetFrag getInstance() {
        MyBetFrag sf = new MyBetFrag();
        return sf;
    }
    @Override
    public void initView(View view) {


        Uiutils.setRec(getContext(), myBetRec, 1);
        adapter = new MyBetAdapter(getContext(), list, R.layout.my_bet_adapter);
        myBetRec.setAdapter(adapter);

        adapter.setOnItemClickListener(this);
        getData();
    }


    @Override
    public void setUserVisibleHint(boolean hidden) {
        super.setUserVisibleHint(hidden);

        if (hidden) {
            getData();
            //不在最前端显示
            LogUtils.e("aa","--------Fragment 不在最前端显示");
        } else {
            //重新显示到最前端
            LogUtils.e("bb","--------Fragment 重新显示到最前端" );
        }

    }

    private MyBetBean myBetBean ;
    private void getData() {
        Map<String,Object> map =new HashMap<>();
        map.put("token",Uiutils.getToken(getContext()));
        map.put("tag","1");

        NetUtils.get(Constants.GETUSERRECENTBET ,map, true, getContext()
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {

                        myBetBean = GsonUtil.fromJson(object, MyBetBean.class);

                        if (list.size()>0)
                            list.clear();

                        if (null != myBetBean && null != myBetBean.getData()
                                &&myBetBean.getData().size()
                                >0) {
                            list.addAll(myBetBean.getData());
                        }
                        adapter.notifyDataSetChanged();
                    }

                    @Override
                    public void onError() {

                    }
                });


    }

    @OnClick(R.id.see_more)
    public void onClick() {
        if (Uiutils.isTourist(getActivity()))
            return;

        Bundle bundle = new Bundle();
        bundle.putInt("type", 1);
        FragmentUtilAct.startAct(getActivity(),new NoteRecordFrag(),bundle);
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        Bundle bundle =new Bundle();
        bundle.putString("id",list.get(position).getId());
        FragmentUtilAct.startAct(getActivity(),new NoteDetailsFrag(),bundle);
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode())
        {
            case EvenBusCode.LONG_SINGLE_INJECTION:
                getData();
                break;
        }
    }
}
