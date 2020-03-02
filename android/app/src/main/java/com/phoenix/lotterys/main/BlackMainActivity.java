package com.phoenix.lotterys.main;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.buyhall.BuyHallTypeFragment;
import com.phoenix.lotterys.chat.fragment.ChatFragment;
import com.phoenix.lotterys.coupons.CouponsFragment;
import com.phoenix.lotterys.home.activity.ElectronicActivity;
import com.phoenix.lotterys.home.adapter.BlackGameAdapter;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.home.bean.NoticeBean;
import com.phoenix.lotterys.home.fragment.BankManageFrament;
import com.phoenix.lotterys.home.fragment.BlackHomeFrament;
import com.phoenix.lotterys.home.fragment.BlackLastReadFrament;
import com.phoenix.lotterys.home.fragment.FundFrament;
import com.phoenix.lotterys.home.fragment.InterestDoteyFrament;
import com.phoenix.lotterys.home.fragment.TransferFrament;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.GameType;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.main.bean.UpdataVersionBean;
import com.phoenix.lotterys.my.activity.BlackLoginActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.AgencyProposerFrag;
import com.phoenix.lotterys.my.fragment.DragonAssistantFrag;
import com.phoenix.lotterys.my.fragment.LotteryRecordFrag;
import com.phoenix.lotterys.my.fragment.MailFrag;
import com.phoenix.lotterys.my.fragment.MissionCenterFrag;
import com.phoenix.lotterys.my.fragment.MyFragment4;
import com.phoenix.lotterys.my.fragment.RecommendBenefitFrag;
import com.phoenix.lotterys.my.fragment.BlackRegeditFrament;
import com.phoenix.lotterys.my.fragment.SafetyCenterFrag;
import com.phoenix.lotterys.my.fragment.SignInFrag;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.AnimationUtil;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.DrawableUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.SkipGameUtil;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.UpdataUtil;
import com.phoenix.lotterys.view.HomeDialog;
import com.phoenix.lotterys.view.MarqueTextView;
import com.phoenix.lotterys.view.MyIntentService;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.AppManager;
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

import static com.phoenix.lotterys.application.Application.getContextObject;

/**
 * Greated by Luke
 * on 2019/10/30
 */
public class BlackMainActivity extends BaseActivity {
    @BindView(R2.id.rl_title)
    RelativeLayout rlTitle;
    @BindView(R2.id.drawer_main_layout)
    DrawerLayout mDrawerLayout;
    @BindView(R2.id.iv_logo)
    ImageView ivLogo;
    @BindView(R2.id.iv_menu)
    ImageView ivMenu;
    @BindView(R2.id.bt_login)
    Button btLogin;
    @BindView(R2.id.bt_regedit)
    Button btRegedit;
    @BindView(R2.id.framelayout)
    FrameLayout framelayout;
    @BindView(R2.id.tv_finance)
    TextView tvFinance;
    @BindView(R2.id.tv_downliad)
    TextView tvDownliad;
    @BindView(R2.id.tv_activity)
    TextView tvActivity;
    @BindView(R2.id.tv_online)
    TextView tvOnline;
    @BindView(R2.id.tv_home)
    TextView tvHome;
    @BindView(R2.id.rl_navig)
    RelativeLayout rlNavig;
    @BindView(R2.id.marquee)
    MarqueTextView tvNotice;
    @BindView(R2.id.rv_game)
    RecyclerView rvGame;
    @BindView(R2.id.cb_show)
    CheckBox cbShow;
    @BindView(R2.id.tv_domain)
    TextView tvDomain;
    @BindView(R2.id.rl_show)
    RelativeLayout rlShow;
    private UpdataUtil updata;
    private SharedPreferences sp;
    private FragmentManager fm;
    private FragmentTransaction fragmentTransaction;
    Application mApp;
    private FundFrament depositFrament;  //资金管理
    private CouponsFragment couponsfragment;   //活动
    private BlackHomeFrament blackHomeFrament;  //黑色首页
    private BaseFragment userFrag;  //个人中心
    private BlackRegeditFrament regeditFrament;  //注册
    private BlackLastReadFrament blackLastReadFrament;  //最近浏览
    private BuyHallTypeFragment buyhallfragment;

    private ChatFragment channelfragment;
    private MailFrag mailFrag;  //站内信1
    private DragonAssistantFrag dragonAssistantFrag;  //长龙助手1
    private LotteryRecordFrag lotteryRecordFrag;  //开奖记录
    private MissionCenterFrag missionCenterFrag;  //任务大厅1
    private SafetyCenterFrag safetyCenterFrag;  //安全中心
    private RecommendBenefitFrag recommendBenefitFrag;  //推荐受益1
    private SignInFrag signInFrag;  //签到1
    private BankManageFrament bankManageFrament;  //银行卡1
    private InterestDoteyFrament interestDoteyFrament;  //利息宝1
    private TransferFrament transferFrament;  //额度转换1
    private AgencyProposerFrag agencyProposerFrag;  //代理
    boolean isChat = false;
    ConfigBean config;
    UserInfo userInfo;
    List<String> mNotice;
    HomeDialog homeDialog;
    private List<Fragment> listFra = new ArrayList<>();
    private List<ConfigBean.DataBean.MobileMenuBean> mobileMenu = new ArrayList<>();
    private List<TextView> mViewList;

    public BlackMainActivity() {
        super(R.layout.black_activity_main, true, true, true);
    }

    @Override
    public void initView() {
        super.initView();
        mApp = (Application) getContextObject();
        sp = getSharedPreferences("User", Context.MODE_PRIVATE);
        fm = getSupportFragmentManager();
        clickTabFragment("/home", "");
        if (!Uiutils.isTourist1(this))
            getAutoTransfer();
        getConfig(false, false);
        getUpdataVersion(false);
        getNotice();
        initData();

        initListener(cbShow, rvGame);
    }

    //侧滑菜单调用
    public void closeSlidingMenu() {
        mDrawerLayout.closeDrawer(Gravity.RIGHT);
    }

    public void openSliding() {
        mDrawerLayout.openDrawer(Gravity.RIGHT);
    }

    //    资金管理
    public void setTab(int i) {
        if (depositFrament != null) {
            depositFrament.setTab(i);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == 100) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (updata != null) {
                    updata.mInstall();
                }
            } else {
                ToastUtils.ToastUtils("您拒绝了SD卡写入权限，要升级请到系统设置-应用管理里把相关权限打开", BlackMainActivity.this);
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1005) {  //资金管理
            try {
                if (data != null && data.getStringExtra("payState") != null) {
                    String payState = data.getStringExtra("payState");
                    if (!TextUtils.isEmpty(payState) && payState.equals("1"))
                        if (depositFrament != null) {
                            depositFrament.setTab(2);
                        }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
    }

    @Override
    public void onDestroy() {
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }

    //额度自动转出转入
    private void getAutoTransfer() {
        Intent intent = new Intent(mApp, MyIntentService.class);
        intent.putExtra("type", "6000");
        startService(intent);
    }

    @OnClick({R.id.iv_menu, R.id.bt_login, R.id.bt_regedit, R.id.framelayout, R.id.tv_finance, R.id.tv_downliad, R.id.tv_activity, R.id.tv_online, R.id.tv_home, R.id.rl_show})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_menu:
                openSliding();
                break;
            case R.id.bt_login:
                if (StringUtils.isEmpty(Uiutils.getToken(this))) {
                    startActivity(new Intent(BlackMainActivity.this, BlackLoginActivity.class));
                } else {
                    clickTabFragment("/user", "-1");
                }
                break;
            case R.id.bt_regedit:
                if (StringUtils.isEmpty(Uiutils.getToken(this))) {
                    clickTabFragment("/regedit", "");
                } else {
//                    clickTabFragment(0, "4");
                    clickTabFragment("/lastread", "-1");
                }
                break;
            case R.id.framelayout:
                break;
            case R.id.rl_show:

                break;
            case R.id.tv_finance:
//                String token = SPConstants.getToken(BlackMainActivity.this);
//                if (TextUtils.isEmpty(token)) {
//                    startActivity(new Intent(BlackMainActivity.this, BlackLoginActivity.class));
//                    return;
//                }
//                if (SPConstants.isTourist(BlackMainActivity.this)) {
//                    startActivity(new Intent(BlackMainActivity.this, BlackLoginActivity.class));
//                    return;
//                }
                if (mobileMenu != null && mobileMenu.size() > 4) {
                    clickTabFragment(mobileMenu.get(4).getPath(), mobileMenu.get(4).getPath().equals("/funds") ? "0" : "-1");
                }

                break;
            case R.id.tv_downliad:
//                getUpdataVersion(true);
                if (mobileMenu != null && mobileMenu.size() > 3) {
                    clickTabFragment(mobileMenu.get(3).getPath(), mobileMenu.get(3).getPath().equals("/funds") ? "0" : "-1");
                }
                break;
            case R.id.tv_activity:
//                clickTabFragment("/activity", "");
                if (mobileMenu != null && mobileMenu.size() > 2) {
                    clickTabFragment(mobileMenu.get(2).getPath(), mobileMenu.get(2).getPath().equals("/funds") ? "0" : "-1");
                }
                break;
            case R.id.tv_online:
//                if (config != null && config.getData() != null && !TextUtils.isEmpty(config.getData().getZxkfUrl())) {
//                    String zxkfurl = config.getData().getZxkfUrl();
//                    SkipGameUtil.loadUrl(zxkfurl, BlackMainActivity.this);
//                } else {
//                    ToastUtils.ToastUtils("客服地址未配置或获取失败", BlackMainActivity.this);
//                }
                if (mobileMenu != null && mobileMenu.size() > 1) {
                    clickTabFragment(mobileMenu.get(1).getPath(), mobileMenu.get(1).getPath().equals("/funds") ? "0" : "-1");
                }
                break;
            case R.id.tv_home:
//                clickTabFragment("/home", "");
                if (mobileMenu != null && mobileMenu.size() > 0) {
                    String typeName = mobileMenu.get(0).getPath();
                    clickTabFragment(mobileMenu.get(0).getPath(), typeName.equals("/funds") ? "0" : "-1");
                }
                break;

        }
    }

    private void initListener(CheckBox cb, View view) {
        cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    AnimationUtil.with().bottomMoveToViewLocation(view, 500);
                    cbShow.setText("收起");
                } else {
                    AnimationUtil.with().moveToViewBottom(view, 500);
                    cbShow.setText("展开");
                }
            }
        });
    }

    private void hideFragment(FragmentTransaction ft) {
        if (listFra != null && listFra.size() > 0) {
            for (Fragment fragment : listFra) {
                ft.hide(fragment);
            }
        }

//        if (blackHomeFrament != null) {
//            ft.hide(blackHomeFrament);
//        }

    }


    //pos 传""不判断是否登录
    public void clickTabFragment(String tabName, String pos) {
        if (!DrawableUtils.menuType(BlackMainActivity.this, tabName, config)) {
            return;
        }

        String token = SPConstants.getValue(BlackMainActivity.this, SPConstants.SP_API_SID);
        if (token.equals(SPConstants.SP_NULL) && (pos.equals("-1") || pos.equals("0") || pos.equals("2"))&&!tabName.equals("/home")) {
            if (!ButtonUtils.isFastDoubleClick()) {
                Intent intent = new Intent(this, BlackLoginActivity.class);
                startActivity(intent);
                return;
            }
        }
        if (tabName.equals("/home")) {
            rlShow.setVisibility(View.GONE);
            rvGame.setVisibility(View.GONE);
            cbShow.setText("展开");
            cbShow.setChecked(false);
        } else {
            if (rlShow.getVisibility() == View.GONE) {
                rlShow.setVisibility(View.VISIBLE);
            }
        }
        if (tabName.equals("/conversion")) {
            rlTitle.setVisibility(View.GONE);
        } else {
            if (rlTitle.getVisibility() == View.GONE) {
                rlTitle.setVisibility(View.VISIBLE);
            }
        }
//        if (tabName.equals("/chatRoomList")) {
//            cbShow.setVisibility(View.GONE);
//        } else {
//            if (cbShow.getVisibility() == View.GONE) {
//                cbShow.setVisibility(View.VISIBLE);
//            }
//        }
        fragmentTransaction = fm.beginTransaction();
        fragmentTransaction.addToBackStack(null);
        hideFragment(fragmentTransaction);

        switch (tabName) {
            case "/home":  //首页

                if (blackHomeFrament == null) {
                    blackHomeFrament = BlackHomeFrament.getInstance();
                    fragmentTransaction.add(R.id.framelayout, blackHomeFrament);
                    listFra.add(blackHomeFrament);
                } else {
                    fragmentTransaction.show(blackHomeFrament);
                }

                break;
            case "/changLong": //长龙助手
                if (dragonAssistantFrag == null) {
                    dragonAssistantFrag = DragonAssistantFrag.getInstance(true);
                    fragmentTransaction.add(R.id.framelayout, dragonAssistantFrag, "clzs");
                    listFra.add(dragonAssistantFrag);
                } else {
                    fragmentTransaction.show(dragonAssistantFrag);
                }
                break;
            case "/lotteryList": //彩票大厅
                if (buyhallfragment == null) {
                    buyhallfragment = BuyHallTypeFragment.getInstance();
                    fragmentTransaction.add(R.id.framelayout, buyhallfragment);
                    listFra.add(buyhallfragment);
                } else {
                    fragmentTransaction.show(buyhallfragment);
                }
                break;
            case "/activity": //优惠活动

                if (couponsfragment == null) {
                    couponsfragment = CouponsFragment.getInstance(true, false);
                    fragmentTransaction.add(R.id.framelayout, couponsfragment);
                    listFra.add(couponsfragment);
                } else {
                    fragmentTransaction.show(couponsfragment);
                }
                break;
            case "/chatRoomList": //聊天室
                if (channelfragment == null || isChat) {
                    isChat = false;
                    channelfragment = ChatFragment.getInstance("");
                    fragmentTransaction.add(R.id.framelayout, channelfragment);
                    listFra.add(channelfragment);
                } else {
                    fragmentTransaction.show(channelfragment);
                }
                break;
            case "/lotteryRecord": //开奖记录
                if (lotteryRecordFrag == null) {
                    lotteryRecordFrag = new LotteryRecordFrag(true);
                    fragmentTransaction.add(R.id.framelayout, lotteryRecordFrag);
                    listFra.add(lotteryRecordFrag);
                } else {
                    fragmentTransaction.show(lotteryRecordFrag);
                }
                break;
            case "/user": //我的

                if (userFrag == null) {
                    userFrag = MyFragment4.getInstance();
                    fragmentTransaction.add(R.id.framelayout, userFrag);
                    listFra.add(userFrag);
                } else {
                    fragmentTransaction.show(userFrag);
                }
                break;
            case "/task": //任务中心

                if (missionCenterFrag == null) {
                    missionCenterFrag = new MissionCenterFrag(true);
                    fragmentTransaction.add(R.id.framelayout, missionCenterFrag);
                    listFra.add(missionCenterFrag);
                } else {
                    fragmentTransaction.show(missionCenterFrag);
                }
                break;
            case "/securityCenter": //安全中心
                if (safetyCenterFrag == null) {
                    safetyCenterFrag = new SafetyCenterFrag(true);
                    fragmentTransaction.add(R.id.framelayout, safetyCenterFrag);
                    listFra.add(safetyCenterFrag);
                } else {
                    fragmentTransaction.show(safetyCenterFrag);
                }
                break;
            case "/funds": //资金管理 1
                if (depositFrament == null) {
                    depositFrament = new FundFrament(true);
                    depositFrament.setPos(pos);
                    fragmentTransaction.add(R.id.framelayout, depositFrament);
                    listFra.add(depositFrament);
                } else {
                    depositFrament.setPos(pos);
                    fragmentTransaction.show(depositFrament);
                }

                break;

            case "/message": //站内信
                if (mailFrag == null) {
                    mailFrag = new MailFrag(true);
                    fragmentTransaction.add(R.id.framelayout, mailFrag);
                    listFra.add(mailFrag);
                } else {
                    fragmentTransaction.show(mailFrag);
                }
                break;
            case "/banks": //银行卡

                if (bankManageFrament == null) {
                    bankManageFrament = new BankManageFrament(true);
                    fragmentTransaction.add(R.id.framelayout, bankManageFrament);
                    listFra.add(bankManageFrament);
                } else {
                    fragmentTransaction.show(bankManageFrament);
                }
                break;
            case "/yuebao": //利息宝

                if (interestDoteyFrament == null) {
                    interestDoteyFrament = new InterestDoteyFrament();
                    fragmentTransaction.add(R.id.framelayout, interestDoteyFrament);
                    listFra.add(interestDoteyFrament);
                } else {
                    fragmentTransaction.show(interestDoteyFrament);
                }
                break;
            case "/Sign": //签到
                initImmersionBar1();
                if (signInFrag == null) {
                    signInFrag = new SignInFrag(true);
                    fragmentTransaction.add(R.id.framelayout, signInFrag);
                    listFra.add(signInFrag);
                } else {
                    fragmentTransaction.show(signInFrag);
                }
                break;
            case "/referrer": //推广收益
                if (Uiutils.isTourist1(this)) {
                    if (recommendBenefitFrag == null) {
                        recommendBenefitFrag = RecommendBenefitFrag.getInstance(true);
                        fragmentTransaction.add(R.id.framelayout, recommendBenefitFrag);
                        listFra.add(recommendBenefitFrag);
                    } else {
                        fragmentTransaction.show(recommendBenefitFrag);
                    }
                    break;
                }
                userInfo = (UserInfo) ShareUtils.getObject(this, SPConstants.USERINFO, UserInfo.class);
                ConfigBean configBean = (ConfigBean) ShareUtils.getObject(this, SPConstants.CONFIGBEAN, ConfigBean.class);
                if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
                    if (recommendBenefitFrag == null) {
                        recommendBenefitFrag = RecommendBenefitFrag.getInstance(true);
                        fragmentTransaction.add(R.id.framelayout, recommendBenefitFrag);
                        listFra.add(recommendBenefitFrag);
                    } else {
                        fragmentTransaction.show(recommendBenefitFrag);
                    }
                    break;
                } else {
                    if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                            .getAgent_m_apply()) && StringUtils.equals("1", configBean.getData()
                            .getAgent_m_apply())) {
//                            FragmentUtilAct.startAct(this, new AgencyProposerFrag(false));
                        if (agencyProposerFrag == null) {
                            agencyProposerFrag = new AgencyProposerFrag(true);
                            fragmentTransaction.add(R.id.framelayout, agencyProposerFrag);
                            listFra.add(agencyProposerFrag);
                        } else {
                            fragmentTransaction.show(agencyProposerFrag);
                        }
                        break;
                    } else {
                        ToastUtil.toastShortShow(this, "在线注册代理已关闭");
                    }
                }

                break;
            case "/conversion": //额度转换
                if (transferFrament == null) {
                    transferFrament = new TransferFrament(true);
                    fragmentTransaction.add(R.id.framelayout, transferFrament);
                    listFra.add(transferFrament);
                } else {
                    fragmentTransaction.show(transferFrament);
                }
                break;
            case "/regedit": //注册
//                if (regeditFrament == null) {
                    regeditFrament = BlackRegeditFrament.getInstance();
                    fragmentTransaction.add(R.id.framelayout, regeditFrament);
                    listFra.add(regeditFrament);
//                } else {
//                    fragmentTransaction.show(regeditFrament);
//                }
                break;
            case "/lastread": //浏览记录
//                if (blackLastReadFrament == null) {
                blackLastReadFrament = BlackLastReadFrament.getInstance(true);
                fragmentTransaction.add(R.id.framelayout, blackLastReadFrament);
                listFra.add(blackLastReadFrament);
//                } else {
//                    fragmentTransaction.show(blackLastReadFrament);
//                }
            default:
        }
        fragmentTransaction.commitAllowingStateLoss();
    }

    private void getUpdataVersion(boolean isShow) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.ANDROIDVERSION) + SecretUtils.DESede("android") + "&sign=" + SecretUtils.RsaToken()).tag(this).execute(new StringCallback() {
            @Override
            public void onSuccess(Response<String> response) {
                if (response != null && response.code() == 200 && response.body() != null) {
                    BaseBean bb = null;
                    try {
                        bb = new Gson().fromJson(response.body(), BaseBean.class);
                    } catch (JsonSyntaxException e) {
                        e.printStackTrace();
                    }
                    if (bb != null && bb.getCode() == 0) {
                        try {
                            UpdataVersionBean uv = new Gson().fromJson(response.body(), UpdataVersionBean.class);
                            if (uv != null && uv.getCode() == 0) {
                                int apkVer = APKVersionCodeUtils.getVersionCode(BlackMainActivity.this);
                                if (uv.getData() != null && !TextUtils.isEmpty(uv.getData().getVersionCode())) {
                                    String verCode = uv.getData().getVersionCode().replaceAll("\\.", "");
                                    if (!StringUtils.isEmpty(verCode) && ShowItem.checkStrIsNum(verCode)) {
                                        Double ver = Double.parseDouble(verCode);
                                        if (ver > apkVer) {
//                                            EventBus.getDefault().postSticky(new Even(50000, response.body() + ""));   //版本更新
                                            EvenBusUtils.setEvenBus(new Even(EvenBusCode.UPDATA,response.body() + ""));
                                        } else {
                                            if (isShow)
                                                ToastUtils.ToastUtils("当前版本已是最新版本", BlackMainActivity.this);
                                        }
                                    }
                                } else if (uv.getData() != null && uv.getData().getVersionCode() != null && uv.getData().getVersionCode().equals("")) {
                                    if (isShow)
                                        ToastUtils.ToastUtils("当前版本已是最新版本", BlackMainActivity.this);
                                }
                            }
                        } catch (JsonSyntaxException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        });

    }

    //配置文件
    public void getConfig(boolean isShowDialogs, boolean isTheme) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.CONFIG)).tag(this).execute(new NetDialogCallBack(this, isShowDialogs, this,
                true, ConfigBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                config = (ConfigBean) o;
                if (config != null && config.getCode() == 0 && config.getData() != null) {
                    if (!TextUtils.isEmpty(config.getData().getMobile_logo())) {
                        ImageLoadUtil.ImageLoad(config.getData().getMobile_logo(), BlackMainActivity.this,
                                ivLogo, "");
                    }
                    ShareUtils.saveObject(BlackMainActivity.this, SPConstants.CONFIGBEAN, config);
                    SharedPreferences.Editor edit = sp.edit();
                    edit.putString(SPConstants.SP_ZXKFURL, config.getData().getZxkfUrl() == null ? "" : config.getData().getZxkfUrl());
                    edit.putString(SPConstants.SP_MOBILE_LOGO, config.getData().getMobile_logo() == null ? "" : config.getData().getMobile_logo());   //首页左边logo
//                    edit.putString(SPConstants.SP_MINWITHDRAWMONEY, config.getData().getMinWithdrawMoney() == null ? "" : config.getData().getMinWithdrawMoney());//下注单笔限额最小
//                    edit.putString(SPConstants.SP_MAXWITHDRAWMONEY, config.getData().getMaxWithdrawMoney() == null ? "" : config.getData().getMaxWithdrawMoney());//下注单笔限额最大
                    edit.putString(SPConstants.SP_YUEBAONAME, config.getData().getYuebaoName() == null ? "" : config.getData().getYuebaoName());//利息宝
//                    edit.putString(SPConstants.SP_APIHOSTS, config.getData().getApiHosts() == null ? "" : String.valueOf(config.getData().getApiHosts()));//域名
                    edit.commit();

                    SPConstants.setListValue(config.getData().getApiHosts());


                    EventBus.getDefault().postSticky(new MessageEvent("config"));
//                    String id = "22";
//                    switch (config.getData().getMobileTemplateCategory()) {
//                        case "0":  //经典
//                            id = config.getData().getMobileTemplateBackground();
//                            break;
//                        case "2":  //新年红
//                            id = "20";
//                            break;
//                        case "3":  //石榴红
//                            id = "21";
//                            break;
//                        case "4":  //一期走经典
//                            config.getData().setMobileTemplateCategory("0");
//                            id = config.getData().getMobileTemplateBackground();
//                            break;
//                    }


//                    if (!StringUtils.equals(id, ShareUtils.getString(BlackMainActivity.this, "themid", ""))) {
//                        ShareUtils.putString(BlackMainActivity.this, "themid", id);
//                        Map<String, Object> map = new HashMap<>();
//                        map.put("themid", id);
//                        map.put("themetyp", config.getData().getMobileTemplateCategory());
////                        }
//                        setTheme(map);
//                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.CHANGE_THEME_STYLE, map));
//                    } else {
//
//                    }
                    tvDomain.setText("易记域名\n" + (config.getData().getEasyRememberDomain() == null ? "" : config.getData().getEasyRememberDomain()));
                    setnavigation();
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

    private void setnavigation() {
        if (config.getData().getMobileMenu() != null && config.getData().getMobileMenu().size() > 0) {
            mobileMenu = config.getData().getMobileMenu();
            setNavigation(mobileMenu);
        } else {
            if (mobileMenu.size() > 0)
                mobileMenu.clear();
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("首页", "/home"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("购彩大厅", "/lotteryList"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("聊天室", "/chatRoomList"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("优惠活动", "/activity"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("我的", "/user"));
            setNavigation(mobileMenu);
        }
    }

    private void setNavigation(List<ConfigBean.DataBean.MobileMenuBean> mobileMenu) {
        mViewList = new ArrayList<>();
        mViewList.add(tvHome);
        mViewList.add(tvOnline);
        mViewList.add(tvActivity);
        mViewList.add(tvDownliad);
        mViewList.add(tvFinance);
        if (mobileMenu.size() < 5) {   //返回4条隐藏一个导航栏
            tvFinance.setVisibility(View.GONE);
        }
        if (mobileMenu.size() < 4) {   //返回3条隐藏一个导航栏
            tvDownliad.setVisibility(View.GONE);
        }
        for (int i = 0; i < mobileMenu.size(); i++) {
            setRadio(mViewList.get(i), i + 1, ShareUtils.getString(this, "themetyp", ""), mobileMenu);
        }
        clickTabFragment("/home", "");
    }

    private void setRadio(TextView textView, int id, String type, List<ConfigBean.DataBean.MobileMenuBean> mobileMenu) {
        Drawable drawable = null;
        DrawableUtils drawableUtils = new DrawableUtils(BlackMainActivity.this, mobileMenu);
        switch (id) {
            case 1:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_first1);
                drawable = drawableUtils.drawable("allblack", 0);
                break;
            case 2:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_second1);
                drawable = drawableUtils.drawable("allblack", 1);
                break;
            case 3:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_third1);
                drawable = drawableUtils.drawable("allblack", 2);
                break;
            case 4:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fourth1);
                drawable = drawableUtils.drawable("allblack", 3);
                break;
            case 5:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fifth1);
                drawable = drawableUtils.drawable("allblack", 4);
                break;
        }

        if (drawable != null) {
            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                    drawable.getMinimumHeight());
            textView.setCompoundDrawables(null, drawable, null, null);
        }
        textView.setTextColor(getResources().getColorStateList(
                R.color.textColor_downSheet_title));
//        }
        textView.setText(mobileMenu.get(id - 1).getName());
    }

    @Override
    protected void onResume() {
        getUser();
        checkLogin();
        super.onResume();
    }

    private void checkLogin() {
        if (StringUtils.isEmpty(Uiutils.getToken(this))) {
            btLogin.setText("登入");
            btRegedit.setText("免费开户");
        } else {
            btLogin.setText("会员中心");
            btRegedit.setText("浏览记录");
        }
    }

    private void getUser() {
        String token = SPConstants.getToken(BlackMainActivity.this);
        if (TextUtils.isEmpty(token)) {
            return;
        }
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken())).
                tag(this).execute(new NetDialogCallBack(this, false, this, true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                UserInfo li = (UserInfo) o;
                if (li != null && li.getCode() == 0) {
                    if (null != userInfo && null != userInfo.getData()) {
                        ShareUtils.saveObject(AppManager.getAppManager().currentActivity(),
                                SPConstants.USERINFO, userInfo);
                        SPConstants.saveData(userInfo,BlackMainActivity.this);
                        EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.LOGIN));
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

    private void getNotice() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.NOTICE)).tag(this).execute(new NetDialogCallBack(this, false, this,
                true, NoticeBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                NoticeBean notice = (NoticeBean) o;
                if (notice != null && notice.getCode() == 0 && notice.getData() != null && notice.getData() != null) {
                    if (notice.getData().getScroll() != null && notice.getData().getScroll().size() != 0) {
                        mNotice = new ArrayList<>();
                        for (NoticeBean.DataBean.Scroll db : notice.getData().getScroll()) {
                            mNotice.add(db.getTitle());
                        }
                        if (notice.getData().getScroll().size() == 1) {
                            mNotice.add(notice.getData().getScroll().get(0).getTitle());
                        }
                        if ((mNotice == null || mNotice.size() == 0) && tvNotice == null)
                            return;
                        tvNotice.setContentList((ArrayList<String>) mNotice);
                        tvNotice.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                int pos = notice.getData().getScroll().size() == 1 ? 0 : tvNotice.getCurrentPos();
                                String[] array = {getResources().getString(R.string.affirm)};
                                TDialog mTDialog = new TDialog(BlackMainActivity.this, TDialog.Style.Center, array,
                                        getResources().getString(R.string.notice), "", notice.getData().getScroll().get(pos).getContent()+ ReplaceUtil.CSS_STYLE, new TDialog.onItemClickListener() {
                                    @Override
                                    public void onItemClick(Object object, int position) {

                                    }
                                });
                                mTDialog.setTitleTextBackgroupColor(R.drawable.blackbg_center);
                                mTDialog.setItemTextColor(getResources().getColor(R.color.white));
                                mTDialog.setTitleTextColor(getResources().getColor(R.color.white));
                                mTDialog.setCancelable(false);
                                mTDialog.show();
                            }
                        });
                    }
                    if (notice.getData().getPopup() != null && notice.getData().getPopup().size() != 0) {
                        notice.getData().getPopup().get(0).setOpen(true);
                        if (homeDialog == null) {
                            homeDialog = new HomeDialog(BlackMainActivity.this, notice.getData().getPopup());
                            homeDialog.show();
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

    @Subscribe(threadMode = ThreadMode.MAIN, sticky = true)
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("2")) {  //退出成功
            checkLogin();
            clickTabFragment("/home", "");
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.LOGIN:  //登录并获取信息
                checkLogin();
                isChat = true;
                break;
            case EvenBusCode.CHECK_THE_UPDATA:  //检查更新
                getVersion();
                break;
            case EvenBusCode.UPDATA:  //更新
                updata = new UpdataUtil(this, even.getData() + "");
                break;
            case EvenBusCode.SHOWFRAMNET:  // 要显示的frament
                if (even.getData().equals("/funds0")) {
                    clickTabFragment("/funds", "0");
                } else if (even.getData().equals("/funds1")) {
                    clickTabFragment("/funds", "1");
                } else {
                    clickTabFragment(even.getData().toString(), "");
                }
                break;
        }
    }

    public void getVersion() {
        getUpdataVersion(true);
    }

    private void initData() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GAMETYPE))//
                .tag(this)//
                .execute(new NetDialogCallBack(this, true, this, true, GameType.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameType gameType = (GameType) o;
                        if (gameType != null && gameType.getCode() == 0 && gameType.getData() != null) {
                            int pos = 0;
                            for (int i = 0; i < gameType.getData().size(); i++) {
                                if (gameType.getData().get(i).getCategory().equals("game")) {
                                    pos = i;
                                }
                            }

                            LinearLayoutManager manager = new LinearLayoutManager(BlackMainActivity.this);
                            manager.setOrientation(LinearLayoutManager.HORIZONTAL);
                            rvGame.setLayoutManager(manager);
                            BlackGameAdapter adapter = new BlackGameAdapter(gameType.getData().get(pos).getGames(), BlackMainActivity.this);
                            rvGame.setAdapter(adapter);

                            int finalPos = pos;
                            adapter.setOnItemClickListener(new BlackGameAdapter.OnItemClickListener() {
                                @Override
                                public void onItemClick(View view, int position) {
                                    if (ButtonUtils.isFastDoubleClick())
                                        return;

                                    try {
                                        HomeGame.DataBean.IconsBean.ListBean data;
                                        data = new HomeGame.DataBean.IconsBean.ListBean();
                                        data.setGameId(gameType.getData().get(finalPos).getGames().get(position).getId());
                                        data.setSeriesId("4");
                                        data.setIcon(gameType.getData().get(finalPos).getGames().get(position).getPic());
                                        data.setTipFlag(gameType.getData().get(finalPos).getGames().get(position).getIsHot());
                                        data.setIsPopup(gameType.getData().get(finalPos).getGames().get(position).getIsPopup()+"");
                                        data.setTitle(gameType.getData().get(finalPos).getGames().get(position).getTitle());
                                        data.setSupportTrial(gameType.getData().get(finalPos).getGames().get(position).getSupportTrial());
                                        Constants.addLastReadList(data);
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }

                                    if (gameType.getData().get(finalPos).getGames().get(position).getIsPopup() == 0) {
                                        goGame(gameType.getData().get(finalPos).getGames(),position);
                                    } else if (gameType.getData().get(finalPos).getGames().get(position).getIsPopup() == 1) {
                                        Intent intent = new Intent();
                                        intent.putExtra("id", gameType.getData().get(finalPos).getGames().get(position).getId());
                                        intent.putExtra("title", gameType.getData().get(finalPos).getGames().get(position).getTitle());
                                        intent.putExtra("supportTrial", gameType.getData().get(finalPos).getGames().get(position).getSupportTrial() + "");
                                        intent.setClass(BlackMainActivity.this, ElectronicActivity.class);
                                        startActivity(intent);
                                    }
                                }
                            });


                        } else if (gameType != null && gameType.getCode() == 1) {

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
    private void goGame(List<GameType.DataBean.GamesBean> mData, int position) {
        String token = SPConstants.getValue(BlackMainActivity.this, SPConstants.SP_API_SID);
        if (token.equals("Null")) {
            Uiutils.login(this);
            return;
        }
        String id = mData.get(position).getId();
        SkipGameUtil.goGame(0,BlackMainActivity.this,id);
    }

    //聊天室隐藏导航栏
    public void setRadioGroup(int show) {
        rlNavig.setVisibility(show);
    }

//    @Subscribe(sticky = true)
//    public void onEvents(Even ev) {
//        if (ev.getCode() == 50000) {//版本更新
//            updata = new UpdataUtil(this, ev.getData() + "");
//        }
//    }
}
