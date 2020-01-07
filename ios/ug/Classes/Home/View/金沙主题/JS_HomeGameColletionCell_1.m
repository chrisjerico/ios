//
//  JS_HomeGameColletionCell_1.m
//  ug
//
//  Created by xionghx on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JS_HomeGameColletionCell_1.h"
#import "JS_HomePromoteView.h"
@interface JS_HomeGameColletionCell_1()
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNuberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end
@implementation JS_HomeGameColletionCell_1

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)bind: (GameModel *)item {
	
	[self.itemImage sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage: [UIImage imageNamed:@""]];
	self.titleLabel.text = item.title;
	self.descriptionLabel.text = item.title;
}

@end
