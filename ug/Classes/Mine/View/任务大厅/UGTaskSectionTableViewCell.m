//
//  UGTaskSectionTableViewCell.m
//  UGBWApp
//
//  Created by andrew on 2020/7/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTaskSectionTableViewCell.h"

@implementation UGTaskSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (Skin1.isBlack) {
        self.contentView.backgroundColor = [UIColor systemGrayColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
