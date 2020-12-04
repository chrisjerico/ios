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
#ifdef APP_TEST
        if (![@"67f7hDao71zMjLy5xjilGx0THS4o4ksvOXqog,by5lebbE5vmYSJAdd5y0HRIFRcVJ4ksvOXqog" containsString:ReactNativeHelper.currentCodePushKey]) {
            [[CodePushConfig current] setAppVersion:@"1.1.1"];
        }
#endif
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
        @"a002": @"NvWd2a9glPunOO5sX9EUCt2hn5kWkpVXGP8d2",
        @"a002_t": @"lUSg1gwbZlsiH-eoGjLa0DRv1Ulca51LXuOua",
        @"c001": @"C2jO6fsZXXSbGdyP-jOK0Uv37LedntR3pvECI",
        @"c001_t": @"8JTT1MIWJ1YjBvtYUWX27oJyMOOFKsIvd68QA",
        @"c002": @"gH8bMMpn612gAirieTKJo5O8qoXTd5KKJnH0p",
        @"c002_t": @"f-RJJJ6yQyvl1rTGL35J0LkTJjxTXsv9up5EU",
        @"c006": @"9OdQB_20NrMIvVHJ09rWhqGgyJgBeFoCm_JwY",
        @"c006_t": @"JxWlupnzoHCVKu62pqGCm_Kq7a45DiNzDGx5n",
        @"c012": @"qbk0VmPhvMu6ATW-9q-7bZALaWGgSFBF2ye2n",
        @"c012_t": @"mC_-66MNMdKvdW9cA8MSDGUhFrft_G3vVd5cj",
        @"c018": @"zuJs9dop0jV8OoOibMwVMx_6Rxn5z-iLemYkD",
        @"c018_t": @"dJXcge18mfLXVau5yAvi5Ljf6Or-Fxl2BPuSq",
        @"c035": @"_0IIw9zysCiGKsgghk4UE3rn62wMpxk6pQTyA",
        @"c035_t": @"3ANHX34vzfH5rm8ATKcYiRm3cYWQcAwJqGk9E",
        @"c035b": @"j7i8rqUZzzM6dubQQkCat5eOgAKnoa_H9hvQn",
        @"c035b_t": @"mpA9XEb2_n-NKJCqF_ZEWuTm-qT7QBl6xlu3z",
        @"c035c": @"aImVMqKqWjknMDbS7F0IvyyooNUImz9WcVGiO",
        @"c035c_t": @"t2fWmw_cUoUJtWYXzlNVvbsaMd5xoOBVQNCNH",
        @"c048": @"GX2sU9Tnjl8lI629wNPsXXp9YB8H6UHXW4g6u",
        @"c048_t": @"ypum-XMFS53js_lZlroy6TxHrhQhBYZa4cSZa",
        @"c052": @"DKGF2YBUyeLySCHL33h2pGb8Ap5pUqgcnNexF",
        @"c052_t": @"6j4D_45uPaHPjTAlNHafP6NeIGO5U4pFdDwzV",
        @"c053": @"mtOMiLQHaEXp1YU4jNST6xISMGRakkFZexYH3",
        @"c053_t": @"ANITNvQHqjAmxNObraTHcFKEliO0tLRsNNjxw",
        @"c073": @"iWhmspp_K7c4VHQsHAB9952LmWmlteCqb5Pn9",
        @"c073_t": @"73C3PyfUCoWTRpVXdLmSCs2dgDXHnkogr7iAC",
        @"c084": @"nK2S0NHnXsNBBsMvTC4VLnkcoeEXowj5XJGML",
        @"c084_t": @"D3hlLp-4fby42dX_ygFqn0fNG1HkNx2nDc7z6",
        @"c085": @"F0un729p56ddFK_dNbpKH8wDG0N9n24XqpGC-",
        @"c085_t": @"nXDEjKxFIAf7XQa2wsYXIwySgfGk37eDwsJW1",
        @"c092": @"_7SFJyyffklBtmf17hcb9lLKErJYvIhIVDTkZ",
        @"c092_t": @"KHuwupIO7mtgyJLgrEYG3d6FiEl0E3ZXgHyRp",
        @"c105b": @"noprAP1CTec9mic6zWT3CaBeLa5VVJJZLOq64",
        @"c105b_t": @"Lr6sJ8lrytBCURSQPWRu56zh5iwDQHuqXxBY4",
        @"c108": @"eyiErGGwv6z6XEevyQLaFrxd-ze6ilK2rXo_I",
        @"c108_t": @"rFooz1F7WwqqG5qqP_NCrBNfOLNefcONRV-DK",
        @"c114": @"4uWjH31FVoBvIeSeiJ6EwLPqsVEoqJvO_lbhn",
        @"c114_t": @"hnQiA8883YVgygKWWlGcghLQJ1gZvGYhh8_kI",
        @"c115": @"_1TVem5MamWJ-Bmtbh5twnOVwVnnDIoFxR6yU",
        @"c115_t": @"oOfb0fDGvidMOr52QI7oztmiW7_8_pc2bPGfu",
        @"c116": @"D83uKmziZSgY8bsZUfukZyXKmebRNkLcU9RWd",
        @"c116_t": @"_4quVLeNAE7EWIbrQePV2VeLSSzbEFOTVKtec",
        @"c117": @"KfgKlpVuqzrNNkTMF_jwrIWEkwwqj1EKZwlVK",
        @"c117_t": @"_gO5MuKDnApNF_kjuWpqoLBXKDexZAg6zojBm",
        @"c120": @"zDLhYV_42AjuiSRySwHP6MmsHEf3DflGIw0mc",
        @"c120_t": @"C54o3ImDKVegTBErCSph401UbPZsG3qucmnNp",
        @"c126": @"pYwdON6wbh-JTxNd-rZoi_29A_bP5u-Y3k3J8",
        @"c126_t": @"klwWn8E7HA9UdqaQCbfyh2P9Ap7gZ41G_ZyGQ",
        @"c126b": @"HSp-K2NPfHB9obr3AHSvgx2OGeguUAvsRN__w",
        @"c126b_t": @"Ia4dOhYnxm32fp2UWJxmNUpR5BGDorE24FzG2",
        @"c134": @"keeYqOUOjfZyeo4T1vSGGjfF5LV5H4LypdbP1",
        @"c134_t": @"2rN7yxmmRMSsRlPoyaKjFGFQC29Kt2_FzaY69",
        @"c137": @"Zs4MG-jXIJ6aK1P7fSvL2w4Deh85xSkL04LDX",
        @"c137_t": @"TUxjpt26dklY8cdyj-0MevlWn09I5XMgkyHDG",
        @"c141": @"yqhHgxbuOl6XZbuHoPY1evaBfLUGkZKtCe75b",
        @"c141_t": @"8DdzZjy8oIArfVBrlTfyt7FbhU37DEVtv3PUc",
        @"c150": @"bZfIfstiND-kMjOEtPi5f8TGAY6PjXWH6xgyv",
        @"c150_t": @"32Ih-bAYRXK2urGYgaV_2LtS0OVEysIxncxfo",
        @"c153": @"_3CreRT5C5yewBRas1h5qto0plq-RnE2CXmZZ",
        @"c153_t": @"bGrQz6Rj8bgzj5wmwPwiJaWFL-onQ1-bmNpae",
        @"c158": @"8CmFC5iztZbK7cv0w4G-p8zJN1jj-ouf8guOE",
        @"c158_t": @"30Z2PU6FEg6Br2VVZo8Ie9PFkUxukUWKE5NyV",
        @"c163": @"wDlmaEKif7Q5zrcNmLfF3n9QH_V037m9X702z",
        @"c163_t": @"vrFdNn_QyHbq1B5VsIV5H7UP_qMxSIZ4WSGDR",
        @"c165": @"u6O7FYPUUshqwfCDvLMhCJCSrioVmLidhjuEv",
        @"c165_t": @"AgcIcJTOf66UafLpbVGQd3S9xQNznyNKcoG0t",
        @"c169": @"D22tR5g38OBX9hp-_yPYNoaL_5C_Q7rAKmrRE",
        @"c169_t": @"1oQHcN3-IEDGk8_msax3juRaLRfQPzpfJ5cT_",
        @"c175": @"exRzaV1JFxpOcrF2xdE7O_JAvTG34H39tIFhC",
        @"c175_t": @"U0NezmxrTuWmTLy_LNh5TJS9eTmtLh2uZlri0",
        @"c186": @"CUjTvNyqo6fm7HXDe6Mqh7dSRmIU6e-rWeRCC",
        @"c186_t": @"No46PvBafe9fMoKKp_6A-DzGx3HFV0JYXyOEG",
        @"c190": @"CkSXxdQuQyyKfvEjUIC_PDe8L4Ex5cDP4d1Lc",
        @"c190_t": @"zSBBdd04hSZveAlfnNrFBH9H7bYwZh68SjGRY",
        @"c193": @"81uDElbS5iVBcYgexbV6W-sOBrvDhD-QbH-HE",
        @"c193_t": @"nSg6w7rw5_O7BZOHF5TRYj3QNHtTk_Gn0oK2u",
        @"c198": @"dw0Q1S9cK6b0W8_HzfFECxotDF5jQRPnoUka-",
        @"c198_t": @"uERTpAGMAJVQgavMSaR7SgPFYSCW5h19Zk0bB",
        @"c200": @"D-UwiPqsVtRgEvrEEt0viZTXOn27BWjNwySXe",
        @"c200_t": @"OykgfdNfgKzQURij1iZ1GOdK07tR9YJC36M6L",
        @"c201": @"FjQDsIgi-JFfADhXVYkN1EB3GXHe5v12TtlXR",
        @"c201_t": @"9D5jLrpYo1he5SDTBAzOWGHcSHQwbHMW3um9s",
        @"c205": @"feWU3gLzrmvaEYINvEQdsDqC6lPWDJtJJ2su7",
        @"c205_t": @"kTOe5uhtHq_wgBTyJYi9WjPbSRpWn98MzI4sG",
        @"c208": @"63Ab9vJUpipT7yOEFA8etGrfaMUq_z9xVOAP6",
        @"c208_t": @"o9EvMxBeYnxcHLVy2FDV9Dsb7xG5VCF5_IA9X",
        @"c211": @"XzJxHa9mQw-IxNakzSMI_nkJ-XrDC4LwEGDNZ",
        @"c211_t": @"_Ro3OJ9bDDkPm1uOzUoCgKVVT1byu3xSTXNYl",
        @"c213": @"7C0EtbLvv8ciCrO_bZITzEli1-GlLapk4kjeh",
        @"c213_t": @"wBvHE5eQPUb3z3iptisnJx2RKQamX6gkhBLRk",
        @"c217": @"2jJFmNBgop2IgSa6XzLXCoRo4P6d5jGCTPxW7",
        @"c217_t": @"8hXmAfQx1DsRkLV7Ro_2vwl4KLpkSThY7XYNx",
        @"c225": @"264WAJZ1fWZRuCyJ09MCMawzWfO_ai_bjsk8y",
        @"c225_t": @"EwuuWZSjH_yu4ptiPByQ3homRgtPvbse3_dVs",
        @"c235": @"Ac_epwlEWNxVxUV7MEVkEgXimVLU_M5Nr5hKJ",
        @"c235_t": @"w-vKnnxLaqqd60mxr2VLb7986DeCamqZct9Wq",
        @"c237": @"3oOjAwExGGQVG1zzNWqBz9qulpWlesNc9Vhcs",
        @"c237_t": @"Rhakx00JlWUyVx0Fr49bUZVrpc48TVG3nS6ee",
        @"c239b": @"ysU__ifbv9RLSLmTmBLCN73QZ1mpJdfeOG6Dy",
        @"c239b_t": @"1ZGSDblG-H_ngleJYdTMWGIP1VbK1TH_ODXON",
        @"c242": @"m9AELTP9d6iNx3ZnZQ55XsM5fX2e1xMBxs2Rd",
        @"c242_t": @"QWNqIgMOw9BXXWuqhvdQfAbjsz4RSMPmZkbRL",
        @"c245": @"Im1OXo9hPAqgADJm2KX76Q8AnlM47eDcPjRjX",
        @"c245_t": @"8soSwl5BnO1K0StCPwIxuVB6iiQu9RQ0m30RL",
        @"c246": @"UySOfAA4xy0gY455sUS8LeCzrRqXWt7x9DRl_",
        @"c246_t": @"jYNqTiKAnufiC2Ca4f9WOj9ynF8_2PpJwMsxY",
        @"c251": @"mApJfVAD-iAvcrJbfND4gcY5cmvMIIiorBFey",
        @"c251_t": @"To8E7CEsDkjlbl6uLF5pqwFYVtc5k-I4rcS3S",
        @"c252": @"7KiW2uiMsY77_dl_dg1z9ea4S4UG15wJq5MHE",
        @"c252_t": @"59qN3JXPB3SphQI2jf4XD6kNGSrkvsarpdpkE",
        @"c254": @"M5g2RlqAjKg2j17ab1M_cYptY55nlWcnPug-t",
        @"c254_t": @"dG_r_gqC5fcf1_Rj9G6TYsBdgrSM8kLm69OfC",
        @"c257": @"atMFEk6JRnT4rNK37jUWfeZBfgY4T95fuj_2u",
        @"c257_t": @"rJbohAhNiT2S3B4IxFYcSG8miQ0L4vVW9wlGk",
        @"h003b": @"3S8Hmu97neFuWtVlj4mFLJvmyhokEXxLw6_CY",
        @"h003b_t": @"2z2RIJGSCtNMsNKVt1yQVQSpIJtOevy-wlr9s",
        @"l002": @"5X5ckx4HLP8Ako-K5EIVmj3eiSA_Ih3FIxQ49",
        @"l002_t": @"d52KElzGUgQsK8LHsOojWSS7mgsPOqMB0Uv9i",
    };
}

+ (NSString *)currentCodePushKey {
#ifdef APP_TEST
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"CodePushKey"] ? : self.allCodePushKey[@"a002"];
#else
    return self.allCodePushKey[APP.Host] ? : @"NvWd2a9glPunOO5sX9EUCt2hn5kWkpVXGP8d2";
#endif
}

+ (void)setCurrentCodePushKey:(NSString *)currentCodePushKey {
    [[NSUserDefaults standardUserDefaults] setObject:currentCodePushKey forKey:@"CodePushKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
