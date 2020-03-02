package com.phoenix.lotterys.buyhall;

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
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.activity.TicketDetailsActivity;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.BlackMainActivity;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.DepositActivity;
import com.phoenix.lotterys.my.activity.InterestDoteyActivity;
import com.phoenix.lotterys.my.adapter.MyitemAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.DragonAssistantFrag;
import com.phoenix.lotterys.my.fragment.DragonAssistantFragB;
import com.phoenix.lotterys.my.fragment.LotteryRecordFrag;
import com.phoenix.lotterys.my.fragment.MailFrag;
import com.phoenix.lotterys.my.fragment.MailFragB;
import com.phoenix.lotterys.my.fragment.MissionCenterFrag;
import com.phoenix.lotterys.my.fragment.MissionCenterFragB;
import com.phoenix.lotterys.my.fragment.NoteRecordFrag;
import com.phoenix.lotterys.my.fragment.NoteRecordFragB;
import com.phoenix.lotterys.my.fragment.RedEnvelopesFragment;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.IntentUtils;
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
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

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
public class SlidingRight_Fragment extends BaseFragments {
    @BindView(R2.id.rv)
    RecyclerView rv;
    List<My_item> list = new ArrayList<>();
    @BindView(R2.id.bt_top_up)
    Button btTopUp;
    @BindView(R2.id.bt_deposit)
    Button btDeposit;
    TicketDetailsActivity mActivity;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_money)
    TextView tvMoney;
    @BindView(R2.id.user_lin)
    LinearLayout userLin;
    @BindView(R2.id.ll_main)
    LinearLayout llMain;
    private LinearLayoutManager layoutManager;
    private SharedPreferences sp;
    @BindView(R2.id.iv_refresh)
    ImageView ivRefresh;
    private MyitemAdapter adapter;
    private UserInfo userInfo;

    public SlidingRight_Fragment() {
        super(R.layout.fragment_slidingright, true, true);
    }

    private ConfigBean configBean;

    @Override
    public void initView(View view) {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO,UserInfo.class);
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN,ConfigBean.class);

        mActivity = (TicketDetailsActivity) getActivity();
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        tvMoney.setTransformationMethod(HideReturnsTransformationMethod.getInstance());   //暗文
        ivRefresh.setVisibility(View.VISIBLE);

        initData();
        initInfo();

        if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                .getMissionSwitch())) {
        } else {
            if (list.size() > 0)
                list.remove(7);
        }

        if (0!=ShareUtils.getInt(getContext(),"ba_top",0)){
            userLin.setBackgroundColor(getContext().getResources().getColor(ShareUtils.getInt
                    (getContext(),"ba_top",0)));

            btTopUp.setBackgroundColor(getContext().getResources().getColor(ShareUtils.getInt
                    (getContext(),"ba_top",0)));
            btDeposit.setBackgroundColor(getContext().getResources().getColor(ShareUtils.getInt
                    (getContext(),"ba_top",0)));
        }


        if (Uiutils.setBaColor(getContext(),llMain)){

        }
        if (Uiutils.isSite("c217")){
            userLin.setVisibility(View.GONE);
        }
    }

    boolean isShow = false;

    private void initData() {
        String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
//        String yuebaoshutdown = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAOSHUTDOWN);
        boolean yuebaoshutdown = SPConstants.getValue(SPConstants.SP_YUEBAOSHUTDOWN, getContext());
        String[] title = getResources().getStringArray(R.array.sliding_list);
        String[] titleAlias = getResources().getStringArray(R.array.sliding_list_alias);
        TypedArray icons = getResources().obtainTypedArray(R.array.img_list);
        for (int i = 0; i < title.length; i++) {
            if (StringUtils.equals("rwzx",titleAlias[i])) {

                if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                        .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                        .getMissionSwitch())) {
                } else {
                    continue;
                }
            }

            if (i == 6 && !yuebaoshutdown) {
                isShow = true;
                continue;
            }



            if (StringUtils.equals("即时注单(0.00)", title[i]) && null != userInfo &&
                    null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData().getUnsettleAmount())) {
                title[i] = "即时注单(" + userInfo.getData().getUnsettleAmount() + ")";
            }

            if (StringUtils.equals("今日输赢(0.00)", title[i]) && null != userInfo &&
                    null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData().getTodayWinAmount())) {
                title[i] = "今日输赢(" + userInfo.getData().getTodayWinAmount() + ")";
            }

            if (StringUtils.equals("jcxbb",titleAlias[i])) {
                title[i] =("版本号("+ APKVersionCodeUtils.getVerName(getContext())+")");
            }

            My_item item = new My_item();
            if (i == 6 && !isShow) {
                if (yuebaoshutdown && !TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
                    item.setTitle(yuebaoName);
                } else if (yuebaoshutdown) {
                    item.setTitle("利息宝");
                }
            } else {
                item.setTitle(title[i]);
            }
            item.setImg(icons.getResourceId(i, 0));
            item.setAlias(titleAlias[i]);

            list.add(item);

        }
        layoutManager = new GridLayoutManager(getContext(), 1);
        rv.setLayoutManager(layoutManager);
        rv.setItemAnimator(new DefaultItemAnimator());
        rv.addItemDecoration(new SpacesItemDecoration(getContext()));
        adapter = new MyitemAdapter(list,1,getContext());
        rv.setAdapter(adapter);
        adapter.setOnItemClickListener(new MyitemAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (ButtonUtils.isFastDoubleClick())
                    return;
                Intent intent = null;
                Bundle bundle = null;
                mActivity.closeSlidingMenu();
                String alias = list.get(position).getAlias();
                if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                        .getMissionSwitch()) && StringUtils.equals("0", configBean.getData()
                        .getMissionSwitch())) {
                } else {
                    if (position > 6)
                        position += 1;
                }


                switch (alias) {
                    case "fhsy":
//                        startActivity(new Intent(getContext(), MainActivity.class));
//                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.TABHOME));   //返回首页
                        goHome(getContext());
                        break;
                    case "lxb":
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url",Constants.BaseUrl+"/dist/#/yuebao");
//                        startActivity(intent);
                        if (Uiutils.isTourist(getActivity()))
                            return;
                        startActivity(new Intent(getActivity(), InterestDoteyActivity.class));
                        mActivity.closeSlidingMenu();
                        break;
                    case "tzjl":  //投注记录
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url",Constants.BaseUrl+"/dist/#/myBet");
//                        startActivity(intent);
                        bundle = new Bundle();
                        bundle.putInt("type", 1);
                        if (Uiutils.setBaColor(getContext(),null)){
                            FragmentUtilAct.startAct(getActivity(), new NoteRecordFragB(), bundle);
                        }else{
                            FragmentUtilAct.startAct(getActivity(), new NoteRecordFrag(), bundle);
                        }

                        mActivity.closeSlidingMenu();
                        break;
                    case "kjjl":  //开奖记录
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        intent = new Intent(getActivity(), WebActivity.class);
//                        intent.putExtra("url",Constants.BaseUrl+"/Open_prize/index.php");
//                        startActivity(intent);

                        if (!StringUtils.isEmpty(mActivity.getisInstant()) && StringUtils.equals(
                                "1", mActivity.getisInstant())) {
                            ToastUtil.toastShortShow(getActivity(), "秒秒彩系列暂无开奖记录");
                            mActivity.closeSlidingMenu();
                            return;
                        }

                        bundle = new Bundle();
                        bundle.putString("id", mActivity.getId() == null ? "1" : mActivity.getId());
                        bundle.putString("gameType", mActivity.getGameType());
                        FragmentUtilAct.startAct(getActivity(), new LotteryRecordFrag(false), bundle);
                        mActivity.closeSlidingMenu();
                        break;
                    case "czgz":  //彩种规则
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.RULES_OF_COLOR_SEED));
                        mActivity.closeSlidingMenu();
                        break;
                    case "clzs":  //长龙助手
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url",Constants.BaseUrl+"/dist/#/changLong/fastChanglong");
//                        startActivity(intent);

                        if (Uiutils.setBaColor(getContext(),null)){
                            FragmentUtilAct.startAct(getActivity(), new DragonAssistantFragB(false));
                        }else{
                            FragmentUtilAct.startAct(getActivity(), new DragonAssistantFrag(false));
                        }


                        mActivity.closeSlidingMenu();
                        break;
                    case "hbjl":  //红包记录
                        RedEnvelopesFragment fgt = new RedEnvelopesFragment();
                        Bundle args = new Bundle();
                        args.putString("type", RedEnvelopesFragment.RED_NORMAL);
                        fgt.setArguments(args);
                        FragmentUtilAct.startAct(getActivity(), fgt);
                        mActivity.closeSlidingMenu();

                        break;
                    case "sljl":  //扫雷记录
                        RedEnvelopesFragment fgt2 = new RedEnvelopesFragment();
                        Bundle args2 = new Bundle();
                        args2.putString("type", RedEnvelopesFragment.RED_MINE);
                        fgt2.setArguments(args2);
                        FragmentUtilAct.startAct(getActivity(), fgt2);
                        mActivity.closeSlidingMenu();

                        break;
                    case "zndx":  //站内信
//                        intent = new Intent(getActivity(), WebActivity.class);
////                        intent.putExtra("url",Constants.BaseUrl+"/dist/#/message");
////                        startActivity(intent);


                        if (Uiutils.setBaColor(getContext(),null)){
                            FragmentUtilAct.startAct(getActivity(), new MailFragB(false));
                        }else{
                            FragmentUtilAct.startAct(getActivity(), new MailFrag(false));
                        }

                        mActivity.closeSlidingMenu();
                        break;
                    case "rwzx":  //任务中心
                        if (Uiutils.isTourist(getActivity()))
                            return;
//                        intent = new Intent(getActivity(), GoWebActivity.class);
//                        intent.putExtra("url", Constants.BaseUrl + "/dist/#/task/task");
//                        startActivity(intent);

                        if (Uiutils.setBaColor(getContext(),null)){
                            FragmentUtilAct.startAct(getActivity(), new MissionCenterFragB(false));
                        }else{
                            FragmentUtilAct.startAct(getActivity(), new MissionCenterFrag(false));
                        }


                        mActivity.closeSlidingMenu();
                        break;
                    case "tcdl":  //登出
                        mLogout();
                        break;
                    case "gszd":   // 即时注单
                        if (Uiutils.isTourist(getActivity()))
                            return;
                        Bundle bundlegszd = new Bundle();
                        bundlegszd.putInt("type", 1);
                        bundlegszd.putInt("index", 2);

                        if (Uiutils.setBaColor(getContext(),null)){
                            FragmentUtilAct.startAct(getActivity(), new NoteRecordFragB(), bundlegszd);
                        }else{
                            FragmentUtilAct.startAct(getActivity(), new NoteRecordFrag(), bundlegszd);
                        }

                        mActivity.closeSlidingMenu();

                        break;
                    case "grse":   //今日输赢
                        if (Uiutils.isTourist(getActivity()))
                            return;
                        Bundle bundlegrse = new Bundle();
                        bundlegrse.putInt("type", 1);
                        bundlegrse.putInt("index", 0);

                        if (Uiutils.setBaColor(getContext(),null)){
                            FragmentUtilAct.startAct(getActivity(), new NoteRecordFragB(), bundlegrse);
                        }else{
                            FragmentUtilAct.startAct(getActivity(), new NoteRecordFrag(), bundlegrse);
                        }
                        mActivity.closeSlidingMenu();

                        break;
                    case "jcxbb":
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.CHECK_THE_UPDATA));
                        mActivity.closeSlidingMenu();
                        break;
                    default:

                        break;
                }
            }
        });
    }

    private void mLogout() {
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.LOGOUT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .params("token", SecretUtils.DESede(sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL)))
                .params("sign", SecretUtils.RsaToken())
                .execute(new NetDialogCallBack(getContext(), true, SlidingRight_Fragment.this,
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
                            ToastUtils.ToastUtils("退出成功", getContext());
                            EventBus.getDefault().postSticky(new MessageEvent("2"));
//                            startActivity(new Intent(getContext(), MainActivity.class));
                            goHome(getContext());
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

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    private boolean isSee = true;

    @OnClick({R.id.bt_top_up, R.id.bt_deposit, R.id.iv_refresh, R.id.ll_main, R.id.tv_money})
    public void onViewClicked(View view) {
        Intent intent;
        Bundle build;
        switch (view.getId()) {
            case R.id.bt_top_up:
//                intent = new Intent(getActivity(), GoWebActivity.class);
//                intent.putExtra("url",Constants.BaseUrl+"/dist/#/funds/deposit");
//                startActivity(intent);
//                mActivity.closeSlidingMenu();
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (Uiutils.isTourist(getActivity()))
                    return;
                build = new Bundle();
                build.putSerializable("page", "0");
                IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                mActivity.closeSlidingMenu();
                break;
            case R.id.bt_deposit:
//                intent = new Intent(getActivity(), GoWebActivity.class);
//                intent.putExtra("url",Constants.BaseUrl+"/dist/#/funds/Withdraw");
//                startActivity(intent);
                if (ButtonUtils.isFastDoubleClick())
                    return;
                if (Uiutils.isTourist(getActivity()))
                    return;
                build = new Bundle();
                build.putSerializable("page", "1");
                IntentUtils.getInstence().intent(getActivity(), DepositActivity.class, build);
                mActivity.closeSlidingMenu();
                break;
            case R.id.ll_main:

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
        }
    }


    //获取登录信息
    private void getUserInfo(String s) {
        OkGo.<String>get(Constants.BaseUrl()+Constants.USERINFO +  SecretUtils.DESede(s)+"&sign="+ SecretUtils.RsaToken()).tag(getActivity()).execute(new NetDialogCallBack(getContext(), true, SlidingRight_Fragment.this, true, UserInfo.class) {
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
                    edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, li.getData().isYuebaoSwitch());
                    edit.putString(SPConstants.SP_TASKREWARD, li.getData().getTaskReward());
                    //头像
                    edit.putString(SPConstants.AVATAR, li.getData().getAvatar());
                    edit.commit();
                    ShareUtils.saveObject(getContext(), SPConstants.USERINFO, li);
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


    @Subscribe(sticky = true)   //登录
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("login") || messageEvent.getMessage().equals("userinfo")) {
            initInfo();
        } else if (messageEvent.getMessage().equals("config")) {
            String yuebaoName = SPConstants.getValue(getContext(), SPConstants.SP_YUEBAONAME);
            if (list != null && list.size() >= 2 && adapter != null) {
                if (!TextUtils.isEmpty(yuebaoName) && !yuebaoName.equals("Null")) {
                    list.get(1).setTitle(yuebaoName);
                } else {
                    list.get(1).setTitle("");
                }
                adapter.notifyItemChanged(1);
            }
        }
    }

    private void initInfo() {
        if (SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE).equals("guest")) {
            tvName.setText("游客");
        } else if (!SPConstants.getValue(getActivity(), SPConstants.SP_USERTYPE).equals("Null")) {
            tvName.setText(SPConstants.getValue(getActivity(), SPConstants.SP_USR));
        }
        tvMoney.setText(SPConstants.getValue(getActivity(), SPConstants.SP_BALANCE));
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_PICTURE:
                Log.e("0000", "?");
                userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO,UserInfo.class);
                if (null != list && list.size() > 0) {
                    for (My_item my_item : list) {
                        if (my_item.getTitle().contains("即时注单")) {
                            my_item.setTitle("即时注单(" + userInfo.getData().getUnsettleAmount() + ")");
                        }

                        if (my_item.getTitle().contains("今日输赢")) {
                            my_item.setTitle("今日输赢(" + userInfo.getData().getTodayWinAmount() + ")");
                        }
                    }
                    if (null != adapter)
                        adapter.notifyDataSetChanged();
                }
                break;
        }
    }

    public static void goHome(Context context){
        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (configBean != null && configBean.getData() != null &&configBean.getData().getMobileTemplateCategory()!=null&& configBean.getData().getMobileTemplateCategory().equals("5")) {
            context.startActivity(new Intent(context, BlackMainActivity.class));
            EvenBusUtils.setEvenBus(new Even(EvenBusCode.SHOWFRAMNET, "/home"));
        } else {
            context.startActivity(new Intent(context, MainActivity.class));
            EvenBusUtils.setEvenBus(new Even(EvenBusCode.TABHOME));   //返回首页
        }
    }

}
