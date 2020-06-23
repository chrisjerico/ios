//
//  UGMessageTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMessageTableViewCell.h"
#import "UGMessageModel.h"

@interface UGMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
@implementation UGMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(UGMessageModel *)item {
    _item = item;
    self.titleLabel.text = item.title;
    self.timeLabel.text = item.updateTime;
    if (item.isRead) {
        self.titleLabel.textColor = Skin1.textColor3;
        self.timeLabel.textColor = Skin1.textColor3;
    } else {
        self.titleLabel.textColor = Skin1.textColor1;
        self.timeLabel.textColor = Skin1.textColor1;
    }
}

@end
