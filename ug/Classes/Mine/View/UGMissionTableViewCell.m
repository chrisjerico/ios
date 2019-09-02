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
    self.headerImageVeiw.hidden = !item.status;
    self.titleLabel.text = item.missionName;
    self.integralLabel.text = [NSString stringWithFormat:@"+%@",item.integral];
    self.overTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",item.overTime];
    if (item.status) {
        [self.goButton setTitle:@"去完成" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(105, 172, 91);
    }else {
        
        [self.goButton setTitle:@"去领取" forState:UIControlStateNormal];
        self.goButton.backgroundColor = UGRGBColor(197, 160, 89);
        
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
