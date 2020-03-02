package com.phoenix.lotterys.util;

import android.app.Activity;
import android.graphics.drawable.Drawable;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.view.tddialog.TDialog;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/10/3
 */
public class DrawableUtils {
    public static String SHOUYI = "/referrer";   //推广收益
    public static String SIGN = "/Sign";    //签到
    public static String YUEBAO = "/yuebao";   //利息宝
    public static String BANKS = "/banks";   //银行卡
    public static String MESSAGE = "/message";   //站内信
    public static String FUNDS = "/funds";   //资金管理
    public static String SECURITYCENTER = "/securityCenter";   //安全中心
    public static String TASK = "/task";   //任务中心
    public static String USER = "/user";   //我的
    public static String LOTTERYRECORD = "/lotteryRecord";   //开奖记录
    public static String CHATROOMLIST = "/chatRoomList";   //聊天室
    public static String ACTIVITY = "/activity";   //优惠活动
    public static String LOTTERYLIST = "/lotteryList";   //彩票大厅
    public static String CHANGLONG = "/changLong";   //长龙助手
    public static String ZRSX = "/zrsx";   //真人视讯
    public static String QPDZ = "/qpdz";   //真人视讯
    public static String HOME = "/home";   //首页

    private Activity activity;
    List<ConfigBean.DataBean.MobileMenuBean> mobileMenu;

    public DrawableUtils(Activity activity, List<ConfigBean.DataBean.MobileMenuBean> mobileMenu) {
        this.activity = activity;
        this.mobileMenu = mobileMenu;
    }

    public Drawable drawable(String colour, int pos) {
        Drawable drawable = null;
        if (mobileMenu == null && mobileMenu.size() <= pos) {
            return null;
        }
        String path = mobileMenu.get(pos).getPath();
        switch (path) {
            case "/home":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_first0);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_first1);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_first);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_first2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.black_home);
                        break;
                }
                break;

            case "/changLong":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigationbet);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigationbet_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigationbet_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigationbet_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_bet);
                        break;
                }
                break;
            case "/lotteryList":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_second0);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_second1);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_second);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_second2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_lottery);
                        break;
                }
                break;
            case "/activity":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fourth0);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fourth1);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fourth);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fourth2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_activity);
                        break;
                }
                break;
            case "/chatRoomList":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_third0);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_third1);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_third);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_third2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_chat);
                        break;
                }
                break;
            case "/lotteryRecord":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_drawyw);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_drawyw_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_drawyw_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_drawyw_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_draw);
                        break;
                }
                break;
            case "/user":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fifth0);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fifth1);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fifth);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.selector_menubar_fifth2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_user);
                        break;
                }
                break;
            case "/task":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_task);
                        break;
                }
                break;
            case "/securityCenter":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_safety);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_safety_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_safety_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_safety_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_safety);
                        break;
                }
                break;
            case "/funds":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_capital);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_capitalyw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_capitalhl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_capitalhl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.money);
                        break;
                }
                break;
            case "/message":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_info);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_info_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_info_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_info_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_info);
                        break;
                }
                break;
            case "/banks":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_bank);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_bank_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_bank_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_bank_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_bank);
                        break;
                }
                break;
            case "/yuebao":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_interest);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_interest_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_interest_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_interest_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_interest);
                        break;
                }
                break;
            case "/Sign":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_task_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_task);
                        break;
                }
                break;
            case "/referrer":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_earnings);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_earnings_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_earnings_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_earnings_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_earnings);
                        break;
                }
                break;
            case "/conversion":
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_transform);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_transform_yw);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_transform_hl);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.navigation_transform_hl2);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.all_black_transform);
                        break;
                }
                break;


            case "/qpdz":  //棋牌电子
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.chess_electronic_black);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.chess_electronic_yellow);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.chess_electronic_blue);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.chess_electronic_red);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.chess_electronic4);
                        break;
                }
                break;

            case "/zrsx":  //真人视讯
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.real_video_black);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.real_video_yellow);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.real_video_blue);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.real_video_red);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.real_video3);
                        break;
                }
                break;
            case "/gameHall":  //
                switch (colour) {
                    case "black":
                        drawable = activity.getResources().getDrawable(R.drawable.lottery_ticket_hall_black);
                        break;
                    case "yellow":
                        drawable = activity.getResources().getDrawable(R.drawable.lottery_ticket_hall_yellow);
                        break;
                    case "blue":
                        drawable = activity.getResources().getDrawable(R.drawable.lottery_ticket_hall_blue);
                        break;
                    case "red":
                        drawable = activity.getResources().getDrawable(R.drawable.lottery_ticket_hall_red);
                        break;
                    case "allblack":   //黑色模板
                        drawable = activity.getResources().getDrawable(R.drawable.lottery_ticket_hall1);
                        break;
                }
//                drawable = activity.getResources().getDrawable(R.drawable.lottery_ticket_hall_red);
                break;

        }

        return drawable;
    }

    public static boolean menuType(Activity activity, String type, ConfigBean config) {
        switch (type) {
//            case "/home":
//
//                break;
//            case "/changLong":
//
//                break;
//            case "/lotteryList":
//
//                break;
//            case "/activity":
//
//                break;
            case "/chatRoomList":
                if (config != null && config.getData() != null && !config.getData().isChatRoomSwitch()) {   //false为关闭  true为开
                    hintDialog(activity, "聊天室未开启");
                    return false;
                }
                break;
//            case "/lotteryRecord":
//
//                break;

            case "/task":
                if (config != null && config.getData() != null && config.getData().getMissionSwitch().equals("1")) {   //1为关闭
                    hintDialog(activity, "任务中心未开启");
                    return false;
                }
                if (Uiutils.isTourist(activity))
                    return false;
                break;
            case "/securityCenter":
                if (Uiutils.isTourist(activity))
                    return false;
                break;
            case "/funds":
                if (Uiutils.isTourist(activity))
                    return false;
                break;
//            case "/message":
//
//                break;
            case "/banks":
                if (Uiutils.isTourist(activity))
                    return false;
                break;
            case "/yuebao":
                UserInfo userInfo = (UserInfo) ShareUtils.getObject(activity, SPConstants.USERINFO, UserInfo.class);
                if (userInfo != null && userInfo.getData() != null && !userInfo.getData().isYuebaoSwitch()) {
                    String name = null;
                    if (config != null && config.getData() != null && config.getData().getYuebaoName() != null)
                        name = config.getData().getYuebaoName();
                    else
                        name = "利息宝";
                    hintDialog(activity, name+"未开启");
                    return false;
                }

                if (Uiutils.isTourist(activity))
                    return false;
                break;
            case "/Sign":
                if (config != null && config.getData() != null && config.getData().getCheckinSwitch().equals("0")) {   //0为关闭
                    hintDialog(activity, "签到未开启");
                    return false;
                }

                if (Uiutils.isTourist(activity))
                    return false;
                break;
//            case "/referrer":
//                if (!Uiutils.isTourist1(activity)) {
//                    if (null != config && null != config.getData() && !StringUtils.isEmpty(config.getData().getAgent_m_apply()) && StringUtils.equals("1", config.getData().getAgent_m_apply())) {
//                        return true;
//                    } else {
//                        ToastUtil.toastShortShow(activity, "在线注册代理已关闭");
//                        return false;
//                    }
//                }
////                break;
            case "/conversion":
                if (Uiutils.isTourist(activity))
                    return false;

                break;
        }
        return true;
    }

    public static void hintDialog(Activity activity, String cont) {
        String title = "提示信息";
        String content = cont ;
        String[] array = new String[]{activity.getResources().getString(R.string.affirm)};
        TDialog mTDialog = new TDialog(activity, TDialog.Style.Center, array, title, content, "", new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int position) {

            }
        });
        mTDialog.setCancelable(false);
        mTDialog.show();

    }

}
