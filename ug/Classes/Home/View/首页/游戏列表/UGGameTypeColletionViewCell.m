//
//  UGGameTypeColletionViewCell.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameTypeColletionViewCell.h"
#import "UGPlatformGameModel.h"
//#import <SDWebImage/FLAnimatedImageView+WebCache.h>

@interface UGGameTypeColletionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (nonatomic, strong)UIImageView *hasSubSign;

@end
@implementation UGGameTypeColletionViewCell

-(void)skin{
    self.layer.borderColor = Skin1.homeContentBorderColor.CGColor;
     [self setBackgroundColor: Skin1.cellBgColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor: Skin1.cellBgColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = Skin1.homeContentBorderColor.CGColor;
    self.layer.borderWidth = 1;
    self.hotImageView.hidden = YES;
	[self addSubview:self.hasSubSign];
	[self.hasSubSign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.right.equalTo(self);
	}];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.nameLabel.text = title;
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:imgName];
}

- (void)setItem:(GameModel *)item {
    _item = item;
	self.nameLabel.text = [item.name length] > 0 ? item.name : item.title;
	[self.hasSubSign setHidden: (item.subType.count > 0 ? false : true)];

    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
	
    if ([item.tipFlag isEqualToString:@"1"]) {
         self.hotImageView.hidden = NO;
    } else {
         self.hotImageView.hidden = YES;
    }
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
