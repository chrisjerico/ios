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

@property (weak, nonatomic) IBOutlet UILabel *missionLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelNumLabel;
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


@end

@implementation UGMissionCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SANotificationEventSubscribe(UGNotificationGetRewardsSuccessfully, self, ^(typeof (self) self, id obj) {
        [self getUserInfo];
        
    });

    
    [self.integralLabel setHidden:YES];
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationItem.title = @"任务大厅";
    self.view.backgroundColor = UGBackgroundColor;
    self.userInfoView.backgroundColor = UGNavColor;
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.height / 2 ;
    self.avaterImageView.layer.masksToBounds = YES;
    self.levelNameLabel.layer.cornerRadius = self.levelNameLabel.height / 2;
    self.levelNameLabel.layer.masksToBounds = YES;
    self.nextLevelLabel.layer.cornerRadius = self.nextLevelLabel.height / 2;
    self.nextLevelLabel.layer.masksToBounds = YES;
    self.view.backgroundColor = UGBackgroundColor;
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressLayer.path = [self progressPathWithProgress:0.3].CGPath;
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = UGBackgroundColor;
    
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveBottomView.backgroundColor = UGRGBColor(84, 171, 238);
    self.waveView.realWaveColor = UGRGBColor(84, 171, 238);
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
    [self.waveView startWaveAnimation];
    
    [self.view addSubview:self.titleCollectionView];
    [self.view addSubview:self.missionCollectionView];
    self.titleCollectionView.selectIndex = 0;
    WeakSelf
    self.titleCollectionView.titleSelectBlock = ^(NSInteger index,NSString *title) {
        weakSelf.missionCollectionView.selectIndex = index;
        weakSelf.title = title;
    };
    
    self.missionCollectionView.selectIndexBlock = ^(NSInteger selectIndex) {
        weakSelf.titleCollectionView.selectIndex = selectIndex;
        
    };

    [self getUserInfo];
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
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = (CGPoint){0,CGRectGetHeight(self.progressView.frame)/2};
    CGPoint endPoint = (CGPoint){CGRectGetWidth(self.progressView.frame)*progress,startPoint.y};
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
        _progressLayer.strokeColor = UGRGBColor(95, 190, 249).CGColor;
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
    
    int int1String = [user.taskRewardTotal intValue];
    NSLog(@"int1String = %d",int1String);
    int int2String = [user.nextLevelInt intValue];
    NSLog(@"int2String = %d",int2String);
    self.missionTitleLabel.text = [NSString stringWithFormat:@"成长值（%d-%d）",int1String,int2String];
    
    
    double floatString = [user.balance doubleValue];
    self.balanceLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    //进度条
    float floatProgress = (float)[user.taskRewardTotal doubleValue]/[user.nextLevelInt doubleValue];
    self.progressLayer.path = [self progressPathWithProgress:floatProgress].CGPath;
    
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

#pragma mark -- 其他方法
- (IBAction)backCick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)refreshBalance:(id)sender {

    
    [self getUserInfo];
}
- (IBAction)goSigInCode:(id)sender {
    
    UGSigInCodeViewController *vc = [[UGSigInCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
