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

}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    
    if (item.select) {
        self.oddsLabel.textColor = UGNavColor;
        self.layer.borderColor = UGNavColor.CGColor;
        self.layer.borderWidth = 1;
    }else {
        self.oddsLabel.textColor = [UIColor blackColor];
        self.layer.borderWidth = 0.7;
        self.layer.borderColor =  UGRGBColor(218, 218, 218).CGColor;
       
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
