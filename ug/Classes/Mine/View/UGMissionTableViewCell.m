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
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *overTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewLeading;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@end
@implementation UGMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.goButton.layer.cornerRadius = 3;
    self.goButton.layer.masksToBounds = YES;
}


- (IBAction)goButtonClick:(id)sender {
    if (self.receiveMissionBlock) {
        self.receiveMissionBlock();
    }
    
}

-(void)setItem:(UGMissionModel *)item {
    _item = item;
    self.headerImageVeiw.hidden = YES;
    self.titleLabel.text = item.missionName;
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
