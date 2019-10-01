//
//  UGLotteryRecordCell.m
//  ug
//
//  Created by ug on 2019/7/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryRecordCell.h"
#import "UGBetsRecordListModel.h"
@interface UGLotteryRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *betIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *betAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lotteryNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *playNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation UGLotteryRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.backgroundColor = UGNavColor;
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

- (void)setItem:(UGBetsRecordModel *)item {
    _item = item;
    self.cancelButton.hidden = YES;
    self.gameNameLabel.text = [NSString stringWithFormat:@"彩种：%@   期数：%@",item.gameName,item.issue];
    self.betIdLabel.text = [NSString stringWithFormat:@"注单单号：%@",item.betId];
    self.betAmountLabel.text = [NSString stringWithFormat:@"注单金额：%@元",item.betAmount];
    self.lotteryNoLabel.text = item.lotteryNo;
    self.playNameLabel.text = [NSString stringWithFormat:@"玩法：%@/%@",item.playGroupName,item.playName];
    self.winAmountLabel.text = [NSString stringWithFormat:@"盈亏：%@元",item.settleAmount];
    
    if (item.status == 1) {
        self.cancelButton.hidden = NO;
        self.lotteryNoLabel.text = @"等待开奖";
        float money = item.odds.floatValue * item.betAmount.floatValue;
        NSString *moneyStr = [NSString stringWithFormat:@"%f",money];
        self.winAmountLabel.text = [NSString stringWithFormat:@"可赢金额：%@元",[moneyStr removeFloatAllZero]];
    }else if (item.status == 4) {
        self.lotteryNoLabel.text = @"已撤单";
        self.winAmountLabel.text = @"盈亏：--";
    }
    
    self.lotteryNoLabel.textColor = UGNavColor;
    
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.betIdLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGGreenColor range:NSMakeRange(5, self.betIdLabel.text.length - 5)];
    self.betIdLabel.attributedText = abStr;
    
    NSMutableAttributedString *abStr1 = [[NSMutableAttributedString alloc] initWithString:self.betAmountLabel.text];
    [abStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, self.betAmountLabel.text.length - 5)];
    self.betAmountLabel.attributedText = abStr1;
    
    if (item.status == 1) {
        
        NSMutableAttributedString *abStr4 = [[NSMutableAttributedString alloc] initWithString:self.winAmountLabel.text];
        [abStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(5, self.winAmountLabel.text.length - 5)];
        self.winAmountLabel.attributedText = abStr4;
    }else {
        NSMutableAttributedString *abStr4 = [[NSMutableAttributedString alloc] initWithString:self.winAmountLabel.text];
        [abStr4 addAttribute:NSForegroundColorAttributeName value:UGGreenColor range:NSMakeRange(3, self.winAmountLabel.text.length - 3)];
        self.winAmountLabel.attributedText = abStr4;
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
