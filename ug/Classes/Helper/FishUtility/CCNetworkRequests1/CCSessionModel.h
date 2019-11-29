//
//  CCSessionModel.h
//  Consult
//
//  Created by fish on 2017/10/26.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;
@class CCUploadFileModel;
@class CCSessionModel;

@protocol CCRequestDelegate
- (NSError *)validationError:(CCSessionModel *)sm;
- (void)requestCompletionAndWillCallBlock:(CCSessionModel *)sm;
@end


/*
 * CC网络会话的数据模型
 * 功能：设置回调 和 获取请求/响应的信息
 */
@interface CCSessionModel : NSObject

// 以下为初始化时赋值字段
@property (nonatomic, copy) NSString *urlString;              /**<    URL */
@property (nonatomic) NSDictionary *params;                   /**<    参数 */
@property (nonatomic) BOOL isPOST;                            /**<    isPOST */
@property (nonatomic) NSInteger reconnectCnt;                 /**<    非接口报错的请求失败，会重新发起（指定次数）请求 */

// 以下为不可修改字段
@property (nonatomic, weak) NSURLSessionTask *task;           /**<    请求任务 */
@property (nonatomic, weak) AFHTTPSessionManager *afsm;       /**<    会话管理器 */
@property (nonatomic, weak) id <CCRequestDelegate> delegate;  /**<    Delegate */

@property (nonatomic) NSError *error;                         /**<    错误信息 */
@property (nonatomic) id responseObject;                      /**<    返回的数据 */
@property (nonatomic) NSHTTPURLResponse *response;            /**<    描述响应（响应头、响应体） */
@property (nonatomic) NSTimeInterval duration;                /**<    请求响应时长(ms) */

+ (NSString *)printURLString:(NSString *)URLString params:(NSDictionary *)params;           /**<    拼接URL */

- (NSURLSessionDataTask *)dataTask:(AFHTTPSessionManager *)m request:(NSURLRequest *)req;   /**<    获取请求Tast */

@end



// ———— 上传和下载接口
@interface CCSessionModel ()

@property (nonatomic) NSString *filePath;                     /**<    下载文件的存储地址 */
@property (nonatomic) NSArray <CCUploadFileModel *>*files;    /**<    上传的文件列表 */

- (NSURLSessionDownloadTask *)downloadTask:(AFHTTPSessionManager *)m request:(NSURLRequest *)req;
- (NSURLSessionDownloadTask *)downloadTask:(AFHTTPSessionManager *)m resumeData:(NSData *)rd;
- (NSURLSessionUploadTask *)uploadTask:(AFHTTPSessionManager *)m request:(NSURLRequest *)req files:(NSArray <CCUploadFileModel *>*)files;
@end


// ———— TaskBlock 回调
@interface CCSessionModel ()

@property (nonatomic) BOOL noShowErrorHUD;    /**<    取消请求失败时显示的错误信息HUD */

@property (nonatomic) void (^successBlock)(id responseObject);                                /**<    请求成功 */
@property (nonatomic) void (^failureBlock)(NSError *error);                                   /**<    请求失败 */
@property (nonatomic) void (^completionBlock)(CCSessionModel *sm);                          /**<    请求完成 */

@property (nonatomic) NSURL *(^filePathBlock)(NSURL *targetPath, NSURLResponse *response);    /**<    设置下载文件的保存路径 */
@property (nonatomic) void (^progressBlock)(NSProgress *progress);                            /**<    上传/下载 进度回调 */

- (void)setSuccessBlock:(void(^)(id responseObject))successBlock failureBlock:(void(^)(NSError *error))failureBlock;
@end



/*
 * 描述一个要上传的文件
 */
@interface CCUploadFileModel : NSObject

@property (nonatomic, copy) NSString *filePath;                /**<    文件本地路径 */
@property (nonatomic, copy) NSString *name;                    /**<    key */
@property (nonatomic, copy) NSString *filename;                /**<    上传后保存的文件名 */
@property (nonatomic, copy) NSString *mimeType;                /**<    mimeType */
@end

