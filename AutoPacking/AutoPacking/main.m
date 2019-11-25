//
//  main.m
//  AutoPackingProject
//
//  Created by fish on 2019/11/25.
//  Copyright © 2019 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteModel.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 获取管理员权限
//        {
//            NSLog(@"AuthHelperTool executing self-repair");
//            OSStatus myStatus;
//            AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
//            AuthorizationRef myAuthorizationRef;
//
//            myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
//            if (myStatus != errAuthorizationSuccess)
//                return myStatus;
//
//            AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
//            AuthorizationRights myRights = {1, &myItems};
//            myFlags = kAuthorizationFlagDefaults |
//            kAuthorizationFlagInteractionAllowed |
//            kAuthorizationFlagPreAuthorize |
//            kAuthorizationFlagExtendRights;
//
//            myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, NULL, myFlags, NULL );
//            if (myStatus != errAuthorizationSuccess)
//                return myStatus;
//
//            char *myToolPath = argv[1];
//            char *myArguments[] = {argv[1], "--fix", NULL};
//            FILE *myCommunicationsPipe = NULL;
//
//            myFlags = kAuthorizationFlagDefaults;
//            //这句是获取管理员权限的代码
//            myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, myToolPath, myFlags, myArguments, &myCommunicationsPipe);
//        }
        
#ifdef DEBUG
        [SiteModel startPackaging:@"hcc,c153,c194"];
#else
        [SiteModel startPackaging:@(argv[1])];
#endif
        
        __block SiteModel *__sm = nil;
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyyMMdd-HH:mm"];
        
        // 修改plist文件，替换图标
        void (^packing)(void) = nil;
        void (^__block __packing)(void) = packing = ^{
            __sm = [SiteModel nextSite];
            if (!__sm) {
                NSLog(@"所有站点已打包完毕，退出打包程序！");
                exit(0);
                return ;
            }
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = [NSString stringWithFormat:@"%@/setup.sh", AutoPackingDir];;
            task.arguments = @[__sm.siteId, __sm.appName, __sm.appId, ];
#ifdef DEBUG
            task.arguments = @[__sm.siteId, __sm.appName, __sm.appId, AutoPackingDir,];
#endif
            task.terminationHandler = ^(NSTask *ts) {
                [ts terminate];
                NSLog(@"站点信息配置完成，开始打包");
                
                NSTask *task = [[NSTask alloc] init];
                task.launchPath = [NSString stringWithFormat:@"%@/autopacking.sh", AutoPackingDir];
                task.arguments = @[
                    [__sm.type isEqualToString:@"企业包"] ? @"1" : @"2",
                    [NSString stringWithFormat:@"/Library/WebServer/Documents/%@/%@_%@.ipa", __sm.type, __sm.siteId, [df stringFromDate:[NSDate date]]],
#ifdef DEBUG
                    AutoPackingDir,
#endif
                ];
                task.terminationHandler = ^(NSTask *ts) {
                    [ts terminate];
                    NSLog(@"打包成功");
                    
                    __packing();
                };
                
                dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                    [task launch];
                    [task waitUntilExit];
                });
            };
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"正在配置站点信息...");
                [task launch];
                [task waitUntilExit];
            });
        };
        
        packing();
        while (1) {}
    }
    return 0;
}


