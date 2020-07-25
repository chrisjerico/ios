//
//  CMNetWork.m
/**
 * 网络请求工具类
 */

#import "CMNetwork.h"
#import "JSONModelArray.h"
#import "JSONModelError.h"
#import "JSONHTTPClient.h"

#import "SAROPSession.h"
#import "CMNetworkStorage.h"
#import "CMCommon.h"

#import "AFNetworking.h"
#import "SAROPSessionStorage.h"

#import "UGEncryptUtil.h"
#import "GLEncryptManager.h"


Class CMResultClassGetResultClass(CMResultClass cls);
Class CMResultClassGetDataClass(CMResultClass cls);

/// 最大值
NSInteger g_network_task_count = 0;
CMSpliteLimiter CMSpliteLimiterMax = {1, 65535};

@interface CMNetwork ()

@property (nonatomic, strong) NSString* server;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSString *serverName;
@end

@interface CMResult () {
@public
    NSError* _error;
}

@end

@implementation CMResult
//允许返回的模型字段为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return true;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    if ([propertyName isEqualToString: NSStringFromSelector(@selector(data))]) {
        return true;
    }
    return [super propertyIsIgnored: propertyName];
}

///
/// @brief 生成JSON信息
///
/// @param JSON         json数据
/// @param dataClass    data的类型
/// @param error        错误信息
///
+ (instancetype)resultWithJSON:(NSDictionary*)JSON dataClass:(id)dataClass error:(NSError**)error {
    id setClass = nil;
    id elementClass = dataClass;
    NSError* __autoreleasing tmpError = nil;
    // 读取...
    if ([dataClass isKindOfClass:NSArray.class]) {
        setClass = [dataClass firstObject];
        elementClass = [dataClass lastObject];
    }
    if (error == nil) {
        error = &tmpError;
    }
    __block NSError* err = *error;
    __block CMResult* result = [[self alloc] init];
    
    ^(id json, id data){
        if (err != nil) {
            return ;
        }
        result = [[self alloc] initWithDictionary:json error:&err];
        if (err != nil) {
            return;
        }
        if (result.code != 0) {
            id errMsg = result.msg ?: [NSString stringWithFormat:@"error code: %zd", result.code];
            err = [NSError errorWithDomain:@"XD" code:result.code userInfo:@{NSLocalizedDescriptionKey:errMsg}];
//            return;
        }
        if (data == nil) {
            //err = [JSONModelError errorInvalidDataWithMessage:@"data is empty"];
            return;
        }
        if (elementClass == nil) {
            result.data = data;
            return;
        }
        if (setClass != nil) {
            if ([data isKindOfClass:NSNull.class]) {
                return;
            }
            if (![data isKindOfClass:NSArray.class]) {
                //                err = [JSONModelError errorInvalidDataWithMessage:@"data is not an NSArray"];
                return;
            }
            if (data) {
                result.data = [[setClass alloc] initWithArray:data modelClass:elementClass];
            }
            
        } else {
            if (data) {
                
                result.data = [[elementClass alloc] initWithDictionary:data error:&err];
            }
        }
    }(JSON, JSON[@"data"]);
    
    // 提交数据
    [result setValue:err forKey:@"_error"];
    *error = err;
    
    return result;
}

///
/// @bief 处理错误, 失败将弹出错误
///
/// @param result 结果
/// @param success 成功回调
///
+ (void)processWithResult:(id)result success:(void(^)(void))success {
    [self processWithResult:result success:success failure:^(id msg) {
        dispatch_block_t handler = ^{
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:msg
                                       delegate:nil
                              cancelButtonTitle:@"好的"
                              otherButtonTitles:nil] show];
        };
        if (NSThread.isMainThread) {
            handler();
            return ;
        }
        dispatch_sync(dispatch_get_main_queue(), handler);
        
    }];
}
///
/// @bief 处理错误
///
/// @param result 结果
/// @param failure 失败回调
/// @param success 成功回调
///
+ (void)processWithResult:(CMResult*)result success:(void(^)(void))success failure:(void(^)(id msg))failure {
    NSString *msg = nil;
    id title = nil;
    if (!result) {
        if (failure != nil) {
            failure(msg);
        }
        return;
    }
    if (result->_error.isURLError) {
        // 网络层错误
        if (result->_error.code == kCFURLErrorNotConnectedToInternet) {
            // 不能连接网络
            msg = @"网络无法连接，请检查网络设置.";
            title = @"网络异常";
        } else if (result->_error.code == kCFURLErrorTimedOut) {
            // 连接超时
            msg = @"网络连接超时，请稍后再试.";
            title = @"网络异常";
        } else {
            // 其他错误
            msg = @"网络发生未知错误, 请稍后再试.";
            title = @"网络异常";
        }
    } else if (result->_error.isHTTPError) {
        // 其他错误
        msg = [NSString stringWithFormat: @"网络发生未知错误, 请稍后再试."];
        title = @"网络异常";
    } else if (result->_error.isROPError) {
        // ROP错误
        title = @"未知错误，稍后再试";
        msg = result->_error.localizedDescription ?: result->_error.ROPReason;
        [LanguageHelper setNoTranslate:msg];
    } else if (result->_error != nil) {
        // 未知错误
        title = @"未知错误，稍后再试";
        msg = result->_error.localizedDescription; //@"发生未知错误, 请稍后再试或者和我们联系.";
        [LanguageHelper setNoTranslate:msg];
    }
    else if(result->_error.code == 401){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // UI更新代码
          
        }];
    }
    
    
    if (msg == nil) {
        [LanguageHelper setNoTranslate:result];
        if (success != nil) {
            success();
        }
    } else {
        NSLog(@"%s %@", __func__, result->_error ?: msg);
        if (failure != nil) {
            failure(msg);
        }
    }
}

@end

@implementation CMSpliteResult
@end
@implementation CMNetwork

+(instancetype)manager {

    static CMNetwork* network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = self.new;
        [JSONHTTPClient setRequestContentType: @"application/x-www-form-urlencoded"];

    });
    return network;
}

/// 存储单元
+ (CMNetworkStorage*)storage {
    static id _storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _storage = [CMNetworkStorage sessionStorageWithIdentifier:@"uggame.network.sa"];
    });
    return _storage;
}

#pragma mark  -

///
/// @brief 请求数据(结果在主线程)
///
/// @param method       方法
/// @param params       附加参数
/// @param model       响应结果类型
/// @param completion   结果回调
///
- (void)requestInMainThreadWithMethod:(NSString*)method
                               params:(NSDictionary*)params
                                model:(CMResultClass)model
                                 post:(BOOL)isPost
                           completion:(CMNetworkBlock)completion {
#ifdef APP_TEST
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = method;
    sm.params = params;
    sm.isPOST = isPost;
#endif
    __block id __block1 = nil;
    __block id __block2 = __block1 = ^(CMResult<id> *model, NSError *err) {
#ifdef APP_TEST
        sm.responseObject = [__block2 cc_userInfo][@"responseObject"];
        sm.error = [__block2 cc_userInfo][@"error"];
        [LogVC addRequestModel:sm];
#endif
        if (completion == nil) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(model, err);
        });
    };
    [self requestWithMethod:method
                     params:params
                      model:model
                       post:isPost
                 completion:__block2];
}
/******************************************************************************
 函数名称 : encryptionCheckSignForURL;
 函数描述 : url参数加密
 输入参数 : url
 输出参数 : NSString 加密后url
 返回参数 : NSString 加密后url
 备注信息 :
 ******************************************************************************/

+ (NSString *)encryptionCheckSignForURL:(NSString*)url {
    
    //    参数加密
    if (checkSign) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        
        tempDic =  [CMCommon yyUrlConversionParameter:url];
        NSMutableDictionary *noChenkSignDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        // 将所有的key取出放入数组arr中
        NSArray *arr = [tempDic allKeys];
        // 遍历arr 取出对应的key以及key对应的value
        for (NSInteger i = 0; i < arr.count; i++) {
            
            //如果是a c 不加密，其他的加密，
            if (![arr[i] isEqualToString:@"a"]&&![arr[i] isEqualToString:@"c"]) {
                [newDic setObject:[tempDic objectForKey:arr[i]] forKey:arr[i]];
            }
            else{
                [noChenkSignDic setObject:[tempDic objectForKey:arr[i]] forKey:arr[i]];
            }
            
        }
        
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        
        parmDic = [CMNetwork encryptionCheckSign:newDic];
        
        NSArray*array = [url componentsSeparatedByString:@"?"];//从字符A中分隔成2个元素的数组
        
        NSMutableString* methodUrl = [NSMutableString stringWithFormat:@"%@?checkSign=1",[array firstObject]];
        
        NSArray *noChenkSignArr = [noChenkSignDic allKeys];
        // 遍历arr 取出对应的key以及key对应的value
        for (NSInteger i = 0; i < noChenkSignArr.count; i++) {
            
            
            [methodUrl appendString:@"&"];
            [methodUrl appendFormat:@"%@",noChenkSignArr[i]];
            [methodUrl appendString:@"="];
            [methodUrl appendFormat:@"%@",[noChenkSignDic objectForKey:noChenkSignArr[i]]];
        }
        
        
        NSArray *parmDicArr = [parmDic allKeys];
        // 遍历arr 取出对应的key以及key对应的value
        for (NSInteger i = 0; i < parmDicArr.count; i++) {
            
            [methodUrl appendString:@"&"];
            [methodUrl appendFormat:@"%@",parmDicArr[i]];
            [methodUrl appendString:@"="];
            [methodUrl appendFormat:@"%@",[parmDic objectForKey:parmDicArr[i]]];
        }
        
        NSLog(@"methodUrl = %@",methodUrl);
        return methodUrl;
    }
    else{
        return url;
    }

  
}

/******************************************************************************
 函数名称 : encryptionCheckSignC;
 函数描述 : 网络请求的，游戏获得的url参数加密
 输入参数 : NSDictionary 参数
 输出参数 : NSMutableDictionary 加密后参数
 返回参数 : NSMutableDictionary 加密后参数
 备注信息 :
 ******************************************************************************/
+ (NSMutableDictionary *)encryptionCheckSign:(NSDictionary *)params {
    if (!params.count) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *deskey = [UGEncryptUtil createUuid];
    NSLog(@"deskey = %@", deskey);
    NSString *sign = [UGEncryptUtil encryptString:[NSString stringWithFormat:@"iOS_%@",deskey] publicKey:RSAPublicKey];
    
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        NSData *resultData;
        NSString *resultString;
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *temp = (NSNumber *)obj;
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            obj = [numberFormatter stringFromNumber:temp];
        }
        NSData *encryptData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        resultData = [GLEncryptManager excute3DESWithData:encryptData secureKey:[deskey dataUsingEncoding:NSUTF8StringEncoding] operation:kCCEncrypt];
        resultString = [GLEncryptManager encodeBase64WithData:resultData];
        [dict setValue:resultString forKey:key];
    }];
    [dict setValue:sign forKey:@"sign"];
    if (UGLoginIsAuthorized()) {
        UGUserModel *user = [UGUserModel currentUser];
        NSData *resultData;
        NSString *resultString;
        NSData *encryptData = [user.sessid dataUsingEncoding:NSUTF8StringEncoding];
        resultData = [GLEncryptManager excute3DESWithData:encryptData secureKey:[deskey dataUsingEncoding:NSUTF8StringEncoding] operation:kCCEncrypt];
        resultString = [GLEncryptManager encodeBase64WithData:resultData];
        [dict setValue:resultString forKey:@"token"];
    }
    
    return dict;
}


/// @brief 请求数据
///
/// @param method       方法
/// @param params       附加参数
/// @param model       响应结果类型
/// @param completion   结果回调
///
- (void)requestWithMethod:(NSString*)method params:(NSDictionary*)params model:(CMResultClass)model post:(BOOL)isPost completion:(CMNetworkBlock)completion {
    if (checkSign && ![method containsString:@"eapi"]) {
        // 参数加密
        method = [NSString stringWithFormat:@"%@&checkSign=1",method];
        params = [CMNetwork encryptionCheckSign:params];
    }
    
    // 登录请求去掉token
    if ([method containsString:@"a=login"]||[method containsString:@"a=lotteryNumber"]) {
        [params setValue:nil forKey:@"token"];
    }
    NSLog(@"请求method   =%@",method);
    NSLog(@"请求params   =%@",params);
    if (isPost) {
        [self postWithMethod:method params:params  model:model retryCount:0 completion:completion];
    } else {
        [self getWithMethod:method params:params  model:model retryCount:0 completion:completion];
    }
}

- (void)getWithMethod:(NSString*)method
                params:(NSDictionary*)params
                 model:(CMResultClass)model
            retryCount:(NSInteger)retryCount
            completion:(CMNetworkBlock)completion {
    
    // 读取信息
    id resultClass = CMResultClassGetResultClass(model);
    id dataClass = CMResultClassGetDataClass(model);
    
//    NSLog(@"url = %@",method);
//    NSLog(@"params = %@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer  setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    // 2.设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
//    NSLog(@"header = %@",[manager.requestSerializer HTTPRequestHeaders]);
    
    [manager GET:method parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([method containsString:@"imgCaptcha"]) {
            if (completion != nil) {
                completion(responseObject, nil);
                return ;
            }
        }
        
        
        // 序列化数据
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:0
                                                               error:nil];
        
 
#ifdef DEBUG
        
        HJSonLog(@"%@: 返回的json = %@",method,json);

#endif

        NSError *error;
        CMResult* result;
        if (json) {
            result  = [resultClass resultWithJSON:json dataClass:dataClass error:&error];
        }
#ifdef APP_TEST
        [completion cc_userInfo][@"responseObject"] = json;
#endif
        if (completion != nil) {
            completion(result, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *errResponse = task.response;
        if (errResponse.statusCode == 401) {
            [SVProgressHUD dismiss];
            SANotificationEventPost(UGNotificationloginTimeout, nil);
			completion(nil, error);

            return ;
        }
        if (errResponse.statusCode == 402) {
            [SVProgressHUD dismiss];
            [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
            UGUserModel.currentUser = nil;
            SANotificationEventPost(UGNotificationUserLogout, nil);
			completion(nil, error);

            return ;
        }
        if (errResponse.statusCode == 403) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:nil];
            NSError *err;
            CMResult* result  = [resultClass resultWithJSON:json dataClass:dataClass error:&err];
            if (completion != nil) {
                completion(result, err);
                return;
            }
        }
#ifdef APP_TEST
        [completion cc_userInfo][@"error"] = error;
#endif
        CMResult* result  = [resultClass resultWithJSON:nil dataClass:dataClass error:&error];
        if (completion != nil) {
            completion(result, error);
        }
    }];
    
}

- (void)postWithMethod:(NSString*)method
params:(NSDictionary*)params
model:(CMResultClass)model
retryCount:(NSInteger)retryCount
completion:(CMNetworkBlock)completion {
    
    // 读取信息
    id resultClass = CMResultClassGetResultClass(model);
    id dataClass = CMResultClassGetDataClass(model);
    
    NSLog(@"url = %@",method);
    NSLog(@"params = %@",params);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//   [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    [manager.requestSerializer  setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    // 2.设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
//    NSLog(@"header = %@",[manager.requestSerializer HTTPRequestHeaders]);
    [manager POST:method parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 序列化数据
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:0
                                                               error:nil];
        
//        NSLog(@"%@: json = %@",method,json);
        
        #ifdef DEBUG
                
                HJSonLog(@"%@: 返回的json = %@",method,json);

        #endif
        NSError *error;
        CMResult* result;
        if (json) {
            result  = [resultClass resultWithJSON:json dataClass:dataClass error:&error];
        }
#ifdef APP_TEST
        [completion cc_userInfo][@"responseObject"] = json;
#endif
        if (completion != nil) {
            completion(result, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *errResponse = task.response;
        if (errResponse.statusCode == 401) {
            [SVProgressHUD dismiss];
            SANotificationEventPost(UGNotificationloginTimeout, nil);
            return ;
        }
        if (errResponse.statusCode == 402) {
            [SVProgressHUD dismiss];
            [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
            UGUserModel.currentUser = nil;
            SANotificationEventPost(UGNotificationUserLogout, nil);
            return ;
        }
        if (errResponse.statusCode == 403 || errResponse.statusCode == 404) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:0 error:nil];
            NSError *err;
            CMResult *result  = [resultClass resultWithJSON:json dataClass:dataClass error:&err];
            if (completion != nil) {
                completion(result, err);
                return;
            }
        }
#ifdef APP_TEST
        [completion cc_userInfo][@"error"] = error;
#endif
        CMResult* result  = [resultClass resultWithJSON:nil dataClass:dataClass error:&error];
        if (completion != nil) {
            completion(result, error);
        }
    }];
    
   
}

//下载文件
+ (void)dowdloadFileWithUrl:(NSURL *)loadUrl completionBlock:(void(^)(NSURL *filePath))completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:loadUrl];
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
    
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error && completionBlock) {
            completionBlock(filePath);
        }
        
    }];
    
    [download resume];
}

- (AFHTTPSessionManager *)sessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    return manager;
}

@end

FOUNDATION_EXPORT CMResultClass CMResultClassMake(Class cls) {
    if (cls == nil) {
        return (id)@[CMResult.class];
    }
    return (id)@[CMResult.class, cls];
}
FOUNDATION_EXPORT CMResultClass CMResultArrayClassMake(Class elementClass) {
    if (elementClass == nil) {
        return (id)@[CMResult.class];
    }
    return (id)@[CMResult.class, @[JSONModelArray.class, elementClass]];
}
FOUNDATION_EXPORT CMResultClass CMResultSpliteClassMake(Class elementClass) {
    if (elementClass == nil) {
        return (id)@[CMSpliteResult.class];
    }
    return (id)@[CMSpliteResult.class, @[JSONModelArray.class, elementClass]];
}

Class CMResultClassGetResultClass(CMResultClass cls) {
    NSArray* xs = (id)cls;
    return xs.firstObject ?: CMResult.class;
}
Class CMResultClassGetDataClass(CMResultClass cls) {
    NSArray* xs = (id)cls;
    if (1 < xs.count) {
        return xs[1];
    }
    return nil;
}

