//
//  JS_TitleView.m
//  ug
//
//  Created by xionghx on 2020/1/9.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JS_TitleView.h"
@interface JS_TitleView()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *useInfoView;


@end
@implementation JS_TitleView

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}
- (void)awakeFromNib {
	[super awakeFromNib];
	if (UGLoginIsAuthorized()) {
		[self.useInfoView setHidden:false];
		[self.loginView setHidden:true];
	} else {
		[self.useInfoView setHidden:true];
		[self.loginView setHidden:false];
	}
	// 登录成功
	WeakSelf
	SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
		[weakSelf.useInfoView setHidden:false];
		[weakSelf.loginView setHidden:true];
		
	});
	//退出登录
	SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
		[weakSelf.useInfoView setHidden:true];
		[weakSelf.loginView setHidden:false];
	});
}

- (IBAction)loginButtonTaped:(id)sender {
    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
}
- (IBAction)registButtonTaped:(id)sender {
    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGRegisterViewController") animated:YES];
}
- (IBAction)moreButtonTaped:(id)sender {
    [JS_Sidebar show];
}

@end
