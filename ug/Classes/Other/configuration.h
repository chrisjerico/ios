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

//路径转换为restful开关
#define RESTFUL NO
//参数是否加密
#define checkSign 0
//获取开奖数据间隔
#define NextIssueSec 10

#define IS_UPGRADE  @"IS_UPGRADE"    //是否显示升级图标
#define APP_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

#define RSAPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEJxz/vN7M0OokKGoikyDiWZJHC3asHzRWC58J3oI7VItExzPhGdh+mXh9Z482OGULOO5PhXUrQk1che47jc9OPazjbODo1wkIEyAIsjbCneS5cbCrRIIsWrWva2i18ze4N6b4gWabbyt9bRtQrGXNttnr2/ILeu2SkClmEKBEswIDAQAB"

static NSString *baseServerUrl = @"http://test10.6yc.com";
//static NSString *baseServerUrl = @"http://test100f.fhptcdn.com";

static NSString *swiperVerifyUrl = @"/dist/index.html#/swiperverify";

static NSString *imagesServerUrl = @"https://cdn01.fsjtzs.cn//images";
static NSString *rechargeUrl = @"/dist/index.html#/funds/deposit";
static NSString *fundUrl = @"/dist/index.html#/funds/Withdraw";
static NSString *chatRoomUrl = @"/dist/index.html#/chatRoomList";
static NSString *yuebaoUrl = @"/dist/index.html#/yuebao";
static NSString *recommendUrl = @"/dist/index.html#/referrer/recommend";
static NSString *balanceConversionUrl = @"/dist/index.html#/conversion";
static NSString *taskCenterUrl = @"/dist/index.html#/task/task";
static NSString *signUrl = @"/dist/index.html#/Sign";
static NSString *changlongUrl = @"/dist/index.html#/changLong/fastChanglong";

#define systemConfigUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=system&a=config"]

#define guestLoginUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=guestLogin"]

#define checkVersionUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=system&a=version"]

#define getImgVcodeUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=secure&a=imgCaptcha"]

#define getSmsVcodeUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php/?c=secure&a=smsCaptcha"]

#define userLoginUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=login"]

#define userLogoutUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php/?c=user&a=logout"]

#define registerUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=reg"]

#define userInfoUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=info"]

#define modifyLoginPwdUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=changeLoginPwd"]

#define bankListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=system&a=bankList"]

#define bindCardUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=bindBank"]

#define getAvatarListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=system&a=avatarList"]

#define changAvatarListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=task&a=changeAvatar"]

#define bankCardInfoUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=bankCard"]

#define addFundPwdUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=addFundPwd"]

#define modifyFundPwdUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=changeFundPwd"]

#define getAllNextIssue [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=lotteryGames"]

#define getLotteryHistoryUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=lotteryHistory"]

#define getLotteryRuleUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=lotteryRule"]

#define autoTransferOutUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=real&a=autoTransferOut"]

#define getNextIssueUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=nextIssue"]

#define changlongUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=changlong"]

#define changlongBetListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=report&a=getUserRecentBet"]

#define userBetUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=bet"]

#define guestBetUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=guestBet"]

#define getBetsListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=ticket&a=history"]

#define cancelBetUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=cancelBet"]

#define getGameDataUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=playOdds"]

#define getPlatformGamesUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=homeRecommend"]

#define getGamelistUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=realGameTypes"]

#define gotoGameUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=real&a=gotoGame"]

#define getBannerListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=system&a=banners"]

#define getNoticeListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=notice&a=latest"]

#define getRankListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=rank&a=singlePrize"]

#define getPromoteListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=system&a=promotions"]

#define feedbackUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php/?c=user&a=addFeedback"]

#define getFeedbackListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php/?c=user&a=myFeedback"]

#define getFeedbackDetailUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=feedbackDetail"]

#define getMsgListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=msgList"]

#define readMsgListUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=readMsg"]

#define getLoginAddressUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=address"]

#define modifyLoginAddressUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=changeAddress"]

#define delLoginAddressUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=delAddress"]

#define realGamesUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=game&a=realGames"]

#define manualTransferUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=real&a=manualTransfer"]

#define transferLogsUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=real&a=transferLogs"]

#define checkRealBalanceUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=real&a=checkBalance"]

#define yuebaoInfoUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=yuebao&a=stat"]

#define yuebaoTransferUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=yuebao&a=transfer"]

#define yuebaoTransferLogsUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=yuebao&a=transferLogs"]

#define yuebaoProfitReportUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=yuebao&a=profitReport"]

#define withdrawApplyUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=withdraw&a=apply"]

#define rechargeLogsUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=recharge&a=logs"]

#define withdrawLogsUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=withdraw&a=logs"]

#define fundLogsUrl [NSString stringWithFormat:@"%@/%@",baseServerUrl,@"wjapp/api.php?c=user&a=fundLogs"]


#ifndef __OPTIMIZE__

#define NSLog(...) NSLog(__VA_ARGS__)

#else

#define NSLog(...) {}

#endif

#define CMMETHOD_BEGIN          (NSLog(@"%s.begin", __func__))
#define CMMETHOD_BEGIN_C(v)     (NSLog(@"%s.begin, param: %ld", __func__, (long)v))
#define CMMETHOD_BEGIN_O(v)     (NSLog(@"%s.begin, param: %@", __func__, v))
#define CMMETHOD_END            (NSLog(@"%s.end", __func__))
#define CMMETHOD_END_C(v)       (NSLog(@"%s.end, result: %ld", __func__, (long)v), v)
#define CMMETHOD_END_O(v)       (NSLog(@"%s.end, result: %@", __func__, v), v)

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

#define UGScreenW [UIScreen mainScreen].bounds.size.width
#define UGScerrnH [UIScreen mainScreen].bounds.size.height
#define UGNavColor [UIColor colorWithRed:76/255.0 green:150/255.0 blue:236/255.0 alpha:1.0]
#define UGBackgroundColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define UGRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0] ///< 用10进制表示颜色，例如（255,255,255）黑色
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
