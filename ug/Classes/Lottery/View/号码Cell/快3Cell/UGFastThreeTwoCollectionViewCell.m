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
    // Initialization code
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.oddsLabel.text = [item.odds removeFloatAllZero];
    self.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"shaizi%@",item.name]];
    
    if (item.select) {
        self.layer.borderColor = Skin1.navBarBgColor.CGColor;
        self.layer.borderWidth = 1;
    }else {
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
