//
//  UGRealBetRecordCell.m
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRealBetRecordCell.h"
#import "UGBetsRecordListModel.h"
@interface UGRealBetRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *betAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;

@end

@implementation UGRealBetRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(UGBetsRecordModel *)item {
    _item = item;
    self.gameNameLabel.text = item.gameName;
    self.timeLabel.text = [item.betTime stringToFormatSecondDateString];
    self.betAmountLabel.text = [NSString stringWithFormat:@"%@元",item.betAmount];
    self.winAmountLabel.text = [NSString stringWithFormat:@"%@元",item.winAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
