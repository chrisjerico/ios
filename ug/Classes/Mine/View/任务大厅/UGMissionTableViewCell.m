//
//  UGMissionTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionTableViewCell.h"
#import "UGMissionModel.h"

@interface UGMissionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *overTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewLeading;



@end
@implementation UGMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.goButton.layer.cornerRadius = 3;
    self.goButton.layer.masksToBounds = YES;
      [self setBackgroundColor: [UIColor whiteColor]];
}


- (IBAction)goButtonClick:(id)sender {
    if (self.receiveMissionBlock) {
        self.receiveMissionBlock();
    }
    
}

-(void)setItem:(UGMissionModel *)item {
    _item = item;
    self.headerImageVeiw.hidden = YES;
    [self.titleLabel setText:item.missionName];

    //==============================================================
//    [self.titleLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
//     {
//         make.left.equalTo(self.mas_left).with.offset(30);
//         make.right.equalTo(self.mas_right).with.offset(-66);
//         make.top.equalTo(self.mas_top).offset(30);
//
//     }];
//    [self.titleLabel setText:item.missionName];
//    [self.titleLabel sizeToFit];
//
//    NSLog(@"%@",NSStringFromCGRect(self.titleLabel.frame));
//    //==============================================================
//    [self.rightImageView  mas_remakeConstraints:^(MASConstraintMaker *make)
//     {
//         make.left.equalTo(self.mas_right).with.offset(40);
//         make.top.equalTo(self.leftImageView.mas_bottom).offset(0);
//         make.height.mas_equalTo(25);
//         make.width.mas_equalTo(20);
//     }];
//    //==============================================================
//    [self.integralLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
//     {
//         make.left.equalTo(self.rightImageView.mas_right).with.offset(5);
//         make.right.equalTo(self.overTimeLabel.mas_left).with.offset(10);
//         make.top.equalTo(self.titleLabel.mas_bottom).offset(20.5);
//         make.height.mas_equalTo(14.5);
//     }];
//    //==============================================================
//    [self.overTimeLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
//     {
//         make.left.equalTo(self.integralLabel.mas_right).with.offset(5);
//         make.top.equalTo(self.titleLabel.mas_bottom).offset(20.5);
//         make.height.mas_equalTo(14.5);
//         make.width.mas_equalTo(200);
//     }];
    
    self.integralLabel.text = [NSString stringWithFormat:@"+%@积分",item.integral];
    
    if ([CMCommon stringIsNull:item.overTime]) {
        self.overTimeLabel.text = @"";
    } else {
        if ([item.overTime isEqualToString:@"0"]) {
            self.overTimeLabel.text = @"";
        } else {
            self.overTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",item.overTime];
        }
    }
    
    if ([item.type isEqualToString:@"0"]) {
        self.typeLabel.text = @"一次性";
    }else {
        self.typeLabel.text = @"日常任务";
    }
    
    if ([item.status isEqualToString:@"3"]) {
        
        [self.goButton setTitle:@"领奖励" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(197, 160, 89);
        
    }else if ([item.status isEqualToString:@"1"]) {
        
        [self.goButton setTitle:@"去完成" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(103, 168, 248);
        
    }else if ([item.status isEqualToString:@"0"]) {
        
        [self.goButton setTitle:@"领任务" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(236, 129, 69);
        
    }else if ([item.status isEqualToString:@"2"]) {
        
        [self.goButton setTitle:@"已完成" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(134, 131, 131);
        
    }
    
    
    CGSize size = [item.missionName sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    float constant = size.width + self.titleLabel.x - 10;
    if (constant > UGScreenW / 2) {
        constant = UGScreenW / 2;
    }
    self.headerImageViewLeading.constant = constant;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
