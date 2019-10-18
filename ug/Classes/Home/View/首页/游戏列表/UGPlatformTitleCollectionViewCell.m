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

    [self setBackgroundColor: [[UGSkinManagers shareInstance] sethomeContentColor]];
}

- (void)setItem:(GameCategoryModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    self.imageView.image = ({
        NSString *imgName = nil;
        if ([@"8" isEqualToString:item.iid]) {
            // 最新游戏
            imgName = @"最新-1";
        } else if ([@"1" isEqualToString:item.iid]) {
            // 彩票游戏
            imgName = @"cp";
        } else if ([@"2" isEqualToString:item.iid]) {
            // 真人视讯
            imgName = @"zr";
        } else if ([@"4" isEqualToString:item.iid]) {
            // 电子游戏
            imgName = @"dz";
        } else if ([@"3" isEqualToString:item.iid]) {
            // 捕鱼游戏
            imgName = @"by";
        } else if ([@"5" isEqualToString:item.iid]) {
            // 棋牌游戏
            imgName = @"qp";
        } else if ([@"6" isEqualToString:item.iid]) {
            // 体育赛事
            imgName = @"ty";
        } else {
            imgName = @"ty";
        }
        [UIImage imageNamed:imgName];
    });
    
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.textColor = [UIColor redColor];
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end
