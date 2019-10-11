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
        [UIViewController jr_swizzleMethod:@selector(cc_becomeFirstResponder) withMethod:@selector(becomeFirstResponder) error:nil];
        [UIViewController jr_swizzleMethod:@selector(cc_awakeFromNib) withMethod:@selector(awakeFromNib) error:nil];
    });
}

- (void)cc_dealloc {
    NSLog(@"—————————————— %@   被释放", [self class]);
    [self cc_dealloc];
}

- (BOOL)cc_becomeFirstResponder {
    NSLog(@"%@ 变成第一响应者", [self class]);
    return [self cc_becomeFirstResponder];
}

- (void)cc_awakeFromNib {
    [self cc_becomeFirstResponder];
    //    NSLog(@"%@ 从图形界面中加载成功！", [self class]);
}

@end
