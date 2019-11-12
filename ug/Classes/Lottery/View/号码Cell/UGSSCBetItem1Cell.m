//
//  UGSSCBetItem1Cell.m
//  ug
//
//  Created by ug on 2019/7/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSSCBetItem1Cell.h"
#import "UGGameplayModel.h"

@interface UGSSCBetItem1Cell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel;

@end
@implementation UGSSCBetItem1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.layer.cornerRadius = self.nameLabel.height / 2;
    self.nameLabel.layer.masksToBounds = YES;
    self.nameLabel.backgroundColor = UGBlueColor;
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [_oddsLabel setTextColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:Skin1.bgColor];
    } else {
        [_oddsLabel setTextColor:[UIColor blackColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }

}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        if (item.select) {
            self.oddsLabel.textColor = [UIColor whiteColor];
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 1;
        }else {
            self.oddsLabel.textColor = RGBA(159, 166, 173, 1);
            self.layer.borderWidth = 0.7;
            self.layer.borderColor =  Skin1.navBarBgColor.CGColor;
           
        }
    } else {
        if (item.select) {
            self.oddsLabel.textColor = Skin1.navBarBgColor;
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
            self.layer.borderWidth = 1;
        }else {
            self.oddsLabel.textColor = [UIColor blackColor];
            self.layer.borderWidth = 0.7;
            self.layer.borderColor =  UGRGBColor(218, 218, 218).CGColor;
           
        }
    }
}

- (void)setNameColor:(UIColor *)nameColor {
    _nameColor = nameColor;
    self.nameLabel.backgroundColor = nameColor;
}

- (void)setNameCornerRadius:(float)nameCornerRadius {
    _nameCornerRadius = nameCornerRadius;
    self.nameLabel.layer.cornerRadius = nameCornerRadius;
}

@end
