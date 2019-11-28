//
//  UGMenuTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMenuTableViewCell.h"

@interface UGMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
@implementation UGMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor: Skin1.cellBgColor];

}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:imgName];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    if ([@"站内信" isEqualToString:title]) {
        self.numLabel.hidden = NO;
        
    }else {
        self.numLabel.hidden = YES;
    }
}

- (void)setUnreadMsg:(NSInteger)unreadMsg {
    _unreadMsg = unreadMsg;
    self.numLabel.hidden = unreadMsg;
    self.numLabel.text = @(unreadMsg).stringValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
