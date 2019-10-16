//
//  UGMissionLevelTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionLevelTableViewCell.h"
#import "UGlevelsModel.h"

@interface UGMissionLevelTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *levelsImager;
@property (weak, nonatomic) IBOutlet UILabel *levelsLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UIView *levelsView;
@property (weak, nonatomic) IBOutlet UILabel *levelsSectionLabel;

@end
@implementation UGMissionLevelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
      [self setBackgroundColor: [UIColor whiteColor]];
}

- (void)setItem:(UGlevelsModel *)item {
    _item = item;
    self.levelsLabel.text = item.levelName;
    self.levelTitleLabel.text = item.levelTitle;
    self.integralLabel.text = item.integral;
    self.levelsSectionLabel.text = item.levelName;
    [self.levelsSectionLabel setHidden:NO];
}

- (void)setSectionBgColor:(UIColor *)bgColor levelsSectionStr:(NSString *)levelsSectionStr{
    [self setBackgroundColor:bgColor];
    [self.levelTitleLabel setBackgroundColor:bgColor];
    [self.integralLabel setBackgroundColor:bgColor];
    [self.levelsSectionLabel setBackgroundColor:bgColor];
    [self.levelsSectionLabel setHidden:NO];
    self.levelsSectionLabel.text = levelsSectionStr;
    [self.levelsView setHidden:YES];
}

@end
