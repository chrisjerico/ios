//
//  JSPatchHelper.m
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JSPatchHelper.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"// 加/解压缩
#import "RSA.h"         // RSA加/解密
#import "JPEngine.h"    // JsPatch引擎
#import "ReactNativeHelper.h"


@implementation HotVersionModel
@end





@interface JPEngine (Decrypt)
@end
@interface JPEngine ()
+ (JSValue *)_evaluateScript:(NSString *)script withSourceURL:(NSURL *)resourceURL;
@end
@implementation JPEngine (Decrypt)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JPEngine jr_swizzleClassMethod:@selector(_evaluateScript:withSourceURL:) withClassMethod:@selector(cc_evaluateScript:withSourceURL:) error:nil];
    });
}
+ (JSValue *)cc_evaluateScript:(NSString *)script withSourceURL:(NSURL *)resourceURL {
    // 分段解密，每段之间用\n隔开（因为rsa无法加/解密太长的字符串）
    NSMutableString *temp = @"".mutableCopy;
    for (NSString *str in [script componentsSeparatedByString:@"\n"]) {
        NSString *a = [RSA decryptString:str];
        [temp appendString:[a stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSBackwardsSearch range:NSMakeRange(a.length-1, 1)]];
    }
    script = temp;
    return [self cc_evaluateScript:script withSourceURL:resourceURL];
}
@end




@implementation JSPatchHelper

+ (void)install {
    NSLog(@"初始化jspatch");
    [JPEngine startEngine];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:APP.jspPath]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [JPEngine evaluateScriptWithPath:APP.jspPath];
        });
    }
}

+ (void)checkUpdate:(NSString *)rnVersion completion:(nonnull void (^)(NSError *, HotVersionModel *))completion {
    if (!rnVersion.length) {
        NSLog(@"rn版本号为空！");
        // 获取ip信息
        [NetworkManager1 getIp].completionBlock = ^(CCSessionModel *ipSM) {
            NSDictionary *ipAddress = ipSM.responseObject[@"data"] ? : @{};
            NSString *ipInfo = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:ipAddress options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            NSString *log = _NSString(@"ip地址：%@\n错误类型：%@", ipInfo, @"rn版本号为空");
            NSString *title = _NSString(@"%@%@", ipAddress[@"country"], ipAddress[@"region"]);
            // 上传日志
            [NetworkManager1 uploadLog:log title:title tag:@"rn版本号为空"];
        };
        return;
    }
    
    NSMutableArray *newVersions = @[].mutableCopy;
    void (^didFindEnd)(void) = ^{
        HotVersionModel *hvm = newVersions.firstObject; // 最新版本
        // 新版本中只要存在强制更新的版本，就要强制更新
        hvm.is_force_update = [newVersions containsValue:@true keyPath:@"is_force_update"];
        if (completion) {
            if ([JSPatchHelper compareVersion:hvm.version newerThanVersion:APP.jspVersion]) {
                NSLog(@"%@", hvm.is_force_update ? @"强制更新" : @"静默更新");
                completion(nil, hvm);
            } else {
                NSLog(@"jsp已是最新版本");
                completion(nil, nil);
            }
        }
    };
    
    
    // 获取版本列表
    NSLog(@"当前rn版本：%@", rnVersion);
    NSLog(@"当前jsp版本：%@", APP.jspVersion);
    NSLog(@"正在查找jsp可用的更新");
    void (^findNewVersions)(NSInteger) = nil;
    void (^__block __nextPage)(NSInteger) = findNewVersions = ^(NSInteger page) {
        [NetworkManager1 getHotUpdateVersionList:page].completionBlock = ^(CCSessionModel *sm) {
            NSArray *vs = sm.responseObject[@"data"][@"result"];
            if (!vs.count) {
                if (page <= 1) {
                    NSError *err = sm.error ? : [NSError errorWithDomain:sm.responseObject[@"msg"] code:-1 userInfo:nil];
                    if (completion) {
                        completion(err, nil);
                    }
                    NSLog(@"拉取jsp热更新列表失败，err = %@", err);
                } else {
                    // 没有更多版本信息了，结束查找
                    didFindEnd();
                }
                return ;
            }
            
            // 比较版本号
            for (NSDictionary *dict in vs) {
                HotVersionModel *hvm = [HotVersionModel mj_objectWithKeyValues:dict];
                if ([hvm.version componentsSeparatedByString:@"."].count != 3) {
                    NSLog(@"%@, 版本号不合法", hvm.version);
                    continue;
                }
                if ([JSPatchHelper compareVersion:hvm.version newerThanVersion:APP.jspVersion]) {
                    if ([JSPatchHelper compareVersion:hvm.version newerThanVersion:rnVersion]) {
                        NSLog(@"%@ 此jspatch版本比CodePush版本大，忽略此更新", hvm.version);
                        continue;
                    } else {
                        NSLog(@"发现jsp新版本：%@", hvm.version);
                        [newVersions addObject:hvm];
                        continue;
                    }
                } else {
                    // 发现比自己低的版本，结束查找
                    didFindEnd();
                    return ;
                }
            }
            
            // 拉取下一页数据继续找比自己新的版本
            __nextPage(page + 1);
        };
    };
    findNewVersions(1);
}

+ (void)updateVersion:(NSString *)rnVersion progress:(nonnull void (^)(CGFloat))progress completion:(nonnull void (^)(BOOL))completion {
    [self checkUpdate:rnVersion completion:^(NSError *err, HotVersionModel *hvm) {
        if (err || !hvm) {
            // 已是最新版本
            [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
                [ReactNativeHelper sendEvent:@"jsp更新结果" params:@(!err)];
            }];
            return ;
        }
        
        // 下载完成后解压
        NSMutableArray <NSNumber *>*speeds = @[].mutableCopy;
        NSDate *startDate = [NSDate date];
        
        NSLog(@"开始下载jsp包：%@", hvm.version);
        CCSessionModel *sm = [NetworkManager1 downloadFile:hvm.file_link];
        __block int __progress = 0;
        __block unsigned long long __downloadSpeed = 0;
        __block unsigned long long __lastCompletedUnitCount = 0;
        __block_Obj_(sm, __sm);
        sm.progressBlock = ^(NSProgress *p) {
            // 进度回调
            CGFloat fp = p.completedUnitCount/(double)p.totalUnitCount;
            if (progress) {
                progress(fp);
            }
            
            // 通知rn刷新进度
            [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
                if (!waited) {
                    [ReactNativeHelper sendEvent:@"jsp下载进度" params:@(fp)];
                }
            }];
            
            // 打印下载进度
            int ip = fp * 100;
            if (ip != __progress) {
                __progress = ip;
                NSLog(@"%@ jsp文件下载进度：%.2f", hvm.version, (double)__progress);
            }
            
            // 计算下载速度
            __downloadSpeed += p.completedUnitCount - __lastCompletedUnitCount;
            __lastCompletedUnitCount = p.completedUnitCount;
            // 保存下载速度
            if (OBJOnceToken(__sm)) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    while (__sm.completionBlock) {
                        [NSThread sleepForTimeInterval:1];
                        [speeds addObject:@(__downloadSpeed)];
                        __downloadSpeed = 0;
                    }
                });
            }
        };
        sm.completionBlock = ^(CCSessionModel *sm) {
            NSString *err = nil;
            if (!sm.error) {
                NSLog(@"jsp包下载完成 %@", hvm.version);
                // 解压
                NSString *zipPath = sm.responseObject;
                NSString *unzipPath = _NSString(@"%@/jsp%@", APP.DocumentDirectory, hvm.version);
                [[NSFileManager defaultManager] removeItemAtPath:unzipPath error:nil];
                BOOL ret = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
                // 保存路径（更新成功）
                if (ret) {
                    NSLog(@"解压缩成功");
                    NSString *jspVersion = [NSString stringWithContentsOfFile:_NSString(@"%@/Version.txt", unzipPath) encoding:NSUTF8StringEncoding error:nil];
                    if (jspVersion.length && [(jspVersion = [RSA decryptString:jspVersion].stringByTrim) hasPrefix:hvm.version]) {
                        NSLog(@"%@ 校验成功，更新完毕", jspVersion);
                        APP.jspVersion = jspVersion;
                        [JSPatchHelper install];
                    } else {
                        NSLog(@"%@", err = @"jsp校验失败，不予更新");
                    }
                } else {
                    NSLog(@"%@", err = @"解压缩失败");
                }
            } else {
                NSLog(@"%@", err = @"jsp下载失败");
            }
            
            BOOL isSucc = [APP.jspVersion isEqualToString:hvm.version];
            if (completion) {
                completion(isSucc);
            }
            [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
                [ReactNativeHelper sendEvent:@"jsp更新结果" params:@(isSucc)];
            }];
            
            // 安装失败时上传错误日志
            if (!isSucc) {
                NSMutableArray *temp = @[].mutableCopy;
                for (NSNumber *s in speeds) {
                    [temp addObject:[AppDefine stringWithFileSize:s.doubleValue]];
                }
                NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startDate];
                NSString *averageSpeed = ({
                    unsigned long long totalLenght = 0;
                    for (NSNumber *s in speeds) {
                        totalLenght += s.doubleValue;
                    }
                    [AppDefine stringWithFileSize:totalLenght/MAX(speeds.count, 1)];
                });
                // 获取ip信息
                [NetworkManager1 getIp].completionBlock = ^(CCSessionModel *ipSM) {
                    NSDictionary *ipAddress = ipSM.responseObject[@"data"] ? : @{};
                    NSString *ipInfo = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:ipAddress options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                    NSString *log = _NSString(@"下载文件：%@\n\n耗时：%.f秒\n平均下载速度：%@\n\nip地址：%@\n\n下载速度：\n%@\n\n\n错误类型：%@\n错误信息：%@", [hvm rn_keyValues], duration, averageSpeed, ipInfo, temp, err, sm.error);
                    NSString *title = _NSString(@"%@%@", ipAddress[@"country"], ipAddress[@"region"]);
                    // 上传日志
                    [NetworkManager1 uploadLog:log title:title tag:@"jsp更新失败"];
                };
            }
            sm.completionBlock = nil;
        };
    }];
}

+ (BOOL)compareVersion:(NSString *)v1 newerThanVersion:(NSString *)v2 {
    BOOL hasUpdate = false; // 是否存在新版本
    
    NSArray *currentV = [v2 componentsSeparatedByString:@"."];
    NSArray *newestV = [v1 componentsSeparatedByString:@"."];
    for (int i=0; i<4; i++) {
        NSString *v1 = currentV.count > i ? currentV[i] : nil;
        NSString *v2 = newestV.count > i ? newestV[i] : nil;
        if (v2.intValue > v1.intValue)
            hasUpdate = true;
        if (v2.intValue != v1.intValue)
            break;
    }
    return hasUpdate;
}

@end
