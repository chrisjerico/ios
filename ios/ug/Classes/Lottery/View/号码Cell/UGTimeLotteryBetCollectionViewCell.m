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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    
    
    
    if (APP.betOddsIsRed) {
        self.titleLabel.attributedText = ({
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:_NSString(@"%@ %@",item.name, [item.odds removeFloatAllZero]) attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
            [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[item.odds removeFloatAllZero]];
            mas;
        });
    } else {
        if (item.enable && item.gameEnable) {
            self.titleLabel.text = _NSString(@"%@ %@",item.name, [item.odds removeFloatAllZero]);
        }
        else{
            self.titleLabel.text = _NSString(@"%@ --",item.name);
        }
        
    }
    
    self.layer.borderWidth = item.select ? APP.borderWidthTimes * 1 : APP.borderWidthTimes *  0.5;
    
    if (Skin1.isBlack) {
        self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if (!APP.betOddsIsRed) {
            self.titleLabel.textColor = Skin1.textColor2;
            self.titleLabel.highlightedTextColor = [UIColor whiteColor];
            self.titleLabel.highlighted = item.select;
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
            } else {
                self.titleLabel.textColor = item.select ? [UIColor whiteColor] : Skin1.textColor1;
            }
        }
    }
}

- (void)setSelected:(BOOL)selected {

}

@end
