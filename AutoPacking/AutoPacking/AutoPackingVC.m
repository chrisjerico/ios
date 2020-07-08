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
    else if ([NSUserName() isEqualToString:@"andrew"]) {
         autoPackPlist = @"/Users/andrew/打包程序/AutoPack.plist";
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
        NSLog(@"后台用户名 =%@",dict[@"后台用户名"]);
        NSLog(@"后台密码 =%@",dict[@"后台密码"]);
        
        [__self login:dict[@"后台用户名"] pwd:dict[@"后台密码"] completion:^{
            
            BOOL isPack = 1;  // 打包类型：0热更新，1原生iOS
            if (isPack) {
//                NSString *ids = @"a002,c001,c005,c105b,c190,c201,c048,l001,c228,c018,l002,h005,c053,c085,c134,c137,c141,c150,c151,c158,c163,c165,c166,c169,c173,c175,c177,c002,c091,c084,c049,c011,c012,c073,c092,c116,c126,c129,h003b,c192,c194,c184,c035,c035b,c035c,c047,c052,c054,c108,c193,c200,c202,c120,c006,c198,c008,c199,c203,c205,c208,c212,c213,c216,c217,c211,c230,c233,c235";    // 站点编号(可以批量打包用','号隔开)  注意别删，打全站用
                
                NSString *ids = @"test60f";    // 站点编号(可以批量打包用','号隔开)  c175  c008 c049
                NSString *branch = @"dev_master";// 分支名
                BOOL willUpload = 1;        // 打包后是否上传审核
                BOOL checkStatus = 0;      // 上传后是否审核  1时只能有bigadmin的账号，否则没权限
                
                [iPack pullCode:branch completion:^(NSString * _Nonnull version) {
                    [iPack startPackingWithIds:ids version:version willUpload:willUpload  checkStatus:checkStatus];
                }];
            }
            else {
                NSString *log = @"（无更新3）";    // 更新日志
                NSString *environment = @"andrew1";    // 正式环境：master，其他：fish1,fish2,fish3,parker1,...
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
            NSLog(@"username = %@",username);
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
        }
        else {
            NSLog(@"获取APP信息失败，%@", sm.error);
        }
    };
}

@end
