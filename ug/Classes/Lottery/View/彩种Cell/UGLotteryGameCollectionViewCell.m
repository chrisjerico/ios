//
//  UGLotteryGameCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/6/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryGameCollectionViewCell.h"
#import "UGAllNextIssueListModel.h"


@interface UGLotteryGameCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *openCycleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end


@implementation UGLotteryGameCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.timeLabel.textColor = [UIColor redColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[[UGSkinManagers shareInstance] sethomeContentColor] CGColor];
}

- (void)setItem:(UGNextIssueModel *)item {
    _item = item;
    self.nameLabel.text = item.title;
    self.openCycleLabel.text = item.openCycle;
    NSString *time = [CMCommon getNowTimeWithEndTimeStr:item.curCloseTime currentTimeStr:item.serverTime];
    if (time) {
        self.timeLabel.text = time;
    } else {
        self.timeLabel.text = @"获取下一期...";
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
	[self.timeLabel setHidden:[@[@"7", @"11", @"9"] containsObject: self.item.gameId]];
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = time;
}

@end
