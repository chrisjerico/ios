//
//  UGRecordFilterCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRecordFilterCollectionViewCell.h"

@interface UGRecordFilterCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
@implementation UGRecordFilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFilterTime:(NSString *)filterTime {
    _filterTime = filterTime;
    self.titleLabel.text = filterTime;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.layer.borderColor = Skin1.navBarBgColor.CGColor;
        self.layer.borderWidth = 1;
        self.titleLabel.textColor =Skin1.navBarBgColor;
    }else {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end
