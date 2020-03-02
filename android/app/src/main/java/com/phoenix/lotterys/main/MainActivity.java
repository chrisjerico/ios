package com.phoenix.lotterys.main;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.drawerlayout.widget.DrawerLayout;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.buyhall.BuyHallFragment;
import com.phoenix.lotterys.buyhall.BuyHallTypeFragment;
import com.phoenix.lotterys.chat.fragment.ChatFragment;
import com.phoenix.lotterys.coupons.CouponsFragment;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.home.fragment.BankManageFrament;
import com.phoenix.lotterys.home.fragment.ChessCardFragment;
import com.phoenix.lotterys.home.fragment.FundFrament;
import com.phoenix.lotterys.home.fragment.HomeFragment;
import com.phoenix.lotterys.home.fragment.InterestDoteyFrament;
import com.phoenix.lotterys.home.fragment.RealVideoFragment;
import com.phoenix.lotterys.home.fragment.SimpleHomeFragment;
import com.phoenix.lotterys.home.fragment.TicketAndChatFrament;
import com.phoenix.lotterys.home.fragment.TransferFrament;
import com.phoenix.lotterys.home.fragment.TransferNewFrament;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.UpdataVersionBean;
import com.phoenix.lotterys.my.activity.LoginActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.MailFragBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.AgencyProposerFrag;
import com.phoenix.lotterys.my.fragment.DragonAssistantFrag;
import com.phoenix.lotterys.my.fragment.InTheBuildingFrag;
import com.phoenix.lotterys.my.fragment.LotteryRecordFrag;
import com.phoenix.lotterys.my.fragment.MailFrag;
import com.phoenix.lotterys.my.fragment.MessagPopFrag;
import com.phoenix.lotterys.my.fragment.MissionCenterFrag;
import com.phoenix.lotterys.my.fragment.MyFragment;
import com.phoenix.lotterys.my.fragment.MyFragment1;
import com.phoenix.lotterys.my.fragment.MyFragment2;
import com.phoenix.lotterys.my.fragment.RecommendBenefitFrag;
import com.phoenix.lotterys.my.fragment.SafetyCenterFrag;
import com.phoenix.lotterys.my.fragment.SignInFrag;
import com.phoenix.lotterys.util.APKVersionCodeUtils;
import com.phoenix.lotterys.util.ButtonUtils;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.DrawableUtils;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.UpdataUtil;
import com.phoenix.lotterys.view.MyIntentService;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.AppManager;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import q.rorbin.badgeview.QBadgeView;

import static com.phoenix.lotterys.application.Application.getContextObject;

/**
 * Created by Luke
 * on 2019/6/22
 */
public class MainActivity extends BaseActivity implements View.OnClickListener {

    Application mApp;
    @BindView(R2.id.drawer_main_layout)
    DrawerLayout mDrawerLayout;
    @BindView(R2.id.radioGroup)
    RadioGroup radioGroup;
    @BindView(R2.id.radio_home)
    RadioButton radioHome;
    @BindView(R2.id.radio_buy)
    RadioButton radioBuy;
    @BindView(R2.id.radio_chat)
    RadioButton radioChat;
    @BindView(R2.id.radio_sale)
    RadioButton radioSale;
    @BindView(R2.id.radio_login)
    RadioButton radioLogin;
    @BindView(R2.id.tv_5)
    TextView tv5;
    @BindView(R2.id.tv_4)
    TextView tv4;
    @BindView(R2.id.tv_3)
    TextView tv3;
    @BindView(R2.id.tv_2)
    TextView tv2;
    @BindView(R2.id.tv_1)
    TextView tv1;
    @BindView(R2.id.rl_4)
    RelativeLayout rl_4;
    @BindView(R2.id.rl_5)
    RelativeLayout rl_5;
    @BindView(R2.id.rl_navig)
    RelativeLayout rlNavig;

    private FragmentManager fm;
    private HomeFragment homefragment;
    private BuyHallTypeFragment buyhallfragment;
    private BuyHallFragment buyHallFragment;
    private TicketAndChatFrament ticketAndChatFrament;
    private SimpleHomeFragment simpleHomeFragment;  //简约模板
    private RealVideoFragment realvideoFragment;   //六合模板真人视讯
    private ChessCardFragment chessCardFragment;   //六合模板棋牌

    private BaseFragment myfragment;
    private CouponsFragment couponsfragment;
//    private ChatFragment channelfragment;
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
    private TransferNewFrament transferNewFrament;  //额度转换新
    private FundFrament depositFrament;  //资金管理1
    private AgencyProposerFrag agencyProposerFrag;  //代理

    private InTheBuildingFrag inTheBuildingFrag;  //


    private List<Integer> mRadioGroup;
    int count = 0;
    private UpdataUtil updata;
    private SharedPreferences sp;
    private List<ConfigBean.DataBean.MobileMenuBean> mobileMenu = new ArrayList<>();
    private FragmentTransaction fragmentTransaction;
    //    BadgeHelper badgeHelperC;  //小红点
    private UserInfo userInfo;
    private List<RadioButton> mGroup;
    private List<TextView> badgeText;
    private QBadgeView badge;
    private String categoryNum;   //模板编号

    @Override
    public void getIntentData() {

    }

    public MainActivity() {
        super(R.layout.activity_main, true, true, true);
    }

    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 1:
                    getMessage();
                    handler.sendEmptyMessageDelayed(1, 1000 * 2 * 60);
                    break;
            }
        }
    };

    private String mesId = "-1";

    private void getMessage() {
        if (StringUtils.isEmpty(Uiutils.getToken(this)))
            return;

        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(this));
        map.put("page", "1");
        map.put("rows", "1");

        NetUtils.get(Constants.MSGLIST, map, false, this
                , new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        MailFragBean mailFragBean = GsonUtil.fromJson(object, MailFragBean.class);
                        if (null != mailFragBean && null != mailFragBean.getData() && null != mailFragBean.
                                getData().getRealTime()) {
                            if (!StringUtils.isEmpty(mesId) &&
                                    !StringUtils.isEmpty(mailFragBean.getData().getRealTime().getId()) &&
                                    !StringUtils.equals("0", mailFragBean.getData().getRealTime().getId()) &&
                                    !StringUtils.equals(mesId, mailFragBean.getData().getRealTime().getId())
                                    && 0 == mailFragBean.getData().getRealTime().getIsRead()) {
                                if (!Constants.isHowMag) {
                                    Constants.isHowMag = true;
                                    Intent intent = new Intent(MainActivity.this, MessagPopFrag.class);
                                    intent.putExtra("name", mailFragBean.getData().getRealTime().getContent());
                                    intent.putExtra("id", mailFragBean.getData().getRealTime().getId());
                                    MainActivity.this.startActivity(intent);
                                    mesId = mailFragBean.getData().getRealTime().getId();
                                } else {
                                    MailFragBean.DataBean.ListBean listBean = new MailFragBean.DataBean.ListBean();
                                    listBean.setId(mailFragBean.getData().getRealTime().getId());
                                    listBean.setName(mailFragBean.getData().getRealTime().getContent());
                                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.message_update_popup, listBean));
                                    mesId = mailFragBean.getData().getRealTime().getId();
                                }
                            }
                        }
                    }

                    @Override
                    public void onError() {
                    }
                });
    }

    @Override
    public void initView() {
        super.initView();
        mApp = (Application) getContextObject();
        sp = getSharedPreferences("User", Context.MODE_PRIVATE);
        getUpdataVersion(false);
//        mState();
//        titleClick();
//        getConfig(true);//配置文件
        config = (ConfigBean) ShareUtils.getObject(this, SPConstants.CONFIGBEAN, ConfigBean.class);
        fm = getSupportFragmentManager();
        mRadioGroup = new ArrayList<>();
        mRadioGroup.add(R.id.radio_home);
        mRadioGroup.add(R.id.radio_buy);
        mRadioGroup.add(R.id.radio_chat);
        mRadioGroup.add(R.id.radio_sale);
        mRadioGroup.add(R.id.radio_login);
        radioGroup.check(R.id.radio_home);
        clickTabFragment(0);
        count = R.id.radio_home;
        getConfig(false, false);
        badge = new QBadgeView(MainActivity.this);
        badge.setBadgeGravity(Gravity.END | Gravity.TOP);

        if (!Uiutils.isTourist1(this))
            getAutoTransfer();


        handler.removeMessages(1);
        handler.sendEmptyMessage(1);
    }

    private void setNavigation(List<ConfigBean.DataBean.MobileMenuBean> mobileMenu) {
        if (!StringUtils.isEmpty(ShareUtils.getString(this, "themetyp", ""))) {
            mGroup = new ArrayList<>();
            mGroup.add(radioHome);
            mGroup.add(radioBuy);
            mGroup.add(radioChat);
            mGroup.add(radioSale);
            mGroup.add(radioLogin);
            badgeText = new ArrayList<>();
            badgeText.add(tv1);
            badgeText.add(tv2);
            badgeText.add(tv3);
            badgeText.add(tv4);
            badgeText.add(tv5);


            if (mobileMenu.size() < 5) {   //返回4条隐藏一个导航栏
                radioLogin.setVisibility(View.GONE);
//                tv5.setVisibility(View.GONE);
                rl_5.setVisibility(View.GONE);
            }
            if (mobileMenu.size() < 4) {   //返回3条隐藏一个导航栏
                radioSale.setVisibility(View.GONE);
//                tv4.setVisibility(View.GONE);
                rl_4.setVisibility(View.GONE);
            }
            for (int i = 0; i < mobileMenu.size(); i++) {
                if (i <= 4)
                    setRadio(mGroup.get(i), i + 1, ShareUtils.getString(this, "themetyp", ""), mobileMenu);
//                }
            }
            //设置小红点消息
            setBadge();

        }
    }

    private boolean isNewYear() {
        //当前的主题是哪个模板
        String themid = ShareUtils.getString(this, "themid", "");
        if (StringUtils.equals("34", themid) || StringUtils.equals("20", themid))
            return true;
        else
            return false;
    }

    private void setRadio(RadioButton radioButton, int id, String type, List<ConfigBean.DataBean.MobileMenuBean> mobileMenu) {
        Drawable drawable = null;
        DrawableUtils drawableUtils = new DrawableUtils(MainActivity.this, mobileMenu);
        if (StringUtils.equals("2", type)) {
            switch (id) {
                case 1:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_first1);
                    if (isNewYear()) {
                        drawable = drawableUtils.drawable("black", 0);
                    } else {
                        drawable = drawableUtils.drawable("yellow", 0);
                    }
                    break;
                case 2:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_second1);
                    if (isNewYear()) {
                        drawable = drawableUtils.drawable("black", 1);
                    } else {
                        drawable = drawableUtils.drawable("yellow", 1);
                    }
                    break;
                case 3:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_third1);
                    if (isNewYear()) {
                        drawable = drawableUtils.drawable("black", 2);
                    } else {
                        drawable = drawableUtils.drawable("yellow", 2);
                    }
                    break;
                case 4:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fourth1);
                    if (isNewYear()) {
                        drawable = drawableUtils.drawable("black", 3);
                    } else {
                        drawable = drawableUtils.drawable("yellow", 3);
                    }
                    break;
                case 5:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fifth1);
                    if (isNewYear()) {
                        drawable = drawableUtils.drawable("black", 4);
                    } else {
                        drawable = drawableUtils.drawable("yellow", 4);
                    }
                    break;
            }
//            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
//                    drawable.getMinimumHeight());
//            radioButton.setCompoundDrawables(null, drawable, null, null);

            if (drawable != null) {
                drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                        drawable.getMinimumHeight());
                radioButton.setCompoundDrawables(null, drawable, null, null);
            }
            if (isNewYear()) {
                radioButton.setTextColor(getResources().getColorStateList(
                        R.color.menubar_text0));
            } else {
                radioButton.setTextColor(getResources().getColorStateList(
                        R.color.menubar_text1));
            }

        } else if (StringUtils.equals("3", type) || StringUtils.equals("4", type)|| StringUtils.equals("9", type)) {
            switch (id) {
                case 1:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_first1);
                    drawable = drawableUtils.drawable("red", 0);
                    break;
                case 2:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_second1);
                    drawable = drawableUtils.drawable("red", 1);
                    break;
                case 3:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_third1);
                    drawable = drawableUtils.drawable("red", 2);
                    break;
                case 4:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fourth1);
                    drawable = drawableUtils.drawable("red", 3);
                    break;
                case 5:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fifth1);
                    drawable = drawableUtils.drawable("red", 4);
                    break;
            }
//            drawable.setBounds(0, 0, drawable.getMinimumWidth(),
//                    drawable.getMinimumHeight());
//            radioButton.setCompoundDrawables(null, drawable, null, null);

            if (drawable != null) {
                drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                        drawable.getMinimumHeight());
                radioButton.setCompoundDrawables(null, drawable, null, null);
            }
            radioButton.setTextColor(getResources().getColorStateList(
                    R.color.menubar_text2));
        } else if (StringUtils.equals("0", type)) {
            switch (id) {
                case 1:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_first0);
                    drawable = drawableUtils.drawable("black", 0);
                    break;
                case 2:
//                    drawable = getResources().getDrawable( R.drawable.selector_menubar_second0);
                    drawable = drawableUtils.drawable("black", 1);
                    break;
                case 3:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_third0);
                    drawable = drawableUtils.drawable("black", 2);
                    break;
                case 4:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fourth0);
                    drawable = drawableUtils.drawable("black", 3);
                    break;
                case 5:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fifth0);
                    drawable = drawableUtils.drawable("black", 4);
                    break;
            }

            if (drawable != null) {
                drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                        drawable.getMinimumHeight());
                radioButton.setCompoundDrawables(null, drawable, null, null);
            }
            radioButton.setTextColor(getResources().getColorStateList(
                    R.color.menubar_text0));
        } else {
            switch (id) {
                case 1:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_first);
                    drawable = drawableUtils.drawable("blue", 0);
                    break;
                case 2:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_second);
                    drawable = drawableUtils.drawable("blue", 1);
                    break;
                case 3:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_third);
                    drawable = drawableUtils.drawable("blue", 2);
                    break;
                case 4:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fourth);
                    drawable = drawableUtils.drawable("blue", 3);
                    break;
                case 5:
//                    drawable = getResources().getDrawable(R.drawable.selector_menubar_fifth);
                    drawable = drawableUtils.drawable("blue", 4);
                    break;
            }
            if (drawable != null) {
                drawable.setBounds(0, 0, drawable.getMinimumWidth(),
                        drawable.getMinimumHeight());
                radioButton.setCompoundDrawables(null, drawable, null, null);
            }
            radioButton.setTextColor(getResources().getColorStateList(
                    R.color.menubar_text));
        }
        radioButton.setText(mobileMenu.get(id - 1).getName());
    }


    //额度自动转出转入
    private void getAutoTransfer() {
        Intent intent = new Intent(mApp, MyIntentService.class);
        intent.putExtra("type", "6000");
        startService(intent);
    }

    private void hideFragment(FragmentTransaction ft) {
        if (homefragment != null) {
            ft.hide(homefragment);
        }
        if (buyhallfragment != null) {
            ft.hide(buyhallfragment);
        }
        if (myfragment != null) {
            ft.hide(myfragment);
        }
        if (couponsfragment != null) {
            ft.hide(couponsfragment);
        }
//        if (channelfragment != null) {
//            ft.hide(channelfragment);
//        }
        if (dragonAssistantFrag != null) {
            ft.hide(dragonAssistantFrag);
        }
        if (mailFrag != null) {
            ft.hide(mailFrag);
        }
        if (lotteryRecordFrag != null) {
            ft.hide(lotteryRecordFrag);
        }
        if (missionCenterFrag != null) {
            ft.hide(missionCenterFrag);
        }
        if (safetyCenterFrag != null) {
            ft.hide(safetyCenterFrag);
        }
        if (recommendBenefitFrag != null) {
            ft.hide(recommendBenefitFrag);
        }
        if (signInFrag != null) {
            ft.hide(signInFrag);
        }
        if (bankManageFrament != null) {
            ft.hide(bankManageFrament);
        }
        if (interestDoteyFrament != null) {
            ft.hide(interestDoteyFrament);
        }
        if (transferFrament != null) {
            ft.hide(transferFrament);
        }
        if (depositFrament != null) {
            ft.hide(depositFrament);
        }
        if (agencyProposerFrag != null) {
            ft.hide(agencyProposerFrag);
        }
        if (realvideoFragment != null) {    //真人视讯
            ft.hide(realvideoFragment);
        }
        if (chessCardFragment != null) {    //棋牌
            ft.hide(chessCardFragment);
        }

        if (inTheBuildingFrag != null) {    //棋牌
            ft.hide(inTheBuildingFrag);
        }

        if (buyHallFragment != null) {    //棋牌
            ft.hide(buyHallFragment);
        }
        if (ticketAndChatFrament != null) {    //聊天室带下注页面
            ft.hide(ticketAndChatFrament);
        }
        if (simpleHomeFragment != null) {    //简约模板 首页
            ft.hide(simpleHomeFragment);
        }
        if (transferNewFrament != null) {    //额度转换
            ft.hide(transferNewFrament);
        }
    }

    private void clickTabFragment(int tabIndex) {
        fragmentTransaction = fm.beginTransaction();
        fragmentTransaction.addToBackStack(null);
        hideFragment(fragmentTransaction);
        if (mobileMenu == null || mobileMenu.size() == 0) {
            switch (tabIndex) {
                case 0:
//                    switch (config == null ? "0" : config.getData() == null ? "0" : config.getData().getMobileTemplateCategory()) {
//                        case "9":
//                            if (simpleHomeFragment == null) {
//                                simpleHomeFragment = SimpleHomeFragment.getInstance();
//                                fragmentTransaction.add(R.id.framelayout, simpleHomeFragment);
//                            } else {
//                                fragmentTransaction.show(simpleHomeFragment);
//                            }
//                            break;
//                        default :
//                                if (homefragment == null) {
//                                    homefragment = HomeFragment.getInstance();
//                                    fragmentTransaction.add(R.id.framelayout, homefragment);
//                                } else {
//                                    fragmentTransaction.show(homefragment);
//                                }
//                          break;
//                    }
                    if (homefragment == null) {
                        homefragment = HomeFragment.getInstance();
                        fragmentTransaction.add(R.id.framelayout, homefragment);
                    } else {
                        fragmentTransaction.show(homefragment);
                    }
                    break;
                case 1:
                    if (buyhallfragment == null) {
                        buyhallfragment = BuyHallTypeFragment.getInstance();
                        fragmentTransaction.add(R.id.framelayout, buyhallfragment);
                    } else {
                        fragmentTransaction.show(buyhallfragment);
                    }

                    break;
                case 2:
//                    if (channelfragment == null || isChat) {
//                        channelfragment = ChatFragment.getInstance("");
//                        fragmentTransaction.add(R.id.framelayout, channelfragment);
//                        isChat = false;
//                    } else {
//                        fragmentTransaction.show(channelfragment);
//                    }

                    if (ticketAndChatFrament == null || isChat) {
                        ticketAndChatFrament = TicketAndChatFrament.getInstance(true, false);
                        fragmentTransaction.add(R.id.framelayout, ticketAndChatFrament);
                        isChat = false;
                    } else {
                        fragmentTransaction.show(ticketAndChatFrament);
                    }
                    break;
                case 3:
                    if (couponsfragment == null) {
                        couponsfragment = CouponsFragment.getInstance(true, false);
                        fragmentTransaction.add(R.id.framelayout, couponsfragment);
                    } else {
                        fragmentTransaction.show(couponsfragment);
                    }
                    break;
                case 4:
                    if (myfragment == null) {
                        setMyf();
                        fragmentTransaction.add(R.id.framelayout, myfragment);
                    } else {
                        fragmentTransaction.show(myfragment);
                    }
                    break;
//                case 5:
//                    if (dragonAssistantFrag == null) {
//                        dragonAssistantFrag = new DragonAssistantFrag(true);
//                        fragmentTransaction.add(R.id.framelayout, dragonAssistantFrag);
//                    } else {
//                        fragmentTransaction.show(dragonAssistantFrag);
//                    }
//                    break;

            }
        } else {

            if (mobileMenu.size() <= tabIndex) {
                return;
            }

            if (mobileMenu.get(tabIndex).getStatus() == 1) {
                isStructure(tabIndex);
                return;
            }

//            mTransaction = mManager.beginTransaction();
            switch (mobileMenu.get(tabIndex).getPath()) {
                case "/home":  //首页
                    if (homefragment == null) {
                        homefragment = HomeFragment.getInstance();
                        fragmentTransaction.add(R.id.framelayout, homefragment);
                    } else {
                        fragmentTransaction.show(homefragment);
                    }

//                    switch (config == null ? "0" : config.getData() == null ? "0" : config.getData().getMobileTemplateCategory()) {
//                        case "9":
//                            if (simpleHomeFragment == null) {
//                                simpleHomeFragment = SimpleHomeFragment.getInstance();
//                                fragmentTransaction.add(R.id.framelayout, simpleHomeFragment);
//                            } else {
//                                fragmentTransaction.show(simpleHomeFragment);
//                            }
//                            break;
//                        default :
//                                if (homefragment == null) {
//                                    homefragment = HomeFragment.getInstance();
//                                    fragmentTransaction.add(R.id.framelayout, homefragment);
//                                } else {
//                                    fragmentTransaction.show(homefragment);
//                                }
//                    }
                    break;
                case "/changLong": //长龙助手
                    if (dragonAssistantFrag == null) {
                        dragonAssistantFrag = DragonAssistantFrag.getInstance(true);
                        fragmentTransaction.add(R.id.framelayout, dragonAssistantFrag, "clzs");
                    } else {
                        fragmentTransaction.show(dragonAssistantFrag);
                    }
                    break;
                case "/gameHall": //彩票大厅
                    if (buyHallFragment == null) {
                        buyHallFragment = BuyHallFragment.getInstance();
                        fragmentTransaction.add(R.id.framelayout, buyHallFragment);
                    } else {
                        fragmentTransaction.show(buyHallFragment);
                    }
                    break;
                case "/activity": //优惠活动
                    if (couponsfragment == null) {
                        couponsfragment = CouponsFragment.getInstance(true, false);
                        fragmentTransaction.add(R.id.framelayout, couponsfragment);

                    } else {
                        fragmentTransaction.show(couponsfragment);
                    }
                    break;
                case "/chatRoomList": //聊天室
//                    if (channelfragment == null || isChat) {
//                        isChat = false;
//                        channelfragment = ChatFragment.getInstance("");
//                        fragmentTransaction.add(R.id.framelayout, channelfragment);
//
//                    } else {
//                        fragmentTransaction.show(channelfragment);
//                    }
                    if (ticketAndChatFrament == null || isChat) {
                        isChat = false;
                        ticketAndChatFrament = TicketAndChatFrament.getInstance(true, false);
                        fragmentTransaction.add(R.id.framelayout, ticketAndChatFrament);

                    } else {
                        fragmentTransaction.show(ticketAndChatFrament);
                    }
                    break;
                case "/lotteryRecord": //开奖记录
                    if (lotteryRecordFrag == null) {
                        lotteryRecordFrag = new LotteryRecordFrag(true);
                        fragmentTransaction.add(R.id.framelayout, lotteryRecordFrag);

                    } else {
                        fragmentTransaction.show(lotteryRecordFrag);
                    }
                    break;
                case "/user": //我的
                    if (myfragment == null) {
                        setMyf();
//                        myfragment = new MyFragment2(false);
                        fragmentTransaction.add(R.id.framelayout, myfragment);

                    } else {
                        fragmentTransaction.show(myfragment);
                    }
                    break;
                case "/task": //任务中心

                    if (missionCenterFrag == null) {
                        missionCenterFrag = new MissionCenterFrag(true);
                        fragmentTransaction.add(R.id.framelayout, missionCenterFrag);

                    } else {
                        fragmentTransaction.show(missionCenterFrag);
                    }
                    break;
                case "/securityCenter": //安全中心
                    if (safetyCenterFrag == null) {
                        Log.e("securityCenter", "securityCenter");
                        safetyCenterFrag = new SafetyCenterFrag(true);
                        fragmentTransaction.add(R.id.framelayout, safetyCenterFrag);

                    } else {
                        Log.e("securityCenter111", "securityCenter");
                        fragmentTransaction.show(safetyCenterFrag);
                    }
                    break;
                case "/funds": //资金管理

                    if (depositFrament == null) {
                        depositFrament = new FundFrament(true);
                        fragmentTransaction.add(R.id.framelayout, depositFrament);

                    } else {
                        fragmentTransaction.show(depositFrament);
                    }
                    break;
                case "/message": //站内信
                    if (mailFrag == null) {
                        mailFrag = new MailFrag(true);
                        fragmentTransaction.add(R.id.framelayout, mailFrag);

                    } else {
                        fragmentTransaction.show(mailFrag);
                    }
                    break;
                case "/banks": //银行卡

                    if (bankManageFrament == null) {
                        bankManageFrament = new BankManageFrament(true);
                        fragmentTransaction.add(R.id.framelayout, bankManageFrament);

                    } else {
                        fragmentTransaction.show(bankManageFrament);
                    }
                    break;
                case "/yuebao": //利息宝

                    if (interestDoteyFrament == null) {
                        interestDoteyFrament = new InterestDoteyFrament();
                        fragmentTransaction.add(R.id.framelayout, interestDoteyFrament);

                    } else {
                        fragmentTransaction.show(interestDoteyFrament);
                    }
                    break;
                case "/Sign": //签到
                    initImmersionBar1();
                    if (signInFrag == null) {
                        signInFrag = new SignInFrag(true);
                        fragmentTransaction.add(R.id.framelayout, signInFrag);

                    } else {
                        fragmentTransaction.show(signInFrag);
                    }
                    break;
                case "/referrer": //推广收益
                    if (Uiutils.isTourist1(this)) {
                        if (recommendBenefitFrag == null) {
                            recommendBenefitFrag = RecommendBenefitFrag.getInstance(true);
                            fragmentTransaction.add(R.id.framelayout, recommendBenefitFrag, "tgsy");
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
                            fragmentTransaction.add(R.id.framelayout, recommendBenefitFrag, "tgsy");
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
                                fragmentTransaction.add(R.id.framelayout, agencyProposerFrag, "tgsy");
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
                    } else {
                        fragmentTransaction.show(transferFrament);
                    }

//                    if (transferNewFrament == null) {
//                        transferNewFrament = new TransferNewFrament(true);
//                        fragmentTransaction.add(R.id.framelayout, transferNewFrament);
//                    } else {
//                        fragmentTransaction.show(transferNewFrament);
//                    }
                    break;
                case "/zrsx": //真人
                    if (realvideoFragment == null) {
                        realvideoFragment = RealVideoFragment.getInstance(mobileMenu.get(tabIndex).getName());
                        fragmentTransaction.add(R.id.framelayout, realvideoFragment);
                    } else {
                        fragmentTransaction.show(realvideoFragment);
                    }
                    break;

                case "/qpdz": //棋牌
                    if (chessCardFragment == null) {
                        chessCardFragment = new ChessCardFragment();
                        Bundle bundle = new Bundle();
                        bundle.putString("name", mobileMenu.get(tabIndex).getName());
                        chessCardFragment.setArguments(bundle);
                        fragmentTransaction.add(R.id.framelayout, chessCardFragment);
                    } else {
                        fragmentTransaction.show(chessCardFragment);
                    }
                    break;
                case "/lotteryList": //
                    if (buyhallfragment == null) {
                        buyhallfragment = BuyHallTypeFragment.getInstance();
                        Bundle bundle = new Bundle();
                        bundle.putString("title", mobileMenu.get(tabIndex).getName());
                        buyhallfragment.setArguments(bundle);
                        fragmentTransaction.add(R.id.framelayout, buyhallfragment);
                    } else {
                        fragmentTransaction.show(buyhallfragment);
                    }
                    break;
                default:
                    break;
            }
        }
        fragmentTransaction.commitAllowingStateLoss();
    }

    private void isStructure(int tabIndex) {
        if (inTheBuildingFrag == null) {
            inTheBuildingFrag = new InTheBuildingFrag();
            Bundle bundle = new Bundle();
            bundle.putString("title", mobileMenu.get(tabIndex).getName());
            inTheBuildingFrag.setArguments(bundle);
            fragmentTransaction.add(R.id.framelayout, inTheBuildingFrag);
        } else {
//            Bundle bundle =new Bundle();
//            bundle.putString("title",mobileMenu.get(tabIndex).getName());
//            inTheBuildingFrag.setArguments(bundle);
            EvenBusUtils.setEvenBus(new Even(EvenBusCode.SETTITLE0, mobileMenu.get(tabIndex).getName()));
            fragmentTransaction.show(inTheBuildingFrag);
        }
        fragmentTransaction.commitAllowingStateLoss();
    }

    private void setMyf() {
        if (!StringUtils.isEmpty(ShareUtils.getString(this, "themetyp", ""))) {
            switch (ShareUtils.getString(this, "themetyp", "")) {
                case "0":
                    myfragment = new MyFragment1(true);
                    break;
                case "2":
                    myfragment = new MyFragment1(true);
                    break;
                case "3":
                    myfragment = new MyFragment1(true);
                    break;
                case "4":
                    myfragment = new MyFragment2(true);
                    break;
                default:
                    myfragment = new MyFragment(true);
                    break;
            }
        } else {
            myfragment = new MyFragment(true);
        }
    }

    @Override
    public void onDestroy() {
        handler.removeMessages(1);
        handler = null;
        OkGo.getInstance().cancelAll();
        super.onDestroy();
    }

    @Subscribe(threadMode = ThreadMode.MAIN, sticky = true)
    public void onMoonEvents(MessageEvent messageEvent) {
        if (messageEvent.getMessage().equals("2")) {  //退出成功
            postion = -1;
            count = R.id.radio_home;
            TabRad(0);
            if (badge != null) {
                badge.setBadgeNumber(0);
            }
        } else if (messageEvent.getMessage().equals("login")) {
            TabRad(0);
        } else if (messageEvent.getMessage().equals("login_my")) {
            for (int c = 0; c < mGroup.size(); c++) {
                if (mGroup.get(c).getText().toString().equals("我的")) {
                    TabRad(c);
                }
            }
        }

    }

    private void TabRad(int tab) {
        clickTabFragment(tab);
        radioGroup.check(mRadioGroup.get(tab));
    }

    @Subscribe(sticky = true)
    public void onEvents(Even ev) {
        if (ev.getCode() == 50000) {//版本更新
            updata = new UpdataUtil(this, ev.getData() + "");
        }
    }

    @Override
    protected void onResume() {
        getUser();
        super.onResume();
    }

    private void getUser() {

        String token = SPConstants.getToken(this);
        if (TextUtils.isEmpty(token)) {
            return;
        }
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken())).
                tag(this).execute(new NetDialogCallBack(this, false, this, true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                userInfo = (UserInfo) o;
                if (userInfo != null && userInfo.getCode() == 0) {
                    if (null != userInfo && null != userInfo.getData()) {
                        ShareUtils.saveObject(AppManager.getAppManager().currentActivity(),
                                SPConstants.USERINFO, userInfo);
                        SPConstants.saveData(userInfo, MainActivity.this);
                        EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.LOGIN));
                        setBadge();
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

    //侧滑菜单调用
    public void closeSlidingMenu() {
        mDrawerLayout.closeDrawer(Gravity.RIGHT);
    }

    //关闭
    public void lockedSlidingMenu() {
        if (mDrawerLayout != null)
            mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
    }

    //开启
    public void enabledSlidingMenu() {
        mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED);
    }


    //侧滑菜单调用
    public void setNavigation(int navigation) {
        clickTabFragment(navigation);
        radioGroup.check(mRadioGroup.get(navigation));
        count = R.id.radio_home;
    }

    public void setRadioGroup(int show) {
//        radioGroup.setVisibility(show);
        rlNavig.setVisibility(show);

    }

    @OnClick({R.id.radio_home, R.id.radio_buy, R.id.radio_chat, R.id.radio_sale, R.id.radio_login})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.radio_home:
                mClickTab(R.id.radio_home, 0);
                break;
            case R.id.radio_buy:
                mClickTab(R.id.radio_buy, 1);
                break;
            case R.id.radio_chat:
                mClickTab(R.id.radio_chat, 2);
                break;
            case R.id.radio_sale:

                mClickTab(R.id.radio_sale, 3);
                break;
            case R.id.radio_login:

                mClickTab(R.id.radio_login, 4);
                break;
        }
    }

    private int postion;

    private void mClickTab(int id, int pos) {
        initImmersionBar();
        if (postion == pos) {

            return;
        }
        if (mobileMenu != null && mobileMenu.size() > 0) {
            if (!DrawableUtils.menuType(MainActivity.this, mobileMenu.get(pos).getPath(), config)) {
                postion = -1;
                radioGroup.check(count);
                return;
            }
        }

        String token = SPConstants.getValue(MainActivity.this, SPConstants.SP_API_SID);
//        "/lotteryList"
        if (mobileMenu != null && mobileMenu.size() > 0 && (mobileMenu.get(pos).getPath().equals("/activity") || mobileMenu.get(pos).getPath().equals("/home"))) {
            if (mobileMenu.get(pos).getPath().equals("/activity") && ((Uiutils.isSite("c049") || Uiutils.isSite("c008")) &&
                    StringUtils.isEmpty(Uiutils.getToken(this)))) {
                Intent intent = new Intent(this, LoginActivity.class);
                startActivity(intent);
            } else {
                count = id;
                clickTabFragment(pos);
            }
        } else if (mobileMenu != null && mobileMenu.size() > 0 && (mobileMenu.get(pos).getPath().equals("/gameHall") || mobileMenu.get(pos).getPath().equals("/zrsx")
                || mobileMenu.get(pos).getPath().equals("/qpdz")) && categoryNum != null && categoryNum.equals("4")) {   //六合模板彩票大厅不用登陆
            count = id;
            clickTabFragment(pos);
        } else if (!token.equals(SPConstants.SP_NULL)) {
            count = id;
            clickTabFragment(pos);
        } else {
            radioGroup.check(count);
            if (!ButtonUtils.isFastDoubleClick()) {
                postion = -1;
                Intent intent = new Intent(this, LoginActivity.class);
                startActivity(intent);
                return;
            }
        }
        postion = pos;
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == 100) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (updata != null) {
                    updata.mInstall();
                }
            } else {
                ToastUtils.ToastUtils("您拒绝了SD卡写入权限，要升级请到系统设置-应用管理里把相关权限打开", MainActivity.this);
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    boolean isChat = false;

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.TABHOME:  //返回首页
                TabRad(0);
                break;
            case EvenBusCode.LOGIN:  //登录并获取信息
                isChat = true;
                setBadge();
                break;
            case EvenBusCode.CHECK_THE_UPDATA:  //检查更新
                getVersion();
                break;
        }
    }

    private void setTheme(Map<String, Object> map) {
//        Log.e("11111111", "///");
//        Map<String, Object> map = (Map<String, Object>) even.getData();
        if (null == map && map.size() == 0)
            return;
        if (map.containsKey("themid")) {
            switch (((String) map.get("themid"))) {
                case "1":
                    putIntSp(R.style.AppTheme1, R.color.ba_top_1, R.drawable.theme_ba1,
                            R.color.ba_bottom_1, map);
                    break;
                case "2":
                    putIntSp(R.style.AppTheme2, R.color.ba_top_2, R.drawable.theme_ba2,
                            R.color.ba_bottom_2, map);
                    break;
                case "3":
                    if (Uiutils.isSite("c228")) {
                        putIntSp(R.style.AppTheme3_2, R.color.ba_top_20, R.drawable.theme_ba3,
                                R.color.ba_bottom_3, map);
                    } else {
                        putIntSp(R.style.AppTheme3, R.color.ba_top_3, R.drawable.theme_ba3,
                                R.color.ba_bottom_3, map);
                    }
                    break;
                case "4":
                    putIntSp(R.style.AppTheme4, R.color.ba_top_4, R.drawable.theme_ba4,
                            R.color.ba_bottom_4, map);
                    break;
                case "5":
                    putIntSp(R.style.AppTheme5, R.color.ba_top_5, R.drawable.theme_ba5,
                            R.color.ba_bottom_5, map);
                    break;
                case "6":
                    putIntSp(R.style.AppTheme6, R.color.ba_top_6, R.drawable.theme_ba6,
                            R.color.ba_bottom_6, map);
                    break;
                case "7":
                    putIntSp(R.style.AppTheme7, R.color.ba_top_7, R.drawable.theme_ba7,
                            R.color.ba_bottom_7, map);
                    break;
                case "8":
                    putIntSp(R.style.AppTheme8, R.color.ba_top_8, R.drawable.theme_ba8,
                            R.color.ba_bottom_8, map);
                    break;
                case "9":
                    putIntSp(R.style.AppTheme9, R.color.ba_top_9, R.drawable.theme_ba9,
                            R.color.ba_bottom_9, map);
                    break;
                case "10":
                    putIntSp(R.style.AppTheme10, R.color.ba_top_10, R.drawable.theme_ba10,
                            R.color.ba_bottom_10, map);
                    break;
                case "11":
                    putIntSp(R.style.AppTheme11, R.color.ba_top_11, R.drawable.theme_ba11,
                            R.color.ba_bottom_11, map);
                    break;
                case "12":
                    putIntSp(R.style.AppTheme12, R.color.ba_top_12, R.drawable.theme_ba12,
                            R.color.ba_bottom_12, map);
                    break;
                case "13":
                    putIntSp(R.style.AppTheme13, R.color.ba_top_13, R.drawable.theme_ba13,
                            R.color.ba_bottom_13, map);
                    break;
                case "14":
                    putIntSp(R.style.AppTheme14, R.color.ba_top_14, R.drawable.theme_ba14,
                            R.color.ba_bottom_14, map);
                    break;
                case "15":
                    putIntSp(R.style.AppTheme15, R.color.ba_top_15, R.drawable.theme_ba15,
                            R.color.ba_bottom_15, map);
                    break;
                case "16":
                    putIntSp(R.style.AppTheme16, R.color.ba_top_16, R.drawable.theme_ba16,
                            R.color.ba_bottom_16, map);
                    break;
                case "17":
                    putIntSp(R.style.AppTheme17, R.color.ba_top_17, R.drawable.theme_ba17,
                            R.color.ba_bottom_17, map);
                    break;
                case "18":
                    putIntSp(R.style.AppTheme18, R.color.ba_top_18, R.drawable.theme_ba18,
                            R.color.ba_bottom_18, map);
                    break;
                case "19":
                    putIntSp(R.style.AppTheme19, R.color.ba_top_19, R.drawable.theme_ba19,
                            R.color.ba_bottom_19, map);
                    break;
                case "20":
                    if (Uiutils.isSite("c199")) {
                        putIntSp(R.style.AppTheme20_c199, R.color.ba_top_15, R.drawable.theme_ba15,
                                R.color.ba_bottom_15, map);
                    } else {
                        putIntSp(R.style.AppTheme20, R.color.ba_top_20, R.drawable.theme_ba20,
                                R.color.ba_bottom_20, map);
                    }
                    break;
                case "21":
                    putIntSp(R.style.AppTheme21, R.color.ba_top_21, R.drawable.theme_ba21,
                            R.color.ba_bottom_21, map);
                    break;
                case "22":
                    putIntSp(R.style.AppTheme, R.color.colorAccent, R.drawable.theme_ba22,
                            R.color.my_line, map);
                    break;
                case "23":
                    putIntSp(R.style.AppTheme23, R.color.ba_top_23, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "24":
                    putIntSp(R.style.AppTheme24, R.color.ba_top_24, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "25":
                    putIntSp(R.style.AppTheme25, R.color.ba_top_25, R.color.color_white,
                            R.color.my_line, map);
                    break;
                case "26":
                    putIntSp(R.style.AppTheme26, R.color.ba_top_26, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "27":
                    putIntSp(R.style.AppTheme27, R.color.ba_top_27, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "28":
                    putIntSp(R.style.AppTheme28, R.color.ba_top_28, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "29":
                    putIntSp(R.style.AppTheme29, R.color.ba_top_29, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "30":
                    putIntSp(R.style.AppTheme30, R.color.ba_top_30, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "31":
                    putIntSp(R.style.AppTheme31, R.color.ba_top_31, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "32":
                    putIntSp(R.style.AppTheme32, R.color.ba_top_32, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "33":
                    putIntSp(R.style.AppTheme33, R.color.ba_top_33, R.color.color_white,
                            R.color.color_white, map);
                    break;
                case "34":
                    putIntSp(R.style.AppTheme34, R.color.ba_top_34, R.drawable.theme_ba34,
                            R.color.ba_bottom_34, map);
                    break;

                case "35":   //简约模板蓝
                    putIntSp(R.style.AppTheme35, R.color.ba_top_35,R.color.color_white,
                            R.color.color_white, map);
                    break;

                case "36":   //简约模板红
                    putIntSp(R.style.AppTheme36, R.color.ba_top_36, R.color.color_white,
                            R.color.color_white, map);
                    break;

                default:
                    putIntSp(R.style.AppTheme1, R.color.ba_top_21, R.drawable.theme_ba1,
                            R.color.ba_bottom_1, map);
                    break;

            }

        }
    }

    /**
     * 配置对应的主题
     * @param theme 主题
     * @param top   顶部颜色
     * @param center    中部颜色
     * @param bottom    底部颜色
     * @param map
     */
    private void putIntSp(int theme, int top, int center, int bottom, Map<String, Object> map) {
        ShareUtils.putInt(this, "sTheme", theme);
        ShareUtils.putInt(this, "ba_top", top);
        ShareUtils.putInt(this, "ba_center", center);
        ShareUtils.putInt(this, "ba_tbottom", bottom);

        this.setTheme(theme);

        initImmersionBar();
//        titlebar.setBackgroundColor(getResources().getColor(ShareUtils.getInt(this, "ba_top", 0)));
        radioGroup.setBackgroundColor(getResources().getColor(ShareUtils.getInt(this, "ba_tbottom", 0)));
        mDrawerLayout.setBackground(getResources().getDrawable(ShareUtils.getInt(this, "ba_center", 0)));
        int i = getResources().getColor(ShareUtils.getInt(this, "ba_top", 0));



        if (map.containsKey("themetyp")) {
            if (!StringUtils.equals((String) map.get("themetyp"),
                    ShareUtils.getString(this, "themetyp", ""))) {
                ShareUtils.putString(this, "themetyp", (String) map.get("themetyp"));

            }
        }

        setnavigation();


        EvenBusUtils.setEvenBus(new Even(EvenBusCode.CHANGE_THEME_STYLE_MYF));
//        if (null!=homefragment)
//            homefragment.setTheme();
    }

    private void setnavigation() {

        if (config != null && config.getData() != null && config.getData().getMobileMenu() != null && config.getData().getMobileMenu().size() > 0) {
            if (config.getData().getM_promote_pos().equals("1")) {

                for (int i = 0; i < config.getData().getMobileMenu().size(); i++) {
                    String act = config.getData().getMobileMenu().get(i).getPath();

                    if (act.equals("/activity")) {
                        config.getData().getMobileMenu().remove(i);
                    }
                }
            }
            mobileMenu = config.getData().getMobileMenu();
            Log.e("mobileMenu0==", mobileMenu.toString());
            setNavigation(mobileMenu);
            postion = -1;
        } else {
            Log.e("setnavigation,==", "///1");
            if (mobileMenu.size() > 0)
                mobileMenu.clear();
//
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("首页", "/home"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("购彩大厅", "/lotteryList"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("聊天室", "/chatRoomList"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("优惠活动", "/activity"));
            mobileMenu.add(new ConfigBean.DataBean.MobileMenuBean("我的", "/user"));

            setNavigation(mobileMenu);
        }
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
                                int apkVer = APKVersionCodeUtils.getVersionCode(MainActivity.this);
                                if (uv.getData() != null && !TextUtils.isEmpty(uv.getData().getVersionCode())) {
                                    String verCode = uv.getData().getVersionCode().replaceAll("\\.", "");
                                    if (!StringUtils.isEmpty(verCode) && ShowItem.checkStrIsNum(verCode)) {
                                        Double ver = Double.parseDouble(verCode);
                                        if (ver > apkVer) {
                                            EventBus.getDefault().postSticky(new Even(50000, response.body() + ""));   //版本更新
                                        } else {
                                            if (isShow)
                                                ToastUtils.ToastUtils("当前版本已是最新版本", MainActivity.this);
                                        }
                                    }
                                } else if (uv.getData() != null && uv.getData().getVersionCode() != null && uv.getData().getVersionCode().equals("")) {
                                    if (isShow)
                                        ToastUtils.ToastUtils("当前版本已是最新版本", MainActivity.this);
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

    public void getVersion() {
        getUpdataVersion(true);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1005) {  //资金管理
            try {
//                assert data != null;
                if (data != null && data.getStringExtra("payState") != null) {
                    String payState = data.getStringExtra("payState");
                    if (!TextUtils.isEmpty(payState) && payState.equals("1"))
//                        mActivity.setTab(2);
                        if (depositFrament != null) {
                            depositFrament.setTab(2);
                        }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (requestCode == 1001) {
            try {
                if (ticketAndChatFrament != null) {
                    ticketAndChatFrament.onActivityResult(requestCode, resultCode, data);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (requestCode == 1003) {
            try {
                if (interestDoteyFrament != null) {
                    interestDoteyFrament.onActivityResult(requestCode, resultCode, data);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            ticketAndChatFrament.onActivityResult(requestCode, resultCode, data);
        }
//        if (channelfragment != null) {
//            channelfragment.onActivityResult(requestCode, resultCode, data);
//        }
    }

    private ConfigBean config;

    //配置文件
    public void getConfig(boolean isShowDialogs, boolean isTheme) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.CONFIG)).tag(this).execute(new NetDialogCallBack(this, isShowDialogs, this,
                true, ConfigBean.class) {

            @Override
            public void onUi(Object o) throws IOException {
                config = (ConfigBean) o;
                if (config != null && config.getCode() == 0 && config.getData() != null) {

//                    if (!StringUtils.isEmpty(config.getData().getIsPopup())
//                    &&StringUtils.equals("1",config.getData().getIsPopup())){
//                        handler.removeMessages(1);
//                        handler.sendEmptyMessage(1);
//                    }

                    ShareUtils.saveObject(MainActivity.this, SPConstants.CONFIGBEAN, config);
                    SharedPreferences.Editor edit = sp.edit();
                    edit.putString(SPConstants.SP_ZXKFURL, config.getData().getZxkfUrl() == null ? "" : config.getData().getZxkfUrl());
                    edit.putString(SPConstants.SP_MOBILE_LOGO, config.getData().getMobile_logo() == null ? "" : config.getData().getMobile_logo());   //首页左边logo
//                    edit.putString(SPConstants.SP_MINWITHDRAWMONEY, config.getData().getMinWithdrawMoney() == null ? "" : config.getData().getMinWithdrawMoney());//下注单笔限额最小
//                    edit.putString(SPConstants.SP_MAXWITHDRAWMONEY, config.getData().getMaxWithdrawMoney() == null ? "" : config.getData().getMaxWithdrawMoney());//下注单笔限额最大
                    edit.putString(SPConstants.SP_YUEBAONAME, config.getData().getYuebaoName() == null ? "" : config.getData().getYuebaoName());//利息宝
//                    edit.putString(SPConstants.SP_APIHOSTS, config.getData().getApiHosts() == null ? "" : String.valueOf(config.getData().getApiHosts()));//域名
                    edit.commit();

                    SPConstants.setListValue(config.getData().getApiHosts());

                    categoryNum = config.getData().getMobileTemplateCategory();
                    EventBus.getDefault().postSticky(new MessageEvent("config"));
                    String id = "22";//哪个模板
                    String category = config.getData().getMobileTemplateCategory();
                    switch (category) {
                        case "0":  //经典
                            id = config.getData().getMobileTemplateBackground();
                            break;
                        case "2":  //新年红
                            if (!StringUtils.isEmpty(config.getData().getMobileTemplateStyle()) &&
                                    StringUtils.equals("1", config.getData().getMobileTemplateStyle())) {
                                id = "34";
                            } else {
                                id = "20";
                            }
                            break;
                        case "3":  //石榴红
                            id = "21";
                            break;
                        case "4":  //一期走经典
                            if (!StringUtils.isEmpty(config.getData().getMobileTemplateLhcStyle())) {
                                switch (config.getData().getMobileTemplateLhcStyle()) {
                                    case "0":
                                        id = "23";
                                        break;
                                    case "1":
                                        id = "24";
                                        break;
                                    case "2":
                                        id = "25";
                                        break;
                                    case "3":
                                        id = "26";
                                        break;
                                    case "4":
                                        id = "27";
                                        break;
                                    case "5":
                                        id = "28";
                                        break;
                                    case "6":
                                        id = "29";
                                        break;
                                    case "7":
                                        id = "30";
                                        break;
                                    case "8":
                                        id = "31";
                                        break;
                                    case "9":
                                        id = "32";
                                        break;
                                    case "10":
                                        id = "33";
                                        break;
                                }
                            }
                            break;
                        case "9":  //简约模板
                            switch (config.getData().getMobileTemplateLhcStyle()) {
                                case "1":  //蓝
                                    id = "35";
                                    break;
                                case "2":   //红
                                    id = "36";
                                    break;
                                default:
                                    id = "35";
                                    break;
                            }
                            break;
                    }
//                    if (!StringUtils.equals(config.getData().getMobileTemplateCategory(),
//                            ShareUtils.getString(getContext(),"themetyp",""))){
//                        ShareUtils.putString(getContext(),"themetyp",config.getData().getMobileTemplateCategory());
//                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.CHANGE_THEME_STYLE,
//                                config.getData().getMobileTemplateCategory()));
//                    }

                    if (!StringUtils.equals(id, ShareUtils.getString(MainActivity.this, "themid", ""))) {
                        ShareUtils.putString(MainActivity.this, "themid", id);
                        Map<String, Object> map = new HashMap<>();
                        map.put("themid", id);
//                        if (!StringUtils.isEmpty(config.getData().getMobileTemplateCategory())&&
//                                StringUtils.equals("4",config.getData().getMobileTemplateCategory())) {
//                            map.put("themetyp", "0");
//                        }else{
                        map.put("themetyp", config.getData().getMobileTemplateCategory());
//                        }
                        setTheme(map);
                        EvenBusUtils.setEvenBus(new Even(EvenBusCode.CHANGE_THEME_STYLE, map));
                    } else {
                        setnavigation();
                    }

                }

                initImmersionBar();
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
                setnavigation();
            }

            @Override
            public void onFailed(Response<String> response) {
                setnavigation();
            }
        });
    }

    //    资金管理
    public void setTab(int i) {
        if (depositFrament != null) {
            depositFrament.setTab(i);
        }
    }

    public void openSliding() {
        mDrawerLayout.openDrawer(Gravity.RIGHT);
    }

    //安全中心下载验证器
    public void setDown(String url) {
        updata = new UpdataUtil(this, url + "", 1);
    }

    @SuppressLint("MissingSuperCall")
    @Override
    public void onSaveInstanceState(Bundle outState) {
//        super.onSaveInstanceState(outState);
    }

    private void setBadge() {

        String token = SPConstants.getToken(MainActivity.this);
        if (TextUtils.isEmpty(token) || token.equals("Null")) {
            return;
        }
        if (mobileMenu != null) {
            if (mGroup == null || badgeText == null) {
                return;
            }
            for (int c = 0; c < badgeText.size(); c++) {
                if (mGroup.get(c).getText().toString().equals("我的")) {
                    badge.bindTarget(badgeText.get(c));
                }
            }
            userInfo = (UserInfo) ShareUtils.getObject(MainActivity.this, SPConstants.USERINFO, UserInfo.class);
            if (userInfo != null && userInfo.getData() != null) {
                badge.setBadgeNumber(userInfo.getData().getUnreadMsg());
            }
        } else {
            if (tv5 != null) {
                userInfo = (UserInfo) ShareUtils.getObject(MainActivity.this, SPConstants.USERINFO, UserInfo.class);
                if (userInfo != null && userInfo.getData() != null) {
                    badge.bindTarget(tv5);
                    badge.setBadgeNumber(userInfo.getData().getUnreadMsg());
                }
            }
        }
        if (StringUtils.equals("2", ShareUtils.getString(this, "themetyp", ""))) {
            badge.setBadgeBackgroundColor(getResources().getColor(R.color.color_4583fc));
        } else {
            badge.setBadgeBackgroundColor(getResources().getColor(R.color.color_FF2600));
        }
    }

    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        postion = -1;
    }

    @Override
    public void onClick(View v) {

    }
}
