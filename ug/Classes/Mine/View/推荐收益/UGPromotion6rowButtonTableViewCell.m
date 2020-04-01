//
//  UGPromotion6rowButtonTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotion6rowButtonTableViewCell.h"

@implementation UGPromotion6rowButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor: Skin1.textColor4];
    _firstLabel.textColor = Skin1.textColor1;
    _secondLabel.textColor = Skin1.textColor1;
    _thirdLabel.textColor = Skin1.textColor1;
    _fifthLabel.textColor = Skin1.textColor1;
    _fourthLabel.textColor = Skin1.textColor1;
    _sixLabel.textColor = Skin1.textColor1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
