//
//  UGMissionLevelTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionLevelTableViewCell.h"
#import "UGMissionLevelModel.h"

@interface UGMissionLevelTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *VIPView;

@end
@implementation UGMissionLevelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShowVIPView:(BOOL)showVIPView {
    _showVIPView = showVIPView;
    
    self.VIPView.hidden = !showVIPView;
    if (showVIPView) {
        self.levelLabel.textColor = [UIColor grayColor];
        self.levelNameLabel.textColor = [UIColor grayColor];
        self.integralLabel.textColor = [UIColor grayColor];
        self.amountLabel.textColor = [UIColor grayColor];
    }else {
        self.levelLabel.textColor = [UIColor blackColor];
        self.levelNameLabel.textColor = [UIColor blackColor];
        self.integralLabel.textColor = [UIColor blackColor];
        self.amountLabel.textColor = [UIColor blackColor];
        
    }
}

- (void)setItem:(UGMissionLevelModel *)item {
    _item = item;
    self.levelLabel.text = item.levelName;
    self.levelNameLabel.text = item.levelTitle;
    self.integralLabel.text = item.integral;
    self.amountLabel.text = item.amount;
    
    if (item.level == 1) {
        self.levelImageView.image = [UIImage imageNamed:@"VIP1.c9922627"];
    }else if (item.level == 2) {
        self.levelImageView.image = [UIImage imageNamed:@"VIP2.ec01ea3e"];
    }else if (item.level == 3) {
        self.levelImageView.image = [UIImage imageNamed:@"VIP3.34187a4f"];
    }else {
        self.levelImageView.image = [UIImage imageNamed:@"VIP4.840a7619"];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
