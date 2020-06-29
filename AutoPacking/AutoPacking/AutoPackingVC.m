//
//  AutoPackingVC.m
//  AutoPacking
//
//  Created by fish on 2019/12/3.
//  Copyright © 2019 fish. All rights reserved.
//   23424234324

#import "AutoPackingVC.h"
#import "iOSPack.h"
#import "ReactNativePack.h"

@implementation AutoPackingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *autoPackPlist = nil;
    if ([NSUserName() isEqualToString:@"fish"]) {
        autoPackPlist = @"/Users/fish/Desktop/AutoPack.plist";
    }
    else{
         autoPackPlist = @"/Users/ug/Desktop/AutoPack.plist";
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:autoPackPlist]) {
        assert(!@"plist文件不存在".length);
    }
    
    __weakSelf_(__self);
    [self readPlist:autoPackPlist completion:^(NSDictionary *dict) {
        [iPack setupPlist:dict];
        [RNPack setupPlist:dict];
        
        [__self login:dict[@"后台用户名"] pwd:dict[@"后台密码"] completion:^{
            
            BOOL isPack = 1;  // 打包类型：0热更新，1原生iOS
            if (isPack) {
                NSString *ids = @"a002,c190,c048,c105b,c228,c018";    // 站点编号(可以批量打包用','号隔开)  c175  c008 c049
                NSString *branch = @"dev_master";// 分支名
                BOOL willUpload = 1;        // 打包后是否上传审核
                
                [iPack pullCode:branch completion:^(NSString * _Nonnull version) {
                    [iPack startPackingWithIds:ids version:version willUpload:willUpload];
                }];
            }
            else {
                NSString *log = @"（无更新3）";    // 更新日志
                NSString *environment = @"fish";    // 正式环境：master，其他：fish1,fish2,fish3,parker1,...
                NSString *branch = @"fish/dev1";    // 分支名：fish/dev1
                
                [RNPack checkEnvironment:environment log:log completion:^(NSString * _Nonnull environment, NSString * _Nonnull log) {
                    [RNPack getCurrentVersionWithEnvironment:environment completion:^(NSString * _Nonnull version) {
                        [RNPack pullCode:branch completion:^{
                            [RNPack pack:version environment:environment log:log completion:^{
                                [[NSUserDefaults standardUserDefaults] setObject:log forKey:@"log"];
                            }];
                        }];
                    }];
                }];
            }
        }];
    }];
}

// 读取plist
- (void)readPlist:(NSString *)plistFile completion:(void (^)(NSDictionary *dict))completion {
    [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"ReadPlist" ofType:@"sh"]
                             arguments:@[plistFile]
                            completion:^(OutputModel * _Nonnull om) {
        if (!om.output1.length) {
            assert(!@"plist文件为空".length);
            return;
        }
        // 解析 plistString 并转换成 NSDcitionary
        NSString *string = [[om.output1 substringToIndex:om.output1.length-3] substringFromIndex:6];
        NSMutableArray *keyValues = @[].mutableCopy;
        NSMutableString *fullString = @"".mutableCopy;
        for (NSString *temp in [string componentsSeparatedByString:@"\n    "]) {
            if ([temp containsString:@" = "]) {
                [keyValues addObject:temp];
                fullString = temp.mutableCopy;
            } else {
                [fullString appendString:temp];
            }
        }
        NSMutableDictionary *dict = @{}.mutableCopy;
        for (NSString *temp in keyValues) {
            NSString *key = [temp componentsSeparatedByString:@" = "].firstObject;
            NSString *value = [temp componentsSeparatedByString:@" = "].lastObject;
            dict[key] = value;
        }
        if (dict.count < 5) {
            assert(!@"plist文件错误".length);
            return;
        }
        if (completion) {
            completion(dict);
        }
    }];
}

// 登录
- (void)login:(NSString *)username pwd:(NSString *)pwd completion:(void (^)(void))completion {
    [NetworkManager1 getInfo:@"123"].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            if (completion)
                completion();
        }
        else if (sm.error.code == 12) {
            [NetworkManager1 login:username pwd:pwd].completionBlock = ^(CCSessionModel *sm) {
                if (!sm.error) {
                    NSLog(@"登录成功，%@", sm.responseObject);
                    [[NSUserDefaults standardUserDefaults] setObject:sm.responseObject[@"data"][@"loginsessid"] forKey:@"loginsessid"];
                    [[NSUserDefaults standardUserDefaults] setObject:sm.responseObject[@"data"][@"logintoken"] forKey:@"logintoken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                    if (completion)
                        completion();
                } else {
                    NSLog(@"登录失败，%@", sm.error);
                }
            };
        } else {
            NSLog(@"登录失败，%@", sm.error);
        }
    };
}

@end
