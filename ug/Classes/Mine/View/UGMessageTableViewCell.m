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
      [self setBackgroundColor: [[UGSkinManagers shareInstance] setCellbgColor]];
}

- (void)setItem:(UGMessageModel *)item {
    _item = item;
    self.titleLabel.text = item.title;
    self.timeLabel.text = item.updateTime;
    if (item.isRead) {
        
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.textColor = [UIColor lightGrayColor];
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = [UIColor blackColor];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
