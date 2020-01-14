//
//  HSC_MineVC.m
//  ug
//
//  Created by xionghx on 2020/1/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HSC_MineVC.h"
#import "UGFundsViewController.h"

@interface HSC_MineVC ()
@property (weak, nonatomic) IBOutlet UIView *headTopBackDropView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (nonatomic, strong)NSArray * items;
@end

@implementation HSC_MineVC

- (void)viewDidLoad {
	[super viewDidLoad];
	self.headTopBackDropView.backgroundColor = Skin1.navBarBgColor;
	[self getUserInfo];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	FastSubViewCode(cell);
	UGUserCenterItem *uci = tableView.dataArray[indexPath.row];
	subLabel(@"标题Label").text = uci.name;
	[subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:uci.logo] placeholderImage:[UIImage imageNamed:uci.lhImgName]];
	subLabel(@"红点Label").text = @([UGUserModel currentUser].unreadMsg).stringValue;
	subLabel(@"红点Label").hidden = !(uci.code==UCI_站内信 && [UGUserModel currentUser].unreadMsg);
	return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UGUserCenterItem *uci = tableView.dataArray[indexPath.row];
	[NavController1 pushVCWithUserCenterItemType:uci.code];
}


- (IBAction)logoutButtonTaped:(id)sender {
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
	//    //提现
	UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
	fundsVC.selectIndex = 1;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)rechargeButtonTaped:(id)sender {
	//    //存款
	UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
	fundsVC.selectIndex = 0;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)accountDetailButtonTaped:(id)sender {
}
- (IBAction)rechargeRecordButtonTaped:(id)sender {
}
- (IBAction)withDrawRecordButtonTaped:(id)sender {
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
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
	[CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			UGUserModel *user = model.data;
			UGUserModel *oldUser = [UGUserModel currentUser];
			user.sessid = oldUser.sessid;
			user.token = oldUser.token;
			UGUserModel.currentUser = user;
			
			[self getSystemConfig];
		} failure:^(id msg) {
			[self stopAnimation];
		}];
	}];
}

- (void)getSystemConfig {
	
	[CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			UGSystemConfigModel *config = model.data;
			UGSystemConfigModel.currentConfig = config;
			[self setupUserInfo];
			[self stopAnimation];
			SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
		} failure:^(id msg) {
			[SVProgressHUD dismiss];
		}];
	}];
}
-(void)setupUserInfo {
	
}
@end
