//
//  UGPromotion4rowTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotion4rowTableViewCell.h"

@implementation UGPromotion4rowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self.contentView setBackgroundColor: Skin1.textColor4];
    _firstLabel.textColor = Skin1.textColor1;
    _secondLabel.textColor = Skin1.textColor1;
    _thirdLabel.textColor = Skin1.textColor1;
    _fourthLabel.textColor = Skin1.textColor1;

    _fouthButton.layer.cornerRadius = 5;
    _fouthButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)signInClick:(id)sender {
    if (self.promotion4rowButtonBlock) {
        self.promotion4rowButtonBlock();
    }
}
@end
