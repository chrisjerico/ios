//
//  CMNetwork+LH.m
//  ug
//
//  Created by ug on 2019/11/26.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork+LH.h"
#import "UGLHLhlModel.h"
#import "UGLHCategoryListModel.h"
#import "UGLHlotteryNumberModel.h"
@implementation CMNetwork (LH)

//老黄历
+ (void)lhlDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[lhlDetailUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGLHLhlModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
    
}

//栏目列表
+ (void)categoryListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[categoryListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultArrayClassMake(UGLHCategoryListModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//当前开奖信息
+ (void)lotteryNumberWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[lotteryNumberUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(UGLHlotteryNumberModel.class)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}
@end
