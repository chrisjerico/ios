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
    self.layer.borderColor = UGRGBColor(177, 188, 189).CGColor;
    
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
    if (selected) {
        self.layer.borderColor = UGNavColor.CGColor;
        self.layer.borderWidth = 1;
    }else {
        
        self.layer.borderColor = UGRGBColor(177, 188, 189).CGColor;
        self.layer.borderWidth = 1;
    }
}

@end
