//
//  JYLotteryCollectionViewCell.m
//  ug
//
//  Created by ug on 2020/2/12.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JYLotteryCollectionViewCell.h"
@interface JYLotteryCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation JYLotteryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = RGBA(117, 117, 117, 1);
    self.backgroundColor = RGBA(246, 246, 246, 1);
}

- (void)setItem:(GameModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
}

- (void)setSelected:(BOOL)selected {
    if (Skin1.isJY) {
        _titleLabel.textColor = selected ? RGBA(217, 157, 63, 1) : RGBA(117, 117, 117, 1);
        if (selected) {
             [CMCommon setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:RGBA(217, 157, 63, 1)  borderWidth:1];
        }
        else{
             [CMCommon setBorderWithView:self top:NO left:NO bottom:YES right:NO borderColor:RGBA(246, 246, 246, 1)  borderWidth:1];
        }
    }
}

@end
