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

//查询各平台游戏列表
+ (void)getPlatformGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getPlatformGamesUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGPlatformModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//查询自定义游戏列表
+(void)getCustomGamesWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
	
	CMMETHOD_BEGIN;
	
	[self.manager requestInMainThreadWithMethod:[getCustomGamesUrl stringToRestfulUrlWithFlag:RESTFUL]
										 params:params
										  model:CMResultArrayClassMake(UGPlatformModel.class)
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
                                          model:CMResultArrayClassMake(UGBannerModel.class)
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

//查询优惠活动列表
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
                                          model:CMResultClassMake(UGRedEnvelopeModel.class)
                                           post:YES
                                     completion:completionBlock];
    
    CMMETHOD_END;
}
@end
