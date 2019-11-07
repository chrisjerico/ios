//
//  UGFeedbackTableViewCell.m
//  ug
//
//  Created by ug on 2019/7/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFeedbackTableViewCell.h"
#import "UGMessageModel.h"
@interface UGFeedbackTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation UGFeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:Skin1.textColor4];
    [self.typeLabel setTextColor:Skin1.textColor1];
    [self.statusLabel setTextColor:Skin1.textColor1];
    [self.contentLabel setTextColor:Skin1.textColor1];
}

- (void)setItem:(UGMessageModel *)item {
    _item = item;
    if (item.type == 0) {
        self.typeLabel.text = @"建议反馈";
    }else {
        self.typeLabel.text = @"投诉建议";
    }
    if (item.status == 0) {
        self.statusLabel.text = @"待回复";
    }else {
        self.statusLabel.text = @"已回复";
    }
    self.contentLabel.text = item.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
