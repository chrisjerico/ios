//
//  CMNetwork+Mine.m
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork+Mine.h"
#import "UGUserModel.h"
#import "UGUserLevelModel.h"
#import "UGbankModel.h"
#import "UGCardInfoModel.h"
#import "UGMessageModel.h"
#import "UGLoginAddressModel.h"
#import "UGAvatarModel.h"
#import "UGPlatformGameModel.h"
#import "UGYuebaoInfoModel.h"
#import "UGYuebaoTransferLogsModel.h"
#import "UGYuebaoProfitReportModel.h"
#import "UGRechargeLogsModel.h"
#import "UGFundLogsModel.h"
#import "UGWithdrawLogsModel.h"
#import "UGBalanceTransferLogsModel.h"
#import "UGSignInModel.h"
#import "UGSignInHistoryModel.h"
#import "UGMissionModel.h"
#import "UGlevelsModel.h"
#import "UGinviteInfoModel.h"

#import "UGdepositModel.h"
#import "UGapplyWinLogDetail.h"
#import "UGagentApplyInfo.h"
#import "UGgaCaptchaModel.h"


@implementation CMNetwork (Mine)

//游客登录
+ (void)guestLoginWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[guestLoginUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGUserModel.class)
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//图形验证码
+ (void)getImgVcodeWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getImgVcodeUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//手机短信验证码
+ (void)getSmsVcodeWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getSmsVcodeUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//用户登录
+ (void)userLoginWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[userLoginUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGUserModel.class)
                                           post:YES
                                     completion:completionBlock];

    CMMETHOD_END;
    
}

//退出登录
+ (void)userLogoutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[userLogoutUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    CMMETHOD_END;
    
}

//用户注册
+ (void)registerWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[registerUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGUserModel.class)
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//用户账号信息
+ (void)getUserInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[userInfoUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGUserModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;

}

//查询用户等级信息
+ (void)getUserLevelInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[userLoginUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGUserLevelModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//修改登录密码
+ (void)modifyLoginPwdWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[modifyLoginPwdUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(nil)
                                           post:YES
                                     completion:completionBlock];

    CMMETHOD_END;
    
}

//修改取款密码
+ (void)modifyPayPwdWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[modifyFundPwdUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//查询常用登录地点列表
+ (void)getLoginAddressWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getLoginAddressUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGLoginAddressModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//跟新常用登录地点
+ (void)modifyLoginAddressWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[modifyLoginAddressUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//删除常用登录地点
+ (void)delLoginAddressWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[delLoginAddressUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//查询站内消息列表
+ (void)getMessageListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getMsgListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGMessageListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
}

//修改消息状态
+ (void)modifyMessageStateWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[readMsgListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
}

//写站内信
+ (void)writeMessageWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[feedbackUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
    
}

//反馈列表
+ (void)getFeedbackListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getFeedbackListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGMessageListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
    
}

//反馈详情
+ (void)getFeedbackDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getFeedbackDetailUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGMessageListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//查询银行列表
+ (void)getBankListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[bankListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGbankModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//绑定银行卡
+ (void)bindCardWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[bindCardUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//查询银行卡信息
+ (void)getBankCardInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[bankCardInfoUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGCardInfoModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//设置取款密码
+ (void)addFundPwdWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[addFundPwdUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//获取头像列表
+ (void)getAvatarListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getAvatarListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGAvatarModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//修改头像
+ (void)changeAvatarWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[changAvatarListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//额度转换真人列表
+ (void)getRealGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[realGamesUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGPlatformGameModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
}

//手动额度转换
+ (void)manualTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[manualTransferUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
}

//手动额度转换记录
+ (void)transferLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[transferLogsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGBalanceTransferLogsListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;

}

//真人余额查询
+ (void)checkRealBalanceWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[checkRealBalanceUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//利息宝统计查询
+ (void)getYuebaoInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[yuebaoInfoUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGYuebaoInfoModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//利息宝转入转出
+ (void)yuebaoTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[yuebaoTransferUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//利息宝转入转出记录
+ (void)yuebaoTransferLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[yuebaoTransferLogsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGYuebaoTransferLogsListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//利息宝收益报表
+ (void)yuebaoProfitReportWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[yuebaoProfitReportUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGYuebaoProfitReportListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//提款申请
+ (void)withdrawApplytWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[withdrawApplyUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//存款记录
+ (void)rechargeLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[rechargeLogsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGRechargeLogsListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//取款记录
+ (void)withdrawLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[withdrawLogsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGRechargeLogsListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//资金明细
+ (void)fundLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[fundLogsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGFundLogsListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}


//用户签到列表  http://test10.6yc.com/wjapp/api.php?c=task&a=checkinList&token=vAUXLubL0X5LxV0U3wxVAvUl
+ (void)checkinListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[checkinListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGSignInModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//领取连续签到奖励  http://test10.6yc.com/wjapp/api.php?c=task&a=checkinBonus    token type
+ (void)checkinBonusWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[checkinBonusUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//用户签到（签到类型：0是签到，1是补签）http://test10.6yc.com/wjapp/api.php?c=task&a=checkin token type date
+ (void)checkinWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[checkinUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//用户签到历史 http://test10.6yc.com/wjapp/api.php?c=task&a=checkinHistory?token=SNNn1AN33aO3404nlaA33ZXN  token
+ (void)checkinHistoryWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[checkinHistoryUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGSignInHistoryModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//任务大厅 http://test10.6yc.com/wjapp/api.php?c=task&a=center&page=1&rows=20&token=SNNn1AN33aO3404nlaA33ZXN
+ (void)centerWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[centerUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//领取任务 http://test10.6yc.com/wjapp/api.php?c=task&a=get  mid token
+ (void)taskGetWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[taskGetUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//领取奖励 http://test10.6yc.com/wjapp/api.php?c=task&a=reward mid token
+ (void)taskRewardWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[taskRewardUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//积分账变列表 http://test10.6yc.com/wjapp/api.php?c=task&a=creditsLog&page=1 &rows=20 &token=SNNn1AN33aO3404nlaA33ZXN
+ (void)taskCreditsLogWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[taskCreditsLogUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//vip等级 http://test10.6yc.com/wjapp/api.php?c=task&a=levels
+ (void)taskLevelsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[taskLevelsLogUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGlevelsModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//积分兑换 http://test10.6yc.com/wjapp/api.php?c=task&a=creditsExchange token money
+ (void)taskCreditsExchangeWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[taskCreditsExchangeLogUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//推荐信息 http://test10.6yc.com/wjapp/api.php?c=team&a=inviteInfo&token=SNNn1AN33aO3404nlaA33ZXN
+ (void)teamInviteInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamInviteInfoUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGinviteInfoModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//下线信息 http://test10.6yc.com/wjapp/api.php?c=team&a=inviteList&token=2BoZKf4o22q8oKQz8OoDdd3Q
+ (void)teamInviteListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamInviteListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//投注报表信息 http://test10.6yc.com/wjapp/api.php?c=team&a=betStat&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamBetStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamBetStatUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//投注记录信息 http://test10.6yc.com/wjapp/api.php?c=team&a=betList&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamBetListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamBetListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//线下充值信息 http://test10.6yc.com/wjapp/api.php?c=team&a=transfer  token coin uid
+ (void)teamTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamTransferUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//代理域名信息 http://test10.6yc.com/wjapp/api.php?c=team&a=inviteDomain&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamInviteDomainWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamInviteDomainUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//存款报表信息
+ (void)teamDepositStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamDepositStatUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//存款记录信息  http://test10.6yc.com/wjapp/api.php?c=team&a=depositList&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamDepositListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamDepositListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//提款报表信息 http://test10.6yc.com/wjapp/api.php?c=team&a=withdrawStat&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamWithdrawStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamWithdrawStatUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//提款记录信息 http://test10.6yc.com/wjapp/api.php?c=team&a=withdrawList&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamWithdrawListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamWithdrawListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}


//真人报表信息 http://test10.6yc.com/wjapp/api.php?c=team&a=realBetStat&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamRealBetStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamRealBetStatUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}


//真人记录信息 http://test10.6yc.com/wjapp/api.php?c=team&a=realBetList&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamRealBetListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamRealBetListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}


//支付通道列表信息 http://test10.6yc.com/wjapp/api.php?c=recharge&a=cashier&token=U24XC4GL9UAC929UCb0c93AD
+ (void)rechargeCashierWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[rechargeCashierUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGdepositModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//在线支付 http://test10.6yc.com/wjapp/api.php?c=recharge&a=onlinePay
+ (void)rechargeOnlinePayWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[rechargeOnlinePayUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//线下支付 http://test10.6yc.com/wjapp/api.php?c=recharge&a=transfer
+ (void)rechargeTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[rechargeTransferUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//会员申请代理接口 http://test10.6yc.com/wjapp/api.php?c=team&a=agentApply
+ (void)teamAgentApplyWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamAgentApplyUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}


//获取申请活动彩金列表 http://test10.6yc.com/wjapp/api.php?c=activity&a=winApplyList&token=2OMm3aqQ46wX84Axb9o7wb29
+ (void)activityWinApplyListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[activityWinApplyListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}


//获取申请活动彩金记录 http://test10.6yc.com/wjapp/api.php?c=activity&a=applyWinLog&token=2OMm3aqQ46wX84Axb9o7wb29
+ (void)activityApplyWinLogWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[activityApplyWinLogUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//申请彩金 http://test10.6yc.com/wjapp/api.php?c=activity&a=applyWin
+ (void)activityApplyWinWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[activityApplyWinUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//获取申请活动彩金记录详情 http://test10.6yc.com/wjapp/api.php?c=activity&a=applyWinLogDetail&token=6DMCw655Dhu5mB83bVD4McbB&id=120
+ (void)activityApplyWinLogDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[activityApplyWinLogDetailUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGapplyWinLogDetail.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//代理申请信息 http://test10.6yc.com/wjapp/api.php?c=team&a=agentApplyInfo&token=yQxBi4W4B3N65Oa5z55Yy46A
+ (void)teamAgentApplyInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[teamAgentApplyInfoUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGagentApplyInfo.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//个人中心谷歌验证相关操作：(操作方法：gen:二维码生成, bind:绑定, unbind:解绑) http://test10.6yc.com/wjapp/api.php?c=secure&a=gaCaptcha&token=1p3xAJrRzQH8PMeCAo8Rze3X&action=gen
+ (void)secureGaCaptchaWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[secureGaCaptchaUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGgaCaptchaModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}
@end

