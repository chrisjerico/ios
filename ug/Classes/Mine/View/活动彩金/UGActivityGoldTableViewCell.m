//
//  UGActivityGoldTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGActivityGoldTableViewCell.h"

@implementation UGActivityGoldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = Skin1.textColor4;
    self.firstLabel.textColor = Skin1.textColor1;
    self.secondLabel.textColor = Skin1.textColor1;
    self.thirdLabel.textColor = Skin1.textColor1;
}

@end
