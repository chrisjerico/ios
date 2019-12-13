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
    
    [__self startPacking:ids];
}

- (void)startPacking:(NSString *)ids {
    __weakSelf_(__self);
    
    // 拉取最新代码
    [ShellHelper pullCode:Path.projectDir completion:^{
        
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
    
    __block SiteModel *__sm = nil;
    __weakSelf_(__self);
    void (^startUploading)(void) = nil;
    void (^__block __next)(void) = startUploading = ^{
        if (!__sm) {
            __sm = sites.firstObject;
            [sites removeObject:__sm];
            
//            if ([[NSFileManager defaultManager] fileExistsAtPath:__sm.plistPath]) {
//                NSLog(@"已上传过 %@.ipa，无需再次上传", __sm.siteId);
//                [okSites addObject:__sm];
//                __sm = nil;
//                __next();
//                return;
//            }
        }
        if (!__sm) {
//            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[dirPath]];
            if (okSites.count < _sites.count) {
                NSLog(@"所有站点已上传完毕，其中 %@ 站点上传失败！", [[okSites valueForKey:@"siteId"] componentsJoinedByString:@","]);
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
                
                [ShellHelper setupPlist:__sm ipaUrl:ipaUrl completion:^{
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.plistPath error:nil];
                    [[NSFileManager defaultManager] copyItemAtPath:Path.tempPlist toPath:__sm.plistPath error:nil];
                    [NetworkManager1 uploadWithId:__sm.uploadId sid:__sm.uploadNum file:Path.tempPlist].completionBlock = ^(CCSessionModel *sm) {
                        if (!sm.error) {
                            NSLog(@"%@ plist文件上传成功", __sm.siteId);
                            NSString *plistUrl = [@"https://app.wdheco.cn" stringByAppendingPathComponent:sm.responseObject[@"data"][@"url"]];
                            [NetworkManager1 editInfo:__sm.uploadId ipaUrl:ipaUrl plistUrl:plistUrl].completionBlock = ^(CCSessionModel *sm) {
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
                        } else {
                            NSLog(@"%@ plist文件上传失败", __sm.siteId);
                            __sm = nil;
                            __next();
                        }
                    };
                }];
            } else {
                NSLog(@"%@ ipa文件上传失败，%@", __sm.siteId, sm.error);
                __sm = nil;
                __next();
            }
        };
    };
    
    startUploading();
}

- (void)saveLog:(SiteModel *)sm {
    [ShellHelper pullCode:Path.log.stringByDeletingLastPathComponent completion:^{
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        
        NSString *downloadPath = _NSString(@"https://baidujump.app/eipeyipeyi/jump-%@.html  (%@原生iOS 已上传请测试审核)", sm.uploadId, sm.siteId);
        NSString *log = _NSString(@"%@ 上传到“%@“ （%@）  |  %@  |  %@\n", sm.siteId, sm.uploadNum, Path.username, [df stringFromDate:[NSDate date]], downloadPath);
        
        // 写入文件末尾
        if(![[NSFileManager defaultManager] fileExistsAtPath:Path.log]) {
            [@"——————————————\n    发包日志\n——————————————\n\n" writeToFile:Path.log atomically:true encoding:NSUTF8StringEncoding error:nil];
        }
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:Path.log];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }];
}

@end
