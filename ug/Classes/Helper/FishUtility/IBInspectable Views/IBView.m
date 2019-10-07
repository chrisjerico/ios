//
//  IBView.m
//  IBInspectable
//
//  Created by fish on 16/6/1.
//  Copyright © 2016年 aduu. All rights reserved.
//

#import "IBView.h"
#import "NSMutableAttributedString+Utils.h"
#import "zj_runtime_property.h"

@implementation IBView
- (void)layoutSubviews {
    [super layoutSubviews];
    [IBView refreshIBEffect:self];
}
+ (void)refreshIBEffect:(UIView *)view {
    if ([view valueForKey:@"圆角倍数"] || [view valueForKey:@"圆角偏移量"]) {
        CGPoint cornerRadiusRatio = [[view valueForKey:@"圆角倍数"] CGPointValue];
        CGFloat cornerRadiusOffset = [[view valueForKey:@"圆角偏移量"] doubleValue];
        view.layer.cornerRadius = cornerRadiusRatio.x * view.frame.size.width + cornerRadiusRatio.y * view.frame.size.height + cornerRadiusOffset;
    }
    if ([view valueForKey:@"maskToBounds"])
        view.layer.masksToBounds = [[view valueForKey:@"maskToBounds"] boolValue];
    if ([view valueForKey:@"borderColor"])
        view.layer.borderColor   = [[view valueForKey:@"borderColor"] CGColor];
    if ([view valueForKey:@"borderWidth"])
        view.layer.borderWidth   = [[view valueForKey:@"borderWidth"] doubleValue];
}
@end


@implementation IBLabel
- (void)layoutSubviews {
    [super layoutSubviews];
    [IBView refreshIBEffect:self];
}
- (void)setKern:(CGFloat)kern {
    _kern = kern;
    [self updateAttributedText:^(NSMutableAttributedString *attributedText) {
        attributedText.kern = kern;
    }];
}
@end


@implementation IBImageView
- (void)layoutSubviews {
    [super layoutSubviews];
    [IBView refreshIBEffect:self];
}
@end


@implementation IBTextView
- (void)layoutSubviews {
    [super layoutSubviews];
    [IBView refreshIBEffect:self];
}
@end

