//
//  AutoPackingVC.m
//  AutoPacking
//
//  Created by fish on 2019/12/3.
//  Copyright © 2019 fish. All rights reserved.
//

#import "AutoPackingVC.h"
#import "ShellHelper.h"

@implementation AutoPackingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weakSelf_(__self);
    
    NSString *ids = @"test10";
    
    // 拉取最新代码
    [ShellHelper pullCode:Path.projectDir completion:^{
        Path.commitId = [[NSString stringWithContentsOfFile:Path.tempCommitId encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // 检查配置
        [ShellHelper checkSiteInfo:ids];
        
        // 批量打包
        NSArray *sms = [SiteModel sites:ids];
        [ShellHelper packing:sms completion:^(NSArray<SiteModel *> *okSites) {
            
            // 登录
            [NetworkManager1 login].completionBlock = ^(CCSessionModel *sm) {
                if (!sm.error) {
                    NSLog(@"登录成功，%@", sm.responseObject);
                    [[NSUserDefaults standardUserDefaults] setObject:sm.responseObject[@"data"][@"loginsessid"] forKey:@"loginsessid"];
                    [[NSUserDefaults standardUserDefaults] setObject:sm.responseObject[@"data"][@"logintoken"] forKey:@"logintoken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // 批量上传
                    [__self upload:okSites completion:^(NSArray<SiteModel *> *okSites) {
                        NSLog(@"退出打包程序");
                        exit(0);
                    }];
                } else {
                    NSLog(@"登录失败，%@", sm.error);
                }
            };
        }];
    }];
}

- (void)upload:(NSArray <SiteModel *>*)_sites completion:(void (^)(NSArray <SiteModel *>*okSites))completion {
    NSMutableArray *sites = _sites.mutableCopy;
    NSMutableArray *okSites = @[].mutableCopy;
    __weakSelf_(__self);
    __block SiteModel *__sm = nil;
    
    void (^__block __next)(void) = nil;
    void (^uploadPlist)(void) = ^{
        [NetworkManager1 uploadWithId:__sm.uploadId sid:__sm.uploadNum file:__sm.plistPath].completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                NSLog(@"%@ plist文件上传成功", __sm.siteId);
                NSString *plistUrl = [@"https://app.wdheco.cn" stringByAppendingPathComponent:sm.responseObject[@"data"][@"url"]];
                [__self saveString:plistUrl toFile:__sm.logPath];
                
                [NetworkManager1 getInfo:__sm.uploadId].completionBlock = ^(CCSessionModel *sm) {
                    __sm.siteUrl = sm.responseObject[@"data"][@"site_url"];
                    [NetworkManager1 editInfo:__sm plistUrl:plistUrl].completionBlock = ^(CCSessionModel *sm) {
                        if (!sm.error) {
                            NSLog(@"%@ 提交审核成功", __sm.siteId);
                            [okSites addObject:__sm];
                            [__self saveLog:__sm];
                        } else {
                            NSLog(@"%@ 提交审核失败", __sm.siteId);
                        }
                        __sm = nil;
                        __next();
                    };
                };
            } else {
                NSLog(@"%@ plist文件上传失败", __sm.siteId);
                __sm = nil;
                __next();
            }
        };
    };
    
    void (^startUploading)(void) = ^{
        if (!__sm) {
            __sm = sites.firstObject;
            [sites removeObject:__sm];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:__sm.plistPath]) {
                NSLog(@"已上传过 %@.ipa，无需再次上传", __sm.siteId);
                uploadPlist();
                return;
            }
        }
        if (!__sm) {
//            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[dirPath]];
            if (okSites.count < _sites.count) {
                NSMutableArray *errs = [_sites mutableCopy];
                [errs removeObjectsInArray:okSites];
                NSLog(@"所有站点已上传完毕，其中 %@ 站点上传失败！", [[errs valueForKey:@"siteId"] componentsJoinedByString:@","]);
            } else {
                NSLog(@"所有站点都已成功上传！");
            }
            if (completion) {
                completion(okSites);
            }
            return ;
        }
        
        __block int __progress = 0;
        CCSessionModel *sm = [NetworkManager1 uploadWithId:__sm.uploadId sid:__sm.uploadNum file:__sm.ipaPath];
        sm.progressBlock = ^(NSProgress *progress) {
            int p = progress.completedUnitCount/(double)progress.totalUnitCount * 100;
            if (p != __progress) {
                __progress = p;
                NSLog(@"%@ ipa文件上传进度：0.%02d", __sm.siteId, __progress);
            }
        };
        sm.completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                NSLog(@"%@ ipa文件上传成功", __sm.siteId);
                NSString *ipaUrl = [@"https://app.wdheco.cn" stringByAppendingPathComponent:sm.responseObject[@"data"][@"url"]];
                [__self saveString:ipaUrl toFile:__sm.logPath];
                
                [ShellHelper setupPlist:__sm ipaUrl:ipaUrl completion:^{
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.plistPath error:nil];
                    [[NSFileManager defaultManager] copyItemAtPath:Path.tempPlist toPath:__sm.plistPath error:nil];
                    uploadPlist();
                }];
            } else {
                NSLog(@"%@ ipa文件上传失败，%@", __sm.siteId, sm.error);
                __sm = nil;
                __next();
            }
        };
    };
    __next = startUploading;
    
    startUploading();
}

// 保存发包日志
- (void)saveLog:(SiteModel *)sm {
    [ShellHelper pullCode:Path.logPath.stringByDeletingLastPathComponent completion:^{
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        
        NSString *downloadPath = _NSString(@"https://baidujump.app/eipeyipeyi/jump-%@.html  (%@原生iOS 已上传请测试审核)", sm.uploadId, sm.siteId);
        NSString *log = _NSString(@"%@ 上传到“%@“ （%@）  |  %@\n%@\n", sm.siteId, sm.uploadNum, Path.username, [df stringFromDate:[NSDate date]], downloadPath);
        [self saveString:log toFile:Path.logPath];
        
        [ShellHelper pushCode:Path.logPath.stringByDeletingLastPathComponent title:_NSString(@"%@ 发包", sm.siteId) completion:^{
            NSLog(@"发包日志提交成功");
        }];
    }];
}

// 写入字符串到文件末尾
- (void)saveString:(NSString *)string toFile:(NSString *)filePath {
    string = [@"\n" stringByAppendingString:string];
    
    // 写入文件末尾
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [@"——————————————\n    发包日志\n——————————————\n\n" writeToFile:filePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

@end
