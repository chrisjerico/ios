//
//  JS_HomeGameCollectionCell.m
//  ug
//
//  Created by xionghx on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JS_HomeGameCollectionCell.h"
@interface JS_HomeGameCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *cornerImage;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;

@end
@implementation JS_HomeGameCollectionCell

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
}
- (void)bind: (GameModel *)item {
	
	[self.itemImage sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage: [UIImage imageNamed:@""]];
	self.itemName.text = item.title;
	
	switch (item.tipFlag) {
		case 0:
			self.cornerImage.image = [UIImage imageNamed:@""];
			break;
		case 1:
			self.cornerImage.image = [UIImage imageNamed:@"theme_jinsha_gamecel_hot"];
			break;
		case 2:
			self.cornerImage.image = [UIImage imageNamed:@"theme_js_gamecell_新"];
			break;
		case 3:
			self.cornerImage.image = [UIImage imageNamed:@"theme_jinsha_gamecell_bao"];
			break;
		default:
			break;
	}
}
@end
