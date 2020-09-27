//
//  configuration.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#ifndef configuration_h
#define configuration_h

#import <Foundation/Foundation.h>

//参数是否加密
#define checkSign 1

//路径转换为restful开关
#define RESTFUL NO
//获取开奖数据间隔
#define NextIssueSec 3

#define IS_UPGRADE  @"IS_UPGRADE"    //是否显示升级图标
#define APP_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

#define RSAPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0CZTn+50HHM0QkziEunofDfIG77buLuRwItL8My9EYAyuLSW1qkLgqta2z2bIedx7Ro6enOZ0PZNFnqsztltGctwTwAVQDGoB+kpqUi5gs5jRTcoRkytgaLs7xZey45H0c2Hof4W+rcdHR/xc7C0hT5fBNqEDjBmGvoLlYpHag/p4m7h+JgpWHmKGWg7ijHMPWJQSFD1JPnP7upQlTJ8BKl24em6n2lSyH8qkoJKoEzUfQ7HricpF4S6MVCm36BSfkz35Oy4La7WxDrwW8KDs3ahKHM4uifgDlupZ+nV/dgzCQWDi5lNiQlvWR0xKsjwwrnXTdHPnMYDX8NdDTvTcQIDAQAB"

static NSString *swiperVerifyUrl = @"/dist/index.html#/swiperverify?platform=native";

static NSString *imagesServerUrl = @"https://cdn01.fsjtzs.cn//images";
static NSString *rechargeUrl = @"/dist/index.html#/funds/deposit";
static NSString *fundUrl = @"/dist/index.html#/funds/Withdraw";
static NSString *chatRoomUrl = @"/dist/index.html#/chatRoom?roomId=0&roomName=";
static NSString *newChatRoomUrl = @"/dist/#/home?from=app&logintoken=";

static NSString *yuebaoUrl = @"/dist/index.html#/yuebao";
static NSString *recommendUrl = @"/dist/index.html#/referrer/recommend";
static NSString *balanceConversionUrl = @"/dist/index.html#/conversion";
static NSString *taskCenterUrl = @"/dist/index.html#/task/task";
static NSString *signUrl = @"/dist/index.html#/Sign";
static NSString *changlongUrl = @"/dist/index.html#/changLong/fastChanglong";

#define pcUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"index2.php"]
//获取系统配置
#define systemConfigUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=config"]
//游客登录
#define guestLoginUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=guestLogin"]
//检查app版本
#define checkVersionUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=version"]
//图形验证码
#define getImgVcodeUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=secure&a=imgCaptcha"]
//手机短信验证码
#define getSmsVcodeUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=secure&a=smsCaptcha"]
//用户登录
#define userLoginUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=login"]
//退出登录
#define userLogoutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=logout"]
//用户注册
#define registerUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=reg"]
//用户账号信息
#define userInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=info"]
//修改登录密码
#define modifyLoginPwdUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=changeLoginPwd"]
//银行列表
#define bankListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=bankList"]
//绑定银行卡
#define bindCardUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=bindBank"]
//获取头像列表
#define getAvatarListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=avatarList"]
//修改头像
#define changAvatarListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=changeAvatar"]
//银行卡信息
#define bankCardInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=bankCard"]
//设置取款密码
#define addFundPwdUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=addFundPwd"]
//修改取款密码
#define modifyFundPwdUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=changeFundPwd"]
//获取彩票大厅数据
#define getAllNextIssue [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=lotteryGames"]
//彩票开奖记录
#define getLotteryHistoryUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=lotteryHistory"]
//彩票规则
#define getLotteryRuleUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=lotteryRule"]
//游戏中的余额自动转出
#define autoTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=autoTransferOut"]
// 增检查真人游戏是否存在余额未转出
#define needToTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=checkTransferStatus"]
//获取下一期开奖数据
#define getNextIssueUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=nextIssue"]
//长龙助手
#define changlongUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=changlong"]
//长龙助手投注记录
#define changlongBetListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=report&a=getUserRecentBet"]
//用户投注  新增傳入字段 activeReturnCoinRatio   傳入格式 string    列 : 拉條值為 4.5% , 則傳入 4.5
#define userBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=bet"]
#define userinstantBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=instantBet"]
#define guestBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=guestBet"]
//投注记录
#define getBetsListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=ticket&a=history"]
//取消注单
#define cancelBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=cancelBet"]
//获取彩票游戏数据
#define getGameDataUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=playOdds"]
//彩票大厅
#define getPlatformGamesUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=homeRecommend"]
//自定义游戏列表
#define getCustomGamesUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=homeGames"]
//各平台下级游戏列表
#define getGamelistUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=realGameTypes"]
//获取三方游戏路径
#define gotoGameUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=gotoGame"]
//轮播图
#define getBannerListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=banners"]
//公告列表
#define getNoticeListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=notice&a=latest"]
//排行榜列表
//#define getRankListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=rank&a=singlePrize"]
#define getRankListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=rankingList"]
//优惠活动列表 typeid
#define getPromoteListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=promotions"]
//写站内信
#define feedbackUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=addFeedback"]
//刪除全部站內信
#define deleteMsgAllUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=deleteMsgAll"]
//全部站內信全部已讀
#define readMsgAllUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=readMsgAll"]
//反馈列表
#define getFeedbackListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=myFeedback"]
//反馈详情
#define getFeedbackDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=feedbackDetail"]
//站内消息列表
#define getMsgListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=msgList"]
//修改消息状态
#define readMsgListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=readMsg"]
//常用登录地点列表
#define getLoginAddressUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=address"]
//跟新常用登录地点
#define modifyLoginAddressUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=changeAddress"]
//删除常用登录地点
#define delLoginAddressUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=delAddress"]
//额度转换真人列表
#define realGamesUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=realGames"]
//手动额度转换
#define manualTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=manualTransfer"]
//手动额度转换记录
#define transferLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=transferLogs"]
// 额度一键转出，第一步：获取需要转出的真人ID
#define oneKeyTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=oneKeyTransferOut"]
// 额度一键转出，第二步：根据真人ID并发请求单游戏快速转出
#define quickTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=quickTransferOut"]
//真人余额查询
#define checkRealBalanceUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=checkBalance"]
//利息宝统计查询
#define yuebaoInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=stat"]
//利息宝转入转出
#define yuebaoTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=transfer"]
//利息宝转入转出记录
#define yuebaoTransferLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=transferLogs"]
//利息宝收益报表
#define yuebaoProfitReportUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=profitReport"]
//提款申请
#define withdrawApplyUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=withdraw&a=apply"]
//存款记录
#define rechargeLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=logs"]
//取款记录
#define withdrawLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=withdraw&a=logs"]
//资金明细
#define fundLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=fundLogs"]
//用户签到列表
#define checkinListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkinList"]
//领取连续签到奖励
#define checkinBonusUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkinBonus"]
//用户签到（签到类型：0是签到，1是补签）
#define checkinUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkin"]
//用户签到历史
#define checkinHistoryUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkinHistory"]
//任务大厅
#define centerUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=center"]
//任务大厅分类
#define categoriesUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=categories"]
//领取任务
#define taskGetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=get"]
//领取奖励
#define taskRewardUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=reward"]
//积分账变列表
#define taskCreditsLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=creditsLog"]
//vip等级
#define taskLevelsLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=levels"]
//积分兑换
#define taskCreditsExchangeLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=creditsExchange"]
//推荐信息
#define teamInviteInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=inviteInfo"]
//下线信息
#define teamInviteListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=inviteList"]
//投注报表信息
#define teamBetStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=betStat"]
//投注记录信息
#define teamBetListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=betList"]
//线下充值信息
#define teamTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=transfer"]
//代理域名信息
#define teamInviteDomainUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=inviteDomain"]
//存款报表信息
#define teamDepositStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=depositStat"]
//存款记录信息
#define teamDepositListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=depositList"]
//提款报表信息
#define teamWithdrawStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=withdrawStat"]
//提款记录信息
#define teamWithdrawListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=withdrawList"]
//真人报表信息
#define teamRealBetStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=realBetStat"]
//真人记录信息
#define teamRealBetListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=realBetList"]
//支付通道列表信息
#define rechargeCashierUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=cashier"]
//在线支付
#define rechargeOnlinePayUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=onlinePay"]
//线下支付
#define rechargeTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=transfer"]
//会员申请代理接口
#define teamAgentApplyUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=agentApply"]
//领取俸禄接口 c=task&a=sendMissionBonus   (参数bonsId 领取俸禄的id 前面列表会传过去)
#define taskSendMissionBonusUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=sendMissionBonus"]
//红包详情
#define activityRedBagDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=redBagDetail"]
//领红包 {{TEST_HOST}}?c=activity&a=getRedBag
#define activityGetRedBagUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=getRedBag"]
//红包日志
#define chatRedBagLogPageUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=chat&a=redBagLogPage"]
//获取申请活动彩金列表
#define activityWinApplyListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=winApplyList"]
//获取申请活动彩金记录
#define activityApplyWinLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=applyWinLog"]
//申请彩金
#define activityApplyWinUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=applyWin"]
//获取申请活动彩金记录详情
#define activityApplyWinLogDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=applyWinLogDetail"]
//代理申请信息
#define teamAgentApplyInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=agentApplyInfo"]
//个人中心谷歌验证相关操作：(操作方法：gen:二维码生成, bind:绑定, unbind:解绑)
#define secureGaCaptchaUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=secure&a=gaCaptcha"]
//获取文档列表数据
#define getDocumentListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=bbs&a=gameDocList"]
//获取文档
#define getDocumentDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=bbs&a=gameDocDetail"]
//打赏文档
#define getDocumentPayUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=bbs&a=gameDocPay"]
//APP在线人数
#define systemOnlineCountUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=onlineCount"]
//首页广告图片
#define systemhomeAdsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=homeAds"]
//首页左右浮窗  {TEST_HOST}}?c=system&a=floatAds&token={{TOKEN}
#define systemfloatAdsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=floatAds"]
//大转盘活动数据 {TEST_HOST}}?c=activity&a=turntableList&token=F9YhrIONRI8jrSbKFNiJrFBo
#define activityTurntableListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=turntableList"]
//获取大转盘该用户当天抽奖日志（最新10条） {TEST_HOST}}?c=activity&a=turntableLog&token=F9YhrIONRI8jrSbKFNiJrFBo&activityId=13
#define  activityTurntableLogUrl   [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=turntableLog"]
//抽奖接口：
#define  activityTurntableWinUrl   [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=turntableWin"]
//侧边栏数据
#define  systemMobileRightUrl   [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=mobileRight"]
// 砸金蛋数据
#define  activityGoldenEggListUrl  [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=goldenEggList"]
// 砸金蛋日志
#define  activityGoldenEggLogUrl  [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=goldenEggLog"]
// 砸金蛋
#define  activityGoldenEggWinUrl  [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=goldenEggWin"]
// 刮刮乐数据
#define  activityScratchListUrl  [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=scratchList"]
// 刮刮乐日志
#define  activityScratchLogUrl  [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=scratchLog"]
// 刮
#define  activityScratchWinUrl  [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=scratchWin"]

//彩票注单统计
#define ticketlotteryStatisticsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=ticket&a=lotteryStatistics"]
// 获得最后一次莫彩种的下注信息  请求参数 ： id  必填（int）
#define ticketgetLotteryFirstOrderUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=ticket&a=getLotteryFirstOrder"]
//自营彩种列表
#define ownLotteryListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"/eapi/own_lottery_list?"]
//彩票开奖走势
#define lotteryTrendUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"eapi/get_lottery_data?gameMark=jsxingyu"]
//官方彩票开奖走势
#define officialLotteryTrendUrl [NSString stringWithFormat:@"%@/%@",@"https://www.fhptjk01.com",@"eapi/get_lottery_data?"]
//下注明细：
#define  userLotteryDayStatUrl   [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=lotteryDayStat"]
//给下级会员充值接口
#define teamRechargeUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=recharge"]
//1 获取俸禄列表接口
#define getMissionBonusListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=getMissionBonusList"]
//=============六合====================================================================================================
//老黄历
#define lhlDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=lhlDetail"]
//栏目列表
#define categoryListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=categoryList"]
//当前开奖信息
#define lotteryNumberUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=lotteryNumber"]
//我的历史帖子
#define historyContentUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=historyContent"]
//关注用户列表
#define followListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=followList"]
//关注帖子列表
#define favContentListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=favContentList"]
//六合用户数据
#define lhcdocgetUserInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=getUserInfo"]
//聊天室数据
#define chatgetTokenUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=chat&a=getToken"]
//=============开奖网url====================================================================================================
#define lotteryUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"open_prize/index.mobile.html?navhidden=1"]

#define lotteryByIdUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"open_prize/history.mobile.html?navhidden=1&&id="]
//=============直播url====================================================================================================
//http://test12.6yc.com/open_prize/video.html?id=1&&gameType=cqssc
#define liveUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"open_prize/video.html?navhidden=1&&id="]
//=============FB登录====================================================================================================
#define oauthHasBindUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=oauth&a=hasBind"]//接口，oauth    3. 未绑定处理-弹出绑定页面
#define oauthBindAccountUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=oauth&a=bindAccount"]//- 绑定旧账号：
#define oauthLoginUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=oauth&a=login"]//- - 访问无密码登录接口：oauth/login，返回站点授权token
#define oauthUnbindUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=oauth&a=unbind"]//解除三方绑定：oauth/unbind，参数：platform = 'facebook'





#ifdef DEBUG
#define NSLog(format, ...) printf("\n%s HHLog %s(line%d) %s\n%s\n\n", __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
//NSLog输出日志不全的解决方法 https://www.jianshu.com/p/287ad5861ff4
#define HJSonLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else
#define NSLog(format, ...)
#define HJSonLog(format, ...)
#endif



#define CMMETHOD_BEGIN
#define CMMETHOD_BEGIN_C(v)
#define CMMETHOD_BEGIN_O(v)
#define CMMETHOD_END
#define CMMETHOD_END_C(v)
#define CMMETHOD_END_O(v)

//#define CMMETHOD_BEGIN          (NSLog(@"%s.begin", __func__))
//#define CMMETHOD_BEGIN_C(v)     (NSLog(@"%s.begin, param: %ld", __func__, (long)v))
//#define CMMETHOD_BEGIN_O(v)     (NSLog(@"%s.begin, param: %@", __func__, v))
//#define CMMETHOD_END            (NSLog(@"%s.end", __func__))
//#define CMMETHOD_END_C(v)       (NSLog(@"%s.end, result: %ld", __func__, (long)v), v)
//#define CMMETHOD_END_O(v)       (NSLog(@"%s.end, result: %@", __func__, v), v)

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

#define UGScreenW [UIScreen mainScreen].bounds.size.width
#define UGScerrnH [UIScreen mainScreen].bounds.size.height
/*
 *判断设备是不是苹果X
 */
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6p 6sp 7p系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)
//判断iPhoneX所有系列
//#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define IS_PhoneXAll \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
#define k_Height_NavContentBar 44.0f
#define k_Height_NavBar (IS_PhoneXAll ? 88.0 : 64.0)//导航栏
#define k_Height_StatusBar (IS_PhoneXAll? 44.0 : 20.0)//状态栏
#define k_Height_TabBar (IS_PhoneXAll ? 83.0 : 49.0)//标签栏的高度
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_PhoneXAll ? 34 : 0)//安全的底部区域
#define IPHONE_TOPSENSOR_HEIGHT      (IS_PhoneXAll ? 32 : 0)//高级传感器

#define UGRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0] ///< 用10进制表示颜色，例如（255,255,255）黑色
#define RGBA(_R,_G,_B,_A) \
[UIColor colorWithRed:((_R) / 255.0) green:((_G) / 255.0) blue:((_B) / 255.0) alpha:_A]

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UGRandomColor UGRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define UGGreenColor UGRGBColor(105,172,91)
#define UGBlueColor UGRGBColor(76,150,236)
#define UGTextColor UGRGBColor(165,135,91)

#define UGNumColor1 [UIColor colorWithHex:0xe6de00]
#define UGNumColor2 [UIColor colorWithHex:0x0092dd]
#define UGNumColor3 [UIColor colorWithHex:0x4b4b4b]
#define UGNumColor4 [UIColor colorWithHex:0xff7600]
#define UGNumColor5 [UIColor colorWithHex:0x17e2e5]
#define UGNumColor6 [UIColor colorWithHex:0x5234ff]
#define UGNumColor7 [UIColor colorWithHex:0xbfbfbf]
#define UGNumColor8 [UIColor colorWithHex:0xff2600]
#define UGNumColor9 [UIColor colorWithHex:0x780b00]
#define UGNumColor10 [UIColor colorWithHex:0x07bf00]
#endif /* configuration_h */
