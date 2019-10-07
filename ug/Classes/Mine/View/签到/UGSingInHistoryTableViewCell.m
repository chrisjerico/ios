//
//  UGSingInHistoryTableViewCell.m
//  ug
//
//  Created by ug on 2019/9/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSingInHistoryTableViewCell.h"
#import "UGSignInHistoryModel.h"

@interface UGSingInHistoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end
@implementation UGSingInHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      [self setBackgroundColor: [[UGSkinManagers shareInstance] sethomeContentColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(UGSignInHistoryModel *)item {
    _item = item;
    self.dateLabel.text = item.checkinDate;
    self.numberLabel.text = item.integral;
    self.remarkLabel.text = item.remark;
   
}

@end
