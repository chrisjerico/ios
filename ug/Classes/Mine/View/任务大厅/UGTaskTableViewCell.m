//
//  UGTaskTableViewCell.m
//  UGBWApp
//
//  Created by andrew on 2020/7/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTaskTableViewCell.h"

@interface UGTaskTableViewCell ()
<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nestTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@end

@implementation UGTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
