//
//  UGFeedbackDetailCell.m
//  ug
//
//  Created by ug on 2019/7/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFeedbackDetailCell.h"
#import "UGMessageModel.h"

@interface UGFeedbackDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation UGFeedbackDetailCell

- (void)setItem:(UGMessageModel *)item {
    _item = item;
    if (self.tag == 0) {
        self.typeLabel.hidden = NO;
        if (item.type) {
            self.typeLabel.text = @"类型：投诉建议";
        }else {
            self.typeLabel.text = @"类型：建议反馈";
        }
        self.timeLabel.text = [item.createTime stringToFormatSecondDateString];
    } else {
        self.typeLabel.hidden = YES;
        self.timeLabel.text = [NSString stringWithFormat:@"提交时间:%@",[item.createTime stringToFormatSecondDateString]];
    }
    self.contentLabel.text = item.content;
}

@end
