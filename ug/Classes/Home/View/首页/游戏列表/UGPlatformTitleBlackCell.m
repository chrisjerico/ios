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
    
    if (Skin1.isGPK) {
        subLabel(@"标题Label").superview.backgroundColor = Skin1.navBarBgColor;
        subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:Skin1.navBarBgColor];
    } else  if(Skin1.isTKL){
        subLabel(@"标题Label").superview.backgroundColor = RGBA(246, 246, 246, 1.0);
          subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:RGBA(246, 246, 246, 1.0)];
         subLabel(@"标题Label").textColor =  Skin1.textColor1;
    }
  
    subImageView(@"箭头ImageView").hidden = true;
    
    
    [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
        if (Skin1.isGPK) {
             subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:Skin1.navBarBgColor];
        }
        else if(Skin1.isTKL){
             subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:RGBA(246, 246, 246, 1.0)];
        }
       
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
    
    subImageView(@"箭头ImageView").hidden = !selected;
    
    if (Skin1.isGPK) {
        subLabel(@"标题Label").textColor = selected ? APP.ThemeColor3 : Skin1.textColor1;
    }
    else if(Skin1.isTKL){
 
        if (selected) {
            subLabel(@"标题Label").superview.backgroundColor = RGBA(229, 229, 229, 1.0);
            subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:RGBA(229, 229, 229, 1.0)];
             subLabel(@"标题Label").textColor = RGBA(96,140,223, 1.0) ;
        } else {
            subLabel(@"标题Label").superview.backgroundColor = RGBA(246, 246, 246, 1.0);
            subImageView(@"箭头ImageView").image = [[UIImage imageNamed:@"jiantou1"] qmui_imageWithTintColor:RGBA(246, 246, 246, 1.0)];
            subLabel(@"标题Label").textColor = Skin1.textColor1;
        }
    }
    
}

@end
