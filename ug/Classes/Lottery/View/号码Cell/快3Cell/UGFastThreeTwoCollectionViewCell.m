//
//  UGFastThreeTwoCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFastThreeTwoCollectionViewCell.h"
#import "UGGameplayModel.h"
@interface UGFastThreeTwoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel;


@end

@implementation UGFastThreeTwoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    self.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",item.name]];
    
    self.layer.borderWidth = item.select ? APP.borderWidthTimes *  1 : APP.borderWidthTimes *  0.5;
    
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

@end
