//
//  UGPlatformTitleBlackCell.m
//  ug
//
//  Created by fish on 2019/11/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformTitleBlackCell.h"

@implementation UGPlatformTitleBlackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    FastSubViewCode(self);
    subLabel(@"标题Label").superview.backgroundColor = Skin1.navBarBgColor;
    subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:Skin1.navBarBgColor];
//    subImageView(@"箭头ImageView").backgroundColor = Skin1.bgColor;
    subImageView(@"箭头ImageView").hidden = true;
    [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
        subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:Skin1.navBarBgColor];
    }];
}

- (void)setGcm:(GameCategoryModel *)gcm {
    _gcm = gcm;
    FastSubViewCode(self);
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:gcm.logo]];
    subLabel(@"标题Label").text = gcm.name;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    FastSubViewCode(self);
    subLabel(@"标题Label").textColor = selected ? APP.ThemeColor3 : Skin1.textColor1;
    subImageView(@"箭头ImageView").hidden = !selected;
}

@end
