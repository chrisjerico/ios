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
	self.itemLabel.text = item.title;
	self.describeLabel.text = item.title;
	self.model = item;
}


- (IBAction)handleButtonTaped:(id)sender {
	[NavController1 pushViewControllerWithGameModel:_model];
}


@end
