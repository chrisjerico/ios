//
//  JS_Sidebar.m
//  ug
//
//  Created by xionghx on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JS_Sidebar.h"
#import "UGModifyLoginPwdController.h"
#import "UGFundsViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGBetRecordViewController.h"
#import "UGMailBoxTableViewController.h"
@interface JS_Sidebar()
{
	UIView * _backDropView;
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sideButtons;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end
@implementation JS_Sidebar

+ (void)show {
	JS_Sidebar * sideBar = [[NSBundle mainBundle] loadNibNamed:@"JS_Sidebar" owner:self options:nil].firstObject;
	sideBar.frame = CGRectMake(UGScreenW, 0, 250, UGScerrnH);
	UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
	UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, UGScerrnH)];
	sideBar -> _backDropView = maskView;
	maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
	[window addSubview:maskView];
	UITapGestureRecognizer * gesture = [UITapGestureRecognizer gestureRecognizer:^(__kindof UIGestureRecognizer *gr) {
		
		[sideBar removeFromSuperview];
		[maskView removeFromSuperview];
	}];
	[maskView addGestureRecognizer:gesture];
	[window addSubview:sideBar];
	
	[sideBar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(maskView);
		make.right.equalTo(maskView);
		make.width.equalTo(@200);
	}];
	[UIView animateWithDuration:0.3 animations:^{
		[sideBar layoutIfNeeded];
	}];
	
}

- (void)awakeFromNib {
	[super awakeFromNib];
	for (UIButton * button in self.sideButtons) {
		[button addTarget:self action:@selector(sideButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
		
	}
	[self.avatarImageView sd_setImageWithURL: [NSURL URLWithString: UGUserModel.currentUser.avatar] placeholderImage: [UIImage imageNamed:@"js_sidebar_avatar_placeholder"]];
	self.userNameLabel.text = UGUserModel.currentUser.username;
	self.balanceLabel.text = [NSString stringWithFormat:@"余额: %@", UGUserModel.currentUser.balance];
}

- (void)sideButtonTaped: (UIButton *)sender {
	NSUInteger index = [self.sideButtons indexOfObject:sender];
	
	switch (index) {
		case 0:
		{
			UGFundsViewController * vc = [UGFundsViewController new];
			vc.selectIndex = 0;
			[NavController1 pushViewController:vc animated:true];
		}
			break;
		case 1:
		{
			UGFundsViewController * vc = [UGFundsViewController new];
			vc.selectIndex = 1;
			[NavController1 pushViewController:vc animated:true];
		}			break;
			
		case 2:
			[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
			break;
			
		case 3:
		{
			UGModifyLoginPwdController * vc = [[UIStoryboard storyboardWithName:@"UGSafety" bundle:nil] instantiateViewControllerWithIdentifier:@"UGModifyLoginPwdController"];
			[NavController1 pushViewController:vc animated:true];
		}
			break;
		case 4:
			[NavController1 pushViewController:[UGSecurityCenterViewController new] animated:YES];
			break;
		case 5:
			[NavController1 pushViewController:[UGBetRecordViewController new] animated:YES];
			break;
		case 6:
		{
			UGFundsViewController * vc = [UGFundsViewController new];
			vc.selectIndex = 4;
			[NavController1 pushViewController:vc animated:true];
		}
			break;
		case 8:
			[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController") animated:true];
			break;
		case 9:
			[NavController1 pushViewController:[[UGMailBoxTableViewController alloc] init] animated:true];
			break;
		case 10:
			[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
			break;
		case 11:
			//			[CMCommon goQQ:@"158691894"];
			//从系统配置中获得QQ号，==》弹窗 ==》点击调起QQ
		{
			if ([CMCommon arryIsNull:SysConf.qqs]) {
				[CMCommon showTitle:@"暂无QQ客服,敬请期待"];
				return;
			}
			NSMutableArray *titles = @[].mutableCopy;
			for (int i = 0 ;i <SysConf.qqs.count ;i++) {
				NSString *ss = [SysConf.qqs objectAtIndex:i];
				[titles addObject:[NSString stringWithFormat:@"QQ客服%d: %@",i+1,ss]];
			}
			UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择QQ客服" btnTitles:[titles arrayByAddingObject:@"取消"]];
			for (int i = 0 ;i <SysConf.qqs.count ;i++) {
				NSString *ss = [SysConf.qqs objectAtIndex:i];
				NSString *t = [NSString stringWithFormat:@"QQ客服%d: %@",i+1,ss];
				[ac setActionAtTitle:t handler:^(UIAlertAction *aa) {
					NSLog(@"ss = %@",ss);
					[CMCommon goQQ:ss];
				}];
			}
		}
			
			break;
		case 12:
			[NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
			break;
			
		case 13:
			[QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
				  if (buttonIndex) {
					  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						  [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
						  UGUserModel.currentUser = nil;
						  SANotificationEventPost(UGNotificationUserLogout, nil);
					  });
				  }
			  }];
			break;
		default:
			break;
	}
	[self dismiss];
	
}
- (void)dismiss {
	[self removeFromSuperview];
	[_backDropView removeFromSuperview];
}
@end
