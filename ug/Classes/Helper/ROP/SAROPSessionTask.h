//
//  SAROPSessionTask.h
//  ChargeManage
//
//  Created by sagesse on 5/19/16.
//  Copyright © 2016 Shenzhen Comtop Information Techology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAROPSessionTask : NSObject

+ (instancetype)taskWithTask:(NSURLSessionTask*)task;

@property (readonly, copy) NSURLRequest  *originalRequest;
@property (readonly, copy) NSURLRequest  *currentRequest;
@property (readonly, copy) NSURLResponse *response;

@property (readonly) int64_t countOfBytesReceived;
@property (readonly) int64_t countOfBytesSent;
@property (readonly) int64_t countOfBytesExpectedToSend;
@property (readonly) int64_t countOfBytesExpectedToReceive;

@property (readonly) NSUInteger    taskIdentifier;
@property (readonly) NSURLSessionTaskState state;

@property (readonly, copy) NSString *taskDescription;
@property (readonly, copy) NSError *error;

- (void)cancel;
- (void)suspend;
- (void)resume;

@end
