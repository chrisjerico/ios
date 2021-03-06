//
//  CCNetworkRequests2.m
//  AutoPacking
//
//  Created by fish on 2019/12/4.
//  Copyright © 2019 fish. All rights reserved.
//

#import "CCNetworkRequests2.h"
#import "AFNetworking.h"

#define HOST @"http://appadmin.fhptcdn.com"
#define ImgbbKey @"8905badeffd4f4c7f0bbfce3ce4a2f78"

@interface CCNetworkRequests2 ()<CCRequestDelegate>
@property (readonly) NSDictionary *publicParams;            /**<    公共参数 */
@end

@implementation CCNetworkRequests2

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
    //    NSLog(@"response = %@", sm.resObject);
    
    if (sm.error) {
        if ([sm.resObject[@"data"] isKindOfClass:[NSString class]]) {
            NSMutableDictionary *dict = [sm.resObject mutableCopy];
            dict[@"data"] = nil;
            sm.resObject = dict;
        }
    }
}
#pragma mark 生成错误信息
// 把 “HTTP请求成功，但服务器返回操作失败” 的情况生成错误信息NSError
- (NSError *)validationError:(CCSessionModel *)sm {
    // 请求失败
    if (sm.error) {
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
    if (![sm.urlString containsString:HOST.lastPathComponent])
        return nil;
    
    NSDictionary *responseObject = sm.resObject;
    
    // 返回数据格式错误
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"❌ 请求 URLString：%@ 失败！发送参数：%@\n 参数的 JSON 字符串为：%@\n 返回参数为：%@\n ⭕️ responseObject 不是 NSDictionary 类。", sm.urlString, sm.params, sm.params.mj_JSONString, responseObject);
        return [NSError errorWithDomain:@"数据格式错误。" code:-1 userInfo:nil];
    }
    
    // 业务逻辑错误 code!=false
    int code = [responseObject[@"code"] intValue];
    if (code != 1) {
        return [NSError errorWithDomain:responseObject[@"msg"] ? : _NSString(@"请求失败 %d", code) code:code userInfo:nil];
    }
    return nil;
}

#pragma mark - —— 公共参数
- (NSDictionary *)publicParams {
    return @{
        @"rand"     : @(arc4random()).stringValue,
        @"sign"     : @"996998ikj*",
        @"loginsessid":[[NSUserDefaults standardUserDefaults] objectForKey:@"loginsessid"],
        @"logintoken":[[NSUserDefaults standardUserDefaults] objectForKey:@"logintoken"],
    }.mutableCopy;
}

#pragma mark - —— 发送请求

// 简写接口
- (CCSessionModel *)req:(NSString *)pathComponent :(NSDictionary *)params :(BOOL)isPOST {
    NSString *host = HOST;
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
    
    NSLog(@"params = %@",params);
    
    CCSessionModel *sm = [CCSessionModel new];
    sm.urlString = urlString;
    sm.params = params;
    sm.isPOST = isPOST;
    sm.delegate = self;
    sm.reconnectCnt = 2;
    sm.urlString = urlString;
    
    static AFHTTPSessionManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 300;
        m = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:urlString] sessionConfiguration:config];
        m.requestSerializer = [AFHTTPRequestSerializer serializer];
        m.responseSerializer = [AFJSONResponseSerializer serializer];
        m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    
    NSString *filePath = params[@"上传文件"];
    if (filePath.length) {
        NSMutableURLRequest *req = [m.requestSerializer multipartFormRequestWithMethod:isPOST ? @"POST":@"GET" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSString *mimeType = [filePath.pathExtension isEqualToString:@"plist"] ? @"application/xml" : @"application/octet-stream";
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:params[@"上传文件"]] name:@"file" fileName:filePath.lastPathComponent mimeType:mimeType error:nil];
        } error:nil];
        [[sm uploadTask:m request:req files:nil] resume];
    } else {
        NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:isPOST ? @"POST":@"GET" URLString:urlString parameters:params error:nil];
        [[sm dataTask:m request:req] resume];
    }
    return sm;
}

// 登录
- (CCSessionModel *)login:(NSString *)user pwd:(NSString *)pwd {
    NSString *vcode = nil;
    return [self req:@"api.php"
                    :@{@"m":@"login",
                       @"username":user,// 用户名
                       @"password":pwd, // 密码
                       @"vcode":vcode,  // 验证码
                    }
                    :true];
}

// 上传文件
- (CCSessionModel *)uploadWithId:(NSString *)_id sid:(NSString *)sid file:(NSString *)file {
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        assert(!_NSString(@"上传的文件不存在。%@", file).length);
    }
    return [self req:@"api.php"
                    :@{@"m":@"upload_file",
                       @"上传文件":file,    // 文件本地路径
                       @"site_number":sid,    //站点编号
                       @"app_id":_id,        // 站点在上传后台的ID
                    }
                    :true];
}

// 获取APP信息
- (CCSessionModel *)getInfo:(NSString *)_id {
    return [self req:@"api.php"
                    :@{@"m":@"get_app_detail",
                       @"app_id":_id,   // 站点在上传后台的ID
                    }
                    :true];
}

// 提交审核
- (CCSessionModel *)submitReview:(SiteModel *)site plistPath:(NSString *)plistPath ver:(NSString *)ver isForce:(BOOL)isForce log:(NSString *)log {
    // 非强制更新
    NSMutableDictionary *dict = @{
        @"m":@"edit_app",
        @"app_id":site.uploadId, // 站点在上传后台的ID
        @"site_url":site.siteUrl,// 站点链接
        @"ios_plist":plistPath,   // plist地址
        @"ios_version":ver,      // 版本号
        @"ios_update_log":log,   // 更新日志
        @"ios_check_status":@"0",
    }.mutableCopy;
    
    // 强制更新
    if (isForce) {
        [dict addEntriesFromDictionary:@{
            @"ios_version_name":ver, // 强制更新版本
            @"ios_force_update":@(isForce).stringValue,  // 是否强制更新
            @"ios_download_page":_NSString(@"https://baidujump.app/eipeyipeyi/jump-%@.html", site.uploadId), // 下载页面链接
        }];
    }
    return [self req:@"api.php"
                    :dict
                    :true];
}


#pragma mark - 高权限操作

// 修改审核状态
- (CCSessionModel *)changeReviewStatus:(SiteModel *)site reviewed:(BOOL)reviewed {
    return [self req:@"api.php"
                    :@{@"m":@"review_app",
                       @"app_id":site.uploadId,
                       @"check_status":@(reviewed),
                       @"platform":@"ios",
                    }
                    :true];
}

// 修改强制更新信息
- (CCSessionModel *)changeForceUpdateInfo:(SiteModel *)site forceVer:(NSString *)forceVer isForce:(BOOL)isForce log:(NSString *)log {
    return [self req:@"api.php"
                    :@{@"m":@"edit_app",
                       @"app_id":site.uploadId, // 站点在上传后台的ID
                       @"site_url":site.siteUrl,// 站点链接
                       @"ios_version_name":forceVer, // 强制更新版本
                       @"ios_update_log":log,   // 更新日志
                       @"ios_force_update":@(isForce).stringValue,  // 是否强制更新
                       @"ios_download_page":_NSString(@"https://baidujump.app/eipeyipeyi/jump-%@.html", site.uploadId), // 下载页面链接
                    }
                    :true];
}

- (CCSessionModel *)uploadImage:(NSString *)base64 {
    return [self sendRequest:@"https://api.imgbb.com/1/upload" params:@{@"image":base64, @"key":ImgbbKey} isPOST:true];
}

@end
