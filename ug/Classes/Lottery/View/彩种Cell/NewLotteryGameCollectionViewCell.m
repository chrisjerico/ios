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
 
    self.mBtn.layer.cornerRadius = 5;
    self.mBtn.layer.borderWidth = 1.6;
    self.mBtn.layer.borderColor = [RGBA(132,164,183, 1) CGColor];
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [RGBA(132,164,183, 1) CGColor];

    if (![Skin1.skitString isEqualToString:@"经典 1蓝色"]) {
        [self setBackgroundColor:Skin1.homeContentColor];
    }
}

- (void)setItem:(UGNextIssueModel *)item {
    _item = item;
    self.nameLabel.text = item.title;

}
@end
