//
//  UGPromotion5rowButtonTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotion5rowButtonTableViewCell.h"

@implementation UGPromotion5rowButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _pointView.layer.cornerRadius = 5;
    _pointView.layer.masksToBounds = YES;
    [self.contentView setBackgroundColor: Skin1.textColor4];
    _firstLabel.textColor = Skin1.textColor1;
    _secondLabel.textColor = Skin1.textColor1;
    _thirdLabel.textColor = Skin1.textColor1;
    _fourthLabel.textColor = Skin1.textColor1;
    _fifthLabel.textColor = Skin1.textColor1;
    
    [_fifthButton setBackgroundColor:Skin1.textColor4];
    
    [_fifthButton setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)signInClick:(id)sender {
    if (self.promotion5rowButtonBlock) {
        self.promotion5rowButtonBlock();
    }
}

@end
