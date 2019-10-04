//
//  ZJSessionModel.m
//  Consult
//
//  Created by fish on 2017/10/26.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "ZJSessionModel.h"
#import "AFNetworking.h"

@implementation ZJSessionModel

MJCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"task", @"delegate",
             @"successBlock", @"failureBlock", @"completionBlock", @"filePathBlock", @"progressBlock", ];
}

+ (NSString *)printURLString:(NSString *)URLString params:(NSDictionary *)params {
    NSMutableString *string = [URLString mutableCopy];
    if (![string containsString:@"?"])
        [string appendString:@"?"];
    
    for (NSString *key in params.allKeys)
        [string appendFormat:@"%@=%@&", key, params[key]];
    
    return string;
}


#pragma mark -

- (void)setSuccessBlock:(void(^)(id responseObject))successBlock failureBlock:(void(^)(NSError *error))failureBlock {
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
}

- (NSURLSessionDataTask *)dataTask:(AFHTTPSessionManager *)m request:(NSURLRequest *)req {
    __blockSelf_(__self);
    NSDate *startTime = [NSDate date];
    _task = [m dataTaskWithRequest:req completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        __self.duration = [[NSDate date] timeIntervalSinceDate:startTime] * 1000;
        __self.response = response;
        __self.responseObject = responseObject;
        __self.error = error;
        
        [__self callback];
    }];
    _afsm = m;
    return (id)_task;
}

- (NSURLSessionDownloadTask *)downloadTask:(AFHTTPSessionManager *)m request:(NSURLRequest *)req {
    __blockSelf_(__self);
    NSDate *startTime = [NSDate date];
    _task = [m downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        if (__self.progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __self.progressBlock(downloadProgress);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        // 保存路径
        NSString *filePath = __self.filePath;
        if (__self.filePathBlock)
            __self.filePath = filePath = __self.filePathBlock(targetPath, response).relativePath;
        
        else if (!__self.filePath.length)
            filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 请求结果
        __self.duration = [[NSDate date] timeIntervalSinceDate:startTime] * 1000;
        __self.response = response;
        __self.responseObject = filePath.absoluteString;
        __self.error = error;
        
        [__self callback];
    }];
    _afsm = m;
    return (id)_task;
}

- (NSURLSessionDownloadTask *)downloadTask:(AFHTTPSessionManager *)m resumeData:(NSData *)rd {
    __blockSelf_(__self);
    NSDate *startTime = [NSDate date];
    _task = [m downloadTaskWithResumeData:rd progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        if (__self.progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __self.progressBlock(downloadProgress);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 保存路径
        NSString *filePath = __self.filePath;
        if (__self.filePathBlock)
            __self.filePath = filePath = __self.filePathBlock(targetPath, response).absoluteString;
        
        else if (!__self.filePath.length)
            filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 请求结果
        __self.duration = [[NSDate date] timeIntervalSinceDate:startTime] * 1000;
        __self.response = response;
        __self.responseObject = filePath.absoluteString;
        __self.error = error;
        
        [__self callback];
    }];
    _afsm = m;
    return (id)_task;
}

- (NSURLSessionUploadTask *)uploadTask:(AFHTTPSessionManager *)m request:(NSURLRequest *)req files:(NSArray<ZJUploadFileModel *> *)files {
    _files = files;
    
    __blockSelf_(__self);
    NSDate *startTime = [NSDate date];
    _task = [m uploadTaskWithStreamedRequest:req progress:^(NSProgress * _Nonnull uploadProgress) {
        // 上传进度
        if (__self.progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __self.progressBlock(uploadProgress);
            });
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        // 请求结果
        __self.duration = [[NSDate date] timeIntervalSinceDate:startTime] * 1000;
        __self.response = response;
        __self.responseObject = responseObject;
        __self.error = error;
        
        [__self callback];
    }];
    _afsm = m;
    return (id)_task;
}

- (void)callback {
    // 请求失败，且不为超时，则忽略此次报错，并重新发起一次请求
    if (_reconnectCnt--) {
        if (_error && _error.code != -1001 && [_task isKindOfClass:[NSURLSessionDataTask class]]) {
            [[self dataTask:_afsm request:_task.originalRequest] resume];
            return;
        }
    }
    
    // 定制错误信息
    if ([(id)self.delegate respondsToSelector:@selector(validationError:)])
        _error = [self.delegate validationError:self];
    
    //
    if ([(id)_delegate respondsToSelector:@selector(requestCompletionAndWillCallBlock:)])
        [_delegate requestCompletionAndWillCallBlock:self];
    
    if (!_error) {
        // 请求成功回调
        if (_successBlock) _successBlock(_responseObject);
    } else {
        // 请求失败回调
        if (_failureBlock) _failureBlock(_error);
    }
    
    // 请求完成回调
    if (_completionBlock)
        _completionBlock(self);
    
    // 显示错误信息HUD
    if (!_noShowErrorHUD && _error.domain.length)
        [HUDHelper showMsg:_error.domain];
    
    _successBlock = nil;
    _failureBlock = nil;
    _completionBlock = nil;
}

@end



@implementation ZJUploadFileModel
MJCodingImplementation
@end

