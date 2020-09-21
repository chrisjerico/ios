//
//  UGLotteryTicketCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryCollectionViewCell.h"
#import "UGAllNextIssueListModel.h"

@interface UGLotteryCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lotteryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation UGLotteryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.timeLabel.textColor = [UIColor redColor];
    
}

- (void)setItem:(UGNextIssueModel *)item {
    _item = item;
    self.lotteryNameLabel.text = item.title;
//    self.imageView.image = [UIImage imageNamed:item.imgName];
    self.countLabel.text = [NSString stringWithFormat:@"全天%@期",item.totalNum];
    NSString *time = [CMCommon getNowTimeWithEndTimeStr:item.curCloseTime currentTimeStr:item.serverTime];
    if (time) {
        self.timeLabel.text = time;
        
    }else {
        self.timeLabel.text = @"获取下一期";
    }
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = time;
}

@end
