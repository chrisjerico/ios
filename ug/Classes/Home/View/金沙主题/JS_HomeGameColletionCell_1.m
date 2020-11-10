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
    FastSubViewCode(self);
    [subView(@"图片View") setHidden:YES];
	[self.itemImage sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage: [UIImage imageNamed:@""]];
	self.titleLabel.text = item.title.length > 0 ? item.title : item.name;
	self.descriptionLabel.text = item.title.length > 0 ? item.title : item.name;

	NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@"⭐️⭐️⭐️⭐️⭐️"];
	NSMutableAttributedString * number = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", random()%2000 + 9000]];
	[number setColor:UIColor.redColor];
	[attributedString appendAttributedString:number];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"人在玩"]];
	[attributedString setFont: [UIFont systemFontOfSize:12]];
	
	self.playerNuberLabel.attributedText = attributedString;
}


- (void)bind2: (GameModel *)item{
    FastSubViewCode(self);
    [subView(@"图片View") setHidden:NO];
    //设置圆角边框
    subView(@"iconbgView").layer.cornerRadius = 5;
    subView(@"iconbgView").layer.masksToBounds = YES;
      //设置边框及边框颜色
    subView(@"iconbgView").layer.borderWidth = 1;
    subView(@"iconbgView").layer.borderColor =[[UIColor colorWithHex:0xf2f2f2] CGColor];
    
    [self.itemImage sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage: [UIImage imageNamed:@""]];
    
    self.titleLabel.text = item.title.length > 0 ? item.title : item.name;
    self.descriptionLabel.text = item.subtitle.length > 0 ? item.subtitle :item.name ;

    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@"⭐️⭐️⭐️⭐️⭐️"];
    NSMutableAttributedString * number = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", random()%2000 + 9000]];
    [number setColor:UIColor.redColor];
    [attributedString appendAttributedString:number];
    [attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"人在玩"]];
    [attributedString setFont: [UIFont systemFontOfSize:12]];
    
    self.playerNuberLabel.attributedText = attributedString;
}

@end
