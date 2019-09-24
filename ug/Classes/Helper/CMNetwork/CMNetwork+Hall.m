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

//用户投注
+ (void)userBetWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    NSString *url = nil;
    if ([UGUserModel currentUser].isTest) {
        url = [guestBetUrl stringToRestfulUrlWithFlag:RESTFUL];
    }else if( [[NSString stringWithFormat:@"%@", params[@"gameId"]] isEqualToString:@"7"]){
        url = [userinstantBetUrl stringToRestfulUrlWithFlag:RESTFUL];
	} else {
		url = [userBetUrl stringToRestfulUrlWithFlag:RESTFUL];
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
                                          model:CMResultArrayClassMake(UGLotteryHistoryModel.class)
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

@end
