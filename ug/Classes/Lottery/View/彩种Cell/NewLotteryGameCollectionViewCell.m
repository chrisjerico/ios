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
    self.nameLabel.textColor = Skin1.textColor1;
    self.mBtn.layer.cornerRadius = 5;
    self.mBtn.layer.borderWidth = 1;
    self.mBtn.layer.borderColor = [RGBA(132,164,183, 1) CGColor];
    
    self.layer.cornerRadius = 10;
}

- (void)setItem:(UGNextIssueModel *)item {
    _item = item;
    self.nameLabel.text = item.title;

}
@end
