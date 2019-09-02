//
//  UGTimeLotteryBetHeaderView.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTimeLotteryBetHeaderView.h"

@interface UGTimeLotteryBetHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterXContstraint;

@end
@implementation UGTimeLotteryBetHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    
}

- (void)setLeftTitle:(BOOL)leftTitle {
    _leftTitle = leftTitle;
    if (leftTitle) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.left).offset(15);
        }];
    }else {
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.left).offset(0);
        }];
    }
}
@end
