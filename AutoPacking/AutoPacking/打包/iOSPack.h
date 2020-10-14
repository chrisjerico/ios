//
//  iOSPack.h
//  AutoPacking
//
//  Created by fish on 2020/6/25.
//  Copyright © 2020 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitModel.h"
#import "SiteModel.h"


#define iPack [iOSPack shared]

NS_ASSUME_NONNULL_BEGIN

@interface iOSPack : NSObject

@property (nonatomic, readonly) NSString *projectDir;   /**<   ios项目目录 */

+ (instancetype)shared;
- (void)setupPlist:(NSDictionary *)dict;    /**<   初始化 */
- (void)pullCode:(NSString *)branch completion:(void (^)(NSString *version))completion;
- (void)startPackingWithIds:(NSString *)ids ver:(NSString *)ver willUpload:(BOOL)willUpload isForce:(BOOL)isForce log:(NSString *)log isReview:(BOOL)isReview;    /**<   打包、上传 */
- (void)changeForceUpdateInfo:(NSString *)ids isForce:(BOOL)isForce log:(NSString *)log;    /**<   修改强制更新信息 */
@end





// 原生iOS导出路径
@interface SiteModel (Helper)
@property (nonatomic, readonly) NSString *ipaPath;
@property (nonatomic, readonly) NSString *plistPath;
@property (nonatomic, readonly) NSString *xcarchivePath;
@property (nonatomic, readonly) NSString *logPath;

@property (nonatomic, copy) NSString *siteUrl;/**<   站点链接（上传接口使用） */
@end
NS_ASSUME_NONNULL_END
