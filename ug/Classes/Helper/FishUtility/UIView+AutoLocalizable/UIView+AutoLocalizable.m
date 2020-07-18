//
//  UIView+AutoLayoutText.m
//  Eyesir
//
//  Created by fish on 16/7/22.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "UIView+AutoLocalizable.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"
#import "RCTRawTextShadowView.h"


@implementation UIView (AutoLocalizable)

static BOOL _EnableAutoLocalizable = false;


- (BOOL)disableAutoLocalizable {
    return [objc_getAssociatedObject(self, @selector(disableAutoLocalizable)) boolValue];
}

- (void)setDisableAutoLocalizable:(BOOL)disableAutoLocalizable {
    objc_setAssociatedObject(self, @selector(disableAutoLocalizable), @(disableAutoLocalizable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)enableAutoLocalizable {
    _EnableAutoLocalizable = true;
}

#pragma mark - Swizzle Method

+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UILabel jr_swizzleMethod:@selector(cc_awakeFromNib_autoLocalizable) withMethod:@selector(awakeFromNib) error:nil];
        [UITextField jr_swizzleMethod:@selector(cc_awakeFromNib_autoLocalizable) withMethod:@selector(awakeFromNib) error:nil];
        [UITextView jr_swizzleMethod:@selector(cc_awakeFromNib_autoLocalizable) withMethod:@selector(awakeFromNib) error:nil];
        [UIButton jr_swizzleMethod:@selector(cc_awakeFromNib_autoLocalizable) withMethod:@selector(awakeFromNib) error:nil];
        
        [UILabel jr_swizzleMethod:@selector(cc_setText:) withMethod:@selector(setText:) error:nil];
        [UITextField jr_swizzleMethod:@selector(cc_setText:) withMethod:@selector(setText:) error:nil];
        [UITextView jr_swizzleMethod:@selector(cc_setText:) withMethod:@selector(setText:) error:nil];
        
        [UIButton jr_swizzleMethod:@selector(cc_setTitle:forState:) withMethod:@selector(setTitle:forState:) error:nil];
        
        [UINavigationItem cc_hookSelector:@selector(setTitle:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
            if (_EnableAutoLocalizable) {
                NSString *title = ai.arguments.lastObject;
                title = [[LanguageHelper shared] stringForCnString:title];
                [ai.originalInvocation setArgument:&title atIndex:2];
            }
            [ai.originalInvocation invoke];
        } error:nil];
        
        [UIViewController cc_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            UIViewController *vc = ai.instance;
            if (vc.navigationItem.title.length)
                vc.navigationItem.title = vc.navigationItem.title;
        } error:nil];
        
        [RCTRawTextShadowView cc_hookSelector:@selector(setText:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            NSString *text = ai.arguments.firstObject;
            text = [[LanguageHelper shared] stringForCnString:text];
            [ai.originalInvocation setArgument:&text atIndex:2];
            [ai.originalInvocation invoke];
        } error:nil];
    });
}

- (void)cc_awakeFromNib_autoLocalizable {
    [self cc_awakeFromNib_autoLocalizable];
    
    // 设置文本本地化
    // 从 xib中加载View不会调用setText:函数，故需要手动调一遍setText:
    if ([self isKindOfClass:[UILabel class]] ||
        [self isKindOfClass:[UITextField class]] ||
        [self isKindOfClass:[UITextView class]]) {
        UILabel *lb = (UILabel *)self;
        lb.text = lb.text;
    }
    else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self;
        [btn setTitle:[btn titleForState:UIControlStateNormal] forState:UIControlStateNormal];
        [btn setTitle:[btn titleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        [btn setTitle:[btn titleForState:UIControlStateDisabled] forState:UIControlStateDisabled];
        [btn setTitle:[btn titleForState:UIControlStateSelected] forState:UIControlStateSelected];
    }
}

- (void)cc_setText:(NSString * _Nullable)text {
    // UITextField、UITextView可编辑时不替换文本
    if ([self isKindOfClass:[UITextField class]] && ((UITextField *)self).userInteractionEnabled) {}
    else if ([self isKindOfClass:[UITextView class]] && ((UITextView *)self).userInteractionEnabled && ((UITextView *)self).editable) {}
    else if (_EnableAutoLocalizable && !self.disableAutoLocalizable && ![self.superview isKindOfClass:[UIButton class]]) {
        text = [[LanguageHelper shared] stringForCnString:text];
    }
    [self cc_setText:text];
}

- (void)cc_setTitle:(nullable NSString *)string forState:(UIControlState)state {
    if (_EnableAutoLocalizable && !self.disableAutoLocalizable) {
        string = [[LanguageHelper shared] stringForCnString:string];
    }
    [self cc_setTitle:string forState:state];
}

+ (void)autoLocalizableView:(UIView *)view {
    // 设置文本本地化
    // 从 xib中加载View不会调用setText:函数，故需要手动调一遍setText:
    if ([view isKindOfClass:[UILabel class]] ||
        [view isKindOfClass:[UITextField class]] ||
        [view isKindOfClass:[UITextView class]]) {
        UILabel *lb = (UILabel *)view;
        lb.text = lb.text;
    }
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        [btn setTitle:[btn titleForState:UIControlStateNormal] forState:UIControlStateNormal];
        [btn setTitle:[btn titleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        [btn setTitle:[btn titleForState:UIControlStateDisabled] forState:UIControlStateDisabled];
        [btn setTitle:[btn titleForState:UIControlStateSelected] forState:UIControlStateSelected];
    }
    for (UIView *subview in view.subviews) {
        [UIView autoLocalizableView:subview];
    }
}

@end
