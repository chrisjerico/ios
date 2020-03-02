package com.phoenix.lotterys.my.activity;

import android.graphics.Color;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.ReportingRecordAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.TransFerLogsBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Greated by Luke
 * on 2019/8/24
 */
//利息宝 转入转出记录
public class ReportingRecordActivity extends BaseActivity {
    @BindView(R2.id.ll_titlereport)
    LinearLayout llTitlereport;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.rv_record)
    RecyclerView rvRecord;
    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;

    @BindView(R2.id.tv_titleblance)
    TextView tvTitleblance;
    @BindView(R2.id.tv_titlemoney)
    TextView tvTitlemoney;
    @BindView(R2.id.tv_titletype)
    TextView tvTitletype;
    @BindView(R2.id.tv_titletime)
    TextView tvTitletime;
    int page = 1;
    int rows = 20;
    String startDate = Uiutils.getFetureDate(-1000);
    String endDate = Uiutils.getFetureDate(0);

    private List<TransFerLogsBean.DataBean.ListBean> list = new ArrayList<>();
    private ReportingRecordAdapter mAdapter;

    public ReportingRecordActivity() {
        super(R.layout.activity_reportingrecord);
    }

    public void getIntentData() {
    }

    @Override
    public void initView() {
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        if (refreshLayout != null) {
            refreshLayout.setOnRefreshListener(new OnRefreshListener() {
                @Override
                public void onRefresh(RefreshLayout refreshLayout) {
                    refreshLayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                    page = 1;
                    getDeposit();
                }
            });
            refreshLayout.setOnLoadMoreListener(new OnLoadMoreListener() {
                @Override
                public void onLoadMore(RefreshLayout refreshLayout) {
                    refreshLayout.finishLoadMore();      //加载完成

                    page++;
                    getDeposit();
                }
            });
        }
        mAdapter = new ReportingRecordAdapter(list,ReportingRecordActivity.this );
        rvRecord.setAdapter(mAdapter);
        if (rvRecord.getItemDecorationCount() == 0) {
            rvRecord.setLayoutManager(new LinearLayoutManager(ReportingRecordActivity.this));
            rvRecord.addItemDecoration(new DividerGridItemDecoration(ReportingRecordActivity.this,
                    DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(200, 200, 200)));
        }
        getDeposit();
        setMtheme();

        Uiutils.setBarStye0(titlebar,this);
    }
    private void setMtheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(ReportingRecordActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(InterestDoteyActivity.this, btSubpw, false, null);
                Uiutils.setBaColor(ReportingRecordActivity.this, rlMain);
                Uiutils.setBaColor(ReportingRecordActivity.this, llTitlereport);

                tvTitleblance.setTextColor(getResources().getColor(R.color.white));
                tvTitlemoney.setTextColor(getResources().getColor(R.color.white));
                tvTitletype.setTextColor(getResources().getColor(R.color.white));
                tvTitletime.setTextColor(getResources().getColor(R.color.white));
            }
        }

    }
    private void getDeposit() {
        String token = SPConstants.checkLoginInfo(ReportingRecordActivity.this);
        String reportingrecord = "?c=yuebao&a=transferLogs&token=%s&page=%s&rows=%s&startTime=%s&endTime=%s";
        String  url = Constants.BaseUrl()+Constants.TRANSFERLOGS + String.format(reportingrecord, SecretUtils.DESede(token), SecretUtils.DESede(page+""),SecretUtils.DESede(rows+""),SecretUtils.DESede(startDate+" 00:00:00"), SecretUtils.DESede(endDate+" 23:59:59")+"&sign="+SecretUtils.RsaToken());
        OkGo.<String>get(URLDecoder.decode(url)).tag(this).execute(new NetDialogCallBack(ReportingRecordActivity.this, true, ReportingRecordActivity.this, true, TransFerLogsBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                TransFerLogsBean db = (TransFerLogsBean) o;
                if (db != null && db.getCode()==0&&db.getData()!=null&&db.getData().getList()!=null) {
                    if (page == 1)
                        list.clear();
                    list.addAll(db.getData().getList());
                    mAdapter.notifyDataSetChanged();
                    if(db.getData().getList()==null||db.getData().getList().size()==0)
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法

                    if(list==null||list.size()==0){
                        tvData.setVisibility(View.VISIBLE);
                    }else {
                        tvData.setVisibility(View.GONE);
                    }
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OkGo.getInstance().cancelAll();
    }
}
