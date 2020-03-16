//
//  NSURL+Utils.m
//  C
//
//  Created by fish on 2018/6/29.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "NSURL+Utils.h"

@implementation NSURL (Utils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSURL jr_swizzleClassMethod:@selector(URLWithString:) withClassMethod:@selector(cc_utils_URLWithString:) error:nil];
    });
}

+ (instancetype)cc_utils_URLWithString:(NSString *)URLString {
    return [self cc_utils_URLWithString:URLString.urlEncodedString];
}

@end
