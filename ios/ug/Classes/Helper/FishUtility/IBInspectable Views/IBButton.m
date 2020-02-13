//
//  IBButton.m
//  IBInspectable
//
//  Created by fish on 16/6/1.
//  Copyright © 2016年 aduu. All rights reserved.
//

#import "IBButton.h"
#import "IBView.h"
#import "cc_runtime_property.h"


@interface IBButton()
@property (nonatomic, weak) CAGradientLayer *gradientLayer;//用于渐变色
@end

@implementation IBButton

- (void)layoutSubviews {
    [super layoutSubviews];
    [IBView refreshIBEffect:self];
    [self refreshIBEffect];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self refreshIBEffect];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self refreshIBEffect];
}

- (void)refreshIBEffect {
    {
        NSDictionary *dict = @{@(UIControlStateNormal):@"默认背景色",
                               @(UIControlStateHighlighted):@"高亮背景色",
                               @(UIControlStateSelected):@"选中背景色", };
        
        NSString *key = dict[@(self.state)];
        UIColor *color = nil;
        if (key && (color = [self valueForKey:key]))
            self.backgroundColor = color;
    }
    
    // 选中时字体加粗
    {
        if ([[self valueForKey:@"选中时字体加粗"] boolValue]) {
            UIFont *font = self.titleLabel.font;
            if (self.state == UIControlStateSelected)
                self.titleLabel.font = [font fontWithBold];
            else
                self.titleLabel.font = [font fontWithNormal];
        }
    }
    
    {
        UIColor *selectedBorderColor = [self valueForKey:@"选中时描边颜色"];
        UIColor *normalBorderColor = [self valueForKey:@"borderColor"];
        if (self.state == UIControlStateSelected) {
            if (selectedBorderColor)
                self.layer.borderColor = [selectedBorderColor CGColor];
        } else if (normalBorderColor)
            self.layer.borderColor = [normalBorderColor CGColor];
    }
    
    
    {
        if (self.文字左间距) {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, self.文字左间距, 0, 0);
        }
    }
    
    {
        if (self.开启渐变色3种颜色都要设置) {
            if (!self.gradientLayer) {
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                self.gradientLayer = gradientLayer;
            }
            self.gradientLayer.colors = @[(__bridge id)self.渐变开始色.CGColor, (__bridge id)self.渐变中间色.CGColor, (__bridge id)self.渐变结束色.CGColor];
            self.gradientLayer.locations = @[@0.0, @.5, @1.0];
            self.gradientLayer.type = kCAGradientLayerAxial;
            self.gradientLayer.startPoint = CGPointMake(0, .5);
            self.gradientLayer.endPoint = CGPointMake(1.f, .6);
            self.gradientLayer.frame = self.bounds;
            [self.layer insertSublayer:self.gradientLayer atIndex:0];
        }
    }
    
    
}

@end


@implementation UIButton (IBInspectableUtils)

_CCRuntimeGetterDoubleValue(BOOL, imgFitOrFill)

- (void)setImgFitOrFill:(BOOL)imgFitOrFill {
    objc_setAssociatedObject(self, @selector(imgFitOrFill), @(imgFitOrFill), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.imageView.contentMode = imgFitOrFill ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (CGSize)imgSize {
    return [objc_getAssociatedObject(self, @selector(imgSize)) CGSizeValue];
}

- (void)setImgSize:(CGSize)imgSize {
    objc_setAssociatedObject(self, @selector(imgSize), @(imgSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (OBJOnceToken(self)) {
        self.cc_userInfo[@"orImageDict"] = @{}.mutableCopy;
        [self cc_hookSelector:@selector(setImage:forState:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            UIImage *img = ai.arguments.firstObject;
            if (!img.cc_userInfo[@"scaleImage"]) {
                UIButton *btn = ai.instance;
                btn.imgSize = btn.imgSize;
            }
        } error:nil];
    }
    for (NSNumber *state in @[@(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateDisabled), @(UIControlStateSelected)]) {
        UIImage *orImage = [self imageForState:state.intValue];
        if (orImage.cc_userInfo[@"isScaleImage"]) {
            orImage = self.cc_userInfo[@"orImageDict"][state];
        } else {
            self.cc_userInfo[@"orImageDict"][state] = orImage;
        }
        if (!orImage) {
            continue;
        }
        if (!imgSize.width) {
            imgSize = CGSizeMake(imgSize.height/orImage.height * orImage.width, imgSize.height);
        }
        if (!imgSize.height) {
            imgSize = CGSizeMake(imgSize.width, imgSize.width/orImage.width * orImage.height);
        }
        UIImage *scaleImage = [orImage imageWithSize:imgSize];
        scaleImage.cc_userInfo[@"scaleImage"] = @true;
        [self setImage:scaleImage forState:state.intValue];
    }
}

@end
