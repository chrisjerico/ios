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
    if (APP.betSizeIsBig) {
        self.nameLabel.font = APP.cellBigFont;
    } else {
        self.nameLabel.font = APP.cellNormalFont;
    }
    
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    self.layer.borderWidth = item.select ? 1 : 0.5;
    

    if (Skin1.isBlack) {
        self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if (APP.betOddsIsRed) {
            self.oddsLabel.textColor = APP.AuxiliaryColor2;
        } else {
            self.oddsLabel.textColor = Skin1.textColor2;
            self.oddsLabel.highlightedTextColor = [UIColor whiteColor];
            self.oddsLabel.highlighted = item.select;
        }
    } else {
        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        if (APP.betBgIsWhite) {
            self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
        } else {
            self.layer.borderColor = (item.select ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.3]).CGColor;
        }
        
        if (APP.betOddsIsRed) {
            self.oddsLabel.textColor = APP.AuxiliaryColor2;
        } else {
            if (APP.betBgIsWhite) {
                self.oddsLabel.textColor = APP.TextColor1;
            } else {
                self.oddsLabel.textColor = item.select ? [UIColor whiteColor] : APP.TextColor1;
            }
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
