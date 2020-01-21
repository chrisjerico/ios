//
//  ReactNativeHelper.m
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ReactNativeHelper.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>

#import "CodePush.h"
#import "RSA.h"


@interface NSBundle (AA)

@end
@implementation NSBundle (AA)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSBundle jr_swizzleMethod:@selector(infoDictionary) withMethod:@selector(cc_infoDictionary) error:nil];
    });
}
- (NSDictionary *)cc_infoDictionary {
    if (self == [NSBundle mainBundle]) {
        NSMutableDictionary *infoDict = [self cc_infoDictionary].mutableCopy;
        infoDict[@"CodePushDeploymentKey"] = @"67f7hDao71zMjLy5xjilGx0THS4o4ksvOXqog";
#ifdef APP_TEST
        infoDict[@"CodePushDeploymentKey"] = @"by5lebbE5vmYSJAdd5y0HRIFRcVJ4ksvOXqog";
#endif
        infoDict[@"CodePushServerURL"] = @"http://ec2-18-163-2-208.ap-east-1.compute.amazonaws.com:3000/";
//        infoDict[@"CodePushPublicKey"] = RSA.publicKey;
        return infoDict;
    }
    return [self cc_infoDictionary];
}
@end





@interface ReactNativeHelper ()<RCTBridgeModule>
@property (nonatomic) void (^didUpdateFinish)(NSString *);
@end

@implementation ReactNativeHelper

CCSharedImplementation

- (void)updateVersion:(void (^)(NSString *))completion {
    _didUpdateFinish = completion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [APP.Window insertSubview:[ReactNativeHelper vcWithName:@"UpdateVersion" params:@{@"willUpdate":@true}].view atIndex:0];
    });
}

+ (UIViewController *)vcWithName:(NSString *)name params:(NSDictionary *)params {
    NSURL *bundleURL = [CodePush bundleURL];
#ifdef DEBUG
    bundleURL = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    if (APP.isFish) {
        bundleURL = [NSURL URLWithString:@"http://192.168.2.1:8081/index.bundle?platform=ios"];
    }
#endif
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:bundleURL moduleName:name initialProperties:[ReactNativeHelper conversion:params] launchOptions:nil];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = rootView;
    return vc;
}

+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params {
    NSMutableDictionary *temp = @{}.mutableCopy;
    [temp addEntriesFromDictionary:params];
    temp[@"_EventName"] = eventName;
    [[ReactNativeHelper shared] sendEventWithName:@"EventReminder" body:temp];
}

#pragma mark -

+ (id)conversion:(id)obj {
    // 是否是数据模型类
    BOOL (^isModelClass)(id) = ^BOOL (id obj) {
        Class temp = [obj class];
        while (temp) {
            if (temp == [NSObject class])
                return true;
            if ([NSBundle bundleForClass:temp] != NSBundle.mainBundle)
                return false;
            temp = [temp superclass];
        }
        return true;
    };
    
    // 把数据模型转换为Dictionary
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *temp = @[].mutableCopy;
        for (id ele in (NSArray *)obj) {
            if (isModelClass(obj)) {
                [temp addObject:[ele mj_keyValues]];
            } else {
                [temp addObject:ele];
            }
        }
        return temp;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = obj;
        NSMutableDictionary *temp = @{}.mutableCopy;
        for (NSString *key in dict.allKeys) {
            id val = dict[key];
            if (isModelClass(obj)) {
                temp[key] = [obj mj_keyValues];
            } else {
                temp[key] = val;
            }
        }
        return temp;
    } else if (isModelClass(obj)) {
        return [obj mj_keyValues];
    }
    return obj;
}


#pragma mark - 注册JS函数

// 注册js模块
RCT_EXPORT_MODULE();

// 注册js函数 push
RCT_EXPORT_METHOD(push:(NSString *)page params:(NSDictionary *)params) {
    UIViewController *vc = _LoadVC_from_storyboard_(page);
    if (!vc) {
        vc = [NSClassFromString(page) new];
    }
    for (NSString *key in params.allKeys) {
        [vc setValue:params[key] forKey:key];
    }
    [NavController1 pushViewController:vc animated:true];
}

// 注册js函数 pop
RCT_EXPORT_METHOD(pop) {
    [NavController1 popViewControllerAnimated:true];
}

// 注册js函数 performSelectors:returnValue:
RCT_EXPORT_METHOD(performSelectors:(NSMutableArray <NSDictionary *>*)selectors returnValue:(RCTResponseSenderBlock)returnValue) {
    selectors = selectors.mutableCopy;
    
    id ret = NSClassFromString(selectors.firstObject[@"class"]);
    for (NSDictionary *dict in selectors) {
        NSString *path = dict[@"selector"];
        if ([path containsString:@"."]) {
            for (NSString *selector in [path componentsSeparatedByString:@"."]) {
                ret = [ret performSelector:NSSelectorFromString(selector) argArray:nil];
            }
        } else {
            ret = [ret performSelector:NSSelectorFromString(dict[@"selector"]) argArray:dict[@"args"]];
        }
    }
    ret = [ReactNativeHelper conversion:ret];
    
    if ([ret isKindOfClass:[NSArray class]]) {
        returnValue(ret);
    } else {
        returnValue(@[ret]);
    }
}

// 注册js 函数（版本更新完毕）
RCT_EXPORT_METHOD(updateFinish) {
    NSString *version = [CodePushPackage getCurrentPackage:nil][@"description"];
    NSLog(@"rn版本号 = %@", version);
    if ([ReactNativeHelper shared].didUpdateFinish) {
        [ReactNativeHelper shared].didUpdateFinish(version);
    }
}

// 注册js常量
- (NSDictionary *)constantsToExport {
    return @{
        // 发布环境Key
        @"CodePushKey": [NSBundle mainBundle].infoDictionary[@"CodePushDeploymentKey"],
    };
}

// 注册js事件
- (NSArray<NSString *> *)supportedEvents {
    return @[@"EventReminder"];
}

@end
