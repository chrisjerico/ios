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
#import "CMLabelCommon.h"

@interface UGMarkSixLotteryBetItem1Cell ()
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *num0Label;
@property (weak, nonatomic) IBOutlet UILabel *num1Label;
@property (weak, nonatomic) IBOutlet UILabel *num2Label;
@property (weak, nonatomic) IBOutlet UILabel *num3Label;
@property (weak, nonatomic) IBOutlet UILabel *num4Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *num0LabelLeading;
@property (weak, nonatomic) IBOutlet UIImageView *ballImg0;
@property (weak, nonatomic) IBOutlet UIImageView *ballImg1;
@property (weak, nonatomic) IBOutlet UIImageView *ballImg2;
@property (weak, nonatomic) IBOutlet UIImageView *ballImg3;
@property (weak, nonatomic) IBOutlet UIImageView *ballImg4;

@end
@implementation UGMarkSixLotteryBetItem1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    [self.leftTitleLabel setTextColor:Skin1.textColor1];
    [self.num0Label setTextColor:Skin1.textColor1];
    [self.num1Label setTextColor:Skin1.textColor1];
    [self.num2Label setTextColor:Skin1.textColor1];
    [self.num3Label setTextColor:Skin1.textColor1];
    [self.num4Label setTextColor:Skin1.textColor1];
    
    if (APP.betSizeIsBig) {
        self.leftTitleLabel.font = APP.cellBigFont;
        //        [CMLabelCommon setRichNumberWithLabel:self.leftTitleLabel Color:self.leftTitleLabel.textColor FontSize:APP.cellNormalFontSize];
    } else {
        self.leftTitleLabel.font = APP.cellNormalFont;
    }
}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.layer.borderWidth = item.select ? APP.borderWidthTimes * 1 : APP.borderWidthTimes *  0.5;
    
    
    
    if (APP.betOddsIsRed) {
        self.leftTitleLabel.attributedText = ({
            NSString *odds = [item.odds removeFloatAllZero];
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:_NSString(@"%@ %@", item.name, [odds isEqualToString:@"0"] ? @"" : odds) attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
            [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:odds];
            mas;
        });
    } else {

            if (item.enable && item.gameEnable) {
                if ([item.typeName isEqualToString:@"合肖"]) {
                     self.leftTitleLabel.text = _item.name;
                } else {
                     self.leftTitleLabel.text = _NSString(@"%@ %@",item.name, [item.odds removeFloatAllZero]);
                }
               
            } else {
                self.leftTitleLabel.text = _NSString(@"%@ --",item.name);
            }

        
    }
    if (Skin1.isBlack||Skin1.is23) {
        self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if (!APP.betOddsIsRed) {
            self.leftTitleLabel.textColor = Skin1.textColor2;
            self.leftTitleLabel.highlightedTextColor = [UIColor whiteColor];
            self.leftTitleLabel.highlighted = item.select;
        }
    } else {
        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        if (APP.isBorderNavBarBgColor) {
            self.backgroundColor = item.select ?Skin1.navBarBgColor:[UIColor clearColor];
        }
        if (APP.betBgIsWhite) {
            self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
        } else {
            self.layer.borderColor = (item.select ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.3]).CGColor;
        }
        
        if (!APP.betOddsIsRed) {
            if (APP.betBgIsWhite) {
                self.leftTitleLabel.textColor = Skin1.textColor1;
            } else {
                self.leftTitleLabel.textColor = item.select ? [UIColor whiteColor] : Skin1.textColor1;
            }
        }
    }
    [self setupNums:item];
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
    
    if (APP.isBall) {
        [self.ballImg0 setHidden:NO];
        [self.ballImg1 setHidden:NO];
        [self.ballImg2 setHidden:NO];
        [self.ballImg3 setHidden:NO];
        [self.ballImg4 setHidden:NO];
        self.ballImg0.cc_constraints.width.constant = 34;
        self.ballImg0.cc_constraints.height.constant = 34;
        self.ballImg1.cc_constraints.width.constant = 34;
        self.ballImg1.cc_constraints.height.constant = 34;
        self.ballImg2.cc_constraints.width.constant = 34;
        self.ballImg2.cc_constraints.height.constant = 34;
        self.ballImg3.cc_constraints.width.constant = 34;
        self.ballImg3.cc_constraints.height.constant = 34;
        self.ballImg4.cc_constraints.width.constant = 34;
        self.ballImg4.cc_constraints.height.constant = 34;
        
        self.num0Label.layer.masksToBounds = NO;
        self.num0Label.layer.borderWidth = 0;
        self.num0Label.cc_constraints.width.constant = 34;
        self.num0Label.cc_constraints.height.constant = 34;
        self.num1Label.layer.masksToBounds = NO;
        self.num1Label.layer.borderWidth = 0;
        self.num1Label.cc_constraints.width.constant = 34;
        self.num1Label.cc_constraints.height.constant = 34;
        self.num2Label.layer.masksToBounds = NO;
        self.num2Label.layer.borderWidth = 0;
        self.num2Label.cc_constraints.width.constant = 34;
        self.num2Label.cc_constraints.height.constant = 34;
        self.num3Label.layer.masksToBounds = NO;
        self.num3Label.layer.borderWidth = 0;
        self.num3Label.cc_constraints.width.constant = 34;
        self.num3Label.cc_constraints.height.constant = 34;
        self.num4Label.layer.masksToBounds = NO;
        self.num4Label.layer.borderWidth = 0;
        self.num4Label.cc_constraints.width.constant = 34;
        self.num4Label.cc_constraints.height.constant = 34;
        [self.ballImg0 setImage:[CMCommon getHKLotteryNumColorImg:num0]];
        [self.ballImg1 setImage:[CMCommon getHKLotteryNumColorImg:num1]];
        [self.ballImg2 setImage:[CMCommon getHKLotteryNumColorImg:num2]];
        [self.ballImg3 setImage:[CMCommon getHKLotteryNumColorImg:num3]];
        if (model.nums.count == 5) {
            NSString *num4 = [NSString stringWithFormat:@"%@",model.nums[4]];
            self.num4Label.text = num4;
            [self.ballImg4 setImage:[CMCommon getHKLotteryNumColorImg:num4]];
            if ([@"合肖" isEqualToString:self.item.typeName]) {
                self.num4Label.hidden = YES;
                [self.ballImg4 setHidden:YES];
            } else {
                self.num4Label.hidden = NO;
                [self.ballImg4 setHidden:NO];
            }
            
        } else {
            self.num4Label.hidden = YES;
            [self.ballImg4 setHidden:YES];
        }
        
    }
    else {
        

        [self.ballImg0 setHidden:YES];
        [self.ballImg1 setHidden:YES];
        [self.ballImg2 setHidden:YES];
        [self.ballImg3 setHidden:YES];
        [self.ballImg4 setHidden:YES];
        self.ballImg0.cc_constraints.width.constant = 28;
        self.ballImg0.cc_constraints.height.constant = 28;
        self.ballImg1.cc_constraints.width.constant = 28;
        self.ballImg1.cc_constraints.height.constant = 28;
        self.ballImg2.cc_constraints.width.constant = 28;
        self.ballImg2.cc_constraints.height.constant = 28;
        self.ballImg3.cc_constraints.width.constant = 28;
        self.ballImg3.cc_constraints.height.constant = 28;
        self.ballImg4.cc_constraints.width.constant = 28;
        self.ballImg4.cc_constraints.height.constant = 28;
        self.num0Label.layer.cornerRadius = self.num0Label.width / 2;
        self.num0Label.layer.masksToBounds = YES;
        self.num0Label.layer.borderWidth = 1;
        self.num0Label.cc_constraints.width.constant = 28;
        self.num0Label.cc_constraints.height.constant = 28;
        
        self.num1Label.layer.cornerRadius = self.num1Label.width / 2;
        self.num1Label.layer.masksToBounds = YES;
        self.num1Label.layer.borderWidth = 1;
        self.num1Label.cc_constraints.width.constant = 28;
        self.num1Label.cc_constraints.height.constant = 28;
        
        self.num2Label.layer.cornerRadius = self.num2Label.width / 2;
        self.num2Label.layer.masksToBounds = YES;
        self.num2Label.layer.borderWidth = 1;
        self.num2Label.cc_constraints.width.constant = 28;
        self.num2Label.cc_constraints.height.constant = 28;
        
        self.num3Label.layer.cornerRadius = self.num3Label.width / 2;
        self.num3Label.layer.masksToBounds = YES;
        self.num3Label.layer.borderWidth = 1;
        self.num3Label.cc_constraints.width.constant = 28;
        self.num3Label.cc_constraints.height.constant = 28;
        
        self.num4Label.layer.cornerRadius = self.num4Label.width / 2;
        self.num4Label.layer.masksToBounds = YES;
        self.num4Label.layer.borderWidth = 1;
        self.num4Label.cc_constraints.width.constant = 28;
        self.num4Label.cc_constraints.height.constant = 28;
        
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
            } else {
                self.num4Label.hidden = NO;
            }
            
        } else {
            self.num4Label.hidden = YES;
        }
    }
    
}

@end
