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
        
        [UIView aspect_hookSelector:@selector(addSubview:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
            UIView *v = ai.arguments.lastObject;
            if (v.classIsCustom) {
                NSLog(@"——————————————添加自定义View： %@", v.class);
            }
        } error:nil];
    });
}

- (void)cc_dealloc {
    if (self.classIsCustom)
        NSLog(@"——————————————控制器释放： %@，title=%@", [self class], self.title);
    [self cc_dealloc];
}

- (void)cc_viewWillAppear:(BOOL)animated {
    if (self.classIsCustom)
        NSLog(@"——————————————控制器出现： %@，title=%@", [self class], self.title);
    [self cc_viewWillAppear:animated];
}

@end
