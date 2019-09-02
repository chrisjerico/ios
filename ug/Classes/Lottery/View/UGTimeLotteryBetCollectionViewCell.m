//
//  UGTimeLotteryBetCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTimeLotteryBetCollectionViewCell.h"
#import "UGGameplayModel.h"

@interface UGTimeLotteryBetCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGTimeLotteryBetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
   
    self.titleLabel.text = [NSString stringWithFormat:@"%@  %@",item.name,[item.odds removeFloatAllZero]];
    if (item.select) {
        self.titleLabel.textColor = UGNavColor;
        self.layer.borderColor = UGNavColor.CGColor;
        self.layer.borderWidth = 1;
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (void)setSelected:(BOOL)selected {

}

@end
