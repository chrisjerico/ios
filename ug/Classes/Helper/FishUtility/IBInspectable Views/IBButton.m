//
//  IBButton.m
//  IBInspectable
//
//  Created by fish on 16/6/1.
//  Copyright © 2016年 aduu. All rights reserved.
//

#import "IBButton.h"
#import "IBView.h"
#import "zj_runtime_property.h"

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
}

@end


@implementation UIButton (IBInspectableUtils)

_ZJRuntimeGetterDoubleValue(BOOL, imgFitOrFill)

- (void)setImgFitOrFill:(BOOL)imgFitOrFill {
    objc_setAssociatedObject(self, @selector(imgFitOrFill), @(imgFitOrFill), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.imageView.contentMode = imgFitOrFill ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
@end
