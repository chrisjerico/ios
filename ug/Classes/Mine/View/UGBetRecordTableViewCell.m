//
//  UGBetRecordTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetRecordTableViewCell.h"
#import "UGBetsRecordListModel.h"

@interface UGBetRecordTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *actionNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *betAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
@implementation UGBetRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.backgroundColor = UGNavColor;
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

- (void)setItem:(UGBetsRecordModel *)item {
    _item = item;
    self.actionNoLabel.text = [NSString stringWithFormat:@"%@\n%@",item.issue,item.betId];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.actionNoLabel.text];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(item.issue.length + 1, item.betId.length)];
    self.actionNoLabel.attributedText = attString;
    self.gameNameLabel.text = [NSString stringWithFormat:@"%@\n%@\n@%@",item.gameName,item.playName,item.odds];
    self.betAmountLabel.text = [NSString stringWithFormat:@"%@元",item.amount];
    float amount = item.amount.floatValue * item.odds.floatValue;
    self.amountLabel.text = [NSString stringWithFormat:@"%.2lf元",amount];


}

- (void)setStatus:(NSString *)status {
    _status = status;
    if ([@"3" isEqualToString:status]) {
        self.amountLabel.textColor = UGRGBColor(102,173,91);
    }else {
        self.amountLabel.textColor = [UIColor redColor];
    }
    if ([@"1" isEqualToString:status]) {
        self.cancelButton.hidden = NO;
    }else {
        self.cancelButton.hidden = YES;
    }
}
- (IBAction)cancelClick:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
