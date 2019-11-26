//
//  ShellHelper.m
//  AutoPacking
//
//  Created by fish on 2019/11/26.
//  Copyright © 2019 fish. All rights reserved.
//

#import "ShellHelper.h"

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
    [df setDateFormat:@"yyyyMMdd-HH:mm"];
    
    
    void (^startPacking)(void) = nil;
    void (^__block __next)(void) = startPacking = ^{
        SiteModel *sm = sites.firstObject;
        [sites removeObject:sm];
        
        NSString *ipaPath = [NSString stringWithFormat:@"%@/build/ug.ipa", ProjectDir];
        NSString *xcarchivePath = [NSString stringWithFormat:@"%@/build/ug.xcarchive", ProjectDir];
        
        if (!sm) {
            NSLog(@"所有站点已打包完毕，退出打包程序！");
            if (completion) {
                completion();
            }
            return ;
        }
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = [NSString stringWithFormat:@"%@/2setup.sh", ShellDir];;
        task.arguments = @[sm.siteId, sm.appName, sm.appId, ProjectDir, ];
        task.terminationHandler = ^(NSTask *ts) {
            [ts terminate];
            NSLog(@"%@ 站点信息配置完成，开始打包", sm.siteId);
            
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = [NSString stringWithFormat:@"%@/3packing.sh", ShellDir];
            task.arguments = @[[sm.type isEqualToString:@"企业包"] ? @"1" : @"2", ProjectDir, ];
            task.terminationHandler = ^(NSTask *ts) {
                [ts terminate];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:ipaPath]) {
                    NSString *outputPath1 = [NSString stringWithFormat:@"/Library/WebServer/Documents/%@/%@_%@.ipa", sm.type, sm.siteId, [df stringFromDate:[NSDate date]]];
                    NSString *outputPath2 = [NSString stringWithFormat:@"/Library/WebServer/Documents/%@/%@_%@.xcarchive", sm.type, sm.siteId, [df stringFromDate:[NSDate date]]];
                    [[NSFileManager defaultManager] moveItemAtPath:ipaPath toPath:outputPath1 error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:xcarchivePath toPath:outputPath2 error:nil];
                    NSLog(@"%@ 打包成功", sm.siteId);
                } else {
                    NSLog(@"%@ 打包失败", sm.siteId);
                }
                __next();
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
}

@end
