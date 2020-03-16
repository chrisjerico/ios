//
//  NSString+Safe.m
//  C
//
//  Created by fish on 2018/10/18.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "NSString+Safe.h"
#import "JRSwizzle.h"

@implementation NSString (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jr_swizzleClassMethod:@selector(stringByAppendingString:) withClassMethod:@selector(ccSafe_stringByAppendingString:) error:nil];
    });
}

- (NSString *)ccSafe_stringByAppendingString:(NSString *)aString {
    NSAssert(aString, _NSString(@"*** -[%@ stringByAppendingString:]: nil argument", [self class]));
    if (aString)
        return [self ccSafe_stringByAppendingString:aString];
    NSLog(@"*** -[%@ stringByAppendingString:]: nil argument", [self class]);
    return [self copy];
}

- (NSString *)stringValue {
    return [self copy];
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return nil;
}
@end
