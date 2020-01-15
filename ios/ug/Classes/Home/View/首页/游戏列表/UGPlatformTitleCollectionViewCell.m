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
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@end
@implementation UGPlatformTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:Skin1.homeContentColor];
    _titleLabel.textColor = Skin1.textColor1;
    _title2Label.textColor = Skin1.textColor1;
    [_title2Label setHidden:!APP.isShowLogo];
    [_imageView setHidden:!APP.isShowLogo];
    [_titleLabel setHidden:APP.isShowLogo];
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		[_titleLabel setHidden:false];
		[_title2Label setHidden:true];
		[_imageView setHidden:true];
		_titleLabel.textColor = [UIColor colorWithHex:0x111111];
		[self setBackgroundColor: [UIColor redColor]];

	}
}

- (void)setItem:(GameCategoryModel *)item {
    _item = item;
    self.titleLabel.text = item.name;
    self.title2Label.text = item.name;
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
        self.title2Label.textColor = [UIColor redColor];
    } else {
        self.titleLabel.textColor = Skin1.textColor1;
        self.title2Label.textColor = Skin1.textColor1;
    }
	
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		_titleLabel.textColor = selected ?  UIColor.redColor : [UIColor colorWithHex:0x111111];
	}
}

@end
