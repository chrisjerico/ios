//
//  NSMutableAttributedString+Utils.m
//  MediaViewer
//
//  Created by fish on 2018/1/23.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "NSMutableAttributedString+Utils.h"
#import "cc_runtime_property.h"
#import "JRSwizzle.h"

@implementation NSAttributedString (Utils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSAttributedString jr_swizzleMethod:@selector(initWithString:attributes:) withMethod:@selector(cc_safe_initWithString:attributes:) error:nil];
    });
}

- (instancetype)cc_safe_initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    return str.length ? [self cc_safe_initWithString:str attributes:attrs] : nil;
}

- (NSAttributedString *)substringWithFrameSize:(CGSize)size {
    CGFloat h = [self boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   context:nil].size.height;
    if (h <= size.height)
        return [self copy];
    
    NSInteger len = self.length/2;
    NSInteger correct = 2;
    NSAttributedString *string = nil;
    NSAttributedString *temp = [self attributedSubstringFromRange:NSMakeRange(0, len)];
    while (true) {
        h = [temp boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               context:nil].size.height;
        if (h <= size.height)
            string = temp;
        
        len /= 2;
        if (!len) {
            if (correct--)
                len = 1;
            else
                return string;
        }
        temp = [self attributedSubstringFromRange:NSMakeRange(0, temp.length + (h > size.height ? -len : len))];
    }
    return nil;
}
@end


@implementation NSMutableAttributedString (Utils)

_CCRuntimeGetter(UIFont *, font)
_CCRuntimeGetter(UIColor *, color)
_CCRuntimeGetterDoubleValue(CGFloat, kern)
_CCRuntimeGetterDoubleValue(CGFloat, lineSpacing)
_CCRuntimeGetterDoubleValue(NSLineBreakMode, lineBreakMode)

- (void)setFont:(UIFont *)font {
    objc_setAssociatedObject(self, @selector(font), font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
}

- (void)setColor:(UIColor *)color {
    objc_setAssociatedObject(self, @selector(color), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
}

- (void)setKern:(CGFloat)kern {
    objc_setAssociatedObject(self, @selector(kern), @(kern), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:NSKernAttributeName value:@(kern) range:NSMakeRange(0, self.length)];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    objc_setAssociatedObject(self, @selector(lineSpacing), @(lineSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
    ps.lineSpacing = lineSpacing;
    ps.lineBreakMode = NSLineBreakByCharWrapping;
    [self addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, self.length)];
}

- (void)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    NSRange range = NSMakeRange(0, self.length);
    NSRange r;
    while ((r = [self.string rangeOfString:target options:NSLiteralSearch range:range]).length) {
        [self replaceCharactersInRange:r withString:replacement ? : @""];
        range.location = r.location + r.length;
        range.length = self.length - range.location;
    }
}

- (void)replaceOccurrencesOfString:(NSString *)target withAttributedString:(NSAttributedString *)replacement {
    NSRange range = NSMakeRange(0, self.length);
    NSRange r;
    while ((r = [self.string rangeOfString:target options:NSLiteralSearch range:range]).length) {
        [self replaceCharactersInRange:r withAttributedString:replacement ? : [NSAttributedString new]];
        range.location = r.location + replacement.length;
        range.length = self.length - range.location;
    }
}

- (void)setString:(NSString *)aString {
    [self replaceCharactersInRange:NSMakeRange(0, self.length) withString:aString ? : @""];
}

- (void)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs withString:(NSString *)string {
    NSRange range = NSMakeRange(0, self.length);
    NSRange r;
    while ((r = [self.string rangeOfString:string options:NSLiteralSearch range:range]).length) {
        [self addAttributes:attrs range:r];
        range.location = r.location + r.length;
        range.length = self.length - range.location;
    }
}
- (void)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs withString:(NSString *)string {
    NSRange range = NSMakeRange(0, self.length);
    NSRange r;
    while ((r = [self.string rangeOfString:string options:NSLiteralSearch range:range]).length) {
        [self replaceCharactersInRange:r withAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attrs]];
        range.location = r.location + r.length;
        range.length = self.length - range.location;
    }
}

@end





#pragma mark - 拓展（UILabel、UITextView）
// ————————————————————————————————————

void (^setText)(id<AspectInfo> aInfo) = ^(id<AspectInfo> aInfo) {;
    NSString *string = aInfo.arguments.firstObject;
    if (!string)
        string = @"";
    
    if ([aInfo.instance attributedText].string.length && [string isKindOfClass:[NSString class]]) {
        [aInfo.instance updateAttributedText:^(NSMutableAttributedString *attributedText) {
            attributedText.string = string;
        }];
    } else {
        [aInfo.originalInvocation invoke];
    }
};
void (^setFont)(id<AspectInfo> aInfo) = ^(id<AspectInfo> aInfo) {
    [aInfo.originalInvocation invoke];
    UIFont *font = aInfo.arguments.firstObject;
    if ([aInfo.instance attributedText] && [font isKindOfClass:[UIFont class]]) {
        [aInfo.instance updateAttributedText:^(NSMutableAttributedString *attributedText) {
            [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.string.length)];
        }];
    }
};
void (^setTextColor)(id<AspectInfo> aInfo) = ^(id<AspectInfo> aInfo) {
    [aInfo.originalInvocation invoke];
    UIColor *textColor = aInfo.arguments.firstObject;
    if ([aInfo.instance attributedText] && [textColor isKindOfClass:[UIColor class]]) {
        [aInfo.instance updateAttributedText:^(NSMutableAttributedString *attributedText) {
            [attributedText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attributedText.string.length)];
        }];
    }
};
void updateAttributedText(UILabel *label, void (^block)(NSMutableAttributedString *)) {
    if (!block) return;
    NSMutableAttributedString *attributedText = nil;
    if (label.attributedText.string.length) {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithString:label.text.length ? label.text : @"\a"
                                                                attributes:@{NSFontAttributeName:label.font, NSForegroundColorAttributeName:label.textColor, }];
    }
    block(attributedText);
    label.attributedText = attributedText;
}

// ———————————————
@implementation UILabel (NSMutableAttributedStringUtils)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UILabel cc_hookSelector:@selector(setText:) withOptions:AspectPositionInstead usingBlock:setText error:nil];
        [UILabel cc_hookSelector:@selector(setFont:) withOptions:AspectPositionInstead usingBlock:setFont error:nil];
        [UILabel cc_hookSelector:@selector(setTextColor:) withOptions:AspectPositionInstead usingBlock:setTextColor error:nil];
    });
}
- (void)updateAttributedText:(void (^)(NSMutableAttributedString *))block {
    updateAttributedText(self, block);
}
@end
