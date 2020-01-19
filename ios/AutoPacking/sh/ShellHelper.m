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
            if (!sm.uploadNum.length) {
                [errs addObject:[NSString stringWithFormat:@"上传编号未配置, %@", sm.siteId]];
            }
            if (!sm.uploadId.length) {
                [errs addObject:[NSString stringWithFormat:@"上传ID未配置, %@", sm.siteId]];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/AutoPacking/打包文件/各站点AppIcon（拷贝出来使用）/%@", Path.projectDir, sm.siteId]]) {
                [errs addObject:[NSString stringWithFormat:@"app图标未配置, %@", sm.siteId]];
            }
        } else {
            [errs addObject:[NSString stringWithFormat:@"没有此站点，请检查是否拼写错误, %@", siteId]];
        }
    }
    NSLog(@"Path.tempPlist= %@",Path.tempPlist);
    if (![[NSFileManager defaultManager] fileExistsAtPath:Path.tempPlist]) {
        [errs addObject:_NSString(@"找不到plist模板，请在此路径放置一个plist模板：%@", Path.tempPlist)];
    }
    if (![[NSString stringWithContentsOfFile:_NSString(@"%@/ug/Classes/Other/configuration.h", Path.projectDir) encoding:NSUTF8StringEncoding error:nil] containsString:@"#define checkSign 1"]) {
        [errs addObject:@"未开启参数加密，请到 configuration.h 文件开启参数加密"];
    }
    
    NSLog(@"\n\n");
    NSLog(@"-——————————检查站点配置———————————\n\n");
    for (NSString *err in errs) {
        NSLog(@"%@", err);
    }
    if (errs.count) {
        NSLog(@"\n\n");
        @throw [NSException exceptionWithName:@"缺少已上配置，请配置完成后再打包" reason:@"" userInfo:nil];
        return ;
    }
    NSLog(@"-——————————配置ok-——————————");
}

// rsa加密
+ (void)encrypt:(NSArray<NSString *> *)stringArray completion:(void (^)(NSArray<NSString *> * _Nonnull))completion {
    // 遍历加密字符串列表
    NSMutableArray *temp = stringArray.mutableCopy;
    NSMutableArray *okStrings = @[].mutableCopy;
    __block NSString *__orString = nil;
    void (^startEncrypt)(void) = nil;
    void (^__block __next)(void) = startEncrypt = ^{
        if (!__orString) {
            __orString = temp.firstObject;
            [temp removeObject:__orString];
        }
        if (!__orString) {
            //            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[Path.exportDir]];
            NSLog(@"所有字符串已加密完毕！");
            if (completion) {
                completion(okStrings);
            }
            return ;
        }
        
        NSMutableArray *substrings = ({
            substrings = @[].mutableCopy;
            NSUInteger loc = 0;
            NSUInteger len = 300;    // 分段加密长度（最大只能300多一点）
            while (loc + len <= __orString.length) {
                [substrings addObject:[__orString substringWithRange:NSMakeRange(loc, len)]];
                loc += len;
            }
            substrings;
        });
        
        // 分段加密，每段之间用\n隔开（因为rsa无法加密太长的字符串）
        [self encryptSubstrins:substrings completion:^(NSArray<NSString *> *rets) {
            [okStrings addObject:[rets componentsJoinedByString:@"\n"]];
            __orString = nil;
            __next();
        }];
    };
    
    startEncrypt();
}

// rsa加密
+ (void)encryptSubstrins:(NSArray<NSString *> *)substrings completion:(void (^)(NSArray<NSString *> * _Nonnull))completion {
    // 遍历加密字符串列表
    NSMutableArray *temp = substrings.mutableCopy;
    NSMutableArray *okStrings = @[].mutableCopy;
    __block NSString *__orString = nil;
    void (^startEncrypt)(void) = nil;
    void (^__block __next)(void) = startEncrypt = ^{
        if (!__orString) {
            __orString = temp.firstObject;
            [temp removeObject:__orString];
        }
        if (!__orString) {
            //            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[Path.exportDir]];
            NSLog(@"字符串加密完成！");
            if (completion) {
                completion(okStrings);
            }
            return ;
        }
        [[NSFileManager defaultManager] removeItemAtPath:Path.tempCiphertext error:nil];
        
        [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"0encrypt" ofType:@"sh"] arguments:@[__orString, Path.privateKey, Path.shellDir,] completion:^(NSTask * _Nonnull ts) {
            NSString *ret = [NSString stringWithContentsOfFile:Path.tempCiphertext encoding:NSUTF8StringEncoding error:nil];
            if (!ret.length) {
                @throw [NSException exceptionWithName:@"js分段加密为空。" reason:@"" userInfo:nil];
            }
            [okStrings addObject:ret];
            __orString = nil;
            __next();
        }];
    };
    
    startEncrypt();
}



+ (void)clean:(NSString *)path completion:(void (^)(void))completion {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [[NSBundle mainBundle] pathForResource:@"6clean" ofType:@"sh"];
    task.arguments = @[path,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        NSLog(@"清空完毕.");
        if (completion) {
            completion();
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"清空所有改动...");
        [task launch];
        [task waitUntilExit];
    });
}

// 拉取最新代码
+ (void)pullCode:(NSString *)path completion:(void (^)(void))completion {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [[NSBundle mainBundle] pathForResource:@"1pull" ofType:@"sh"];
    task.arguments = @[path,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_NSString(@"%@/CommitId.txt", path)]) {
            @throw [NSException exceptionWithName:@"拉取代码失败，请手动更新代码。" reason:@"" userInfo:nil];
            return ;
        }
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
+ (void)pushCode:(NSString *)path title:(NSString *)title completion:(void (^)(void))completion {
    if (!title.length) {
        title = @"发包";
    }
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [[NSBundle mainBundle] pathForResource:@"5push" ofType:@"sh"];
    task.arguments = @[title, path,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        NSLog(@"提交完毕");
        if (completion) {
            completion();
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"提交发包记录");
        [task launch];
        [task waitUntilExit];
    });
}

// 批量打包
+ (void)packing:(NSArray<SiteModel *> *)_sites completion:(nonnull void (^)(NSArray<SiteModel *> * _Nonnull))completion {
    NSMutableArray *sites = _sites.mutableCopy;
    NSMutableArray *okSites = @[].mutableCopy;
    for (SiteModel *sm in sites) {
        sm.retryCnt = 3;
    };
    
    __block SiteModel *__sm = nil;
    void (^startPacking)(void) = nil;
    void (^__block __next)(void) = startPacking = ^{
        if (!__sm) {
            __sm = sites.firstObject;
            [sites removeObject:__sm];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:__sm.xcarchivePath]) {
                NSLog(@"已存在 %@ 安装包，无需再次打包", __sm.siteId);
                [okSites addObject:__sm];
                __sm = nil;
                __next();
                return;
            }
        }
        if (!__sm) {
//            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[Path.exportDir]];
            if (okSites.count < _sites.count) {
                NSMutableArray *errs = [_sites mutableCopy];
                [errs removeObjectsInArray:okSites];
                NSLog(@"所有站点已打包完毕，其中 %@ 站点打包失败！", [[errs valueForKey:@"siteId"] componentsJoinedByString:@","]);
            } else {
                NSLog(@"所有站点已打包完毕！");
            }
            if (completion) {
                completion(okSites);
            }
            return ;
        }
        
        NSLog(@"Path.projectDir = %@",Path.projectDir);
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = [[NSBundle mainBundle] pathForResource:@"2setup" ofType:@"sh"];;
        task.arguments = @[__sm.siteId, __sm.appName, APPVersion, __sm.appId, Path.projectDir, ];
        task.terminationHandler = ^(NSTask *ts) {
            [ts terminate];
            NSLog(@"%@ 站点信息配置完成，开始打包", __sm.siteId);
            NSLog(@"%@ ", __sm.type);
            BOOL isEnterprise = [@"企业包,内测包" containsString:__sm.type];
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = [[NSBundle mainBundle] pathForResource:@"3packing" ofType:@"sh"];
            task.arguments = @[isEnterprise ? @"2" : @"1", Path.projectDir, ];
            task.terminationHandler = ^(NSTask *ts) {
                [ts terminate];
                NSLog(@"Path.tempIpa = %@",Path.tempIpa);
                NSLog(@"Path.tempXcarchive = %@",Path.tempXcarchive);
                NSLog(@"__sm.ipaPath = %@",__sm.ipaPath);
                NSLog(@"Path.exportDir = %@,Path.commitId= %@",Path.ipaExportDir,Path.commitId);
                if ([[NSFileManager defaultManager] fileExistsAtPath:Path.tempIpa]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:__sm.ipaPath.stringByDeletingLastPathComponent withIntermediateDirectories:true attributes:nil error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.ipaPath error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.xcarchivePath error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:Path.tempIpa toPath:__sm.ipaPath error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:Path.tempXcarchive toPath:__sm.xcarchivePath error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:_NSString(@"%@/PullSuccess.txt", Path.projectDir) toPath:_NSString(@"%@/%@/log.txt", Path.ipaExportDir, Path.commitId) error:nil];
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
                [ShellHelper clean:Path.projectDir completion:^{
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
    task.launchPath = [[NSBundle mainBundle] pathForResource:@"4plist" ofType:@"sh"];
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
