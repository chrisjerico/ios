//
//  UGPlatformTitleCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformTitleCollectionViewCell.h"
#import "UGPlatformGameModel.h"

@interface UGPlatformTitleCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation UGPlatformTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(GameCategoryModel *)item {
    _item = item;
    self.titleLabel.text = item.title;
    if ([@"lottery" isEqualToString:item.alias]) {
        self.imageView.image = [UIImage imageNamed:@"cp"];
    }else if ([@"real" isEqualToString:item.alias]) {
        self.imageView.image = [UIImage imageNamed:@"zr"];
    }else if ([@"game" isEqualToString:item.alias]) {
        self.imageView.image = [UIImage imageNamed:@"dz"];
    }else if ([@"fish" isEqualToString:item.alias]) {
        self.imageView.image = [UIImage imageNamed:@"by"];
    }else if ([@"card" isEqualToString:item.alias]) {
        self.imageView.image = [UIImage imageNamed:@"qp"];
    }else {
        self.imageView.image = [UIImage imageNamed:@"ty"];
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.textColor = [UIColor redColor];
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end
