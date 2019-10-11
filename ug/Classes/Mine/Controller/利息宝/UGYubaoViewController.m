//
//  UGYubaoViewController.m
//  ug
//
//  Created by ug on 2019/5/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYubaoViewController.h"
#import "FLAnimatedImage.h"
#import "UGYubaoConversionCenterController.h"
#import "UGYubaoConversionViewController.h"
#import "ZZCircleProgress.h"
#import "CountDown.h"
#import "WavesView.h"
#import "UGYubaoInComeController.h"
#import "UGYubaoConversionRecordController.h"
#import "UGYuebaoInfoModel.h"
@interface UGYubaoViewController ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImageView;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIView *waveBgView;
@property (weak, nonatomic) IBOutlet UIView *waveBotomView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualizedRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftBalanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *imgButton;
@property (nonatomic, strong) WavesView *waveView;
@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) UGYuebaoInfoModel *infoModel;
@property (weak, nonatomic) IBOutlet UIView *yyBgView;

@end

@implementation UGYubaoViewController
-(void)skin{
//    UIImage *image = [UIImage imageNamed:@"yybgyubao1"];
//    UIImage *afterImage = [image qmui_imageWithBlendColor: [[UGSkinManagers shareInstance] setNavbgColor]];
//    self.bgView.image = afterImage;
    
    [_yyBgView setBackgroundColor:[[UGSkinManagers shareInstance] setbgColor]];
    
    self.waveBotomView.backgroundColor =  [[UGSkinManagers shareInstance] setNavbgColor];
    self.waveView.realWaveColor =  [[UGSkinManagers shareInstance] setNavbgColor];
    [self.view setBackgroundColor: [UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    [self.view setBackgroundColor: [UIColor whiteColor]];
//    self.fd_prefersNavigationBarHidden = YES;// 让导航条隐藏
    self.navigationItem.title = @"利息宝";
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
//    self.waveBotomView.backgroundColor = UGRGBColor(84, 171, 238);
//    self.waveView.realWaveColor = UGRGBColor(84, 171, 238);
    self.waveBotomView.backgroundColor =  [[UGSkinManagers shareInstance] setbgColor];
    self.waveView.realWaveColor =  [[UGSkinManagers shareInstance] setbgColor];
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
    [self.waveView startWaveAnimation];
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"yuebaoMone" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    FLAnimatedImage *bgAnimateImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
    self.animatedImageView.animatedImage = bgAnimateImage;
    self.animatedImageView.hidden = YES;
    
    [_yyBgView setBackgroundColor:[[UGSkinManagers shareInstance] setbgColor]];
      
//     UIImage *image = [UIImage imageNamed:@"yybgyubao1"];
//      UIImage *afterImage = [image qmui_imageWithBlendColor: [[UGSkinManagers shareInstance] setNavbgColor]];
//      self.bgView.image = afterImage;

    self.progressView.startAngle = 0;
    self.progressView.strokeWidth = 3;
    self.progressView.showPoint = NO;
    self.progressView.showProgressText = YES;
    self.progressView.progressLabel.font = [UIFont systemFontOfSize:14];
    self.progressView.pathBackColor = UGRGBColor(85, 117, 245);
    self.progressView.pathFillColor = UGRGBColor(255, 255, 255);
    self.progressView.progress = 1;
    self.progressView.progressLabel.text = @"60";
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    self.progressView.duration = 0;
    self.progressView.increaseFromLast = YES;
    
    self.countDown = [[CountDown alloc] init];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
     [self.waveView startWaveAnimation];
    WeakSelf
    __block float progress = 0;
    __block NSInteger count = 0;
    [self.countDown countDownWithPER_SECBlock:^{
        progress += 0.01 * 1.67;
        if (progress >= 1) {
            progress = 0;
            count = 1;
        }
        if (progress < 0.07 && count) {
            weakSelf.animatedImageView.hidden = NO;
        }else {
            weakSelf.animatedImageView.hidden = YES;
        }
        weakSelf.progressView.progress = progress;
        
    }];
    
    [self getYuebaoInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.countDown destoryTimer];
     [self.waveView stopWaveAnimation];
}

- (void)getYuebaoInfo {
    
    [CMNetwork getYuebaoInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            self.infoModel = model.data;
            [self setupInfo];
        } failure:^(id msg) {
            
        }];
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)conversion:(id)sender {
    if ([UGUserModel currentUser].isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    }else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
        UGYubaoConversionViewController *conversionVC = [storyboard instantiateViewControllerWithIdentifier:@"UGYubaoConversionViewController"];
        conversionVC.infoModel = self.infoModel;
        [self.navigationController pushViewController:conversionVC animated:YES];
       
    }
}
- (IBAction)incomList:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
    UGYubaoInComeController *incomeVC = [storyboard instantiateViewControllerWithIdentifier:@"UGYubaoInComeController"];
    [self.navigationController pushViewController:incomeVC animated:YES];
}
- (IBAction)record:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
    UGYubaoConversionRecordController *incomeVC = [storyboard instantiateViewControllerWithIdentifier:@"UGYubaoConversionRecordController"];
    [self.navigationController pushViewController:incomeVC animated:YES];
    
}

- (void)setupInfo {
    
    self.nameLabel.text = self.infoModel.yuebaoName;
    self.todayProfitLabel.text = self.infoModel.todayProfit;
    self.balanceLabel.text = [NSString stringWithFormat:@"利息宝余额 %@",self.infoModel.balance];
    NSString *nhl = [NSString stringWithFormat:@"%.4f",self.infoModel.annualizedRate.floatValue * 100];
    self.annualizedRateLabel.text = [NSString stringWithFormat:@"年化率 %@%%",[nhl removeFloatAllZero]];
    self.giftBalanceLabel.text = [NSString stringWithFormat:@"体验金 %@",self.infoModel.giftBalance];
    self.weekProfitLabel.text = self.infoModel.weekProfit;
    self.monthProfitLabel.text = self.infoModel.monthProfit;
    self.totalProfitLabel.text = self.infoModel.totalProfit;
    self.introLabel.text = self.infoModel.intro;
    
}

@end
