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
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.textColor = Skin1.navBarBgColor;
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end
