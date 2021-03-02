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
#import "RNCWebView.h"

#define CodePushHost @"http://ec2-18-163-2-208.ap-east-1.compute.amazonaws.com:3000/"


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
        [[CodePushConfig current] setAppVersion:RNCheckVersion1];
        [[CodePushConfig current] setServerURL:CodePushHost];
        [[CodePushConfig current] setDeploymentKey:ReactNativeHelper.currentCodePushKey];
//        [[CodePushConfig current] configuration[@"publicKey"] = ;
        
        
        // ——————修复react-native-webview 移除后重新添加时闪退bug
        // 错误信息：Cannot form weak reference to instance (0x7fab8494e600) of class WKWebView. It is possible that this object was over-released, or is in the process of deallocation.
        // 解决方法：移除时保留webview在内存里面使其能被正常引用（保留3个）
        static NSMutableArray *__wvs = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __wvs = @[].mutableCopy;
        });
        [RNCWebView cc_hookSelector:@selector(removeFromSuperview) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            [__wvs addObject:[ai.instance webView]];
            if (__wvs.count > 3) {
                [__wvs removeFirstObject];
            }
        } error:nil];
        
        
        [CodePushDownloadHandler cc_hookSelector:@selector(download:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            NSLog(@"CodePush原下载地址 = %@", ai.arguments.firstObject);
            NSString *downloadURL = [[CodePushConfig current].serverURL stringByAppendingPathComponent:[NSURL URLWithString:ai.arguments.firstObject].path];
            downloadURL = [downloadURL stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
            downloadURL = [downloadURL stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
            NSLog(@"CodePush替换后的下载地址 = %@", downloadURL);
            [ai.originalInvocation setArgument:&downloadURL atIndex:2];
            [ai.originalInvocation invoke];
        } error:nil];
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

+ (void)downloadNewestPackage:(void (^)(double progress))progress completion:(void (^)(BOOL ret))completion {
    static BOOL once = false;
    if (once) return;
    once = true;
    
    NSDictionary *curPackage = [CodePushPackage getCurrentPackage:nil];
    {
        // 安装已下载好的包
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"downloadedPackage"];
        [CodePushPackage installPackage:dict removePendingUpdate:false error:nil];
//        NSLog(@"已下载的安装包：%@", dict);
//        NSLog(@"当前安装包：%@", curPackage);
    }
    
    // 检查RN更新
    __block int __delay = 1;
    void (^getReactNativePackage)(void) = nil;
    void (^__block __getReactNativePackage)(void) = getReactNativePackage = ^{
        [NetworkManager1 getCodePushUpdate:ReactNativeHelper.currentCodePushKey].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                NSDictionary *dict = sm.resObject[@"update_info"];
                NSMutableDictionary *updatePackage = ({
                    updatePackage = @{}.mutableCopy;
                    for (NSString *key in [dict allKeys]) {
                        updatePackage[[NSString convertToCamelCaseFromSnakeCase:key]] = dict[key];
                    }
                    updatePackage;
                });
                
//                NSLog(@"最新安装包：%@", updatePackage);
                if (![curPackage[@"packageHash"] isEqualToString:updatePackage[@"packageHash"]]) {
                    NSString *expectedBundleFileName = @"main.jsbundle";
                    NSString *publicKey = nil;
                    [CodePushPackage downloadPackage:updatePackage expectedBundleFileName:expectedBundleFileName publicKey:publicKey operationQueue:dispatch_get_main_queue() progressCallback:^(long long expectedContentLength, long long receivedContentLength) {
                        if (progress)
                            progress(receivedContentLength/(double)expectedContentLength);
                    } doneCallback:^{
                        NSLog(@"RN下载成功");
                        NSError *err = nil;
                        [CodePushPackage installPackage:updatePackage removePendingUpdate:false error:&err];
#ifdef APP_TEST
                        if (err) [AlertHelper showAlertView:@"热更新失败，请联系开发" msg:err.domain btnTitles:@[@"确定"]];
#endif
                        NSLog(@"安装成功，当前安装包：%@", [CodePushPackage getCurrentPackage:nil]);
                        [[NSUserDefaults standardUserDefaults] setObject:updatePackage forKey:@"downloadedPackage"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        if (completion)
                            completion(true);
                    } failCallback:^(NSError *err) {
                        // 获取ip信息
                        [NetworkManager1 getIp].completionBlock = ^(CCSessionModel *ipSM, id resObject, NSError *err) {
                            NSDictionary *ipAddress = ipSM.resObject[@"data"] ? : @{};
                            NSString *ipInfo = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:ipAddress options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                            NSString *log = _NSString(@"ip地址：%@\n错误类型：%@", ipInfo, err);
                            NSString *title = _NSString(@"%@%@", ipAddress[@"country"], ipAddress[@"region"]);
                            // 上传日志
                            [NetworkManager1 uploadLog:log title:title tag:@"rn更新包下载失败"];
                        };
                        
#ifdef APP_TEST
                        [AlertHelper showAlertView:@"热更新失败，请联系开发" msg:err.domain btnTitles:@[@"确定"]];
#endif
                        if (completion)
                            completion(false);
                    }];
                } else {
                    NSLog(@"当前已是最新版本！");
                    if (completion)
                        completion(true);
                }
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(__delay++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __getReactNativePackage();
                });
            }
        };
    };
    __getReactNativePackage();
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
    temp[@"rnAction"] = @"jump";
    [[ReactNativeHelper shared] sendEventWithName:@"SelectVC" body:[ReactNativeHelper addOnceBlocks:[temp rn_keyValues] key:vcName]];
}

+ (void)pushVC:(NSString *)vcName params:(NSDictionary *)params {
    NSMutableDictionary *temp = @{}.mutableCopy;
    [temp addEntriesFromDictionary:params];
    temp[@"vcName"] = vcName;
    temp[@"rnAction"] = @"push";
    [[ReactNativeHelper shared] sendEventWithName:@"SelectVC" body:[ReactNativeHelper addOnceBlocks:[temp rn_keyValues] key:vcName]];
}

+ (void)refreshVC:(NSString *)vcName params:(NSDictionary *)params {
    NSMutableDictionary *temp = @{}.mutableCopy;
    [temp addEntriesFromDictionary:params];
    temp[@"vcName"] = vcName;
    temp[@"rnAction"] = @"refresh";
    [[ReactNativeHelper shared] sendEventWithName:@"SelectVC" body:[ReactNativeHelper addOnceBlocks:[temp rn_keyValues] key:vcName]];
}

+ (void)leaveVC:(NSString *)vcName params:(NSDictionary *)params {
    NSMutableDictionary *temp = @{}.mutableCopy;
    [temp addEntriesFromDictionary:params];
    temp[@"vcName"] = vcName;
    temp[@"rnAction"] = @"blur";
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
                    else if ([valueType isEqualToString:@"RNBlock"]) {
                        NSString *bt = temp[@"string"];
                        bt = [bt stringByReplacingOccurrencesOfString:@"Object" withString:@"1"];
                        bt = [bt stringByReplacingOccurrencesOfString:@"Number" withString:@"0"];
                        NSString *event = temp[@"event"];
                        if ([bt isEqualToString:@"0"]) {
                            return ^(double v1) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":@(v1)}];
                            };
                        } else if ([bt isEqualToString:@"1"]) {
                            return ^(NSObject *o1) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":o1}];
                            };
                        } else if ([bt isEqualToString:@"0,0"]) {
                            return ^(double v1, double v2) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":@(v1), @"1":@(v2)}];
                            };
                        } else if ([bt isEqualToString:@"1,1"]) {
                            return ^(NSObject *o1, NSObject *o2) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":o1, @"1":o2}];
                            };
                        } else if ([bt isEqualToString:@"1,0"]) {
                            return ^(NSObject *o1, double v1) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":o1, @"1":@(v1)}];
                            };
                        } else if ([bt isEqualToString:@"0,1"]) {
                            return ^(double v1, NSObject *o1) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":@(v1), @"1":o1}];
                            };
                        } else if ([bt isEqualToString:@"0,0,0"]) {
                            return ^(double v1, double v2, double v3) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":@(v1), @"1":@(v2), @"2":@(v3)}];
                            };
                        } else if ([bt isEqualToString:@"0,1,1"]) {
                            return ^(double v1, NSObject *o1, NSObject *o2) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":@(v1), @"1":o1, @"2":o2}];
                            };
                        } else if ([bt isEqualToString:@"0,1,0"]) {
                            return ^(double v1, NSObject *o1, double v2) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":@(v1), @"1":o1, @"2":@(v2)}];
                            };
                        } else if ([bt isEqualToString:@"0,0,1"]) {
                            return ^(double v1, double v2, NSObject *o1) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":@(v1), @"1":@(v2), @"2":o1}];
                            };
                        } else if ([bt isEqualToString:@"1,0,0"]) {
                            return ^(NSObject *o1, double v1, double v2) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":o1, @"1":@(v1), @"2":@(v2)}];
                            };
                        } else if ([bt isEqualToString:@"1,1,1"]) {
                            return ^(NSObject *o1, NSObject *o2, NSObject *o3) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":o1, @"1":o2, @"2":o3}];
                            };
                        } else if ([bt isEqualToString:@"1,1,0"]) {
                            return ^(NSObject *o1, NSObject *o2, double v1) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":o1, @"1":o2, @"2":@(v1)}];
                            };
                        } else if ([bt isEqualToString:@"1,0,1"]) {
                            return ^(NSObject *o1, double v1, NSObject *o2) {
                                [ReactNativeHelper sendEvent:event params:@{@"0":o1, @"1":@(v1), @"2":o2}];
                            };
                        }
                    }
                    return [NSNull null];
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

// RN版本更新完毕
RCT_EXPORT_METHOD(launchFinish) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [ReactNativeHelper launchFinish];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRnVersionUpdateFinish" object:nil];
    });
}
// RN启动成功
+ (void)launchFinish {
    for (void (^b)(BOOL waited) in [ReactNativeHelper shared].launchFinishBlocks) {
        b(true);
    }
    [ReactNativeHelper shared].launchFinishBlocks = nil;
}

// 注册js常量
- (NSDictionary *)constantsToExport {
    return @{
        // 发布环境Key
        @"CodePushKey": ReactNativeHelper.currentCodePushKey,
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

+ (NSDictionary <NSString *, NSString *>*)allCodePushKey {
    return @{
        @".dev本地代码":@"LocalCode",
        @".master":@"67f7hDao71zMjLy5xjilGx0THS4o4ksvOXqog",
        @"_fish/dev1":@"vwZ46SpQTllu7Abj1G87cR3YeMBQ4ksvOXqog",
        @"_fish/dev2":@"DuCk6Xw9lnn6FPrnGaPFNAx1kWhw4ksvOXqog",
        @"_fish/dev3":@"iLFD6XqccMoxB815X7jSTD2FuAVa4ksvOXqog",
        @"_tars/dev1":@"Ie1KY7PxCnh3hZTBzNtboLPXngWb4ksvOXqog",
        @"_tars/dev2":@"Fjz5DvNVI9Ys6t03oB4NBAzSCNtO4ksvOXqog",
        @"_tars/dev3":@"x5uUsG1y1tzV1XPCXxdP68aTf1fZ4ksvOXqog",
        @"_ezer/dev1":@"F2WjxOH2AYoNreuPfF0xpNKCnMJ54ksvOXqog",
        @"_ezer/dev2":@"WMRzGoSYNjP5K6kbeevDyF8K62IY4ksvOXqog",
        @"_ezer/dev3":@"NL33yBkA1X96DaiEqDMyhNWS8xAA4ksvOXqog",
        @"_andrew/dev1":@"e9jfQgbriVQEL2GYvlhg7J4kiYnW4ksvOXqog",
        @"_andrew/dev2":@"5JnX4XYmWjRG1t4YuKKt8ZAMeVCA4ksvOXqog",
        @"_andrew/dev3":@"ev1LRvu8FpvRaTVCE6JPTSJpoYL34ksvOXqog",
        @"a002": @"iaSI4okfkRlB8wXVKMUTCMEitmYb4ksvOXqog",
        @"c001": @"8QmjutQYWePbzC8ChRgCSGaR2hhB4ksvOXqog",
        @"c002": @"0fgUHhzdmLyEvHdMoPuZOD0F5Du44ksvOXqog",
        @"c006": @"VR3LgeUHoFwXsYlZF4xV4GfbyYrl4ksvOXqog",
        @"c012": @"ZurU83NExX1d3z9i3gMs1AnApSVB4ksvOXqog",
        @"c018": @"SWWowOvXZFBzA51QT9T0EJvxTqzl4ksvOXqog",
        @"c035": @"V0V7ifQhwulss0olO02YAOjM8ZsB4ksvOXqog",
        @"c035b": @"RB0tUpS0mtiuf0HZRRqOQHKZrXPR4ksvOXqog",
        @"c035c": @"N07DK7z8WGhgtZpUly9ID9YUgfHG4ksvOXqog",
        @"c048": @"HTwe4joVbx7AsFAwkuci1OO1UwGp4ksvOXqog",
        @"c052": @"8syufclyfT9AZ04viyg4xwGJTAf24ksvOXqog",
        @"c053": @"aEqCquLxuawzkH7neYkN0dh1DpIs4ksvOXqog",
        @"c073": @"KWWu6nurIPrOE0FOCFVimnzMDMUh4ksvOXqog",
        @"c084": @"I99Wcm9peNFSbOzIDeRVqdziJgkp4ksvOXqog",
        @"c085": @"a6kpJwjOJj4C2gKib87JWaS2RhcH4ksvOXqog",
        @"c092": @"Otcd2DTGK4IDHnFthgt0jrUAvRk24ksvOXqog",
        @"c105b": @"271hxFuAq6OU4yxvrgz9qId4pAsq4ksvOXqog",
        @"c108": @"7sImFPhNhNQvPcFUINXAYkYuvViy4ksvOXqog",
        @"c114": @"8rlyBWkzJVpkelxQNIeXZjtw4Qwv4ksvOXqog",
        @"c115": @"TOhSYQrtEQJFbg3BP7JG845APkE14ksvOXqog",
        @"c116": @"KI1deBMQAKnNziQR4zUW6RYdc4af4ksvOXqog",
        @"c117": @"OtAiocFH9MSTQR3DsmDDMhau71054ksvOXqog",
        @"c120": @"tsNxGhObDgOHlb3yfc3aWq5iGRr24ksvOXqog",
        @"c126": @"jJSxgtPyIpT8AHXTOO7wcjI5DF1n4ksvOXqog",
        @"c126b": @"neFkvhqDr9fRh3xvIIbeVugEobDI4ksvOXqog",
        @"c134": @"g2QFKrVt7lxkCBUSUOsh61iPyYLw4ksvOXqog",
        @"c137": @"IZ4PcvoADGIQ5TM8lNvRrbAuQRdM4ksvOXqog",
        @"c141": @"i1xgBTn3R9FSPWJ1YRGHpCnYGpwo4ksvOXqog",
        @"c150": @"0L3y96UH9t160R21YKpqTYCWwoXf4ksvOXqog",
        @"c153": @"wlko3T3TTZWnaFk5yy82uHLti6nm4ksvOXqog",
        @"c158": @"mzfnn7GureDwzyTIYS5gpemFA2n14ksvOXqog",
        @"c163": @"ovQJ5YMyLYkdjFnjjym0sAqHqyWr4ksvOXqog",
        @"c165": @"o2d3kBQCVeSKZUUxyLn9yIfjsUsE4ksvOXqog",
        @"c169": @"i3eRdnyXzkrec5HFPbesrXnJxbaP4ksvOXqog",
        @"c175": @"01naK7VpEXb4bwpFvARXME9Jr0qW4ksvOXqog",
        @"c186": @"QxKQKOwveHAaBdrIt7pMRfhbttwQ4ksvOXqog",
        @"c190": @"N4H2NVCue6Xo0zONIdAhBhSJ18xP4ksvOXqog",
        @"c193": @"eGnM5HMCaCcLreDSoObzyTZbBJSN4ksvOXqog",
        @"c198": @"9Uqwe3Zs0nOzctJliZvwXxQqhrQG4ksvOXqog",
        @"c200": @"ZqwfOJaS1R973bOPgwFtA01rclxX4ksvOXqog",
        @"c201": @"yrsHtPt3wnYbHS6hwQz60GaTgafl4ksvOXqog",
        @"c205": @"QoxN8swKKpN5HTMss5dO2qBt94EW4ksvOXqog",
        @"c208": @"tNZAkdh071I2hLU0MA7gRdYW83HK4ksvOXqog",
        @"c211": @"MJGvkLPhlJJfo5OGUh0eXL76uJ2C4ksvOXqog",
        @"c213": @"zPlAOGLGcW4Ap4Asg4txtSJbfPKR4ksvOXqog",
        @"c217": @"Hcq50yuvDjROgWY1CltiD4XM7LF14ksvOXqog",
        @"c225": @"0am3VtCtodzzAxmKVOcnRh9kgnSa4ksvOXqog",
        @"c235": @"6aJewjtLuYS1ugY0JAPCTF3Rd9rm4ksvOXqog",
        @"c237": @"7kL1eATIXlS2IXbLBJ3NOxpAMpoS4ksvOXqog",
        @"c239b": @"waelR75jAa59Z6CNIapR7MaGKBcM4ksvOXqog",
        @"c242": @"5wx1XlEZBshmgpDiRPrhmNa9yojj4ksvOXqog",
        @"c245": @"LoUEoNLb8gXz6P7YuWYz8cKW9e274ksvOXqog",
        @"c246": @"G06EF3FC6xtoZSrfP2fA4H9LD8nc4ksvOXqog",
        @"c251": @"qxwLkd7XqzszpTbBqXrO3QXPnj0D4ksvOXqog",
        @"c252": @"spzTpSgi5H7ebn9SV7pZ4XV4oZl54ksvOXqog",
        @"c254": @"NQoF3CTLMIK3l34dlDCUTeVcmUUG4ksvOXqog",
        @"c257": @"YmkUvFvTTxCKblY9MxGBASL7XGkc4ksvOXqog",
        @"h003b": @"6Ezn6jgJhZnOwslpQCeBp2hDFO6b4ksvOXqog",
        @"l002": @"3pcbblg7f9ZygsdecDisvV2LwTRv4ksvOXqog",
    };
}

+ (NSString *)currentCodePushKey {
#ifdef APP_TEST
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"CodePushKey"] ? : self.allCodePushKey[@".master"];
#else
    return @"67f7hDao71zMjLy5xjilGx0THS4o4ksvOXqog";    
#endif
}

+ (void)setCurrentCodePushKey:(NSString *)currentCodePushKey {
    [[NSUserDefaults standardUserDefaults] setObject:currentCodePushKey forKey:@"CodePushKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
