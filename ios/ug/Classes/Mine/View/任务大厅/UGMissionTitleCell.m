//
//  UGMissionTitleCell.m
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionTitleCell.h"

@interface UGMissionTitleCell ()




@end
@implementation UGMissionTitleCell

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
	if (Skin1.isBlack) {
		[self.contentView setBackgroundColor:Skin1.bgColor];
		[self.titleLabel setTextColor:Skin1.textColor1];
	} else {
		[self.contentView setBackgroundColor:[UIColor whiteColor]];
		[self.titleLabel setTextColor:[UIColor blackColor]];
	}
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		self.layer.cornerRadius = 3;
		self.layer.borderColor = [UIColor colorWithHex:0xe5e5e5].CGColor;
		self.layer.borderWidth = 1;

	}
}

- (void)setImgName:(NSString *)imgName {
	_imgName = imgName;
	self.imgView.image = [UIImage imageNamed:imgName];
}

- (void)setTitle:(NSString *)title {
	_title = title;
	self.titleLabel.text = title;
	
}

- (void)setSelected:(BOOL)selected {
	if (Skin1.isBlack) {
		if (selected) {
			self.layer.borderColor = [UIColor whiteColor].CGColor;
			self.layer.borderWidth = 1;
		}else {
			self.layer.borderColor = Skin1.navBarBgColor.CGColor;
			
		}
	} else if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		if (selected) {
			self.layer.borderWidth = 1;
			self.layer.borderColor = [UIColor colorWithHex:0x838383].CGColor;

		}else {
			self.layer.borderWidth = 1;
			self.layer.borderColor = [UIColor colorWithHex:0xe5e5e5].CGColor;

		}
	} else {
		if (selected) {
			self.layer.borderColor = Skin1.navBarBgColor.CGColor;
			self.layer.borderWidth = 1;
		}else {
			self.layer.borderColor = [UIColor whiteColor].CGColor;
			
		}
	}
	
}

@end
