//
//  CCNetworkRequests2.h
//  AutoPacking
//
//  Created by fish on 2019/12/4.
//  Copyright © 2019 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSessionModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SiteModel;

#define NetworkManager1 [CCNetworkRequests2 sharedManager]


@interface CCNetworkRequests2 : NSObject

+ (instancetype)sharedManager;

// 登录
- (CCSessionModel *)login;

// 上传文件
- (CCSessionModel *)uploadWithId:(NSString *)_id sid:(NSString *)sid file:(NSString *)file;

// 获取APP信息
- (CCSessionModel *)getInfo:(NSString *)_id;

// 修改APP信息
- (CCSessionModel *)editInfo:(SiteModel *)site plistUrl:(NSString *)plistUrl;

@end

NS_ASSUME_NONNULL_END
