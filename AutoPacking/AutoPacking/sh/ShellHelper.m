//
//  ShellHelper.m
//  AutoPacking
//
//  Created by fish on 2019/11/26.
//  Copyright © 2019 fish. All rights reserved.
//

#import "ShellHelper.h"

@implementation ShellHelper

// rsa加密
+ (void)encrypt:(NSArray<NSString *> *)stringArray privateKey:(NSString *)privateKey completion:(void (^)(NSArray<NSString *> * _Nonnull))completion {
    if (!stringArray.count) {
        assert(!@"字符串为空。".length);
    }
    // 遍历加密字符串列表
    NSMutableArray *temp = stringArray.mutableCopy;
    NSMutableArray *okStrings = @[].mutableCopy;
    __block NSString *__orString = nil;
    void (^startEncrypt)(void) = nil;
    void (^__block __next)(void) = startEncrypt = ^{
        if (!__orString) {
            __orString = temp.firstObject;
            [temp removeObject:__orString];
        }
        if (!__orString) {
            NSLog(@"所有字符串已加密完毕！");
            if (completion) {
                completion(okStrings);
            }
            return ;
        }
        
        NSMutableArray *substrings = ({
            substrings = @[].mutableCopy;
            NSUInteger loc = 0;
            NSUInteger len = 100;    // 分段加密长度（最大只能100多一点）
            while (loc < __orString.length) {
                [substrings addObject:[__orString substringWithRange:NSMakeRange(loc, MIN(__orString.length - loc, len))]];
                loc += len;
            }
            substrings;
        });
        
        // 分段加密，每段之间用\n隔开（因为rsa无法加密太长的字符串）
        [self encryptSubstrins:substrings privateKey:privateKey completion:^(NSArray<NSString *> *rets) {
            NSLog(@"完整的字符串加密完成");
            [okStrings addObject:[rets componentsJoinedByString:@"\n"]];
            __orString = nil;
            __next();
        }];
    };
    
    startEncrypt();
}

// rsa加密
+ (void)encryptSubstrins:(NSArray<NSString *> *)substrings privateKey:(NSString *)privateKey completion:(void (^)(NSArray<NSString *> * _Nonnull))completion {
    if (!substrings.count) {
        assert(!@"字符串为空。".length);
    }
    // 遍历加密字符串列表
    NSMutableArray *temp = substrings.mutableCopy;
    NSMutableArray *okStrings = @[].mutableCopy;
    __block NSString *__orString = nil;
    void (^startEncrypt)(void) = nil;
    void (^__block __next)(void) = startEncrypt = ^{
        if (!__orString) {
            __orString = temp.firstObject;
            [temp removeObject:__orString];
        }
        if (!__orString) {
            NSLog(@"-分割出来的字符串加密完成！");
            if (completion) {
                completion(okStrings);
            }
            return ;
        }
//        NSLog(@"__orString= %@",__orString);
        [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"0encrypt" ofType:@"sh"]
                                 arguments:@[__orString, privateKey]
                                completion:^(OutputModel * _Nonnull om) {
            NSString *ret = om.output1;
            if (!ret.length) {
                assert(!@"js分段加密为空。".length);
            }
            [okStrings addObject:ret];
            __orString = nil;
            __next();
        }];
    };
    
    startEncrypt();
}



+ (void)clean:(NSString *)path completion:(void (^)(void))completion {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = [[NSBundle mainBundle] pathForResource:@"6clean" ofType:@"sh"];
    task.arguments = @[path,];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        NSLog(@"清空完毕.");
        if (completion) {
            completion();
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"清空所有改动...");
        [task launch];
        [task waitUntilExit];
    });
}

// 拉取最新代码
+ (void)pullCode:(NSString *)projectPath branch:(NSString *)branch completion:(void (^)(GitModel *gm))completion {
    NSLog(@"拉取最新代码...");
    [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"1pull" ofType:@"sh"]
                             arguments:@[projectPath, branch]
                            completion:^(OutputModel * _Nonnull om) {
        if (!om.output1.length) {
            assert(!@"【1pull.sh脚本】拉取代码失败，请尝试命令行是否能正常执行。".length);
            return ;
        }
        NSLog(@"拉取完毕");
        if (completion) {
            NSString *commitId = [om.output1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *log = [[om.output2 stringByReplacingOccurrencesOfString:@"\n" withString:@""] componentsSeparatedByString:@"(1):      "].lastObject;
            NSString *number = [om.output3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            GitModel *gm = [GitModel new];
            gm.path = projectPath;
            gm.branch = branch;
            gm.commitId = commitId;
            gm.log = log;
            gm.number = number;
            completion(gm);
        }
    }];
}

// 提交代码
+ (void)pushCode:(NSString *)path title:(NSString *)title completion:(void (^)(void))completion {
    if (!title.length) {
        title = @"发包";
    }
    [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"5push" ofType:@"sh"]
                             arguments:@[path, title,]
                            completion:^(OutputModel * _Nonnull om) {
        NSLog(@"提交发包记录");
        if (completion) {
            completion();
        }
    }];
}

// 批量打包
+ (void)iosPacking:(NSString *)projectPath sites:(NSArray <SiteModel *> *)_sites version:(NSString *)version completion:(void (^)(NSArray <SiteModel *>*okSites))completion {
    NSMutableArray *sites = _sites.mutableCopy;
    NSMutableArray *okSites = @[].mutableCopy;
    for (SiteModel *sm in sites) {
        sm.retryCnt = 1;
    };
    
    __block SiteModel *__sm = nil;
    void (^startPacking)(void) = nil;
    void (^__block __next)(void) = startPacking = ^{
        if (!__sm) {
            __sm = sites.firstObject;
            [sites removeObject:__sm];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:__sm.xcarchivePath]) {
                NSLog(@"已存在 %@ 安装包，无需再次打包", __sm.siteId);
                [okSites addObject:__sm];
                __sm = nil;
                __next();
                return;
            }
        }
        if (!__sm) {
            if (okSites.count < _sites.count) {
                NSMutableArray *errs = [_sites mutableCopy];
                [errs removeObjectsInArray:okSites];
                NSLog(@"所有站点已打包完毕，其中 %@ 站点打包失败！", [[errs valueForKey:@"siteId"] componentsJoinedByString:@","]);
            } else {
                NSLog(@"所有站点已打包完毕！");
            }
            if (completion) {
                completion(okSites);
            }
            return ;
        }
        
        NSLog(@"Path.projectDir = %@", projectPath);
        [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"2setup" ofType:@"sh"]
                                 arguments:@[projectPath, __sm.siteId, __sm.appName, version, __sm.appId, ]
                                completion:^(OutputModel * _Nonnull om) {
            // 注释掉APP_TEST
            if (![__sm.type isEqualToString:@"内测包"]) {
                NSString *filePath = _NSString(@"%@/ug/Classes/Helper/FishUtility/define/AppDefine.h", projectPath);
                NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                content = [content stringByReplacingOccurrencesOfString:@"#define APP_TEST" withString:@"//#define APP_TEST"];
                [content writeToFile:filePath atomically:true encoding:NSUTF8StringEncoding error:nil];
            }
            
            NSLog(@"%@ 站点信息配置完成，开始打包", __sm.siteId);
            NSLog(@"%@ ", __sm.type);
            BOOL isEnterprise = [@"企业包,内测包" containsString:__sm.type];
            NSString *tempIpa = [NSString stringWithFormat:@"%@/ug.ipa", projectPath];
            NSString *tempXcarchive = [NSString stringWithFormat:@"%@/ug.xcarchive", projectPath];
            [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"3packing" ofType:@"sh"]
                                     arguments:@[projectPath, isEnterprise ? @"2" : @"1",]
                                    completion:^(OutputModel * _Nonnull om) {
                NSLog(@"__sm.ipaPath = %@",__sm.ipaPath);
                if ([[NSFileManager defaultManager] fileExistsAtPath:tempIpa]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:__sm.ipaPath.stringByDeletingLastPathComponent withIntermediateDirectories:true attributes:nil error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.ipaPath error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:__sm.xcarchivePath error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:tempIpa toPath:__sm.ipaPath error:nil];
                    [[NSFileManager defaultManager] moveItemAtPath:tempXcarchive toPath:__sm.xcarchivePath error:nil];
                    NSLog(@"%@ 打包成功", __sm.siteId);
                    [okSites addObject:__sm];
                    __sm = nil;
                } else {
                    if (!__sm.retryCnt--) {
                        __sm = nil;
                        NSLog(@"%@ 打包失败", __sm.siteId);
                    } else {
                        NSLog(@"%@ 打包失败，再试一次", __sm.siteId);
                    }
                }
                [ShellHelper clean:projectPath completion:^{
                    __next();
                }];
            }];
        }];
    };
    
    startPacking();
}

// 配置plist文件
+ (void)setupPlist:(NSString *)plistFile sm:(SiteModel *)sm ipaUrl:(NSString *)ipaUrl completion:(void (^)(void))completion {
    NSString *logoUrl = _NSString(@"https://app.pindanduo.cn/img/%@/%@.png", sm.uploadNum, sm.uploadNum);
    
    [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"4plist" ofType:@"sh"]
                             arguments:@[plistFile, ipaUrl, logoUrl, sm.appId, sm.appName,]
                            completion:^(OutputModel * _Nonnull om) {
        if (completion) {
            completion();
        }
    }];
}

@end
