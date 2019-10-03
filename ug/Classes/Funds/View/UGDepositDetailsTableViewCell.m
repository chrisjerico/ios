//
//  UGDepositDetailsTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDepositDetailsTableViewCell.h"

#import "UGdepositModel.h"

@interface UGDepositDetailsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;//已签到（灰）补签（红）签到（蓝）




@end
@implementation UGDepositDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.nameLabel.text = nameStr;
    
}


- (void)setHeaderImageStr:(NSString *)headerImageStr {
    _headerImageStr= headerImageStr;
    self.headerImageView.image = [UIImage imageNamed:headerImageStr];
    
}
@end
