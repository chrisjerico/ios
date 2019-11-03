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
    self.backgroundColor = Skin1.cellBgColor;
    self.nameLabel.textColor = Skin1.textColor1;
    self.amountLabel.textColor = Skin1.textColor1;
    self.dateLabel.textColor = Skin1.textColor1;
    self.modeLabel.textColor = Skin1.textColor1;
}

- (void)setItem:(UGBalanceTransferLogsModel *)item {
    _item = item;
    self.nameLabel.text = item.gameName;
    self.amountLabel.text = item.amount;
    self.dateLabel.text = item.actionTime;
    self.modeLabel.text = item.isAuto ? @"自动" : @"手动";
}

@end
