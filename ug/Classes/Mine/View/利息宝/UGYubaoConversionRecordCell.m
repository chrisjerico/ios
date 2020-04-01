//
//  UGYubaoConversionRecordCell.m
//  ug
//
//  Created by ug on 2019/5/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYubaoConversionRecordCell.h"
#import "UGYuebaoTransferLogsModel.h"
@interface UGYubaoConversionRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end
@implementation UGYubaoConversionRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:Skin1.textColor4];
    [_timeLabel setTextColor:Skin1.textColor1];
    [_typeLabel setTextColor:Skin1.textColor1];
    [_amountLabel setTextColor:Skin1.textColor1];
    [_balanceLabel setTextColor:Skin1.textColor1];
}

-(void)setItem:(UGYuebaoTransferLogsModel *)item {
    _item = item;
    self.timeLabel.text = item.changeTime;
    self.amountLabel.text = [item.amount removeFloatAllZero];
    self.balanceLabel.text = [item.balance removeFloatAllZero];

    self.typeLabel.text = item.category;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
