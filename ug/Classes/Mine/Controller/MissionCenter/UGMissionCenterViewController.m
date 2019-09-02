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

@interface UGMissionCenterViewController ()

@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *missionTitleLabel;
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


@end

@implementation UGMissionCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.titleCollectionView.titleSelectBlock = ^(NSInteger index) {
        weakSelf.missionCollectionView.selectIndex = index;
    };
    
    self.missionCollectionView.selectIndexBlock = ^(NSInteger selectIndex) {
        weakSelf.titleCollectionView.selectIndex = selectIndex;
    };

}

- (IBAction)backCick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)refreshBalance:(id)sender {
    if (!self.refreshBalanceButton.selected) {
        [self startAnimation];
    }else {
        [self.refreshBalanceButton.layer removeAllAnimations];
    }
    self.refreshBalanceButton.selected = !self.refreshBalanceButton.selected;
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

@end
