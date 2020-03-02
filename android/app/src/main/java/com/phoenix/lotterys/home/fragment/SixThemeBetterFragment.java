package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.adapter.ForumAdapter;
import com.phoenix.lotterys.home.bean.BuyContent;
import com.phoenix.lotterys.home.bean.ForumBean;
import com.phoenix.lotterys.home.bean.PreiseBean;
import com.phoenix.lotterys.home.bean.SixThemeBbsDetailBean;
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
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * Created by Luke
 * on 2019/6/28
 */

//综合、精华帖、最新、搜索帖子、历史帖子
@SuppressLint("ValidFragment")
public class SixThemeBetterFragment extends BaseFragments {
    String title;

    @BindView(R2.id.ll_search)
    LinearLayout llsearch;
    @BindView(R2.id.et_search)
    EditText et_search;
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;
    @BindView(R2.id.tv_back)
    TextView tvBack;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.rl_main)
    RelativeLayout rlMain;
    @BindView(R2.id.rv_record)
    RecyclerView rvRecord;
    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    int page = 1;
    int rows = 30;
    String alias;
    String url;
    String search;
    private List<ForumBean.DataBean.ListBean> list = new ArrayList<>();
    private String BETTER = "&token=%s&alias=%s&page=%s&rows=%s&sort=%s";
    private ForumAdapter mAdapter;
    private List<String> emojiList = new ArrayList<>();
    boolean isShow = false;  //是否加载
    int isLoad = -1;  //重新加载哪个条目
    int loadPage;

    @SuppressLint("ValidFragment")
    public SixThemeBetterFragment(String title) {
        super(R.layout.fragment_sixtheme_better, true, true);
        this.title = title;
    }

    public static SixThemeBetterFragment getInstance(String title, String alias) {
        SixThemeBetterFragment sf = new SixThemeBetterFragment(title);
        sf.title = title;
        sf.alias = alias;
        return sf;
    }

    @Override
    public void onResume() {
        super.onResume();
        if (isShow) {
//            getDetail();
        }
    }

    @Override
    public void initView(View view) {
        Uiutils.setBarStye0(titlebar,getContext());
        Uiutils.setBarStye0(llsearch,getContext());

        if (title.equals("历史帖子")) {
            titlebar.setVisibility(View.VISIBLE);
            tvTitle.setText(title);
        } else if (title.equals("搜索帖子")) {
            titlebar.setVisibility(View.VISIBLE);
            tvTitle.setText(title);
            llsearch.setVisibility(View.VISIBLE);
            tvData.setVisibility(View.VISIBLE);
        } else {
            titlebar.setVisibility(View.GONE);
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
        mAdapter = new ForumAdapter(list, getContext());
        rvRecord.setAdapter(mAdapter);
        if (rvRecord.getItemDecorationCount() == 0) {
            rvRecord.setLayoutManager(new LinearLayoutManager(getContext()));
            rvRecord.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 20, Color.rgb(238, 238, 238)));
        }
        mAdapter.setListener(new ForumAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (list != null || list.size() != 0) {
                    if (list.get(position).getIsLike() != null) {
                        if (list.get(position).getIsLike().equals("1")) {
                            getpraise("0", "1", list.get(position).getCid() == null ? "" : list.get(position).getCid(), position);
                        } else if (list.get(position).getIsLike().equals("0")) {
                            getpraise("1", "1", list.get(position).getCid() == null ? "" : list.get(position).getCid(), position);
                        }
                    }
                }
            }

            @Override
            public void onClickItemListener(View view, int position) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (!TextUtils.isEmpty(list.get(position).getPrice())) {
                    double pay = Double.parseDouble(list.get(position).getPrice());
                    if (pay > 0) {
                        if (list.get(position).getHasPay() != null && list.get(position).getHasPay().equals("1")) {
                            isLoad = position;
                            FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance("论坛详情", list.get(position).getCid() == null ? "" : list.get(position).getCid(), alias == null ? "" : alias));
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
                                        bbsDialog(list.get(position).getTitle() == null ? "" : list.get(position).getTitle(), pay + "", list.get(position).getCid() == null ? "" : list.get(position).getCid(), position);
                                        return;
                                    }
                                }
                            }
                        }
                    } else {
                        isLoad = position;
                        FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance("论坛详情", list.get(position).getCid() == null ? "" : list.get(position).getCid(), alias == null ? "" : alias));
                        return;
                    }
                }
            }
        });
        getDeposit();
//        setTheme();
        for (int i = 0; i < 175; i++) {
            emojiList.add("[em_" + i + "]");
        }

        if (Uiutils.isTheme(getContext())){
            Uiutils.setBarStye0(titlebar,getActivity());
        }
    }

//    private void setTheme() {
//        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
//        if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
//            if (config.getData().getMobileTemplateCategory().equals("5")) {
//                Uiutils.setBaColor(getContext(), rlMain);
//                tvData.setTextColor(getResources().getColor(R.color.font));
//            }
//        }
//    }

    //高手论坛
    private void getDeposit() {
        String token = SPConstants.getToken(getContext());
        if (!TextUtils.isEmpty(title) && title.equals("综合")) {
            url = Constants.CONTENTLIST + String.format(BETTER, SecretUtils.DESede(token), SecretUtils.DESede(alias),
                    SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + ""), SecretUtils.DESede("")) + "&sign=" + SecretUtils.RsaToken();
        } else if (!TextUtils.isEmpty(title) && title.equals("精华帖")) {
            url = Constants.CONTENTLIST + String.format(BETTER, SecretUtils.DESede(token), SecretUtils.DESede(alias),
                    SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + ""), SecretUtils.DESede("hot")) + "&sign=" + SecretUtils.RsaToken();
        } else if (!TextUtils.isEmpty(title) && title.equals("最新")) {
            url = Constants.CONTENTLIST + String.format(BETTER, SecretUtils.DESede(token), SecretUtils.DESede(alias),
                    SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + ""), SecretUtils.DESede("new")) + "&sign=" + SecretUtils.RsaToken();
        } else if (!TextUtils.isEmpty(title) && title.equals("历史帖子")) {
            String history = "&token=%s&page=%s&rows=%s";
            url = Constants.HISTORYCONTENT + String.format(history, SecretUtils.DESede(token),
                    SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + "")) + "&sign=" + SecretUtils.RsaToken();
        } else if (!TextUtils.isEmpty(title) && title.equals("搜索帖子")) {
            if (TextUtils.isEmpty(search)) {
                return;
            }
            String history = "&token=%s&alias=%s&page=%s&rows=%s&content=%s";
            url = Constants.SEARCHCONTENT + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(alias),
                    SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + ""), SecretUtils.DESede(search)) + "&sign=" + SecretUtils.RsaToken();
        }
        if (TextUtils.isEmpty(url))
            return;
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), false, SixThemeBetterFragment.this, true, ForumBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                isShow = true;  //加载后为true，Resume 不会再次加载
                ForumBean forum = (ForumBean) o;
                if (forum != null && forum.getCode() == 0 && forum.getData() != null && forum.getData().getList() != null) {
                    if (page == 1 && list != null)
                        list.clear();
                    if ((forum.getData().getList() == null || forum.getData().getList().size() < 30) && refreshLayout != null) {
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法
                    }
//                    loadPage = page;
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
//                    if(isLoad==-1){
                    list.addAll(forum.getData().getList());
                    if (mAdapter != null) {
                        mAdapter.notifyDataSetChanged();
                    }
//                    }else {
//                        int posLoad = 0;
//                        if(loadPage ==1){
//                            posLoad= isLoad;
//                        }else if(loadPage>1) {
//                            if(isLoad>29){
//                                posLoad = isLoad- (30*(loadPage-1));
//                                Log.e("isLoad1",""+isLoad+"|"+posLoad+"|"+loadPage);
//                            }else {
//                                posLoad= isLoad;
//                            }
//                            Log.e("isLoad",""+isLoad+"|"+posLoad+"|"+loadPage);
//                        }
//                        list.get(isLoad).setViewNum(forum.getData().getList().get(posLoad).getViewNum());
//                        list.get(isLoad).setContent(forum.getData().getList().get(posLoad).getContent());
//                        list.get(isLoad).setIsLike(forum.getData().getList().get(posLoad).getIsLike());
//                        list.get(isLoad).setLikeNum(forum.getData().getList().get(posLoad).getLikeNum());
//                        list.get(isLoad).setReplyCount(forum.getData().getList().get(posLoad).getReplyCount());
//                        if (mAdapter != null) {
//                            mAdapter.notifyItemChanged(isLoad);
//                        }
//                    }
                    isLoad = -1;

                    if ((list == null || list.size() == 0) && tvData != null) {
                        tvData.setVisibility(View.VISIBLE);
                    } else if (tvData != null) {
                        tvData.setVisibility(View.GONE);
                    }
                } else {
//                    if (tvData != null)
//                        tvData.setVisibility(View.VISIBLE);
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
        mAdapter.cancelAllWebview();
        super.onDestroy();
    }

    @OnClick({R.id.tv_back, R.id.tv_search})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_back:
                getActivity().finish();
                break;
            case R.id.tv_search:
                search = et_search.getText().toString().trim();
                if (search == null || search.length() == 0) {
                    ToastUtil.toastShortShow(getContext(), getResources().getString(R.string.search));
                    return;
                }
                getDeposit();
                break;
        }
    }

    private void bbsDialog(String title, String pay, String id, int position) {
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
                    postContent(id, position);
                }
            }
        });
        mTDialog.setMsgGravity(Gravity.CENTER);
        mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
        mTDialog.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
        mTDialog.addView(inflate);
        mTDialog.show();
    }

    private void loginDialog() {
        String title = getResources().getString(R.string.lhc_bbs_hint);
        String content = getResources().getString(R.string.lhc_bbs_needlogin);
        String[] array = new String[]{getResources().getString(R.string.cancel), getResources().getString(R.string.lhc_bbs_login)};
        TDialog mTDialog1 = new TDialog(getActivity(), TDialog.Style.Center, array, title, content, "", new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int position) {
                if (position == 1) {
                    startActivity(new Intent(getContext(), LoginActivity.class));
                }
            }
        });
        mTDialog1.setCancelable(false);
        mTDialog1.show();
    }

    private void postContent(String id, int pos) {
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
                            isLoad = pos;
//                            if (mAdapter != null) {
//                                mAdapter.notifyItemChanged(isLoad);
//                            }
                            Log.e("posisLoad", "" + pos);
                            FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance("论坛详情", id, alias == null ? "" : alias));
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


    //点赞
    private void getpraise(String likeFlag, String type, String rid, int pos) {
        String url;
        String token = SPConstants.checkLoginInfo(getContext());
        String history = "&token=%s&rid=%s&likeFlag=%s&type=%s";
        url = Constants.LIKEPOST + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(rid), SecretUtils.DESede(likeFlag), SecretUtils.DESede(type)) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBetterFragment.this, true, PreiseBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                PreiseBean base = (PreiseBean) o;
                if (base != null && base.getMsg() != null) {
//                    ToastUtil.toastShortShow(getContext(), base.getMsg());
                    if (base.getCode() == 0) {
                        if (!TextUtils.isEmpty(list.get(pos).getIsLike())) {
                            if (list.get(pos).getIsLike().equals("0")) {
                                list.get(pos).setIsLike("1");
                            } else if (list.get(pos).getIsLike().equals("1")) {
                                list.get(pos).setIsLike("0");
                            }
                            list.get(pos).setLikeNum(base.getData().getLikeNum() + "");
                            if (mAdapter != null)
                                mAdapter.notifyItemChanged(pos);
                        }
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


    private void getDetail() {
        String url;
        String token = SPConstants.getToken(getContext());
        if(isLoad==-1){
            return;
        }
        String id = list.get(isLoad).getCid() == null ? "" : list.get(isLoad).getCid();
        Log.e("idtoken", "" + id);
        if (TextUtils.isEmpty(token)) {
            String history = "&id=%s";
            url = Constants.CONTENTDETAIL + String.format(history, SecretUtils.DESede(id)) + "&sign=" + SecretUtils.RsaToken();
        } else {
            String history = "&token=%s&id=%s";
            url = Constants.CONTENTDETAIL + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(id)) + "&sign=" + SecretUtils.RsaToken();
        }
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBetterFragment.this, true, SixThemeBbsDetailBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                SixThemeBbsDetailBean detail = (SixThemeBbsDetailBean) o;
                if (detail != null && detail.getCode() == 0 && detail.getData() != null) {
                    SixThemeBbsDetailBean.DataBean data = detail.getData();
                    if(list!=null) {
                        list.get(isLoad).setViewNum(data.getViewNum() == null ? "" : data.getViewNum());
//                        list.get(isLoad).setContent(data.getContent() == null ? "" : data.getContent());
                        list.get(isLoad).setIsLike(data.getIsLike() == null ? "0" : (data.getIsLike()));
                        list.get(isLoad).setLikeNum(data.getLikeNum() == null ? "" : data.getLikeNum());
                        list.get(isLoad).setReplyCount(data.getReplyCount() == null ? "" : data.getReplyCount());
                        if (mAdapter != null) {
                            mAdapter.setNoLoad(1);
                            Log.e("isLoad",""+isLoad);
                            mAdapter.notifyItemChanged(isLoad);
                        }
                    }

                } else {

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
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.ITEMUPDATA:
                if (even.getData().equals(alias)) {
                    getDetail();
                }
                break;
            case EvenBusCode.ITEMDATA:
                page = 1;
                getDeposit();
                break;
        }
    }

}
