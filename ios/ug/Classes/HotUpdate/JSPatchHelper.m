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
@property (nonatomic) NSString *version;        /**<   版本号 */
@property (nonatomic) NSString *file_link;      /**<   文件下载地址 */
@property (nonatomic) NSString *detail;         /**<   更新日志 */
@property (nonatomic) NSString *release_time;   /**<   发布时间 */
@property (nonatomic) NSString *add_time;       /**<   提交时间 */
@property (nonatomic) NSString *username;       /**<   提交者 */
@property (nonatomic) BOOL is_force_update;     /**<   是否强制更新 */
@property (nonatomic) NSInteger type;           /**<  1 ios ，2 android */
@property (nonatomic) BOOL status;              /**<   是否已发布 */
@end
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
    NSMutableArray *temp = @[].mutableCopy;
    for (NSString *str in [script componentsSeparatedByString:@"\n"]) {
        [temp addObject:[RSA decryptString:str]];
    }
    script = [temp componentsJoinedByString:@""];
    return [self cc_evaluateScript:script withSourceURL:resourceURL];
}
@end




@implementation JSPatchHelper

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
        CCSessionModel *sm = [NetworkManager1 downloadFile:hvm.file_link];
        __block int __progress = 0;
        sm.progressBlock = ^(NSProgress *progress) {
            int p = progress.completedUnitCount/(double)progress.totalUnitCount * 100;
            if (p != __progress) {
                __progress = p;
                NSLog(@"JSPatch文件下载进度：%.2f", (double)__progress);
            }
        };
        sm.completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                NSLog(@"jsp包下载完成");
                // 解压
                NSString *zipPath = sm.responseObject;
                NSString *unzipPath = _NSString(@"%@/jsp%@", APP.DocumentDirectory, hvm.version);
                [[NSFileManager defaultManager] removeItemAtPath:unzipPath error:nil];
                BOOL ret = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
                // 保存路径（更新成功）
                if (ret) {
                    NSLog(@"解压缩成功");
                    NSString *jspVersion = [NSString stringWithContentsOfFile:_NSString(@"%@/Version.txt", unzipPath) encoding:NSUTF8StringEncoding error:nil];
                    if (jspVersion.length && [(jspVersion = [RSA decryptString:jspVersion]) hasPrefix:hvm.version]) {
                        NSLog(@"校验成功，更新完毕");
                        APP.jspVersion = jspVersion;
                        [JSPatchHelper install];
                    } else {
                        NSLog(@"jsp校验失败，不予更新");
                    }
                } else {
                    NSLog(@"解压缩失败");
                }
            } else {
                NSLog(@"jsp下载失败");
            }
            
            if (completion) {
                completion([APP.jspVersion isEqualToString:hvm.version]);
            }
        };
    };
    
    // 获取版本列表
    NSLog(@"正在查找jsp可用的更新");
    void (^getVersionList)(NSInteger) = nil;
    void (^__block __nextPage)(NSInteger) = getVersionList = ^(NSInteger page) {
        [NetworkManager1 getHotUpdateVersionList:page].completionBlock = ^(CCSessionModel *sm) {
            NSArray *vs = sm.responseObject[@"data"][@"result"];
            NSLog(@"vs = %@", vs);
            NSLog(@"cpVersion = %@", cpVersion);
            NSLog(@"jspVersion = %@", APP.jspVersion);
            if (vs.count) {
                HotVersionModel *newVersion = nil;
                // 比较版本号
                for (NSDictionary *dict in vs) {
                    HotVersionModel *hvm = [HotVersionModel mj_objectWithKeyValues:dict];
                    if ([hvm.version componentsSeparatedByString:@"."].count != 3) {
                        NSLog(@"%@, 版本号不合法", hvm.version);
                        continue;
                    }
                    if ([JSPatchHelper compareVersion:hvm.version newerThanVersion:APP.jspVersion]) {
                        if ([JSPatchHelper compareVersion:hvm.version newerThanVersion:cpVersion]) {
                            NSLog(@"%@ 此jspatch版本比CodePush版本大，忽略此更新", hvm.version);
                            continue;
                        } else {
                            NSLog(@"发现jsp新版本：%@", hvm.version);
                            newVersion = hvm;
                            break;
                        }
                    } else {
                        // 已是最新版本
                        NSLog(@"jsp已是最新版本");
                        return ;
                    }
                }
                if (newVersion) {
                    NSLog(@"下载jsp更新包");
                    downloadPackage(newVersion);
                } else if (vs.count >= 10) {
                    // 未找到可以更新的版本，拉取下一页数据继续找
                    __nextPage(page + 1);
                }
            } else {
                NSLog(@"拉取jsp热更新列表失败，err = %@", sm.error ? : sm.responseObject[@"msg"]);
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
