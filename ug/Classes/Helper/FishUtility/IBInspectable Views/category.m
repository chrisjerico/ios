//
//  category.m
//  C
//
//  Created by fish on 2018/12/4.
//  Copyright © 2018 fish. All rights reserved.
//

#import "category.h"
#import "NSMutableAttributedString+Utils.h"
#import "zj_runtime_property.h"
#import "JRSwizzle.h"
#import "RegExCategories.h"

// —————————— IBInspectableUtils 类别
// ——————————————————————————————————————————————————

@implementation UILabel (IBInspectableUtils)
_ZJRuntimeGetterDoubleValue(CGFloat, lineSpacing1)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UILabel jr_swizzleMethod:@selector(textRectForBounds:limitedToNumberOfLines:) withMethod:@selector(zj_textRectForBounds:limitedToNumberOfLines:) error:nil];
        [UILabel jr_swizzleMethod:@selector(drawTextInRect:) withMethod:@selector(zj_drawTextInRect:) error:nil];
    });
}

- (CGRect)zj_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGPoint padding = self.内边距;
    UIEdgeInsets insets = UIEdgeInsetsMake(padding.y, padding.x, padding.y, padding.x);
    CGRect rect = [self zj_textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets) limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    return rect;
}

- (void)zj_drawTextInRect:(CGRect)rect {
    CGPoint padding = self.内边距;
    [self zj_drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(padding.y, padding.x, padding.y, padding.x))];
}

- (CGPoint)内边距 {
    return [objc_getAssociatedObject(self, @selector(内边距)) CGPointValue];
}

- (void)set内边距:(CGPoint)内边距 {
    objc_setAssociatedObject(self, @selector(内边距), [NSValue valueWithCGPoint:内边距], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLineSpacing1:(CGFloat)lineSpacing1 {
    objc_setAssociatedObject(self, @selector(lineSpacing1), @(lineSpacing1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateAttributedText:^(NSMutableAttributedString *attributedText) {
        attributedText.lineSpacing = lineSpacing1;
    }];
}
@end





@implementation UITextField (IBInspectableUtils)
_ZJRuntimeProperty_Assign(NSUInteger, 限制长度, set限制长度)
_ZJRuntimeProperty_Assign(BOOL, 仅数字, set仅数字)
_ZJRuntimeProperty_Assign(BOOL, 禁用符号, set禁用符号)
_ZJRuntimeProperty_Assign(BOOL, 禁用特殊字符, set禁用特殊字符)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换setDelegate:方法
        [UITextField jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(zj_layoutSubviews) error:nil];
        [UITextField jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(zj_setDelegate:) error:nil];
        // 监听文本长度
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            UITextField *tf = note.object;
            if (tf.限制长度) {
                UITextPosition *position = [tf positionFromPosition:[tf markedTextRange].start offset:0];
                if (!position && tf.text.length > tf.限制长度) {
                    tf.text = [tf.text substringToIndex:tf.限制长度];
                    [HUDHelper showMsg:_NSString(@"不得超过%d字符", (int)tf.限制长度)];
                }
            }
        }];
    });
}
- (void)zj_layoutSubviews {
    if (!self.delegate) {
        zj_once_block(self, ^{
            self.delegate = (id)self;
        });
    }
    [self zj_layoutSubviews];
}
- (void)zj_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self zj_setDelegate:delegate];
    if ([delegate isKindOfClass:[NSObject class]]) {
        zj_once_block(delegate, ^{
            [(id)delegate aspect_hookSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aInfo) {
                [aInfo.originalInvocation invoke];
                // 过滤文本
                UITextField *tf = aInfo.arguments.firstObject;
                NSString *text = aInfo.arguments[2];
                BOOL ret = true;
                if (tf.仅数字)
                    ret &= [text isMatch:RX(@"^[0-9]*$")];
                else if (tf.禁用符号)
                    ret &= [text isMatch:RX(@"^[0-9A-Za-z]*$")];
                else if (tf.禁用特殊字符)
                    ret &= [text isMatch:RX(@"^[\x20-\x7E]*$")];    // 不使用原生的正则函数是因为，原生函数会把中文标点符号误认为ASCII符号而匹配通过，比如“。”->"." 或 “，”->","
                if (!ret)
                    [aInfo.originalInvocation setReturnValue:&ret];
            } error:nil];
        });
    }
}
@end




@implementation UITextView (IBInspectableUtils)
_ZJRuntimeProperty_Assign(NSUInteger, 限制长度, set限制长度)
_ZJRuntimeProperty_Assign(BOOL, 仅数字, set仅数字)
_ZJRuntimeProperty_Assign(BOOL, 禁用符号, set禁用符号)
_ZJRuntimeProperty_Assign(BOOL, 禁用特殊字符, set禁用特殊字符)
_ZJRuntimeGetterDoubleValue(BOOL, 内容紧贴边框)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换setDelegate:方法
        [UITextView jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(zj_layoutSubviews) error:nil];
        [UITextView jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(zj_setDelegate:) error:nil];
        // 监听文本长度
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            UITextView *tf = note.object;
            if (tf.限制长度) {
                UITextPosition *position = [tf positionFromPosition:[tf markedTextRange].start offset:0];
                if (!position && tf.text.length > tf.限制长度) {
                    tf.text = [tf.text substringToIndex:tf.限制长度];
                    [HUDHelper showMsg:_NSString(@"不得超过%d字符", (int)tf.限制长度)];
                }
            }
        }];
    });
}
- (void)zj_layoutSubviews {
    if (!self.delegate) {
        zj_once_block(self, ^{
            self.delegate = (id)self;
        });
    }
    [self zj_layoutSubviews];
}
- (void)zj_setDelegate:(id<UITextViewDelegate>)delegate {
    [self zj_setDelegate:delegate];
    if ([delegate isKindOfClass:[NSObject class]]) {
        zj_once_block(delegate, ^{
            [(id)delegate aspect_hookSelector:@selector(textView:shouldChangeTextInRange:replacementText:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aInfo) {
                [aInfo.originalInvocation invoke];
                // 过滤文本
                UITextView *tf = aInfo.arguments.firstObject;
                NSString *text = aInfo.arguments[2];
                BOOL ret = true;
                if (tf.仅数字)
                    ret &= [text isMatch:RX(@"^[0-9]*$")];
                else if (tf.禁用符号)
                    ret &= [text isMatch:RX(@"^[0-9A-Za-z]*$")];
                else if (tf.禁用特殊字符)
                    ret &= [text isMatch:RX(@"^[\x20-\x7E]*$")];    // 不使用原生的正则函数是因为，原生函数会把中文标点符号误认为ASCII符号而匹配通过，比如“。”->"." 或 “，”->","
                if (!ret)
                    [aInfo.originalInvocation setReturnValue:&ret];
            } error:nil];
        });
    }
}
- (void)set内容紧贴边框:(BOOL)内容紧贴边框 {
    objc_setAssociatedObject(self, @selector(内容紧贴边框), @(内容紧贴边框), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (内容紧贴边框)
        self.contentInset = UIEdgeInsetsMake(-8, -5, -8, -5);
}
@end


@interface NSObject (IBInspectableUtils)
@end
@implementation NSObject (IBInspectableUtils)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return true;
}
@end





@implementation UISearchBar (IBInspectableUtils)
_ZJRuntimeProperty_Retain(UIColor *, textColor, setTextColor)
_ZJRuntimeProperty_Assign(CGFloat, fontSize, setFontSize)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UISearchBar jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(zjIBView_layoutSubviews) error:nil];
    });
}
- (void)zjIBView_layoutSubviews {
    [self zjIBView_layoutSubviews];
    self.textField.font = [UIFont systemFontOfSize:self.fontSize];
    self.textField.textColor = self.textColor;
}
- (UITextField *)textField {
    for (UIView *view in self.subviews.firstObject.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            return (id)view;
    }
    return nil;
}
@end

