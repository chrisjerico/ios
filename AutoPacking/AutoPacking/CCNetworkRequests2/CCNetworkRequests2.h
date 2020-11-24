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

// 提交审核
- (CCSessionModel *)submitReview:(SiteModel *)site plistPath:(NSString *)plistPath ver:(NSString *)ver isForce:(BOOL)isForce log:(NSString *)log;


#pragma mark - 高权限操作

// 修改审核状态
- (CCSessionModel *)changeReviewStatus:(SiteModel *)site reviewed:(BOOL)reviewed;

// 修改强制更新信息
- (CCSessionModel *)changeForceUpdateInfo:(SiteModel *)site forceVer:(NSString *)forceVer isForce:(BOOL)isForce log:(nullable NSString *)log;

// 上传图片
- (CCSessionModel *)uploadImage:(NSString *)base64;

@end

NS_ASSUME_NONNULL_END
