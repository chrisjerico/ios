//
//  JS_MineVC.m
//  ug
//
//  Created by xionghx on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JS_MineVC.h"
#import "UGMineMenuCollectionViewCell.h"
#import "UGMineSkinCollectionViewCell.h"
#import "UGMineSkinFirstCollectionHeadView.h"
#import "UGSkinSeconCollectionHeadView.h"
#import "UGMineSkinModel.h"
#import "UGAvaterSelectView.h"
#import "UGMissionCenterViewController.h"
#import "UGSigInCodeViewController.h"

#import "UGFundsViewController.h"
#import "SLWebViewController.h"
#import "UGSystemConfigModel.h"
#import "UGBalanceConversionController.h"
#import "UGBankCardInfoController.h"
#import "UGPromotionIncomeController.h"
#import "UGBindCardViewController.h"
#import "UGSetupPayPwdController.h"
#import "UGYubaoViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGBetRecordViewController.h"
#import "UGRealBetRecordViewController.h"

#import "UGFeedBackController.h"
#import "UGMosaicGoldViewController.h"
#import "UGagentApplyInfo.h"
#import "UGAgentViewController.h"
#import "UGAgentViewController.h"
#import "UGChangLongController.h"
#import "STBarButtonItem.h"
#import "UGYYRightMenuView.h"
@interface JS_MineVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionnView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel2;
//===================================================
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moenyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fristVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondVipLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;  /**<   进度条 */
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIView *headerBackDropView;

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *containerLayer;

@property (nonatomic, strong) NSMutableArray <UGUserCenterItem *>*menuNameArray;        /**<   行数据 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@end

@implementation JS_MineVC
- (BOOL)允许未登录访问 { return false; }
- (BOOL)允许游客访问 { return true; }
- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"我的";
	self.headerBackDropView.backgroundColor = Skin1.navBarBgColor;
	self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
	self.headImageView.layer.masksToBounds = YES;
	self.headImageView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvaterSelectView)];
	[self.headImageView addGestureRecognizer:tap];
	[self.progressView.layer addSublayer:self.progressLayer];
	self.progressView.layer.cornerRadius = self.progressView.height / 2;
	self.progressView.layer.masksToBounds = YES;
	self.progressView.backgroundColor = UGRGBColor(213, 224, 237);
	self.collectionnView.delegate = self;
	self.collectionnView.dataSource = self;
	[self.collectionnView registerNib: [UINib nibWithNibName:@"UGMineMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell"];
	[self setupUserInfo:true];
	[self getSystemConfig];
	self.menuNameArray = SysConf.userCenter.copy;
	self.collectionViewHeight.constant = ((self.menuNameArray.count - 1)/3 + 1) * (APP.Width - 3)/ 3.0;
	[self.collectionnView reloadData];
	UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	[rightButton addTarget:self action:@selector(rightButtonTaped)];
	[rightButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
	self.balanceLabel2.text = @"";
	
	// 登录成功
	WeakSelf;
	SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
		[weakSelf setupUserInfo:true];

	});

	//用户信息更新
	SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
		[weakSelf setupUserInfo:true];
	});
}
- (void)rightButtonTaped {
	[JS_Sidebar show];
}

#pragma mark UICollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.menuNameArray.count;;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UGMineMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell" forIndexPath:indexPath];
	UGUserCenterItem *uci = self.menuNameArray[indexPath.row];
	cell.menuName = uci.name;
	[cell.imageView sd_setImageWithURL:[NSURL URLWithString:uci.logo] placeholderImage:[UIImage imageNamed:uci.lhImgName]];
	cell.badgeNum = uci.code==UCI_站内信 ? [UGUserModel currentUser].unreadMsg : 0;
	[cell setBackgroundColor: [UIColor whiteColor]];
//	cell.layer.borderWidth = 0.5;
//	cell.layer.borderColor = UIColor.lightGrayColor.CGColor;
	return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	float itemW = (APP.Width - 3)/ 3.0;
	CGSize size = {itemW, itemW};
	return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 1.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	
	UGUserCenterItem *uci = self.menuNameArray[indexPath.row];
	[NavController1 pushVCWithUserCenterItemType:uci.code];
}
#pragma mark - 其他方法

// 任务中心
- (IBAction)showMissionVC:(id)sender {
	// 任务中心
	UIViewController *vc = [NavController1.viewControllers objectWithValue:UGMissionCenterViewController.class keyPath:@"class"];
	if (vc) {
		[NavController1 popToViewController:vc animated:false];
	} else {
		[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:false];
	}
}

// 每日签到
- (IBAction)showSign:(id)sender {
	[self.navigationController pushViewController:[UGSigInCodeViewController new] animated:YES];
}

// 刷新余额
- (IBAction)refreshBalance:(id)sender {
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

//刷新余额动画
- (void)startAnimation {
	CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
	ReFreshAnimation.duration = 1;
	ReFreshAnimation.repeatCount = HUGE_VALF;
	[self.refreshFirstButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

//刷新余额动画
- (void)stopAnimation {
	[self.refreshFirstButton.layer removeAllAnimations];
}

- (CAShapeLayer *)containerLayer {
	if (!_containerLayer) {
		_containerLayer = [self defaultLayer];
		CGRect rect = (CGRect){(self.progressView.bounds.size.width-self.progressView.bounds.size.height)/2, 0, self.progressView.bounds.size.height, self.progressView.bounds.size.height};
		_containerLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
	}
	return _containerLayer;
}

- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress {
	if (progress < 0.0001) { return nil; }
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	CGPoint startPoint = (CGPoint){-5, CGRectGetHeight(self.progressView.frame)/2};
	CGPoint endPoint = (CGPoint){CGRectGetWidth(self.progressView.frame)*progress, startPoint.y};
	[path moveToPoint:startPoint];
	[path addLineToPoint:endPoint];
	[path closePath];
	return path;
}

- (CAShapeLayer *)defaultLayer {
	CAShapeLayer *layer = [CAShapeLayer layer];
	layer.fillColor = [UIColor grayColor].CGColor;
	layer.strokeColor = [UIColor grayColor].CGColor;
	layer.lineCap = kCALineCapRound;
	layer.lineJoin = kCALineJoinRound;
	layer.frame = self.progressView.bounds;
	return layer;
}

- (CAShapeLayer *)progressLayer {
	if (!_progressLayer) {
		_progressLayer = [self defaultLayer];
		_progressLayer.lineWidth = self.progressView.height;
		_progressLayer.strokeColor = Skin1.progressBgColor.CGColor;
	}
	return _progressLayer;
}
#pragma mark --其他方法
- (void)showAvaterSelectView {
    if (UserI.isTest) {
        return;
    }
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
}
#pragma mark - UIS
- (void)setupUserInfo:(BOOL)flag  {
	UGUserModel *user = [UGUserModel currentUser];
	UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
	
	if ([config.missionSwitch isEqualToString:@"0"]) {
        [self.taskButton.superview setHidden:NO];
		if ([config.checkinSwitch isEqualToString:@"0"]) {
			[self.signButton.superview setHidden:YES];
		} else {
			[self.signButton.superview setHidden:NO];
		}
	} else {
		[self.taskButton.superview setHidden:YES];
		[self.signButton.superview setHidden:YES];
	}
	UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:user.avatar];
	[_headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar]
					  placeholderImage:cacheImage? cacheImage : [UIImage imageNamed:@"txp"]
							   options:SDWebImageRefreshCached];

	
	self.userNameLabel.text = user.username;
	self.userVipLabel.text = user.curLevelGrade;
	self.fristVipLabel.text = user.curLevelGrade;
	NSString *imagerStr = [user.curLevelGrade lowercaseString];
	//    NSLog(@"imagerStr = %@",imagerStr);
	//           unreadMsg = user.unreadMsg;
	//    NSLog(@"unreadMsg = %d", (int)unreadMsg);
	
	self.secondVipLabel.text = user.nextLevelGrade;
	
	self.valueLabel.text = _NSString(@"成长值（%@-%@）", _FloatString4(user.taskRewardTotal.doubleValue), _FloatString4(user.nextLevelInt.doubleValue));
	
	if (![CMCommon stringIsNull:user.taskRewardTitle]) {
		self.moneyNameLabel.text = user.taskRewardTitle;
	}
	if (![CMCommon stringIsNull:user.taskRewardTotal]) {
		self.moenyNumberLabel.text = user.taskReward;
	}
	
	double floatString = [user.balance doubleValue];
	self.userMoneyLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
	self.balanceLabel2.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
	//进度条
	double progress = user.taskRewardTotal.doubleValue/user.nextLevelInt.doubleValue;
	self.progressLayer.path = [self progressPathWithProgress:progress].CGPath;
}


#pragma mark -- 网络请求

- (void)getUserInfo {
	[self startAnimation];
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf;
	[CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			UGUserModel *user = model.data;
			UGUserModel *oldUser = [UGUserModel currentUser];
			user.sessid = oldUser.sessid;
			user.token = oldUser.token;
			UGUserModel.currentUser = user;
			NSLog(@"签到==%d",[UGUserModel currentUser].checkinSwitch);
			
			[weakSelf getSystemConfig];
			//            //初始化数据
			//            [self getDateSource];
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
			[weakSelf setupUserInfo:YES];
			[weakSelf stopAnimation];
			SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
		} failure:^(id msg) {
			[SVProgressHUD dismiss];
		}];
	}];
}

- (IBAction)rechargeButtonTaped:(id)sender {
	//存款
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	fundsVC.selectIndex = 0;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)withdrawButtonTaped:(id)sender {
	//提现
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	fundsVC.selectIndex = 1;
	[self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)convertButtonTaped:(id)sender {
	//转换
	[self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController") animated:YES];
}

- (IBAction)rechargeRecordButtonTaped:(id)sender {
	UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	  fundsVC.selectIndex = 2;
	  [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)withdrawRecordButtonTaped:(id)sender {
	NSLog(@"提现记录");
	 UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
	 fundsVC.selectIndex = 3;
	 [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)betRecordButtonTaepd:(id)sender {
	NSLog(@"投注记录");
	 [self.navigationController pushViewController:[UGBetRecordViewController new] animated:YES];
}
- (IBAction)customerServiceButtonTaped:(id)sender {
	NSLog(@"联系客服");
	  [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
}
# pragma mark <JS_TitleViewDelegagte>
- (void)loginButtonTaped {
	[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];

}
- (void)registButtonnTaped {
	[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGRegisterViewController") animated:YES];

}
- (void)moreButtonTaped {
	[JS_Sidebar show];
}
@end
