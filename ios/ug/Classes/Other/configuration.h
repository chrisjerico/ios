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

#define systemConfigUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=config"]

#define guestLoginUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=guestLogin"]

#define checkVersionUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=version"]

#define getImgVcodeUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=secure&a=imgCaptcha"]

#define getSmsVcodeUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=secure&a=smsCaptcha"]

#define userLoginUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=login"]

#define userLogoutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=logout"]

#define registerUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=reg"]

#define userInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=info"]

#define modifyLoginPwdUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=changeLoginPwd"]

#define bankListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=bankList"]

#define bindCardUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=bindBank"]

#define getAvatarListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=avatarList"]

#define changAvatarListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=changeAvatar"]

#define bankCardInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=bankCard"]

#define addFundPwdUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=addFundPwd"]

#define modifyFundPwdUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=changeFundPwd"]

#define getAllNextIssue [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=lotteryGames"]

#define getLotteryHistoryUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=lotteryHistory"]

#define getLotteryRuleUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=lotteryRule"]

#define autoTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=autoTransferOut"]

#define needToTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=checkTransferStatus"]

#define getNextIssueUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=nextIssue"]

#define changlongUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=changlong"]

#define changlongBetListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=report&a=getUserRecentBet"]

#define userBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=bet"]
#define userinstantBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=instantBet"]

#define guestBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=guestBet"]

#define getBetsListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=ticket&a=history"]

#define cancelBetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=cancelBet"]

#define getGameDataUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=playOdds"]

#define getPlatformGamesUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=homeRecommend"]

#define getCustomGamesUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=homeGames"]

#define getGamelistUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=realGameTypes"]

#define gotoGameUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=gotoGame"]

#define getBannerListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=banners"]

#define getNoticeListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=notice&a=latest"]

//#define getRankListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=rank&a=singlePrize"]

#define getRankListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=rankingList"]

#define getPromoteListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=promotions"]

#define feedbackUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=addFeedback"]

#define getFeedbackListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php/?c=user&a=myFeedback"]

#define getFeedbackDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=feedbackDetail"]

#define getMsgListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=msgList"]

#define readMsgListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=readMsg"]

#define getLoginAddressUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=address"]

#define modifyLoginAddressUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=changeAddress"]

#define delLoginAddressUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=delAddress"]

#define realGamesUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=game&a=realGames"]

#define manualTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=manualTransfer"]

#define transferLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=transferLogs"]

#define oneKeyTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=oneKeyTransferOut"]

#define quickTransferOutUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=quickTransferOut"]

#define checkRealBalanceUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=real&a=checkBalance"]

#define yuebaoInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=stat"]

#define yuebaoTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=transfer"]

#define yuebaoTransferLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=transferLogs"]

#define yuebaoProfitReportUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=yuebao&a=profitReport"]

#define withdrawApplyUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=withdraw&a=apply"]

#define rechargeLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=logs"]

#define withdrawLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=withdraw&a=logs"]

#define fundLogsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=user&a=fundLogs"]

#define checkinListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkinList"]

#define checkinBonusUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkinBonus"]

#define checkinUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkin"]

#define checkinHistoryUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=checkinHistory"]

#define centerUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=center"]

#define taskGetUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=get"]

#define taskRewardUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=reward"]

#define taskCreditsLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=creditsLog"]

#define taskLevelsLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=levels"]

#define taskCreditsExchangeLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=task&a=creditsExchange"]

#define teamInviteInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=inviteInfo"]

#define teamInviteListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=inviteList"]

#define teamBetStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=betStat"]

#define teamBetListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=betList"]

#define teamTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=transfer"]

#define teamInviteDomainUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=inviteDomain"]

#define teamDepositStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=depositStat"]

#define teamDepositListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=depositList"]

#define teamWithdrawStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=withdrawStat"]

#define teamWithdrawListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=withdrawList"]

#define teamRealBetStatUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=realBetStat"]

#define teamRealBetListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=realBetList"]

#define rechargeCashierUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=cashier"]

#define rechargeOnlinePayUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=onlinePay"]

#define rechargeTransferUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=recharge&a=transfer"]

#define teamAgentApplyUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=agentApply"]

#define activityRedBagDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=redBagDetail"]

#define activityGetRedBagUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=getRedBag"]

#define activityWinApplyListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=winApplyList"]

#define activityApplyWinLogUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=applyWinLog"]

#define activityApplyWinUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=applyWin"]

#define activityApplyWinLogDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=activity&a=applyWinLogDetail"]

#define teamAgentApplyInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=agentApplyInfo"]

#define secureGaCaptchaUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=secure&a=gaCaptcha"]

#define getDocumentListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=bbs&a=gameDocList"]

#define getDocumentDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=bbs&a=gameDocDetail"]

#define getDocumentPayUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=bbs&a=gameDocPay"]

#define systemOnlineCountUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=onlineCount"]

#define systemhomeAdsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=homeAds"]

#define systemfloatAdsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=system&a=floatAds"]

#define ticketlotteryStatisticsUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=ticket&a=lotteryStatistics"]
// 走势
#define ownLotteryListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"/eapi/own_lottery_list?"]

#define lotteryTrendUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"eapi/get_lottery_data?gameMark=jsxingyu"]
#define officialLotteryTrendUrl [NSString stringWithFormat:@"%@/%@",@"https://www.fhptjk01.com",@"eapi/get_lottery_data?"]

//给下级会员充值接口
#define teamRechargeUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=team&a=recharge"]

//=============六合====================================================================================================
#define lhlDetailUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=lhlDetail"]

#define categoryListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=categoryList"]

#define lotteryNumberUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=lotteryNumber"]

#define historyContentUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=historyContent"]

#define followListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=followList"]

#define favContentListUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=favContentList"]

#define lhcdocgetUserInfoUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=lhcdoc&a=getUserInfo"]

#define chatgetTokenUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"wjapp/api.php?c=chat&a=getToken"]
//=============开奖网url====================================================================================================
#define lotteryUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"open_prize/index.mobile.html?navhidden=1"]
//=============直播url====================================================================================================
//http://test12.6yc.com/open_prize/video.html?id=1&&gameType=cqssc
#define liveUrl [NSString stringWithFormat:@"%@/%@",APP.Host,@"open_prize/video.html?navhidden=1&&id="]


#if DEBUG

//#define NSLog(...) NSLog(__VA_ARGS__)

#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


#else

//#define NSLog(...) {}

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
