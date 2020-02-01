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
    self.titleLabel.font = selected ? [UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
    if (Skin1.isBlack) {
        self.titleLabel.textColor = selected ? [UIColor whiteColor] : RGBA(159, 166, 173, 1);
    } else {
        UIColor *selectedColor = APP.betBgIsWhite ? Skin1.navBarBgColor : [UIColor whiteColor];
        if ([@"c085" containsString:APP.SiteId]) {
            selectedColor = [UIColor blueColor];
        }
        self.titleLabel.textColor = selected ? selectedColor : [UIColor blackColor];
    }
}

@end
