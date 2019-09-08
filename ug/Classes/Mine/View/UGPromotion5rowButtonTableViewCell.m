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
