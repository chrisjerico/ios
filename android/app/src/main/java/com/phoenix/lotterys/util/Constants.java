package com.phoenix.lotterys.util;

import android.content.Context;
import android.os.Environment;
import android.util.Log;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import okhttp3.MediaType;

/**
 * Created by Luke
 * on 2019/6/9
 */
public class Constants {
    //txt开头的为 测试环境 false，否则为 生产环境 true
    public static boolean ENCRYPT = BuildConfig.FLAVOR.startsWith("txt") ? false : true;
//    public static final String BaseUrl = "http://test100f.fhptcdn.com";  //
//    public static final String BaseUrl = "http://test10.6yc.com/Open_prize/index.php";  //
//    public static String BaseUrl = BuildConfig.DOMAIN_NAME;  //

    public static boolean ALL_SITES = false;//是否打开切换全站

    public static String PATH = "/wjapp/api.php";  //
    //    public static  String SIGN = "";  //
    public static String SIGN = "&checkSign=true";  //
    public static final String LOTTERYBUY = PATH + "?c=game&a=lotteryGames";     //购彩大厅游戏数据
    public static final String LOTTERYGAMEODDS = PATH + "?c=game&a=playOdds&id=";     //彩票详情
    public static final String USERREGEDIT = PATH + "?c=user&a=reg";     //注册
    public static final String USERLOGIN = PATH + "?c=user&a=login";     //登录
    public static final String GAMETYPE = PATH + "?c=game&a=homeRecommend";     //游戏类型
    public static final String CUSTOMGAMETYPE = PATH + "?c=game&a=customGames";     //游戏类型
    public static final String HOMEGAMES = PATH + "?c=game&a=homeGames";     //首页游戏列表
    public static final String LOGOUT = PATH + "?c=user&a=logout";     //退出
    public static final String GUESTLOGIN = PATH + "?c=user&a=guestLogin";     //游客登录
    public static final String USERINFO = PATH + "?c=user&a=info&token=";     //用户信息
    public static final String LOTTERYBET = PATH + "?c=user&a=bet";     //下注
    public static final String INSTANTLOTTERYBET = PATH + "?c=user&a=instantBet";     //秒秒下注
    public static final String LOTTERYGUESTBET = PATH + "?c=user&a=guestBet";     //试玩下注
    public static final String BANNER = PATH + "?c=system&a=banners";     //banner
    public static final String CONFIG = PATH + "?c=system&a=config";     //配置文件
    //    public static final String RANKLIST = BaseUrl + PATH + "?c=rank&a=singlePrize";     //中奖排行榜
//    public static String NOTICE = "http://tgkfhfg.com"  + "?c=notice&a=latest";     //公告
    public static final String NOTICE = PATH + "?c=notice&a=latest";     //公告
    public static final String FLOAT_AD = PATH + "?c=system&a=floatAds";     //悬浮公告
    public static String COUPONS = PATH + "?c=system&a=promotions";     //优惠活动
    public static final String WALLETLIST = PATH + "?c=game&a=realGames";     //余额转换列表
    public static final String CHAT = "/dist/#/chatRoomList?from=app&back=hide&";     //聊天室列表
    public static final String CHATROOM = "/dist/#/chatRoomList?id=";     //聊天室
    public static final String SHARECHATROOM = "/dist/index.html#/chatRoom?roomId=0&roomName=";     //分享到聊天室
    public static final String CHATROOM_NEW = "/h5chat/index.php#/chatRoom?from=app&back=hide&hideHead=true&";     //聊天室列表
    public static final String LOTTERYNUM = PATH + "?c=game&a=nextIssue&id=";     //开奖结果
    public static final String BANKLIST = PATH + "?c=system&a=bankList";     //银行列表
    public static final String BANKCARDLIST = PATH + "?c=user&a=bankCard&token=";     //银行卡列表
    public static final String BANDBANKCARDLIST = PATH + "?c=user&a=bindBank";     //银行卡绑定
    public static final String FUNDPWD = PATH + "?c=user&a=addFundPwd";     //设置支付密码
    public static final String GOTOGAMEREAL = PATH + "?c=real&a=gotoGame&";     //真人
    public static final String GOTOGAME = PATH + "?c=real&a=gameUrl&";     //跳转到第三方游戏
    public static final String GOTOGAMELIST = PATH + "?c=game&a=realGameTypes&id=";     //二级游戏列表
    public static final String GET_TOKEN = PATH + "?c=chat&a=getToken";     //获取聊天房间列表

    //修改用户提款密码
    public static final String CHANGELOGINPWD = PATH + "?c=user&a=changeLoginPwd";

    //修改用户提款密码
    public static final String CHANGEFUNDPWD = PATH + "?c=user&a=changeFundPwd";

    //用户留言反馈提交（type: 0=提交建议，1=我要投诉）
    public static final String ADDFEEDBACK = PATH + "?c=user&a=addFeedback";

    //用户留言反馈列表(不填类型获取全部)
    public static final String MYFEEDBACK = PATH + "?c=user&a=myFeedback";

    //用户留言反馈详情
    public static final String FEEDBACKDETAIL = PATH + "?c=user&a=feedbackDetail";

    //获取站内信列表
    public static final String MSGLIST = PATH + "?c=user&a=msgList";
    //站内信读取
    public static final String READMSG = PATH + "?c=user&a=readMsg";
    //所有站内信读取
    public static final String READ_ALLMSG = PATH + "?c=user&a=readMsgAll";

    //获取所有常用登录地
    public static final String ADDRESS = PATH + "?c=user&a=address";
    //更新用户常用登录地
    public static final String CHANGEADDRESS = PATH + "?c=user&a=changeAddress";
    //删除用户常用登录地
    public static final String DELADDRESS = PATH + "?c=user&a=delAddress";

    //注单讯息
    public static final String GETBETSLIST = PATH + "?c=report&a=getBetsList";

    //注单讯息
    public static final String HISTORY = PATH + "?c=ticket&a=history";

    //彩票注单统计
    public static final String LOTTERYSTATISTICS = PATH + "?c=ticket&a=lotteryStatistics";

    //用户签到列表（签到类型：0是签到，1是补签）
    public static final String CHECKINLIST = PATH + "?c=task&a=checkinList";

    //用户签到（签到类型：0是签到，1是补签）
    public static final String CHECKIN = PATH + "?c=task&a=checkin";

    //彩票游戏列表（购彩大厅）
    public static final String LOTTERYGAMES = PATH + "?c=game&a=lotteryGames";

    //彩票开奖历史
    public static final String LOTTERYHISTORY = PATH + "?c=game&a=lotteryHistory";

    //玩家取消注单
    public static final String CANCELBET = PATH + "?c=user&a=cancelBet";

    //系统头像列表
    public static final String AVATARLIST = PATH + "?c=system&a=avatarList";

    //修改用户头像
    public static final String CHANGEAVATAR = PATH + "?c=task&a=changeAvatar";


    //彩票游戏规则
    public static final String LOTTERYRULE1 = PATH + "?c=game&a=lotteryRule";
    //彩票游戏规则
    public static final String LOTTERYRULE = PATH + "?c=game&a=lotteryRule&id=";

    //个人中心谷歌验证相关操作：(操作方法：gen:二维码生成, bind:绑定, unbind:解绑)
    public static final String GACAPTCHA = PATH + "?c=secure&a=gaCaptcha";

    //长龙助手
    public static final String CHANGLONG = PATH + "?c=game&a=changlong";

    public static final String IMGCODE = PATH + "?c=secure&a=imgCaptcha&accessToken=";//图片验证码
    public static final String PHONECODE = PATH + "?c=secure&a=smsCaptcha";//短信验证码

    //任务大厅
    public static final String CENTER = PATH + "?c=task&a=center";

    //任务大厅分类
    public static final String CENTER_CATEGORY = PATH + "?c=task&a=categories";

    //积分兑换
    public static final String CREDITSEXCHANGE = PATH + "?c=task&a=creditsExchange";

    //积分账变列表
    public static final String CREDITSLOG = PATH + "?c=task&a=creditsLog";

    //任务头衔
    public static final String LEVELS = PATH + "?c=task&a=levels";

    //代理推荐信息
    public static final String INVITEINFO = PATH + "?c=team&a=inviteInfo";

    //领取奖励
    public static final String REWARD = PATH + "?c=task&a=reward";

    //领取任务
    public static final String GET_TASK = PATH + "?c=task&a=get";

    //代理申请信息
    public static final String AGENTAPPLYINFO = PATH + "?c=team&a=agentApplyInfo";
    //会员申请代理接口
    public static final String AGENTAPPLY = PATH + "?c=team&a=agentApply";
    //代理域名
    public static final String INVITEDOMAIN = PATH + "?c=team&a=inviteDomain";
    //代理下线列表
    public static final String INVITELIST = PATH + "?c=team&a=inviteList";
    //代理下线充值
    public static final String RECOMMEND_TRANSFER = PATH + "?c=team&a=transfer";
    //代理下线投注报表
    public static final String BETSTAT = PATH + "?c=team&a=betStat";
    //代理下线投注记录
    public static final String BETLIST = PATH + "?c=team&a=betList";
    //代理下线存款报表
    public static final String DEPOSITSTAT = PATH + "?c=team&a=depositStat";
    //代理下线存款记录
    public static final String DEPOSITLIST = PATH + "?c=team&a=depositList";
    //代理下线提款报表
    public static final String WITHDRAWSTAT = PATH + "?c=team&a=withdrawStat";
    //代理下线提款记录
    public static final String WITHDRAWLIST = PATH + "?c=team&a=withdrawList";
    //代理下线真人投注报表
    public static final String REALBETSTAT = PATH + "?c=team&a=realBetStat";
    //代理下线真人投注记录
    public static final String REALBETLIST = PATH + "?c=team&a=realBetList";

    //长龙助手-我的投注
    public static final String GETUSERRECENTBET = PATH + "?c=report&a=getUserRecentBet";

    //领取连续签到奖励
    public static final String CHECKINBONUS = PATH + "?c=task&a=checkinBonus";

    //用户签到历史
    public static final String CHECKINHISTORY = PATH + "?c=task&a=checkinHistory";


    //申请活动彩金活动列表
    public static final String WINAPPLYLIST = PATH + "?c=activity&a=winApplyList";
    //申请参与申请彩金活动
    public static final String APPLYWIN = PATH + "?c=activity&a=applyWin";
    //获取申请活动彩金记录
    public static final String APPLYWINLOG = PATH + "?c=activity&a=applyWinLog";
    //获取申请活动彩金记录详情
    public static final String APPLYWINLOGDETAIL = PATH + "?c=activity&a=applyWinLogDetail";



    //获取老黄历详情
    public static final String LHLDETAIL =  PATH+"?c=lhcdoc&a=lhlDetail";
    //六合图库列表接口
    public static final String TKLIST =  PATH+"?c=lhcdoc&a=tkList";
    //获取帖子的期数列表
    public static final String LHCNOLIST =  PATH+"?c=lhcdoc&a=lhcNoList";
    //获取帖子详情
//    public static final String CONTENTDETAIL =  PATH+"?c=lhcdoc&a=contentDetail";
    //获取帖子评论
//    public static final String CONTENTREPLYLIST =  PATH+"?c=lhcdoc&a=contentReplyList";
    //点赞内容或帖子
//    public static final String LIKEPOST =  PATH+"?c=lhcdoc&a=likePost";
    //发表评论
    public static final String POSTCONTENTREPLY =  PATH+"?c=lhcdoc&a=postContentReply";
    //收藏资料
//    public static final String DOFAVORITES =  PATH+"?c=lhcdoc&a=doFavorites";
    //给帖子投票
    public static final String VOTE =  PATH+"?c=lhcdoc&a=vote";
    //帖子列表
//    public static final String CONTENTLIST =  PATH+"?c=lhcdoc&a=contentList";
    //粉丝列表
    public static final String FANSLIST =  PATH+"?c=lhcdoc&a=fansList";
    //帖子粉丝列表
    public static final String CONTENTFANSLIST =  PATH+"?c=lhcdoc&a=contentFansList";
    //我的历史帖子
//    public static final String HISTORYCONTENT =  PATH+"?c=lhcdoc&a=historyContent";
    //关注用户列表
    public static final String FOLLOWLIST =  PATH+"?c=lhcdoc&a=followList";
    //关注帖子列表
    public static final String FAVCONTENTLIST =  PATH+"?c=lhcdoc&a=favContentList";
    //关注或取消关注楼主
//    public static final String FOLLOWPOSTER =  PATH+"?c=lhcdoc&a=followPoster";




    public static final String IMGCDN = "https://cdn01.fsjtzs.cn//images/";     //图片
    public static final String UPDATA = "https://cdn01.fsjtzs.cn//images/";     //更新
    //    public static final String SLIDECODE = "http://t005f.fhptcdn.com/dist/index.html#/swiperverify";     //滑动验证码
    public static final String SLIDECODE = "/dist/index.html#/swiperverify?platform=native";     //滑动验证码
    //    public static final String SLIDECODE = "http://test19.6yc.com"+"/dist/index.html#/swiperverify";     //滑动验证码
    public static final String USEREXISTS = PATH + "?c=user&a=exists";  //检测用户是否存在
    public static final String GOOGLEANDROIDCODE = "lib/google_authenticator/google_android.apk";  //  二次验证 android
    public static final String GOOGLEIOSCODE = "https://apps.apple.com/cn/app/google-authenticator/id388497605";  //二次验证 ios
    public static final String ANDROIDVERSION = PATH + "?c=system&a=version&device=";  //app版本更新
    public static final String LAUNCHIMAGES = PATH + "?c=system&a=launchImages";  //启动图
    public static final String AUTOTRANSFEROUT = PATH + "?c=real&a=autoTransferOut";  //自动转出
    public static final String WITHDRAW = PATH + "?c=withdraw&a=apply";  //提款申请
    public static final String DEPOSITRECORD = PATH + "?c=recharge&a=logs&";  //存款记录
    public static final String DRAWRECORD = PATH;  //提款记录
    public static final String FUNDRECORD = PATH;  //资金明细
    public static final String YUEBAO = PATH + "?c=yuebao&a=stat&token=";  //利息宝
    public static final String PROFITREPORT = PATH;  //收益报表
    public static final String TRANSFERLOGS = PATH;  //利息宝转出转入记录
    public static final String TRANSFER = PATH + "?c=yuebao&a=transfer";  //利息宝转出转入
    public static final String PAYAISLE = PATH + "?c=recharge&a=cashier&token=";  //支付通道
    public static final String CHECKBALANCE = PATH;  //查询真人游戏余额
    public static final String MANUALTRANSFER = PATH + "?c=real&a=manualTransfer";  //额度转换
    public static final String TRANSFERINTEREST = PATH;  //额度转换记录
    public static final String PAYOFFLINE = PATH + "?c=recharge&a=transfer";  //人工转账
    public static final String ONLINE = PATH + "?c=recharge&a=onlinePay";  //在线支付
    public static final String THIRDPAY = PATH + "?c=recharge&a=payUrl";  //跳转到第三方支付页面
    public static final String ONLINECOUNT = PATH + "?c=system&a=onlineCount";  //在线人数
    public static final String RANKINGLIST = PATH + "?c=system&a=rankingList";  //首页排行榜
    public static final String REDBAGDETAIL = PATH + "?c=activity&a=redBagDetail";  //红包活动信息
    public static final String GETREDBAG = PATH + "?c=activity&a=getRedBag";  //领红包
    public static final String BBSLIST = PATH + "?c=bbs&a=gameDocList&";  //资讯列表
    public static final String BBSDETAILS = PATH + "?c=bbs&a=gameDocDetail&";  //资讯详情
    public static final String BBSDETAILSPAY = PATH + "?c=bbs&a=gameDocPay";  //资讯付费
    public static final String OPEN_PRIZE = "/Open_prize/index.php";  //开奖网
    public static final String CHECKTRANSFERSTATUS = PATH + "?c=real&a=checkTransferStatus&token=";  //检查额度转换状态
    public static final String ONEKEYTRANSFEROUT = PATH + "?c=real&a=oneKeyTransferOut";  //一键转出
    public static final String QUICKTRANSFEROUT = PATH + "?c=real&a=quickTransferOut";  //单游戏转出



    //六合模板
    public static final String LHCLIST = PATH + "?c=lhcdoc&a=categoryList";  //栏目列表
    public static final String LHCNUM = PATH + "?c=lhcdoc&a=lotteryNumber";  //六合彩开奖信息
    public static final String CONTENTLIST = PATH + "?c=lhcdoc&a=contentList";  //帖子列表
    public static final String POSTCONTENT = PATH + "?c=lhcdoc&a=postContent";  //发帖
    public static final String HISTORYCONTENT = PATH + "?c=lhcdoc&a=historyContent";  //历史记录
    public static final String SEARCHCONTENT = PATH + "?c=lhcdoc&a=searchContent";  //搜索记录
    public static final String CONTENTDETAIL = PATH + "?c=lhcdoc&a=contentDetail";  //帖子详情1
    public static final String CONTENTREPLYLIST = PATH + "?c=lhcdoc&a=contentReplyList";  //评论列表
    public static final String FOLLOWPOSTER = PATH + "?c=lhcdoc&a=followPoster";  //关注楼主
    public static final String DOFAVORITES = PATH + "?c=lhcdoc&a=doFavorites";  //收藏
    public static final String LIKEPOST = PATH + "?c=lhcdoc&a=likePost";  //点赞帖子或内容
    public static final String BUYCONTENT = PATH + "?c=lhcdoc&a=buyContent";  //购买帖子
    public static final String SIXTHEMEUSERINFO = PATH + "?c=lhcdoc&a=getUserInfo";  //六合模板个人用户信息
    public static final String SETNICKNAME = PATH + "?c=lhcdoc&a=setNickname";  //六合模板个人用户信息
    public static final String CONTENTREPLY = PATH + "?c=lhcdoc&a=postContentReply";  //发表评论
    public static final String TIPCONTENT = PATH + "?c=lhcdoc&a=tipContent";  //打赏

    public static final String HOMEADS = PATH + "?c=system&a=homeAds";  //

    public static final String MINE_FRIENDS = PATH + "?c=moment&a=myMoment&msg_type=1&rows=10&page=";     //我的朋友圈
    public static final String ALL_FRIENDS = PATH + "?c=moment&a=allMoment&msg_type=1&rows=10&page=";     //所有朋友圈
    public static final String SHARE_TO_FRIENDS = PATH + "?c=moment&a=addMoment";     //分享至朋友圈
    public static final String DEL_SHARE = PATH + "?c=moment&a=delMoment";     //删除朋友圈
    public static final String LIKE_SHARE = PATH + "?c=moment&a=addLike";     //朋友圈点赞
    public static final String LIKE_CANCEL_SHARE = PATH + "?c=moment&a=cancelLike";     //朋友圈点赞
    public static final String COMMENT_SHARE = PATH + "?c=moment&a=addComment";     //朋友圈评论
    public static final String UPLOAD_IMG = PATH + "?c=moment&a=uploadFile";     //朋友圈图片上传
    public static final String ADD_FOLLOW = PATH + "?c=moment&a=addFollow";     //关注

    public static final String CHAT_LIST = PATH + "?c=chat&a=conversationList";     //会话列表
    public static final String CHAT_HISTORY = PATH + "?c=chat&a=messageRecord";     //历史消息
    public static final String CREATE_RED_BAG = PATH + "?c=chat&a=createRedBag";     //生成红包
    public static final String GET_RED_BAG = PATH + "?c=chat&a=grabRedBag";     //抢红包
    public static final String RED_BAG_DETAIL = PATH + "?c=chat&a=redBag";     //红包详情
    public static final String HISTORY_TICKET_LIST = PATH + "?c=chat&a=betList";     //历史注单列表
    public static final String CHAT_UPLOAD_IMG = PATH + "?c=chat&a=uploadFile";     //聊天图片上传
    public static final String CHAT_LIST_TOP = PATH + "?c=chat&a=conversationTop";     //会话列表置顶
    public static final String CHAT_LIST_DEL = PATH + "?c=chat&a=conversationDel";     //会话列表删除

    public static final String RED_ENVELOPES = PATH + "?c=chat&a=redBagLogPage";     //会话列表

    public static final String TREND_OFFICIAL = "https://www.fhptkj01.com/eapi/get_lottery_data";     //官方预测
    public static final String TREND_SELF_SUPPORT = "/eapi/get_lottery_data";     //自营预测

    //下载路径
//    public static final String APK_SAVE_PATH = Environment.getExternalStorageDirectory().getAbsolutePath() + "/UpdateAPK/fhjt.apk";
    public static final String apkPath(Context context) {
        String path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/" + APKVersionCodeUtils.getPackageName(context) + "/fhjt.apk";
        return path;
    }

    static List<String> host = SPConstants.getListValue();
    static Application mApp;

    public static void alterHost() {
        mApp = (Application) Application.getContextObject();
        mApp.setCount();

    }

    public static String BaseUrl() {

        //是否打开切换全站
        if (ALL_SITES && !StringUtils.isEmpty(ShareUtils.getString(Application.getInstance(),"host",""))){
            return ShareUtils.getString(Application.getInstance(),"host","");
        }


        String BaseUrl = "";
        if (host == null)
            return BuildConfig.DOMAIN_NAME;
        for (int i = 0; i < host.size(); i++) {

        }
        mApp = (Application) Application.getContextObject();
//        if(mApp.getCount()==0)
//            BaseUrl =  BuildConfig.DOMAIN_NAME;
//        else
//        if(mApp.getCount()<host.size()){
//            BaseUrl= host.get(mApp.getCount());
//        }else {
        BaseUrl = BuildConfig.DOMAIN_NAME;
//        }

        return BaseUrl;
    }

    public static final MediaType JSON = MediaType.parse("application/json;charset=UTF-8");

//黑色模板浏览记录
    static List<HomeGame.DataBean.IconsBean.ListBean> LastReadList = new ArrayList<>();
    static List<HomeGame.DataBean.IconsBean.ListBean> LastRead = new ArrayList<>();
//    static HomeGame.DataBean.IconsBean.ListBean data;
    public static List<HomeGame.DataBean.IconsBean.ListBean> getLastReadList() {
        return LastReadList;
    }
    public static void addLastReadList(HomeGame.DataBean.IconsBean.ListBean lastReadList) {
        for (int i = 0; i < LastReadList.size(); i++) {
            if (lastReadList!=null&&lastReadList.getGameId()!=null&&lastReadList.getGameId().equals(LastReadList.get(i).getGameId())) {
                LastReadList.remove(i);
            }
        }

        LastReadList.add(lastReadList);
    }
    public static HomeGame.DataBean.IconsBean game = new HomeGame.DataBean.IconsBean();
    public static HomeGame.DataBean.IconsBean getGame() {
        if(LastRead!=null){
            LastRead.clear();
        }
        LastRead.addAll(LastReadList);
        Collections.reverse(LastRead);
        game.setList(LastRead);
        return game;
    }
    public static void setGame(HomeGame.DataBean.IconsBean game) {
        game.setList(LastReadList);
    }


    public static boolean isHowMag = false;

}
