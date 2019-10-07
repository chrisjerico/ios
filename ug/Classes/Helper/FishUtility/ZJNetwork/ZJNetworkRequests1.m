//
//  ZJNetworkRequests1.m
//  Consult
//
//  Created by fish on 2017/10/26.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "ZJNetworkRequests1.h"
#import "AFNetworking.h"
#import "ZJNetworkRequests1+HTTPS.h"

@interface ZJNetworkRequests1 ()<ZJRequestDelegate>
@property (readonly) NSDictionary *publicParams;            /**<    公共参数 */
@end

@implementation ZJNetworkRequests1

+ (instancetype)sharedManager {
    static id obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}


#pragma mark - ZJRequestDelegate

- (void)requestCompletionAndWillCallBlock:(ZJSessionModel *)sm {
    // 执行 请求完成后的通用操作
    // ...
    //    NSLog(@"url = %@", sObj.urlString);
    //    NSLog(@"params = %@", sObj.params);
    //    NSLog(@"error = %@", sObj.error);
    //    NSLog(@"response = %@", sObj.responseObject);
    
    if (sm.error) {
        if ([sm.responseObject[@"data"] isKindOfClass:[NSString class]]) {
            NSMutableDictionary *dict = [sm.responseObject mutableCopy];
            dict[@"data"] = nil;
            sm.responseObject = dict;
        }
    }
}
#pragma mark 生成错误信息
// 把 “HTTP请求成功，但服务器返回操作失败” 的情况生成错误信息NSError
- (NSError *)validationError:(ZJSessionModel *)sObj {
    // 请求失败
    if (sObj.error) {
        NSLog(@"❌ 请求 URLString：%@ 失败！发送参数：%@\n 参数的 JSON 字符串为：%@\n ERROR 的系统信息为：\n%@\n", sObj.urlString, sObj.params, sObj.params.mj_JSONString, sObj.error);
        if ([sObj.error.domain isEqualToString:@"NSURLErrorDomain"])
            return [NSError errorWithDomain:@"当前网络连接异常，请检查一下你的网络设置。" code:sObj.error.code userInfo:sObj.error.userInfo];
        if ([sObj.error.domain containsString:@".error."])
            return [NSError errorWithDomain:@"服务器连接异常，请你在“我的-使用帮助-联系客服”中与我们联系。" code:sObj.error.code userInfo:sObj.error.userInfo];
        return [NSError errorWithDomain:@"当前网络连接异常，请检查一下你的网络设置。" code:sObj.error.code userInfo:sObj.error.userInfo];
        NSError *error = sObj.error.userInfo[@"NSUnderlyingError"] ? : sObj.error;
        return [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] ? : error.domain code:sObj.error.code userInfo:sObj.error.userInfo];
    }
    
    // 非P咖服务器则返nil
    if (![sObj.urlString hasPrefix:APP.HOST])
        return nil;
    
    id responseObject = sObj.responseObject;

    // 返回数据格式错误
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
         NSLog(@"❌ 请求 URLString：%@ 失败！发送参数：%@\n 参数的 JSON 字符串为：%@\n 返回参数为：%@\n ⭕️ responseObject 不是 NSDictionary 类。", sObj.urlString, sObj.params, sObj.params.mj_JSONString, responseObject);
        return [NSError errorWithDomain:@"数据格式错误。" code:-1 userInfo:nil];
    }
    
    // 业务逻辑错误 code!=false
    NSInteger code = [responseObject[@"code"] intValue];
    if (code == -10002) {
        
    } else if (code != 0) {
        NSString *domain = ({
            if ([responseObject[@"data"] isKindOfClass:[NSString class]] && [responseObject[@"data"] length])
                domain = responseObject[@"data"];
             else
                domain = responseObject[@"message"];
            domain;
        });
        return [NSError errorWithDomain:domain code:[responseObject[@"code"] integerValue] userInfo:nil];
    }

    return nil;
}

#pragma mark - —— 公共参数
- (NSDictionary *)publicParams {
    return [@{@"appVersion"     :APP.Version,
              @"apiVersion"     :@(APP.apiVersion),
              @"phoneType"      :@0,    // 0为iOS，1安卓
//              @"timeStamp"      :@((long long int)([[NSDate date] millisecondIntervalSince1970])),
//              @"token"          :UserI.token,
              } mutableCopy];
}

#pragma mark - —— 发送请求

// 简写接口
- (ZJSessionModel *)req:(NSString *)pathComponent :(NSDictionary *)params :(BOOL)isPOST {
    NSString *host = APP.HOST;
    NSString *string = _NSString(@"%@%@", host, pathComponent);
    return [self sendRequest:string params:params isPOST:isPOST];
}

// 发起请求
- (ZJSessionModel *)sendRequest:(NSString *)urlString params:(NSDictionary *)_params isPOST:(BOOL)isPOST {
    NSMutableDictionary *params = ({
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        [temp addEntriesFromDictionary:_params];
        
        NSDictionary *publicParams = self.publicParams;
        for (NSString *key in publicParams) {
            if (!temp[key]) {
                temp[key] = publicParams[key];
            }
        }
        temp;
    });
    
    ZJSessionModel *sm = [ZJSessionModel new];
    sm.urlString = urlString;
    sm.params = params;
    sm.isPOST = isPOST;
    sm.delegate = self;
    sm.reconnectCnt = 1;
    
#if defined(DEBUG)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (sm.successBlock)
//            sm.successBlock(@{});
//        if (sm.completionBlock)
//            sm.completionBlock(sm);
//    });
//    return sm;
#endif
    
    // 发起请求
    {
        AFHTTPSessionManager *m = [ZJNetworkRequests1 authSessionManager:urlString];
        NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:isPOST ? @"POST":@"GET" URLString:urlString parameters:params error:nil];
//        [req addValue:UserI.token forHTTPHeaderField:@"ACCESS_TOKEN"];
        [[sm dataTask:m request:req] resume];
    }
    
#if defined(DEBUG) || defined(APP_TEST)
//    [LogVC addRequestModel:sm];
#endif
    return sm;
}

@end
