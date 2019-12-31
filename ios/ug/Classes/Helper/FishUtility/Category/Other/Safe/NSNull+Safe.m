//
//  NSNull+ExtractingNumericValues.m
//  
//
//  Created by fish on 15/10/14.
//  Copyright © 2015年 fish. All rights reserved.
//

#import "NSNull+Safe.h"
#import <objc/runtime.h>

@implementation NSNull (Safe)

void * _func (id self, SEL sel, ...) {
//    NSLog(@"———————— < NSNull > 调用了无效函数， [< NSNull > %@]", NSStringFromSelector(sel));
    return nil;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return class_addMethod(self, sel, (IMP)_func, "^v24@0:8^v16");
}

@end
