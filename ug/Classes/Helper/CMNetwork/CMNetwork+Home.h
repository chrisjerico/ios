//
//  CMNetwork+Home.h
//  ug
//
//  Created by ug on 2019/6/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNetwork (Home)
//获取系统配置
+ (void)getSystemConfigWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询各平台游戏列表
+ (void)getPlatformGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询各平台下级游戏列表
+ (void)getGameListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取三方游戏路径
+ (void)getGotoGameUrlWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询轮播图
+ (void)getBannerListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询公告列表
+ (void)getNoticeListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询排行榜列表
+ (void)getRankListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//查询优惠活动列表
+ (void)getPromoteListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//检查app版本
+ (void)checkVersionWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
