//
//  UGRechargeRecordCell.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRechargeRecordCell.h"
#import "UGRechargeLogsModel.h"

@interface UGRechargeRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
@implementation UGRechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:Skin1.textColor4];
    [self.timeLabel setTextColor:Skin1.textColor1];
    [self.amountLabel setTextColor:Skin1.textColor1];
    [self.statusLabel setTextColor:Skin1.textColor1];
}

- (void)setItem:(UGRechargeLogsModel *)item {
    _item = item;
    self.timeLabel.text = item.applyTime;
    self.amountLabel.text = [NSString stringWithFormat:@"¥%@",[item.amount removeFloatAllZero]];
    self.statusLabel.text = item.status;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
