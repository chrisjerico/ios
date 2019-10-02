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
    // Initialization code
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
