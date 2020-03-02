package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.activity.ReviewActivity;
import com.phoenix.lotterys.home.adapter.ReplyListAdapter;
import com.phoenix.lotterys.home.bean.PreiseBean;
import com.phoenix.lotterys.home.bean.ReplyBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/12/1
 */

//2级评论列表
@SuppressLint("ValidFragment")
public class SixThemeBbsDetailReviewListFrament extends BaseFragments {
    String title, rid, cid;
    int page = 1;
    List<ReplyBean.DataBean.ListBean> dataList = new ArrayList<>();
    boolean isPraise = false;   //点赞
    ReplyListAdapter mAdapter;
    @BindView(R2.id.rv_record)
    RecyclerView rvRecord;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    @BindView(R2.id.rl_speak)
    RelativeLayout rlSpeak;
    @BindView(R2.id.ll_data)
    LinearLayout llData;
    @BindView(R2.id.iv_head)
    ImageView ivHead;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_content)
    TextView tvContent;
    @BindView(R2.id.tv_time)
    TextView tvTime;
    @BindView(R2.id.tv_praise)
    TextView tvPraise;
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;
    boolean isShow = false;
    private String uid;
    private String headImg, nickname, actionTime, content, islike, islikeNum;


    @SuppressLint("ValidFragment")
    public SixThemeBbsDetailReviewListFrament(String title) {
        super(R.layout.fragment_sixtheme_bbsdetail_reviewlist);
        this.title = title;
    }

    public static SixThemeBbsDetailReviewListFrament getInstance(String title, String cid, String rid, String headImg, String nickname, String actionTime, String content, String islike, String islikeNum) {
        SixThemeBbsDetailReviewListFrament sf = new SixThemeBbsDetailReviewListFrament(title);
        sf.title = title;
        sf.cid = cid;
        sf.rid = rid;
        sf.headImg = headImg;
        sf.nickname = nickname;
        sf.actionTime = actionTime;
        sf.content = content;
        sf.islike = islike;
        sf.islikeNum = islikeNum;
        return sf;
    }

    @Override
    public void initView(View view) {
        Uiutils.setBarStye0(titlebar,getContext());
        getComment();
        refreshLayout.setOnRefreshListener(new OnRefreshListener() {
            @Override
            public void onRefresh(RefreshLayout refreshLayout) {
                refreshLayout.finishRefresh(1000/*,false*/);//传入false表示刷新失败
                page = 1;
                getComment();
            }
        });
        refreshLayout.setOnLoadMoreListener(new OnLoadMoreListener() {
            @Override
            public void onLoadMore(RefreshLayout refreshLayout) {
                refreshLayout.finishLoadMore(1000);      //加载完成
                page++;
                getComment();
            }
        });
        initRrply();
        initData();

        Uiutils.setBarStye0(titlebar,getActivity());
    }

    private void initData() {
        mPraise();
        tvName.setText(TextUtils.isEmpty(nickname) ? "" : nickname);
        tvContent.setText(TextUtils.isEmpty(content) ? "" : content);
        tvTime.setText(TextUtils.isEmpty(actionTime) ? "" : actionTime);
        if (headImg != null) {
            ImageLoadUtil.loadRoundImage(ivHead, headImg, 0);
        }
    }

    private void mPraise() {
        if (islike != null && islike.equals("1")) {
            Drawable drawable = getResources().getDrawable(R.mipmap.praise_red);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            tvPraise.setCompoundDrawables(drawable, null, null, null);
        } else if (islike != null) {
            Drawable drawable = getResources().getDrawable(R.mipmap.praise);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            tvPraise.setCompoundDrawables(drawable, null, null, null);
        }
        tvPraise.setText(TextUtils.isEmpty(islikeNum) ? "" : islikeNum);
    }

    private void initRrply() {
        mAdapter = new ReplyListAdapter(dataList, getContext());
        rvRecord.setAdapter(mAdapter);
        if (rvRecord.getItemDecorationCount() == 0) {
            rvRecord.setLayoutManager(new LinearLayoutManager(getContext()));
            rvRecord.addItemDecoration(new DividerGridItemDecoration(getContext(),
                    DividerGridItemDecoration.HORIZONTAL_LIST, 20, Color.rgb(255, 255, 255)));
        }
    }


    @OnClick({R.id.tv_back, R.id.rl_speak, R.id.tv_praise})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_back:
                getActivity().finish();
                break;
            case R.id.tv_praise:
                getpraise(islike.equals("1") ? "0" : "1", "2", rid,-1);
                break;
            case R.id.rl_speak:
                Bundle build = new Bundle();
                build.putSerializable("cid", cid);
                build.putSerializable("rid", rid);
                IntentUtils.getInstence().intent(getActivity(), ReviewActivity.class, build);
                break;
        }
    }

    //评论列表
    private void getComment() {
        String url;
        String token = SPConstants.getToken(getContext());
//        if (TextUtils.isEmpty(token)) {
        String history = "&contentId=%s&replyPId=%s&token=%s&page=%s&rows=%s";
        url = Constants.CONTENTREPLYLIST + String.format(history, SecretUtils.DESede(cid), SecretUtils.DESede(rid), SecretUtils.DESede(token), SecretUtils.DESede(page + ""), SecretUtils.DESede("30")) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBbsDetailReviewListFrament.this, true, ReplyBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                isShow = true;
                ReplyBean reply = (ReplyBean) o;
                if (reply != null && reply.getCode() == 0 && reply.getData() != null&&reply.getData().getList()!=null) {
                    if (page == 1 && dataList != null)
                        dataList.clear();
                    dataList.addAll(reply.getData().getList());
                    if (mAdapter != null) {
                        mAdapter.notifyDataSetChanged();
                    }
                    if ((reply.getData().getList() == null || reply.getData().getList().size() < 30) && refreshLayout != null)
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法
                    if ((dataList == null || dataList.size() == 0) && llData != null) {
                        llData.setVisibility(View.VISIBLE);
                    } else if (llData != null) {
                        llData.setVisibility(View.GONE);
                    }
                } else {
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


    //点赞
    private void getpraise(String likeFlag, String type, String rid, int pos) {
        String url;
        String token = SPConstants.checkLoginInfo(getContext());
        if (TextUtils.isEmpty(token)) {
            return;
        }
        String history = "&token=%s&rid=%s&likeFlag=%s&type=%s";
        url = Constants.LIKEPOST + String.format(history, SecretUtils.DESede(token), SecretUtils.DESede(rid), SecretUtils.DESede(likeFlag), SecretUtils.DESede(type)) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + url)).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SixThemeBbsDetailReviewListFrament.this, true, PreiseBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                PreiseBean base = (PreiseBean) o;
                if (base != null && base.getMsg() != null) {
//                    ToastUtil.toastShortShow(getContext(), base.getMsg());
                    if (base.getCode() == 0&&base.getData()!=null) {
                        if (pos ==-1) {
                            islike = islike.equals("1") ? "0" : "1";
                            islikeNum = base.getData().getLikeNum()+"";
                            mPraise();
                        }
                        if (type.equals("2") && pos != -1) {
                            if (!TextUtils.isEmpty(dataList.get(pos).getIsLike())) {
                                if (dataList.get(pos).getIsLike().equals("0")) {
                                    dataList.get(pos).setIsLike("1");
//                                    dataList.get(pos).setLikeNum("1");
                                } else if (dataList.get(pos).getIsLike().equals("1")) {
                                    dataList.get(pos).setIsLike("0");
//                                    dataList.get(pos).setLikeNum("1");
                                }
                                if(base.getData()!=null) {
                                    dataList.get(pos).setLikeNum(base.getData().getLikeNum() + "");
                                    if (mAdapter != null)
                                        mAdapter.notifyDataSetChanged();
                                }
                            }
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

    @Override
    public void onResume() {
        super.onResume();
        if (isShow) {
            page =1;
            refreshLayout.setNoMoreData(false);
            getComment();
        }
    }

}
