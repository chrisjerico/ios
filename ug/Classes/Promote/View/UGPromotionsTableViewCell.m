//
//  UGPromotionsTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionsTableViewCell.h"
#import "UGPromoteModel.h"

@interface UGPromotionsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGPromotionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
}

- (void)setItem:(UGPromoteModel *)item {
    _item = item;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = item.title;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
