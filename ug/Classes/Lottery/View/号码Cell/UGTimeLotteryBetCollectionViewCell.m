//
//  UGTimeLotteryBetCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTimeLotteryBetCollectionViewCell.h"
#import "UGGameplayModel.h"
#import "CMLabelCommon.h"
@interface UGTimeLotteryBetCollectionViewCell ()



@end
@implementation UGTimeLotteryBetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (APP.betSizeIsBig) {
        self.titleLabel.font = APP.cellBigFont;
        //        [CMLabelCommon setRichNumberWithLabel:self.titleLabel Color:self.titleLabel.textColor FontSize:APP.cellNormalFontSize];
    } else {
        self.titleLabel.font = APP.cellNormalFont;
    }
}



- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    
    
    
    if (APP.betOddsIsRed) {
        self.titleLabel.textColor = Skin1.textColor1;
        self.numberLB.textColor = APP.AuxiliaryColor2;
    } else {
        
        
        if (item.enable && item.gameEnable) {
            
            self.titleLabel.text = item.name;
            self.numberLB.text = [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [item.odds floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
        }
        else{
        
            self.titleLabel.text = item.name;
            self.numberLB.text = @" --";
        }

    }
    
    self.layer.borderWidth = item.select ? APP.borderWidthTimes * 1 : APP.borderWidthTimes *  0.5;
    
    if (Skin1.isBlack||Skin1.is23) {
        if ([Skin1.skitString isEqualToString:@"黑色模板香槟金"]) {
            self.backgroundColor = item.select ? RGBA(72, 146, 209, 1):  Skin1.homeContentSubColor;
        } else {
            self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        }
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if (!APP.betOddsIsRed) {
            self.titleLabel.textColor = Skin1.textColor2;
            self.titleLabel.highlightedTextColor = [UIColor whiteColor];
            self.titleLabel.highlighted = item.select;
            
            self.numberLB.textColor = Skin1.textColor2;
            self.numberLB.highlightedTextColor = [UIColor whiteColor];
            self.numberLB.highlighted = item.select;
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
        
        if (!APP.betOddsIsRed) {
            if (APP.betBgIsWhite) {
                self.titleLabel.textColor = Skin1.textColor1;
                self.numberLB.textColor = Skin1.textColor1;
            } else {
                self.titleLabel.textColor = item.select ? [UIColor whiteColor] : Skin1.textColor1;
                self.numberLB.textColor = item.select ? [UIColor whiteColor] : Skin1.textColor1;
            }
        }
    }
}

- (void)setSelected:(BOOL)selected {
    
}

@end
