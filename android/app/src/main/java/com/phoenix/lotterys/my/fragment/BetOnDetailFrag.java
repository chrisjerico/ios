package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.adapter.NoteRecordAdapter;
import com.phoenix.lotterys.my.bean.NoteRecordBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/11/19 19:47
 */
public class BetOnDetailFrag extends BaseFragment implements BaseRecyclerAdapter.
        OnItemClickListener, OnRefreshListener, OnLoadMoreListener{

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.vip_tex)
    TextView vipTex;
    @BindView(R2.id.vip_lin)
    RelativeLayout vipLin;
    @BindView(R2.id.name_text1)
    TextView nameText1;
    @BindView(R2.id.name_tex)
    TextView nameTex;
    @BindView(R2.id.name_tex_lin)
    TextView nameTexLin;
    @BindView(R2.id.happiness_tex)
    TextView happinessTex;
    @BindView(R2.id.happiness_tex0)
    TextView happinessTex0;
    @BindView(R2.id.happiness_tex_lin)
    TextView happinessTexLin;
    @BindView(R2.id.happy_balance_tex)
    TextView happyBalanceTex;
    @BindView(R2.id.happy_balance_tex_lin)
    TextView happyBalanceTexLin;
    @BindView(R2.id.full_date_tex)
    TextView fullDateTex;
    @BindView(R2.id.full_date_lin)
    LinearLayout fullDateLin;
    @BindView(R2.id.happiness_tex_lin5)
    TextView happinessTexLin5;
    @BindView(R2.id.happiness_tex_5)
    TextView happinessTex5;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.note_record_rec)
    RecyclerView noteRecordRec;
    @BindView(R2.id.no_more_records_tex)
    TextView noMoreRecordsTex;
    @BindView(R2.id.note_record_refresh)
    SmartRefreshLayout noteRecordRefresh;
    @BindView(R2.id.total_money_tex)
    TextView totalMoneyTex;
    @BindView(R2.id.win_lose_tex)
    TextView winLoseTex;
    @BindView(R2.id.win_lose_lin)
    LinearLayout winLoseLin;

    public BetOnDetailFrag() {
        super(R.layout.bet_on_detai_frag, true, true);
    }

    private int type ;
    private NoteRecordAdapter adapter;
    private List<NoteRecordBean.DataBean.ListBean> list = new ArrayList<>();

    @Override
    public void initView(View view) {
        type =getArguments().getInt("type");

        Uiutils.setBarStye(titlebar, getActivity());
        titlebar.setRIghtImg(R.drawable.calendar_white, View.GONE);

        nameTexLin.setVisibility(View.GONE);
        happinessTexLin.setVisibility(View.GONE);
        happyBalanceTexLin.setVisibility(View.GONE);
        fullDateLin.setVisibility(View.GONE);
        happinessTex5.setVisibility(View.VISIBLE);
        switch (type){
            case 1:
                titlebar.setText("下注明细");
                nameTex.setText("彩种");
                happinessTex.setText("笔数");
                happyBalanceTex.setText("下注金额");
                happinessTex5.setText("输赢");
                break;
            case 2:
                titlebar.setText("下注明细(已结算)");
                nameTex.setText("期号/注单号");
                happinessTex.setText("下注明细");
                happyBalanceTex.setText("下注金额");
                happinessTex5.setText("输赢");
                break;
        }

        Uiutils.setRec(getContext(), noteRecordRec, 0);

        adapter = new NoteRecordAdapter(getContext(), list, R.layout.note_record_adapter, 5);
        noteRecordRec.setAdapter(adapter);
        adapter.setOnItemClickListener(this);

        noteRecordRefresh.setEnableLoadMore(false);
        noteRecordRefresh.setEnableRefresh(true);
        noteRecordRefresh.setOnRefreshListener(this);
        noteRecordRefresh.setOnLoadMoreListener(this);

        getData();
    }
    private NoteRecordBean noteRecordBean;
    private void getData() {
        Map<String, Object> map = new HashMap<>();
        map.put("page", 1 + "");
        map.put("rows", 20 + "");
        map.put("category", "lottery");

            map.put("status", 3 + "");
            map.put("startDate",Uiutils.getFetureDate(-30));
            map.put("endDate", Uiutils.getFetureDate(0));

        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.HISTORY, map, true, getContext()
//                NetUtils.get("http://test100f.fhptcdn.com/wjapp/api.php/?c=ticket&a=history&status=3&category=fish&startDate=2019-07-23&endDate=2019-07-23&token=Dsre0fsrHHuShPR664cWf0hZ",
//                        isShow, getContext()
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        noteRecordRefresh.finishLoadMore();
                        noteRecordRefresh.finishRefresh();


                        if (!StringUtils.isEmpty(object)) {
                            noteRecordBean = GsonUtil.fromJson(object, NoteRecordBean.class);
                        }

                        if (null != noteRecordBean && null != noteRecordBean.getData() &&
                                null != noteRecordBean.getData().getList() && noteRecordBean.getData()
                                .getList().size() > 0) {
                            list.addAll(noteRecordBean.getData()
                                    .getList());
                        }

                        if (null != noteRecordBean && null != noteRecordBean.getData() && !StringUtils
                                .isEmpty(noteRecordBean.getData().getTotal_money()) &&
                                Double.parseDouble(noteRecordBean.getData().getTotal_money()) > 0) {
                            totalMoneyTex.setText(Uiutils.getTwo(noteRecordBean.getData().getTotal_money()) +
                                    getContext().getResources().getString(R.string.element));
                        } else {
                            totalMoneyTex.setText("0.00" +
                                    getContext().getResources().getString(R.string.element));
                        }

                        if (null != noteRecordBean && null != noteRecordBean.getData() &&
                                list.size() == noteRecordBean.getData().getTotal()) {
                            noteRecordRefresh.setEnableLoadMore(false);
                        } else {
                            noteRecordRefresh.setEnableLoadMore(true);
                        }

                        if (null != noteRecordBean && null != noteRecordBean.getData() && !StringUtils.isEmpty(
                                noteRecordBean.getData().getSettleAmount()
                        )) {
                            double win_lose = Double.parseDouble(noteRecordBean.getData().getSettleAmount());
                                if (win_lose > 0) {
                                    winLoseTex.setTextColor(getResources().getColor(R.color.color_white));
                                    winLoseTex.setText("+" + Uiutils.getTwo(noteRecordBean.getData().getSettleAmount()) +
                                            getContext().getResources().getString(R.string.element));
                                } else if (win_lose == 0) {
                                    winLoseTex.setTextColor(getResources().getColor(R.color.color_white));
                                    winLoseTex.setText(
                                            getContext().getResources().getString(R.string.not_amount));
                                } else {
                                    winLoseTex.setTextColor(getResources().getColor(R.color.color_008000));
                                    winLoseTex.setText(Uiutils.getTwo(noteRecordBean.getData().getSettleAmount()) +
                                            getContext().getResources().getString(R.string.element));
                                }
                        }
                        adapter.notifyDataSetChanged();

                        if (type==2){
                            noMoreRecordsTex.setVisibility(View.VISIBLE);
                            noMoreRecordsTex.setText("没有更多记录");
                        }else {
                            noMoreRecordsTex.setVisibility(View.GONE);
                            noMoreRecordsTex.setText("没有更多记录");
                        }
                    }

                    @Override
                    public void onError() {
                        noteRecordRefresh.finishLoadMore();
                        noteRecordRefresh.finishRefresh();
                    }
                });

    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        if (type==1) {
            Bundle bundle =new Bundle();
            bundle.putInt("type",2);
            FragmentUtilAct.startAct(getActivity(), new BetOnDetailFrag(),bundle);
        }
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {

    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        getData();
    }
}
