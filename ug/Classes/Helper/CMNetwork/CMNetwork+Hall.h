//
//  CMNetwork+Hall.h
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNetwork (Hall)
//自营彩种列表
+ (void)getOwnLotteryList: (NSDictionary *)params completion: (CMNetworkBlock)completionBlock;
//彩票开奖走势
+ (void)getLotteryTrend: (NSDictionary *)params completion: (CMNetworkBlock)completionBlock;
//官方彩票开奖走势
+ (void)getOfficialLotteryTrend: (NSDictionary *)params completion: (CMNetworkBlock)completionBlock;
//获取彩票大厅游戏数据
+ (void)getAllNextIssueWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取彩票游戏数据
+ (void)getGameDatasWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取下一期开奖数据
+ (void)getNextIssueWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//用户投注
+ (void)userBetWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//投注记录
+ (void)getBetsListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//长龙助手
+ (void)getChanglongWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//长龙助手投注记录
+ (void)getChanglongBetListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//取消注单
+ (void)cancelBetWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//彩票开奖记录
+ (void)getLotteryHistoryWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//彩票规则
+ (void)getLotteryRuleWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//游戏中的余额自动转出
+ (void)autoTransferOutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

// 增检查真人游戏是否存在余额未转出
+ (void)needToTransferOutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//彩票注单统计
+ (void)ticketlotteryStatisticsUrlWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock ;

@end

NS_ASSUME_NONNULL_END
