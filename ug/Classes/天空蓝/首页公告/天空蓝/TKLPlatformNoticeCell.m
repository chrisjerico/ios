//
//  TKLPlatformNoticeCell.m
//  UGBWApp
//
//  Created by ug on 2020/9/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLPlatformNoticeCell.h"

@implementation TKLPlatformNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end
