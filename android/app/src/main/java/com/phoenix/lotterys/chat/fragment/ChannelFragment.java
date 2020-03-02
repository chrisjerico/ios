package com.phoenix.lotterys.chat.fragment;

import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.chat.adapter.ChannelAdapter;
import com.phoenix.lotterys.chat.bean.ChannelBean;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Greated by Luke
 * on 2019/7/11
 */
public class ChannelFragment extends BaseFragments {
    @BindView(R2.id.rv_channel_type)
    RecyclerView rvChannelType;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    ChannelAdapter mAdapter;
    public ChannelFragment() {
        super(R.layout.channelfragment);
    }

    public static ChannelFragment getInstance() {
        return new ChannelFragment();
    }

    @Override
    public void initView(View view) {
        List<ChannelBean> cb = new ArrayList<>();
        List<ChannelBean.DataBean> db = new ArrayList<>();
        db.add(new ChannelBean.DataBean("牛牛红包"));
        db.add(new ChannelBean.DataBean("扫雷红包"));

        cb.add(new ChannelBean("抢红包",true,db));
        cb.add(new ChannelBean("北京赛车",false,null));
        cb.add(new ChannelBean("香港六合彩",true,null));
        cb.add(new ChannelBean("重庆六合彩",true,null));
        cb.add(new ChannelBean("11选5",true,null));
        mAdapter = new ChannelAdapter(cb, getContext());
        LinearLayoutManager layoutManager = new LinearLayoutManager(getContext());
        rvChannelType.setItemAnimator(new DefaultItemAnimator());
        rvChannelType.addItemDecoration(new SpacesItemDecoration(getContext()));
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvChannelType.setLayoutManager(layoutManager);
        rvChannelType.setAdapter(mAdapter);
        mAdapter.setListener(new ChannelAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if(cb.get(position).getOpen()){
                    cb.get(position).setOpen(false);
                }else {
                    cb.get(position).setOpen(true);
                }
                mAdapter.notifyDataSetChanged();
            }
        });
    }

}
