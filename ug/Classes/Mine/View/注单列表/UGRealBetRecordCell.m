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
@property (weak, nonatomic) IBOutlet UILabel *ticketNoLabel;
@end

@implementation UGRealBetRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:Skin1.textColor4];
    [_gameNameLabel setTextColor:Skin1.textColor1];
    [_timeLabel setTextColor:Skin1.textColor1];
    [_betAmountLabel setTextColor:Skin1.textColor1];
    [_winAmountLabel setTextColor:Skin1.textColor1];
}

- (void)setItem:(UGBetsRecordModel *)item {
    _item = item;
    self.gameNameLabel.text = _NSString(@"%@/\n%@", item.gameName, item.gameTypeName);
    self.timeLabel.text = item.betTime;
    self.betAmountLabel.text = [NSString stringWithFormat:@"%@元",item.betAmount];
    self.winAmountLabel.text = [NSString stringWithFormat:@"%@元",item.winAmount];
    self.ticketNoLabel.text = item.ticketNo;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
