//
//  UIScrollView+Utils.m
//  C
//
//  Created by fish on 2018/9/17.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "UIScrollView+Utils.h"

@implementation UIScrollView (Utils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIScrollView jr_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(utils_didMoveToSuperview) error:nil];
        [UIScrollView jr_swizzleMethod:@selector(touchesShouldBegin:withEvent:inContentView:) withMethod:@selector(utils_touchesShouldBegin:withEvent:inContentView:) error:nil];
    });
}

- (void)utils_didMoveToSuperview {
    [self utils_didMoveToSuperview];
    if (OBJOnceToken(self)) {
        // 拖拽UIScrollView时，收起键盘
        [self xw_addObserverBlockForKeyPath:@"contentOffset" block:^(UIScrollView *scrollView, id  _Nonnull oldVal, id  _Nonnull newVal) {
            if (scrollView.dragging && [scrollView existSuperview:NavController1.topView] && (![scrollView isKindOfClass:[UITextView class]] || ![scrollView isKindOfClass:NSClassFromString(@"YYTextView")]))
                [NavController1.topView endEditing:true];
        }];
        // 关闭系统自适应contentInset
        if (@available(iOS 11.0, *)) {
            if ([self isMemberOfClass:[UIScrollView class]] ||
                [self isMemberOfClass:[UITableView class]] ||
                [self isMemberOfClass:[UICollectionView class]]) {
                self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
    }
}

- (BOOL)utils_touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    // 点击UIScrollView时收起键盘
    if (!([view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:NSClassFromString(@"YYTextView")]))
        if ([self existSuperview:NavController1.topView])
            [NavController1.topView endEditing:true];
    return [self utils_touchesShouldBegin:touches withEvent:event inContentView:view];
}

@end
