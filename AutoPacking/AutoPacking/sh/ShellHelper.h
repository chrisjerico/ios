//
//  ShellHelper.h
//  AutoPacking
//
//  Created by fish on 2019/11/26.
//  Copyright © 2019 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShellHelper : NSObject

// rsa加密
+ (void)encrypt:(NSArray <NSString *>*)stringArray privateKey:(NSString *)privateKey completion:(void (^)(NSArray <NSString *>*rets))completion;

// 清空所有改动
+ (void)clean:(NSString *)projectPath completion:(void (^)(void))completion;

// 拉取最新代码
+ (void)pullCode:(NSString *)projectPath branch:(NSString *)branch completion:(void (^)(GitModel *gm))completion;

// 提交代码
+ (void)pushCode:(NSString *)projectPath title:(NSString *)title completion:(void (^)(void))completion;

// 批量打包
+ (void)iosPacking:(NSString *)projectPath sites:(NSArray <SiteModel *> *)sites version:(NSString *)version completion:(void (^)(NSArray <SiteModel *>*okSites))completion;

// 配置plist文件
+ (void)setupPlist:(NSString *)plistFile sm:(SiteModel *)sm ipaUrl:(NSString *)ipaUrl completion:(void (^)(void))completion;


@end

NS_ASSUME_NONNULL_END
