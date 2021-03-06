//
//  UGMissionTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionTableViewCell.h"
#import "UGMissionModel.h"
//（存款任务）每日单笔存款金额达到5000元
@interface UGMissionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageVeiw;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *overTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewLeading;
@property (weak, nonatomic) IBOutlet UIView *separatorLineView;

@end


@implementation UGMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goButton.layer.cornerRadius = 3;
    self.goButton.layer.masksToBounds = YES;
    if (Skin1.isBlack) {
        [self setBackgroundColor: Skin1.bgColor];
        [_titleLabel setTextColor:Skin1.textColor1];
        [_overTimeLabel setTextColor:Skin1.textColor1];
        
    } else {
        [self setBackgroundColor: [UIColor whiteColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_overTimeLabel setTextColor:[UIColor blackColor]];
    }
    _separatorLineView.backgroundColor = Skin1.isBlack ? [UIColor lightTextColor] : APP.LineColor;
}

- (IBAction)goButtonClick:(id)sender {
    if (self.receiveMissionBlock)
        self.receiveMissionBlock(self);
}

- (IBAction)cellButtonClick:(id)sender {
    if (self.receiveBlock)
        self.receiveBlock(self);
}

-(void)setItem:(UGMissionModel *)item {
    _item = item;
    self.headerImageVeiw.hidden = YES;
    [self.titleLabel setText:item.missionName];

    self.integralLabel.text = [NSString stringWithFormat:@"+%@积分",[item.integral removeFloatAllZero]];
    
    if ([CMCommon stringIsNull:item.overTime]) {
        self.overTimeLabel.text = @"";
    } else {
        if ([item.overTime isEqualToString:@"0"]) {
            self.overTimeLabel.text = @"";
        } else {
            self.overTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",item.overTime];
        }
    }
    
//    if ([item.type isEqualToString:@"0"]) {
//        self.typeLabel.text = @"一次性";
//    } else {
//        self.typeLabel.text = @"日常任务";
//    }
//    self.typeLabel.text = item.sortName;

    
    if ([item.status isEqualToString:@"3"]) {
        [self.goButton setTitle:@"领奖励" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(197, 160, 89);
    }
    else if ([item.status isEqualToString:@"1"]) {
        [self.goButton setTitle:@"去完成" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(103, 168, 248);
    }
    else if ([item.status isEqualToString:@"0"]) {
        [self.goButton setTitle:@"领任务" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(236, 129, 69);
    }
    else if ([item.status isEqualToString:@"2"]) {
        [self.goButton setTitle:@"已完成" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(134, 131, 131);
    }
    self.goButton.titleLabel.font = [self.goButton.currentTitle fontWithFrameSize:CGSizeMake(80, 27) maxFont:[UIFont systemFontOfSize:12]];
    
    CGSize size = [item.missionName sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    float constant = size.width + self.titleLabel.x - 10;
    if (constant > UGScreenW / 2) {
        constant = UGScreenW / 2;
    }
    self.headerImageViewLeading.constant = constant;
}

@end
