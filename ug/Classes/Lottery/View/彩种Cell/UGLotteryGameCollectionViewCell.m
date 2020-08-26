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
    self.timeLabel.textColor = [UIColor redColor];
    self.nameLabel.textColor = Skin1.textColor1;
    
    self.clipsToBounds = false;
    self.layer.cornerRadius = 10;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.1;
    
    if (APP.isTitleWhite) {
        [self.openCycleLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)setItem:(UGNextIssueModel *)item {
    _item = item;
    self.nameLabel.text = item.title;
    self.openCycleLabel.text = item.openCycle;
    NSString *time = [CMCommon getNowTimeWithEndTimeStr:item.curCloseTime currentTimeStr:item.serverTime];
    if (time) {
        self.timeLabel.text = time;
    } else {
        self.timeLabel.text = @"获取下一期";
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
	[self.timeLabel setHidden:item.isInstant];
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = time;
}

@end
