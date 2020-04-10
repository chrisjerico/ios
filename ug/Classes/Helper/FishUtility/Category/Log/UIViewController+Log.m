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
        
        __block NSDate *__lastDate = nil;
        NSMutableDictionary *dict = @{}.mutableCopy;
        [UIView cc_hookSelector:@selector(didAddSubview:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
            UIView *v = ai.arguments.lastObject;
            if (v.classIsCustom) {
                dict[NSStringFromClass(v.class)] = @([dict[NSStringFromClass(v.class)] intValue] + 1);
                __lastDate = [NSDate date];
//                NSLog(@"——————————————添加自定义View： %@", NSStringFromClass(v.class));
            }
        } error:nil];
        
        static NSTimer *__timer;
        __timer = [NSTimer scheduledTimerWithInterval:0.8 repeats:true block:^(NSTimer *timer) {
            if ([__lastDate timeIntervalSinceDate:[NSDate date]] < -1) {
                for (NSString *clsName in dict.allKeys) {
                    NSLog(@"——————————————添加了 %@ 个自定义View： %@", dict[clsName], clsName);
                }
                [dict removeAllObjects];
            }
        }];
        
//        [UIButton cc_hookSelector:@selector(addTarget:action:forControlEvents:)
//                             withOptions:AspectPositionAfter
//                              usingBlock:^(id<AspectInfo> aspectInfo, id target, SEL action, UIControlEvents controlEvents) {
//
//                                  if ([aspectInfo.instance isKindOfClass:[UIButton class]]) {
//
//                                      UIButton *button = aspectInfo.instance;
//                                      button.accessibilityHint = NSStringFromSelector(action);
//                                  }
//                              } error:NULL];
//           
//        [UIControl cc_hookSelector:@selector(beginTrackingWithTouch:withEvent:)
//                              withOptions:AspectPositionAfter
//                               usingBlock:^(id<AspectInfo> aspectInfo, UITouch *touch, UIEvent *event) {
//
//                                   if ([aspectInfo.instance isKindOfClass:[UIButton class]]) {
//
//                                       UIButton *button = aspectInfo.instance;
//                                       id object =  [button.allTargets anyObject];
//                                       NSString *className = NSStringFromClass([object class]);
//                                       NSLog(@"——————————————当前控制器：%@ ——————————————按钮方法：%@",className,button.accessibilityHint);
//                                   }
//                               } error:NULL];
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