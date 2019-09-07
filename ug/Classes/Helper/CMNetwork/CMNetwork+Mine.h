//
//  CMNetwork+Mine.h
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNetwork (Mine)

//游客登录
+ (void)guestLoginWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//图形验证码
+ (void)getImgVcodeWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//手机短信验证码
+ (void)getSmsVcodeWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//用户登录
+ (void)userLoginWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//退出登录
+ (void)userLogoutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//用户注册
+ (void)registerWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//用户账号信息
+ (void)getUserInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询用户等级信息
+ (void)getUserLevelInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//修改登录密码
+ (void)modifyLoginPwdWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//修改取款密码
+ (void)modifyPayPwdWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询常用登录地点列表
+ (void)getLoginAddressWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//更新常用登录地点
+ (void)modifyLoginAddressWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//删除常用登录地点
+ (void)delLoginAddressWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询消息列表
+ (void)getMessageListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//修改消息状态
+ (void)modifyMessageStateWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//写站内信
+ (void)writeMessageWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//反馈列表
+ (void)getFeedbackListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//反馈详情
+ (void)getFeedbackDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询银行列表
+ (void)getBankListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//绑定银行卡
+ (void)bindCardWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询银行卡信息 
+ (void)getBankCardInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//设置取款密码
+ (void)addFundPwdWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取头像列表
+ (void)getAvatarListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//修改头像
+ (void)changeAvatarWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//额度转换真人列表
+ (void)getRealGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//手动额度转换
+ (void)manualTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//手动额度转换记录
+ (void)transferLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//真人余额查询
+ (void)checkRealBalanceWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//利息宝统计查询
+ (void)getYuebaoInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//利息宝转入转出
+ (void)yuebaoTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//利息宝转入转出记录
+ (void)yuebaoTransferLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//利息宝收益报表
+ (void)yuebaoProfitReportWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//提款申请
+ (void)withdrawApplytWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//存款记录
+ (void)rechargeLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//取款记录
+ (void)withdrawLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//资金明细
+ (void)fundLogsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//用户签到列表
+ (void)checkinListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//领取连续签到奖励
+ (void)checkinBonusWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//用户签到（签到类型：0是签到，1是补签）
+ (void)checkinWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//用户签到历史
+ (void)checkinHistoryWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//任务大厅
+ (void)centerWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//领取任务
+ (void)taskGetWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//领取奖励
+ (void)taskRewardWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//积分账变列表
+ (void)taskCreditsLogWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//vip等级
+ (void)taskLevelsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
