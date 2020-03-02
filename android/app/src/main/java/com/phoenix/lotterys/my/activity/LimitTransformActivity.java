package com.phoenix.lotterys.my.activity;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.LimitAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.LoginInfo;
import com.phoenix.lotterys.my.bean.TransferinterestBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.MissionCenterFrag;
import com.phoenix.lotterys.my.fragment.MissionCenterFragB;
import com.phoenix.lotterys.my.fragment.SignInFrag;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.DynamicWave;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import org.greenrobot.eventbus.EventBus;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/8/26
 */
//额度转换记录
public class LimitTransformActivity extends BaseActivitys implements View.OnClickListener {
    @BindView(R2.id.tv_taskreward)
    TextView tvTaskreward;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.rv)
    RecyclerView rv;
    @BindView(R2.id.iv_img)
    ImageView ivImg;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_money)
    TextView tvMoney;
    @BindView(R2.id.progress1)
    ProgressBar progress1;
    @BindView(R2.id.tv_userParentId)
    TextView tvUserParentId;
    @BindView(R2.id.tv_integral)
    TextView tvIntegral;
    @BindView(R2.id.tv_grow)
    TextView tvGrow;
    @BindView(R2.id.iv_task)
    ImageView ivTask;
    @BindView(R2.id.iv_sign)
    ImageView ivSign;
    @BindView(R2.id.iv_refresh)
    ImageView ivRefresh;
    LoginInfo li;
    @BindView(R2.id.d_wave)
    DynamicWave dWave;
    @BindView(R2.id.ll_user)
    LinearLayout llUser;
    @BindView(R2.id.rl_userInfo)
    RelativeLayout rlUserInfo;
    @BindView(R2.id.ll_level)
    LinearLayout llLevel;
    @BindView(R2.id.tv_level)
    TextView tvLevel;
    @BindView(R2.id.tv_next_level)
    TextView tvNextLevel;
    @BindView(R2.id.progress_lin)
    LinearLayout progressLin;
    @BindView(R2.id.tv_data)
    TextView tvData;
    @BindView(R2.id.ll_title)
    LinearLayout llTitle;
    @BindView(R2.id.refreshLayout)
    SmartRefreshLayout refreshLayout;
    int page = 1;
    int rows = 20;
    @BindView(R2.id.tv_title_game)
    TextView tvTitleGame;
    @BindView(R2.id.tv_title_money)
    TextView tvTitleMoney;
    @BindView(R2.id.tv_title_data)
    TextView tvTitleData;
    @BindView(R2.id.tv_title_model)
    TextView tvTitleModel;
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.main_rel)
    RelativeLayout mainRel;
    private String transferLogs = "?c=real&a=transferLogs&token=%s&page=%s&rows=%s&startTime=%s&endTime=%s";

    private SharedPreferences sp;
    private ObjectAnimator objectAnimator;


    private List<TransferinterestBean.DataBean.ListBean> list = new ArrayList<>();
    private LimitAdapter mAdapter;

    public LimitTransformActivity() {
        super(R.layout.activity_limit_transfrom);
    }

    @Override
    public void initView() {
        sp = getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance());   //暗文
        ivRefresh.setVisibility(View.VISIBLE);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        try {
            userInfo();
        } catch (Exception e) {
            e.printStackTrace();
        }
        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(LimitTransformActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (configBean != null && configBean.getData() != null && configBean.getData().getMobileTemplateCategory() != null) {
            if (configBean.getData().getMobileTemplateCategory().equals("5")) {
                Uiutils.setBaColor(LimitTransformActivity.this, llTitle, false, null);
                Uiutils.setBaColor(LimitTransformActivity.this, llMain);
                tvTitleGame.setTextColor(getResources().getColor(R.color.white));
                tvTitleMoney.setTextColor(getResources().getColor(R.color.white));
                tvTitleData.setTextColor(getResources().getColor(R.color.white));
                tvTitleModel.setTextColor(getResources().getColor(R.color.white));
                tvData.setTextColor(getResources().getColor(R.color.font));
            }
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
                    page++;
                    getDeposit();
                }
            });
        }
        mAdapter = new LimitAdapter(list, LimitTransformActivity.this);
        rv.setAdapter(mAdapter);
        if (rv.getItemDecorationCount() == 0) {
            rv.setLayoutManager(new LinearLayoutManager(LimitTransformActivity.this));
            rv.addItemDecoration(new DividerGridItemDecoration(LimitTransformActivity.this,
                    DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(200, 200, 200)));
        }
        getDeposit();


        if (!StringUtils.isEmpty(ShareUtils.getString(this, "themetyp", ""))) {
            dWave.setVisibility(View.GONE);
        }

        if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                .getCheckinSwitch()) && StringUtils.equals("1", configBean.getData()
                .getCheckinSwitch())) {
            ivSign.setVisibility(View.VISIBLE);
            tvTaskreward.setVisibility(View.GONE);
        }

        if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                .getMissionSwitch())) {
            llLevel.setVisibility(View.VISIBLE);
            progressLin.setVisibility(View.VISIBLE);
            tvTaskreward.setVisibility(View.VISIBLE);
        } else {
            ivSign.setVisibility(View.INVISIBLE);
            tvTaskreward.setVisibility(View.GONE);

        }

        Uiutils.setBarStye0(mainRel, this);
        Uiutils.setBarStye0(titlebar, this);
    }

    private void getDeposit() {
        String startDate = Uiutils.getFetureDate(-1000);
        String endDate = Uiutils.getFetureDate(0);
        String token = SPConstants.checkLoginInfo(LimitTransformActivity.this);
        String url = Constants.BaseUrl() + Constants.TRANSFERINTEREST + String.format(transferLogs, SecretUtils.DESede(token), SecretUtils.DESede(page + ""), SecretUtils.DESede(rows + ""), SecretUtils.DESede(startDate + " 00:00:00"), SecretUtils.DESede(endDate + " 23:59:59")) + "&sign=" + SecretUtils.RsaToken();
        OkGo.<String>get(URLDecoder.decode(url)).tag(this).execute(new NetDialogCallBack(LimitTransformActivity.this, true, LimitTransformActivity.this, true, TransferinterestBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                refreshLayout.finishLoadMore(1000);      //加载完成
                TransferinterestBean db = (TransferinterestBean) o;
                if (db != null && db.getCode() == 0 && db.getData() != null && db.getData().getList() != null) {
                    if (page == 1)
                        list.clear();
                    list.addAll(db.getData().getList());
                    mAdapter.notifyDataSetChanged();
                    if (db.getData().getList() == null || db.getData().getList().size() == 0)
                        refreshLayout.finishLoadMoreWithNoMoreData();  //全部加载完成,没有数据了调用此方法

                    if (list == null || list.size() == 0) {
                        tvData.setVisibility(View.VISIBLE);
                    } else {
                        tvData.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
                refreshLayout.finishLoadMore(1000);      //加载完成
            }

            @Override
            public void onFailed(Response<String> response) {
                refreshLayout.finishLoadMore(1000);      //加载完成
            }
        });
    }


    private void userInfo() {
        UserInfo userInfo = (UserInfo) ShareUtils.getObject(LimitTransformActivity.this, SPConstants.USERINFO, UserInfo.class);
        if (null != userInfo && null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData()
                .getAvatar())) {
            ImageLoadUtil.loadRoundImage(ivImg,
                    userInfo.getData()
                            .getAvatar(), 0);
        } else {
            ImageLoadUtil.ImageLoad(LimitTransformActivity.this, R.drawable.head, ivImg);

        }
        String taskRewardTitle = userInfo.getData().getTaskRewardTitle() == null ? "" : userInfo.getData().getTaskRewardTitle() /*SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARDTITLE)*/;
        String taskRewardValue = userInfo.getData().getTaskReward() == null ? "" : userInfo.getData().getTaskReward() /*SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARD)*/;

        String levelGrade = userInfo.getData().getCurLevelGrade() == null ? "" : userInfo.getData().getCurLevelGrade() /*SPConstants.getValue(getContext(), SPConstants.SP_CURLEVELGRADE)*/;
        String nextLevelGrade = userInfo.getData().getNextLevelGrade() == null ? "" : userInfo.getData().getNextLevelGrade() /*SPConstants.getValue(getContext(), SPConstants.SP_NEXTLEVELGRADE)*/;
        String nextlevelint = userInfo.getData().getNextLevelInt() == null ? "" : userInfo.getData().getNextLevelInt()/*SPConstants.getValue(getContext(), SPConstants.SP_NEXTLEVELINT)*/;
        String taskReward = userInfo.getData().getTaskRewardTotal() == null ? "" : userInfo.getData().getTaskRewardTotal()/*SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARDTOTAL)*/;
        tvMoney.setText(userInfo.getData().getBalance() == null ? "" : userInfo.getData().getBalance()/*SPConstants.getValue(getContext(), SPConstants.SP_BALANCE)*/);

//        String taskRewardTitle = SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_TASKREWARDTITLE);
//        String taskRewardValue = SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_TASKREWARD);
        tvTaskreward.setText(taskRewardTitle + ":\n" + taskRewardValue);


//        String levelGrade = SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_CURLEVELGRADE);
//        String nextLevelGrade = SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_NEXTLEVELGRADE);
        tvUserParentId.setText(levelGrade + " ");
        tvLevel.setText(levelGrade);
        tvNextLevel.setText(nextLevelGrade);
//        tvMoney.setText(SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_BALANCE));
        tvName.setText(SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_USR));  //用户名

//        String nextlevelint = SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_NEXTLEVELINT);
//        String taskReward = SPConstants.getValue(LimitTransformActivity.this, SPConstants.SP_TASKREWARD);
        String temp = ShowItem.subZeroAndDot(taskReward.equals("Null") ? "0" : taskReward);
        if (ShowItem.isNumeric(nextlevelint) || ShowItem.isNumeric(temp)) {
            double d = Double.parseDouble(temp);
            int reward = (int) d;
            int m = Integer.parseInt(nextlevelint.equals("Null") ? "0" : ShowItem.subZeroAndDot(nextlevelint));
            progress1.setMax(m);
            progress1.setProgress(reward);
            tvGrow.setText("成长值(" + ShowItem.subZeroAndDot(d + "") + " - " + ShowItem.subZeroAndDot(m + "") + ")");
        }
    }

    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }

    private boolean isSee = true;

    @OnClick({R.id.iv_task, R.id.iv_sign, R.id.tv_money, R.id.iv_refresh/*, R.id.iv_img*/})
    public void onClick(View view) {
        Intent intent = null;
        switch (view.getId()) {
            case R.id.iv_task:
                if (ButtonUtils.isFastDoubleClick())
                    return;
//                intent = new Intent(getActivity(), GoWebActivity.class);
//                intent.putExtra("url", Constants.BaseUrl + "/dist/#/task/task");
//                startActivity(intent);

                ConfigBean config = (ConfigBean) ShareUtils.getObject(LimitTransformActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
                if (config != null && config.getData() != null && config.getData().getMobileTemplateCategory() != null) {
                    if (config.getData().getMobileTemplateCategory().equals("5")) {
                        FragmentUtilAct.startAct(LimitTransformActivity.this, new MissionCenterFragB(false));
                    } else {
                        FragmentUtilAct.startAct(LimitTransformActivity.this, new MissionCenterFrag(false));
                    }
                } else {
                    FragmentUtilAct.startAct(LimitTransformActivity.this, new MissionCenterFrag(false));
                }


                break;
            case R.id.iv_sign:  //签到
//                intent = new Intent(getActivity(), GoWebActivity.class);
//                intent.putExtra("url", Constants.BaseUrl + "/dist/#/Sign");
//                startActivity(intent);
                if (ButtonUtils.isFastDoubleClick())
                    return;
                FragmentUtilAct.startAct(LimitTransformActivity.this, new SignInFrag(false));

                break;

            case R.id.tv_money:
                isSee = !isSee;
                if (isSee) {//¥
                    tvMoney.setTransformationMethod(PasswordTransformationMethod.getInstance());   //暗文
                    ivRefresh.setVisibility(View.GONE);
                } else {
                    tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance()); //明文
                    ivRefresh.setVisibility(View.VISIBLE);
                }

                break;

            case R.id.iv_refresh:
                if (ButtonUtils.isFastDoubleClick())
                    return;
//                tvMoney.setText("¥ ..");
                objectAnimator = ObjectAnimator.ofFloat(ivRefresh, "rotation", 0f, 360f);
                objectAnimator.setDuration(1500);
                objectAnimator.start();
                checkLoginInfo();
                break;

        }
    }

    private void checkLoginInfo() {
        String token = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
        if (!token.equals(SPConstants.SP_NULL)) {
            getUserInfo(token);
        } else {
//            startActivity(new Intent(LimitTransformActivity.this, LoginActivity.class));
            Uiutils.login(LimitTransformActivity.this);
        }
    }

    //获取登录信息
    private void getUserInfo(String s) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(s) + "&sign=" + SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(LimitTransformActivity.this, true, LimitTransformActivity.this, true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                UserInfo li = (UserInfo) o;
                if (li != null && li.getCode() == 0) {
                    SharedPreferences.Editor edit = sp.edit();
                    edit.putString(SPConstants.SP_BALANCE, FormatNum.amountFormat(li.getData().getBalance(), 4));   //金额
                    edit.putString(SPConstants.SP_USR, li.getData().getUsr());
                    edit.putString(SPConstants.SP_CURLEVELGRADE, li.getData().getCurLevelGrade());
                    edit.putString(SPConstants.SP_NEXTLEVELGRADE, li.getData().getNextLevelGrade());
                    edit.putString(SPConstants.SP_CURLEVELINT, li.getData().getCurLevelInt());
                    edit.putString(SPConstants.SP_NEXTLEVELINT, li.getData().getNextLevelInt());
                    edit.putString(SPConstants.SP_TASKREWARDTITLE, li.getData().getTaskRewardTitle());
                    edit.putString(SPConstants.SP_TASKREWARDTOTAL, li.getData().getTaskRewardTotal());
                    edit.putString(SPConstants.SP_HASBANKCARD, li.getData().isHasBankCard() + "");
                    edit.putString(SPConstants.SP_HASFUNDPWD, li.getData().isHasFundPwd() + "");
                    edit.putString(SPConstants.SP_ISTEST, li.getData().isIsTest() + "");
                    edit.putString(SPConstants.SP_UNREADMSG, li.getData().getUnreadMsg() + "");
                    edit.putString(SPConstants.SP_TASKREWARD, li.getData().getTaskReward());
                    //头像
                    edit.putString(SPConstants.AVATAR, li.getData().getAvatar());
                    edit.putString(SPConstants.SP_CURLEVELTITLE, li.getData().getCurLevelTitle());
                    edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, li.getData().isYuebaoSwitch());
                    edit.commit();
                    ShareUtils.saveObject(LimitTransformActivity.this, SPConstants.USERINFO, li);
                    EventBus.getDefault().postSticky(new MessageEvent("userinfo"));

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
