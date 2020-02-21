//
//  ReactNativeHelper.m
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ReactNativeHelper.h"

#import <React/RCTBridge.h>

#import "CodePush.h"
#import "RSA.h"


#define CodePushHost @"http://ec2-18-163-2-208.ap-east-1.compute.amazonaws.com:3000/"
#ifdef APP_TEST
#define CodePushKey @"by5lebbE5vmYSJAdd5y0HRIFRcVJ4ksvOXqog"
#else
#define CodePushKey @"67f7hDao71zMjLy5xjilGx0THS4o4ksvOXqog"
#endif



@interface CodePushConfig (CodePushSetup)
@end
@implementation CodePushConfig (CodePushSetup)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[CodePushConfig current] setAppVersion:@"1.1.1"];
        [[CodePushConfig current] setServerURL:CodePushHost];
        [[CodePushConfig current] setDeploymentKey:CodePushKey];
//        [[CodePushConfig current] configuration[@"publicKey"] = ;
    });
}
@end



@interface ReactNativeHelper ()<RCTBridgeModule>
@property (nonatomic, strong) NSMutableArray *launchFinishBlocks;
@end

@implementation ReactNativeHelper

static id _instace;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)shared {
    static ReactNativeHelper *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
        obj.launchFinishBlocks = @[].mutableCopy;
    });
    return obj;
}

+ (void)waitLaunchFinish:(void (^)(BOOL))finishBlock {
    if (finishBlock) {
        if ([ReactNativeHelper shared].launchFinishBlocks) {
            [[ReactNativeHelper shared].launchFinishBlocks addObject:finishBlock];
        } else {
            finishBlock(false);
        }
    }
}


static NSMutableDictionary *_blockDict = nil;

+ (id)addOnceBlocks:(id)blocks key:(NSString *)key {
    id (^setupBlocks)(NSString *, id) = nil;
    id (^__block __sub)(NSString *, id) = setupBlocks = ^id (NSString *bKey, id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *temp = [obj mutableCopy];
            for (int i=0; i<[obj count]; i++) {
                bKey = [bKey stringByAppendingFormat:@"[%d]", i];
                temp[i] = __sub(bKey, obj[i]);;
            }
            return temp;
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *temp = [obj mutableCopy];
            for (NSString *key in [obj allKeys]) {
                bKey = [bKey stringByAppendingFormat:@".%@", key];
                temp[key] = __sub(bKey, obj[key]);
            }
            return temp;
        }
        else if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _blockDict = @{}.mutableCopy;
            });
            _blockDict[bKey] = obj;
            return bKey;
        }
        return obj;
    };
    return setupBlocks(key, blocks);
}

+ (void)sendEvent:(NSString *)eventName params:(id)params {
    NSMutableDictionary *temp = @{}.mutableCopy;
    temp[@"_EventName"] = eventName;
    temp[@"params"] = params;
    [[ReactNativeHelper shared] sendEventWithName:@"EventReminder" body:[ReactNativeHelper addOnceBlocks:temp key:eventName]];
}

+ (void)selectViewController:(NSString *)vcName params:(NSDictionary *)params {
    NSMutableDictionary *temp = @{}.mutableCopy;
    [temp addEntriesFromDictionary:params];
    temp[@"vcName"] = vcName;
    [[ReactNativeHelper shared] sendEventWithName:@"SelectViewController" body:[ReactNativeHelper addOnceBlocks:temp key:vcName]];
}

+ (void)exit {
    exit(0);
}


#pragma mark - 注册JS函数

// 注册js模块
RCT_EXPORT_MODULE()

// 注册 push
RCT_EXPORT_METHOD(push:(NSString *)page params:(NSDictionary *)params) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIViewController *vc = _LoadVC_from_storyboard_(page);
        if (!vc) {
            vc = [NSClassFromString(page) new];
        }
        for (NSString *key in params.allKeys) {
            [vc setValue:[params[key] rn_models] forKey:key];
        }
        [NavController1 pushViewController:vc animated:true];
    });
}

// 注册 pop
RCT_EXPORT_METHOD(pop) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [NavController1 popViewControllerAnimated:true];
    });
}

// 注册 callblack
RCT_EXPORT_METHOD(callback:(NSString *)key params:(id)params) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        void (^block)(NSArray *) = _blockDict[key];
        if (block) {
            block([params rn_models]);
        }
    });
}

// 注册js函数 performSelectors:returnValue:
RCT_EXPORT_METHOD(performSelectors:(NSArray <NSDictionary *>*)selectors resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_sync(dispatch_get_main_queue(), ^{
#warning 暂不支持返回值为基本数据类型
        id (^invoke)(NSArray <NSDictionary *>*) = nil;
        id (^__block __getArg)(NSArray <NSDictionary *>*) = invoke = ^id (NSArray <NSDictionary *>*selectors) {
            
            id ret = NSClassFromString(selectors.firstObject[@"class"]);
            for (NSDictionary *dict in selectors) {
                
                // 参数是函数返回值的情况处理
                NSMutableArray *argArray = [dict[@"args"] mutableCopy];
                for (int i=0; i<argArray.count; i++) {
                    id arg = argArray[i];
                    if ([arg isKindOfClass:[NSDictionary class]] && dict[@"class"] && arg[@"selector"]) {
                        argArray[i] = __getArg(@[arg]);
                    } else if ([arg isKindOfClass:[NSArray class]] && [arg firstObject][@"class"] && [arg firstObject][@"selector"]) {
                        argArray[i] = __getArg(arg);
                    }
                }
                
                // 调用函数
                NSString *path = dict[@"selector"];
                if ([path containsString:@"."]) {
                    NSArray *paths = [path componentsSeparatedByString:@"."];
                    for (int i=0; i<paths.count; i++) {
                        ret = [ret performSelector:NSSelectorFromString(paths[i]) argArray:(i < paths.count - 1 ? nil : argArray)];
                    }
                } else {
                    ret = [ret performSelector:NSSelectorFromString(dict[@"selector"]) argArray:argArray];
                }
            }
            return ret;
        };
        // 开始执行函数，返回结果做数据转换(NSDictionary)
        resolve([invoke(selectors) rn_keyValues]);
    });
}

RCT_EXPORT_METHOD(launchFinish) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        for (void (^b)(BOOL waited) in [ReactNativeHelper shared].launchFinishBlocks) {
            b(true);
        }
        [ReactNativeHelper shared].launchFinishBlocks = nil;
    });
}

// 注册js常量
- (NSDictionary *)constantsToExport {
    return @{
        // 发布环境Key
        @"CodePushKey": CodePushKey,
    };
}

// 注册js事件
- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"EventReminder",   // 其他
        @"SelectViewController",// 用于切换页面
    ];
}

@end
