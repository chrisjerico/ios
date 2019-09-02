//
//  SAROPSessionTask.m
//  ChargeManage
//
//  Created by sagesse on 5/19/16.
//  Copyright © 2016 Shenzhen Comtop Information Techology Co., Ltd. All rights reserved.
//

#import "SAROPSessionTask.h"

@interface SAROPSessionTask ()
@property (nonatomic, strong) NSURLSessionTask* task;
@end

@implementation SAROPSessionTask

+ (instancetype)taskWithTask:(NSURLSessionTask*)task {
    SAROPSessionTask* stask = [[self alloc] init];
    stask.task = task;
    return stask;
}

//@property (readonly, copy) NSURLRequest  *originalRequest;
//@property (readonly, copy) NSURLRequest  *currentRequest;
//@property (readonly, copy) NSURLResponse *response;
//
//@property (readonly) int64_t countOfBytesReceived;
//@property (readonly) int64_t countOfBytesSent;
//@property (readonly) int64_t countOfBytesExpectedToSend;
//@property (readonly) int64_t countOfBytesExpectedToReceive;
//
//@property (readonly) NSUInteger    taskIdentifier;
//@property (readonly) NSURLSessionTaskState state;
//
//@property (readonly, copy) NSString *taskDescription;
//@property (readonly, copy) NSError *error;
//
//- (void)cancel;
//- (void)suspend;
//- (void)resume;
#pragma mark - Method

- (void)cancel {
    [self.task cancel];
}
- (void)suspend {
    [self.task suspend];
}
- (void)resume {
    [self.task resume];
}

#pragma mark - Getter

- (NSURLRequest*)originalRequest {
    return self.task.originalRequest;
}
- (NSURLRequest*)currentRequest {
    return self.task.currentRequest;
}
- (NSURLResponse*)response {
    return self.task.response;
}

- (int64_t)countOfBytesReceived {
    return self.task.countOfBytesReceived;
}
- (int64_t)countOfBytesSent {
    return self.task.countOfBytesSent;
}
- (int64_t)countOfBytesExpectedToSend {
    return self.task.countOfBytesExpectedToSend;
}
- (int64_t)countOfBytesExpectedToReceive {
    return self.task.countOfBytesExpectedToReceive;
}

- (NSUInteger)taskIdentifier {
    return self.task.taskIdentifier;
}
- (NSURLSessionTaskState)state {
    return self.task.state;
}

- (NSString*)taskDescription {
    return self.task.taskDescription;
}
- (NSError*)error {
    return self.task.error;
}

@end
