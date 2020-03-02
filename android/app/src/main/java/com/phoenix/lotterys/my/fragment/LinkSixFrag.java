package com.phoenix.lotterys.my.fragment;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.linkman.ClearEditText;
import com.phoenix.lotterys.linkman.PinyinComparator;
import com.phoenix.lotterys.linkman.PinyinUtils;
import com.phoenix.lotterys.linkman.SideBar;
import com.phoenix.lotterys.linkman.SortAdapter;
import com.phoenix.lotterys.my.bean.MailFragBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/19 14:34
 */
public class LinkSixFrag extends BaseFragment implements OnRefreshListener,
        OnLoadMoreListener{


    @BindView(R2.id.recyclerView)
    RecyclerView mRecyclerView;
    @BindView(R2.id.dialog)
    TextView dialog;
    @BindView(R2.id.filter_edit)
    ClearEditText mClearEditText;
    @BindView(R2.id.sideBar)
    SideBar sideBar;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.smart_refresh_layout)
    SmartRefreshLayout smartRefreshLayout;
    /**
     * 根据拼音来排列RecyclerView里面的数据类
     */
    private PinyinComparator pinyinComparator;
    private SortAdapter adapter;

    LinearLayoutManager manager;

    private List<MailFragBean.DataBean.ListBean> list =new ArrayList<>();

    public LinkSixFrag() {
        super(R.layout.link_six_frag, true, true);
    }

    @Override
    public void initView(View view) {
        Uiutils.setBarStye(titlebar, getActivity());
        titlebar.setText(getArguments().getString("name"));
        pinyinComparator = new PinyinComparator();

        sideBar.setTextView(dialog);

        smartRefreshLayout.setOnRefreshListener(this);
        smartRefreshLayout.setOnLoadMoreListener(this);
        smartRefreshLayout.setEnableLoadMore(false);
        smartRefreshLayout.setEnableRefresh(true);

        //设置右侧SideBar触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {

            @Override
            public void onTouchingLetterChanged(String s) {
                //该字母首次出现的位置
                int position = adapter.getPositionForSection(s.charAt(0));
                if (position != -1) {
                    manager.scrollToPositionWithOffset(position, 0);
                }

            }
        });

//        list = filledData(getResources().getStringArray(R.array.date_six));

        // 根据a-z进行排序源数据

        //RecyclerView社置manager
        manager = new LinearLayoutManager(getContext());
        manager.setOrientation(LinearLayoutManager.VERTICAL);
        mRecyclerView.setLayoutManager(manager);
        adapter = new SortAdapter(getContext(), list);
        mRecyclerView.setAdapter(adapter);
        //item点击事件
        /*adapter.setOnItemClickListener(new SortAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                Toast.makeText(MainActivity.this, ((SortModel)adapter.getItem(position)).getName(),Toast.LENGTH_SHORT).show();
            }
        });*/

        //根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                //当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {

            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        getLiuHe(true);
    }


    private MailFragBean mailFragBean;
    private int page = 1;
    private int rows = 1000;

    private void getLiuHe(boolean b) {
        Map<String, Object> map = new HashMap<>();
//        if (type == 12)
            map.put("showFav", "0");
//        if (type == 13)
//            map.put("showFav", "1");

        map.put("page", page + "");
        map.put("rows", rows + "");
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.TKLIST, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishRefresh();
                    smartRefreshLayout.finishLoadMore();
                }
                mailFragBean = Uiutils.stringToObject(object, MailFragBean.class);

                if (null != mailFragBean && null != mailFragBean.getData() && null != mailFragBean.getData()
                        .getList()) {

                    if (page == 1)
                        list.clear();

                    if (mailFragBean.getData().getList().size() > 0) {
                        list.addAll(mailFragBean.getData().getList());
                    }

                    if (list.size()>0){
                        filledData();
                        Collections.sort(list, pinyinComparator);
                    }

                    if (null != adapter)
                        adapter.notifyDataSetChanged();

                    if (list.size() == mailFragBean.getData().getTotal()) {
                        smartRefreshLayout.setEnableLoadMore(false);
                    } else {
                        smartRefreshLayout.setEnableLoadMore(true);
                    }

                } else {
                    smartRefreshLayout.setEnableLoadMore(false);
                }

                if (null != mailFragBean && null != mailFragBean.getData() && null != mailFragBean.getData()
                        .getHotList()&&mailFragBean.getData().getHotList().size()>0) {
                    if (page==1){
                        list.addAll(0,mailFragBean.getData().getHotList());
                    }
                }

//                if (list.size() == 0) {
//                    emptyLin.setVisibility(View.VISIBLE);
//                } else {
//                    emptyLin.setVisibility(View.GONE);
//                }

            }

            @Override
            public void onError() {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishRefresh();
                    smartRefreshLayout.finishLoadMore();
                }
            }
        });
    }


    /**
     * 为RecyclerView填充数据
     *
     * @return
     */
    private void filledData() {
        for (int i = 0; i < list.size(); i++) {
            //汉字转换成拼音
            String pinyin = PinyinUtils.getPingYin(list.get(i).getName());
            String sortString = pinyin.substring(0, 1).toUpperCase();

            // 正则表达式，判断首字母是否是英文字母
            if (sortString.matches("[A-Z]")) {
                list.get(i).setLetters(sortString.toUpperCase());
            } else {
                list.get(i).setLetters("#");
            }
        }
    }


    /**
     * 根据输入框中的值来过滤数据并更新RecyclerView
     *
     * @param filterStr
     */
    private void filterData(String filterStr) {
        List<MailFragBean.DataBean.ListBean> filterDateList = new ArrayList<>();

        if (TextUtils.isEmpty(filterStr)) {
            filterDateList = list;
        } else {
//            filterDateList.clear();
            for (MailFragBean.DataBean.ListBean sortModel : list) {
                String name = sortModel.getName();
                String alias = sortModel.getAlias();
                if ((!StringUtils.isEmpty(name)&&name.contains(filterStr))||
                        (!StringUtils.isEmpty(alias)&&alias.contains(filterStr))) {
                    filterDateList.add(sortModel);
                }
            }
        }

        // 根据a-z进行排序
        Collections.sort(filterDateList, pinyinComparator);
        adapter.updateList(filterDateList);
    }


    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        getLiuHe(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page=1;
        getLiuHe(false);
    }
}
