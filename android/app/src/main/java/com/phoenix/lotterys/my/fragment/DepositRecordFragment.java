package com.phoenix.lotterys.my.fragment;

import android.graphics.Color;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.DepositWithdrawalsAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.DepositBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by Luke
 * on 2019/6/28
 */
public class DepositRecordFragment extends BaseFragments {
    String title;
    @BindView(R2.id.tv_titledate)
    TextView tvTitledate;
    @BindView(R2.id.tv_titlemoney)
    TextView tvTitlemoney;
    @BindView(R2.id.tv_titletype)
    TextView tvTitletype;
    @BindView(R2.id.tv_titlestate)
    TextView tvTitlestate;

    @BindView(R2.id.card)
    CardView card;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    @BindView(R2.id.rl_status)
    RelativeLayout rlStatus;
    @BindView(R2.id.rv_record)
    RecyclerView rvRecord;
    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    int page = 1;
    int rows = 20;
    String url;
    String startDate = Uiutils.getFetureDate(-1000);
    String endDate = Uiutils.getFetureDate(0);
    private List<DepositBean.DataBean.ListBean> list = new ArrayList<>();
    private  String DEPOSIT = "?c=recharge&a=logs&token=%s&startDate=%s&endDate=%s&page=%s&rows=%s";   //存款记录
    private  String DRAW = "?c=withdraw&a=logs&token=%s&startDate=%s&endDate=%s&page=%s&rows=%s";   //提款记录
    private DepositWithdrawalsAdapter mAdapter;

    public DepositRecordFragment() {
        super(R.layout.fragment_deposit_record);
    }
    public static DepositRecordFragment getInstance(String title) {
        DepositRecordFragment sf = new DepositRecordFragment();
        sf.title = title;
        return sf;
    }

    @Override
    public void initView(View view) {
        if(!TextUtils.isEmpty(title)){
            rlStatus.setVisibility(title.equals("存款记录")?View.VISIBLE:View.GONE);
        }
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
                    refreshLayout.finishLoadMore(1000);      //加载完成

                    page++;
                    getDeposit();
                }
            });
        }
        mAdapter = new DepositWithdrawalsAdapter(list, getContext(),title);
        rvRecord.setAdapter(mAdapter);
        if (rvRecord.getItemDecorationCount() == 0) {
            rvRecord.setLayoutManager(new LinearLayoutManager(getContext()));
            rvRecord.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(200, 200, 200)));
        }
        mAdapter.setListener(new DepositWithdrawalsAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if(list!=null||list.size()!=0) {
                    DepositBean.DataBean.ListBean dp = list.get(position);
                    String text = null;
                    if(title.equals("存款记录")){
                        text = "交易编号：" + dp.getOrderNo() + "\n" + "发起时间：" + dp.getApplyTime() + "\n" + "交易类型：" + (TextUtils.isEmpty(dp.getCategory())?"--":dp.getCategory()) + "\n" + "交易金额："
                                + dp.getAmount() + "\n" + "交易状态：" + dp.getStatus() + "\n" + "存款人：" + dp.getUsername()+"\n" + "存款时间：" + dp.getArriveTime() + "\n" + "备注：" + dp.getRemark();
                    }else if(title.equals("取款记录")){
                        text = "交易编号：" + dp.getOrderNo() + "\n" + "发起时间：" + dp.getApplyTime() + "\n" + "到账时间：" + dp.getArriveTime() +"\n" + "交易类型：" + "提现" +  "\n" + "交易金额："
                                + dp.getAmount() + "\n" + "手续费用：" + dp.getFee()+"\n" + "交易状态：" + dp.getStatus() +"\n" + "提现银行：" + dp.getBankName() + "\n" +"提款卡号：" + dp.getBankCard()+ "\n" + "持卡人："+dp.getBankAccount() ;
                    }
                    View inflate = LayoutInflater.from(getContext()).inflate(R.layout.alertext, null);
                    TextView tvText = (TextView) inflate.findViewById(R.id.tv_text);
                    String[] array = {getResources().getString(R.string.affirm)};
                    if(text!=null)
                    tvText.setText(text);
                    TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, getResources().getString(R.string.view_details), "", "", new TDialog.onItemClickListener() {
                        @Override
                        public void onItemClick(Object object, int position) {

                        }
                    });
                    mTDialog.setMsgGravity(Gravity.CENTER);
                    mTDialog.setMsgPaddingLeft(10, 5, 10, 0);

                    mTDialog.addView(inflate);

                    ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
                    if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
                        if (config.getData().getMobileTemplateCategory().equals("5")) {
                            mTDialog.setTitleTextBackgroupColor(R.drawable.blackbg_center);
                            mTDialog.setItemTextColor(getResources().getColor(R.color.white));
                            mTDialog.setTitleTextColor(getResources().getColor(R.color.white));
                            tvText.setTextColor(getResources().getColor(R.color.white));
//                            tvText.setTextColor();
                        }else {
                            mTDialog.setItemTextColorAt(0,
                                    getResources().getColor( ShareUtils.getInt(getContext(),
                                            "ba_top",R.color.textColor_alert_button_cancel)));
                        }
                    }else {
                        mTDialog.setItemTextColorAt(0,
                                getResources().getColor( ShareUtils.getInt(getContext(),
                                        "ba_top",R.color.textColor_alert_button_cancel)));
                    }


                    mTDialog.show();
                }
            }
        });
        getDeposit();
        setTheme();
    }

    private void setTheme() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
            if (config.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(getContext(), card, false, null);
                Uiutils.setBaColor(getContext(), rlMain);
                tvTitledate.setTextColor(getResources().getColor(R.color.font));
                tvTitlemoney.setTextColor(getResources().getColor(R.color.font));
                tvTitletype.setTextColor(getResources().getColor(R.color.font));
                tvData.setTextColor(getResources().getColor(R.color.font));
                tvTitlestate.setTextColor(getResources().getColor(R.color.white));

            }
        }
    }

    private void getDeposit() {
       
        String token = SPConstants.checkLoginInfo(getContext());
        if (!TextUtils.isEmpty(title) && title.equals("存款记录")) {
            url = Constants.DEPOSITRECORD + String.format(DEPOSIT, SecretUtils.DESede(token), SecretUtils.DESede(startDate), SecretUtils.DESede(endDate), SecretUtils.DESede(page+""), SecretUtils.DESede(rows+""))+"&sign="+SecretUtils.RsaToken();
        } else if (!TextUtils.isEmpty(title) && title.equals("取款记录")) {
            url = Constants.DRAWRECORD + String.format(DRAW, SecretUtils.DESede(token), SecretUtils.DESede(startDate), SecretUtils.DESede(endDate), SecretUtils.DESede(page+""), SecretUtils.DESede(rows+""))+"&sign="+SecretUtils.RsaToken();
        }
        if(TextUtils.isEmpty(url))
            return;
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, DepositRecordFragment.this, true, DepositBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                DepositBean db = (DepositBean) o;
                if (db != null && db.getCode()==0&&db.getData()!=null&&db.getData().getList()!=null) {
                    if (page == 1&&list!=null)
                        list.clear();
                    list.addAll(db.getData().getList());
                    if(mAdapter!=null)
                    mAdapter.notifyDataSetChanged();

                    if((db.getData().getList()==null||db.getData().getList().size()==0)&&refreshLayout!=null)
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法

                    if((list==null||list.size()==0)&&tvData!=null){
                        tvData.setVisibility(View.VISIBLE);
                    }else if(tvData!=null){
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
    public void onDestroy() {
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }

}
