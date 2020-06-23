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

//查询自定义游戏列表
+(void)getCustomGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

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

//查询优惠图片分类信息
+ (void)getPromotionsTypeWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock ;

//检查app版本
+ (void)checkVersionWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//红包详情 http://test10.6yc.com/wjapp/api.php?c=activity&a=redBagDetail
+ (void)activityRedBagDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//领红包 {{TEST_HOST}}?c=activity&a=getRedBag
+ (void)activityGetRedBagWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//红包日志
+ (void)chatRedBagLogPageWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//APP在线人数 http://test10.6yc.com/wjapp/api.php?c=system&a=onlineCount
+ (void)systemOnlineCountWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//首页广告图片 http://test100f.fhptcdn.com/wjapp/api.php?c=system&a=homeAds
+ (void)systemhomeAdsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//首页左右浮窗  {TEST_HOST}}?c=system&a=floatAds&token={{TOKEN}
+ (void)systemfloatAdsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//大转盘活动数据 {TEST_HOST}}?c=activity&a=turntableList&token=F9YhrIONRI8jrSbKFNiJrFBo
+ (void)activityTurntableListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//获取大转盘该用户当天抽奖日志（最新10条） {TEST_HOST}}?c=activity&a=turntableLog&token=F9YhrIONRI8jrSbKFNiJrFBo&activityId=13
//方式：GET
//参数 token
//     activityId 活动id
+ (void)activityTurntableLogWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;
//抽奖接口： http://test28f.fhptcdn.com//wjapp/api.php?c=activity&a=turntableWin
//方式：POST
//参数 token
//     activityId 活动id
+ (void)activityTurntableWinWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

//侧边栏数据 {TEST_HOST}}?c=system&a=mobileRight
+ (void)systemMobileRightWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
