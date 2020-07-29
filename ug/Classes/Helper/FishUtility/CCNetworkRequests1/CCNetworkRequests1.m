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
    
    {
        [LanguageHelper setNoTranslate:sm.error.domain];
        [LanguageHelper setNoTranslate:sm.responseObject];
    }
    
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
    
    if ([sm.urlString containsString:APP.Host.lastPathComponent] && sm.responseObject) {
        id responseObject = sm.responseObject;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            // 业务逻辑错误 code!=false
            int code = [responseObject[@"code"] intValue];
            if (code != 0) {
                return [NSError errorWithDomain:responseObject[@"msg"] ? : _NSString(@"请求失败 %d", code) code:code userInfo:nil];
            }
        } else {
            // 返回数据格式错误
            return [NSError errorWithDomain:@"数据格式错误。" code:-1 userInfo:nil];
        }
    }
    
    // 请求失败
    if (sm.error) {
        if (sm.response.statusCode == 401) {
            [SVProgressHUD dismiss];
            SANotificationEventPost(UGNotificationloginTimeout, nil);
            sm.noShowErrorHUD = true;
            return [NSError errorWithDomain:@"您的账号已经登录超时，请重新登录。" code:sm.error.code userInfo:sm.error.userInfo];
        }
        if (sm.response.statusCode == 402) {
            [SVProgressHUD dismiss];
            [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
            UGUserModel.currentUser = nil;
            SANotificationEventPost(UGNotificationUserLogout, nil);
            sm.noShowErrorHUD = true;
            return [NSError errorWithDomain:@"登录已过期" code:sm.error.code userInfo:sm.error.userInfo];
        }
        
        if (sm.response.statusCode == 403 || sm.response.statusCode == 404) {
            return [NSError errorWithDomain:sm.error.userInfo[@"com.alamofire.serialization.response.error.data"] code:sm.response.statusCode userInfo:sm.error.userInfo];
        }
        return [NSError errorWithDomain:@"当前网络连接异常，请检查一下你的网络设置。" code:sm.error.code userInfo:sm.error.userInfo];
    }
    return nil;
}

#pragma mark - —— 公共参数
- (NSDictionary *)publicParams {
    return [@{
//              @"appVersion"     :APP.Version,
              @"token"          :UserI.sessid,
              } mutableCopy];
}

#pragma mark - —— 发送请求

// 简写接口
- (CCSessionModel *)req:(NSString *)pathComponent :(NSDictionary *)params :(BOOL)isPOST {
    NSString *host = APP.Host;
    NSString *string = [host stringByAppendingPathComponent:pathComponent];
    NSLog(@"token = %@",UserI.sessid);

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
    
    
    NSLog(@"请求接口url：%@",urlString);
    NSLog(@"请求参数：%@",params);
    
    if (checkSign) {
        urlString = [urlString containsString:@"?"] ? [urlString stringByAppendingFormat:@"&checkSign=1"] : [urlString stringByAppendingFormat:@"?checkSign=1"];
        params = [CMNetwork encryptionCheckSign:params];
        params[@"checkSign"] = @"1";
    }
    
    // 发起请求
    {
        static AFHTTPSessionManager *m = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            m = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:urlString]];
        });
        m.requestSerializer = [AFJSONRequestSerializer serializer];
        m.responseSerializer = [AFJSONResponseSerializer serializer];
        m.securityPolicy = ({
            // 安全策略：不验证证书
            AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
            policy.allowInvalidCertificates = true;
            policy.validatesDomainName = false;
            policy;
        });
        m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:isPOST ? @"POST":@"GET" URLString:urlString parameters:params error:nil];
        [[sm dataTask:m request:req] resume];
    }
    
#ifdef APP_TEST
    [LogVC addRequestModel:sm];
#endif
    return sm;
}


#pragma mark - 热更新

- (CCSessionModel *)getHotUpdateVersionList:(NSInteger)page {
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = @"http://appadmin.fhptcdn.com/api.php";
    sm.params = @{
        @"m":@"get_app_log_list",
        @"type":@"1",   // 1=ios,2=andriod
        @"page":@(page),
#ifdef APP_TEST
#else
        @"status":@1,  // 0未发布，1已发布，不传(全部)
#endif
        @"rand":@(arc4random()).stringValue,
        @"sign":@"996998ikj*",
    };
    sm.isPOST = true;
    sm.reconnectCnt = 2;
    
    // 发起请求
    {
        static AFHTTPSessionManager *m = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            m = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:sm.urlString]];
        });
        m.requestSerializer = [AFHTTPRequestSerializer serializer];
        m.responseSerializer = [AFJSONResponseSerializer serializer];
        m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:sm.isPOST ? @"POST":@"GET" URLString:sm.urlString parameters:sm.params error:nil];
        [[sm dataTask:m request:req] resume];
    }
    return sm;
}

- (CCSessionModel *)downloadFile:(NSString *)url {
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = url;
    sm.reconnectCnt = 2;
    
    // 发起请求
    {
        static AFHTTPSessionManager *m = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            m = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:sm.urlString]];
        });
        NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:sm.isPOST ? @"POST":@"GET" URLString:sm.urlString parameters:sm.params error:nil];
        [[sm downloadTask:m request:req] resume];
    }
    return sm;
}

- (CCSessionModel *)getCodePushUpdate:(NSString *)deploymentKey {
    NSString *urlString = @"http://ec2-18-163-2-208.ap-east-1.compute.amazonaws.com:3000/v0.1/public/codepush/update_check";
    NSDictionary *params = @{@"app_version":@"1.1.1", @"deployment_key":deploymentKey};
    BOOL isPost = false;
    
    AFHTTPSessionManager *m = [AFHTTPSessionManager manager];
    m.requestSerializer = [AFHTTPRequestSerializer serializer];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = urlString;
    sm.params = params;
    sm.isPOST = isPost;
    sm.reconnectCnt = 2;
    NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:sm.isPOST ? @"POST":@"GET" URLString:sm.urlString parameters:sm.params error:nil];
    [[sm dataTask:m request:req] resume];
    return sm;
}

// 获取ip
- (CCSessionModel *)getIp {
    NSString *urlString = @"http://ip.taobao.com/service/getIpInfo2.php";
    NSDictionary *params = @{@"ip":@"myip"};
    BOOL isPost = true;
    
    static AFHTTPSessionManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [AFHTTPSessionManager manager];
    });
    m.requestSerializer = [AFHTTPRequestSerializer serializer];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = urlString;
    sm.params = params;
    sm.isPOST = isPost;
    sm.reconnectCnt = 2;
    NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:sm.isPOST ? @"POST":@"GET" URLString:sm.urlString parameters:sm.params error:nil];
    [[sm dataTask:m request:req] resume];
    return sm;
//    return [self sendRequest:@"http://ip.taobao.com/service/getIpInfo2.php" params:@{@"ip":@"myip"} isPost:true files:nil];
}

// 上传日志到ShowDoc
- (CCSessionModel *)uploadLog:(NSString *)log title:(NSString *)title tag:(nonnull NSString *)tag {
    NSString *urlString = @"https://www.showdoc.cc/server/api/item/updateByApi";
    NSDictionary *params = @{
        @"api_key":@"8d36c0232492493fe13fad667eeb221f2104779671",
        @"api_token":@"0a98a37b01f88f2afe9b9f5c052db169143601101",
        @"page_content":log,// 内容
        @"page_title":_NSString(@"%@（%@）", [[NSDate date] stringWithFormat:@"MM月dd日 HH:mm"], title),// 标题
        @"cat_name":tag,    // 目录名
        @"s_number":[[NSDate date] stringWithFormat:@"yyyyMMddHHmm"],// 序号，数字越小越靠前
    };
    BOOL isPost = true;
    
    static AFHTTPSessionManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [AFHTTPSessionManager manager];
    });
    m.requestSerializer = [AFHTTPRequestSerializer serializer];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = urlString;
    sm.params = params;
    sm.isPOST = isPost;
    sm.reconnectCnt = 2;
    NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:sm.isPOST ? @"POST":@"GET" URLString:sm.urlString parameters:sm.params error:nil];
    [[sm dataTask:m request:req] resume];
    return sm;
//    return [CCSessionModel dataTask:m isPost:isPost url:urlString params:params];
}

@end
