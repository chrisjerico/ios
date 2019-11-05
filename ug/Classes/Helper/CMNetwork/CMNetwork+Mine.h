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

// 额度一键转出，第一步：获取需要转出的真人ID
+ (void)oneKeyTransferOutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

// 额度一键转出，第二步：根据真人ID并发请求单游戏快速转出
+ (void)quickTransferOutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

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

//积分兑换
+ (void)taskCreditsExchangeWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//推荐信息
+ (void)teamInviteInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//下线信息==会员管理
+ (void)teamInviteListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//投注报表信息
+ (void)teamBetStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//投注记录信息
+ (void)teamBetListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//线下充值信息
+ (void)teamTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//代理域名信息
+ (void)teamInviteDomainWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//存款报表信息
+ (void)teamDepositStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//存款记录信息
+ (void)teamDepositListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//提款报表信息 http://test10.6yc.com/wjapp/api.php?c=team&a=withdrawStat&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamWithdrawStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//提款记录信息 http://test10.6yc.com/wjapp/api.php?c=team&a=withdrawList&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamWithdrawListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//真人报表信息 http://test10.6yc.com/wjapp/api.php?c=team&a=realBetStat&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamRealBetStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//真人记录信息 http://test10.6yc.com/wjapp/api.php?c=team&a=realBetList&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
+ (void)teamRealBetListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//支付通道列表信息 http://test10.6yc.com/wjapp/api.php?c=recharge&a=cashier&token=U24XC4GL9UAC929UCb0c93AD
+ (void)rechargeCashierWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//在线支付 http://test10.6yc.com/wjapp/api.php?c=recharge&a=onlinePay
+ (void)rechargeOnlinePayWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//线下支付 http://test10.6yc.com/wjapp/api.php?c=recharge&a=transfer
+ (void)rechargeTransferWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//会员申请代理接口 http://test10.6yc.com/wjapp/api.php?c=team&a=agentApply
+ (void)teamAgentApplyWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取申请活动彩金列表 http://test10.6yc.com/wjapp/api.php?c=activity&a=winApplyList&token=2OMm3aqQ46wX84Axb9o7wb29
+ (void)activityWinApplyListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取申请活动彩金记录 http://test10.6yc.com/wjapp/api.php?c=activity&a=applyWinLog&token=2OMm3aqQ46wX84Axb9o7wb29
+ (void)activityApplyWinLogWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//申请彩金 http://test10.6yc.com/wjapp/api.php?c=activity&a=applyWin
+ (void)activityApplyWinWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取申请活动彩金记录详情 http://test10.6yc.com/wjapp/api.php?c=activity&a=applyWinLogDetail&token=6DMCw655Dhu5mB83bVD4McbB&id=120
+ (void)activityApplyWinLogDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//代理申请信息 http://test10.6yc.com/wjapp/api.php?c=team&a=agentApplyInfo&token=yQxBi4W4B3N65Oa5z55Yy46A
+ (void)teamAgentApplyInfoWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//个人中心谷歌验证相关操作：(操作方法：gen:二维码生成, bind:绑定, unbind:解绑) http://test10.6yc.com/wjapp/api.php?c=secure&a=gaCaptcha&token=1p3xAJrRzQH8PMeCAo8Rze3X&action=gen
+ (void)secureGaCaptchaWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;
@end

NS_ASSUME_NONNULL_END

