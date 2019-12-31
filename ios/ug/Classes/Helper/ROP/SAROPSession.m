//
//  SAROPSession.m
//  ChargeManage
//
//  Created by sagesse on 5/19/16.
//  Copyright © 2016 Shenzhen Comtop Information Techology Co., Ltd. All rights reserved.
//

#import "SAROPSession.h"

#import <CommonCrypto/CommonDigest.h>

#define SAROP_PARAMETERNAME_APPKEY        @"appKey"
#define SAROP_PARAMETERNAME_APPSECRET     @"appSecret"
#define SAROP_PARAMETERNAME_VERSION       @"v"
#define SAROP_PARAMETERNAME_METHOD        @"method"
#define SAROP_PARAMETERNAME_SIGN          @"sign"
#define SAROP_PARAMETERNAME_NONCE         @"nonce"
#define SAROP_PARAMETERNAME_FORMAT        @"format"
#define SAROP_PARAMETERNAME_TIMESTAMP     @"timestamp"
#define SAROP_PARAMETERNAME_LOCALE        @"locale"
#define SAROP_PARAMETERNAME_SESSIONID     @"sessionId"

#define SAROP_REDIRECT_URL                @"rUrl"
#define SAROP_REDIRECT_URL_APPKEY         @"rUrlAppKey"

NSString* const NSHTTPErrorDomain = @"NSHTTPErrorDomain";

NSString* const SAROPSessionErrorDomain = @"SAROPSessionErrorDomain";
NSString* const SAROPSessionErrorReasonKey = @"SAROPSessionErrorReasonKey";
NSString* const SAROPSessionErrorMessageKey = @"SAROPSessionErrorMessageKey";
NSString* const SAROPSessionErrorSolutionKey = @"SAROPSessionErrorSolutionKey";
NSString* const SAROPSessionErrorSubErrorsKey = @"SAROPSessionErrorSubErrorsKey";


@interface SAROPSession ()

@property (nonatomic, strong) NSURLSession* session;

@property (nonatomic, strong) SAROPSessionStorage* storage;
@property (nonatomic, strong) SAROPSessionConfiguration* configuration;

//@property (nonatomic, strong, nonnull) NSString* appKey;
//@property (nonatomic, strong, nonnull) NSString* appSecret;
//
//@property (nonatomic, strong, nonnull) NSURL* URL;

@end


@implementation SAROPSession

/// 全局的会话
+ (instancetype)sharedSession {
    static id _sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSession = [self sessionWithConfiguration:SAROPSessionConfiguration.defaultConfiguration];
    });
    return _sharedSession;
}

/// 自定义的会话
+ (instancetype)sessionWithConfiguration:(SAROPSessionConfiguration*)configuration {
    id storage = [SAROPSessionStorage sessionStorageWithIdentifier:configuration.identifier];
    return [self sessionWithConfiguration:configuration
                                  storage:storage];
}
/// 自定义的会话
+ (instancetype)sessionWithConfiguration:(SAROPSessionConfiguration*)configuration
                                 storage:(SAROPSessionStorage*)storage {
    SAROPSession* session = [[self alloc] init];
    session.session = [NSURLSession sessionWithConfiguration: [configuration valueForKey:@"configuration"]];
    
    session.configuration = configuration;
    session.storage = storage;
    return session;
}

#pragma mark -

- (NSURL*)URLWithRelativeURL:(NSString*)URL {
    
    if ([URL containsString:@"/drt/personcenter/"]) {
//        个人中心微服务
        NSDictionary *dict = NSBundle.mainBundle.infoDictionary;
        NSString* serverStr = [dict valueForKeyPath: @"SAROPServer.SAROPServerURLPer"];
        return [NSURL URLWithString:[serverStr stringByAppendingString:URL]];
    }else if ([URL containsString:@"combo.png"]) {
//        根据银行卡号码获取银行卡归属地信息接口地址
        return [NSURL URLWithString:@"https://apimg.alipay.com/combo.png"];
        
    }else if ([URL containsString:@"validateAndCacheCardInfo.json"]) {
//        根绝银行卡归属标识码，查询银行logo图标接口地址：
        return [NSURL URLWithString:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json"];
        
    }else if ([URL containsString:@"/drt/elec/"]) {
        //        电费微服务
        NSDictionary *dict = NSBundle.mainBundle.infoDictionary;
        NSString* serverStr = [dict valueForKeyPath: @"SAROPServer.SAROPServerURLElec"];
        return [NSURL URLWithString:[serverStr stringByAppendingString:URL]];
        
    }else {
//        资产微服务
        return [self.configuration.serverURL URLByAppendingPathComponent: URL];
    }
}

#pragma mark - Make Request

- (NSMutableDictionary*)requestParametersWithURL:(NSURL*)URL
                                       ropMethod:(NSString*)ropMethod
                                      ropVersion:(NSString*)ropVersion
                                   ropParameters:(NSDictionary*)ropParameters {
    NSURLComponents* components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:false];
    NSMutableDictionary* newParameters = [NSMutableDictionary dictionaryWithCapacity:ropParameters.count];
    // 读取URL的参数
    for (NSURLQueryItem* item in components.queryItems) {
        if (item.name.length == 0) {
            continue;
        }
        newParameters[item.name] = item.value ?: @"";
    }
    
    //NSString *sessionId = [[NSUserDefaults standardUserDefaults]objectForKey:kSessionIdKey];
    
    //self.storage.sessionId = sessionId;
    // 合并业务参数
    [newParameters addEntriesFromDictionary:ropParameters];
    // 添加系统参数(为了防止被覆盖)
    newParameters[SAROP_PARAMETERNAME_LOCALE] = @"zh_CN";//self.configuration.systemLocale.localeIdentifier;
    newParameters[SAROP_PARAMETERNAME_APPKEY] = self.appKey;
    newParameters[SAROP_PARAMETERNAME_NONCE] = NSUUID.UUID.UUIDString;
    newParameters[SAROP_PARAMETERNAME_FORMAT] = @"json";
    newParameters[SAROP_PARAMETERNAME_METHOD] = ropMethod ?: @"Unknow";
    newParameters[SAROP_PARAMETERNAME_VERSION] = ropVersion ?: @"Unknow";
    newParameters[SAROP_PARAMETERNAME_SESSIONID] = self.storage.sessionId ?: @"";
    //newParameters[SAROP_PARAMETERNAME_TIMESTAMP] = self.storage.sessionTimestamp ?: @"";
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *_timeStampS = [NSString stringWithFormat:@"%.0f", timeStamp];
     newParameters[SAROP_PARAMETERNAME_TIMESTAMP] = _timeStampS ;
    // 签名
    NSString* sign = [SAROPSession signWithParameters:newParameters secret:self.appSecret];
    newParameters[SAROP_PARAMETERNAME_SIGN] = sign;
    //NSLog(@"*** newParameters = %@",newParameters);
    return newParameters;
}

- (BOOL)hasDataWithParameters:(NSDictionary*)parameters {
    __block BOOL has = false;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if ([obj isKindOfClass:NSData.class]) {
            has = true;
            *stop = true;
        }
        if ([obj isKindOfClass:NSArray.class]) {
            [(NSArray*)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:NSData.class]) {
                    has = true;
                }
                *stop = true;
            }];
            if (has) {
                *stop = true;
            }
        }
    }];
    return has;
}

- (NSString*)requestQueryWithParameters:(NSDictionary*)parameters {
    NSMutableString* query = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        NSString* format = @"&%@=%@";
        if (query.length == 0) {
            format = @"%@=%@";
        }
        [query appendFormat: format, key, obj];
    }];
    return query;
}

- (NSData*)requestBodyDataWithParameters:(NSDictionary*)parameters boundary:(NSString*)boundary {
    NSMutableData* body = [NSMutableData new];
    NSString* mineType = @"application/octet-stream";
    
    if (parameters.count == 0) {
        return body;
    }
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        // 添加多个数据
        if ([obj isKindOfClass:NSArray.class]) {
            // 获取目标类型
            NSString* type = parameters[[NSString stringWithFormat:@"%@.type", key]];
            NSString* fileName = parameters[[NSString stringWithFormat:@"%@.name", key]];
            // 添加数据(文件)
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//                // 添加数据(文件)
                NSString* str1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName ?: key];
                NSString* str2 = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", type ?: mineType];
                [body appendData:[str1 dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:obj];
            }];
            return ;
        }
//         add begin
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        if ([obj isKindOfClass:NSData.class]) {
            // 获取目标类型
            NSString* type = parameters[[NSString stringWithFormat:@"%@.type", key]];
            NSString* fileName = parameters[[NSString stringWithFormat:@"%@.name", key]];
            // 添加数据(文件)
            NSString* str1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName ?: key];
            NSString* str2 = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", type ?: mineType];
            [body appendData:[str1 dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:obj];
        } else {
//             普通数据
            NSString* str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, obj];
            [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
    // add end
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

- (NSMutableURLRequest*)requestWithURL:(NSURL*)URL
                                method:(NSString*)method
                             ropMethod:(NSString*)ropMethod
                            ropVersion:(NSString*)ropVersion
                         ropParameters:(NSDictionary*)ropParameters {
    NSMutableURLRequest* newRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLComponents* components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:false];
    
//    id params = [self requestParametersWithURL:URL ropMethod:ropMethod ropVersion:ropVersion ropParameters:ropParameters];
    id params = ropParameters;
    
    newRequest.allHTTPHeaderFields = self.configuration.allHTTPHeaderFields;
    newRequest.HTTPMethod = method;
    newRequest.timeoutInterval = 60;
    if (![self hasDataWithParameters:params]) {
        NSString* boundary = [[NSUUID UUID] UUIDString];
        NSString* contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary];
        
        [newRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
        newRequest.HTTPMethod = @"POST"; // 必须是POST
        newRequest.HTTPBody = [self requestBodyDataWithParameters:params boundary:boundary];

    } else {
        components.query = [self requestQueryWithParameters:params];
        newRequest.URL = components.URL;
    }

    return newRequest;
}

#pragma mark - Data Task

- (void)finishTasksAndInvalidate {
    [self.session finishTasksAndInvalidate];
}
- (void)invalidateAndCancel {
    [self.session invalidateAndCancel];
}

///
/// 获取数据任务
///
- (SAROPSessionTask*)dataTaskWithURL:(NSString*)URL
                              method:(NSString*)ropMethod
                             version:(NSString*)ropVersion
                          parameters:(NSDictionary*)ropParameters
                      completionHandler:(void (^)(NSDictionary* json, NSURLResponse* response, NSError* error))completionHandler {
   // NSLog(@"URL ==== %@",URL);
    // 生成请求信息
    id url = [self URLWithRelativeURL:URL];
    id request = [self requestWithURL:url
                               method:@"POST"
                            ropMethod:ropMethod
                           ropVersion:ropVersion
                        ropParameters:ropParameters];
    NSLog(@"URL ==== %@",url);
    // 发起请求
    id task = [self.session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        // 获取HTTP错误码
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSHTTPURLResponse* resp = (id)response;
            if (resp.statusCode != 200) {
                id err = [NSHTTPURLResponse localizedStringForStatusCode:resp.statusCode];
                id errMsg = [NSString stringWithFormat:@"%zd %@", resp.statusCode, err];
                error = [NSError errorWithDomain:NSHTTPErrorDomain code:resp.statusCode userInfo:@{NSLocalizedDescriptionKey: errMsg}];
            }
        }
        id json = [SAROPSession toJSONResponse:data error:&error];
        NSString* appKey = [json valueForKey: @"appKey"];
        NSString* appSecret = [json valueForKey: @"appSecret"];
        // 如果有appKey和appSecret, 主动重置参数
        if ([appKey isKindOfClass: NSString.class] && appKey.length != 0
            && [appSecret isKindOfClass: NSString.class] && appSecret.length != 0) {
            // 更新请求参数
            self.storage.appKey = appKey;
            self.storage.appSecret= appSecret;
        }
        NSString* sessionId = [json valueForKey: @"sessionId"];
        // 如果有sessionId, 主动保存
        if ([sessionId isKindOfClass: NSString.class] && sessionId.length != 0) {
            
            //if (![ropMethod isEqualToString:@"user.relogin"]) {
                self.storage.sessionId = sessionId;
                //[[NSUserDefaults standardUserDefaults]setObject:sessionId forKey:kSessionIdKey];
                //[[NSUserDefaults standardUserDefaults] synchronize];
            //}

        }
        NSString* timestamp = [[json valueForKey: @"timeStamp"] stringValue];
        // 如果有timestamp, 主动更新
        if ([timestamp isKindOfClass: NSString.class] && timestamp.length != 0) {
            self.storage.sessionTimestamp = timestamp;
            //NSLog(@"timestamp =***= %@",timestamp);
        }
        
        NSString* jsessionId = [json valueForKey: @"jsessionId"];
        // 如果有jsessionId, 主动更新
        if ([jsessionId isKindOfClass: NSString.class] && jsessionId.length != 0) {
            self.storage.jsessionId = jsessionId;
        }
        
        NSString* imToken = [json valueForKey: @"imToken"];
        // 如果有imToken, 主动更新
        if ([imToken isKindOfClass: NSString.class] && imToken.length != 0) {
            self.storage.imToken = imToken;
        }
        
        NSString* tenantId = [json valueForKey: @"tenantId"];
        // 如果有tenantId, 主动更新
        if ([tenantId isKindOfClass: NSString.class] && tenantId.length != 0) {
            self.storage.tenantId = tenantId;
        }
        
        
        if (completionHandler != nil) {
            completionHandler(json, response, error);
        }
    }];
    
    [task resume];
    
    return [SAROPSessionTask taskWithTask:task];
}

#pragma mark - Version 1.0

/// 获取重定向URL
- (NSURL*)redirectURLWithURL:(NSURL*)URL {
    NSMutableDictionary* newParameters = [NSMutableDictionary dictionary];
   
    // 添加系统参数(为了防止被覆盖)
    newParameters[SAROP_PARAMETERNAME_LOCALE] = @"zh_CN";//self.configuration.systemLocale.localeIdentifier;
    newParameters[SAROP_PARAMETERNAME_APPKEY] = self.appKey;
    newParameters[SAROP_PARAMETERNAME_NONCE] = NSUUID.UUID.UUIDString;
    
    newParameters[SAROP_PARAMETERNAME_SESSIONID] = self.storage.sessionId ?: @"";
    newParameters[SAROP_PARAMETERNAME_TIMESTAMP] = self.storage.sessionTimestamp ?: @"";
    newParameters[SAROP_REDIRECT_URL] = URL.absoluteString ?: @"";
    newParameters[SAROP_REDIRECT_URL_APPKEY] = self.appKey;
    // 签名
    NSString* sign = [SAROPSession signWithParameters:newParameters secret:self.appSecret];
    newParameters[SAROP_PARAMETERNAME_SIGN] = sign;
    //NSLog(@"**** newParameters =%@",newParameters);
    // 把参数合到Request里面
    NSMutableString* query = [NSMutableString string];
    //NSMutableArray* queryItems = [NSMutableArray array];
    [newParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        NSString* format = @"&%@=%@";
        if (query.length == 0) {
            format = @"%@=%@";
        }
        [query appendFormat: format, key, obj];
    }];
    // 合成地址
    NSURL* baseURL = [self URLWithRelativeURL:[NSString stringWithFormat:@"/%@/rop_redirect", self.configuration.serverName]];
    
    NSURLComponents* components = [NSURLComponents componentsWithURL:baseURL
                                             resolvingAgainstBaseURL:false];
    components.query = query;
    
    return components.URL;
}


///
/// 获取数据任务(从配置读取URL)
///
- (SAROPSessionTask*)dataTaskWithMethod:(NSString*)method
                                version:(NSString*)version
                             parameters:(NSDictionary*)parameters
                      completionHandler:(void (^)(NSDictionary* json, NSURLResponse* response, NSError* error))completionHandler {
//    id tmp = [NSString stringWithFormat:@"/%@/router", self.configuration.serverName];
    id tmp = [NSString stringWithFormat:@"/%@/%@", self.configuration.serverName,method];
    return [self dataTaskWithURL:tmp
                          method:method
                         version:version
                      parameters:parameters
               completionHandler:completionHandler];
}

#pragma mark - Data Convert

+ (id)toJSONResponse:(NSData*)data error:(NSError**)error {
    __autoreleasing NSError* _error = nil;
    error = error ?: &_error;
    // 还有错误没有处理
    if (*error != nil) {
        return nil;
    }
    if (data == nil) {
        *error = [SAROPSession errorWithReason:@"数据错误"
                                          code:-1
                                      userInfo:nil];
        return nil;
    }
    // 序列化数据
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:error];
    // 存在错误
    if (*error != nil) {
        return nil;
    }
    if (json == nil || ![json isKindOfClass:NSDictionary.class]) {
        *error = [SAROPSession errorWithReason:@"数据解析错误"
                                          code:-1
                                      userInfo:nil];
        return nil;
    }
    // 校验数据
    *error = [SAROPSession errorWithResponse:json];
    // 总是返回
    return json;
}

#pragma mark - Error Convert

+ (id)errorWithReason:(NSString*)reason
                 code:(NSInteger)code
             userInfo:(NSDictionary*)userInfo {
    
    NSMutableDictionary* _userInfo = userInfo.mutableCopy ?: NSMutableDictionary.new;
    
    _userInfo[SAROPSessionErrorMessageKey] = reason;
    _userInfo[SAROPSessionErrorSolutionKey] = reason;
    _userInfo[NSLocalizedDescriptionKey] = reason;
    
    return [NSError errorWithDomain:SAROPSessionErrorDomain
                               code:code
                           userInfo:_userInfo];
}
+ (id)errorWithResponse:(NSDictionary*)response {
    NSInteger code = [response[@"code"] integerValue];
    // 是空的话. 直接返回了
    if (code == 0) {
        return nil;
    }
    
    NSMutableDictionary* _userInfo = NSMutableDictionary.new;
    __block NSMutableString* description = [response[@"message"] mutableCopy];
    
    _userInfo[SAROPSessionErrorMessageKey] = response[@"message"];
    _userInfo[SAROPSessionErrorSolutionKey] = response[@"solution"];
    
    NSArray* subErrors = response[@"subErrors"];
    // 有子错误
    if ([subErrors isKindOfClass: NSArray.class] && subErrors.count != 0) {
        NSMutableArray* _subErrors = [NSMutableArray arrayWithCapacity: subErrors.count];
        [subErrors enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL* stop) {
            //NSString* code = obj[@"code"];
            NSString* message = obj[@"message"];
            // 生成错误信息
            id error = [self errorWithReason:message
                                        code:-1
                                    userInfo:nil];
            
            description = message.mutableCopy;
            //[description appendFormat:@": %@", message];
            [_subErrors addObject:error];
        }];
        _userInfo[SAROPSessionErrorSubErrorsKey] = _subErrors;
    }
    _userInfo[NSLocalizedDescriptionKey] = description;
    // 生成
    return [NSError errorWithDomain:SAROPSessionErrorDomain
                               code:code
                           userInfo:_userInfo];
}

#pragma mark - Parameter Secret

// SHA1加密
+ (NSData *)sha1:(NSString *)str {
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20] = {};
    CC_SHA1(data.bytes, (CC_LONG)data.length, result);
    return [NSData dataWithBytes:result length:20];
}

// 二进制转十六进制
+ (NSString *)hexString:(NSData *)data {
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
    const unsigned char *dataBuffer = [data bytes];
    for (int i = 0; i < [data length]; ++i) {
        [stringBuffer appendFormat:@"%02X", (unsigned int)dataBuffer[i]];
    }
    return stringBuffer;
}
// 签名
+ (NSString*)signWithParameters:(NSDictionary*)parameters
                         secret:(NSString*)secret {
    // 检查检查
    if (secret.length == 0) {
        return nil;
    }
    NSMutableString* unsignValue = [NSMutableString stringWithString:secret];
    // 参数名正序排列
    NSArray* names = [parameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSForcedOrderingSearch];
    }];
    // 合成字符串
    [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        id value = parameters[obj];
        //        if ([value isKindOfClass:NSData.class]) {
        //            return ;
        //        }
        [unsignValue appendFormat: @"%@%@", obj, value];
    }];
    [unsignValue appendString:secret];
    // 开始签名
    NSString* signedValue = [self hexString:[self sha1:unsignValue]];
    //NSLog(@"%s %@", __func__, unsignValue);
    //NSLog(@"%s %@", __func__, signedValue);
    return signedValue;
}

// 签名
+ (NSString*)signWithParameters:(NSDictionary*)parameters
                     exceptKeys:(NSArray*)exceptKeys
                         secret:(NSString*)secret {
    NSMutableDictionary* dic = parameters.mutableCopy;
    [exceptKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [dic removeObjectForKey:obj];
    }];
    return [self signWithParameters:dic secret:secret];
}

#pragma mark - getter

- (NSString*)appKey {
    return self.storage.appKey ?: self.configuration.defaultAppKey ?: @"";
}
- (NSString*)appSecret {
    return self.storage.appSecret ?: self.configuration.defaultAppSecret ?: @"";
}



@end


#pragma mark - Error Info

///
/// @brief ROP错误信息
///
@implementation NSError (SAROPSession)

- (NSArray*)ROPSubErrors {
    return self.userInfo[SAROPSessionErrorSubErrorsKey];
}

- (NSString*)ROPReason {
    return self.userInfo[SAROPSessionErrorReasonKey];
}
- (NSString*)ROPMessage {
    return self.userInfo[SAROPSessionErrorMessageKey];
}
- (NSString*)ROPSolution {
    return self.userInfo[SAROPSessionErrorSolutionKey];
}

- (BOOL)isROPError {
    return [self.domain isEqualToString:SAROPSessionErrorDomain];
}
- (BOOL)isHTTPError {
    return [self.domain isEqualToString:NSHTTPErrorDomain];
}
- (BOOL)isURLError {
    return [self.domain isEqualToString:NSURLErrorDomain];
}

@end
