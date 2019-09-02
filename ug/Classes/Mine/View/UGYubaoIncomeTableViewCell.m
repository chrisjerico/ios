//
//  UGYubaoIncomeTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYubaoIncomeTableViewCell.h"
#import "UGYuebaoProfitReportModel.h"
@interface UGYubaoIncomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end
@implementation UGYubaoIncomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(UGYuebaoProfitReportModel *)item {
    _item = item;
    self.timeLabel.text = item.settleTime;
    self.incomeLabel.text = item.profitAmount;
    self.balanceLabel.text = item.settleBalance;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
