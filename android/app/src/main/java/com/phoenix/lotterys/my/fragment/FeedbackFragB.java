package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.adapter.FeedbackAdapterB;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * 文件描述: 建议反馈
 * 创建者: IAN
 * 创建时间: 2019/7/3 16:26
 */
public class FeedbackFragB extends BaseFragments implements BaseRecyclerAdapter.OnItemClickListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.reddback_rec)
    RecyclerView reddbackRec;

    public FeedbackFragB() {
        super(R.layout.feedback_act_b, true, true);
    }

    @Override
    public void initView(View v ) {
        titlebar.setText(getResources().getString(R.string.recommendation_feedback));

        Uiutils.setBarStye(titlebar,getActivity());

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        reddbackRec.setLayoutManager(linearLayoutManager);
        reddbackRec.addItemDecoration(new SpacesItemDecoration(getContext(),1));

        List<String> list = new ArrayList<>();

        list.add(getResources().getString(R.string.recommendation_feedback_context1));
        list.add(getResources().getString(R.string.recommendation_feedback_context2));
        list.add(getResources().getString(R.string.recommendation_feedback_context3));
        list.add(getResources().getString(R.string.recommendation_feedback_context4));

        FeedbackAdapterB adapter = new FeedbackAdapterB(getContext(), list, R.layout.feedback_adapter_b);
        reddbackRec.setAdapter(adapter);

        adapter.setOnItemClickListener(this);
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
            switch (position){
                case 0:
                   String zxkfurl = SPConstants.getValue(getContext(), SPConstants.SP_ZXKFURL);
                    if (!TextUtils.isEmpty(zxkfurl)) {
                        Uiutils.goWebView(getContext(),zxkfurl.startsWith("http") ? zxkfurl : "http://" + zxkfurl
                                ,"在线客服");
                    } else {
                        ToastUtils.ToastUtils("客服地址未配置或获取失败", getContext());
                    }

                    break;
                case 1:
                    Bundle bundle =new Bundle();
                    bundle.putInt("type",1);
                    FragmentUtilAct.startAct(getActivity(),new EditFeedbackFragB(),bundle);
                    break;
                case 2:
                    Bundle bundle2 =new Bundle();
                    bundle2.putInt("type",2);
                    FragmentUtilAct.startAct(getActivity(),new EditFeedbackFragB(),bundle2);
                    break;
                case 3:
                    FragmentUtilAct.startAct(getActivity(),new FeedbackRecordFragB());
                    break;
            }
    }
}
