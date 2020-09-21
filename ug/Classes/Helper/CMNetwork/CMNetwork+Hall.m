//
//  CMNetwork+Hall.m
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork+Hall.h"
#import "UGAllNextIssueListModel.h"
#import "UGGameplayModel.h"
#import "UGBetsRecordListModel.h"
#import "UGLotteryHistoryModel.h"
#import "UGChanglongaideModel.h"
#import "UGChanglongBetRecordModel.h"
#import "UGBetDetailModel.h"
@implementation CMNetwork (Hall)
//自营彩种列表
+ (void)getOwnLotteryList: (NSDictionary *)params completion: (CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
     
     [self.manager requestInMainThreadWithMethod:[ownLotteryListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                          params:params
                                           model:nil
                                            post:NO
                                      completion:completionBlock];
     
     CMMETHOD_END;
}
//彩票开奖走势
+ (void)getLotteryTrend: (NSDictionary *)params completion: (CMNetworkBlock)completionBlock {
	CMMETHOD_BEGIN;
	 
	 [self.manager requestInMainThreadWithMethod:[lotteryTrendUrl stringToRestfulUrlWithFlag:RESTFUL]
										  params:params
										   model:nil
											post:NO
									  completion:completionBlock];
	 
	 CMMETHOD_END;
}
//官方彩票开奖走势
+ (void)getOfficialLotteryTrend: (NSDictionary *)params completion: (CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
     
     [self.manager requestInMainThreadWithMethod:[officialLotteryTrendUrl stringToRestfulUrlWithFlag:RESTFUL]
                                          params:params
                                           model:nil
                                            post:NO
                                      completion:completionBlock];
     
     CMMETHOD_END;
}

//获取彩票大厅数据
+ (void)getAllNextIssueWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getAllNextIssue stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGAllNextIssueListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
}

//获取彩票游戏数据
+ (void)getGameDatasWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getGameDataUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGPlayOddsModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    CMMETHOD_END;
    
}

//获取下一期开奖数据
+ (void)getNextIssueWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getNextIssueUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGNextIssueModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//用户投注  新增傳入字段 activeReturnCoinRatio   傳入格式 string    列 : 拉條值為 4.5% , 則傳入 4.5
+ (void)userBetWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    NSString *url = nil;
    
    if([UGUserModel currentUser].isTest) {
        
        NSNumber *isInstant = params[@"isInstant"];
        BOOL isInstantBool = [isInstant boolValue];
        if (isInstantBool) {
            url = [userinstantBetUrl stringToRestfulUrlWithFlag:RESTFUL];
        } else {
            url = [guestBetUrl stringToRestfulUrlWithFlag:RESTFUL];
        }
        
    } else {
        
        NSNumber *isInstant = params[@"isInstant"];
        BOOL isInstantBool = [isInstant boolValue];
        if (isInstantBool) {
            url = [userinstantBetUrl stringToRestfulUrlWithFlag:RESTFUL];
        } else {
            url = [userBetUrl stringToRestfulUrlWithFlag:RESTFUL];
        }
        
    }
    [self.manager requestInMainThreadWithMethod:url
                                         params:params
                                          model:CMResultClassMake([UGBetDetailModel class])
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//投注记录
+ (void)getBetsListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getBetsListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGBetsRecordListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
}

//长龙助手
+ (void)getChanglongWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[changlongUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGChanglongaideModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//长龙助手投注记录
+ (void)getChanglongBetListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[changlongBetListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGChanglongBetRecordModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//取消注单
+ (void)cancelBetWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[cancelBetUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(nil)
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//彩票开奖记录
+ (void)getLotteryHistoryWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getLotteryHistoryUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params

                                          model:CMResultClassMake(UGLotteryHistoryListModel.class)

                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
    
}

//彩票规则
+ (void)getLotteryRuleWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[getLotteryRuleUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//游戏中的余额自动转出
+ (void)autoTransferOutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[autoTransferOutUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:nil
                                           post:YES
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

// 增检查真人游戏是否存在余额未转出
+ (void)needToTransferOutWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    [self.manager requestInMainThreadWithMethod:[needToTransferOutUrl stringToRestfulUrlWithFlag:RESTFUL]
        params:params
         model:nil
          post:false
    completion:completionBlock];
}


//彩票注单统计
+ (void)ticketlotteryStatisticsUrlWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[ticketlotteryStatisticsUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGBetsRecordListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}
    
// 获得最后一次莫彩种的下注信息  请求参数 ： id  必填（int）
+ (void)ticketgetLotteryFirstOrderWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[ticketgetLotteryFirstOrderUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGNextIssueModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}
@end
