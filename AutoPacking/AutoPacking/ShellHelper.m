//
//  ShellHelper.m
//  AutoPacking
//
//  Created by fish on 2019/11/26.
//  Copyright © 2019 fish. All rights reserved.
//

#import "ShellHelper.h"
#import "AFNetworking.h"

#define ShellDir [NSString stringWithFormat:@"%@/AutoPacking/sh", ProjectDir]


@implementation ShellHelper

+ (void)pullCode:(void (^)(void))completion {
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [NSString stringWithFormat:@"%@/1pull.sh", ShellDir];
#ifdef DEBUG
    task.arguments = @[ShellDir,];
#endif
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

+ (void)packing:(NSArray<SiteModel *> *)_sites completion:(void (^)(void))completion {
    NSMutableArray *sites = _sites.mutableCopy;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyyMMdd_HHmm"];
    
    for (SiteModel *sm in sites) {
        sm.retryCnt = 3;
    }
    NSString *commitId = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/CommitId.txt", ProjectDir] encoding:NSUTF8StringEncoding error:nil];
    commitId = [commitId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *dirPath = [NSString stringWithFormat:@"/Library/WebServer/Documents/ipa_%@", commitId ? : [df stringFromDate:[NSDate date]]];
    NSMutableString *errSiteIds = @"".mutableCopy;
    
    __block SiteModel *__sm = nil;
    void (^startPacking)(void) = nil;
    void (^__block __next)(void) = startPacking = ^{
        if (!__sm) {
            __sm = sites.firstObject;
            [sites removeObject:__sm];
        }
        
        
        NSString *ipaPath = [NSString stringWithFormat:@"%@/ug.ipa", ProjectDir];
        NSString *xcarchivePath = [NSString stringWithFormat:@"%@/ug.xcarchive", ProjectDir];
        
        if (!__sm) {
            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[dirPath]];
            if (errSiteIds.length) {
                NSLog(@"所有站点已打包完毕，其中 %@ 站点打包失败，退出打包程序！", errSiteIds);
            } else {
                NSLog(@"所有站点已打包完毕，退出打包程序！");
            }
            if (completion) {
                completion();
            }
            return ;
        }
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = [NSString stringWithFormat:@"%@/2setup.sh", ShellDir];;
        task.arguments = @[__sm.siteId, __sm.appName, __sm.appId, ProjectDir, ];
        task.terminationHandler = ^(NSTask *ts) {
            [ts terminate];
            NSLog(@"%@ 站点信息配置完成，开始打包", __sm.siteId);
            
            BOOL isEnterprise = [__sm.type isEqualToString:@"企业包"] || [__sm.type isEqualToString:@"内测包"];
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = [NSString stringWithFormat:@"%@/3packing.sh", ShellDir];
            task.arguments = @[isEnterprise ? @"1" : @"2", ProjectDir, ];
            task.terminationHandler = ^(NSTask *ts) {
                [ts terminate];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:ipaPath]) {
                    NSString *outputPath1 = [NSString stringWithFormat:@"%@/%@/%@.ipa", dirPath, __sm.type, __sm.siteId];
                    NSString *outputPath2 = [NSString stringWithFormat:@"%@/%@/%@.xcarchive", dirPath, __sm.type, __sm.siteId];
                    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", dirPath, __sm.type] withIntermediateDirectories:true attributes:nil error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:ipaPath toPath:outputPath1 error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:xcarchivePath toPath:outputPath2 error:nil];
                    NSLog(@"%@ 打包成功", __sm.siteId);
                    __sm = nil;
                } else {
                    [errSiteIds appendFormat:@"%@,", __sm.siteId];
                    if (!__sm.retryCnt--) {
                        __sm = nil;
                        NSLog(@"%@ 打包失败", __sm.siteId);
                    } else {
                        NSLog(@"%@ 再试一次打包", __sm.siteId);
                    }
                }
                [ShellHelper pullCode:^{
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

+ (void)upload:(void (^)(void))completion {
    if (completion) {
        completion();
    }
    return;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSLog(@"333");
    static NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress = %@", downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath = %@", targetPath);
        NSLog(@"response = %@", response);
        
        return [NSURL URLWithString:@"/Library/WebServer/Documents/ipa.html"];;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
    }];
    [dataTask resume];
    
    
    // 登录
    
    // 创建APP
    
    // 上传ipa
    
    // 上传plist文件
    
    // 修改app信息
    
    
    if (completion) {
        completion();
    }
}

@end
