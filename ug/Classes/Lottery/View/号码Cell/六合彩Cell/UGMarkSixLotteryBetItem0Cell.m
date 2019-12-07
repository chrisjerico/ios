//
//  UGMarkSixLotteryBetItem0Cell.m
//  ug
//
//  Created by ug on 2019/5/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMarkSixLotteryBetItem0Cell.h"
#import "UGGameplayModel.h"
@interface UGMarkSixLotteryBetItem0Cell ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelCenterXConstraint;

@end
@implementation UGMarkSixLotteryBetItem0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftLabel.layer.cornerRadius = self.leftLabel.width / 2;
    self.leftLabel.layer.masksToBounds = YES;
    self.leftLabel.layer.borderWidth = 1;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.leftLabel.text = item.name;
    
    self.rightLabel.text = [item.odds removeFloatAllZero];
    self.rightLabel.hidden = [_rightLabel.text isEqualToString:@"0"];
    
    self.layer.borderWidth = item.select ? 1 : 0.5;
    
    if (Skin1.isBlack) {
        self.leftLabel.textColor = Skin1.textColor1;
        self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if (APP.betOddsIsRed) {
            self.rightLabel.textColor = APP.AuxiliaryColor2;
        } else {
            self.rightLabel.textColor = Skin1.textColor2;
            self.rightLabel.highlightedTextColor = [UIColor whiteColor];
            self.rightLabel.highlighted = item.select;
        }
        
    } else {
        if (APP.betBgIsWhite) {
            self.leftLabel.textColor = Skin1.textColor1;
        } else {
            self.leftLabel.textColor = item.select ? [UIColor whiteColor] : Skin1.textColor1;
        }
        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        if (APP.betBgIsWhite) {
            self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
        } else {
            self.layer.borderColor = (item.select ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.3]).CGColor;
        }
        
        if (APP.betOddsIsRed) {
            self.rightLabel.textColor = APP.AuxiliaryColor2;
        } else {
            if (APP.betBgIsWhite) {
                self.rightLabel.textColor = APP.TextColor1;
            } else {
                self.rightLabel.textColor = item.select ? [UIColor whiteColor] : APP.TextColor1;
            }
        }
    }
   
    
    self.leftLabel.layer.borderColor = [CMCommon getHKLotteryNumColor:item.name].CGColor;
    if (item.odds.length) {
        if ([item.odds containsString:@"/"]) {
            self.leftLabelCenterXConstraint.constant = -25;
        } else {
            self.leftLabelCenterXConstraint.constant = -15;
        }
    } else {
        self.leftLabelCenterXConstraint.constant = 0;
    }
}

@end
