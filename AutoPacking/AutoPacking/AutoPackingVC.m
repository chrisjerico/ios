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
#import "NSObject+XWAdd.h"

@interface AutoPackingVC ();
@property (weak) IBOutlet NSButton *imgManagerBtn;
@end


@implementation AutoPackingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *autoPackPlist = nil;
    if ([NSUserName() isEqualToString:@"fish"]) {
        autoPackPlist = @"/Users/fish/Desktop/AutoPack.plist";
    }
    else if ([NSUserName() isEqualToString:@"andrew"]) {
         autoPackPlist = @"/Users/andrew/Desktop/AutoPack.plist";//
    }
    else if ([NSUserName() isEqualToString:@"ezer"]) {
        autoPackPlist = @"/Users/ezer/打包程序/AutoPack.plist";
    }
	else if ([NSUserName() isEqualToString:@"xionghx"]) {
        autoPackPlist = @"/Users/xionghx/打包程序/AutoPack.plist";
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
        
        BOOL OpenImageManager = 0; // 图片管理器
        if (OpenImageManager) {
            return;
        }
        
        
        [__self login:dict[@"后台用户名"] pwd:dict[@"后台密码"] completion:^{
            
            BOOL isPack = 1;  // 打包类型：0热更新，1原生iOS
            if (isPack) {
//超级签名后台没有c005，c201
//                NSString *ids = @"a002,c001,c105b,c190,c048,l002,c053,c085,c134,c137,c150,c158,c163,c165,c169,c175,c002,c012,c073,c092,c116,c126,h003b,c035,c035b,c035c,c052,c108,c193,c200,c120,c198,c205,c208,c213,c217,c211,c235,c237,c246,c126b,c225,c245,c251,c252,c254,c257,c259,c261";    // 站点编号(可以批量打包用','号隔开)  注意别删，打全站用
//                NSString *ids = @"a002,c001,c105b,c190,c048,l002,c053,c085,c134,c137,c150,c158,c163,c165,c169,c175,c002,c012,c073,c092,c116,c126,h003b,c035";    //  andrew打包
//                NSString *ids = @"c035b,c035c,c052,c108,c193,c200,c120,c198,c205,c208,c213,c217,c211,c235,c237,c246,c126b,c225,c245,c251,c252,c254,c257,c259,c261";    //  fish打包

                NSString *ids = @"l002";    // 站点编号(可以批量打包用','号隔开)每天上班第一件事打t005
                NSString *branch = @"dev_master";// 分支名dev_master_waitWithdrawal
//                NSString *branch = @"andrew/六合";// 分支名dev_master_waitWithdrawal
                BOOL willUpload = 1;        // 打包后是否上传审核
                // 高权限操作
                BOOL isReview = 0;      // 是否改为已审核
                BOOL isForce = 0;       // 是否强制更新
                NSString *updateLog = @"优化用户体验。";  // 更新日志，给用户看的
                
                [self popupConfirmWithIsReview:isReview isForce:isForce completion:^{
                    [iPack pullCode:branch completion:^(NSString * _Nonnull version) {
                        [iPack startPackingWithIds:ids ver:version willUpload:willUpload isForce:isForce log:updateLog isReview:isReview];
                    }];
                }];
            }
            else {
                NSString *environment = @"master";    //master andrew1 正式环境：master，其他：fish1,fish2,fish3,parker1,...
                NSString *branch = @"shiyu/dev1";    // 分支名：fish/dev1
                
                [RNPack checkEnvironment:environment completion:^(NSString * _Nonnull environment) {
                    [ShellHelper pullCode:RNPack.projectDir branch:branch completion:^(GitModel * _Nonnull gm) {
                        [RNPack pack:gm environment:environment completion:^{}];
                    }];
                }];
            }
        }];
    }];
}

// 弹框确认，避免误操作
- (void)popupConfirmWithIsReview:(BOOL)isReview isForce:(BOOL)isForce completion:(void (^)(void))completion {
    if (!completion) return;
    if (!isReview && !isForce) {
        completion();
        return;
    }
    
    __block BOOL __showed = false;
    void (^showAlert)(void) = ^{
        if (__showed || ![NSApplication sharedApplication].keyWindow) return;
        __showed = true;
        
        NSString *msg = @"";
        if (isReview) {
            msg = [msg stringByAppendingString:@"- 确定要自动改为已审核吗？\n"];
        }
        if (isForce) {
            msg = [msg stringByAppendingString:@"- 确定要强制更新吗？\n"];
        }
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleWarning;
        [alert addButtonWithTitle:@"取消"];
        [alert addButtonWithTitle:@"确定"];
        alert.messageText = msg;
        alert.informativeText = @"温馨提示：请慎重选择";
        
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse returnCode) {
            //        NSLog(@"%d", returnCode);
            if (returnCode == NSAlertSecondButtonReturn) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    completion();
                });
            } else {
                NSLog(@"退出打包程序");
                exit(0);
            }
        }];
    };
    
    [[NSApplication sharedApplication] xw_addObserverBlockForKeyPath:@"keyWindow" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        showAlert();
    }];
    showAlert();
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
    if (!completion) return;
    [NetworkManager1 login:username pwd:pwd].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        if (!sm.error) {
            NSLog(@"登录成功，%@", sm.resObject);

            [[NSUserDefaults standardUserDefaults] setObject:sm.resObject[@"data"][@"loginsessid"] forKey:@"loginsessid"];
            [[NSUserDefaults standardUserDefaults] setObject:sm.resObject[@"data"][@"logintoken"] forKey:@"logintoken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            completion();
        } else {
            NSLog(@"登录失败，%@", sm.error);
        }
    };
}

@end
