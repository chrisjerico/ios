//
//  CCNetworkRequests1.m
//  Consult
//
//  Created by fish on 2017/10/26.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "CCNetworkRequests1.h"
#import "AFNetworking.h"

@interface CCNetworkRequests1 ()<CCRequestDelegate>
@property (readonly) NSDictionary *publicParams;            /**<    公共参数 */
@end

@implementation CCNetworkRequests1

+ (instancetype)sharedManager {
    static id obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}


#pragma mark - CCRequestDelegate

- (void)requestCompletionAndWillCallBlock:(CCSessionModel *)sm {
    // 执行 请求完成后的通用操作
    // ...
    //    NSLog(@"url = %@", sm.urlString);
    //    NSLog(@"params = %@", sm.params);
    //    NSLog(@"error = %@", sm.error);
    //    NSLog(@"response = %@", sm.responseObject);
    
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
- (NSError *)validationError:(CCSessionModel *)sm {
    // 请求失败
    if (sm.error) {
        if (sm.response.statusCode == 401) {
            [SVProgressHUD dismiss];
            SANotificationEventPost(UGNotificationloginTimeout, nil);
            sm.noShowErrorHUD = true;
        }
        if (sm.response.statusCode == 402) {
            [SVProgressHUD dismiss];
            [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
            UGUserModel.currentUser = nil;
            SANotificationEventPost(UGNotificationUserLogout, nil);
            sm.noShowErrorHUD = true;
        }
        if (sm.response.statusCode == 403 || sm.response.statusCode == 404) {
            return [NSError errorWithDomain:sm.error.userInfo[@"com.alamofire.serialization.response.error.data"] code:sm.response.statusCode userInfo:sm.error.userInfo];
        }
        
        NSLog(@"❌ 请求 URLString：%@ 失败！发送参数：%@\n 参数的 JSON 字符串为：%@\n ERROR 的系统信息为：\n%@\n", sm.urlString, sm.params, sm.params.mj_JSONString, sm.error);
        if ([sm.error.domain isEqualToString:@"NSURLErrorDomain"])
            return [NSError errorWithDomain:@"当前网络连接异常，请检查一下你的网络设置。" code:sm.error.code userInfo:sm.error.userInfo];
        if ([sm.error.domain containsString:@".error."])
            return [NSError errorWithDomain:@"服务器连接异常，请你在“我的-使用帮助-联系客服”中与我们联系。" code:sm.error.code userInfo:sm.error.userInfo];
        return [NSError errorWithDomain:@"当前网络连接异常，请检查一下你的网络设置。" code:sm.error.code userInfo:sm.error.userInfo];
        NSError *error = sm.error.userInfo[@"NSUnderlyingError"] ? : sm.error;
        return [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] ? : error.domain code:sm.error.code userInfo:sm.error.userInfo];
    }
    
    // 非主服务器则返nil
    if (![sm.urlString containsString:APP.Host.lastPathComponent])
        return nil;
    
    id responseObject = sm.responseObject;

    // 返回数据格式错误
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
         NSLog(@"❌ 请求 URLString：%@ 失败！发送参数：%@\n 参数的 JSON 字符串为：%@\n 返回参数为：%@\n ⭕️ responseObject 不是 NSDictionary 类。", sm.urlString, sm.params, sm.params.mj_JSONString, responseObject);
        return [NSError errorWithDomain:@"数据格式错误。" code:-1 userInfo:nil];
    }
    
    // 业务逻辑错误 code!=false
    int code = [responseObject[@"code"] intValue];
    if (code != 0) {
        return [NSError errorWithDomain:responseObject[@"msg"] ? : _NSString(@"请求失败 %d", code) code:code userInfo:nil];
    }
    return nil;
}

#pragma mark - —— 公共参数
- (NSDictionary *)publicParams {
    return [@{@"appVersion"     :APP.Version,
              @"phoneType"      :@0,    // 0为iOS，1安卓
//              @"timeStamp"      :@((long long int)([[NSDate date] millisecondIntervalSince1970])),
              @"token"          :UserI.sessid,
              } mutableCopy];
}

#pragma mark - —— 发送请求

// 简写接口
- (CCSessionModel *)req:(NSString *)pathComponent :(NSDictionary *)params :(BOOL)isPOST {
    NSString *host = APP.Host;
    NSString *string = [host stringByAppendingPathComponent:pathComponent];
    return [self sendRequest:string params:params isPOST:isPOST];
}

// 发起请求
- (CCSessionModel *)sendRequest:(NSString *)urlString params:(NSDictionary *)_params isPOST:(BOOL)isPOST {
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
    
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = urlString;
    sm.params = params;
    sm.isPOST = isPOST;
    sm.delegate = self;
    sm.reconnectCnt = 1;
    
#ifdef DEBUG
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
        static AFHTTPSessionManager *m = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            m = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:urlString]];
        });
        m.requestSerializer = [AFJSONRequestSerializer serializer];
        m.responseSerializer = [AFJSONResponseSerializer serializer];
        m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:isPOST ? @"POST":@"GET" URLString:urlString parameters:params error:nil];
//        [req addValue:UserI.token forHTTPHeaderField:@"ACCESS_TOKEN"];
        [[sm dataTask:m request:req] resume];
    }
    
#ifdef DEBUG
//    [LogVC addRequestModel:sm];
#endif
    return sm;
}

@end
