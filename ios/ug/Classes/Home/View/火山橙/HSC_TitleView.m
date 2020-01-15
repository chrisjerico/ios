//
//  HSC_TitleView.m
//  ug
//
//  Created by xionghx on 2020/1/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HSC_TitleView.h"
@interface HSC_TitleView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalWidth;

@end
@implementation HSC_TitleView

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.totalWidth.constant = APP.Width;
	if (UGLoginIsAuthorized()) {
		[self.loginButton setHidden:true];
		[self.registButton setHidden:true];
		[self.userButton setHidden:false];
		[self.mailButton setHidden:false];
		[self.balanceLabel setHidden:false];
		self.balanceLabel.text = [UGUserModel currentUser].balance;
		[self.mailButton setSelected:[UGUserModel currentUser].unreadMsg > 0];
		self.userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	} else {
		[self.loginButton setHidden:false];
		[self.registButton setHidden:false];
		[self.userButton setHidden:true];
		[self.mailButton setHidden:true];
		[self.balanceLabel setHidden:true];

	}
	// 登录成功
	WeakSelf;
	SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
		[weakSelf.loginButton setHidden:true];
		[weakSelf.registButton setHidden:true];
		[weakSelf.userButton setHidden:false];
		[weakSelf.mailButton setHidden:false];
		[self.balanceLabel setHidden:false];

	});
	//退出登录
	SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
		[weakSelf.loginButton setHidden:false];
		[weakSelf.registButton setHidden:false];
		[weakSelf.userButton setHidden:true];
		[weakSelf.mailButton setHidden:true];
		[self.balanceLabel setHidden:true];

	});
	//用户信息更新
	SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
		[weakSelf.userButton setTitle:[UGUserModel currentUser].balance forState:UIControlStateNormal];
		weakSelf.balanceLabel.text = [UGUserModel currentUser].balance;
		[weakSelf.mailButton setSelected:[UGUserModel currentUser].unreadMsg > 0];

	});
	
}
- (IBAction)loginButtonTaped:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(loginButtonTaped)]) {
		[self.delegate loginButtonTaped];
	}
}
- (IBAction)registButtonTaped:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(registButtonnTaped)]) {
		[self.delegate registButtonnTaped];
	}
}
- (IBAction)avatarButtonTaped:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(avatarButtonTaped)]) {
		[self.delegate avatarButtonTaped];
	}
}

- (IBAction)emailButtonTaped:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(emailButtonTaped)]) {
		[self.delegate emailButtonTaped];
	}
}

@end
