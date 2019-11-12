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
    // Initialization code
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.contentView setBackgroundColor: Skin1.bgColor];
         self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        [self.contentView setBackgroundColor: [UIColor whiteColor]];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
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
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        if (selected) {
            self.titleLabel.textColor = [UIColor whiteColor];
        }else {
            self.titleLabel.textColor = RGBA(159, 166, 173, 1);
        }
    } else {
        if (selected) {
            self.titleLabel.textColor = Skin1.navBarBgColor;
        }else {
            self.titleLabel.textColor = [UIColor blackColor];
        }
    }
}

@end
