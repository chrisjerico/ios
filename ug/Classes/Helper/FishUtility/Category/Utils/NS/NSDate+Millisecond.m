//
//  NSDate+Millisecond.m
//  C
//
//  Created by fish on 2018/11/19.
//  Copyright © 2018 fish. All rights reserved.
//

#import "NSDate+Millisecond.h"

@implementation NSDate (Millisecond)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSDate jr_swizzleMethod:@selector(timeAgoSinceNow) withMethod:@selector(zj_timeAgoSinceNow) error:nil];
    });
}

- (NSTimeInterval)millisecondIntervalSince1970 {
    return self.timeIntervalSince1970 * 1000;
}

+ (instancetype)dateWithMillisecondIntervalSince1970:(NSTimeInterval)secs {
    return [NSDate dateWithTimeIntervalSince1970:secs / 1000.0];
}

- (NSString *)zj_timeAgoSinceNow {
    return [self timeAgoSinceDate:[NSDate date] numericDates:true];
}

@end
