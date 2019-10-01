//
//  UGFundDetailsCell.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundDetailsCell.h"
#import "UGFundLogsModel.h"
#import "UGRechargeLogsModel.h"

@interface UGFundDetailsCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation UGFundDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

- (void)setItem:(UGFundLogsModel *)item {
    _item = item;
    self.timeLabel.text = item.time;
    self.changeAmountLabel.text = item.changeMoney;
    self.typeLabel.text = item.category;
    self.balanceLabel.text = [item.balance removeFloatAllZero];
    if ([item.changeMoney containsString:@"-"]) {
        self.changeAmountLabel.textColor = UGGreenColor;
    }else {
        self.changeAmountLabel.textColor = [UIColor redColor];
    }
}

- (void)setRechargeitem:(UGRechargeLogsModel *)rechargeitem {
    _rechargeitem = rechargeitem;
    self.timeLabel.text = rechargeitem.applyTime;
    self.changeAmountLabel.text = [NSString stringWithFormat:@"¥%@",[rechargeitem.amount removeFloatAllZero]];
    self.changeAmountLabel.textColor = UGGreenColor;
    self.typeLabel.text = rechargeitem.category;
    self.balanceLabel.text = rechargeitem.status;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
