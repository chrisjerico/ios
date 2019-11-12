//
//  UGMarkSixLotteryBetItem0Cell.m
//  ug
//
//  Created by ug on 2019/5/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMarkSixLotteryBetItem0Cell.h"
#import "UGGameplayModel.h"
@interface UGMarkSixLotteryBetItem0Cell ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelCenterXConstraint;

@end
@implementation UGMarkSixLotteryBetItem0Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftLabel.layer.cornerRadius = self.leftLabel.width / 2;
    self.leftLabel.layer.masksToBounds = YES;
    self.leftLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.leftLabel.layer.borderWidth = 1;
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.rightLabel setTextColor:[UIColor whiteColor]];
        [self.leftLabel setTextColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:Skin1.bgColor];
    } else {
        [self.rightLabel setTextColor:[UIColor blackColor]];
        [self.leftLabel setTextColor:[UIColor blackColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
}

- (void)setItem:(UGGameBetModel *)item {
    
    _item = item;
    self.leftLabel.text = item.name;
    self.rightLabel.text = [item.odds removeFloatAllZero];
    self.rightLabel.hidden = [_rightLabel.text isEqualToString:@"0"];
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
         if (item.select) {
               self.layer.borderColor = [UIColor whiteColor].CGColor;
               self.layer.borderWidth = 1;
           } else {
               self.layer.borderWidth = 0.7;
               self.layer.borderColor = Skin1.bgColor.CGColor;
           }
    } else {
        if (item.select) {
               self.layer.borderColor = Skin1.navBarBgColor.CGColor;
               self.layer.borderWidth = 1;
           } else {
               self.layer.borderWidth = 0.7;
               self.layer.borderColor = [UIColor whiteColor].CGColor;
           }
    }
   
    
    self.leftLabel.layer.borderColor = [CMCommon getHKLotteryNumColor:item.name].CGColor;
    if (item.odds.length) {
        if ([item.odds containsString:@"/"]) {
            self.leftLabelCenterXConstraint.constant = -25;
        } else {
            self.leftLabelCenterXConstraint.constant = -15;
        }
    } else {
        self.leftLabelCenterXConstraint.constant = 0;
    }

}

@end
