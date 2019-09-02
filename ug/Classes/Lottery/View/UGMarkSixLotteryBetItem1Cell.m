//
//  UGMarkSixLotteryBetItem1Cell.m
//  ug
//
//  Created by ug on 2019/5/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMarkSixLotteryBetItem1Cell.h"
#import "UGGameplayModel.h"
#import "UGLotterySettingModel.h"

@interface UGMarkSixLotteryBetItem1Cell ()
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *num0Label;
@property (weak, nonatomic) IBOutlet UILabel *num1Label;
@property (weak, nonatomic) IBOutlet UILabel *num2Label;
@property (weak, nonatomic) IBOutlet UILabel *num3Label;
@property (weak, nonatomic) IBOutlet UILabel *num4Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *num0LabelLeading;

@end
@implementation UGMarkSixLotteryBetItem1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.num0Label.layer.cornerRadius = self.num0Label.width / 2;
    self.num0Label.layer.masksToBounds = YES;
    self.num0Label.layer.borderColor = [UIColor redColor].CGColor;
    self.num0Label.layer.borderWidth = 1;
    
    self.num1Label.layer.cornerRadius = self.num1Label.width / 2;
    self.num1Label.layer.masksToBounds = YES;
    self.num1Label.layer.borderColor = [UIColor redColor].CGColor;
    self.num1Label.layer.borderWidth = 1;
    
    self.num2Label.layer.cornerRadius = self.num2Label.width / 2;
    self.num2Label.layer.masksToBounds = YES;
    self.num2Label.layer.borderColor = [UIColor redColor].CGColor;
    self.num2Label.layer.borderWidth = 1;
    
    self.num3Label.layer.cornerRadius = self.num3Label.width / 2;
    self.num3Label.layer.masksToBounds = YES;
    self.num3Label.layer.borderColor = [UIColor redColor].CGColor;
    self.num3Label.layer.borderWidth = 1;
    
    self.num4Label.layer.cornerRadius = self.num4Label.width / 2;
    self.num4Label.layer.masksToBounds = YES;
    self.num4Label.layer.borderColor = [UIColor redColor].CGColor;
    self.num4Label.layer.borderWidth = 1;
    
    
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.leftTitleLabel.text = [NSString stringWithFormat:@"%@ %@",item.name,[item.odds removeFloatAllZero]];
    [self setupNums:item];
    
    if (item.select) {
        self.layer.borderColor = UGNavColor.CGColor;
        self.layer.borderWidth = 1;
    }else {
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
}

- (void)setNum4Hidden:(BOOL)num4Hidden {
    _num4Hidden = num4Hidden;
    self.num4Label.hidden = num4Hidden;
    if (num4Hidden) {
        self.num0LabelLeading.constant = 60;
    }else {
        self.num0LabelLeading.constant = 30;
    }
}

- (void)setupNums:(UGGameBetModel *)item {
    for (UGZodiacModel *model in self.playModel.setting.zodiacNums) {
        if ([item.name isEqualToString:model.name]) {
            [self handleNums:model];
        }
    }
    for (UGZodiacModel *model in self.playModel.setting.tails) {
        if ([item.name isEqualToString:model.name]) {
            [self handleNums:model];
        }
    }
}

- (void)handleNums:(UGZodiacModel *)model {
    NSString *num0 = [NSString stringWithFormat:@"%@",model.nums[0]];
    NSString *num1 = [NSString stringWithFormat:@"%@",model.nums[1]];
    NSString *num2 = [NSString stringWithFormat:@"%@",model.nums[2]];
    NSString *num3 = [NSString stringWithFormat:@"%@",model.nums[3]];
    self.num0Label.text = num0;
    self.num1Label.text = num1;
    self.num2Label.text = num2;
    self.num3Label.text = num3;
    self.num0Label.layer.borderColor = [CMCommon getHKLotteryNumColor:num0].CGColor;
    self.num1Label.layer.borderColor = [CMCommon getHKLotteryNumColor:num1].CGColor;
    self.num2Label.layer.borderColor = [CMCommon getHKLotteryNumColor:num2].CGColor;
    self.num3Label.layer.borderColor = [CMCommon getHKLotteryNumColor:num3].CGColor;
    if (model.nums.count == 5) {
       
        NSString *num4 = [NSString stringWithFormat:@"%@",model.nums[4]];
        self.num4Label.text = num4;
        self.num4Label.layer.borderColor = [CMCommon getHKLotteryNumColor:num4].CGColor;
        if ([@"合肖" isEqualToString:self.item.typeName]) {
            self.num4Label.hidden = YES;
        }else {
             self.num4Label.hidden = NO;
        }
        
    }else {
        self.num4Label.hidden = YES;
        
    }
}

@end
