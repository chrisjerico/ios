//
//  JS_HomePromoteView.m
//  ug
//
//  Created by xionghx on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JS_HomePromoteView.h"
@interface JS_HomePromoteView()
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIImageView *promoteSign;
@property (weak, nonatomic) IBOutlet UILabel *userNubersLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIButton *handelButton;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (nonatomic, strong)  GameModel* model;
@end
@implementation JS_HomePromoteView

- (void)bind: (GameModel *)item {
	
	[self.itemImage sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage: [UIImage imageNamed:@""]];
	self.itemLabel.text = item.title.length > 0 ? item.title : item.name;
	self.describeLabel.text = item.title.length > 0 ? item.title : item.name;
	self.userNubersLabel.text = [NSString stringWithFormat:@"%ld人在玩", random()%2000 + 9000];
	
	NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@"⭐️⭐️⭐️⭐️⭐️"];
	NSMutableAttributedString * number = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", random()%2000 + 9000]];
	[number setColor:UIColor.redColor];
	[attributedString appendAttributedString:number];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"人在玩"]];
	[attributedString setFont: [UIFont systemFontOfSize:12]];
	
	self.userNubersLabel.attributedText = attributedString;
	self.model = item;
}


- (IBAction)handleButtonTaped:(id)sender {
	[NavController1 pushViewControllerWithGameModel:_model];
}


@end
