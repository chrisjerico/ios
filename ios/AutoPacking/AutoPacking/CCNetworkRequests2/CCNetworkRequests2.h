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
- (CCSessionModel *)login:(NSString *)user pwd:(NSString *)pwd;

// 上传文件
- (CCSessionModel *)uploadWithId:(NSString *)_id sid:(NSString *)sid file:(NSString *)file;

// 获取APP信息
- (CCSessionModel *)getInfo:(NSString *)_id;

// 修改APP信息
- (CCSessionModel *)editInfo:(SiteModel *)site plistPath:(NSString *)plistPath;

// 提交热更新版本信息
- (CCSessionModel *)addHotUpdateVersion:(NSString *)version log:(NSString *)log url:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
