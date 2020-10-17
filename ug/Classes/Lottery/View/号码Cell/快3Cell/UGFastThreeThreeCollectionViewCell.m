//
//  UGFastThreeThreeCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFastThreeThreeCollectionViewCell.h"
#import "UGGameplayModel.h"

@interface UGFastThreeThreeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView0;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel;

@end
@implementation UGFastThreeThreeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    
    if (item.enable && item.gameEnable) {
        self.oddsLabel.text = [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [item.odds floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
    } else {
        self.oddsLabel.text = @"--";
    }
    NSArray *arr = [item.name componentsSeparatedByString:@"_"];
    self.imgView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr.firstObject]];
    self.imgView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr.lastObject]];
    
    self.layer.borderWidth = item.select ? APP.borderWidthTimes *  1 : APP.borderWidthTimes *  0.5;
    
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
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
        if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
            self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
        } else {
            self.layer.borderColor = (item.select ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.3]).CGColor;
        }
        
        if (APP.betOddsIsRed) {
            self.oddsLabel.textColor = APP.AuxiliaryColor2;
        } else {
            if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
                self.oddsLabel.textColor = APP.TextColor1;
            } else {
                self.oddsLabel.textColor = item.select ? [UIColor whiteColor] : APP.TextColor1;
            }
        }
    }
}

@end
