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
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView; /**<   热门ImageView */
@property (nonatomic, strong) UIImageView *hasSubSign;          /**<   二级目录ImageView */

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
    
    
    
}

- (void)setItem:(GameModel *)item {
    _item = item;
   
	self.nameLabel.text =  [CMCommon stringIsNull:item.name] ? item.title : item.title;
	[self.hasSubSign setHidden: (item.subType.count > 0 ? false : true)];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    __weakSelf_(__self);
    [self.hotImageView sd_setImageWithURL:[NSURL URLWithString:item.hotIcon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            __self.hotImageView.image = [UIImage imageNamed:@"hot"];
        }
    }];
    
    FastSubViewCode(self);
    BOOL isBlack = Skin1.isBlack;
    _hotImageView.hidden = isBlack || !item.tipFlag;
    subImageView(@"活动ImageView").hidden = !(isBlack && item.tipFlag==2);
    subButton(@"热Button").superview.hidden = !(isBlack && item.tipFlag==1);
    subButton(@"大奖Button").superview.hidden = !(isBlack && item.tipFlag==3);
}

- (void)setSubitem:(GameSubModel *)subitem {
    _subitem = subitem;
   
    self.nameLabel.text =  [CMCommon stringIsNull:subitem.name] ? subitem.title : subitem.title;
    NSLog(@"self.nameLabel. = %@",self.nameLabel.text);
    NSLog(@"subitem = %@",subitem);
//    [self.hasSubSign setHidden: (subitem.subType.count > 0 ? false : true)];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:subitem.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    __weakSelf_(__self);
    [self.hotImageView sd_setImageWithURL:[NSURL URLWithString:subitem.hotIcon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            __self.hotImageView.image = [UIImage imageNamed:@"hot"];
        }
    }];
    
    FastSubViewCode(self);
    BOOL isBlack = Skin1.isBlack;
    _hotImageView.hidden = isBlack || !subitem.tipFlag;
    subImageView(@"活动ImageView").hidden = !(isBlack && subitem.tipFlag==2);
    subButton(@"热Button").superview.hidden = !(isBlack && subitem.tipFlag==1);
    subButton(@"大奖Button").superview.hidden = !(isBlack && subitem.tipFlag==3);
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
