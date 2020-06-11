//
//  UGChanglongBetRecrodCell.m
//  ug
//
//  Created by ug on 2019/8/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChanglongBetRecrodCell.h"
#import "UGChanglongBetRecordModel.h"
@interface UGChanglongBetRecrodCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *betAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
@implementation UGChanglongBetRecrodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_bgView setBackgroundColor:Skin1.textColor4];
    [_nameLabel setTextColor:Skin1.textColor1];
    
}

- (void)setItem:(UGChanglongBetRecordModel *)item {
    _item = item;
    self.nameLabel.text = item.title;
    self.betAmountLabel.text = [NSString stringWithFormat:@"¥%@",[item.money removeFloatAllZero]];
    
    if (![CMCommon stringIsNull:item.displayNumber]) {
        self.issueLabel.text = [NSString stringWithFormat:@"%@ 期",item.displayNumber];
    } else {
        self.issueLabel.text = [NSString stringWithFormat:@"%@ 期",item.issue];
    }
    
    if (item.isWin) {
        self.winAmountLabel.hidden = NO;
        self.statusWinLabel.hidden = NO;
        self.statusLabel.hidden = YES;
        self.winAmountLabel.text = [NSString stringWithFormat:@"+%@元",item.bonus];
    }else {
        self.winAmountLabel.hidden = YES;
        self.statusWinLabel.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = item.msg;
        if (item.status) {
            self.statusLabel.textColor = [UIColor grayColor];
        }else {
            self.statusLabel.textColor = [UIColor redColor];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
