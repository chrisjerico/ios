//
//  HSC_MineVC.m
//  ug
//
//  Created by xionghx on 2020/1/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HSC_MineVC.h"
#import "UGFundsViewController.h"
#import "UGMenuTableViewCell.h"

@interface HSC_MineVC ()
@property (weak, nonatomic) IBOutlet UIView *headTopBackDropView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong)NSArray<UGUserCenterItem *> * items;
@end
@implementation HSC_MineVC
- (BOOL)允许未登录访问 { return false; }
- (BOOL)允许游客访问 { return true; }
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)awakeFromNib {
	[super awakeFromNib];

	[self.tableView registerNib:[UINib nibWithNibName:@"UGMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGMenuTableViewCell"];
	self.items = SysConf.userCenter.copy;
	[self.tableView reloadData];

}
- (void)viewDidLoad {
	[super viewDidLoad];
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
	}
	self.headTopBackDropView.backgroundColor = Skin1.navBarBgColor;
	
	WeakSelf;
	SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
		weakSelf.items = SysConf.userCenter.copy;
		[weakSelf.tableView reloadData];
	});
	[self setupUserInfo];
	[self getUserInfo];
    
    // 登录成功
    SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
        [weakSelf setupUserInfo];

    });

    //用户信息更新
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [weakSelf setupUserInfo];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UGMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGMenuTableViewCell" forIndexPath:indexPath];
	UGUserCenterItem *uci = self.items[indexPath.row];
	cell.imgName = uci.lhImgName;
	cell.title = uci.name;
	return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UGUserCenterItem *uci = self.items[indexPath.row];
	[NavController1 pushVCWithUserCenterItemType:uci.code];
}


- (IBAction)logoutButtonTaped:(id)sender {
	[QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
		if (buttonIndex) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
				UGUserModel.currentUser = nil;
				SANotificationEventPost(UGNotificationUserLogout, nil);
			});
		}
	}];
}
- (IBAction)balanceRefreshButtonTaped:(id)sender {
	[self getUserInfo];
	
	if (sender) {
		__weakSelf_(__self);
		[CMNetwork needToTransferOutWithParams:@{@"token":UserI.token} completion:^(CMResult<id> *model, NSError *err) {
			BOOL needToTransferOut = [model.data[@"needToTransferOut"] boolValue];
			if (needToTransferOut) {
				UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"真人游戏正在进行或有余额未成功转出，请确认是否需要转出游戏余额" btnTitles:@[@"取消", @"确认"]];
				[ac setActionAtTitle:@"确认" handler:^(UIAlertAction *aa) {
					[CMNetwork autoTransferOutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
						if (!err) {
							[SVProgressHUD showSuccessWithStatus:@"转出成功"];
							[__self getUserInfo];
						}
					}];
				}];
			}
		}];
	}
}
- (IBAction)withDrawButtonTaped:(id)sender {
	//  提现
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	fundsVC.selectIndex = 1;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)rechargeButtonTaped:(id)sender {
	//  存款
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	fundsVC.selectIndex = 0;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)accountDetailButtonTaped:(id)sender {
	//  存款
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	fundsVC.selectIndex = 4;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)rechargeRecordButtonTaped:(id)sender {
	//  存款记录
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	fundsVC.selectIndex = 2;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)withDrawRecordButtonTaped:(id)sender {
	// 取款记录
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	fundsVC.selectIndex = 3;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)transferButtonTaped:(id)sender {
	//转换
	[self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController") animated:YES];
}

//刷新余额动画
- (void)startAnimation {
	CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
	ReFreshAnimation.duration = 1;
	ReFreshAnimation.repeatCount = HUGE_VALF;
	[self.refreshButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

//刷新余额动画
- (void)stopAnimation {
	[self.refreshButton.layer removeAllAnimations];
}


- (void)getUserInfo {
	[self startAnimation];
	WeakSelf;
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
	[CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			UGUserModel *user = model.data;
			UGUserModel *oldUser = [UGUserModel currentUser];
			user.sessid = oldUser.sessid;
			user.token = oldUser.token;
			UGUserModel.currentUser = user;
			[weakSelf getSystemConfig];
		} failure:^(id msg) {
			[weakSelf stopAnimation];
		}];
	}];
}

- (void)getSystemConfig {
	WeakSelf;
	[CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			UGSystemConfigModel *config = model.data;
			UGSystemConfigModel.currentConfig = config;
			[weakSelf setupUserInfo];
			[weakSelf stopAnimation];
			SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
		} failure:^(id msg) {
			[SVProgressHUD dismiss];
		}];
	}];
}
-(void)setupUserInfo {
	
	self.userNameLabel.text = [UGUserModel currentUser].username;
	[self.avatarImageView sd_setImageWithURL: [NSURL URLWithString: UGUserModel.currentUser.avatar] placeholderImage: [UIImage imageNamed:@"js_sidebar_avatar_placeholder"]];
	self.balanceLabel.text = [UGUserModel currentUser].balance;
}
@end
