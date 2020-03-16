//
//  SAROPSession.h
//  ChargeManage
//
//  Created by sagesse on 5/19/16.
//  Copyright © 2016 Shenzhen Comtop Information Techology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SAROPSessionTask.h"
#import "SAROPSessionStorage.h"
#import "SAROPSessionConfiguration.h"



///
/// @brief ROP会话
///
@interface SAROPSession : NSObject

@property (nonatomic, readonly) SAROPSessionStorage* storage;
@property (nonatomic, readonly) SAROPSessionConfiguration* configuration;

/// 全局的会话
+ (instancetype)sharedSession;

/// 自定义的会话
+ (instancetype)sessionWithConfiguration:(SAROPSessionConfiguration*)configuration;
+ (instancetype)sessionWithConfiguration:(SAROPSessionConfiguration*)configuration
                                 storage:(SAROPSessionStorage*)storage;


- (void)finishTasksAndInvalidate;
- (void)invalidateAndCancel;

#pragma mark - Version 2.0

///
/// 获取数据任务
///
- (SAROPSessionTask*)dataTaskWithURL:(NSString*)URL
                              method:(NSString*)method
                             version:(NSString*)version
                          parameters:(NSDictionary*)parameters
                   completionHandler:(void (^)(NSDictionary* json, NSURLResponse* response, NSError* error))completionHandler;

#pragma mark - Version 1.0

///
/// 获取重定向地址(从配置读取URL)
///
- (NSURL*)redirectURLWithURL:(NSURL*)URL;

///
/// 获取数据任务(从配置读取URL)
///
- (SAROPSessionTask*)dataTaskWithMethod:(NSString*)method
                                version:(NSString*)version
                             parameters:(NSDictionary*)parameters
                      completionHandler:(void (^)(NSDictionary* json, NSURLResponse* response, NSError* error))completionHandler;
@end

///
/// @brief ROP错误信息
///
@interface NSError (SAROPSession)

@property (nonatomic, readonly) BOOL isURLError;
@property (nonatomic, readonly) BOOL isHTTPError;
@property (nonatomic, readonly) BOOL isROPError;

@property (nonatomic, readonly) NSString* ROPReason;
@property (nonatomic, readonly) NSString* ROPMessage;
@property (nonatomic, readonly) NSString* ROPSolution;

@property (nonatomic, readonly) NSArray* ROPSubErrors;

@end
