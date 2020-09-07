//
//  UGTimeLotteryBetHeaderView.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTimeLotteryBetHeaderView.h"

@interface UGTimeLotteryBetHeaderView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterXContstraint;

@end
@implementation UGTimeLotteryBetHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (Skin1.isBlack||Skin1.is23) {
         self.titleLabel.textColor = [UIColor whiteColor];
    } else {
         self.titleLabel.textColor = Skin1.textColor1;
    }
    
    if (APP.isSectionWhite) {
         self.titleLabel.textColor = [UIColor whiteColor];
    }
    
    [self.allBtn setBackgroundColor:UGBlueColor];
    [self.bigBtn setBackgroundColor:UGBlueColor];
    [self.smallBtn setBackgroundColor:UGBlueColor];
    [self.jiBtn setBackgroundColor:UGBlueColor];
    [self.ouBtn setBackgroundColor:UGBlueColor];
    [self.removeBtn setBackgroundColor:UGBlueColor];


}

- (void)setLeftTitle:(BOOL)leftTitle {
    _leftTitle = leftTitle;
    if (leftTitle) {
        if (Skin1.isBlack||Skin1.is23) {
             self.titleLabel.textColor = [UIColor whiteColor];
        } else {
             self.titleLabel.textColor = Skin1.textColor1;
        }
        self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.left).offset(15);
        }];
    }else {
        if (Skin1.isBlack||Skin1.is23) {
             self.titleLabel.textColor = [UIColor whiteColor];
        } else {
             self.titleLabel.textColor = Skin1.textColor2;
        }
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.left).offset(0);
        }];
    }
    
    if (APP.isSectionWhite) {
         self.titleLabel.textColor = [UIColor whiteColor];
    }
}
@end
