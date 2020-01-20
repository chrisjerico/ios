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
    
    BOOL isPack = 1;  // 0全站提交热更新，1批量打包上传APP后台
//    BOOL isPack = 0;  // 0全站提交热更新，1批量打包上传APP后台
    
    // 拉取最新代码
    [ShellHelper pullCode:Path.projectDir completion:^{
        Path.commitId = [[NSString stringWithContentsOfFile:Path.tempCommitId encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        Path.gitLog = [[[NSString stringWithContentsOfFile:Path.tempLog encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""] componentsSeparatedByString:@"(1):      "].lastObject;
        Path.gitVersion = ({
            NSString *vStr = [[NSString stringWithContentsOfFile:Path.tempVersion encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if (vStr.length != 4) {
                @throw [NSException exceptionWithName:@"版本号获取失败。" reason:@"" userInfo:nil];
            }
            NSString *(^getChar)(int) = ^NSString *(int idx) {
                return [vStr substringWithRange:NSMakeRange(idx, 1)];
            };
            _NSString(@"%@.%@.%@%@", getChar(0), getChar(1), getChar(2), getChar(3));
        });
        
        if (isPack) {


            NSString *ids = @"test29";   // 站点编号

            BOOL willUpload = 1; // 打包后是否上传审核
            [self startPackingWithIds:ids willUpload:willUpload];
        }
        else {
            NSString *log = @"热更新发包测试，热更新发包测试，热更新发包测试，热更新发包测试，热更新发包测试2，";    // 更新日志
            [self postHotUpdate:log];
        }
    }];
}



#pragma mark - 发布热更新

- (void)postHotUpdate:(NSString *)log {
    if (log.length < 20) {
        @throw [NSException exceptionWithName:@"日志太短，请写详细点。" reason:@"" userInfo:nil];
    }
    
//    Path.jspatchDir
    BOOL isDir = NO;
    BOOL isExist = NO;
    
    // 更新Version.txt
    {
        NSString *versionPath = _NSString(@"%@/Version.txt", Path.jspatchDir);
        [[NSFileManager defaultManager] removeItemAtPath:versionPath error:nil];
        [Path.gitVersion writeToFile:versionPath atomically:true encoding:NSUTF8StringEncoding error:nil];
    }
    
    //列举目录内容，可以遍历子目录
    NSMutableArray *contents = @[].mutableCopy;
    NSMutableArray *paths = @[].mutableCopy;
    for (NSString *path in [[NSFileManager defaultManager] enumeratorAtPath:Path.jspatchDir].allObjects) {
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", Path.jspatchDir, path];
        isExist = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
        if (isExist && !isDir) {
            NSString *content = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
            if (!content.length) {
                @throw [NSException exceptionWithName:@"js导出失败，文件不存在。" reason:@"" userInfo:nil];
            }
            [contents addObject:content];
            [paths addObject:path];
        }
    }
    
    // 加密文件内容
    NSString *rootDir = [Path.jsExportDir stringByAppendingFormat:@"/%@", Path.commitId];
    [ShellHelper encrypt:contents completion:^(NSArray<NSString *> * _Nonnull rets) {
        // 保存加密后的内容为js文件
        for (int i=0; i<rets.count; i++) {
            NSString *content = rets[i];
            NSString *path = paths[i];
            if (!content.length) {
                @throw [NSException exceptionWithName:@"js加密后为空。" reason:@"" userInfo:nil];
            }
            NSString *fullPath = _NSString(@"%@/%@", rootDir, path);
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:fullPath.stringByDeletingLastPathComponent withIntermediateDirectories:true attributes:nil error:nil];
            NSError *err = nil;
            [content writeToFile:fullPath atomically:true encoding:NSUTF8StringEncoding error:&err];
            if (err) {
                @throw [NSException exceptionWithName:@"js加密后保存失败。" reason:@"" userInfo:nil];
            }
        }
        
        // 压缩
        NSString *zipPath = _NSString(@"%@/%@.zip", rootDir, Path.gitVersion);
        [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"8zip" ofType:@"sh"] arguments:@[Path.gitVersion, rootDir] completion:^(NSTask * _Nonnull ts) {
            
            // 上传js压缩包
            __block int __progress = 0;
            CCSessionModel *sm = [NetworkManager1 addHotUpdateVersion:Path.gitVersion log:log filePath:zipPath];
            sm.progressBlock = ^(NSProgress *progress) {
                int p = progress.completedUnitCount/(double)progress.totalUnitCount * 100;
                if (p != __progress) {
                    __progress = p;
                    NSLog(@"%@ js压缩包上传进度：%.2f", Path.gitVersion, (double)__progress);
                }
            };
            sm.completionBlock = ^(CCSessionModel *sm) {
                if (sm.error) {
                    NSLog(@"err = %@", sm.error);
                    @throw [NSException exceptionWithName:@"JSPatch热更新提交失败。" reason:@"" userInfo:nil];
                    return ;
                }
                
                NSLog(@"%@ JSPatch热更新提交成功。", Path.gitVersion);
                // 提交rn资源包
                [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"7codepush" ofType:@"sh"] arguments:@[APPVersion, Path.gitVersion, [log stringByReplacingOccurrencesOfString:@"\n" withString:@";"], Path.projectDir.stringByDeletingLastPathComponent] completion:^(NSTask * _Nonnull ts) {
                    NSString *rnRet = [NSString stringWithContentsOfFile:_NSString(@"%@/rn打包结果.txt", Path.projectDir.stringByDeletingLastPathComponent) encoding:NSUTF8StringEncoding error:nil];
                    [rnRet stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    if ([rnRet hasSuffix:@"info Done copying assets"]) {
                        @throw [NSException exceptionWithName:@"rn打包失败。" reason:@"" userInfo:nil];
                    }
                    
                    // 记录热更新日志
                    [ShellHelper pullCode:Path.jsLogPath.stringByDeletingLastPathComponent completion:^{
                        
                        NSDateFormatter *df = [NSDateFormatter new];
                        [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                        
                        NSString *jsLog = _NSString(@"（%@）%@  |  %@，%@（%@）", Path.username, [df stringFromDate:[NSDate date]], Path.commitId, Path.gitLog, [log stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
                        [self saveString:jsLog toFile:Path.jsLogPath];
                        
                        // 提交发包日志到git
                        NSString *title = _NSString(@"%@ 提交热更新，%@", Path.gitVersion, log);
                        [ShellHelper pushCode:Path.jsLogPath.stringByDeletingLastPathComponent title:title completion:^{
                            NSLog(@"发包日志提交成功");
                            NSLog(@"退出程序！");
                            exit(0);
                        }];
                    }];
                }];
            };
        }];
    }];
}


#pragma mark - 批量打包+上传

// 批量打包
- (void)startPackingWithIds:(NSString *)ids willUpload:(BOOL)willUpload {
    __weakSelf_(__self);
    // 检查配置
    [ShellHelper checkSiteInfo:ids];
    
    // 批量打包
    [ShellHelper packing:[SiteModel sites:ids] completion:^(NSArray<SiteModel *> *okSites) {
        if (!okSites.count) {
            NSLog(@"没有一个打包成功的。");
            exit(0);
        }
        if (!willUpload) {
            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[okSites.firstObject.ipaPath.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent]];
            
            // 上传打包日志
            [self saveLog:okSites uploaded:false completion:^(BOOL ok) {
                [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", @"/Applications/Xcode.app", Path.ipaLogPath]];
                NSLog(@"只打包不上传，退出打包程序");
                exit(0);
            }];
            return ;
        }
        okSites = ({
            NSMutableArray *temp = okSites.mutableCopy;
            for (SiteModel *sm in okSites) {
                if (![@"企业包,内测包" containsString:sm.type]) {
                    [temp removeObject:sm];
                }
            }
            if (temp.count < okSites.count) {
                // 弹出不能自动上传的包，手动处理
                [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[okSites.firstObject.ipaPath.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent]];
                NSMutableArray *ReSign = okSites.mutableCopy;
                [ReSign removeObjectsInArray:temp];
                NSLog(@"-------\n.");
                for (SiteModel *sm in ReSign) {
                    NSLog(@"此ipa需要改签：%@（%@）", sm.siteId, sm.type);
                }
                NSLog(@"-------");
                // 上传打包日志
                [self saveLog:ReSign uploaded:false completion:^(BOOL ok) {
                    if (!temp.count) {
                        [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", @"/Applications/Xcode.app", Path.ipaLogPath]];
                        NSLog(@"无需上传，退出打包程序！");
                        exit(0);
                    }
                }];
            }
            if (!temp.count) {
                return ;
            }
            temp.copy;
        });
        
        // 登录
        [NetworkManager1 login:Path.username pwd:Path.pwd].completionBlock = ^(CCSessionModel *sm) {
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
}

// 批量上传审核
- (void)upload:(NSArray <SiteModel *>*)_sites completion:(void (^)(NSArray <SiteModel *>*okSites))completion {
    NSMutableArray *sites = _sites.mutableCopy;
    NSMutableArray *okSites = @[].mutableCopy;
    __weakSelf_(__self);
    __block SiteModel *__sm = nil;
    
    void (^__block __next)(void) = nil;
    // 上传plist文件，并提交审核
    void (^uploadPlist)(void) = ^{
        [NetworkManager1 uploadWithId:__sm.uploadId sid:__sm.uploadNum file:__sm.plistPath].completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                NSLog(@"%@ plist文件上传成功", __sm.siteId);
                NSString *plistPath = sm.responseObject[@"data"][@"url"];
                NSString *plistUrl = _NSString(@"https://app.wdheco.cn%@", plistPath);
                [__self saveString:plistUrl toFile:__sm.logPath];
                
                // 提交审核
                [NetworkManager1 getInfo:__sm.uploadId].completionBlock = ^(CCSessionModel *sm) {
                    __sm.siteUrl = sm.responseObject[@"data"][@"site_url"];
                    [NetworkManager1 editInfo:__sm plistPath:plistPath].completionBlock = ^(CCSessionModel *sm) {
                        if (!sm.error) {
                            NSLog(@"%@ 提交审核成功", __sm.siteId);
                            [okSites addObject:__sm];
                            [__self saveLog:@[__sm] uploaded:true completion:^(BOOL ok) {
                                __sm = nil;
                                __next();
                            }];
                        } else {
                            NSLog(@"%@ 提交审核失败", __sm.siteId);
                            __sm = nil;
                            __next();
                        }
                        
                    };
                };
            } else {
                NSLog(@"%@ plist文件上传失败", __sm.siteId);
                __sm = nil;
                __next();
            }
        };
    };
    
    // 上传ipa包
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
            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", @"/Applications/Xcode.app", Path.ipaLogPath]];
            
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
        
        // 上传ipa包
        __block int __progress = 0;
        CCSessionModel *sm = [NetworkManager1 uploadWithId:__sm.uploadId sid:__sm.uploadNum file:__sm.ipaPath];
        sm.progressBlock = ^(NSProgress *progress) {
            int p = progress.completedUnitCount/(double)progress.totalUnitCount * 100;
            if (p != __progress) {
                __progress = p;
                NSLog(@"%@ ipa文件上传进度：%.2f", __sm.siteId, (double)__progress);
            }
        };
        sm.completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                NSLog(@"%@ ipa文件上传成功", __sm.siteId);
                NSString *ipaUrl = _NSString(@"https://app.wdheco.cn%@", sm.responseObject[@"data"][@"url"]);
                if (![ipaUrl containsString:@".ipa"]) {
                    NSLog(@"%@ ipa文件上传错误❌，%@", __sm.siteId, sm.error);
                    __sm = nil;
                    __next();
                    return ;
                }
                [__self saveString:ipaUrl toFile:__sm.logPath];
                
                // 配置plist文件
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
- (void)saveLog:(NSArray <SiteModel *>*)sms uploaded:(BOOL)uploaded completion:(void (^)(BOOL ok))completion {
    // 从git拉取最新的发包日志
    [ShellHelper pullCode:Path.ipaLogPath.stringByDeletingLastPathComponent completion:^{
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        
        for (SiteModel *sm in sms) {
            NSString *downloadPath = _NSString(@"https://baidujump.app/eipeyipeyi/jump-%@.html  (%@原生iOS 已上传请测试审核)", sm.uploadId, sm.siteId);
            if (!uploaded) {
                downloadPath = _NSString(@"【%@ %@】打包记录", sm.siteId, sm.type);
            }
            NSString *log = _NSString(@"%@\t\t（%@）%@  |  %@，%@", downloadPath, Path.username, [df stringFromDate:[NSDate date]], Path.commitId, Path.gitLog);
            [self saveString:log toFile:Path.ipaLogPath];
        }
        
        // 提交发包日志到git
        NSString *title = _NSString(@"%@ %@，%@", [(NSArray *)[sms valueForKey:@"siteId"] componentsJoinedByString:@","], uploaded ? @"【发包】" : @"【只打包】", Path.gitLog);
        [ShellHelper pushCode:Path.ipaLogPath.stringByDeletingLastPathComponent title:title completion:^{
            NSLog(@"发包日志提交成功");
            if (completion) {
                completion(true);
            }
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
