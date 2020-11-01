//
//  ReactNativePack.m
//  AutoPacking
//
//  Created by fish on 2020/6/25.
//  Copyright © 2020 fish. All rights reserved.
//

#import "ReactNativePack.h"
#import "ShellHelper.h"

#import <UserNotifications/UserNotifications.h>

@interface ReactNativePack ()
@property (nonatomic, strong) GitModel *gm;
@property (nonatomic, readonly) NSString *jspatchDir;       /**<   jspatch文件目录 */
@property (nonatomic, readonly) NSString *jspExportDir;     /**<   jspatch导出目录 */
@property (nonatomic, copy) NSString *logFile;      /**<   ipa发包记录 */
@end


@implementation ReactNativePack

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self class] new];
    });
    return obj;
}

- (void)setupPlist:(NSDictionary *)dict {
    _projectDir = dict[@"打包项目路径"];
    _jspatchDir = [_projectDir stringByAppendingPathComponent:@"js/jspatch"];
    _jspExportDir =  [dict[@"导出目录"] stringByAppendingPathComponent:@"js"];
    _privateKey = [NSTemporaryDirectory() stringByAppendingString:@"/.privateKey"];
    _logFile = [NSString stringWithFormat:@"%@/RN发包记录.txt", dict[@"日志项目路径"]];
    [dict[@"私钥"] writeToFile:_privateKey atomically:true encoding:NSUTF8StringEncoding error:nil];
}

- (void)checkEnvironment:(NSString *)environment completion:(void (^)(NSString *environment))completion {
    environment = [environment isEqualToString:@"master"] ? @"UGiOS" : environment;
    
    // 获取CodePush版本号判断是否已发布成功
    [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"RnInfo" ofType:@"sh"]
                             arguments:@[environment]
                            completion:^(OutputModel * _Nonnull om) {
        if ([om.output1 containsString:@"Error"]) {
            assert(!@"CodePush错误，请在检查发布环境名是否正确。".length);
            return ;
        }
        if (![om.output1 containsString:@"Update Metadata"]) {
            assert(!@"CodePush错误，请在命令行登录CodePush。".length);
            return ;
        }
        if (completion) {
            completion(environment);
        }
    }];
}


#pragma mark - 发布热更新

- (void)pack:(GitModel *)gm environment:(NSString *)environment completion:(void (^)(void))completion {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *description = _NSString(@"（%@）%@ ｜ 分支：%@ - %@ - %@", NSUserName(), [df stringFromDate:[NSDate date]], gm.branch, gm.commitId, gm.log);
    [self postReactNative:description environment:environment completion:^{
        NSString *log = _NSString(@"（%@）%@ | 环境：%@ | 分支：%@ - %@ - %@", NSUserName(), [df stringFromDate:[NSDate date]], [environment stringByReplacingOccurrencesOfString:@"UGiOS" withString:@"master"], gm.branch, gm.commitId, gm.log);
        NSString *title = _NSString(@"（%@）环境：%@ | 分支：%@ - %@ - %@", NSUserName(), [environment stringByReplacingOccurrencesOfString:@"UGiOS" withString:@"master"], gm.branch, gm.commitId, gm.log);
        [self saveLog:log title:title completion:^(BOOL ok) {
            NSLog(@"热更新发布成功");
            NSLog(@"退出程序！");
            exit(0);
        }];
    }];
}

- (void)postReactNative:(NSString *)log environment:(NSString *)environment completion:(void (^)(void))completion {
    NSString *rncv = [environment isEqualToString:@"UGiOS"] ? RNCheckVersion2 : @"1.1.1";
    // 提交rn资源包
    NSLog(@"准备打包rn代码");
    [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"7codepush" ofType:@"sh"]
                             arguments:@[self.projectDir, rncv, log, environment, RNPack.privateKey, ]
                            completion:^(OutputModel * _Nonnull om) {
        // 获取CodePush版本号判断是否已发布成功
        [NSTask launchedTaskWithLaunchPath:[[NSBundle mainBundle] pathForResource:@"RnInfo" ofType:@"sh"]
                                 arguments:@[environment]
                                completion:^(OutputModel * _Nonnull om) {
            if ([om.output1 containsString:@"Error"]) {
                assert(!@"CodePush错误，请在检查发布环境名是否正确。".length);
                return ;
            }
            if (![om.output1 containsString:@"Update Metadata"]) {
                assert(!@"CodePush错误，请在命令行登录CodePush。".length);
                return ;
            }
            NSLog(@"打印版本信息：\n%@", om.output1);
            
            NSString *ProductionLog = nil;
            NSString *StagingLog = ({
                StagingLog = [[om.output1 componentsSeparatedByString:@"Description:"].lastObject componentsSeparatedByString:@"└"].firstObject;
                StagingLog = [[StagingLog stringByReplacingOccurrencesOfString:@"│" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
                StagingLog = [StagingLog stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                StagingLog;
            });
            NSString *checkLog = [[log stringByReplacingOccurrencesOfString:@"│" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (![StagingLog isEqualToString:checkLog]) {
                assert(!@"rn打包失败（请排查：1代码无法编译通过；2代码内容相同无法重复提交；）。".length);
            }
            if (completion) {
                completion();
            }
        }];
    }];
}


#pragma mark - 上传发包记录
// 保存发包记录
- (void)saveLog:(NSString *)log title:(NSString *)title completion:(void (^)(BOOL ok))completion {
    NSLog(@"提交打包日志");
    [ShellHelper pullCode:self.logFile.stringByDeletingLastPathComponent branch:@"rn/packLog" completion:^(GitModel * _Nonnull _) {
        [self saveString:log toFile:self.logFile];
        [ShellHelper pushCode:self.logFile.stringByDeletingLastPathComponent title:title completion:^{
            NSLog(@"发包记录提交成功");
            if (completion) {
                completion(true);
            }
        }];
    }];
}

// 写入字符串到文件末尾
- (void)saveString:(NSString *)string toFile:(NSString *)filePath {
    string = [@"\n" stringByAppendingString:string];
    
    // 写入文件末尾
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [@"——————————————\n    发包记录\n——————————————\n\n" writeToFile:filePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

@end
