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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = true;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = Skin1.textColor3.CGColor;
    _nameLabel.textColor = Skin1.textColor1;
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
