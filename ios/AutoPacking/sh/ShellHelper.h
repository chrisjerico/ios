//
//  ShellHelper.h
//  AutoPacking
//
//  Created by fish on 2019/11/26.
//  Copyright © 2019 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShellHelper : NSObject

// 检查站点配置
+ (void)checkSiteInfo:(NSString *)siteIds;

// rsa加密
+ (void)encrypt:(NSArray <NSString *>*)stringArray completion:(void (^)(NSArray <NSString *>*rets))completion;

// 清空所有改动
+ (void)clean:(NSString *)path completion:(void (^)(void))completion;

// 拉取最新代码
+ (void)pullCode:(NSString *)path completion:(void (^)(void))completion;

// 提交代码
+ (void)pushCode:(NSString *)path title:(NSString *)title completion:(void (^)(void))completion;

// 批量打包
+ (void)packing:(NSArray <SiteModel *> *)sites completion:(void (^)(NSArray <SiteModel *>*okSites))completion;

// 配置plist文件
+ (void)setupPlist:(SiteModel *)sm ipaUrl:(NSString *)ipaUrl completion:(void (^)(void))completion;


@end

NS_ASSUME_NONNULL_END
