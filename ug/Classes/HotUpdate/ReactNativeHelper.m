//
//  ReactNativeHelper.m
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ReactNativeHelper.h"

#import <React/RCTBridge.h>
#import "RCTHTTPRequestHandler.h"

#import "CodePush.h"
#import "RSA.h"

#define CodePushHost @"http://ec2-18-163-2-208.ap-east-1.compute.amazonaws.com:3000/"
#ifdef APP_TEST
#define CodePushKey @"by5lebbE5vmYSJAdd5y0HRIFRcVJ4ksvOXqog"
#else
#define CodePushKey @"67f7hDao71zMjLy5xjilGx0THS4o4ksvOXqog"
#endif




@interface RCTHTTPRequestHandler (RnHelper)

@end

@implementation RCTHTTPRequestHandler (RnHelper)

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}
@end


@interface OCFuncModel : NSObject
@property (nonatomic, strong) NSString *objKey;
@property (nonatomic, strong) NSString *selectors;
@property (nonatomic, strong) NSArray *args1;
@property (nonatomic, strong) NSArray *args2;
@property (nonatomic, strong) NSArray *args3;
@property (nonatomic, strong) NSArray *args4;
@property (nonatomic, strong) NSArray *args5;
@property (nonatomic, strong) NSArray *args6;
@property (nonatomic, strong) NSArray *args7;
@property (nonatomic, strong) NSArray *args8;
@property (nonatomic, strong) NSArray *args9;
- (NSArray *)argsWithIndex:(unsigned int)idx;
@end
@implementation OCFuncModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"objKey":@"obj"};
}
- (NSArray *)argsWithIndex:(unsigned int)idx {
    return idx < 9 ? [self valueForKey:_NSString(@"args%d", idx+1)] : nil;
}
@end



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
    [[ReactNativeHelper shared] sendEventWithName:@"EventReminder" body:[ReactNativeHelper addOnceBlocks:[temp rn_keyValues] key:eventName]];
}

+ (void)selectVC:(NSString *)vcName params:(NSDictionary *)params {
    NSMutableDictionary *temp = @{}.mutableCopy;
    [temp addEntriesFromDictionary:params];
    temp[@"vcName"] = vcName;
    [[ReactNativeHelper shared] sendEventWithName:@"SelectVC" body:[ReactNativeHelper addOnceBlocks:[temp rn_keyValues] key:vcName]];
}

+ (void)removeVC:(NSString *)vcName {
    [[ReactNativeHelper shared] sendEventWithName:@"RemoveVC" body:@{@"vcName":vcName}];
}

+ (void)exit {
    exit(0);
}


#pragma mark - 注册JS函数
//https://blog.csdn.net/future_challenger/article/details/53506779
//宏RCT_EXPORT_METHOD的参数就是这个方法的声明部分，方法体在外面。RCT_EXPORT_METHOD(someMethod:(NSString*)stringParameter)这样的，然后外面写方法体。
//暴露给RN的方法是不能直接返回任何东西的。因为RN的调用时异步的，所以只能使用回调的方式，或者触发事件的方式实现返回值
//因为笔者的项目已经上了async/await了，回调就显得没啥必要了。而且，文档显示。RN也提供了暴露接口返回Promise的支持。只需要在方法里接受两个参数，一个resolver，一个rejecter：
//基本上在项目里如何暴露一个native方法给RN的js调用非常简单，就如上面所述一样。
//1. 在头文件里继承了RCTBridgeModule协议。
//2. 在源文件里使用RCT_EXPORT_MODULE();宏。
//3. 使用宏RCT_EXPORT_METHOD暴露方法。
//通过方法- (dispatch_queue_t)methodQueue来指定。
//https://www.jianshu.com/p/1e75bd387aa0
//async/await特点
//async/await更加语义化，async 是“异步”的简写，async function 用于申明一个 function 是异步的； await，可以认为是async wait的简写， 用于等待一个异步方法执行完成；
//async/await是一个用同步思维解决异步问题的方案（等结果出来之后，代码才会继续往下执行）
//可以通过多层 async function 的同步写法代替传统的callback嵌套

// 注册js模块
RCT_EXPORT_MODULE()

// 注册 callblack
RCT_EXPORT_METHOD(callback:(NSString *)key params:(id)params) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        void (^block)(NSArray *) = _blockDict[key];
        if (block) {
            block([params rn_models]);
            _blockDict[key] = nil;
        }
    });
}

// 注册js函数 performSelectors:returnValue:
RCT_EXPORT_METHOD(performSelectors:(NSArray <NSDictionary *>*)selectors resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        // 保存函数链点返回值做为变量
        NSMutableDictionary *varDict1 = @{}.mutableCopy;
        
        id (^__block __getArg)(OCFuncModel *) = nil;
        
        id (^convertArgs)(id) = nil;
        id (^__block __sub)(id) = convertArgs = ^id (id obj) {
            if ([obj isKindOfClass:[NSArray class]]) {
                NSMutableArray *temp = @[].mutableCopy;
                for (id ele in (NSArray *)obj) {
                    [temp addObject:__sub(ele)];
                }
                return temp;
            }
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *temp = @{}.mutableCopy;
                for (NSString *key in ((NSDictionary *)obj).allKeys) {
                    temp[key] = __sub(obj[key]);
                }
                
                // OCFuncModel->函数返回值
                NSString *selector = temp[@"selectors"];
                if (selector) {
                    return __getArg([OCFuncModel mj_objectWithKeyValues:temp]);
                }
                // NSDictionary->Model
                Class cls = NSClassFromString(temp[@"clsName"]);
                if (cls) {
                    return [cls mj_objectWithKeyValues:temp];
                }
                // NSDictionary->NSValue
                NSString *valueType = temp[@"valueType"];
                if (valueType.length) {
                    if ([valueType isEqualToString:@"CGPoint"]) {
                        return [NSValue valueWithCGPoint:CGPointFromString(temp[@"string"])];
                    }
                    else if ([valueType isEqualToString:@"CGVector"]) {
                        return [NSValue valueWithCGVector:CGVectorFromString(temp[@"string"])];
                    }
                    else if ([valueType isEqualToString:@"CGSize"]) {
                        return [NSValue valueWithCGSize:CGSizeFromString(temp[@"string"])];
                    }
                    else if ([valueType isEqualToString:@"CGRect"]) {
                        return [NSValue valueWithCGRect:CGRectFromString(temp[@"string"])];
                    }
                    else if ([valueType isEqualToString:@"CGAffineTransform"]) {
                        return [NSValue valueWithCGAffineTransform:CGAffineTransformFromString(temp[@"string"])];
                    }
                    else if ([valueType isEqualToString:@"UIEdgeInsets"]) {
                        return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsFromString(temp[@"string"])];
                    }
                    else if ([valueType isEqualToString:@"UIOffset"]) {
                        return [NSValue valueWithUIOffset:UIOffsetFromString(temp[@"string"])];
                    }
                }
                return temp;
            }
            else if ([obj isKindOfClass:[NSString class]]) {
                return varDict1[obj] ? : obj;
            }
            return obj;
        };
        
        
        id (^invoke)(OCFuncModel *) = nil;
        __getArg = invoke = ^id (OCFuncModel *fm) {
            
            // 保存用‘大括号’括起来的变量
            NSMutableDictionary *varDict2 = @{}.mutableCopy;
            int argsIndex = 0;
            id lastRet = nil;
            
            // 用‘分号’拆分函数
            NSArray *selectors = [fm.selectors componentsSeparatedByString:@";"];
            for (NSString *selector in selectors) {
                // 用‘点号’、‘中括号’进一步拆分函数
                NSMutableArray <NSDictionary <NSString *, NSNumber *>*>*sels = @[].mutableCopy;
                for (NSString *path in [selector componentsSeparatedByString:@"."]) {
                    if (!path.length)
                        continue;
                    for (NSString *sel in [path componentsSeparatedByString:@"["]) {
                        [sels addObject:@{[sel stringByReplacingOccurrencesOfString:@"]" withString:@""]:@([sel containsString:@"]"])}];
                    }
                }
                
                // 执行函数
                id ret = nil;
                if ([selector hasPrefix:@"."]) {
                    ret = varDict1[fm.objKey];
                }
                
                for (NSDictionary *dict in sels) {
                    NSString *sel = dict.allKeys.firstObject;
                    BOOL ignoreReturnValue = [dict[sel] boolValue];
                    if (!ret) {
                        ret = NSClassFromString(sel) ? : nil;
                        ret = varDict2[sel] ? : ret;
                        if (ret) {
                            continue;
                        } else {
                            break;
                        }
                    }
                    
                    NSString *var = [sel containsString:@"{"] ? [[sel componentsSeparatedByString:@"{"].lastObject componentsSeparatedByString:@"}"].firstObject : nil;
                    sel = [sel stringByReplacingOccurrencesOfString:_NSString(@"{%@}", var) withString:@""];
                    NSArray *argArray = [sel containsString:@":"] ? [fm argsWithIndex:argsIndex++] : nil;
                    
                    // 转换参数：NSDictionary->Model、OCFuncModel->函数返回值
                    argArray = convertArgs(argArray);
                    
                    id temp = [ret performSelector:NSSelectorFromString(sel) argArray:argArray];
                    // 返回值
                    if (!ignoreReturnValue) {
                        lastRet = ret = temp;
                    }
                    // 保存变量
                    if (var.length) {
                        varDict2[ret] = temp;
                    }
                }
            }
            return lastRet;
        };
        
        // 遍历函数链（一条函数链能执行多个函数）
        for (NSDictionary *d in selectors) {
            NSString *varKey = _NSString(@"OCFuncVariable.%@", d.allKeys.firstObject);
            OCFuncModel *fm = [OCFuncModel mj_objectWithKeyValues:d[d.allKeys.firstObject]];
            varDict1[varKey] = invoke(fm);
        }
        
        // 开始执行函数，返回结果做数据转换(NSDictionary)
        resolve([varDict1[@"OCFuncVariable.ret"] rn_keyValues]);
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
        @"SelectVC",// 用于切换页面
        @"RemoveVC",// 用于移除页面
    ];
}

@end
