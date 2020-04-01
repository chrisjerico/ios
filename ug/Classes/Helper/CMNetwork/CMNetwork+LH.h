//
//  CMNetwork+LH.h
//  ug
//
//  Created by ug on 2019/11/26.
//  Copyright © 2019 ug. All rights reserved.
//


#import "CMNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNetwork (LH)

//老黄历
+ (void)lhlDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//栏目列表
+ (void)categoryListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//当前开奖信息
+ (void)lotteryNumberWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//我的历史帖子
+ (void)historyContentWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//关注用户列表
+ (void)followListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//关注帖子列表
+ (void)favContentListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
