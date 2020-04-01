//
//  CMCommonHook.m
//  ug
//
//  Created by ug on 2019/12/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMCommonHook.h"
#import <SafariServices/SafariServices.h>
@implementation CMCommonHook
///// 对象调用时，放回对象
//- (id)instance;
///// 方法的原始实现
//- (NSInvocation *)originalInvocation;
///// 原方法调用的参数
//- (NSArray *)arguments;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SFSafariViewController cc_hookSelector:@selector(initWithURL:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> ai) {
            NSURL *url = ai.arguments.firstObject;
            if (url.scheme == nil) {
                url = [NSURL URLWithString:_NSString(@"http://%@", url.absoluteString)];
                [ai.originalInvocation setArgument:&url atIndex:2];
            }
        } error:nil];
    });
}

@end
