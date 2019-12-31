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
        [CMCommonHook hookSFSafari];
    });
}

+(void)hookSFSafari{
    [SFSafariViewController cc_hookSelector:@selector(initWithURL:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> ai) {
        //            NSLog(@"ai = %@",ai);
        //            NSLog(@"ai.arguments= %@",ai.arguments);
        NSInvocation *invocation = ai.originalInvocation;
        NSURL *url = [ai.arguments objectAtIndex:0];
        NSString *urlStr = [url absoluteString];
        //            NSLog(@"urlStr = %@",urlStr);
        if (urlStr.length) {
            if ([urlStr hasPrefix:@"http"]) {
                //把参数给原来的方法；
                NSURL *ul = [NSURL URLWithString:urlStr];
                [invocation setArgument:&ul atIndex:2];
                [invocation invoke];
            }
            else{
                NSString *newUrlStr = [NSString stringWithFormat:@"http://%@",urlStr];
                //把参数给原来的方法；
                NSURL *ul = [NSURL URLWithString:newUrlStr];
                [invocation setArgument:&ul atIndex:2];
                [invocation invoke];
            }
        }
        
    } error:nil];
}
@end
