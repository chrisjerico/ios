//
//  UGIntegarlConvertRecordCell.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGIntegarlConvertRecordCell.h"
#import "UGCreditsLogModel.h"


@interface UGIntegarlConvertRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *gnewIntLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;


@end
@implementation UGIntegarlConvertRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(UGCreditsLogModel *)item {
    _item = item;
    self.typeLabel.text = item.type;
    self.integralLabel.text = item.integral;
    self.gnewIntLabel.text = item.gnewInt;
    self.addTimeLabel.text = item.addTime;

    
}
@end
