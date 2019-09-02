//
//  UGLotterySubResultCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotterySubResultCollectionViewCell.h"

@interface UGLotterySubResultCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGLotterySubResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.7;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setShowAdd:(BOOL)showAdd {
    _showAdd = showAdd;
    if (showAdd) {
        self.titleLabel.hidden = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
    }else {
        self.titleLabel.hidden = NO;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

- (void)setWin:(BOOL)win {
    _win = win;
    if (win) {
        self.backgroundColor = [UIColor yellowColor];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
