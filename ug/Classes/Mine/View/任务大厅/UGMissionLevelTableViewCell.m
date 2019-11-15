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
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.levelsLabel setTextColor: Skin1.textColor1];
        [self setBackgroundColor: Skin1.bgColor];
        [self.levelTitleLabel setTextColor: Skin1.textColor1];
        [self.integralLabel setTextColor: Skin1.textColor1];
        [self.levelsSectionLabel setTextColor: Skin1.textColor1];
    } else {
        [self.levelsLabel setTextColor: [UIColor blackColor]];
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.levelTitleLabel setTextColor: [UIColor blackColor]];
        [self.integralLabel setTextColor: [UIColor blackColor]];
        [self.levelsSectionLabel setTextColor: [UIColor blackColor]];
    }

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
