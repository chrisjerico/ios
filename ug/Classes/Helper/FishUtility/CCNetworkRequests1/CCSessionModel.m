//
//  CCSessionModel.m
//  Consult
//
//  Created by fish on 2017/10/26.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "CCSessionModel.h"
#import "AFNetworking.h"

@implementation CCSessionModel

MJCodingImplementation

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"task", @"delegate",
             @"successBlock", @"failureBlock", @"completionBlock", @"filePathBlock", @"progressBlock", ];
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
        
        else if (!__self.filePath.length) {
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"yyyyMMddHHmmss"];
            filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:_NSString(@"%@_%@", [df stringFromDate:[NSDate date]], response.suggestedFilename)];
        }
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 请求结果
        __self.duration = [[NSDate date] timeIntervalSinceDate:startTime] * 1000;
        __self.response = response;
        __self.responseObject = filePath.relativePath;
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

- (NSURLSessionUploadTask *)uploadTask:(AFHTTPSessionManager *)m request:(NSURLRequest *)req files:(NSArray<CCUploadFileModel *> *)files {
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
    if (_reconnectCnt-- > 0) {
        if (_error && _error.code != -1001 && [_task isKindOfClass:[NSURLSessionDataTask class]]) {
            if (self.params[@"上传文件"]) {
                [[self uploadTask:_afsm request:_task.originalRequest files:nil] resume];
            } else {
                [[self dataTask:_afsm request:_task.originalRequest] resume];
            }
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
#ifdef APP_VERSION
    if (!_noShowErrorHUD && _error.domain.length) {
        [SVProgressHUD showErrorWithStatus:_error.domain];
    }
#endif
    
    
    _successBlock = nil;
    _failureBlock = nil;
    _completionBlock = nil;
}

@end



@implementation CCUploadFileModel
MJCodingImplementation
@end

