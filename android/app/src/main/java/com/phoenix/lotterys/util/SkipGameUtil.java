package com.phoenix.lotterys.util;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.buyhall.activity.BuyHallTypeActivity;
import com.phoenix.lotterys.buyhall.activity.TicketDetailsActivity;
import com.phoenix.lotterys.buyhall.bean.TicketDetails;
import com.phoenix.lotterys.chat.fragment.ChatFragment;
import com.phoenix.lotterys.coupons.CouponsFragment;
import com.phoenix.lotterys.coupons.activity.WebActivity;
import com.phoenix.lotterys.helper.OpenHelper;
import com.phoenix.lotterys.home.activity.ElectronicActivity;
import com.phoenix.lotterys.home.activity.InformationActivity;
import com.phoenix.lotterys.home.bean.GameUrlBean;
import com.phoenix.lotterys.home.fragment.TicketAndChatFrament;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.main.bean.UpdataVersionBean;
import com.phoenix.lotterys.main.webview.AgentWebActivity;
import com.phoenix.lotterys.main.webview.GoWebActivity;
import com.phoenix.lotterys.main.webview.GoWebActivity1;
import com.phoenix.lotterys.my.activity.DepositActivity;
import com.phoenix.lotterys.my.activity.InterestDoteyActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.ActivityFiledFrag;
import com.phoenix.lotterys.my.fragment.AgencyProposerFrag;
import com.phoenix.lotterys.my.fragment.DragonAssistantFrag;
import com.phoenix.lotterys.my.fragment.FeedbackFrag;
import com.phoenix.lotterys.my.fragment.MailFrag;
import com.phoenix.lotterys.my.fragment.MissionCenterFrag;
import com.phoenix.lotterys.my.fragment.NoteRecordFrag;
import com.phoenix.lotterys.my.fragment.RecommendBenefitFrag;
import com.phoenix.lotterys.my.fragment.SignInFrag;
import com.phoenix.lotterys.view.ChatDialog;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import org.greenrobot.eventbus.EventBus;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

/**
 * Greated by Luke
 * on 2019/9/11
 */
public class SkipGameUtil {
    private static String UrlModel = "id=%s&token=%s";

    public static void goGame(int position, Context context, String id) {
        String token = SPConstants.getValue(context, SPConstants.SP_API_SID);
        if (token.equals("Null")) {
//            context.startActivity(new Intent(context, LoginActivity.class));
            Uiutils.login(context);
            return;
        }

        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.GOTOGAMEREAL + String.format(UrlModel, SecretUtils.DESede(id), SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken()))//
//                .tag(this)//
                .execute(new NetDialogCallBack(context, true, context,
                        true, GameUrlBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameUrlBean url = (GameUrlBean) o;
                        if (url != null && url.getCode() == 0 && url.getData() != null) {
                            String gameUrl = "";
                            if (Constants.ENCRYPT) {
                                gameUrl = (Constants.BaseUrl() + Constants.GOTOGAME + String.format(UrlModel, SecretUtils.DESede(id),
                                        SecretUtils.DESede(token)) + "&sign=" + SecretUtils.RsaToken());
                            } else {
                                gameUrl = url.getData();
                            }
                            gameUrl = gameUrl.replaceAll("\n", "");



                            Intent intent = null;
                            if (id.equals("58")) {  //
                                intent = new Intent(context, GoWebActivity.class);
                            } else {
                                intent = new Intent(context, AgentWebActivity.class);
                            }
                            intent.putExtra("url", gameUrl);
                            intent.putExtra("show", "");
                            context.startActivity(intent);
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


    public static void SkipGame(int position, Context context, HomeGame.DataBean.IconsBean game) {
        HomeGame.DataBean.IconsBean.ListBean gameListBean = game.getList().get(position);
//        if (gameListBean.getSeriesId() != null && gameListBean.getSeriesId().equals("7")) {
        if ("7".equals(gameListBean.getSeriesId())) {
            SkipNavig("7", gameListBean.getSubId(), gameListBean.getUrl(), context, "", "", "");
        }
        if (ButtonUtils.isFastDoubleClick())
            return;
        //是否登录
        if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
            return;
        }
//        if (!TextUtils.isEmpty(gameListBean.getSubId())
//                && (gameListBean.getSubId().equals("10000")
//                || gameListBean.getSubId().equals("0")
//                || gameListBean.getSubId().equals("20000")
//                || gameListBean.getSubId().equals("1000"))) {
        if ("10000".equals(gameListBean.getSubId())
                || "0".equals(gameListBean.getSubId())
                || "20000".equals(gameListBean.getSubId())
                || "1000".equals(gameListBean.getSubId())) {
            if (!TextUtils.isEmpty(gameListBean.getUrl())) {
                loadUrl(gameListBean.getUrl(), context);
                return;
            }
        }

        //六合彩资料
//        if (gameListBean.getDocType() != null && gameListBean.getDocType().equals("1")) {
        if ("1".equals(gameListBean.getDocType())) {
            skipSixInfo(context, position, game);
            return;
        }
//        if (game.getList().get(position).getSeriesId()!=null&&game.getList().get(position).getSeriesId().equals("7")) {
//            SkipNavig("7",game.getList().get(position).getSubId(),game.getList().get(position).getUrl(),context, "", "", "");
//            return;
//        }
//        if (gameListBean.getSeriesId().equals("1")) {
        if ("1".equals(gameListBean.getSeriesId())) {
//            if (!TextUtils.isEmpty(game.getList().get(position).getDocType())) {
            Intent intent = null;
            TicketDetails td = new TicketDetails();
            intent = new Intent(context, TicketDetailsActivity.class);
            td.setGameId(gameListBean.getGameId());
            td.setTitle(gameListBean.getTitle());
            ShareUtils.putString(context, "isInstant", gameListBean.getIsInstant());
            td.setGameType(gameListBean.getGameType());
            td.setIsInstant(gameListBean.getIsInstant());
            Gson gson = new Gson();
            String ticketDetails = gson.toJson(td);
            intent.putExtra("ticketDetails", ticketDetails);
            OpenHelper.startActivity(context, intent);
        }else if("9".equals(gameListBean.getSeriesId())){
            skipNewChat(context, gameListBean.getSubId(), gameListBean.getName());
//            skipChat(context,game.getList().get(position).getSubId());
        } else if ("0".equals(gameListBean.getIsPopup())) {
            if ("1".equals(gameListBean.getSupportTrial())) {
                if (StringUtils.isEmpty(gameListBean.getGameCode())
                        || "-1".equals(gameListBean.getGameCode())) {
                    goGame(position, context, gameListBean.getGameId());
                } else {
                    ElectronicActivity.goGame(context, gameListBean.getGameId(), gameListBean.getGameCode());
                }
            } else if ("0".equals(gameListBean.getSupportTrial())) {
                if (Uiutils.isTourist(context)) {
                    return;
                } else {
                    if (StringUtils.isEmpty(gameListBean.getGameCode())
                            || "-1".equals(gameListBean.getGameCode())) {
                        goGame(position, context, gameListBean.getGameId());
                    } else {
                        ElectronicActivity.goGame(context, gameListBean.getGameId(), gameListBean.getGameCode());
                    }
                }
            }

        } else if ("1".equals(gameListBean.getIsPopup())) {
            if (StringUtils.isEmpty(gameListBean.getGameCode())
                || "-1".equals(gameListBean.getGameCode())) {
                Intent intent = new Intent();
                intent.putExtra("id", gameListBean.getGameId());
//            intent.putExtra("name", game.getList().get(position).getCategory());
                intent.putExtra("title", gameListBean.getTitle());
                intent.putExtra("supportTrial", gameListBean.getSupportTrial() + "");
//                        intent.putExtra("isInstant", game.getGames().get(position).i);
                intent.setClass(context, ElectronicActivity.class);
                context.startActivity(intent);
            } else {
                ElectronicActivity.goGame(context, gameListBean.getGameId(), gameListBean.getGameCode());
            }
        }
    }

    private static void skipSixInfo(Context context, int position, HomeGame.DataBean.IconsBean game) {
        TicketDetails td = new TicketDetails();
        Intent intent = new Intent(context, InformationActivity.class);
        td.setGameId(game.getList().get(position).getType());
        td.setTitle(game.getList().get(position).getName());
        td.setId(game.getList().get(position).getId());
        List<TicketDetails.BbsBean> bbsList = new ArrayList<>();
        for (HomeGame.DataBean.IconsBean.ListBean list : game.getList()) {
            if (list.getDocType() != null && list.getDocType().equals("1")) {
                bbsList.add(new TicketDetails.BbsBean(list.getId(), list.getName(), list.getType(), list.getGameType()));
            }
        }
        td.setBbsBean(bbsList);
        td.setGameType(game.getList().get(position).getGameType());
        td.setIsInstant(game.getList().get(position).getIsInstant());
        Gson gson = new Gson();
        String ticketDetails = gson.toJson(td);
        intent.putExtra("ticketDetails", ticketDetails);
        OpenHelper.startActivity(context, intent);

    }


    public static void loadUrl(String url, Context context) {
        Intent intent = new Intent(context, GoWebActivity.class);
        intent.putExtra("url", url.startsWith("http") ? url : "http://" + url);
        context.startActivity(intent);
    }

    public static void loadExternalUrl(String url, Context context) {
        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        Uri content_url = Uri.parse(url.startsWith("http") ? url : "http://" + url);
        intent.setData(content_url);
        context.startActivity(intent);
    }

    public static void twoSkipGame(int position, Context context, List<HomeGame.DataBean.IconsBean.ListBean.SubTypeBean> game) {

        try {
            if (game.get(position).getSeriesId() != null && game.get(position).getSeriesId().equals("7")) {
                SkipNavig("7", game.get(position).getSubId(), game.get(position).getUrl(), context, "", "", "");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (ButtonUtils.isFastDoubleClick())
            return;
        if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
            return;
        }
        if ((!TextUtils.isEmpty(game.get(position).getSeriesId())) && game.get(position).getSeriesId().equals("1")) {
            Intent intent = new Intent(context, TicketDetailsActivity.class);
            TicketDetails td = new TicketDetails();
            td.setGameId(game.get(position).getGameId());
            td.setTitle(game.get(position).getTitle());
            td.setGameType(game.get(position).getGameType());
            td.setIsInstant(game.get(position).getIsInstant());
            ShareUtils.putString(context, "isInstant", game.get(position).getIsInstant());
            Gson gson = new Gson();
            String ticketDetails = gson.toJson(td);
            intent.putExtra("ticketDetails", ticketDetails);
            OpenHelper.startActivity(context, intent);
        } else if (game.get(position).getIsPopup() != null && game.get(position).getIsPopup().equals("0")) {
            if (game.get(position).getSupportTrial() != null && game.get(position).getSupportTrial().equals("1"))
                goGame(position, context, game.get(position).getGameId());
            else if (game.get(position).getSupportTrial() != null && game.get(position).getSupportTrial().equals("0"))
                if (Uiutils.isTourist(context)) {
                    return;
                } else {
                    goGame(position, context, game.get(position).getGameId());
                }
        } else if (game.get(position).getIsPopup() != null && game.get(position).getIsPopup().equals("1")) {
            Intent intent = new Intent();
            intent.putExtra("id", game.get(position).getGameId());
//            intent.putExtra("name", game.getList().get(position).getCategory());
            intent.putExtra("title", game.get(position).getTitle());
            intent.putExtra("supportTrial", game.get(position).getSupportTrial() + "");
//                        intent.putExtra("isInstant", game.getGames().get(position).i);
            intent.setClass(context, ElectronicActivity.class);
            context.startActivity(intent);
        }
    }


    private static void questVersion(Context context) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.ANDROIDVERSION + SecretUtils.DESede("android") + "&sign=" + SecretUtils.RsaToken())).tag(context).execute(new StringCallback() {
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
                                int apkVer = APKVersionCodeUtils.getVersionCode(context);
                                if (uv.getData() != null && !TextUtils.isEmpty(uv.getData().getVersionCode())) {
                                    String verCode = uv.getData().getVersionCode().replaceAll("\\.", "");
                                    if (ShowItem.checkStrIsNum(verCode)) {
                                        Double ver = Double.parseDouble(verCode);
                                        if (ver > apkVer) {
                                            EventBus.getDefault().postSticky(new Even(50000, response.body() + ""));   //版本更新
                                        } else {
                                            ToastUtil.toastShortShow(context, "当前版本已经是最新版本");
                                        }
                                    }
                                } else if (uv.getData() != null && uv.getData().getVersionCode() != null && uv.getData().getVersionCode().equals("")) {

                                    ToastUtil.toastShortShow(context, "当前版本已是最新版本");
                                }
                            }
                        } catch (JsonSyntaxException e) {
                            e.printStackTrace();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        });
    }

    public static void loadInnerWebviewUrl(String url, Context context, String isHideTitle, String title) {
        Intent intent = new Intent(context, GoWebActivity.class);
        intent.putExtra("url", url.startsWith("http") ? url : "http://" + url);
        intent.putExtra("type", isHideTitle);
        intent.putExtra("title", title);
        context.startActivity(intent);
    }
    public static void loadInnerWebviewUrl1(String url, Context context, String isHideTitle, String title) {
        Intent intent = new Intent(context, GoWebActivity1.class);
        intent.putExtra("url", url.startsWith("http") ? url : "http://" + url);
        intent.putExtra("type", isHideTitle);
        intent.putExtra("title", title);
        context.startActivity(intent);
    }

    public static void loadInnerWebviewUrl(Context context,String url, String isHideTitle, String title) {
        Intent intent = null;
        if(BuildConfig.FLAVOR.equals("c085")){    //c085直接跳转到游戏浏览器
           intent = new Intent(context, AgentWebActivity.class);
        }else {
            intent = new Intent(context, GoWebActivity.class);
        }
        intent.putExtra("url", url.startsWith("http") ? url : "http://" + url);
        intent.putExtra("type", isHideTitle);
        context.startActivity(intent);
    }

    //导航
    public static void SkipNavig1(int position, Context context, List<HomeGame.DataBean.NavsBean> game) {
        if (ButtonUtils.isFastDoubleClick())
            return;
//        if (game.getAlias().equals("navigation")) {
        Bundle build;
        Intent intent;
        if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("1")) {  //存取款
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;
            build = new Bundle();
            build.putSerializable("page", "0");
            IntentUtils.getInstence().intent(context, DepositActivity.class, build);
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("2")) {   //app下载
            questVersion(context);
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("3")) {  //聊天室
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
//      if (Uiutils.isTourist(context))
//          return;
//            String sid = SPConstants.getValue(context, SPConstants.SP_API_SID);
//            String apiToken = SPConstants.getValue(context, SPConstants.SP_API_TOKEN);
//            intent = new Intent(context, WebActivity.class);
//            intent.putExtra("url", Constants.BaseUrl() + Constants.CHAT + "logintoken=" + apiToken + "&sessiontoken=" + sid);
//            intent.putExtra("type", "chat");
//            context.startActivity(intent);
                skipNewChat(context,game.get(position).getSubId(),game.get(position).getName());

        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("4")) {  //在线客服
//            String url = SPConstants.getValue(context, SPConstants.SP_ZXKFURL);
            ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
            if (configBean != null && configBean.getData() != null && configBean.getData().getZxkfUrl() != null) {
                if (TextUtils.isEmpty(configBean.getData().getZxkfUrl())) {
                    ToastUtils.ToastUtils("客服地址未配置或获取失败", context);
                    return;
                }
                loadInnerWebviewUrl(configBean.getData().getZxkfUrl(), context, "isHideTitle", "");
            }

        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("5")) {  //长龙助手
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
//                if (Uiutils.isTourist(context))
//                    return;
            FragmentUtilAct.startAct(context, new DragonAssistantFrag(false));
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("6")) {   //推荐受益
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }

            if (Uiutils.isTourist1(context)) {
                FragmentUtilAct.startAct(context, new RecommendBenefitFrag(false));
                return;
            }
            UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);
            ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
            if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
                FragmentUtilAct.startAct(context, new RecommendBenefitFrag(false));
            } else {
                if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                        .getAgent_m_apply()) && StringUtils.equals("1", configBean.getData()
                        .getAgent_m_apply())) {
                    FragmentUtilAct.startAct(context, new AgencyProposerFrag(false));
                } else {
                    ToastUtil.toastShortShow(context, "在线注册代理已关闭");
                }
            }

        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("7")) { //开奖网
            String url = Constants.BaseUrl() + Constants.OPEN_PRIZE;
            if (TextUtils.isEmpty(url))
                return;
            loadInnerWebviewUrl(url, context, "isHideTitle", "");
//                intent = new Intent(context, GoWebActivity.class);
//                intent.putExtra("url", url);
//                intent.putExtra("type", "isShowTitle");
//                context.startActivity(intent);
//                loadUrl(url, context);
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("8")) {   //利息宝
            UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);
            if (userInfo != null && userInfo.getData() != null && !userInfo.getData().isYuebaoSwitch()) {
                String name = null;
                ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
                if (configBean != null && configBean.getData() != null && configBean.getData().getYuebaoName() != null)
                    name = configBean.getData().getYuebaoName();
                else
                    name = "利息宝";
                ToastUtil.toastShortShow(context, name + "未开启");
                return;
            }
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;
            context.startActivity(new Intent(context, InterestDoteyActivity.class));
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("9")) {   //优惠活动
            FragmentUtilAct.startAct(context, new CouponsFragment(false, false));
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("10")) {   //游戏记录
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;
            Bundle bundle = new Bundle();
            bundle.putInt("type", 1);
            FragmentUtilAct.startAct(context, new NoteRecordFrag(), bundle);
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("11")) {   //QQ
//            if(game.get(position).getName()!=null){
//                if(ShowItem.isNum(game.get(position).getName())){
//                    if (QQClientAvailable.isQQClientAvailable(context)) {
//                        // 跳转到客服的QQ
//                        String url = "mqqwpa://im/chat?chat_type=wpa&uin=" + game.get(position).getName();
//                        Intent intent1 = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
//                        // 跳转前先判断Uri是否存在，如果打开一个不存在的Uri，App可能会崩溃
//                        if (QQClientAvailable.isValidIntent(context, intent1)) {
//                            context.startActivity(intent1);
//                        }
//                    } else {
//                        ToastUtil.toastShortShow(context, "请安装QQ后再试");
//                    }
//                }else {
//                    ToastUtil.toastShortShow(context, "QQ号码格式不对");
//                }
//            }
            ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
            String num = configBean.getData().getAppPopupQqNum() == null ? "" : configBean.getData().getAppPopupQqNum();
            String qq = !TextUtils.isEmpty(configBean.getData().getServiceQQ1()) ?configBean.getData().getServiceQQ1():!TextUtils.isEmpty(configBean.getData().getServiceQQ2())?configBean.getData().getServiceQQ2():"";
            if (configBean != null && configBean.getData() != null && !TextUtils.isEmpty(configBean.getData().getAppPopupQqImg())) {
                chatDialog(context, "QQ客服(" + num + ")", configBean.getData().getAppPopupQqImg());
            } else if (!TextUtils.isEmpty(qq)) {
                launchQQ(context,qq);
            } else {
                ToastUtil.toastShortShow(context, "未配置图片");
            }

        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("12")) {   //微信
            ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
            if (configBean != null && configBean.getData() != null && !TextUtils.isEmpty(configBean.getData().getAppPopupWechatImg())) {
                String num = configBean.getData().getAppPopupWechatNum() == null ? "" : configBean.getData().getAppPopupWechatNum();
                chatDialog(context, "微信客服(" + num + ")", configBean.getData().getAppPopupWechatImg());
            } else {
                ToastUtil.toastShortShow(context, "未配置图片");
            }
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("13")) {   //任务大厅
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;
            FragmentUtilAct.startAct(context, new MissionCenterFrag(false));
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("14")) {   //站内信
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;
            FragmentUtilAct.startAct(context, new MailFrag(false));
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("15")) {   //签到
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;
            FragmentUtilAct.startAct(context, new SignInFrag(false));
        } else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("16")) {   //投诉中心
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;


        }  else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("17")) {
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;

            //TODO
            ToastUtil.toastShortShow(context,"敬请期待...");
        }  else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("18")) {   //申请彩金
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;

            FragmentUtilAct.startAct(context, new ActivityFiledFrag());
        }  else if (!TextUtils.isEmpty(game.get(position).getSubId()) && game.get(position).getSubId().equals("19")) {   //购彩大厅
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (Uiutils.isTourist(context))
                return;

            BuyHallTypeActivity.Companion.start(context);
        } else if (!TextUtils.isEmpty(game.get(position).getUrl())) {
            String url = game.get(position).getUrl();
//            loadUrl(url, context);
            loadInnerWebviewUrl(context,url,"isShowTitle", game.get(position).getTitle() != null ? game.get(position).getTitle() : game.get(position).getName() != null ? game.get(position).getName() : "");
        } else {
            ToastUtil.toastShortShow(context, "未配置跳转");
        }
//        }
    }


    //带下注页面聊天
    private static void skipNewChat(Context context,String roomId,String roomName) {
        Intent intent = new Intent(context, TicketDetailsActivity.class);
        TicketDetails td = new TicketDetails();
        td.setGameId("70");
        td.setGameType("lhc");
        td.setIsChar(1);
        td.setIsInstant("0");
        td.setRoomId(roomId);
        td.setRoomName(roomName);
        ShareUtils.putString(context, "isInstant", "0");
//        td.setLotteryTime("-1");
        Gson gson = new Gson();
        String ticketDetails = gson.toJson(td);
        intent.putExtra("ticketDetails", ticketDetails);
        OpenHelper.startActivity(context, intent);
    }

    private static void skipChat(Context context,String id) {
        if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
            return;
        }
//      if (Uiutils.isTourist(context))
//          return;
        String sid = SPConstants.getValue(context, SPConstants.SP_API_SID);
        String apiToken = SPConstants.getValue(context, SPConstants.SP_API_TOKEN);
        Intent intent = new Intent(context, WebActivity.class);
        intent.putExtra("url", Constants.BaseUrl() + Constants.CHAT + "logintoken=" + apiToken + "&sessiontoken=" + sid);
        intent.putExtra("type", "chat");
        context.startActivity(intent);
//        FragmentUtilAct.startAct(context, TicketAndChatFrament.getInstance(true, false));
//        skipNewChat(context,"0","");
    }



    //启动
    private static void launchQQ(Context context, String num) {
        if (QQClientAvailable.isQQClientAvailable(context)) {
            String url = "mqqwpa://im/chat?chat_type=wpa&uin=" + num;
            Intent intent1 = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            // 跳转前先判断Uri是否存在，如果打开一个不存在的Uri，App可能会崩溃
            if (QQClientAvailable.isValidIntent(context, intent1)) {
                context.startActivity(intent1);
            }
        } else {
            ToastUtil.toastShortShow(context, "请安装QQ后再试");
        }
    }

    private static void chatDialog(Context context, String chat, String urlImg) {
        ChatDialog chatdialog = new ChatDialog(context, chat, urlImg, new ChatDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object) {

            }
        });
        chatdialog.show();
    }


    public static void SkipNavig(String linkCategory, String linkPosition, String mUrl, Context context, String lotteryGameType, String realIsPopup, String realSupportTrial) {
        if (ButtonUtils.isFastDoubleClick())
            return;
        Bundle build;
        Intent intent;
        ConfigBean configBean;
        if (linkCategory.equals("0")) {  //网址
                if (!StringUtils.isEmpty(mUrl)){
                    loadInnerWebviewUrl1(mUrl, context, "isHideTitle", "");
                }
        } else if (linkCategory.equals("1")) {  //彩票
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }

            if (StringUtils.isEmpty(linkPosition)||StringUtils.equals("0",linkPosition))
                return;

            intent = new Intent(context, TicketDetailsActivity.class);
            TicketDetails td = new TicketDetails();
            td.setGameId(linkPosition);
            td.setGameType(lotteryGameType);
            if (linkPosition.equals("11") || linkPosition.equals("7") || linkPosition.equals("9")) {
                td.setIsInstant("1");
                ShareUtils.putString(context, "isInstant", "1");
            } else {
                td.setIsInstant("0");
                ShareUtils.putString(context, "isInstant", "0");
            }
            td.setLotteryTime("-1");
            Gson gson = new Gson();
            String ticketDetails = gson.toJson(td);
            intent.putExtra("ticketDetails", ticketDetails);
            OpenHelper.startActivity(context, intent);
        } else if (linkCategory.equals("2")
                || linkCategory.equals("3")
                || linkCategory.equals("4")
                || linkCategory.equals("5")
                || linkCategory.equals("6")
                || linkCategory.equals("8")
        ) {   //真人
            if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                return;
            }
            if (realSupportTrial.equals("0") && Uiutils.isTourist(context))
                return;
            goGame(0, context, linkPosition);
        } else if (linkCategory.equals("7")) {  //导航
            switch (linkPosition) {
                case "1":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    if (Uiutils.isTourist(context))
                        return;
                    build = new Bundle();
                    build.putSerializable("page", "0");
                    IntentUtils.getInstence().intent(context, DepositActivity.class, build);
                    break;
                case "2":
                    questVersion(context);
                    break;
                case "3":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
//                    String sid = SPConstants.getValue(context, SPConstants.SP_API_SID);
//                    String apiToken = SPConstants.getValue(context, SPConstants.SP_API_TOKEN);
//                    intent = new Intent(context, WebActivity.class);
//                    intent.putExtra("url", Constants.BaseUrl() + Constants.CHAT + "logintoken=" + apiToken + "&sessiontoken=" + sid);
//                    intent.putExtra("type", "chat");
//                    context.startActivity(intent);

                    skipNewChat(context,"0","");
                    break;
                case "4":
                    configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
                    if (configBean != null && configBean.getData() != null && configBean.getData().getZxkfUrl() != null) {
                        if (TextUtils.isEmpty(configBean.getData().getZxkfUrl())) {
                            ToastUtils.ToastUtils("客服地址未配置或获取失败", context);
                            return;
                        }
                        loadInnerWebviewUrl(configBean.getData().getZxkfUrl(), context, "isHideTitle", "");
                    }
                    break;
                case "5":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    FragmentUtilAct.startAct(context, new DragonAssistantFrag(false));
                    break;
                case "6"://收益推荐
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    if (Uiutils.isTourist1(context)) {
                        FragmentUtilAct.startAct(context, new RecommendBenefitFrag(false));
                        return;
                    }
                    UserInfo userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);
                    configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
                    if (null != userInfo && null != userInfo.getData() && userInfo.getData().isAgent()) {
                        FragmentUtilAct.startAct(context, new RecommendBenefitFrag(false));
                    } else {
                        if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                                .getAgent_m_apply()) && StringUtils.equals("1", configBean.getData()
                                .getAgent_m_apply())) {
                            FragmentUtilAct.startAct(context, new AgencyProposerFrag(false));
                        } else {
                            ToastUtil.toastShortShow(context, "在线注册代理已关闭");
                        }
                    }
                    break;
                case "7":
                    String url = Constants.BaseUrl() + Constants.OPEN_PRIZE;
                    if (TextUtils.isEmpty(url))
                        return;
                    loadInnerWebviewUrl(url, context, "isHideTitle", "");
                    break;
                case "8":
                    userInfo = (UserInfo) ShareUtils.getObject(context, SPConstants.USERINFO, UserInfo.class);
                    if (userInfo != null && userInfo.getData() != null && !userInfo.getData().isYuebaoSwitch()) {
                        String name = null;
                        configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
                        if (configBean != null && configBean.getData() != null && configBean.getData().getYuebaoName() != null)
                            name = configBean.getData().getYuebaoName();
                        else
                            name = "利息宝";
                        ToastUtil.toastShortShow(context, name + "未开启");
                        return;
                    }
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    if (Uiutils.isTourist(context))
                        return;
                    context.startActivity(new Intent(context, InterestDoteyActivity.class));
                    break;
                case "9":
                    FragmentUtilAct.startAct(context, new CouponsFragment(false, false));
                    break;
                case "10":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    if (Uiutils.isTourist(context))
                        return;
                    Bundle bundle = new Bundle();
                    bundle.putInt("type", 1);
                    FragmentUtilAct.startAct(context, new NoteRecordFrag(), bundle);
                    break;
                case "11":
                    configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
                    String numQQ = configBean.getData().getAppPopupQqNum() == null ? "" : configBean.getData().getAppPopupQqNum();
                    String qq = !TextUtils.isEmpty(configBean.getData().getServiceQQ1()) ?configBean.getData().getServiceQQ1():!TextUtils.isEmpty(configBean.getData().getServiceQQ2())?configBean.getData().getServiceQQ2():"";
                    if (configBean != null && configBean.getData() != null && !TextUtils.isEmpty(configBean.getData().getAppPopupQqImg())) {
                        chatDialog(context, "QQ客服(" + numQQ + ")", configBean.getData().getAppPopupQqImg());
                    } else if (!TextUtils.isEmpty(qq)) {
                        launchQQ(context,qq);
                    } else {
                        ToastUtil.toastShortShow(context, "未配置图片");
                    }
                    break;
                case "12":
                    configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
                    String num = configBean.getData().getAppPopupWechatNum() == null ? "" : configBean.getData().getAppPopupWechatNum();
                    if (configBean != null && configBean.getData() != null && !TextUtils.isEmpty(configBean.getData().getAppPopupWechatImg())) {
                        chatDialog(context, "微信客服(" + num + ")", configBean.getData().getAppPopupWechatImg());
                    } else {
                        ToastUtil.toastShortShow(context, "未配置图片");
                    }
                    break;
                case "13":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    if (Uiutils.isTourist(context))
                        return;
                    FragmentUtilAct.startAct(context, new MissionCenterFrag(false));
                    break;
                case "14":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    FragmentUtilAct.startAct(context, new MailFrag(false));
                    break;
                case "15":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    FragmentUtilAct.startAct(context, new SignInFrag(false));
                    break;
                case "16"://投诉中心
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }
                    FragmentUtilAct.startAct(context, new FeedbackFrag());
                    break;
                case "17":
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }

                    //TODO
                    ToastUtil.toastShortShow(context,"敬请期待...");
                    break;
                case "18"://申请彩金
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }

                    FragmentUtilAct.startAct(context, new ActivityFiledFrag());
                    break;
                case "19"://购彩大厅
                    if (TextUtils.isEmpty(SPConstants.checkLoginInfo(context))) {
                        return;
                    }

                    BuyHallTypeActivity.Companion.start(context);
                    break;
            }
        } else if ("9".equals(linkCategory)) {  //聊天室
            skipNewChat(context,linkPosition,"");
        } else if ("10".equals(linkCategory)) {  //手机资料栏目
            //TODO
        }
    }


    public static void goqq(Context context,String qq){
//            configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
//            String numQQ = configBean.getData().getAppPopupQqNum() == null ? "" : configBean.getData().getAppPopupQqNum();
//        String qq = !TextUtils.isEmpty(configBean.getData().getServiceQQ1()) ?configBean.getData().
//                getServiceQQ1():!TextUtils.isEmpty(configBean.getData().getServiceQQ2())?configBean.getData().getServiceQQ2():"";
        if (!StringUtils.isEmpty(qq)) {
            launchQQ(context,qq);
        } else {
            ToastUtil.toastShortShow(context, "未配置图片");
        }
    }


}
