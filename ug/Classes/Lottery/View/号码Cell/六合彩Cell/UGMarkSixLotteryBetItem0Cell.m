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
@property (weak, nonatomic) IBOutlet UIImageView *ballImg;

@end
@implementation UGMarkSixLotteryBetItem0Cell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setItem:(UGGameBetModel *)item {
    _item = item;
    self.leftLabel.text = item.name;
    
    
    self.rightLabel.hidden = [_rightLabel.text isEqualToString:@"0"];
    if ([item.typeName isEqualToString:@"自选不中"]) {
        self.rightLabel.text = @"";
    }
    else{
        if (item.enable && item.gameEnable) {
           
            self.rightLabel.text = [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [item.odds floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
            
        }
        else{
            self.rightLabel.text = @"--";
        }
    }

    self.layer.borderWidth = item.select ? APP.borderWidthTimes * 1 : APP.borderWidthTimes * 0.5;
    
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
        self.leftLabel.textColor = Skin1.textColor1;
        if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
             self.backgroundColor = item.select ? RGBA(72, 146, 209, 1):  Skin1.homeContentSubColor;
        } else {
             self.backgroundColor = item.select ? Skin1.homeContentSubColor : UIColorHex(101010);
        }
       
        self.layer.borderColor = (item.select ? [UIColor whiteColor] : Skin1.textColor3).CGColor;
        
        if (APP.betOddsIsRed) {
            self.rightLabel.textColor = APP.AuxiliaryColor2;
        } else {
            self.rightLabel.textColor = Skin1.textColor2;
            self.rightLabel.highlightedTextColor = [UIColor whiteColor];
            self.rightLabel.highlighted = item.select;
        }
        
    } else {
        if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
            self.leftLabel.textColor = Skin1.textColor1;
        } else {
            self.leftLabel.textColor = item.select ? [UIColor whiteColor] : Skin1.textColor1;
        }
        

        self.backgroundColor = item.select ? [Skin1.homeContentSubColor colorWithAlphaComponent:0.2] : [UIColor clearColor];
        if (APP.isBorderNavBarBgColor) {
            self.backgroundColor = item.select ?Skin1.navBarBgColor:[UIColor clearColor];
        }
        
        if (APP.isBorderNavBarBgColor) {
            self.backgroundColor = item.select ?Skin1.navBarBgColor:[UIColor clearColor];
        }
        
        if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
            self.layer.borderColor = (item.select ? Skin1.navBarBgColor : APP.LineColor).CGColor;
        } else {
            self.layer.borderColor = (item.select ? [UIColor whiteColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.3]).CGColor;
        }
        
        if (APP.betOddsIsRed) {
            self.rightLabel.textColor = APP.AuxiliaryColor2;
        } else {
            if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
                self.rightLabel.textColor = Skin1.textColor1;
            } else {
                self.rightLabel.textColor = item.select ? [UIColor whiteColor] : Skin1.textColor1;
            }
        }
    }
    
    if (APP.isRed) {
        self.layer.borderColor = (item.select ? [UIColor redColor] : [[UIColor whiteColor] colorWithAlphaComponent:0.3]).CGColor;
    }
   

    if (APP.isBall) {
        [self.ballImg setHidden:NO];
        self.ballImg.cc_constraints.width.constant = 34;
        self.ballImg.cc_constraints.height.constant = 34;
        self.leftLabel.cc_constraints.width.constant = 34;
        self.leftLabel.cc_constraints.height.constant = 34;
//        [self.leftLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
//         {
//            make.centerY.equalTo(self.mas_centerY).with.offset(-2);
//        }];
        NSString *colorStr = [CMCommon getHKLotteryNumColorString:item.name];
        if ([colorStr isEqualToString:@"red"]) {
            [self.ballImg setImage:[UIImage imageNamed:@"lhc_red"]];
        }
        else if ([colorStr isEqualToString:@"blue"]) {
            [self.ballImg setImage:[UIImage imageNamed:@"lhc_blue"]];
        }
        else if ([colorStr isEqualToString:@"greed"]) {
            [self.ballImg setImage:[UIImage imageNamed:@"lhc_green"]];
        }
        self.leftLabel.layer.masksToBounds = NO;
        self.leftLabel.layer.borderWidth = 0;
        
        self.leftLabel.textColor =  Skin1.textColor1;
        
    }
    else {
        [self.ballImg setHidden:YES];
        self.ballImg.cc_constraints.width.constant = 28;
        self.ballImg.cc_constraints.height.constant = 28;
        self.leftLabel.cc_constraints.width.constant = 28;
        self.leftLabel.cc_constraints.height.constant = 28;
        self.leftLabel.layer.borderColor = [CMCommon getHKLotteryNumColor:item.name].CGColor;
        self.leftLabel.layer.cornerRadius = self.leftLabel.width / 2;
        self.leftLabel.layer.masksToBounds = YES;
        self.leftLabel.layer.borderWidth = 1;
    }

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
