//
//  JSPatchHelper.m
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JSPatchHelper.h"
#import "SSZipArchive.h"


@interface HotVersionModel : NSObject
@property (nonatomic) NSString *version; /**<   版本号 */
@property (nonatomic) NSString *title2; /**<   文件下载地址 */
@property (nonatomic) NSString *title3; /**<   更新日志 */
@property (nonatomic) NSString *title0; /**<   发布时间 */
@property (nonatomic) BOOL title4; /**<   0静默更新 1强制更新 */
@property (nonatomic) BOOL title5; /**<  1 ios ，2 android */
@end


@implementation JSPatchHelper

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // japatch 解密
        
    });
}

+ (void)updateVersion:(NSString *)cpVersion completion:(void (^)(BOOL))completion {
    
    // 下载完成后解压
    void (^downloadPackage)(HotVersionModel *) = ^(HotVersionModel *hvm) {
        CCSessionModel *sm = [NetworkManager1 lhcdoc_getUserInfo:@""];
        sm.progressBlock = ^(NSProgress *progress) {
            
        };
        sm.completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                // 解压
                
                // 保存路径（更新成功）
                APP.jspVersion = @"";
//                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JSPatch热更新版本号"];
            }
        };
    };
    
    // 获取版本列表
    void (^getVersionList)(NSInteger) = nil;
    void (^__block __nextPage)(NSInteger) = getVersionList = ^(NSInteger page) {
        [NetworkManager1 lhdoc_fansList:@"" page:page].completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                NSArray *vs = sm.responseObject[@"data"];
                
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
                        return ;
                    }
                }
                if (newVersion) {
                    downloadPackage(newVersion);
                } else if (vs.count >= 10) {
                    // 未找到可以更新的版本，拉取下一页数据继续找
                    __nextPage(page + 1);
                }
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
