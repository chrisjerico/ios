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


@interface HotVersionModel : NSObject
@property (nonatomic) NSString *version;    /**<   版本号 */
@property (nonatomic) NSString *update_url; /**<   文件下载地址 */
@property (nonatomic) NSString *fabu_log;   /**<   更新日志 */
@property (nonatomic) NSString *update_time;/**<   发布时间 */
@property (nonatomic) BOOL update_method;   /**<   0静默更新 1强制更新 */
@property (nonatomic) BOOL app_type;        /**<  1 ios ，2 android */
@property (nonatomic) BOOL fabu_status;     /**<   是否已发布 */
@end
@implementation HotVersionModel
@end



@interface JPEngine ()
+ (JSValue *)_evaluateScript:(NSString *)script withSourceURL:(NSURL *)resourceURL;
@end

@implementation JSPatchHelper

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        #define HookSEL(cls, selector) NSSelectorFromString([NSString stringWithFormat:@"cc_%@_%@", cls, selector])
        
        // japatch 解密
        Class cls = [JPEngine class];
        SEL sel = @selector(_evaluateScript:withSourceURL:);
        [cls jr_swizzleClassMethod:sel withBlock:^(id obj, NSString *script, NSURL *resourceURL) {
            script = [RSA decryptString:script];
            [obj performSelectorWithArgs:HookSEL(cls, NSStringFromSelector(sel)), script, resourceURL];
        } error:nil];
    });
}

+ (void)install {
    [JPEngine startEngine];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:APP.jspPath]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [JPEngine evaluateScriptWithPath:APP.jspPath];
        });
    }
}

+ (void)updateVersion:(NSString *)cpVersion completion:(void (^)(BOOL))completion {
    
    // 下载完成后解压
    void (^downloadPackage)(HotVersionModel *) = ^(HotVersionModel *hvm) {
        CCSessionModel *sm = [NetworkManager1 downloadFile:hvm.update_url];
        __block int __progress = 0;
        sm.progressBlock = ^(NSProgress *progress) {
            int p = progress.completedUnitCount/(double)progress.totalUnitCount * 100;
            if (p != __progress) {
                __progress = p;
                NSLog(@"JSPatch文件下载进度：%.2f", (double)__progress);
            }
        };
        sm.completionBlock = ^(CCSessionModel *sm) {
            NSLog(@"下载完成");
            if (!sm.error) {
                // 解压
                NSString *zipPath = sm.responseObject;
                NSString *unzipPath = _NSString(@"%@/jsp%@", APP.DocumentDirectory, hvm.version);
                [[NSFileManager defaultManager] removeItemAtPath:unzipPath error:nil];
                BOOL ret = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
                // 保存路径（更新成功）
                if (ret) {
                    NSString *jspVersion = [NSString stringWithContentsOfFile:_NSString(@"%@/Version.txt", unzipPath) encoding:NSUTF8StringEncoding error:nil];
                    jspVersion = [RSA decryptString:jspVersion];
                    if ([jspVersion isEqualToString:hvm.version]) {
                        APP.jspVersion = jspVersion;
                        [JSPatchHelper install];
                    }
                }
            }
        };
    };
    
#ifdef DEBUG
//    downloadPackage(({
//        HotVersionModel *hvm = [HotVersionModel new];
//        hvm.version = @"1.1.1";
//        hvm.update_url = @"http://192.168.1.144/chat.zip";
//        hvm;
//    }));
//    return;
#endif
    
    // 获取版本列表
    void (^getVersionList)(NSInteger) = nil;
    void (^__block __nextPage)(NSInteger) = getVersionList = ^(NSInteger page) {
        [NetworkManager1 getHotUpdateVersionList:page].completionBlock = ^(CCSessionModel *sm) {
            NSArray *vs = sm.responseObject[@"data"][@"result"];
            if (vs.count) {
                HotVersionModel *newVersion = nil;
                // 比较版本号
                for (HotVersionModel *hvm in @[]) {
                    if ([JSPatchHelper compareVersion:hvm.version newerThanVersion:APP.jspVersion]) {
                        if ([JSPatchHelper compareVersion:hvm.version newerThanVersion:cpVersion]) {
                            // 此jspatch版本比CodePush版本大，忽略此更新
                            continue;
                        } else {
                            // 发现新版本
                            newVersion = hvm;
                            break;
                        }
                    } else {
                        // 已是最新版本
                        NSLog(@"已是最新版本");
                        return ;
                    }
                }
                if (newVersion) {
                    NSLog(@"下载更新包");
                    downloadPackage(newVersion);
                } else if (vs.count >= 10) {
                    // 未找到可以更新的版本，拉取下一页数据继续找
                    __nextPage(page + 1);
                }
            } else {
                NSLog(@"拉取热更新列表失败，err = %@", sm.error ? : sm.responseObject[@"msg"]);
            }
        };
    };
    getVersionList(1);
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
