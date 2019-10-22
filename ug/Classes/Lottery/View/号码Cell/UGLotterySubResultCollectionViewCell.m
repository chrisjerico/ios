//
//  UGLotterySubResultCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotterySubResultCollectionViewCell.h"

@interface UGLotterySubResultCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGLotterySubResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgImageView.image = [[UIImage imageNamed:@"qb"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    _titleLabel.layer.cornerRadius = 3;
    _titleLabel.layer.masksToBounds = true;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setShowAdd:(BOOL)showAdd {
    _showAdd = showAdd;
    _titleLabel.hidden = showAdd;
    _bgImageView.hidden = showAdd;
}

- (void)setWin:(BOOL)win {
    _win = win;
    _titleLabel.backgroundColor = win ? [UIColor yellowColor] : [UIColor whiteColor];
}

@end
