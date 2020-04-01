//
//  UGConvertCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGConvertCollectionViewCell.h"
#import "UGMissionLevelModel.h"
@interface UGConvertCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGConvertCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.7;

    
    if (Skin1.isBlack) {
        [self.contentView setBackgroundColor:Skin1.navBarBgColor];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        self.layer.borderColor = Skin1.navBarBgColor.CGColor;
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        self.layer.borderColor = UGRGBColor(177, 188, 189).CGColor;
    }
    
}

- (void)setItem:(UGMissionLevelModel *)item {
    _item = item;
    self.titleLabel.text = item.integral;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    if (Skin1.isBlack) {
        if (selected) {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 1;
        }else {
            
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
            self.layer.borderWidth = 1;
        }
    } else {
        if (selected) {
            self.layer.borderColor = Skin1.navBarBgColor.CGColor;
            self.layer.borderWidth = 1;
        }else {
            
            self.layer.borderColor = UGRGBColor(177, 188, 189).CGColor;
            self.layer.borderWidth = 1;
        }
    }

}

@end
