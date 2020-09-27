//
//  NewLotteryGameCollectionViewCell.m
//  UGBWApp
//
//  Created by fish on 2020/9/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NewLotteryGameCollectionViewCell.h"

@interface NewLotteryGameCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *mBtn;

@end

@implementation NewLotteryGameCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.mBtn.clipsToBounds = false;
    self.mBtn.layer.cornerRadius = 5;
    self.mBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mBtn.layer.shadowOffset = CGSizeMake(0, 1);
    self.mBtn.layer.shadowRadius = 2;
    self.mBtn.layer.shadowOpacity = 0.1;

    self.clipsToBounds = false;
    self.layer.cornerRadius = 10;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.1;

    if (![Skin1.skitString isEqualToString:@"经典 1蓝色"]) {
        
        if (Skin1.isGPK ||Skin1.isBlack ) {
            [self setBackgroundColor:Skin1.homeContentColor];
            [self.nameLabel setTextColor:Skin1.textColor4];
            [self.mBtn setTitleColor:Skin1.textColor4 forState:UIControlStateNormal];
        } else {
            [self setBackgroundColor:Skin1.homeContentColor];
            [self.nameLabel setTextColor:Skin1.textColor1];
            [self.mBtn setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        }
        
    }
    
}

- (void)setItem:(UGNextIssueModel *)item {
    _item = item;
    self.nameLabel.text = item.title;

}
@end
