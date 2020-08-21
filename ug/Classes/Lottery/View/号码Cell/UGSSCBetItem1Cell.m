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
@property (weak, nonatomic) IBOutlet UILabel *nameOnlyLabel;

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

	self.nameOnlyLabel.layer.cornerRadius = 15;
	self.nameOnlyLabel.layer.masksToBounds = YES;
	self.nameOnlyLabel.layer.borderColor = [UGTextColor CGColor];
	self.nameOnlyLabel.layer.borderWidth = 0.5;
	self.nameOnlyLabel.backgroundColor = UGBlueColor;
	
	self.nameLabel.hidden = false;
	self.oddsLabel.hidden = false;
	self.nameOnlyLabel.hidden = true;
    
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.nameLabel.text = item.name;
    
    if (item.enable && item.gameEnable) {
        self.oddsLabel.text =  [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [item.odds floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
    }
    else {
        self.oddsLabel.text = @"--";
    }
    self.layer.borderWidth = item.select ? APP.borderWidthTimes * 1 : APP.borderWidthTimes * 0.5;
    
    
    if (Skin1.isBlack||Skin1.is23) {
        if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
            self.backgroundColor = item.select ? RGBA(72, 146, 209, 1):  Skin1.homeContentSubColor;
        } else {
            self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        }
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
        if (APP.isBorderNavBarBgColor) {
            self.backgroundColor = item.select ?Skin1.navBarBgColor:[UIColor clearColor];
        }
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
	
	if ([item.typeName isEqualToString:@"定位胆"]) {
		self.nameLabel.hidden = true;
		self.oddsLabel.hidden = true;
		self.nameOnlyLabel.hidden = false;
		self.nameOnlyLabel.text = item.name;
		self.layer.borderWidth = item.select ? APP.borderWidthTimes * 1 : 0.5;

	} else {
		self.nameLabel.hidden = false;
		self.oddsLabel.hidden = false;
		self.nameOnlyLabel.hidden = true;
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
