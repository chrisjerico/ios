package com.phoenix.lotterys.main;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.TypedArray;
import android.os.Bundle;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.home.fragment.TransferFrament;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.BlackLoginActivity;
import com.phoenix.lotterys.my.activity.InterestDoteyActivity;
import com.phoenix.lotterys.my.adapter.MyitemAdapterBlack;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.ActivityFiledFragB;
import com.phoenix.lotterys.my.fragment.AgencyProposerFragB;
import com.phoenix.lotterys.my.fragment.MailFragB;
import com.phoenix.lotterys.my.fragment.NoteRecordFragB;
import com.phoenix.lotterys.my.fragment.RecommendBenefitFragB;
import com.phoenix.lotterys.my.fragment.SafetyCenterFragB;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Date:2018/10/20
 * TIME:14:30
 * author：Luke
 */
public class BlackSlidingRight_Fragment extends BaseFragments {

    @BindView(R2.id.user_lin)
    LinearLayout userLin;
    @BindView(R2.id.bt_top_up)
    Button btTopUp;
    @BindView(R2.id.bt_deposit)
    Button btDeposit;
    @BindView(R2.id.go_back_img)
    ImageView goBackImg;
    @BindView(R2.id.head_img)
    ImageView headImg;
    @BindView(R2.id.goto_register_tex)
    TextView gotoRegisterTex;
    @BindView(R2.id.open_account_tex)
    TextView openAccountTex;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_money)
    TextView tvMoney;
    @BindView(R2.id.iv_refresh)
    ImageView ivRefresh;
    @BindView(R2.id.rv)
    RecyclerView rv;
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    @BindView(R2.id.not_register_head_img)
    ImageView notRegisterHeadImg;
    @BindView(R2.id.register_lin)
    LinearLayout registerLin;
    @BindView(R2.id.not_register_lin)
    LinearLayout notRegisterLin;
    @BindView(R2.id.register_user_lin)
    LinearLayout registerUserLin;
    @BindView(R2.id.user_head_lin)
    LinearLayout userHeadLin;


    private LinearLayoutManager layoutManager;
    private SharedPreferences sp;
    Application mApp;
    private MyitemAdapterBlack adapter;
    List<My_item> list = new ArrayList<>();

    private BlackMainActivity mActivity;

    public BlackSlidingRight_Fragment() {
        super(R.layout.black_slidingright, true, true);
    }

    private ConfigBean configBean;
    private UserInfo userInfo;

    @Override
    public void initView(View view) {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        mApp = (Application) Application.getContextObject();
        mActivity = (BlackMainActivity) getActivity();
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);

        ivRefresh.setColorFilter(getContext().getResources().getColor(R.color.fount2));

//        tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance());   //暗文
        ivRefresh.setVisibility(View.VISIBLE);
        initData();
        initInfo();
        updataYuebao();
        setData();
    }

    private void setTheme() {
        if (0 != ShareUtils.getInt(getContext(), "ba_top", 0)) {
            userLin.setBackgroundColor(getContext().getResources().getColor(ShareUtils.getInt
                    (getContext(), "ba_top", 0)));

            btTopUp.setBackgroundColor(getContext().getResources().getColor(ShareUtils.getInt
                    (getContext(), "ba_top", 0)));
            btDeposit.setBackgroundColor(getContext().getResources().getColor(ShareUtils.getInt
                    (getContext(), "ba_top", 0)));
        }
    }

    private boolean isShow = false;
    private String yuebaoName;
    private boolean yuebaoshutdown;

    private String[] titleAlias;
    private String[] title;
    private TypedArray icons;

    private void initData() {
        yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());
        titleAlias = getResources().getStringArray(R.array.black_sliding_list_alias);
        title = getResources().getStringArray(R.array.black_sliding_list);
        icons = getResources().obtainTypedArray(R.array.black_img_list);
        for (int i = 0; i < title.length; i++) {

//            if (i == 5)
//                continue;
//            if (StringUtils.equals("rwzx", titleAlias[i])) {
//                if (null == configBean || null == configBean.getData()) {
//                } else if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
//                        .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
//                        .getMissionSwitch())) {
//                } else {
//                    continue;
//                }
//            }

//            if (StringUtils.equals("即时注单(0.00)", title[i]) && null != userInfo &&
//                    null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData().getUnsettleAmount())) {
//                title[i] = "即时注单(" + userInfo.getData().getUnsettleAmount() + ")";
//            }
//
//            if (StringUtils.equals("今日输赢(0.00)", title[i]) && null != userInfo &&
//                    null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData().getTodayWinAmount())) {
//                title[i] = "今日输赢(" + userInfo.getData().getTodayWinAmount() + ")";
//            }
//
//            if (StringUtils.equals("jcxbb", titleAlias[i])) {
//                title[i] = ("版本号(" + APKVersionCodeUtils.getVerName(getContext()) + ")");
//            }
            My_item item = new My_item();
            if (StringUtils.equals("jcxbb",titleAlias[i])) {
                item.setTitle("版本号("+ APKVersionCodeUtils.getVerName(getContext())+")");
            }else{
                item.setTitle(title[i]);
            }
            item.setImg(icons.getResourceId(i, 0));
            item.setAlias(titleAlias[i]);
            list.add(item);

        }
//        //处理去掉开将记录
//        if (list.size()>3)
//        list.remove(3);
        layoutManager = new GridLayoutManager(getContext(), 1);
        rv.setLayoutManager(layoutManager);
        rv.setItemAnimator(new DefaultItemAnimator());
        rv.addItemDecoration(new SpacesItemDecoration(getContext()));
        adapter = new MyitemAdapterBlack(list, 1, getContext());
        rv.setAdapter(adapter);
        adapter.setOnItemClickListener(onItemClickListener);
    }

    private void mLogout() {
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.LOGOUT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .params("token", SecretUtils.DESede(sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL)))
                .params("sign", SecretUtils.RsaToken())
                .execute(new NetDialogCallBack(getContext(), true, BlackSlidingRight_Fragment.this,
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        if (li != null && li.getCode() == 0) {
                            SharedPreferences.Editor edit = sp.edit();
                            edit.putString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
                            edit.putString(SPConstants.SP_API_TOKEN, SPConstants.SP_NULL);
                            String userType = sp.getString(SPConstants.SP_USERTYPE, SPConstants.SP_NULL);
                            if (userType.equals("guest")) {
                                edit.putString(SPConstants.SP_USERNAME, SPConstants.SP_NULL);
                                edit.putString(SPConstants.SP_PASSWORD, SPConstants.SP_NULL);
                            }
                            edit.commit();


                            goToOut();

//                            mActivity.setNavigation(0);
//                            mActivity.mState();
                            EventBus.getDefault().postSticky(new MessageEvent("2"));
                        } else if (li != null && li.getCode() != 0 && li.getMsg() != null) {
                            ToastUtils.ToastUtils(li.getMsg(), getContext());
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

    private void goToOut() {
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        int sTheme = ShareUtils.getInt(getContext(), "sTheme", 0);
        int ba_top = ShareUtils.getInt(getContext(), "ba_top", 0);
        int ba_center = ShareUtils.getInt(getContext(), "ba_center", 0);
        int ba_tbottom =  ShareUtils.getInt(getContext(), "ba_tbottom",0);

        String name =ShareUtils.getString(getContext(), SPConstants.SP_USERNAME, "");
        String pass =ShareUtils.getString(getContext(), SPConstants.SP_PASSWORD, "");

        ShareUtils.deleAll(getContext());

        ShareUtils.saveObject(getContext(), SPConstants.CONFIGBEAN,configBean);
        ShareUtils.putInt(getContext(), "sTheme", sTheme);
        ShareUtils.putInt(getContext(), "ba_top", ba_top);
        ShareUtils.putInt(getContext(), "ba_center", ba_center);
        ShareUtils.putInt(getContext(), "ba_tbottom", ba_tbottom);

        ShareUtils.putString(getContext(), SPConstants.SP_USERNAME, name);
        ShareUtils.putString(getContext(), SPConstants.SP_PASSWORD, pass);

        ToastUtils.ToastUtils("退出成功", getContext());
//                            sethead(1);
//                            addOr();

        initInfo();
        updataYuebao();
    }

    @Override
    public void onDestroy() {
//        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }

    private boolean isSee = true;

    //获取登录信息
    private void getUserInfo(String s) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(s) + "&sign=" + SecretUtils.RsaToken())).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, BlackSlidingRight_Fragment.this, true, UserInfo.class) {
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
                    edit.putString(SPConstants.SP_TASKREWARD, li.getData().getTaskReward());
                    //头像
                    edit.putString(SPConstants.AVATAR, li.getData().getAvatar());
                    edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, li.getData().isYuebaoSwitch());
                    ShareUtils.saveObject(getContext(), SPConstants.USERINFO, li);
                    edit.commit();
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

    @Subscribe(sticky = true)
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("userinfo")) {
            initInfo();
            updataYuebao();
            Log.e("xxxuserinfo", "userinfo");
        } else if (messageEvent.getMessage().equals("config")) {
            updataYuebao();
            initInfo();
            Log.e("xxxconfig", "config");
        }
    }

    private void updataYuebao() {
        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());

        Log.e("yuebaoshutdown==","//"+yuebaoshutdown);

        if (!yuebaoshutdown) {
            if (list != null) {
                for (int i = 0; i < list.size(); i++) {
                    if (list.get(i).getAlias().equals("lxb")) {
                        Log.e("updataYuebao==", list.get(i).getAlias() + "///lxb");
                        list.remove(i);
                    }
                }
            }
            if (adapter != null)
                adapter.notifyDataSetChanged();
        } else if (yuebaoshutdown && list != null && list.size() > 0 && adapter != null) {
            Log.e("yuebaoshutdown==","//00"+yuebaoshutdown);
//            for (My_item my_item :list) {
//                if (my_item.getAlias().equals("lxb")) {
//                    if (!TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
//                        my_item.setTitle(yuebaoName);
//                    } else {
//                        my_item.setTitle("利息宝");
//                    }
//                    adapter.notifyDataSetChanged();
//                }
////                else {
////                    list.add(4, new My_item(R.mipmap.lxb_sele, yuebaoName.equals("Null") ? "利息宝" : yuebaoName, "lxb"));
////                    adapter.notifyDataSetChanged();
////                }
//            }
            if (list.get(1).getAlias().equals("lxb")) {
                if (!TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
                    list.get(1).setTitle(yuebaoName);
                } else {
                    list.get(1).setTitle("利息宝");
                }
                adapter.notifyDataSetChanged();
            } else {
                list.add(1, new My_item(R.mipmap.lxb_sele, yuebaoName.equals("Null") ? "利息宝" : yuebaoName, "lxb"));
                adapter.notifyDataSetChanged();
            }


        }

        setSytpe();
    }

    private void setListItemNmae(List<My_item> list,String alias ,String name) {
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getAlias().equals(alias)) {
                list.get(i).setTitle(name);
            }
        }
    }

    private void setSytpe() {
        Log.e("yuebaoshutdown==","//aa"+yuebaoshutdown);
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        if (Uiutils.isTourist1(getActivity())) {
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getAlias().equals("sytj")) {
                    list.get(i).setTitle("收益推荐");
                }
            }
            return;
        }

        if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
//            if (!StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))&&list.size()>0) {
                setListItemNmae(list,"sytj","收益推荐");
//            }
        } else {
//            if (!StringUtils.equals("2",ShareUtils.getString(getContext(), "themetyp", ""))&&list.size()>0) {
                setListItemNmae(list,"sytj","申请代理");
//            }
        }

        if (null == userInfo || null == userInfo.getData() ){ }
        else if ( !userInfo.getData().isHasActLottery()) {
                if (list.size()>0){
                    removeItem("hdsg");
                }
        }else if (userInfo.getData().isHasActLottery()){
                if (list.size()>0){
                    if (!haveItem("hdsg")){
                        if (!haveItem("lxb")){
                            list.add(6, new My_item(R.mipmap.handsel,"活动彩金", "hdsg"));
                        }else{
                            list.add(7, new My_item(R.mipmap.handsel,"活动彩金", "hdsg"));
                        }

                    }
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


    private void initInfo() {
        if (SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE).equals("guest")) {
            tvName.setText("游客");
            ImageLoadUtil.ImageLoad(getContext(),R.drawable.profile,headImg);
            sethead(2);
        } else if (!SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE).equals("Null")) {
            tvName.setText(SPConstants.getValue(getActivity(), SPConstants.SP_USR));
            sethead(2);

            if (!StringUtils.isEmpty(SPConstants.getValue(getActivity(), SPConstants.AVATAR)))
            ImageLoadUtil.loadRoundImage(headImg,SPConstants.getValue(getActivity(), SPConstants.AVATAR),0);
            else
                ImageLoadUtil.ImageLoad(getContext(),R.drawable.profile,headImg);
        } else {
            sethead(1);
            ImageLoadUtil.ImageLoad(getContext(),R.drawable.profile,headImg);
        }
        addOr();
    }

    private void addOr() {
        if (list.size() > 0) {
            if (StringUtils.equals("tcdl", list.get(list.size() - 1).getAlias())) {
                if (StringUtils.isEmpty(SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE)) ||
                        StringUtils.equals("Null", SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE))) {
                    removeItem("tcdl");
                }
            } else {
                if (StringUtils.isEmpty(SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE)) ||
                        StringUtils.equals("Null", SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE))) {
                } else {
                    My_item item = new My_item();
                    item.setTitle(title[title.length - 1]);
                    item.setImg(icons.getResourceId(title.length - 1, 0));
                    item.setAlias(titleAlias[title.length - 1]);
                    list.add(item);
                    if (null != adapter)
                        adapter.notifyDataSetChanged();
                }
            }
        }
    }

    private void sethead(int type) {
        switch (type) {
            case 1:
                notRegisterHeadImg.setVisibility(View.VISIBLE);
                registerLin.setVisibility(View.GONE);
                notRegisterLin.setVisibility(View.VISIBLE);
                registerUserLin.setVisibility(View.GONE);
                break;
            case 2:
                notRegisterHeadImg.setVisibility(View.GONE);
                registerLin.setVisibility(View.VISIBLE);
                notRegisterLin.setVisibility(View.GONE);
                registerUserLin.setVisibility(View.VISIBLE);

                if (null != userInfo && null != userInfo.getData())
                    tvMoney.setText("¥ " + userInfo.getData().getBalance());

//                tvMoney.setTextColor(getContext().getResources().getColor(R.color.black));
                break;
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_PICTURE:
                Log.e("list1==", list.toString());
                configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
                userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
                if (null != list && list.size() > 0) {
                    for (My_item my_item : list) {

                        if (null != userInfo && null != userInfo.getData())
                            if (my_item.getTitle().contains("即时注单")) {
                                my_item.setTitle("即时注单(" + userInfo.getData().getUnsettleAmount() + ")");
                            }

                        if (null != userInfo && null != userInfo.getData())
                            if (my_item.getTitle().contains("今日输赢")) {
                                my_item.setTitle("今日输赢(" + userInfo.getData().getTodayWinAmount() + ")");
                            }
                    }

                    if (null == configBean || null == configBean.getData()) {
                    } else if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                            .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                            .getMissionSwitch())) {
                    } else {
                        removeItem("rwzx");
                    }

                    if (null != adapter)
                        adapter.notifyDataSetChanged();

                    setData();
                }
                break;
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Log.e("list2==", list.toString());
                setData();
                updataYuebao();
//                if (null == userInfo || null == userInfo.getData()){
//                }else if ( !userInfo.getData().isYuebaoSwitch()) {
//                    removeItem("lxb");
//                } else if (null != configBean && null != configBean.getData()&&!StringUtils.isEmpty(configBean.getData().getYuebaoName())){
//                    setItem("lxb",configBean.getData().getYuebaoName());
//                }else{
//                    setItem("lxb","利息宝");
//                }
                break;


        }
    }

    private void setData() {
        setTheme();
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);

        if (null == configBean || null == configBean.getData()) {
        } else if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                .getMissionSwitch())) {
        } else {
            removeItem("rwzx");
        }

//        if (null == userInfo || null == userInfo.getData()){
//        }else if (null != userInfo && null != userInfo.getData() &&!userInfo.getData().isYuebaoSwitch()) {
//            removeItem("lxb");
//        } else if (null != configBean && null != configBean.getData()&&!StringUtils.isEmpty(configBean.getData().getYuebaoName())){
//            setItem("lxb",configBean.getData().getYuebaoName());
//        }else{
//            setItem("lxb","利息宝");
//        }
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

    private void setItem(String str, String name) {
        if (list.size() > 0)
            for (int i = 0; i < list.size(); i++) {
                if (StringUtils.equals(str, list.get(i).getAlias())) {
                    list.get(i).setTitle(name);
                    if (null != adapter)
                        adapter.notifyDataSetChanged();
                    continue;
                }
            }
    }

    @OnClick({R.id.go_back_img, R.id.goto_register_tex, R.id.open_account_tex, R.id.iv_refresh
            , R.id.user_head_lin,R.id.user_main_lin})
    public void onClick(View view) {

        Intent intent = null;
        switch (view.getId()) {
            case R.id.user_main_lin:
                mActivity.closeSlidingMenu();
                break;
            case R.id.go_back_img:
                mActivity.closeSlidingMenu();
                break;
            case R.id.goto_register_tex://登录
                intent = new Intent(mActivity, BlackLoginActivity.class);
                mActivity.startActivity(intent);
                mActivity.closeSlidingMenu();
                break;
            case R.id.open_account_tex:
                mActivity.clickTabFragment("/regedit", "");
                mActivity.closeSlidingMenu();
                break;
            case R.id.iv_refresh:
                if (ButtonUtils.isFastDoubleClick())
                    return;
                ObjectAnimator objectAnimator = ObjectAnimator.ofFloat(ivRefresh, "rotation", 0f, 360f);
                objectAnimator.setDuration(1500);
                objectAnimator.start();
                String token = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
                if (!token.equals(SPConstants.SP_NULL)) {
                    getUserInfo(token);
                } else {
//                    startActivity(new Intent(getContext(), LoginActivity.class));
                    Uiutils.login(getContext());
                }
                break;
            case R.id.user_head_lin:
                if (Uiutils.isTourist2(getActivity()))
                    return;
                mActivity.clickTabFragment("/user", "");
                mActivity.closeSlidingMenu();
                break;
        }
    }

    private Uiutils.OnItemClickListener onItemClickListener = new Uiutils.OnItemClickListener() {
        @Override
        public void onItemClick(View view, int position) {
            if (ButtonUtils.isFastDoubleClick())
                return;

            Intent intent = null;
            mActivity.closeSlidingMenu();
            String alias = list.get(position).getAlias();
            Bundle build = null;
            switch (alias) {
                case "fhsy"://返回首页
                    if (null!=mActivity)
                    mActivity.clickTabFragment("/home","");
                    break;
                case "lxb"://利息宝
                    if (Uiutils.isTourist2(getActivity()))
                        return;

                    startActivity(new Intent(getActivity(), InterestDoteyActivity.class));
                    break;
                case "znx"://站内信
//                    if (Uiutils.isTourist1(getActivity()))
//                        return;
                    FragmentUtilAct.startAct(getActivity(), new MailFragB(false));
                    break;
                case "xgmm"://修改密码
                    if (Uiutils.isTourist2(getActivity()))
                        return;
                    build = new Bundle();
                    build.putInt("type", 0);
                    build.putBoolean("isBla", true);
                    FragmentUtilAct.startAct(getActivity(), new SafetyCenterFragB(false), build);
                    break;
                case "xgqkmm"://修改取款密码
                    if (Uiutils.isTourist2(getActivity()))
                        return;
                    build = new Bundle();
                    build.putInt("type", 1);
                    build.putBoolean("isBla", true);
                    FragmentUtilAct.startAct(getActivity(), new SafetyCenterFragB(false), build);
                    break;
                case "zxkf"://在线客服
                    String zxkfurl = SPConstants.getValue(getContext(), SPConstants.SP_ZXKFURL);
                    if (!TextUtils.isEmpty(zxkfurl)) {
                        Uiutils.goWebView(getContext(), zxkfurl.startsWith("http") ? zxkfurl : "http://" + zxkfurl
                                , "在线客服");
                    } else {
                        ToastUtils.ToastUtils("客服地址未配置或获取失败", getContext());
                    }
                    break;
                case "tzjl"://投注记录
                    if (Uiutils.isTourist2(getActivity()))
                        return;
                    Bundle bundle = new Bundle();
                    bundle.putInt("type", 1);
                    FragmentUtilAct.startAct(getActivity(), new NoteRecordFragB(), bundle);
                    break;
                case "hdsg"://优惠申请大厅
                    if (Uiutils.isTourist2(getActivity()))
                        return;
                    FragmentUtilAct.startAct(getActivity(), new ActivityFiledFragB());
                    break;
                case "sytj"://代理注册
                    if (Uiutils.isTourist1(getActivity())){
                        FragmentUtilAct.startAct(getActivity(), new RecommendBenefitFragB(false));
                        return;
                    }

                    if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
                    FragmentUtilAct.startAct(getActivity(), new RecommendBenefitFragB(false));
                    } else {
                        if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                                .getAgent_m_apply()) && StringUtils.equals("1", configBean.getData()
                                .getAgent_m_apply())) {
                            FragmentUtilAct.startAct(getActivity(), new AgencyProposerFragB(false));
                        } else {
                            ToastUtil.toastShortShow(getContext(), "在线注册代理已关闭");
                        }
                    }
                    break;
                case "ck"://线下充值
//                if (ButtonUtils.isFastDoubleClick())
//                    return;
                    if (Uiutils.isTourist2(getActivity()))
                        return;
//                    build = new Bundle();
//                    build.putSerializable("page", "0");
//                    IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.SHOWFRAMNET, "/funds0"));
                    break;
                case "qk"://线上取款
//                if (ButtonUtils.isFastDoubleClick())
//                    return;
                    if (Uiutils.isTourist2(getActivity()))
                        return;
//                    build = new Bundle();
//                    build.putSerializable("page", "1");
//                    IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.SHOWFRAMNET, "/funds1"));
                    break;
                case "edzh"://额度转换
                    if (Uiutils.isTourist2(getActivity()))
                        return;
                    FragmentUtilAct.startAct(getActivity(), new TransferFrament(false));
                    break;
                case "tcdl"://退出登录
                    mLogout();
                    break;
                case "jcxbb"://
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.CHECK_THE_UPDATA));
                    mActivity.closeSlidingMenu();
                    break;
            }
        }
    };

    @Subscribe(threadMode = ThreadMode.MAIN, sticky = true)
    public void getEvENT(MessageEvent messageEvent) {
        Log.e("getEvENT==","/////");
        if (messageEvent.getMessage().equals("2")) {  //退出成功
            goToOut();
        }
    }

}
