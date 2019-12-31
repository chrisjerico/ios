//
//  UGSegmentCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/7/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSegmentCollectionViewCell.h"

@interface UGSegmentCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGSegmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self selectTextColor:self.selected];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    [self selectTextColor:selected];
}

-(void)selectTextColor:(BOOL)selected{
    if (Skin1.isBlack) {
        self.titleLabel.textColor = selected ? [UIColor whiteColor] : RGBA(159, 166, 173, 1);
    } else {
        self.titleLabel.textColor = selected ? Skin1.navBarBgColor : [UIColor blackColor];
    }
}

@end
