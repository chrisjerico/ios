//
//  ShellHelper.m
//  AutoPacking
//
//  Created by fish on 2019/11/26.
//  Copyright © 2019 fish. All rights reserved.
//

#import "ShellHelper.h"

@implementation ShellHelper

// 检查配置
+ (void)checkSiteInfo:(NSString *)siteIds {
    NSMutableArray *errs = @[].mutableCopy;
    for (NSString *siteId in [siteIds componentsSeparatedByString:@","]) {
        SiteModel *sm = [SiteModel modelWithId:siteId];
        if (sm) {
            if (!sm.type.length || [sm.type isEqualToString:@"未确定签名方式"]) {
                [errs addObject:[NSString stringWithFormat:@"未确定签名方式, %@", sm.siteId]];
            }
            if (!sm.appName.length) {
                [errs addObject:[NSString stringWithFormat:@"app名称未配置, %@", sm.siteId]];
            }
            if (!sm.appId.length) {
                [errs addObject:[NSString stringWithFormat:@"bundleId未配置, %@", sm.siteId]];
            }
            if (!sm.host.length) {
                [errs addObject:[NSString stringWithFormat:@"接口域名未配置, %@", sm.siteId]];
            }
            if (!sm.uploadId.length) {
                [errs addObject:[NSString stringWithFormat:@"上传ID未配置, %@", sm.siteId]];
            }
            if (!sm.uploadNum.length) {
                [errs addObject:[NSString stringWithFormat:@"上传编号未配置, %@", sm.siteId]];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/AutoPacking/打包文件/各站点AppIcon（拷贝出来使用）/%@", Path.projectDir, sm.siteId]]) {
                [errs addObject:[NSString stringWithFormat:@"app图标未配置, %@", sm.siteId]];
            }
        } else {
            [errs addObject:[NSString stringWithFormat:@"没有此站点，请检查是否拼写错误, %@", siteId]];
        }
    }
    
    NSLog(@"-——————————检查站点配置———————————");
    for (NSString *err in errs) {
        NSLog(@"%@", err);
    }
    if (errs.count) {
        @throw [NSException exceptionWithName:@"缺少已上配置，请配置完成后再打包" reason:@"" userInfo:nil];
        return ;
    }
    NSLog(@"-——————————配置ok-——————————");
}

// rsa加密
+ (void)encrypt:(NSString *)string completion:(void (^)(NSString *ret))completion {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [NSString stringWithFormat:@"%@/0encrypt.sh", Path.shellDir];
    task.arguments = @[string, Path.shellDir,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        
        NSString *ret = [NSString stringWithContentsOfFile:Path.tempCiphertext encoding:NSUTF8StringEncoding error:nil];
        if (completion) {
            completion(ret);
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [task launch];
        [task waitUntilExit];
    });
}

// 拉取最新代码
+ (void)pullCode:(NSString *)path completion:(void (^)(void))completion {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [NSString stringWithFormat:@"%@/1pull.sh", Path.shellDir];
    task.arguments = @[path,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        NSLog(@"拉取完毕");
        if (completion) {
            completion();
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"拉取最新代码...");
        [task launch];
        [task waitUntilExit];
    });
}

// 提交代码
+ (void)pushCode:(NSString *)path completion:(void (^)(void))completion {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [NSString stringWithFormat:@"%@/5push.sh", Path.shellDir];
    task.arguments = @[path,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        NSLog(@"提交完毕");
        if (completion) {
            completion();
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"提交发包日志");
        [task launch];
        [task waitUntilExit];
    });
}

// 批量打包
+ (void)packing:(NSArray<SiteModel *> *)_sites completion:(nonnull void (^)(NSArray<SiteModel *> * _Nonnull))completion {
    NSMutableArray *sites = _sites.mutableCopy;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyyMMdd_HHmm"];
    
    for (SiteModel *sm in sites) {
        sm.retryCnt = 3;
    }
    NSString *commitId = [NSString stringWithContentsOfFile:Path.tempCommitId encoding:NSUTF8StringEncoding error:nil];
    commitId = [commitId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *dirPath = [NSString stringWithFormat:@"%@/ipa_%@", Path.exportDir, commitId ? : [df stringFromDate:[NSDate date]]];
    NSMutableArray *okSites = @[].mutableCopy;
    
    __block SiteModel *__sm = nil;
    void (^startPacking)(void) = nil;
    void (^__block __next)(void) = startPacking = ^{
        if (!__sm) {
            __sm = sites.firstObject;
            [sites removeObject:__sm];
        }
        if (!__sm) {
            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[dirPath]];
            if (okSites.count < _sites.count) {
                NSLog(@"所有站点已打包完毕，其中 %@ 站点打包失败！", [[okSites valueForKey:@"siteId"] componentsJoinedByString:@","]);
            } else {
                NSLog(@"所有站点已打包完毕！");
            }
            if (completion) {
                completion(okSites);
            }
            return ;
        }
        
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = [NSString stringWithFormat:@"%@/2setup.sh", Path.shellDir];;
        task.arguments = @[__sm.siteId, __sm.appName, __sm.appId, Path.projectDir, ];
        task.terminationHandler = ^(NSTask *ts) {
            [ts terminate];
            NSLog(@"%@ 站点信息配置完成，开始打包", __sm.siteId);
            
            BOOL isEnterprise = [@"企业包,内测包" containsString:__sm.type];
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = [NSString stringWithFormat:@"%@/3packing.sh", Path.shellDir];
            task.arguments = @[isEnterprise ? @"2" : @"1", Path.projectDir, ];
            task.terminationHandler = ^(NSTask *ts) {
                [ts terminate];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:Path.tempIpa]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:__sm.ipaPath.stringByDeletingLastPathComponent withIntermediateDirectories:true attributes:nil error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.ipaPath error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.xcarchivePath error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:Path.tempIpa toPath:__sm.ipaPath error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:Path.tempXcarchive toPath:__sm.xcarchivePath error:nil];
                    NSLog(@"%@ 打包成功", __sm.siteId);
                    [okSites addObject:__sm];
                    __sm = nil;
                } else {
                    if (!__sm.retryCnt--) {
                        __sm = nil;
                        NSLog(@"%@ 打包失败", __sm.siteId);
                    } else {
                        NSLog(@"%@ 打包失败，再试一次", __sm.siteId);
                    }
                }
                [ShellHelper pullCode:Path.projectDir completion:^{
                    __next();
                }];
            };
            
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                [task launch];
                [task waitUntilExit];
            });
        };
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            [task launch];
            [task waitUntilExit];
        });
    };
    
    startPacking();
}

// 配置plist文件
+ (void)setupPlist:(SiteModel *)sm ipaUrl:(NSString *)ipaUrl completion:(void (^)(void))completion {
    NSString *logoUrl = _NSString(@"https://app.wdheco.cn/img/%@/%@.png", sm.uploadNum, sm.uploadNum);
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [NSString stringWithFormat:@"%@/4plist.sh", Path.shellDir];
    task.arguments = @[ipaUrl, logoUrl, sm.appId, sm.appName, Path.shellDir,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        if (completion) {
            completion();
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [task launch];
        [task waitUntilExit];
    });
}

@end
