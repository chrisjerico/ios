//
//  UGMissionCenterViewController.m
//  ug
//
//  Created by ug on 2019/5/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionCenterViewController.h"
#import "XYYSegmentControl.h"
#import "UGMissionListController.h"
#import "UGMissionLevelController.h"
#import "UGIntegralConvertController.h"
#import "UGIntegralConvertRecordController.h"
#import "UGMissionTitleCollectionView.h"
#import "UGMissionCollectionView.h"
#import "WavesView.h"
#import "UGSigInCodeViewController.h"
#import "UGMineSkinViewController.h"
#import "UGSignInHistoryModel.h"
#import "UGSalaryListView.h"
@interface UGMissionCenterViewController ()


@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *missionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImager;

@property (weak, nonatomic) IBOutlet UIImageView *curLevelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextLevelImageView;

@property (weak, nonatomic) IBOutlet UILabel *curLevel1Label;
@property (weak, nonatomic) IBOutlet UILabel *nextLevel2Label;

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBalanceButton;

@property (weak, nonatomic) IBOutlet UIView *waveBgView;
@property (weak, nonatomic) IBOutlet UIView *waveBottomView;

@property (nonatomic, strong) CAShapeLayer *containerLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) UGMissionTitleCollectionView *titleCollectionView;
@property (nonatomic, strong) UGMissionCollectionView *missionCollectionView;
@property (nonatomic, strong) WavesView *waveView;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;//积分，暂时隐藏
@property (weak, nonatomic) IBOutlet UILabel *taskRewradTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *waveUImageV;

@property (weak, nonatomic) IBOutlet UIButton *salaryBtn;  /**<   领取俸禄 */


@property (nonatomic, strong) NSMutableArray <UGSignInHistoryModel *> *historyDataArray;


@end

@implementation UGMissionCenterViewController

static NSString *__title = nil;

+ (void)setTitle:(NSString *)title {
    __title = title;
}

- (void)skin {
    [self initView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _historyDataArray = [NSMutableArray new];
    SANotificationEventSubscribe(UGNotificationGetRewardsSuccessfully, self, ^(typeof (self) self, id obj) {
        [self getUserInfo];
        
    });
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self setupUserInfo];
    });
    [self initView];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupUserInfo];
}

- (void)initView {
    [self.integralLabel setHidden:YES];
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationItem.title = __title.length ? __title : @"任务中心";
    
    [self.salaryBtn setHidden:!APP.isShowSalary];


    self.userInfoView.backgroundColor = Skin1.is23 ? RGBA(111, 111, 111, 1) : Skin1.navBarBgColor;
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.height / 2 ;
    self.avaterImageView.layer.masksToBounds = YES;
    self.levelNameLabel.layer.cornerRadius = self.levelNameLabel.height / 2;
    self.levelNameLabel.layer.masksToBounds = YES;
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressLayer.path = [self progressPathWithProgress:0.3].CGPath;
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = UGRGBColor(213, 224, 237);
    
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveBottomView.backgroundColor = Skin1.tabBarBgColor;
    self.waveView.realWaveColor = Skin1.tabBarBgColor;
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
    [self.waveView startWaveAnimation];
    
    if (Skin1.isBlack) {
        [_waveUImageV setHidden:YES];
        self.view.backgroundColor = Skin1.bgColor;
    }
    else {
        [_waveUImageV setHidden:NO];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self.view addSubview:self.titleCollectionView];
    [self.view addSubview:self.missionCollectionView];
    self.titleCollectionView.selectIndex = 0;
    WeakSelf
    self.titleCollectionView.titleSelectBlock = ^(NSInteger index,NSString *title) {
        weakSelf.missionCollectionView.selectIndex = index;
//        weakSelf.title = title;
    };
    
    self.missionCollectionView.selectIndexBlock = ^(NSInteger selectIndex) {
        weakSelf.titleCollectionView.selectIndex = selectIndex;
        
    };
    
    [self getUserInfo];
    
    // 彩币兑换成功时，刷新余额、彩币
    [self xw_addNotificationForName:kDidCreditsExchangeData block:^(NSNotification * _Nonnull noti) {
        [weakSelf setupUserInfo];
    }];
}


//刷新余额动画
-(void)startAnimation
{
    
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshBalanceButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
    
}

//刷新余额动画
-(void)stopAnimation
{
    
    [self.refreshBalanceButton.layer removeAllAnimations];

}

- (CAShapeLayer *)containerLayer
{
    if (!_containerLayer) {
        _containerLayer = [self defaultLayer];
        CGRect rect = (CGRect){(self.progressView.bounds.size.width-self.progressView.bounds.size.height)/2,0,self.progressView.bounds.size.height,self.progressView.bounds.size.height};
        _containerLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
    }
    return _containerLayer;
}

- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress
{
    if (progress < 0.0001) 
        return nil;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = (CGPoint){0, CGRectGetHeight(self.progressView.frame)/2};
    CGPoint endPoint = (CGPoint){CGRectGetWidth(self.progressView.frame)*progress, startPoint.y};
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    return path;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [self defaultLayer];
        _progressLayer.lineWidth = self.progressView.height;
        _progressLayer.strokeColor = Skin1.progressBgColor.CGColor;
    }
    return _progressLayer;
}

- (CAShapeLayer *)defaultLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor grayColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.progressView.bounds;
    return layer;
    
}

- (UGMissionTitleCollectionView *)titleCollectionView {
    if (_titleCollectionView == nil) {
        _titleCollectionView = [[UGMissionTitleCollectionView alloc] initWithFrame:CGRectMake(0, self.userInfoView.height + 5, UGScreenW, 50)];
    }
    return _titleCollectionView;
}

- (UGMissionCollectionView *)missionCollectionView {
    if (_missionCollectionView == nil) {
        _missionCollectionView = [[UGMissionCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleCollectionView.frame), UGScreenW, UGScerrnH - CGRectGetMaxY(self.titleCollectionView.frame))];
    }
    return _missionCollectionView;
}

#pragma mark - UIS
- (void)setupUserInfo {
    UGUserModel *user = [UGUserModel currentUser];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    self.userNameLabel.text = user.username;
    self.levelNameLabel.text = user.curLevelGrade;
    
    NSString *imagerStr = [user.curLevelGrade lowercaseString];
    NSLog(@"imagerStr = %@",imagerStr);
    
    if (![CMCommon stringIsNull:user.curLevelGrade]) {
        if (user.curLevelGrade.length>=4) {
            NSString *subStr = [user.curLevelGrade substringFromIndex:3];
            
            int levelsInt = [subStr intValue];
            NSString *imgStr = @"";
            if (levelsInt <11) {
                imgStr = [NSString stringWithFormat:@"vip%d",levelsInt];
            } else {
                imgStr = @"vip11";
            }
            
            [self.vipImager setImage: [UIImage imageNamed:imgStr]];
            
            NSString *img2Str = @"";
            if (levelsInt <11) {
                img2Str = [NSString stringWithFormat:@"grade_%d",levelsInt];
            } else {
                img2Str = @"grade_11";
            }
            
            [self.curLevelImageView setImage: [UIImage imageNamed:img2Str]];
            self.curLevel1Label.text = [NSString stringWithFormat:@"VIP%@",subStr];
        }
    }
    
    if (![CMCommon stringIsNull:user.nextLevelGrade]) {
        if (user.nextLevelGrade.length>=4) {
            NSString *sub2Str = [user.nextLevelGrade substringFromIndex:3];
            
            int levels2Int = [sub2Str intValue];
            
            NSString *img2_1Str = @"";
            if (levels2Int <11) {
                img2_1Str = [NSString stringWithFormat:@"grade_%d",levels2Int];
            } else {
                img2_1Str = @"grade_11";
            }
            
            [self.nextLevelImageView setImage: [UIImage imageNamed:img2_1Str]];
            self.nextLevel2Label.text = [NSString stringWithFormat:@"VIP%@",sub2Str];
            self.missionTitleLabel.text = _NSString(@"成长值（%@-%@）", _FloatString4(user.taskRewardTotal.doubleValue), _FloatString4(user.nextLevelInt.doubleValue));
        }
    }
    
    
    if (![CMCommon stringIsNull:user.taskRewardTitle]) {
        self.taskRewradTitleLabel.text = user.taskRewardTitle;
    }
    if (![CMCommon stringIsNull:user.taskRewardTotal]) {
        self.integralLabel.text = _FloatString4(user.taskReward.doubleValue);
        [self.integralLabel setHidden:NO];
    }
    
    double floatString = [user.balance doubleValue];
    self.balanceLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    //进度条
    double progress = user.taskRewardTotal.doubleValue/user.nextLevelInt.doubleValue;
    self.progressLayer.path = [self progressPathWithProgress:progress].CGPath;
}


#pragma mark -- 网络请求

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
            [self setupUserInfo];
            [self stopAnimation];
        } failure:^(id msg) {
            [self stopAnimation];
        }];
    }];
}


#pragma mark - IBAction

//去会员中心
- (IBAction)backCick:(id)sender {
    
    // 会员中心
       UIViewController *vc = [NavController1.viewControllers objectWithValue:UGMineSkinViewController.class keyPath:@"class"];
       if (vc) {
           [NavController1 popToViewController:vc animated:false];
       } else {

           [self.navigationController pushViewController:[UGMineSkinViewController new] animated:YES];
       }
//    if ([self.navigationController.viewControllers.lastObject isEqual:self]) {
//        //去会员中心
//        [self.navigationController pushViewController:[UGMineSkinViewController new] animated:YES];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
}

// 每日签到
- (IBAction)goSigInCode:(id)sender {
    UGSigInCodeViewController *vc = [[UGSigInCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 领取俸禄
- (IBAction)goSalary:(id)sender {
 
    [self getMissionBonusList];
}

//获取俸禄列表数据
- (void)getMissionBonusList {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};

    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork getMissionBonusListUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSLog(@"model.data = %@",model.data);
            self.historyDataArray = model.data;
            NSLog(@"_historyDataArray = %@",self.historyDataArray);
            if (![CMCommon arryIsNull:self.historyDataArray]) {
                [self showUGSignInHistoryView];
            }


        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];

}

#pragma mark -- 其他方法

- (void)showUGSignInHistoryView {

    UGSalaryListView *notiveView = [[UGSalaryListView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
    notiveView.dataArray = self.historyDataArray;
    [notiveView.bgView setBackgroundColor: Skin1.navBarBgColor];

    [notiveView show];
    
}

@end
