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
    
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
         [self  setBackgroundColor:Skin1.bgColor];
         [_titleLabel setTextColor:[UIColor blackColor]];
    }
    else if(Skin1.isTKL) {
         [_titleLabel setTextColor:Skin1.navBarBgColor];
         [self  setBackgroundColor:[UIColor whiteColor]];
         [_titleLabel.layer setBorderColor:Skin1.navBarBgColor.CGColor];//设置边界的颜色
    }
    else {
         [_titleLabel setTextColor:[UIColor blackColor]];
         [self  setBackgroundColor:[UIColor whiteColor]];
    }
   
    
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
    if ([@"c085" containsString:APP.SiteId]) {
        _titleLabel.hidden = NO;
        if (showAdd) {
            _titleLabel.text = @"+";
        }
        
    } else {
        _titleLabel.hidden = showAdd;
    }

    _bgImageView.hidden = showAdd;
}

- (void)setWin:(BOOL)win {
    _win = win;
    _titleLabel.backgroundColor = win ? [UIColor yellowColor] : [UIColor whiteColor];
}

@end
