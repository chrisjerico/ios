//
//  JS_HomePromoteContainerView.m
//  ug
//
//  Created by xionghx on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JS_HomePromoteContainerView.h"
#import "JS_HomePromoteView.h"

@interface JS_HomePromoteContainerView()
@property(nonatomic, strong)NSArray<JS_HomePromoteView*> * promots;

@end
@implementation JS_HomePromoteContainerView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
	self.promots = @[[[NSBundle mainBundle] loadNibNamed:@"JS_HomePromoteView" owner:self options:nil].firstObject,
					 [[NSBundle mainBundle] loadNibNamed:@"JS_HomePromoteView" owner:self options:nil].firstObject];
	UIView * temp;
	for (JS_HomePromoteView * promot in self.promots) {
		[self addSubview:promot];
		[promot mas_makeConstraints:^(MASConstraintMaker *make) {
			if (temp) {
				make.top.equalTo(temp.mas_bottom).offset(1);
			} else {
				make.top.equalTo(self).offset(1);
			}
			make.left.right.equalTo(self);
			make.height.equalTo(@80);
		}];
		temp = promot;
	}
}

- (void)bind: (NSArray<GameModel *> *)items {
	
	for (JS_HomePromoteView * promot in self.promots) {
		[promot removeFromSuperview];
	}
	
	NSMutableArray * promots = [NSMutableArray array];
	UIView * temp;
	
	for (NSInteger i = 0; i < items.count; i ++) {
		[self.promots[i] bind:items[i]];
		JS_HomePromoteView * promot = [[NSBundle mainBundle] loadNibNamed:@"JS_HomePromoteView" owner:self options:nil].firstObject;
		[promot bind:items[i]];
		[promots appendObject:promot];
		[self addSubview:promot];
		
		[promot mas_makeConstraints:^(MASConstraintMaker *make) {
			if (temp) {
				make.top.equalTo(temp.mas_bottom).offset(1);
			} else {
				make.top.equalTo(self).offset(1);
			}
			make.left.right.equalTo(self);
			make.height.equalTo(@80);
		}];
		temp = promot;
		if (i == 1) {
			break;
		}
	}
	self.promots = promots.copy;
	
}

@end
