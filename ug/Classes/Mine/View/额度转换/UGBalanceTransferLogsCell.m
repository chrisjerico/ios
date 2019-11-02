//
//  UGBalanceTransferLogsCell.m
//  ug
//
//  Created by ug on 2019/8/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBalanceTransferLogsCell.h"
#import "UGBalanceTransferLogsModel.h"
@interface UGBalanceTransferLogsCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

@end
@implementation UGBalanceTransferLogsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self setBackgroundColor: Skin1.cellBgColor];
}

- (void)setItem:(UGBalanceTransferLogsModel *)item {
    _item = item;
    self.nameLabel.text = item.gameName;
    self.amountLabel.text = item.amount;
    self.dateLabel.text = item.actionTime;
    self.modeLabel.text = item.isAuto ? @"自动" : @"手动";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
