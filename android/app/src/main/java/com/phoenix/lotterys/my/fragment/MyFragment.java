package com.phoenix.lotterys.my.fragment;


import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.TypedArray;
import android.os.Bundle;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.home.fragment.BankManageFrament;
import com.phoenix.lotterys.home.fragment.TransferFrament;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.DepositActivity;
import com.phoenix.lotterys.my.activity.InterestDoteyActivity;
import com.phoenix.lotterys.my.adapter.HeandAdapter;
import com.phoenix.lotterys.my.adapter.MyitemBadgeAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.HeandBean;
import com.phoenix.lotterys.my.bean.LoginInfo;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.ToTransferBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.DynamicWave;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by Luke
 * on 2019/6/8
 */
@SuppressLint("ValidFragment")
public class MyFragment extends BaseFragments implements View.OnClickListener {

    @BindView(R2.id.tv_taskreward)
    TextView tvTaskreward;
    @BindView(R2.id.rv)
    RecyclerView rv;
    List<My_item> list = new ArrayList<>();
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
    @BindView(R2.id.main_tex)
    TextView mainTex;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    private SharedPreferences sp;
    private ObjectAnimator objectAnimator;

    private HeandAdapter heandAdapter;
    private View phoneView;
    private CustomPopWindow mCustomPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private List<HeandBean.DataBean> heandList = new ArrayList<>();
    private HeandBean heandBean;

    private ImageView headImg;
    private RecyclerView headPopRec;
    private ImageView leftImg;
    private ImageView rightImg;

    private String filename;
    private String heandUrl;
    private int lastPosition = 1;
    private int fristPosition = 0;
    private String zxkfurl;
    private MyitemBadgeAdapter adapter;
    MainActivity mActivity;
    boolean isHide = false;

    @SuppressLint("ValidFragment")
    public MyFragment(boolean isHide) {
        super(R.layout.fragment_my, true);
        this.isHide = isHide;
    }

    public static MyFragment getInstance() {
        return new MyFragment(true);
    }

    private ConfigBean configBean;

    @Override
    public void initView(View view) {

        if (isHide) {
            if (getActivity() instanceof MainActivity) {
                mActivity = (MainActivity) getActivity();
            }
        }
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance());   //明文
        ivRefresh.setVisibility(View.VISIBLE);
        initdata();
        checkLoginInfo();
        isVisible = true;
        try {
            userInfo();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (null != userInfo && null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData()
                .getAvatar())) {
            ImageLoadUtil.loadRoundImage(ivImg,
                    userInfo.getData()
                            .getAvatar(), 0);
            phoneStr = userInfo.getData()
                    .getAvatar().substring(0, userInfo.getData()
                            .getAvatar().indexOf("?"));
        } else {
            ImageLoadUtil.ImageLoad(getContext(), R.drawable.head, ivImg);
            phoneStr = "";
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
            removeItem("rwzx");

        }
        setSytpe();


        if (0 != ShareUtils.getInt(getContext(), "ba_top", 0)) {
            mainTex.setBackgroundColor(getContext().getResources().getColor(
                    ShareUtils.getInt(getContext(), "ba_top", 0)));
        }
        titlebar.setRightIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isHide)
                    mActivity.openSliding();
            }
        });
        if (!isHide) {
            titlebar.setRIghtImgVisibility(View.GONE);
            titlebar.setIvBackHide(View.VISIBLE);
            Uiutils.setBarStye(titlebar, getActivity());
        } else {
            titlebar.setRIghtImgVisibility(View.VISIBLE);
            titlebar.setIvBackHide(View.GONE);
        }
        Uiutils.setBaColor(getContext(), titlebar, false, null);


    }

    private void removeItem(String str) {
        if (list.size() > 0)
            for (int i = 0; i < list.size(); i++) {
                if (StringUtils.equals(str, list.get(i).getAlias())) {
                    list.remove(i);
                    if (null != adapter)
                        adapter.notifyDataSetChanged();
                    continue;
                }
            }
    }


    private void userInfo() {
        if (isVisible) {
            userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
            if (userInfo != null && userInfo.getData() != null) {

                //积分taskRewardTitle
                String taskRewardTitle = userInfo.getData().getTaskRewardTitle() == null ? "" : userInfo.getData().getTaskRewardTitle()/*SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARDTITLE)*/;
                String taskRewardValue = userInfo.getData().getTaskReward() == null ? "" : userInfo.getData().getTaskReward() /*SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARD)*/;
                tvTaskreward.setText(taskRewardTitle + ":\n" + taskRewardValue);
                //等级
                String levelGrade = userInfo.getData().getCurLevelGrade() == null ? "" : userInfo.getData().getCurLevelGrade() /*SPConstants.getValue(getContext(), SPConstants.SP_CURLEVELGRADE)*/;
                String nextLevelGrade = userInfo.getData().getNextLevelGrade() == null ? "" : userInfo.getData().getNextLevelGrade() /*SPConstants.getValue(getContext(), SPConstants.SP_NEXTLEVELGRADE)*/;
                tvUserParentId.setText(levelGrade + " ");
                tvUserParentId.setText(levelGrade);
                tvLevel.setText(levelGrade);
                tvNextLevel.setText(nextLevelGrade);
                //用户名
                if (SPConstants.getValue(getContext(), SPConstants.SP_USERTYPE).equals("guest")) {
                    tvName.setText("游客");
                } else if (!SPConstants.getValue(getContext(), SPConstants.SP_USERTYPE).equals("Null")) {
                    tvName.setText(SPConstants.getValue(getContext(), SPConstants.SP_USR));  //用户名
                }
                //余额
                tvMoney.setText(userInfo.getData().getBalance() == null ? "" : userInfo.getData().getBalance()/*SPConstants.getValue(getContext(), SPConstants.SP_BALANCE)*/);
//            String curlevelint = SPConstants.getValue(getContext(), SPConstants.SP_CURLEVELINT);
                String nextlevelint = userInfo.getData().getNextLevelInt() == null ? "" : userInfo.getData().getNextLevelInt()/*SPConstants.getValue(getContext(), SPConstants.SP_NEXTLEVELINT)*/;
                String taskReward = userInfo.getData().getTaskRewardTotal() == null ? "Null" : userInfo.getData().getTaskRewardTotal()/*SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARDTOTAL)*/;
                String temp = ShowItem.subZeroAndDot(taskReward.equals("Null") ? "0" : taskReward);
                //成长值
                if (ShowItem.isNumeric(nextlevelint) || ShowItem.isNumeric(temp)) {
                    double d = Double.parseDouble(temp);
                    int reward = (int) d;
                    int m = Integer.parseInt(nextlevelint.equals("Null") ? "0" : ShowItem.subZeroAndDot(nextlevelint));
                    progress1.setMax(m);
                    progress1.setProgress(reward);
                    tvGrow.setText("成长值(" + ShowItem.subZeroAndDot(d + "") + " - " + ShowItem.subZeroAndDot(m + "") + ")");
                }
                if (list != null && adapter != null) {
                    for (int i = 0; i < list.size(); i++) {
                        if (list.get(i).getAlias().equals("znx")) {
//                        list.get(i).setMess(SPConstants.getValue(getContext(), SPConstants.SP_UNREADMSG).equals("NUll") ? "0" : SPConstants.getValue(getContext(), SPConstants.SP_UNREADMSG));
                            list.get(i).setMess(userInfo.getData().getUnreadMsg() + "");
                            adapter.notifyItemChanged(i);
                            continue;
                        }

                        if (null != userInfo && null != userInfo.getData() && !userInfo.getData().isHasActLottery()) {
                            removeItem("hdsg");
                        }
                    }
                }
            }
        }
        zxkfurl = SPConstants.getValue(getContext(), SPConstants.SP_ZXKFURL);
    }

    //设置会员等级图片
    private void setLecel(String levelGrade, String nextLevelGrade) {
        tvUserParentId.setText(levelGrade + " ");
        switch (levelGrade) {
            case "VIP1":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip1));
                tvLevel.setBackgroundResource(R.mipmap.grade_1);
                break;
            case "VIP2":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip2));
                tvLevel.setBackgroundResource(R.mipmap.grade_2);
                break;
            case "VIP3":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip3));
                tvLevel.setBackgroundResource(R.mipmap.grade_3);
                break;
            case "VIP4":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip4));
                tvLevel.setBackgroundResource(R.mipmap.grade_4);
                break;
            case "VIP5":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip5));
                tvLevel.setBackgroundResource(R.mipmap.grade_5);
                break;
            case "VIP6":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip6));
                tvLevel.setBackgroundResource(R.mipmap.grade_6);
                break;
            case "VIP7":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip7));
                tvLevel.setBackgroundResource(R.mipmap.grade_7);
                break;
            case "VIP8":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip8));
                tvLevel.setBackgroundResource(R.mipmap.grade_8);
                break;
            case "VIP9":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip9));
                tvLevel.setBackgroundResource(R.mipmap.grade_9);
                break;
            case "VIP10":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip10));
                tvLevel.setBackgroundResource(R.mipmap.grade_10);
                break;
            case "VIP11":
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip11));
                tvLevel.setBackgroundResource(R.mipmap.grade_11);
                break;
            default:
                tvUserParentId.setBackground(getResources().getDrawable(R.mipmap.vip0));
                tvLevel.setBackgroundResource(R.mipmap.grade_0);
                break;
        }

        switch (nextLevelGrade) {
            case "VIP1":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_1));
                break;
            case "VIP2":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_2));
                break;
            case "VIP3":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_3));
                break;
            case "VIP4":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_4));
                break;
            case "VIP5":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_5));
                break;
            case "VIP6":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_6));
                break;
            case "VIP7":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_7));
                break;
            case "VIP8":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_8));
                break;
            case "VIP9":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_9));
                break;
            case "VIP10":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_10));
                break;
            case "VIP11":
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_11));
                break;
            default:
                tvNextLevel.setBackground(getResources().getDrawable(R.mipmap.grade_0));
                break;
        }

    }

    private UserInfo userInfo;

    //获取登录信息
    private void getUserInfo(String s) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(s) + "&sign=" + SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(getContext(), true, MyFragment.this, true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                userInfo = (UserInfo) o;
                if (userInfo != null && userInfo.getCode() == 0) {
                    SharedPreferences.Editor edit = sp.edit();
                    edit.putString(SPConstants.SP_BALANCE, userInfo.getData().getBalance() == null ? "0" : FormatNum.amountFormat(userInfo.getData().getBalance(), 4));   //金额
                    edit.putString(SPConstants.SP_USR, userInfo.getData().getUsr() == null ? "" : userInfo.getData().getUsr());
                    edit.putString(SPConstants.SP_CURLEVELGRADE, userInfo.getData().getCurLevelGrade() == null ? "" : userInfo.getData().getCurLevelGrade());
                    edit.putString(SPConstants.SP_NEXTLEVELGRADE, userInfo.getData().getNextLevelGrade() == null ? "" : userInfo.getData().getNextLevelGrade());
                    edit.putString(SPConstants.SP_CURLEVELINT, userInfo.getData().getCurLevelInt() == null ? "" : userInfo.getData().getCurLevelInt());
                    edit.putString(SPConstants.SP_NEXTLEVELINT, userInfo.getData().getNextLevelInt() == null ? "" : userInfo.getData().getNextLevelInt());
                    edit.putString(SPConstants.SP_TASKREWARDTITLE, userInfo.getData().getTaskRewardTitle() == null ? "" : userInfo.getData().getTaskRewardTitle());
                    edit.putString(SPConstants.SP_TASKREWARDTOTAL, userInfo.getData().getTaskRewardTotal() == null ? "" : userInfo.getData().getTaskRewardTotal());
                    edit.putString(SPConstants.SP_TASKREWARD, userInfo.getData().getTaskReward() == null ? "" : userInfo.getData().getTaskReward());
                    edit.putString(SPConstants.SP_HASBANKCARD, userInfo.getData().isHasBankCard() + "");
                    edit.putString(SPConstants.SP_HASFUNDPWD, userInfo.getData().isHasFundPwd() + "");
                    edit.putString(SPConstants.SP_ISTEST, userInfo.getData().isIsTest() + "");
                    edit.putString(SPConstants.SP_UNREADMSG, userInfo.getData().getUnreadMsg() + "");
                    //头像
                    edit.putString(SPConstants.AVATAR, userInfo.getData().getAvatar() == null ? "" : userInfo.getData().getAvatar());
                    edit.putString(SPConstants.SP_CURLEVELTITLE, userInfo.getData().getCurLevelTitle() == null ? "" : userInfo.getData().getCurLevelTitle());
                    edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, userInfo.getData().isYuebaoSwitch());

                    edit.commit();
                    ShareUtils.saveObject(getContext(), SPConstants.USERINFO, userInfo);
                    EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                    setSytpe();
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

    private void setSytpe() {
        if (Uiutils.isTourist1(getActivity())) {
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getAlias().equals("sytj")) {
                    list.get(i).setTitle("收益推荐");
                }
            }
            return;
        }


        if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getAlias().equals("sytj")) {
                    list.get(i).setTitle("收益推荐");
                }
            }
        } else {
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getAlias().equals("sytj")) {
                    list.get(i).setTitle("申请代理");
                }
            }
        }

        if (null == userInfo || null == userInfo.getData() ){ }
        else if ( !userInfo.getData().isHasActLottery()) {
                if (list.size()>0){
                    removeItem("hdsg");
                }
        }else if (userInfo.getData().isHasActLottery()){
                if (list.size()>0){
                    if (!StringUtils.equals(list.get(list.size()-1).getAlias(),("hdsg"))){
                        list.add( new My_item(R.mipmap.handsel,"活动彩金", "hdsg"));
                    }
                }
            }

        adapter.notifyDataSetChanged();
    }


    @Subscribe(sticky = true)
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("userinfo")) {
            userInfo();
            updataYuebao();

        } else if (messageEvent.getMessage().equals("config")) {
            userInfo();
            updataYuebao();


        }
    }

    private void updataYuebao() {
        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());
        if (!yuebaoshutdown) {
            if (list != null) {
                for (int i = 0; i < list.size(); i++) {
                    if (list.get(i).getAlias().equals("lxb")) {
                        list.remove(i);
                    }
                }
            }
            if (adapter != null)
                adapter.notifyDataSetChanged();
        } else if (yuebaoshutdown && list != null && list.size() >= 2 && adapter != null) {
            if (list.get(2).getAlias().equals("lxb")) {
                if (!TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
                    list.get(2).setTitle(yuebaoName);
                } else {
                    list.get(2).setTitle("利息宝");
                }
                adapter.notifyDataSetChanged();
            } else {
                list.add(2, new My_item(R.mipmap.lxb_sele, yuebaoName.equals("Null") ? "利息宝" : yuebaoName, "lxb"));
                adapter.notifyDataSetChanged();
            }
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.READ:
                checkLoginInfo();
                break;
            case EvenBusCode.CHANGE_PICTURE:
                userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
                if (null != userInfo && null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData()
                        .getAvatar())) {
                    if (!StringUtils.isEmpty(phoneStr)) {
                        if (!userInfo.getData().getAvatar().contains(phoneStr)) {
                            ImageLoadUtil.loadRoundImage(ivImg,
                                    userInfo.getData()
                                            .getAvatar(), 0);
                        }
                    } else {
                        ImageLoadUtil.loadRoundImage(ivImg,
                                userInfo.getData()
                                        .getAvatar(), 0);
                    }
                    phoneStr = userInfo.getData()
                            .getAvatar().substring(0, userInfo.getData()
                                    .getAvatar().indexOf("?"));
                } else {
                    ImageLoadUtil.ImageLoad(getContext(), R.drawable.head, ivImg);
                    phoneStr = "";
                }
                setSytpe();
                break;
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                if (0 != ShareUtils.getInt(getContext(), "ba_top", 0))
                    mainTex.setBackgroundColor(getResources().getColor(
                            ShareUtils.getInt(getContext(), "ba_top", 0)));
                break;
        }
    }

    protected void onTransformResume() {
        userInfo();
    }

    boolean isShow = false;

    private String[] title;
    private String[] titleAlias;
    private TypedArray icons;


    private void initdata() {
        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());
        title = getResources().getStringArray(R.array.my_list);
        titleAlias = getResources().getStringArray(R.array.my_list_alias);
        icons = getResources().obtainTypedArray(R.array.my_img_list);
        for (int i = 0; i < title.length; i++) {
            if (StringUtils.equals("lxb", titleAlias[i]) && !yuebaoshutdown) {
                isShow = true;
                continue;
            }

            if (StringUtils.equals("hdsg", titleAlias[i])) {
                if (null != userInfo && null != userInfo.getData() && !userInfo.getData().isHasActLottery()) {
                    continue;
                }
            }

            My_item item = new My_item();
            item.setImg(icons.getResourceId(i, 0));
            item.setAlias(titleAlias[i]);
            if (StringUtils.equals("lxb", titleAlias[i]) && !isShow) {
                if (yuebaoshutdown && !TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
                    item.setTitle(yuebaoName);
                } else if (yuebaoshutdown) {
                    item.setTitle("利息宝");
                }
            } else {
                item.setTitle(title[i]);
            }

            list.add(item);
        }

        for (My_item item : list) {
            if (item.getAlias().equals("jcxbb")) {
                item.setTitle("检查新版本  " + "(当前版本号：V" + APKVersionCodeUtils.getVerName(getContext()) + ")");
            }
        }
        rv.setLayoutManager(new LinearLayoutManager(getContext()));
        rv.setItemAnimator(new DefaultItemAnimator());
        rv.addItemDecoration(new SpacesItemDecoration(getContext()));
        adapter = new MyitemBadgeAdapter(list, getContext());
        rv.setAdapter(adapter);
        adapter.setOnItemClickListener(new MyitemBadgeAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (!Uiutils.isFastClick())
                    return;
                Intent intent = null;
                Bundle build;
                String alias = list.get(position).getAlias();
                switch (alias) {
                    case "ck":  //存款
                        if (Uiutils.isTourist(getActivity()))
                            return;
                        build = new Bundle();
                        build.putSerializable("page", "0");
                        IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);

//                       startActivity(new Intent(getActivity(), DepositActivity.class));
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/funds/deposit");
//                        intent.putExtra("type", "存款");
//                        startActivity(intent);
                        break;
                    case "qk":   //取款
                        if (Uiutils.isTourist(getActivity()))
                            return;
                        build = new Bundle();
                        build.putSerializable("page", "1");
                        IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/funds/Withdraw");
//                        intent.putExtra("type", "取款");
//                        startActivity(intent);
//                        startActivity(new Intent(getActivity(), DepositActivity.class));
                        break;
                    case "zxkf":   //在线客服
                        if (!TextUtils.isEmpty(zxkfurl)) {
                            Uiutils.goWebView(getContext(), zxkfurl.startsWith("http") ? zxkfurl : "http://" + zxkfurl
                                    , "在线客服");
                        } else {
                            ToastUtils.ToastUtils("客服地址未配置或获取失败", getContext());
                        }
                        break;
                    case "yhkgl":  //银行卡管理
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        startActivity(new Intent(getActivity(), BankManageActivity.class));
                        FragmentUtilAct.startAct(getActivity(), new BankManageFrament(false));
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/banks");
//                        startActivity(intent);
                        break;
                    case "lxb": //利息宝
                        if (Uiutils.isTourist(getActivity()))
                            return;
                        startActivity(new Intent(getActivity(), InterestDoteyActivity.class));
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/yuebao");
//                        startActivity(intent);
                        break;
                    case "edzh":  //额度转换
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        startActivity(new Intent(getActivity(), TransferActivity.class));
                        FragmentUtilAct.startAct(getActivity(), new TransferFrament(false));
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/conversion");
//                        startActivity(intent);
//                        FragmentUtilAct.startAct(getActivity(), new TransferNewFrament(false));
                        break;
                    case "sytj":  // 推荐收益
                        if (Uiutils.isTourist(getActivity()))
                            return;

                        if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
                            FragmentUtilAct.startAct(getActivity(), new RecommendBenefitFrag(false));
                        } else {
                            if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                                    .getAgent_m_apply()) && StringUtils.equals("1", configBean.getData()
                                    .getAgent_m_apply())) {
                                FragmentUtilAct.startAct(getActivity(), new AgencyProposerFrag(false));
                            } else {
                                ToastUtil.toastShortShow(getContext(), "在线注册代理已关闭");
                            }
                        }

                        break;
                    case "aqzx":  //安全中心
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/securityCenter");
//                        startActivity(intent);
                        isVisible = true;
                        FragmentUtilAct.startAct(getActivity(), new SafetyCenterFrag(false));
                        break;
                    case "znx":  //站内信
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/message");
//                        startActivity(intent);
//                        startActivity(new Intent(getActivity(), MailFrag.class));

                        FragmentUtilAct.startAct(getActivity(), new MailFrag(false));
                        break;
                    case "cpzdjl":  //彩票注单记录

                        if (Uiutils.isTourist(getActivity()))
                            return;

                        Bundle bundle = new Bundle();
                        bundle.putInt("type", 1);
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/myBet");
//                        startActivity(intent);

                        FragmentUtilAct.startAct(getActivity(), new NoteRecordFrag(), bundle);
                        break;
                    case "qtzdjl":  //注单记录
                        if (Uiutils.isTourist(getActivity()))
                            return;

                        Bundle bundle2 = new Bundle();
                        bundle2.putInt("type", 2);
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/myBet");
//                        startActivity(intent);

                        FragmentUtilAct.startAct(getActivity(), new NoteRecordFrag(), bundle2);

                        break;
                    case "jyfk":  //建议反馈
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/feedback");
//                        startActivity(intent);
//                        startActivity(new Intent(getActivity(), FeedbackFrag.class));

                        FragmentUtilAct.startAct(getActivity(), new FeedbackFrag());
                        break;
                    case "rwzx":  //任务中心
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/task/task");
//                        startActivity(intent);
                        if (getActivity() instanceof FragmentUtilAct) {
                            getActivity().finish();
                        }
                        FragmentUtilAct.startAct(getActivity(), new MissionCenterFrag(false));
                        break;
                    case "grxx":  //个人信息
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/myinfo");
//                        startActivity(intent);
//                        startActivity(new Intent(getActivity(), PersonalInformationAct.class));

                        FragmentUtilAct.startAct(getActivity(), new PersonalInformationFrag());

//                        intent = new Intent(getActivity(), TestFrag.class);
//                        intent.putExtra("url", "http://debugtbs.qq.com/");
//                        startActivity(intent);

                        break;

                    case "hdsg":  //活动彩金
                        if (Uiutils.isTourist(getActivity()))
                            return;
                        FragmentUtilAct.startAct(getActivity(), new ActivityFiledFrag());
                        break;
                    case "jcxbb":
//                        mActivity.getVersion();
                        break;
                    case "clzs":
//                        mActivity.getVersion();
                        FragmentUtilAct.startAct(getActivity(), new DragonAssistantFrag(false));
                        break;
                }
            }
        });
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
//        Constants.setmHidden(hidden);
    }

    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelTag(this);
        OkGo.getInstance().cancelTag(getActivity());
        super.onDestroy();
    }

    private boolean isSee = true;

    @OnClick({R.id.iv_task, R.id.iv_sign, R.id.tv_money, R.id.iv_refresh, R.id.iv_img})
    public void onClick(View view) {
        Intent intent = null;
        switch (view.getId()) {
            case R.id.iv_task:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (Uiutils.isTourist(getActivity()))
                    return;
//                intent = new Intent(getActivity(), GoWebActivity.class);
//                intent.putExtra("url", Constants.BaseUrl + "/dist/#/task/task");
//                startActivity(intent);
                FragmentUtilAct.startAct(getActivity(), new MissionCenterFrag(false));
                break;
            case R.id.iv_sign:  //签到
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (Uiutils.isTourist(getActivity()))
                    return;
//                intent = new Intent(getActivity(), GoWebActivity.class);
//                intent.putExtra("url", Constants.BaseUrl + "/dist/#/Sign");
//                startActivity(intent);
                FragmentUtilAct.startAct(getActivity(), new SignInFrag(false));

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
//                String token = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
//                if (!token.equals(SPConstants.SP_NULL)) {
//                    getUserInfo(token);
//                } else {
//                    startActivity(new Intent(getContext(), LoginActivity.class));
//                }
                checkLoginInfo();
                break;
            case R.id.iv_img:  //头像
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (heandList.size() == 0) {
                    getHeadList();
                } else {
                    setHead();
                }
                break;
            case R.id.left_img:  //左
                lastPosition = isVisBottom(headPopRec);
                if (fristPosition > 0) {
                    fristPosition = fristPosition - 1;
                    lastPosition = lastPosition - 1;
                    headPopRec.scrollToPosition(fristPosition);
                    leftOrrightSyte(headPopRec);
                }
                break;
            case R.id.right_img:  //右
                lastPosition = isVisBottom(headPopRec);
                if (lastPosition < heandList.size() - 1) {
                    lastPosition = lastPosition + 1;
                    if (fristPosition == -1) {
                        fristPosition = 1;
                    } else {
                        fristPosition = fristPosition + 1;
                    }
                    headPopRec.scrollToPosition(lastPosition);
                    leftOrrightSyte(headPopRec);
                }
                break;
            case R.id.clera_tex:  //取消
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.commit_tex:  //确定
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                changeAvatar();
                break;
        }
    }

    private String phoneStr = "";

    /**
     * 更换头像
     */
    private void changeAvatar() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("filename", filename);
        NetUtils.post(Constants.CHANGEAVATAR, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                objectAnimator = ObjectAnimator.ofFloat(ivRefresh, "rotation", 0f, 360f);
                objectAnimator.setDuration(1500);
                objectAnimator.start();
                checkLoginInfo();
            }

            @Override
            public void onError() {
            }
        });
    }

    /**
     * 获取头像例表
     */
    private void getHeadList() {
        NetUtils.get(Constants.AVATARLIST, "", true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                heandBean = Uiutils.stringToObject(object, HeandBean.class);
                if (null != heandBean && null != heandBean.getData() && heandBean.getData().size() > 0) {
                    heandList.addAll(heandBean.getData());
                    setHead();
                }
            }

            @Override
            public void onError() {
            }
        });

    }

    private void setHead() {
        phoneView = LayoutInflater.from(getContext()).inflate(R.layout.head_preview_pop_lay, null);
        setPopView();
        popupWindowBuilder = Uiutils.setPopSetting(getContext(), phoneView, ViewGroup.LayoutParams.
                        MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT, true,
                true, 05f);

        mCustomPopWindow = popupWindowBuilder.create();
        mCustomPopWindow.showAtLocation(phoneView, Gravity.BOTTOM, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    /**
     * 改头像pop
     */
    private void setPopView() {
        headImg = phoneView.findViewById(R.id.head_img);
        headPopRec = phoneView.findViewById(R.id.head_pop_rec);
        leftImg = phoneView.findViewById(R.id.left_img);
        rightImg = phoneView.findViewById(R.id.right_img);

        ImageLoadUtil.ImageLoad(getContext(), ShareUtils.getString(getContext(), SPConstants.AVATAR
                , ""), headImg, R.drawable.head);

        leftImg.setOnClickListener(this);
        rightImg.setOnClickListener(this);
        phoneView.findViewById(R.id.commit_tex).setOnClickListener(this);
        phoneView.findViewById(R.id.clera_tex).setOnClickListener(this);

        Uiutils.setRec(getContext(), headPopRec, 1, true);
        heandAdapter = new HeandAdapter(getContext(), heandList, R.layout.image_lay);
        headPopRec.setAdapter(heandAdapter);
        heandAdapter.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {
                heandUrl = heandList.get(position).getUrl();
                ImageLoadUtil.ImageLoad(getContext(), heandUrl,
                        headImg);
                filename = heandList.get(position).getFilename();
            }
        });
        headPopRec.addOnScrollListener(onScrollListener);
    }

    /**
     * 当前位置
     *
     * @param recyclerView
     * @return
     */
    public int isVisBottom(RecyclerView recyclerView) {
        LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
        int lastVisibleItemPosition = layoutManager.findLastVisibleItemPosition(); //屏幕中最后一个可见子项的position
        return lastVisibleItemPosition;
    }

    /**
     * 滑动事件
     */
    private RecyclerView.OnScrollListener onScrollListener = new RecyclerView.OnScrollListener() {
        @Override
        public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
            //当前状态为停止滑动状态SCROLL_STATE_IDLE时
            if (newState == RecyclerView.SCROLL_STATE_IDLE) {
                RecyclerView.LayoutManager layoutManager = recyclerView.getLayoutManager();
                lastPosition = ((LinearLayoutManager) layoutManager).findLastVisibleItemPosition();
                fristPosition = ((LinearLayoutManager) layoutManager).findFirstVisibleItemPosition();
                leftOrrightSyte(recyclerView);
            }
        }

        @Override
        public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
        }
    };

    /**
     * 滑动改样式
     *
     * @param recyclerView
     */
    private void leftOrrightSyte(@NotNull RecyclerView recyclerView) {
        if (lastPosition == recyclerView.getLayoutManager().getItemCount() - 1) {
            ImageLoadUtil.ImageLoad(getContext(), R.drawable.return_ash_right, rightImg);
        } else {
            ImageLoadUtil.ImageLoad(getContext(), R.drawable.return_back_right, rightImg);
        }
        if (fristPosition > 0) {
            ImageLoadUtil.ImageLoad(getContext(), R.drawable.return_back_left, leftImg);
        } else {
            ImageLoadUtil.ImageLoad(getContext(), R.drawable.return_ash_left, leftImg);
        }
    }

    private void checkLoginInfo() {
        String token = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
        if (!token.equals(SPConstants.SP_NULL)) {
            getUserInfo(token);
            if (!Uiutils.isTourist1(getActivity())){
                transferStatus();
            }

        } else {
//            startActivity(new Intent(getContext(), LoginActivity.class));
            Uiutils.login(getContext());
        }
    }

    //额度转换
    private void transferStatus() {
        String token = SPConstants.getToken(getContext());
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.CHECKTRANSFERSTATUS + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken()))
                .tag(this)
                .execute(new NetDialogCallBack(getContext(), true, MyFragment.this, true, ToTransferBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        Log.e("response==", o + "?");
                        ToTransferBean trans = (ToTransferBean) o;
                        if (trans != null && trans.getCode() == 0 && trans.getData() != null) {
                            if (trans.getData().isNeedToTransferOut()) {
                                hintDialog(getActivity(), "真人游戏正在进行或有余额未成功转出，请确认是否需要转出游戏余额", token);
                            }
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        Log.e("response==", bb.toString() + "?");
                    }

                    @Override
                    public void onFailed(Response<String> response) {
                        Log.e("response==", response.body() + "?");
                    }
                });

    }

    public void hintDialog(Activity activity, String cont, String token) {
        String title = "提示信息";
        String content = cont;
        String[] array = activity.getResources().getStringArray(R.array.affirm_change);
        TDialog mTDialog = new TDialog(activity, TDialog.Style.Center, array, title, content, "", new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int position) {
                if (position == 1) {
                    getAutotransferout(token);
                }
            }
        });
        mTDialog.setCancelable(false);
        mTDialog.show();

    }

    private void getAutotransferout(String token) {
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.AUTOTRANSFEROUT + (Constants.ENCRYPT ? Constants.SIGN : "")))
                .params("token", SecretUtils.DESede(token))
                .params("sign", SecretUtils.RsaToken())//
                .execute(new NetDialogCallBack(getContext(), true, MyFragment.this, true, ToTransferBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        ToTransferBean base = (ToTransferBean) o;
                        if (base != null && base.getCode() == 0) {
                            ToastUtil.toastShortShow(getContext(), "转出成功");
                            checkLoginInfo();
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
