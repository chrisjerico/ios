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
    // Initialization code
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
   
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    NSArray *arr = [item.name componentsSeparatedByString:@"_"];
    self.imgView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr.firstObject]];
    self.imgView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",arr.lastObject]];
    
    if (item.select) {
        self.layer.borderColor = Skin1.navBarBgColor.CGColor;
        self.layer.borderWidth = 1;
    }else {
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
