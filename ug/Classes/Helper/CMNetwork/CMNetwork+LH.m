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

//我的历史帖子
//请求参数：
//cateId：栏目ID
//page：分页页码，非必填
//rows：分页条数，非必填
//token：用户TOKEN
+ (void)historyContentWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[historyContentUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(nil)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//关注用户列表
//请求参数：
//uid：选填，为空时，查询当前登录用户的关注列表；否则查询指定用户的
//token：用户TOKEN
+ (void)followListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    CMMETHOD_BEGIN;
    
    [self.manager requestInMainThreadWithMethod:[followListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(nil)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}

//关注帖子列表
//请求参数：
//page：分页页码，非必填
//rows：分页条数，非必填
//uid：选填，为空时，查询当前登录用户的；否则查询指定用户的
//token：用户TOKEN
+ (void)favContentListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock{
    [self.manager requestInMainThreadWithMethod:[favContentListUrl stringToRestfulUrlWithFlag:RESTFUL]
                                         params:params
                                          model:CMResultClassMake(nil)
                                           post:NO
                                     completion:completionBlock];
    
    
    CMMETHOD_END;
}
@end
