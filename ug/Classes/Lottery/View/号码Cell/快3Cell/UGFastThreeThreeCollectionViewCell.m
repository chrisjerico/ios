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
   
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    NSArray *arr = [item.name componentsSeparatedByString:@"_"];
    self.imgView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr.firstObject]];
    self.imgView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr.lastObject]];
    
    self.layer.borderWidth = item.select ? 1 : 0.5;
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if ([APP.SiteId isEqualToString:@"c194"]) {
            self.oddsLabel.textColor = APP.AuxiliaryColor2;
        } else {
            self.oddsLabel.textColor = Skin1.textColor2;
            self.oddsLabel.highlightedTextColor = [UIColor whiteColor];
            self.oddsLabel.highlighted = item.select;
        }
        
    } else {
        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
        
        if ([APP.SiteId isEqualToString:@"c194"]) {
            self.oddsLabel.textColor = APP.AuxiliaryColor2;
        } else {
            self.oddsLabel.textColor = APP.TextColor1;
        }
    }
}

@end
