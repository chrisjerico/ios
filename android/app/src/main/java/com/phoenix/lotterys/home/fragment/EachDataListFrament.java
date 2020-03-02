package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.adapter.EachDataAdapter;
import com.phoenix.lotterys.home.bean.BuyContent;
import com.phoenix.lotterys.home.bean.ForumBean;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.activity.LoginActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ToastUtils;
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
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/12/1
 */

//每期资料
@SuppressLint("ValidFragment")
public class EachDataListFrament extends BaseFragments {

    String title, alias;
    int page = 1;
    EachDataAdapter mAdapter;
    @BindView(R2.id.rv_record)
    RecyclerView rvRecord;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.ll_data)
    LinearLayout llData;
    @BindView(R2.id.tv_back)
    TextView tvBack;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;

    private List<ForumBean.DataBean.ListBean> list = new ArrayList<>();

    @SuppressLint("ValidFragment")
    public EachDataListFrament(String title) {
        super(R.layout.fragment_eachdata_list);
        this.title = title;
    }

    public static EachDataListFrament getInstance(String title, String alias) {
        EachDataListFrament sf = new EachDataListFrament(title);
        sf.title = title;
        sf.alias = alias;
        return sf;
    }

    @Override
    public void initView(View view) {
        tvTitle.setText(title);
        getDeposit();
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
        mAdapter = new EachDataAdapter(list, getContext());
        rvRecord.setAdapter(mAdapter);
        if (rvRecord.getItemDecorationCount() == 0) {
            rvRecord.setLayoutManager(new LinearLayoutManager(getContext()));
            rvRecord.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(217 ,217, 217)));
        }

        mAdapter.setListener(new EachDataAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {

            }
            @Override
            public void onClickItemListener(View view, int position) {
//                FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance(list.get(position).getTitle()==null?"":list.get(position).getTitle(),
//                        list.get(position).getCid() == null ? "" : list.get(position).getCid(),alias==null?"":alias));
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (!TextUtils.isEmpty(list.get(position).getPrice())) {
                    double pay = Double.parseDouble(list.get(position).getPrice());
                    if (pay > 0) {
                        if (list.get(position).getHasPay() != null && list.get(position).getHasPay().equals("1")) {
                            FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance(list.get(position).getTitle() == null ? "" : list.get(position).getTitle(),
                                    list.get(position).getCid() == null ? "" : list.get(position).getCid(),alias==null?"":alias));
                        } else {
                            String token = SPConstants.getToken(getContext());
                            if (TextUtils.isEmpty(token)) {
                                loginDialog();
                                return;
                            }
                            if (Uiutils.isTourist1(getContext())) {
                                loginDialog();
                                return;
                            }
                            if (list != null && list.size() > 0) {
                                if (list.get(position).getHasPay() != null) {
                                    if (list.get(position).getHasPay().equals("0")) {
                                        bbsDialog(list.get(position).getTitle() == null ? "" : list.get(position).getTitle(), pay + "",
                                                list.get(position).getCid() == null ? "" : list.get(position).getCid(), position);
                                        return;
                                    }
                                }
                            }
                        }
                    } else {
                        FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance(list.get(position).getTitle() == null ? "" : list.get(position).getTitle(),
                                list.get(position).getCid() == null ? "" : list.get(position).getCid(),alias==null?"":alias));
                        return;
                    }
                }
            }
        });

        Uiutils.setBarStye0(titlebar,getActivity());
    }

    private void bbsDialog(String title, String pay, String id, int pos) {
        String[] array = getResources().getStringArray(R.array.affirm_change);
        View inflate;
        inflate = LayoutInflater.from(getActivity()).inflate(R.layout.alertext_better, null);
        TextView tvContent = (TextView) inflate.findViewById(R.id.tv_content);
        tvContent.setText("打赏" + pay + "元");
        TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, title,
                "", ""
                , new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int pos) {
                if (pos == 1) {
                    postContent(title,id, pos);
                }
            }
        });
        mTDialog.setMsgGravity(Gravity.CENTER);
        mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
        mTDialog.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
        mTDialog.addView(inflate);
        mTDialog.show();
    }

    private void postContent(String title,String id, int pos) {
        String token = SPConstants.checkLoginInfo(getContext());
        if (TextUtils.isEmpty(token)) {
            return;
        }
        BuyContent content = new BuyContent();
        if (Constants.ENCRYPT)
            content.setSign(SecretUtils.RsaToken());
        content.setToken(SecretUtils.DESede(token));
        content.setCid(SecretUtils.DESede(id));
        Gson gson = new Gson();
        String json = gson.toJson(content);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.BUYCONTENT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getContext(), true, getActivity(),
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        if (li != null && li.getCode() == 0) {
                            ToastUtils.ToastUtils(li.getMsg(), getContext());
                            list.get(pos).setHasPay("1");
                            FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance(title, id,alias==null?"":alias));
                        } else if (li != null && li.getCode() != 0 && li.getMsg() != null) {
                            ToastUtils.ToastUtils(li.getMsg(), getContext());
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        if (bb != null && bb.getExtra() != null && !bb.getExtra().isHasNickname()) {

                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }


    private void loginDialog() {
        String title = getResources().getString(R.string.lhc_bbs_hint);
        String content = getResources().getString(R.string.lhc_bbs_needlogin);
        String[] array = new String[]{getResources().getString(R.string.cancel), getResources().getString(R.string.lhc_bbs_login)};
        TDialog mTDialog1 = new TDialog(getActivity(), TDialog.Style.Center, array, title, content, "", new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int position) {
                if(position==1){
                    startActivity(new Intent(getContext(), LoginActivity.class));
                }
            }
        });
        mTDialog1.setCancelable(false);
        mTDialog1.show();
    }

    @OnClick({R.id.tv_back})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_back:
                getActivity().finish();
                break;
        }
    }

    String url;
    //每期资料
    private void getDeposit() {
        String BETTER = "&token=%s&alias=%s&page=%s&rows=%s&sort=%s";
        String token = SPConstants.getToken(getContext());
        url = Constants.CONTENTLIST + String.format(BETTER, SecretUtils.DESede(token), SecretUtils.DESede(alias),
                SecretUtils.DESede(page + ""), SecretUtils.DESede("30"), SecretUtils.DESede("")) + "&sign=" + SecretUtils.RsaToken();
        if (TextUtils.isEmpty(url))
            return;
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, EachDataListFrament.this, true, ForumBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                ForumBean forum = (ForumBean) o;
                if (forum != null && forum.getCode() == 0 && forum.getData() != null && forum.getData().getList() != null) {
                    if (page == 1 && list != null)
                        list.clear();
//                    for(int i = 0;i<forum.getData().getList().size();i++){
//                        for (int t = 0; t < 175; t++) {
//                            String img = "<img src=\"file:///android_asset/emoji/" + (t + 1) + ".gif\">";
//                        if (temp != null) {
//                            data = temp;
//                        }
//                        temp = data.replaceAll("\\[em_" + (i + 1) + "" + "\\]", img);
//                    }
//                        list.add(forum.getData().getList().get(i));
//                    }


                    list.addAll(forum.getData().getList());
                    if (mAdapter != null) {
//                            mAdapter.setNoLoad(load);
                        mAdapter.notifyDataSetChanged();
                    }
                    if ((forum.getData().getList() == null || forum.getData().getList().size() == 0) && refreshLayout != null)
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法
                    if ((list == null || list.size() == 0) && llData != null) {
                        llData.setVisibility(View.VISIBLE);
                    } else if (llData != null) {
                        llData.setVisibility(View.GONE);
                    }
                } else {
                    if (llData != null)
                        llData.setVisibility(View.VISIBLE);
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

}
