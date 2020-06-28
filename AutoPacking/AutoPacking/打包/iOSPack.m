//
//  iOSPack.m
//  AutoPacking
//
//  Created by fish on 2020/6/25.
//  Copyright © 2020 fish. All rights reserved.
//

#import "iOSPack.h"
#import "ShellHelper.h"
#import "cc_runtime_property.h"


@interface iOSPack ()
@property (nonatomic, strong) GitModel *gm;
@property (nonatomic, copy) NSString *plistFile;    /**<   plist模版 */
@property (nonatomic, copy) NSString *exportDir;    /**<   ipa导出目录 */
@property (nonatomic, copy) NSString *logFile;      /**<   ipa发包记录 */
@end

@implementation iOSPack

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self class] new];
    });
    return obj;
}

- (void)setupPlist:(NSDictionary *)dict {
    _projectDir = [NSString stringWithFormat:@"%@/ios", dict[@"打包项目路径"]];
    _plistFile = [_projectDir stringByAppendingString:@"/AutoPacking/AutoPacking/sh/a.plist"];
    _exportDir = @"/Library/WebServer/Documents/ipa";
    _logFile = [NSString stringWithFormat:@"%@/PackingLog.txt", dict[@"日志项目路径"]];
}

#pragma mark - 版本号

- (void)pullCode:(NSString *)branch completion:(nonnull void (^)(NSString * _Nonnull))completion {
    __weakSelf_(__self);
    [ShellHelper pullCode:self.projectDir branch:branch completion:^(GitModel * _Nonnull gm) {
        __self.gm = gm;
        
        NSString *(^getChar)(NSString *, int) = ^NSString *(NSString *vStr, int idx) {
            return [vStr substringWithRange:NSMakeRange(idx, 1)];
        };
        NSString *ipaVersion = _NSString(@"%@.%@%@.0", getChar(gm.number, 0), getChar(gm.number, 1), getChar(gm.number, 2));
        NSLog(@"ipaVersion = %@", ipaVersion);
        if (completion)
            completion(ipaVersion);
    }];
}

#pragma mark - 检查站点配置

- (void)checkSiteInfo:(NSString *)siteIds {
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
            if (![sm.host hasPrefix:@"http"]) {
                [errs addObject:[NSString stringWithFormat:@"接口域名未配置, %@", sm.siteId]];
            }
            if (!sm.uploadNum.length) {
                [errs addObject:[NSString stringWithFormat:@"上传编号未配置, %@", sm.siteId]];
            }
            if (!sm.uploadId.length) {
                [errs addObject:[NSString stringWithFormat:@"上传ID未配置, %@", sm.siteId]];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/AutoPacking/打包文件/各站点AppIcon（拷贝出来使用）/%@", _projectDir, sm.siteId]]) {
                [errs addObject:[NSString stringWithFormat:@"app图标未配置, %@", sm.siteId]];
            }
        } else {
            [errs addObject:[NSString stringWithFormat:@"没有此站点，请检查是否拼写错误, %@", siteId]];
        }
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_plistFile]) {
        [errs addObject:_NSString(@"找不到plist模板，请在此路径放置一个plist模板：%@", _plistFile)];
    }
    if (![[NSString stringWithContentsOfFile:_NSString(@"%@/ug/Classes/Other/configuration.h", _projectDir) encoding:NSUTF8StringEncoding error:nil] containsString:@"#define checkSign 1"]) {
        [errs addObject:@"未开启参数加密，请到 configuration.h 文件开启参数加密"];
    }
    NSString *appDefine = [NSString stringWithContentsOfFile:_NSString(@"%@/ug/Classes/Helper/FishUtility/define/AppDefine.h", _projectDir) encoding:NSUTF8StringEncoding error:nil];
    if (!([appDefine componentsSeparatedByString:@"#define APP_TEST"].count == 2 && [appDefine containsString:@"\n#define APP_TEST\n"])) {
        [errs addObject:@"未正确配置 APP_TEST宏，请在AppDefine.h上配置。"];
    }
    
    NSLog(@"\n\n");
    NSLog(@"-——————————检查站点配置———————————\n\n");
    for (NSString *err in errs) {
        NSLog(@"%@", err);
    }
    if (errs.count) {
        NSLog(@"\n\n");
        assert(!@"缺少已上配置，请配置完成后再打包".length);
        return ;
    }
    NSLog(@"-——————————配置ok-——————————");
}

#pragma mark - 批量打包+上传

// 批量打包
- (void)startPackingWithIds:(NSString *)ids version:(NSString *)version willUpload:(BOOL)willUpload {
    __weakSelf_(__self);
    // 检查站点配置
    [self checkSiteInfo:ids];
    
    // 批量打包
    [ShellHelper iosPacking:_projectDir sites:[SiteModel sites:ids] version:version completion:^(NSArray<SiteModel *> *okSites) {
        if (!okSites.count) {
            NSLog(@"没有一个打包成功的。");
            exit(0);
        }
        if (!willUpload) {
            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[okSites.firstObject.ipaPath.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent]];
            
            // 上传打包日志
            [self saveLog:okSites uploaded:false completion:^(BOOL ok) {
                [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", @"/Applications/Xcode.app", iPack.logFile]];
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
                        [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", @"/Applications/Xcode.app", iPack.logFile]];
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
        
        // 批量上传
        [__self upload:okSites completion:^(NSArray<SiteModel *> *okSites) {
            NSLog(@"退出打包程序");
            exit(0);
        }];
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
                NSString *plistUrl = _NSString(@"https://app.pindanduo.cn%@", plistPath);
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
            [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:@[@"-a", @"/Applications/Xcode.app", iPack.logFile]];
            
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
                NSString *ipaUrl = _NSString(@"https://app.pindanduo.cn%@", sm.responseObject[@"data"][@"url"]);
                if (![ipaUrl containsString:@".ipa"]) {
                    NSLog(@"%@ ipa文件上传错误❌，%@", __sm.siteId, sm.error);
                    __sm = nil;
                    __next();
                    return ;
                }
                [__self saveString:ipaUrl toFile:__sm.logPath];
                
                // 配置plist文件
                [ShellHelper setupPlist:iPack.plistFile sm:__sm ipaUrl:ipaUrl completion:^{
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.plistPath error:nil];
                    [[NSFileManager defaultManager] copyItemAtPath:iPack.plistFile toPath:__sm.plistPath error:nil];
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
    NSLog(@"提交打包日志");
    [ShellHelper pullCode:iPack.logFile.stringByDeletingLastPathComponent branch:@"master" completion:^(GitModel * _Nonnull _) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        
        for (SiteModel *sm in sms) {
            NSString *downloadPath = _NSString(@"https://baidujump.app/eipeyipeyi/jump-%@.html  (%@原生iOS 已上传请测试审核,审核后请关闭工单，通知客服)", sm.uploadId, sm.siteId);
            if (!uploaded) {
                downloadPath = _NSString(@"【%@ %@ 】https://baidujump.app/eipeyipeyi/jump-%@.html", sm.siteId, sm.type,sm.uploadId);
            }
            NSString *log = _NSString(@"%@\t\t（%@）%@  |  %@，%@", downloadPath, NSUserName(), [df stringFromDate:[NSDate date]], iPack.gm.commitId, iPack.gm.log);
            [self saveString:log toFile:iPack.logFile];
        }
        
        // 提交发包日志到git
        NSString *title = _NSString(@"%@ %@，%@", [(NSArray *)[sms valueForKey:@"siteId"] componentsJoinedByString:@","], uploaded ? @"【发包】" : @"【只打包】", iPack.gm.log);
        [ShellHelper pushCode:iPack.logFile.stringByDeletingLastPathComponent title:title completion:^{
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




@implementation SiteModel (Helper)

_CCRuntimeProperty_Copy(NSString *, siteUrl, setSiteUrl)

- (NSString *)ipaPath       { return _NSString(@"%@/%@/%@/%@.ipa",         iPack.exportDir, iPack.gm.commitId, self.type, self.siteId); }
- (NSString *)plistPath     { return _NSString(@"%@/%@/%@/%@.plist",       iPack.exportDir, iPack.gm.commitId, self.type, self.siteId); }
- (NSString *)xcarchivePath { return _NSString(@"%@/%@/%@/%@.xcarchive",   iPack.exportDir, iPack.gm.commitId, self.type, self.siteId); }
- (NSString *)logPath       { return _NSString(@"%@/%@/%@/%@.txt",         iPack.exportDir, iPack.gm.commitId, self.type, self.siteId); }

@end
