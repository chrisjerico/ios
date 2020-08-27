//
//  CMNetwork+Home.m
//  ug
//
//  Created by ug on 2019/6/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork+Home.h"
#import "UGPlatformGameModel.h"
#import "UGBannerModel.h"
#import "UGNoticeModel.h"
#import "UGRankModel.h"
#import "UGPromoteModel.h"
#import "UGSystemConfigModel.h"
#import "UGAPPVersionModel.h"
#import "UGRedEnvelopeModel.h"
#import "GameCategoryDataModel.h"
#import "UGonlineCount.h"
#import "UGYYPlatformGames.h"
#import "UGhomeAdsModel.h"
#import "RedBagLogModel.h"
#import "UGNoticeTypeModel.h"
#import "UGBetsRecordListModel.h"
@implementation CMNetwork (Home)

//获取系统配置
+ (void)getSystemConfigWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[systemConfigUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGSystemConfigModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//查询彩票大厅
+ (void)getPlatformGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getPlatformGamesUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGYYPlatformGames.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//查询自定义游戏列表
+(void)getCustomGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
	
	CMMETHOD_BEGIN;
	
	[self.manager requestInMainThreadWithMethod:[getCustomGamesUrl stringToRestfulUrlWithFlag:RESTFUL]
										 params:params
										  model:CMResultClassMake(GameCategoryDataModel.class)
										   post:NO
									 completion:completionBlock];
	
	
	CMMETHOD_END;
	
}

//查询各平台下级游戏列表
+ (void)getGameListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getGamelistUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGSubGameModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
}

//获取三方游戏路径
+ (void)getGotoGameUrlWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[gotoGameUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(nil)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
}

//查询轮播图
+ (void)getBannerListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getBannerListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGBannerModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//查询公告列表
+ (void)getNoticeListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getNoticeListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGNoticeTypeModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//查询排行榜列表
+ (void)getRankListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getRankListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGRankListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//查询优惠活动列表 typeid
+ (void)getPromoteListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getPromoteListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGPromoteListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//检查app版本
+ (void)checkVersionWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[checkVersionUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGAPPVersionModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
    
}


//红包详情 http://test10.6yc.com/wjapp/api.php?c=activity&a=redBagDetail
+ (void)activityRedBagDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[activityRedBagDetailUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGRedEnvelopeModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
    
}
//领红包 {{TEST_HOST}}?c=activity&a=getRedBag
+ (void)activityGetRedBagWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[activityGetRedBagUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    CMMETHOD_END;
}

//红包日志
//HTTP请求方式：POST
//
//请求参数：
//
//| 参数      | 必选  | 类型      | 说明                                                         |
//| --------- | ----- | --------- | ------------------------------------------------------------ |
//| token     | true  | string    | 授权TOKEN                                                    |
//| type      | true  | int       | 类型 1 = 普通紅包, 2 = 掃雷紅包                              |
//| page      | false | int       | 分页页码                                                     |
//| rows      | false | int       | 每页条数                                                     |
//| startTime | false | timeStamp | 开始时间                                                     |
//| endTime   | false | timeStamp | 结束时间                                                     |
//| operate   | false | int       | 操作类型1-发送红包，2-抢红包，3-过期退回，4-踩雷赔付，5-获得赔付，6-幸运奖励，7-多雷奖励 |
+ (void)chatRedBagLogPageWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[chatRedBagLogPageUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//APP在线人数 http://test10.6yc.com/wjapp/api.php?c=system&a=onlineCount
+ (void)systemOnlineCountWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[systemOnlineCountUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGonlineCount.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
}

//首页广告图片 http://test100f.fhptcdn.com/wjapp/api.php?c=system&a=homeAds
+ (void)systemhomeAdsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[systemhomeAdsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGhomeAdsModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
}

//首页左右浮窗  {TEST_HOST}}?c=system&a=floatAds&token={{TOKEN}
+ (void)systemfloatAdsWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;
{
    CMMETHOD_BEGIN;
       
       [self.manager requestInMainThreadWithMethod:[systemfloatAdsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                            params:params
                                             model:CMResultArrayClassMake(UGhomeAdsModel.class)
                                              post:NO
                                        completion:completionBlock];
       
       CMMETHOD_END;
}


//大转盘活动数据 {TEST_HOST}}?c=activity&a=turntableList&token=F9YhrIONRI8jrSbKFNiJrFBo
+ (void)activityTurntableListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock
{
    CMMETHOD_BEGIN;
       
       [self.manager requestInMainThreadWithMethod:[activityTurntableListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                            params:params
                                             model:nil
                                              post:NO
                                        completion:completionBlock];
       
       CMMETHOD_END;
}

//获取大转盘该用户当天抽奖日志（最新10条） {TEST_HOST}}?c=activity&a=turntableLog&token=F9YhrIONRI8jrSbKFNiJrFBo&activityId=13
//方式：GET
//参数 token
//     activityId 活动id
+ (void)activityTurntableLogWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock
{
    CMMETHOD_BEGIN;
       
       [self.manager requestInMainThreadWithMethod:[activityTurntableLogUrl stringToRestfulUrlWithFlag:RESTFUL]
                                            params:params
                                             model:nil
                                              post:NO
                                        completion:completionBlock];
       
       CMMETHOD_END;
}
//抽奖接口： http://test28f.fhptcdn.com//wjapp/api.php?c=activity&a=turntableWin
//方式：POST
//参数 token
//     activityId 活动id
+ (void)activityTurntableWinWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[activityTurntableWinUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}


//下注明细：
//方式：POST
//参数 token + date UGBetsRecordModel
+ (void)userLotteryDayStatWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
     [self.manager requestInMainThreadWithMethod:[userLotteryDayStatUrl stringToRestfulUrlWithFlag:RESTFUL]
                                          params:params
                                           model:nil
                                            post:YES
                                      completion:completionBlock];
     CMMETHOD_END;
}


//侧边栏数据 {TEST_HOST}}?c=system&a=mobileRight
+ (void)systemMobileRightWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    [self.manager requestInMainThreadWithMethod:[systemMobileRightUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(GameModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}
@end
