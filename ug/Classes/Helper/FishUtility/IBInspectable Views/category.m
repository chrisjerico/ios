//
//  category.m
//  C
//
//  Created by fish on 2018/12/4.
//  Copyright © 2018 fish. All rights reserved.
//

#import "category.h"
#import "NSMutableAttributedString+Utils.h"
#import "cc_runtime_property.h"
#import "JRSwizzle.h"
#import "RegExCategories.h"

// —————————— IBInspectableUtils 类别
// ——————————————————————————————————————————————————

@implementation UILabel (IBInspectableUtils)
_CCRuntimeGetterDoubleValue(CGFloat, lineSpacing1)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UILabel jr_swizzleMethod:@selector(textRectForBounds:limitedToNumberOfLines:) withMethod:@selector(cc_textRectForBounds:limitedToNumberOfLines:) error:nil];
        [UILabel jr_swizzleMethod:@selector(drawTextInRect:) withMethod:@selector(cc_drawTextInRect:) error:nil];
    });
}

- (CGRect)cc_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGPoint padding = self.内边距;
    UIEdgeInsets insets = UIEdgeInsetsMake(padding.y, padding.x, padding.y, padding.x);
    CGRect rect = [self cc_textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets) limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    return rect;
}

- (void)cc_drawTextInRect:(CGRect)rect {
    CGPoint padding = self.内边距;
    [self cc_drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(padding.y, padding.x, padding.y, padding.x))];
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

@implementation UIButton (IBInspectableUtils)
- (CGPoint)内边距 { return CGPointZero; }
- (void)set内边距:(CGPoint)内边距 {
    CGPoint padding = 内边距;
    self.contentEdgeInsets = UIEdgeInsetsMake(padding.y, padding.x, padding.y, padding.x);
}
- (NSInteger)numberOfLines {
    return self.titleLabel.numberOfLines;
}
- (void)setNumberOfLines:(NSInteger)numberOfLines {
    self.titleLabel.numberOfLines = numberOfLines;
}
@end



@interface _CCTextDelegateModel : NSObject<UITextFieldDelegate, UITextViewDelegate>
@end
@implementation _CCTextDelegateModel
+ (instancetype)shared {
    static _CCTextDelegateModel *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [_CCTextDelegateModel new];
    });
    return obj;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string { return true; }
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text { return true; }
@end

@interface NSObject (_CCTextDelegate)
@end
@implementation NSObject (_CCTextDelegate)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string { return true; }
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text { return true; }
@end


@implementation UITextField (IBInspectableUtils)
_CCRuntimeProperty_Assign(NSUInteger, 限制长度, set限制长度)
_CCRuntimeProperty_Assign(BOOL, 仅数字, set仅数字)
_CCRuntimeProperty_Assign(NSUInteger, 仅数字含小数, set仅数字含小数)
_CCRuntimeProperty_Assign(BOOL, 仅数字加字母, set仅数字加字母)
_CCRuntimeProperty_Assign(BOOL, 仅可见的ASCII, set仅可见的ASCII)
_CCRuntimeProperty_Copy(NSString *, 额外允许的字符, set额外允许的字符)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换setDelegate:方法
        [UITextField jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(cc_layoutSubviews) error:nil];
        [UITextField jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(cc_setDelegate:) error:nil];
        // 监听文本长度
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            UITextField *tf = note.object;
            if (tf.限制长度) {
                UITextPosition *position = [tf positionFromPosition:[tf markedTextRange].start offset:0];
                if (!position && tf.text.length > tf.限制长度) {
                    tf.text = [tf.text substringToIndex:tf.限制长度];
                    [HUDHelper showMsg:_NSString(@"不得超过%d个字符", (int)tf.限制长度)];
                }
            }
        }];
    });
}
- (void)cc_layoutSubviews {
    if (!self.delegate && OBJOnceToken(self)) {
        self.delegate = [_CCTextDelegateModel shared];
    }
    [self cc_layoutSubviews];
}
- (void)cc_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self cc_setDelegate:delegate];
	if (CHAT_TARGET) { return; }
    if ([delegate isKindOfClass:[NSObject class]] && OBJOnceToken(delegate)) {
        [(id)delegate cc_hookSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aInfo) {
            [aInfo.originalInvocation invoke];
            // 过滤文本
            UITextField *tf = aInfo.arguments.firstObject;
            NSRange range = [aInfo.arguments[1] rangeValue];
            NSString *text = aInfo.arguments[2];
            
            text = [tf.text stringByReplacingCharactersInRange:range withString:text];
            for (NSString *c in tf.额外允许的字符) {
                text = [text stringByReplacingOccurrencesOfString:c withString:@""];
            }
            
            BOOL ret = true;
            if (tf.仅数字)
                ret &= [text isMatch:RX(@"^[0-9]*$")];
            else if (tf.仅数字含小数)
                ret &= [text isMatch:RX(_NSString(@"^[0-9]*[.]?[0-9]{0,%d}$", (int)tf.仅数字含小数))];
            else if (tf.仅数字加字母)
                ret &= [text isMatch:RX(@"^[0-9A-Za-z]*$")];
            else if (tf.仅可见的ASCII)
                ret &= [text isMatch:RX(@"^[\\x20-\\x7E]*$")];    // 不使用原生的正则函数是因为，原生函数会把中文标点符号误认为ASCII符号而匹配通过，比如“。”->"." 或 “，”->","
            if (!ret)
                [aInfo.originalInvocation setReturnValue:&ret];
        } error:nil];
    }
}
@end




@implementation UITextView (IBInspectableUtils)
_CCRuntimeProperty_Assign(NSUInteger, 限制长度, set限制长度)
_CCRuntimeProperty_Assign(BOOL, 仅数字, set仅数字)
_CCRuntimeProperty_Assign(NSUInteger, 仅数字含小数, set仅数字含小数)
_CCRuntimeProperty_Assign(BOOL, 仅数字加字母, set仅数字加字母)
_CCRuntimeProperty_Assign(BOOL, 仅可见的ASCII, set仅可见的ASCII)
_CCRuntimeProperty_Copy(NSString *, 额外允许的字符, set额外允许的字符)
_CCRuntimeGetterDoubleValue(BOOL, 内容紧贴边框)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换setDelegate:方法
        [UITextView jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(cc_layoutSubviews) error:nil];
        [UITextView jr_swizzleMethod:@selector(setDelegate:) withMethod:@selector(cc_setDelegate:) error:nil];
        // 监听文本长度
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            UITextView *tf = note.object;
            if (tf.限制长度) {
                UITextPosition *position = [tf positionFromPosition:[tf markedTextRange].start offset:0];
                if (!position && tf.text.length > tf.限制长度) {
                    tf.text = [tf.text substringToIndex:tf.限制长度];
                    [HUDHelper showMsg:_NSString(@"不得超过%d个字符", (int)tf.限制长度)];
                }
            }
        }];
    });
}
- (void)cc_layoutSubviews {
    if (!self.delegate && OBJOnceToken(self)) {
        self.delegate = [_CCTextDelegateModel shared];
    }
    [self cc_layoutSubviews];
}
- (void)cc_setDelegate:(id<UITextViewDelegate>)delegate {
    [self cc_setDelegate:delegate];
	if (CHAT_TARGET) { return; }
    if ([delegate isKindOfClass:[NSObject class]] && OBJOnceToken(delegate)) {
        [(id)delegate cc_hookSelector:@selector(textView:shouldChangeTextInRange:replacementText:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aInfo) {
            [aInfo.originalInvocation invoke];
            
            // 过滤文本
            UITextView *tf = aInfo.arguments.firstObject;
            NSRange range = [aInfo.arguments[1] rangeValue];
            NSString *text = aInfo.arguments[2];
            
            text = [tf.text stringByReplacingCharactersInRange:range withString:text];
            for (NSString *c in tf.额外允许的字符) {
                text = [text stringByReplacingOccurrencesOfString:c withString:@""];
            }
            
            BOOL ret = true;
            if (tf.仅数字)
                ret &= [text isMatch:RX(@"^[0-9]*$")];
            else if (tf.仅数字含小数)
                ret &= [text isMatch:RX(_NSString(@"^[0-9]*[.]?[0-9]{0,%d}$", (int)tf.仅数字含小数))];
            else if (tf.仅数字加字母)
                ret &= [text isMatch:RX(@"^[0-9A-Za-z]*$")];
            else if (tf.仅可见的ASCII)
                ret &= [text isMatch:RX(@"^[\\x20-\\x7E]*$")];    // 不使用原生的正则函数是因为，原生函数会把中文标点符号误认为ASCII符号而匹配通过，比如“。”->"." 或 “，”->","
            if (!ret)
                [aInfo.originalInvocation setReturnValue:&ret];
        } error:nil];
    }
}
- (void)set内容紧贴边框:(BOOL)内容紧贴边框 {
    objc_setAssociatedObject(self, @selector(内容紧贴边框), @(内容紧贴边框), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (内容紧贴边框)
        self.contentInset = UIEdgeInsetsMake(-8, -5, -8, -5);
}
@end





@implementation UISearchBar (IBInspectableUtils)
_CCRuntimeProperty_Retain(UIColor *, textColor, setTextColor)
_CCRuntimeProperty_Assign(CGFloat, fontSize, setFontSize)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UISearchBar jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(ccIBView_layoutSubviews) error:nil];
    });
}
- (void)ccIBView_layoutSubviews {
    [self ccIBView_layoutSubviews];
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






@implementation UISegmentedControl (IBInspectableUtils)
- (UIColor *)textColor1 { return nil; }
- (void)setTextColor1:(UIColor *)textColor1 {
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor1} forState:UIControlStateNormal];
}
@end

