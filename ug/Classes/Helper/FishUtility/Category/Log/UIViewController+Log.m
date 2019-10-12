//
//  UIViewController+Log.m
//  Eyesir
//
//  Created by fish on 16/6/6.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import "UIViewController+Log.h"
#import "JRSwizzle.h"

@implementation UIViewController (Log)

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController jr_swizzleMethod:@selector(cc_dealloc) withMethod:NSSelectorFromString(@"dealloc") error:nil];
        [UIViewController jr_swizzleMethod:@selector(cc_viewWillAppear:) withMethod:@selector(viewWillAppear:) error:nil];
    });
}

- (void)cc_dealloc {
    NSLog(@"—————————————— %@   被释放", [self class]);
    [self cc_dealloc];
}

- (void)cc_viewWillAppear:(BOOL)animated {
    NSLog(@"—————————————— %@   将出现", [self class]);
    [self cc_viewWillAppear:animated];
}

@end
