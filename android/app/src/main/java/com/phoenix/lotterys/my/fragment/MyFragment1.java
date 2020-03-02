package com.phoenix.lotterys.my.fragment;

import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.TypedArray;
import android.os.Bundle;
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
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.home.fragment.BankManageFrament;
import com.phoenix.lotterys.home.fragment.TransferFrament;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.DepositActivity;
import com.phoenix.lotterys.my.activity.InterestDoteyActivity;
import com.phoenix.lotterys.my.adapter.HeandAdapter;
import com.phoenix.lotterys.my.adapter.MyFragAdapter1;
import com.phoenix.lotterys.my.adapter.MyFragAdapter2;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.HeandBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.ToTransferBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.IntentUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.MyNestedScrollView;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
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
 * 文件描述:  个人中心(主提之一)
 * 创建者: IAN
 * 创建时间: 2019/9/25 13:44
 */
@SuppressLint("ValidFragment")
public class MyFragment1 extends BaseFragment implements View.OnClickListener {
    //    @BindView(R2.id.main_tex)
//    TextView mainTex;
//    @BindView(R2.id.d_wave)
//    DynamicWave dWave;
    @BindView(R2.id.iv_img)
    ImageView ivImg;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_userParentId)
    TextView tvUserParentId;
    @BindView(R2.id.tv_money)
    TextView tvMoney;
    @BindView(R2.id.iv_refresh)
    ImageView ivRefresh;
    @BindView(R2.id.tv_integral)
    TextView tvIntegral;
    @BindView(R2.id.ll_user)
    LinearLayout llUser;
    @BindView(R2.id.tv_taskreward)
    TextView tvTaskreward;
    @BindView(R2.id.rl_userInfo)
    RelativeLayout rlUserInfo;
    @BindView(R2.id.tv_grow)
    TextView tvGrow;
    @BindView(R2.id.iv_task)
    ImageView ivTask;
    @BindView(R2.id.ll_level)
    LinearLayout llLevel;
    @BindView(R2.id.tv_level)
    TextView tvLevel;
    @BindView(R2.id.progress1)
    ProgressBar progress1;
    @BindView(R2.id.tv_next_level)
    TextView tvNextLevel;
    @BindView(R2.id.progress_lin)
    LinearLayout progressLin;
    @BindView(R2.id.iv_sign)
    ImageView ivSign;
    @BindView(R2.id.lin_tex)
    TextView linTex;
    @BindView(R2.id.recharge_record_tex)
    TextView rechargeRecordTex;
    @BindView(R2.id.withdrawal_record_tex)
    TextView withdrawalRecordTex;
    @BindView(R2.id.betting_record_tex)
    TextView bettingRecordTex;
    @BindView(R2.id.customer_tex)
    TextView customerTex;
    @BindView(R2.id.record_tab_lin)
    LinearLayout recordTabLin;
    @BindView(R2.id.rv)
    RecyclerView rv;
    @BindView(R2.id.main_lin)
    RelativeLayout mainLin;
    @BindView(R2.id.grow_up_lin)
    LinearLayout growUpLin;
    @BindView(R2.id.grow_up_rel)
    RelativeLayout growUpRel;
    @BindView(R2.id.tv_money1)
    TextView tvMoney1;
    @BindView(R2.id.iv_refresh1)
    ImageView ivRefresh1;
    @BindView(R2.id.recharge_tex)
    TextView rechargeTex;
    @BindView(R2.id.deposit_tex)
    TextView depositTex;
    @BindView(R2.id.line_conversion_tex)
    TextView lineConversionTex;
    @BindView(R2.id.user_money_lin)
    LinearLayout userMoneyLin;
    @BindView(R2.id.ma_lin)
    MyNestedScrollView maLin;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.iv_imgchange)
    ImageView ivImgchange;

    @SuppressLint("ValidFragment")
    public MyFragment1(boolean isHide) {
        super(R.layout.fragment_my1, true, true);
        this.isHide = isHide;
    }

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
    private MyFragAdapter1 adapter;
    private MyFragAdapter2 adapter2;
    MainActivity mActivity;
    List<My_item> list = new ArrayList<>();
    boolean isHide = false;

    public static MyFragment1 getInstance() {
        return new MyFragment1(true);
    }

    private ConfigBean configBean;

    @Override
    public void initView(View view) {
        if(isHide){
            if (getActivity() instanceof MainActivity) {
                mActivity = (MainActivity) getActivity();
            }
        }
//        dWave.setVisibility(View.GONE);
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);

        initialProject();


        Log.e("configBean==", configBean + "");
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance());   //明文
        tvMoney1.setTransformationMethod(HideReturnsTransformationMethod.getInstance());   //明文
        ivRefresh.setVisibility(View.VISIBLE);

        if (!StringUtils.isEmpty(ShareUtils.getString(getContext(), "themetyp", ""))) {

            switch (ShareUtils.getString(getContext(), "themetyp", "")) {

                case "0":
//                    userMoneyLin.setVisibility(View.GONE);
                    recordTabLin.setVisibility(View.GONE);
                    LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) rv.getLayoutParams();
                    lp.leftMargin = 0;
                    lp.rightMargin = 0;
                    rv.setLayoutParams(lp);
                    rv.setBackground(null);
                    linTex.setBackgroundColor(getResources().getColor(R.color.my_line));
                    if (list.size()==0){
                        initdata(1);
                    }else{
                        initdata1(1);
                    }
                    userMoneyLin.setVisibility(View.GONE);
                    break;
                case "2":
                    recordTabLin.setVisibility(View.GONE);
                    initdataNew();
                    break;
                case "3":
                    if (list.size()==0){
                        initdata(0);
                    }else{
                        initdata1(1);
                    }
                    break;
            }
        }

        checkLoginInfo();
        isVisible = true;

        if (null != userInfo && null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData()
                .getAvatar())) {
            ImageLoadUtil.loadRoundImage0(ivImg,
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


        if (null == configBean || null == configBean.getData()) {
        } else if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                .getMissionSwitch())) {
            llLevel.setVisibility(View.VISIBLE);
            progressLin.setVisibility(View.VISIBLE);
            tvTaskreward.setVisibility(View.VISIBLE);
            if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                    .getCheckinSwitch()) && StringUtils.equals("1", configBean.getData()
                    .getCheckinSwitch())) {
                ivSign.setVisibility(View.VISIBLE);
            } else if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                    .getCheckinSwitch()) && StringUtils.equals("0", configBean.getData()
                    .getCheckinSwitch())) {
                ivSign.setVisibility(View.INVISIBLE);
            }
        } else {
            ivSign.setVisibility(View.INVISIBLE);
            tvTaskreward.setVisibility(View.GONE);
            removeItem("rwzx");
        }
        setSytpe();

        if (0 != ShareUtils.getInt(getContext(), "ba_top", 0)) {
            mainLin.setBackgroundColor(getContext().getResources().getColor(
                    ShareUtils.getInt(getContext(), "ba_top", R.color.colorAccent)));
        }

        setba();

        try {
            userInfo();
        } catch (Exception e) {
            e.printStackTrace();
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

    if(BuildConfig.FLAVOR.equals("c134"))
        ivImgchange.setVisibility(View.VISIBLE);

    }

    //    private List<My_item> listPre =new ArrayList<>();
    private void initialProject() {
        if (null!=configBean&&null!=configBean.getData()&&null!=configBean.getData().getUserCenter()
                &&configBean.getData().getUserCenter().size()>0){
            for (ConfigBean.DataBean.MobileMenuBean mobileMenuBean :configBean.getData().getUserCenter()){
                switch (mobileMenuBean.getCode()){
                    case "1" :
                        addListPrc(mobileMenuBean.getName(),"ck",R.mipmap.ck,mobileMenuBean.getLogo());
                        break;
                    case "2" :
                        addListPrc(mobileMenuBean.getName(),"qk",R.mipmap.qk,mobileMenuBean.getLogo());
                        break;
                    case "3" :
                        addListPrc(mobileMenuBean.getName(),"yhkgl",R.mipmap.yhkgl,mobileMenuBean.getLogo());
                        break;
                    case "4" :
                        addListPrc(mobileMenuBean.getName(),"lxb",R.mipmap.lxb_sele,mobileMenuBean.getLogo());
                        break;
                    case "5" :
                        addListPrc(mobileMenuBean.getName(),"sytj",R.mipmap.tjsy,mobileMenuBean.getLogo());
                        break;
                    case "6" :
                        addListPrc(mobileMenuBean.getName(),"cpzdjl",R.mipmap.zdjl,mobileMenuBean.getLogo());
                        break;
                    case "7" :
                        addListPrc(mobileMenuBean.getName(),"qtzdjl",R.mipmap.zdjl,mobileMenuBean.getLogo());
                        break;
                    case "8" :
                        addListPrc(mobileMenuBean.getName(),"edzh",R.mipmap.edzh,mobileMenuBean.getLogo());
                        break;
                    case "9" :
                        addListPrc(mobileMenuBean.getName(),"znx",R.mipmap.znx,mobileMenuBean.getLogo());
                        break;
                    case "10" :
                        addListPrc(mobileMenuBean.getName(),"aqzx",R.mipmap.aqzx,mobileMenuBean.getLogo());
                        break;
                    case "11" :
                        addListPrc(mobileMenuBean.getName(),"rwzx",R.mipmap.rwzx,mobileMenuBean.getLogo());
                        break;
                    case "12" :
                        addListPrc(mobileMenuBean.getName(),"grxx",R.mipmap.userinfo,mobileMenuBean.getLogo());
                        break;
                    case "13" :
                        addListPrc(mobileMenuBean.getName(),"jyfk",R.mipmap.jyfk,mobileMenuBean.getLogo());
                        break;
                    case "14" :
                        addListPrc(mobileMenuBean.getName(),"zxkf",R.mipmap.zxkf,mobileMenuBean.getLogo());
                        break;
                    case "15" :
                        addListPrc(mobileMenuBean.getName(),"hdsg",R.mipmap.handsel,mobileMenuBean.getLogo());
                        break;
                    case "16" :
                        addListPrc(mobileMenuBean.getName(),"clzs",R.mipmap.clzs,mobileMenuBean.getLogo());
                        break;
                    case "17" :
                        addListPrc(mobileMenuBean.getName(),"qmjc",R.mipmap.qmjc,mobileMenuBean.getLogo());
                        break;
                    case "18" :
                        addListPrc(mobileMenuBean.getName(),"kgzs",R.mipmap.kgzs,mobileMenuBean.getLogo());
                        break;
                    case "19" :
                        addListPrc(mobileMenuBean.getName(),"",R.drawable.application_agency_qq,mobileMenuBean.getLogo());
                        break;
                        default:
                            addListPrc(mobileMenuBean.getName(),"",0,mobileMenuBean.getLogo());
                            break;
                }
            }
        }
    }

    private void addListPrc(String name ,String alias ,int img ,String logo) {
        My_item my_item =new My_item();
        my_item.setTitle(name);
        my_item.setAlias(alias);
        my_item.setImg(img);
        my_item.setLogo(logo);
        list.add(my_item);
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

    private boolean haveItem(String str) {
        if (list.size() > 0)
            for (int i = 0; i < list.size(); i++) {
                if (StringUtils.equals(str, list.get(i).getAlias())) {
                    return true;
                }
            }

        return false;
    }

    private void userInfo() {
        if (isVisible) {
            //积分
            String taskRewardTitle = SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARDTITLE);
            String taskRewardValue = SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARD);
            tvTaskreward.setText(taskRewardTitle + ":\n" + taskRewardValue);
            //等级
            String levelGrade = SPConstants.getValue(getContext(), SPConstants.SP_CURLEVELGRADE);
            String nextLevelGrade = SPConstants.getValue(getContext(), SPConstants.SP_NEXTLEVELGRADE);
            tvUserParentId.setText(levelGrade + " ");
//            setLecel(levelGrade, nextLevelGrade);
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
//            tvMoney.setText(SPConstants.getValue(getContext(), SPConstants.SP_BALANCE));
            tvMoney.setText(userInfo.getData().getBalance() == null ? "" : userInfo.getData().getBalance());
            tvMoney1.setText(userInfo.getData().getBalance() == null ? "" : userInfo.getData().getBalance());
//            tvMoney1.setText(SPConstants.getValue(getContext(), SPConstants.SP_BALANCE));
//            String curlevelint = SPConstants.getValue(getContext(), SPConstants.SP_CURLEVELINT);
            String nextlevelint = SPConstants.getValue(getContext(), SPConstants.SP_NEXTLEVELINT);
            String taskReward = SPConstants.getValue(getContext(), SPConstants.SP_TASKREWARDTOTAL);
            String temp = ShowItem.subZeroAndDot(taskReward.equals("Null") ? "0" : taskReward);
            //成长值
            if (ShowItem.isNumeric(nextlevelint) || ShowItem.isNumeric(temp)) {
                double d = Double.parseDouble(temp);
                int reward = (int) d;
                int m = 0;
                if (!StringUtils.isEmpty(nextlevelint))
                    m = Integer.parseInt(nextlevelint.equals("Null") ? "0" : ShowItem.subZeroAndDot(nextlevelint));
                progress1.setMax(m);
                progress1.setProgress(reward);
                tvGrow.setText("成长值(" + ShowItem.subZeroAndDot(d + "") + " - " + ShowItem.subZeroAndDot(m + "") + ")");
            }

            Log.e("userinfomy1", "userinfo111");
            if (null != themeList && themeList.size() > 0) {
                for (List<My_item> list : themeList) {
                    if (null != list && list.size() > 0) {
                        for (My_item my_item : list) {
                            if (StringUtils.equals(my_item.getAlias(), "znx")) {

                                userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
                                if (userInfo != null && userInfo.getData() != null) {
                                    my_item.setMess(userInfo.getData().getUnreadMsg() + "");
                                }
                                if (null != adapter2)
                                    adapter2.notifyDataSetChanged();
                                break;
                            }
                        }
                    }
                }
            } else {
                if (list != null && list.size() > 0 && adapter != null) {
                    userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
                    for (int i = 0; i < list.size(); i++) {
                        if (list.get(i).getAlias().equals("znx")) {
                            if (userInfo != null && userInfo.getData() != null) {
                                list.get(i).setMess(userInfo.getData().getUnreadMsg() + "");
                            }else{
                                list.get(i).setMess("0");
                            }
                        }else{
                            list.get(i).setMess("0");
                        }
                    }
                    adapter.notifyDataSetChanged();
                }
            }
        }
        zxkfurl = SPConstants.getValue(getContext(), SPConstants.SP_ZXKFURL);
    }

    private UserInfo userInfo;

    //获取登录信息
    private void getUserInfo(String s) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(s) + "&sign=" + SecretUtils.RsaToken())).tag(this).execute(new NetDialogCallBack(getContext(), true, MyFragment1.this, true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                Log.e("response==", o + "?");
                userInfo = (UserInfo) o;
                if (userInfo != null && userInfo.getCode() == 0) {
                    SharedPreferences.Editor edit = sp.edit();
                    edit.putString(SPConstants.SP_BALANCE, FormatNum.amountFormat(userInfo.getData().getBalance(), 4));   //金额
                    edit.putString(SPConstants.SP_USR, userInfo.getData().getUsr());
                    edit.putString(SPConstants.SP_CURLEVELGRADE, userInfo.getData().getCurLevelGrade());
                    edit.putString(SPConstants.SP_NEXTLEVELGRADE, userInfo.getData().getNextLevelGrade());
                    edit.putString(SPConstants.SP_CURLEVELINT, userInfo.getData().getCurLevelInt());
                    edit.putString(SPConstants.SP_NEXTLEVELINT, userInfo.getData().getNextLevelInt());
                    edit.putString(SPConstants.SP_TASKREWARDTITLE, userInfo.getData().getTaskRewardTitle());
                    edit.putString(SPConstants.SP_TASKREWARDTOTAL, userInfo.getData().getTaskRewardTotal());
                    edit.putString(SPConstants.SP_TASKREWARD, userInfo.getData().getTaskReward());
                    edit.putString(SPConstants.SP_HASBANKCARD, userInfo.getData().isHasBankCard() + "");
                    edit.putString(SPConstants.SP_HASFUNDPWD, userInfo.getData().isHasFundPwd() + "");
                    edit.putString(SPConstants.SP_ISTEST, userInfo.getData().isIsTest() + "");
                    edit.putString(SPConstants.SP_UNREADMSG, userInfo.getData().getUnreadMsg() + "");
                    //头像
                    edit.putString(SPConstants.AVATAR, userInfo.getData().getAvatar());
                    edit.putString(SPConstants.SP_CURLEVELTITLE, userInfo.getData().getCurLevelTitle());
                    edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, userInfo.getData().isYuebaoSwitch());

                    edit.commit();

                    ShareUtils.saveObject(getContext(), SPConstants.USERINFO, userInfo);
                    EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                    setSytpe();
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
            if (!StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))&&list.size()>0) {
                setListItemNmae(list,"sytj","收益推荐");
            }else if (StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))&&themeList.size()>0){
                setListItemNmae(themeList.get(0),"sytj","收益推荐");
            }
        } else {
            if (!StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))&&list.size()>0) {
                setListItemNmae(list,"sytj","申请代理");
            }else if (StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))&&themeList.size()>0){
                setListItemNmae(themeList.get(0),"sytj","申请代理");
            }
        }

        if (null == userInfo || null == userInfo.getData() ){ }
        else if ( !userInfo.getData().isHasActLottery()) {
            if (StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))){
                if (themeList.size()>0){
                    if (themeList.get(0).size()>2){
                        if (StringUtils.equals("hdsg",themeList.get(0).get(themeList.get(0).size()-2).getAlias())){
                            themeList.get(0).remove(themeList.get(0).get(themeList.get(0).size()-2));

                            if (null != adapter2)
                                adapter2.notifyDataSetChanged();
                        }
                    }
                }
            }else{
                if (list.size()>0){
                    removeItem("hdsg");
                }
            }
        }else if (userInfo.getData().isHasActLottery()){
            if (StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))){

                if (themeList.size()>0){
                    if (themeList.get(0).size()>2){
                        if (!StringUtils.equals("hdsg",themeList.get(0).get(themeList.get(0).size()-2).getAlias())){
                            themeList.get(0).add(themeList.get(0).size()-2,
                                    new My_item(R.mipmap.handsel,"活动彩金", "hdsg"));

                            if (null != adapter2)
                                adapter2.notifyDataSetChanged();
                        }
                    }
                }

            }else{
                if (list.size()>0){
                    if (!haveItem("hdsg")){
//                        if (Uiutils.isSite("c001")){
////                            if (Uiutils.isSite("c083")){
//                            if (StringUtils.equals("lxb",list.get(0).getAlias())){
//                                list.add(1, new My_item(R.mipmap.handsel,"活动彩金", "hdsg"));
//                            }else{
//                                list.add( 0,new My_item(R.mipmap.handsel,"活动彩金", "hdsg"));
//                            }
//                        }else{
                        list.add( new My_item(R.mipmap.handsel,"活动彩金", "hdsg"));
//                        }

                    }
                }
            }
        }


    }

    private void setListItemNmae(List<My_item> list,String alias ,String name) {
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getAlias().equals(alias)) {
                list.get(i).setTitle(name);
            }
        }
    }


    @Subscribe(sticky = true)
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("userinfo")) {
            userInfo();
            updataYuebao();
//            Log.e("userinfomy1", "userinfo");
        } else if (messageEvent.getMessage().equals("config")) {
            updataYuebao();
            userInfo();
//            Log.e("configmy1", "config");
        }
    }

    private void updataYuebao() {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());

        if (list.size() > 0) {
            if (!yuebaoshutdown) {
                if (haveItem("lxb"))
                    removeItem("lxb");
            }else{
                if (!haveItem("lxb"))
                    list.add( new My_item(R.mipmap.lxb_sele, yuebaoName.equals("Null") ? "利息宝" : yuebaoName, "lxb"));
            }
//                if (list != null) {
//                    for (int i = 0; i < list.size(); i++) {
//                        if (list.get(i).getAlias().equals("lxb")) {
//                            list.remove(i);
//                        }
//                    }
//                }
//                if (haveItem("lxb"))
//                removeItem("lxb");
//
//                if (adapter != null)
//                    adapter.notifyDataSetChanged();
//            } else if (yuebaoshutdown && list != null && list.size() >= 3 && adapter != null) {
//                if (Uiutils.isSite("c001")) {
////                    if (Uiutils.isSite("c083")) {
//                    if (list.get(0).getAlias().equals("lxb")) {
//                        if (!TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
//                            list.get(0).setTitle(yuebaoName);
//                        } else {
//                            list.get(0).setTitle("利息宝");
//                        }
//                    } else {
//                        list.add(0, new My_item(R.mipmap.lxb_sele, yuebaoName.equals("Null") ? "利息宝" : yuebaoName, "lxb"));
//                    }
//                adapter.notifyDataSetChanged();
//                } else {
//                    if (list.get(2).getAlias().equals("lxb")) {
//                        if (!TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
//                            list.get(2).setTitle(yuebaoName);
//                        } else {
//                            list.get(2).setTitle("利息宝");
//                        }
//                    } else {
//                        list.add(2, new My_item(R.mipmap.lxb_sele, yuebaoName.equals("Null") ? "利息宝" : yuebaoName, "lxb"));
//                    }
//                    adapter.notifyDataSetChanged();
//                }
//            }
        } else if (themeList.size() > 0 && themeList.size() > 1) {
            if (!yuebaoshutdown) {
                if (themeList.get(0) != null && themeList.get(0).size() > 0) {
                    for (int i = 0; i < themeList.get(0).size(); i++) {
                        if (themeList.get(0).get(i).getAlias().equals("lxb")) {
                            themeList.get(0).remove(i);
                        }
                    }
                }
            } else {
                if (themeList.get(0).get(0).getAlias().equals("lxb")) {
                    if (!TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
                        themeList.get(0).get(0).setTitle(yuebaoName);
                    } else {
                        themeList.get(0).get(0).setTitle("利息宝");
                    }
                } else {
                    themeList.get(0).add(0, new My_item(R.mipmap.lxb_sele, yuebaoName.equals("Null") ? "利息宝" : yuebaoName, "lxb"));
                }
            }
            if (adapter2 != null)
                adapter2.notifyDataSetChanged();
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
                            ImageLoadUtil.loadRoundImage0(ivImg,
                                    userInfo.getData()
                                            .getAvatar(), 0);
                        }
                    } else {
                        ImageLoadUtil.loadRoundImage0(ivImg,
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
                Log.e("myf1", "getEvenMsg");
                setba();

                if (null == configBean || null == configBean.getData()) {
                } else if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                        .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                        .getMissionSwitch())) {
                    llLevel.setVisibility(View.VISIBLE);
                    progressLin.setVisibility(View.VISIBLE);
                    tvTaskreward.setVisibility(View.VISIBLE);
                } else {
                    ivSign.setVisibility(View.INVISIBLE);
                    tvTaskreward.setVisibility(View.GONE);
//                    removeItem("rwzx");
                }
                break;
        }
    }

    private void setba() {
        if (0 != ShareUtils.getInt(getContext(), "ba_top", 0)) {
            mainLin.setBackgroundColor(getResources().getColor(
                    ShareUtils.getInt(getContext(), "ba_top", 0)));
            titlebar.setBackgroundColor(getResources().getColor(
                    ShareUtils.getInt(getContext(), "ba_top", 0)));
        }
        Uiutils.setMyBa(getContext(),maLin);

        Uiutils.setBarStye0(titlebar,getContext());
    }


    protected void onTransformResume() {
        userInfo();
    }

    boolean isShow = false;

    private String[] title;
    private String[] titleAlias;
    private TypedArray icons;


    private String[] themeName1;
    private String[] themeAlias1;
    private TypedArray themeImg1;
    private String[] themeName2;
    private String[] themeAlias2;
    private TypedArray themeImg2;
    private String[] themeName3;
    private String[] themeAlias3;
    private TypedArray themeImg3;
    private String[] themeName4;
    private String[] themeAlias4;
    private TypedArray themeImg4;
    private String[] themeName5;
    private String[] themeAlias5;
    private TypedArray themeImg5;

    private List<List<My_item>> themeList = new ArrayList<>();

    private void initdataNew() {
        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());

        themeName1 = getResources().getStringArray(R.array.myf_theme_1);
        themeAlias1 = getResources().getStringArray(R.array.myf_theme_alias_1);
        themeImg1 = getResources().obtainTypedArray(R.array.myf_theme_img_1);

        themeName2 = getResources().getStringArray(R.array.myf_theme_2);
        themeAlias2 = getResources().getStringArray(R.array.myf_theme_alias_2);
        themeImg2 = getResources().obtainTypedArray(R.array.myf_theme_img_2);

        themeName3 = getResources().getStringArray(R.array.myf_theme_3);
        themeAlias3 = getResources().getStringArray(R.array.myf_theme_alias_3);
        themeImg3 = getResources().obtainTypedArray(R.array.myf_theme_img_3);

        themeName4 = getResources().getStringArray(R.array.myf_theme_4);
        themeAlias4 = getResources().getStringArray(R.array.myf_theme_alias_4);
        themeImg4 = getResources().obtainTypedArray(R.array.myf_theme_img_4);

        themeName5 = getResources().getStringArray(R.array.myf_theme_5);
        themeAlias5 = getResources().getStringArray(R.array.myf_theme_alias_5);
        themeImg5 = getResources().obtainTypedArray(R.array.myf_theme_img_5);

        addThemeData(themeName1, themeAlias1, themeImg1);
        addThemeData(themeName2, themeAlias2, themeImg2);
        addThemeData(themeName3, themeAlias3, themeImg3);
        addThemeData(themeName4, themeAlias4, themeImg4);
        addThemeData(themeName5, themeAlias5, themeImg5);

        Uiutils.setRec(getContext(), rv, 1);
        Uiutils.setBa(getContext(),rv);
        adapter2 = new MyFragAdapter2(getContext(), themeList, R.layout.my_frag_adapter2, onItemClickListener);
        rv.setAdapter(adapter2);
    }

    private void addThemeData(String[] name, String[] alias, TypedArray img) {
        List<My_item> list1 = new ArrayList<>();
        for (int i = 0; i < name.length; i++) {
            if (StringUtils.equals("rwzx", alias[i])) {
                if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                        .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                        .getMissionSwitch())) {
                } else {
                    continue;
                }
            }
            if (StringUtils.equals("hdsg", alias[i])) {
                if (null != userInfo && null != userInfo.getData() && !userInfo.getData().isHasActLottery()) {
                    continue;
                }
            }
            if (StringUtils.equals("lxb", alias[i])) {
                boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());
                String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
                if (!yuebaoshutdown) {
                    continue;
                }
                if (yuebaoshutdown && !TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
                    list1.add(new My_item(img.getResourceId(i, 0), yuebaoName, alias[i]));
                } else if (yuebaoshutdown) {
                    list1.add(new My_item(img.getResourceId(i, 0), name[i], alias[i]));
                }
            } else if (StringUtils.equals("jcxbb", alias[i])) {
                list1.add(new My_item(img.getResourceId(i, 0), "版本号(" + APKVersionCodeUtils.
                        getVerName(getContext()) + ")", alias[i]));
            } else if (StringUtils.equals("sytj", alias[i])) {
                if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
                    list1.add(new My_item(img.getResourceId(i, 0), name[i], alias[i]));
                } else {
                    list1.add(new My_item(img.getResourceId(i, 0), "申请代理", alias[i]));
                }
            } else if (StringUtils.equals("znx", alias[i])) {
                My_item my_item = new My_item(img.getResourceId(i, 0), name[i], alias[i]);
                my_item.setMess(SPConstants.getValue(getContext(), SPConstants.SP_UNREADMSG).
                        equals("NUll") ? "0" : SPConstants.getValue(getContext(), SPConstants.SP_UNREADMSG));

                list1.add(my_item);
            } else {
                list1.add(new My_item(img.getResourceId(i, 0), name[i], alias[i]));
            }
        }
        themeList.add(list1);

    }

    private void initdata(int type) {
        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());
        if (Uiutils.isSite("c001")){
//            if (Uiutils.isSite("c083")){
            title = getResources().getStringArray(R.array.my_list0);
            titleAlias = getResources().getStringArray(R.array.my_list_alias0);
            icons = getResources().obtainTypedArray(R.array.my_img_list0);
        }else{
            title = getResources().getStringArray(R.array.my_list);
            titleAlias = getResources().getStringArray(R.array.my_list_alias);
            icons = getResources().obtainTypedArray(R.array.my_img_list);
        }
        title = getResources().getStringArray(R.array.my_list);
        titleAlias = getResources().getStringArray(R.array.my_list_alias);
        icons = getResources().obtainTypedArray(R.array.my_img_list);
        for (int i = 0; i < title.length; i++) {
            if (StringUtils.equals("hdsg", titleAlias[i])) {
                if (null != userInfo && null != userInfo.getData() && !userInfo.getData().isHasActLottery()) {
                    continue;
                }
            }

            if (StringUtils.equals("lxb", titleAlias[i]) && !yuebaoshutdown) {
                isShow = true;
                continue;
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
                item.setTitle("版本号(" + APKVersionCodeUtils.getVerName(getContext()) + ")");
            }
        }
        if (type == 1) {
            Uiutils.setRec(getContext(), rv, 3, R.color.my_line1);
        } else {
            Uiutils.setRec(getContext(), rv, 3, R.color.my_line1);
        }

        adapter = new MyFragAdapter1(getContext(), list, R.layout.my_frag_adapter1, onItemClickListener, type);
        rv.setAdapter(adapter);

    }

    private void initdata1(int type) {
//        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());
//        if (Uiutils.isSite("c001")){
////            if (Uiutils.isSite("c083")){
//            title = getResources().getStringArray(R.array.my_list0);
//            titleAlias = getResources().getStringArray(R.array.my_list_alias0);
//            icons = getResources().obtainTypedArray(R.array.my_img_list0);
//        }else{
//            title = getResources().getStringArray(R.array.my_list);
//            titleAlias = getResources().getStringArray(R.array.my_list_alias);
//            icons = getResources().obtainTypedArray(R.array.my_img_list);
//        }
//        title = getResources().getStringArray(R.array.my_list);
//        titleAlias = getResources().getStringArray(R.array.my_list_alias);
//        icons = getResources().obtainTypedArray(R.array.my_img_list);
//        for (int i = 0; i < list.size(); i++) {
//            if (StringUtils.equals("hdsg", list.get(i).getAlias())) {
//                if (null != userInfo && null != userInfo.getData() && !userInfo.getData().isHasActLottery()) {
//                    continue;
//                }
//            }
//
//            if (StringUtils.equals("lxb", titleAlias[i]) && !yuebaoshutdown) {
//                isShow = true;
//                continue;
//            }
//        }

        if (null != userInfo && null != userInfo.getData() && !userInfo.getData().isHasActLottery()) {
            removeItem("hdsg");
        }

        if (!yuebaoshutdown)
            removeItem("lxb");

        for (My_item item : list) {
            if (item.getAlias().equals("jcxbb")) {
                item.setTitle("版本号(" + APKVersionCodeUtils.getVerName(getContext()) + ")");
            }
        }


        if (type == 1) {
            Uiutils.setRec(getContext(), rv, 3, R.color.my_line1);
        } else {
            Uiutils.setRec(getContext(), rv, 3, R.color.my_line1);
        }

        adapter = new MyFragAdapter1(getContext(), list, R.layout.my_frag_adapter1, onItemClickListener, type);
        rv.setAdapter(adapter);

    }

    private void setLister(My_item my_ite) {
        if (!Uiutils.isFastClick())
            return;
        switch (my_ite.getAlias()) {
            case "ck":  //存款
                setonc(7);
                break;
            case "qk":   //取款
                setonc(8);
                break;
            case "zxkf":   //在线客服
                setonc(9);
                break;
            case "yhkgl":  //银行卡管理
                setonc(10);
                break;
            case "lxb": //利息宝
                setonc(11);
                break;
            case "edzh":  //额度转换
                setonc(12);
                break;
            case "sytj":  // 推荐收益
                setonc(13);
                break;
            case "aqzx":  //安全中心
                setonc(14);
                break;
            case "znx":  //站内信
                setonc(15);
                break;
            case "cpzdjl":  //彩票注单记录
                setonc(16);
                break;
            case "qtzdjl":  //注单记录
                setonc(17);
                break;
            case "jyfk":  //建议反馈
                setonc(18);
                break;
            case "rwzx":  //任务中心
                setonc(19);
                break;
            case "grxx":  //个人信息
                setonc(20);
                break;
            case "hdsg":  //活动彩金
                setonc(21);
                break;
            case "jcxbb":
//                mActivity.getVersion();
                break;
            case "clzs":  //长龙
                setonc(24);
                break;
            case "qmjc":  //
                setonc(25);
                break;
            case "kgzs":  //
                setonc(25);
                break;
                default:
                    getQQpop();

                        if (listQQ.size()>0){
                        popupWindowBuilder =  new CustomPopWindow.PopupWindowBuilder(getContext())
                                .size( MeasureUtil.dip2px(getContext(), 300),  ViewGroup.LayoutParams.WRAP_CONTENT)
                                .setView(contentView)
                                .enableOutsideTouchableDissmiss(true)
                                .enableBackgroundDark(true)
                                .setBgDarkAlpha(0.5f); // 控制亮度

                        mCustomPopWindow = popupWindowBuilder.create();
                        mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                            Uiutils.setStateColor(getActivity());
//                        SkipGameUtil.SkipNavig("7", "11", "", getContext(), "", "", "");
                    }else{
                            Log.e("dd","///");
                        ToastUtil.toastShortShow(getContext(),"暂无QQ客服,敬请期待");
                        return;
                    }

                    break;
        }
    }

    private  List<String> listQQ=new ArrayList<>();

    private void getQQpop() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop, null);
        contentView.findViewById(R.id.clear_tex).setOnClickListener(this);
        contentView.findViewById(R.id.commit_tex).setVisibility(View.GONE);
        ((TextView) contentView.findViewById(R.id.title_tex)).setText("请选择QQ客服");
        contextTex = ((TextView) contentView.findViewById(R.id.context_tex));
        contextTex1 = ((TextView) contentView.findViewById(R.id.context_tex2));
        contextTex2 = ((TextView) contentView.findViewById(R.id.context_tex3));

        contextTex.setTextColor(getContext().getResources().getColor(ShareUtils.getInt(getContext(),"ba_top",0)));
        contextTex1.setTextColor(getContext().getResources().getColor(ShareUtils.getInt(getContext(),"ba_top",0)));
        contextTex2.setTextColor(getContext().getResources().getColor(ShareUtils.getInt(getContext(),"ba_top",0)));

        contextTex.setOnClickListener(this);
        contextTex1.setOnClickListener(this);
        contextTex2.setOnClickListener(this);

        if (listQQ.size()>0)
            listQQ.clear();

        if (null!=configBean&&null!=configBean.getData()){
            if (!StringUtils.isEmpty(configBean.getData().getServiceQQ1().trim())){
                listQQ.add(configBean.getData().getServiceQQ1());
            }
            if (!StringUtils.isEmpty(configBean.getData().getServiceQQ2().trim())){
                listQQ.add(configBean.getData().getServiceQQ2());
            }
            if (!StringUtils.isEmpty(configBean.getData().getAppPopupQqNum().trim())){
                listQQ.add(configBean.getData().getAppPopupQqNum());
            }
        }

        if (listQQ.size()>0) {
            for (String qq : listQQ) {
                if (listQQ.size()>0&&StringUtils.equals(qq, listQQ.get(0))) {
                    contextTex.setText("QQ客服1: " + qq);
                    contextTex.setTag(qq);
                }
                if (listQQ.size()>1)
                if (StringUtils.equals(qq, listQQ.get(1))) {
                    contextTex1.setText("QQ客服2: " + qq);
                    contextTex1.setVisibility(View.VISIBLE);
                    contextTex1.setTag(qq);
                }
                if (listQQ.size()>2)
                if (StringUtils.equals(qq, listQQ.get(2))) {
                    contextTex2.setText("QQ客服3: " + qq);
                    contextTex2.setVisibility(View.VISIBLE);
                    contextTex2.setTag(qq);
                }
            }
        }
    }

    private View contentView;
    private TextView contextTex;
    private TextView contextTex1;
    private TextView contextTex2;


    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
    }

    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelTag(this);
        super.onDestroy();
    }

    private boolean isSee = true;

    @OnClick({R.id.iv_task, R.id.iv_sign, R.id.tv_money, R.id.iv_refresh, R.id.iv_img
            , R.id.recharge_record_tex, R.id.withdrawal_record_tex, R.id.betting_record_tex
            , R.id.customer_tex, R.id.iv_refresh1, R.id.recharge_tex, R.id.deposit_tex
            , R.id.line_conversion_tex, R.id.tv_money1, R.id.iv_imgchange})
    public void onClick(View view) {
        Intent intent = null;
        switch (view.getId()) {
            case R.id.iv_task:
                setonc(1);
                break;
            case R.id.iv_sign:  //签到
                setonc(2);
                break;
            case R.id.tv_money:
                setonc(3);
                break;
            case R.id.tv_money1:
                setonc(3);
                break;
            case R.id.iv_refresh:
                setRe(ivRefresh);
                break;
            case R.id.iv_refresh1:
                setRe(ivRefresh1);
                break;
            case R.id.iv_img:  //头像
                setonc(4);
                break;
            case R.id.left_img:  //左
                setonc(5);
                break;
            case R.id.right_img:  //右
                setonc(6);
                break;
            case R.id.clera_tex:  //取消
                if (null!=mCustomPopWindow)
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.commit_tex:  //确定
                if (null!=mCustomPopWindow)
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                changeAvatar();
                break;
            case R.id.recharge_tex:
                setonc(7);
                break;
            case R.id.deposit_tex:
                setonc(8);
                break;
            case R.id.line_conversion_tex:
                setonc(12);
                break;
            case R.id.recharge_record_tex:
                setonc(22);
                break;
            case R.id.withdrawal_record_tex:
                setonc(23);
                break;
            case R.id.betting_record_tex:
                setonc(16);
                break;
            case R.id.customer_tex:
                setonc(9);
                break;

            case R.id.clear_tex:
                if (null!=mCustomPopWindow)
                    mCustomPopWindow.dissmiss();
                break;
            case R.id.context_tex:
                if (null!=contextTex) {
                    String qq = (String) contextTex.getTag();
                    Log.e("qq==",qq+"///");
                    SkipGameUtil.goqq(getContext(),qq);
                }
                if (null!=mCustomPopWindow)
                    mCustomPopWindow.dissmiss();
                break;
            case R.id.context_tex2:
                if (null!=contextTex1) {
                    String qq = (String) contextTex1.getTag();
                    Log.e("qq==",qq+"///");
                    SkipGameUtil.goqq(getContext(),qq);
                }

                if (null!=mCustomPopWindow)
                    mCustomPopWindow.dissmiss();
                break;
            case R.id.context_tex3:
                if (null!=contextTex2) {
                    String qq = (String) contextTex2.getTag();
                    Log.e("qq==",qq+"///");
                    SkipGameUtil.goqq(getContext(),qq);
                }

                if (null!=mCustomPopWindow)
                    mCustomPopWindow.dissmiss();
                break;
            case R.id.iv_imgchange:  //头像
                setonc(4);
                break;
        }
    }

    private void setRe(ImageView view) {
        objectAnimator = ObjectAnimator.ofFloat(view, "rotation", 0f, 360f);
        objectAnimator.setDuration(1500);
        objectAnimator.start();
        checkLoginInfo();
        if (!Uiutils.isTourist1(getActivity())){
            transferStatus();
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
                setRe(ivRefresh);
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

        leftImg.setOnClickListener(this);
        rightImg.setOnClickListener(this);
        phoneView.findViewById(R.id.commit_tex).setOnClickListener(this);
        phoneView.findViewById(R.id.clera_tex).setOnClickListener(this);

        if (!StringUtils.isEmpty(ShareUtils.getString(getContext(), SPConstants.AVATAR
                , "")))
            ImageLoadUtil.loadRoundImage0(headImg, ShareUtils.getString(getContext(), SPConstants.AVATAR
                    , ""),0);

        Uiutils.setRec(getContext(), headPopRec, 1, true);
        heandAdapter = new HeandAdapter(getContext(), heandList, R.layout.image_lay);
        headPopRec.setAdapter(heandAdapter);
        heandAdapter.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {
                heandUrl = heandList.get(position).getUrl();
                ImageLoadUtil.loadRoundImage0(headImg, heandUrl
                        ,0);
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
        } else {
//            startActivity(new Intent(getContext(), LoginActivity.class));
            Uiutils.login(getContext());
        }
    }


    private void setonc(int i) {
        Bundle build;
        switch (i) {
            case 1:  //任务中心
                if (Uiutils.isTourist(getActivity()))
                    return;
                if (getActivity() instanceof FragmentUtilAct) {
                    getActivity().finish();
                }

                FragmentUtilAct.startAct(getActivity(), new MissionCenterFrag(false));
                break;
            case 2:  //签到
                if (Uiutils.isTourist(getActivity()))
                    return;
                FragmentUtilAct.startAct(getActivity(), new SignInFrag(false));
                break;
            case 3:  //钱
                isSee = !isSee;
                if (isSee) {//¥
                    tvMoney.setTransformationMethod(PasswordTransformationMethod.getInstance());   //暗文
                    tvMoney1.setTransformationMethod(PasswordTransformationMethod.getInstance());   //暗文
                    ivRefresh.setVisibility(View.GONE);
                } else {
                    tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance()); //明文
                    tvMoney1.setTransformationMethod(HideReturnsTransformationMethod.getInstance()); //明文
                    ivRefresh.setVisibility(View.VISIBLE);
                }
                break;
            case 4:  //头像
                if (heandList.size() == 0) {
                    getHeadList();
                } else {
                    setHead();
                }
                break;
            case 5:  //左
                lastPosition = isVisBottom(headPopRec);
                if (fristPosition > 0) {
                    fristPosition = fristPosition - 1;
                    lastPosition = lastPosition - 1;
                    headPopRec.scrollToPosition(fristPosition);
                    leftOrrightSyte(headPopRec);
                }
                break;
            case 6:  //左
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
            case 7:  //存款
                if (Uiutils.isTourist(getActivity()))
                    return;
                build = new Bundle();
                build.putString("page", "0");
                IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                break;
            case 8:  //取款
                if (Uiutils.isTourist(getActivity()))
                    return;
                build = new Bundle();
                build.putString("page", "1");
                IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                break;
            case 9:  //在线客服
                if (!TextUtils.isEmpty(zxkfurl)) {
                    Uiutils.goWebView(getContext(), zxkfurl.startsWith("http") ? zxkfurl : "http://" + zxkfurl
                            , "在线客服");

                } else {
                    ToastUtils.ToastUtils("客服地址未配置或获取失败", getContext());
                }
                break;
            case 10:  //银行卡管理
                if (Uiutils.isTourist(getActivity()))
                    return;
//                startActivity(new Intent(getActivity(), BankManageActivity.class));
                FragmentUtilAct.startAct(getActivity(), new BankManageFrament(false));
                break;

            case 11:  //利息宝
                if (Uiutils.isTourist(getActivity()))
                    return;
                startActivity(new Intent(getActivity(), InterestDoteyActivity.class));
                break;
            case 12:  //额度转换
                if (Uiutils.isTourist(getActivity()))
                    return;
//                startActivity(new Intent(getActivity(), TransferActivity.class));
                FragmentUtilAct.startAct(getActivity(), new TransferFrament(false));
//                FragmentUtilAct.startAct(getActivity(), new TransferNewFrament(false));

                break;
            case 13:  //推荐收益
                if (Uiutils.isTourist1(getActivity())){
                    FragmentUtilAct.startAct(getActivity(), new RecommendBenefitFrag(false));
                    return;
                }

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
            case 14:  //安全中心
                if (Uiutils.isTourist(getActivity()))
                    return;
                FragmentUtilAct.startAct(getActivity(), new SafetyCenterFrag(false));
                break;
            case 15:  //站内信
                FragmentUtilAct.startAct(getActivity(), new MailFrag(false));
                break;
            case 16:  //彩票注单记录
                if (Uiutils.isTourist(getActivity()))
                    return;

                Bundle bundle = new Bundle();
                bundle.putInt("type", 1);
                FragmentUtilAct.startAct(getActivity(), new NoteRecordFrag(), bundle);
                break;
            case 17:  //注单记录
                if (Uiutils.isTourist(getActivity()))
                    return;

                Bundle bundle2 = new Bundle();
                bundle2.putInt("type", 2);
                FragmentUtilAct.startAct(getActivity(), new NoteRecordFrag(), bundle2);

                break;
            case 18:  //建议反馈
                if (Uiutils.isTourist(getActivity()))
                    return;
                FragmentUtilAct.startAct(getActivity(), new FeedbackFrag());
                break;
            case 19:  //任务中心
                if (Uiutils.isTourist(getActivity()))
                    return;
                FragmentUtilAct.startAct(getActivity(), new MissionCenterFrag(false));
                break;
            case 20:  //个人信息
                FragmentUtilAct.startAct(getActivity(), new PersonalInformationFrag());
                break;
            case 21:  //活动彩金
                if (Uiutils.isTourist(getActivity()))
                    return;
                FragmentUtilAct.startAct(getActivity(), new ActivityFiledFrag());
                break;
            case 22:  //存款
                if (Uiutils.isTourist(getActivity()))
                    return;
                build = new Bundle();
                build.putString("page", "2");
                IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                break;
            case 23:  //存款
                if (Uiutils.isTourist(getActivity()))
                    return;
                build = new Bundle();
                build.putString("page", "3");
                IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                break;
            case 24:  //长龙?
                FragmentUtilAct.startAct(getActivity(), new DragonAssistantFrag(false));
                break;
            case 25:  //
                ToastUtil.toastShortShow(getContext(),"敬请期待");
                break;
        }
    }


    public interface OnItemListener {
        void onItemClick(View view, My_item my_item);
    }

    private OnItemListener onItemClickListener = new OnItemListener() {
        @Override
        public void onItemClick(View view, My_item my_ite) {
            setLister(my_ite);
        }
    };


    //额度转换
    private void transferStatus() {
        String token = SPConstants.getToken(getContext());
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.CHECKTRANSFERSTATUS + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken()))
                .tag(this)
                .execute(new NetDialogCallBack(getContext(), true, MyFragment1.this, true, ToTransferBean.class) {
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
                .execute(new NetDialogCallBack(getContext(), true, MyFragment1.this, true, ToTransferBean.class) {
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


