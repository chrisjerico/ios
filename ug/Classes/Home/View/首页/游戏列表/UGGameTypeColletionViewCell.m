//
//  UGGameTypeColletionViewCell.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameTypeColletionViewCell.h"
#import "UGPlatformGameModel.h"
#import "FLAnimatedImageView.h"
//#import <SDWebImage/FLAnimatedImageView+WebCache.h>

@interface UGGameTypeColletionViewCell ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgView;      /**<   图片ImageView */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        /**<   标题ImageView */
@property (weak, nonatomic) IBOutlet UILabel *name2Label;        /**<   标题ImageView */
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView; /**<   热门ImageView */
@property (nonatomic, strong) UIImageView *hasSubSign;          /**<   二级目录ImageView */
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *effImgView;/**<   烟花背景gif */

@end

@implementation UGGameTypeColletionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = Skin1.isBlack ? Skin1.bgColor : Skin1.homeContentColor;
    self.nameLabel.textColor = Skin1.textColor1;
    self.hotImageView.hidden = YES;
    
    if (!Skin1.isJY) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    if (APP.isWhite) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    
    
	[self addSubview:self.hasSubSign];
	[self.hasSubSign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.right.equalTo(self);
	}];
    
    // 一闪一闪的动画效果
    FastSubViewCode(self);
    __weakSelf_(__self);
    __block NSInteger __i = 0;
    __block NSTimer *__timer = [NSTimer scheduledTimerWithInterval:0.27 repeats:true block:^(NSTimer *timer) {
        __i++;
        subImageView(@"活动ImageView").y += __i%2 ? 2 : -2;
        subButton(@"热Button").selected = !(__i%6);
        subButton(@"大奖Button").selected = !(__i%6);
        if (__i > 1000000) {
            __i = 0;
        }
        if (!__self) {
            [__timer invalidate];
            __timer = nil;
        }
    }];
    
    
//    if (APP.isFireworks) {
//        [_effImgView setHidden:NO];
//        _effImgView.contentMode = UIViewContentModeScaleAspectFit;
//        _effImgView.userInteractionEnabled = true;
//        [_effImgView sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"effects" withExtension:@"gif"]];
//    }
//


    
    
    
}

- (void)setItem:(GameModel *)item {
    _item = item;
   
	self.nameLabel.text =  [CMCommon stringIsNull:item.name] ? item.title : item.name;
    self.name2Label.text =  [CMCommon stringIsNull:item.subtitle] ? @"" : item.subtitle;
	[self.hasSubSign setHidden: (item.subType.count > 0 ? false : true)];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    __weakSelf_(__self);
    [self.hotImageView sd_setImageWithURL:[NSURL URLWithString:item.hotIcon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            __self.hotImageView.image = [UIImage imageNamed:@"hot"];
        }
    }];
    
    [self.effImgView sd_setImageWithURL:[NSURL URLWithString:item.hotIcon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            [__self.effImgView sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"effects" withExtension:@"gif"]];
        }
    }];
    
    FastSubViewCode(self);
    BOOL isBlack = Skin1.isBlack;
    _hotImageView.hidden = isBlack || !item.tipFlag;
    subImageView(@"活动ImageView").hidden = !(isBlack && item.tipFlag==2);
    subButton(@"热Button").superview.hidden = !(isBlack && item.tipFlag==1);
    subButton(@"大奖Button").superview.hidden = !(isBlack && item.tipFlag==3);

    _effImgView.hidden = !(item.tipFlag==4);
}



- (UIImageView *)hasSubSign {
	if (!_hasSubSign) {
		_hasSubSign = [UIImageView new];
		_hasSubSign.image = [UIImage imageNamed:@"game_has_sub"];
		_hasSubSign.backgroundColor = [UIColor clearColor];
	}
	return _hasSubSign;
}

@end
