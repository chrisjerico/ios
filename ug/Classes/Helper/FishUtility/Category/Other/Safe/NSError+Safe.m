//
//  NSError+Safe.m
//  ug
//
//  Created by ug on 2019/12/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "NSError+Safe.h"

@implementation NSError (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSError jr_swizzleMethod:@selector(initWithDomain:code:userInfo:) withMethod:@selector(cc_initWithDomain:code:userInfo:) error:nil];
    });
}

- (instancetype)cc_initWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict {
    NSLog(@"cc_initWithDomain");
    if (!domain) {
        return nil;
    }
    return [self cc_initWithDomain:domain code:code userInfo:dict];
}

@end
