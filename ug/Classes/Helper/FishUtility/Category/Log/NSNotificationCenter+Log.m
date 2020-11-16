//
//  NSNotificationCenter+Log.m
//  UGBWApp
//
//  Created by fish on 2020/10/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NSNotificationCenter+Log.h"

@implementation NSNotificationCenter (Log)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSNotificationCenter jr_swizzleMethod:@selector(postNotificationName:object:userInfo:) withMethod:@selector(cc_postNotificationName:object:userInfo:) error:nil];
    });
}

- (void)cc_postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {    
    if ([aName hasPrefix:@"UG"]) {
        NSLog(@"发送通知  = %@", aName);
    }
    [self cc_postNotificationName:aName object:anObject userInfo:aUserInfo];
}

@end
