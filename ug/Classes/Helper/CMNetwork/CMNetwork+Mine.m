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
@end
