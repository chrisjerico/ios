
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
#import "UGYUbaoTitleView.h"
@interface UGYubaoViewController ()
@property (nonatomic, strong) UGYUbaoTitleView *titleView;               /**<   自定义导航条 */

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

- (BOOL)允许游客访问 { return UserI.yuebaoSwitch; }

- (void)skin {
	
	self.waveBotomView.backgroundColor =  Skin1.navBarBgColor;
	self.waveView.realWaveColor =  Skin1.navBarBgColor;
	FastSubViewCode(self.view)
	if (Skin1.isBlack||Skin1.is23) {
        [self.view setBackgroundColor:Skin1.is23 ?RGBA(135 , 135 ,135, 1):Skin1.bgColor];
		[subLabel(@"本周收益label") setTextColor:[UIColor whiteColor]];
		[subLabel(@"本月收益label") setTextColor:[UIColor whiteColor]];
		[subLabel(@"总收益label") setTextColor:[UIColor whiteColor]];
		[subLabel(@"额度转入转出label") setTextColor:[UIColor whiteColor]];
		[subLabel(@"收益报表label") setTextColor:[UIColor whiteColor]];
		[subLabel(@"转入转出记录label") setTextColor:[UIColor whiteColor]];
		[subLabel(@"内容label") setTextColor:[UIColor whiteColor]];
		[_weekProfitLabel setTextColor:[UIColor whiteColor]];
		[_monthProfitLabel setTextColor:[UIColor whiteColor]];
		[_totalProfitLabel setTextColor:[UIColor whiteColor]];
		[subImageView(@"浪图UIImagV") setHidden:YES];
	} else if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		[self.view setBackgroundColor: [UIColor whiteColor]];
		[subLabel(@"本周收益label") setTextColor:[UIColor blackColor]];
		[subLabel(@"本月收益label") setTextColor:[UIColor blackColor]];
		[subLabel(@"总收益label") setTextColor:[UIColor blackColor]];
		[subLabel(@"额度转入转出label") setTextColor:[UIColor blackColor]];
		[subLabel(@"收益报表label") setTextColor:[UIColor blackColor]];
		[subLabel(@"转入转出记录label") setTextColor:[UIColor blackColor]];
		[subLabel(@"内容label") setTextColor:[UIColor blackColor]];
		[_weekProfitLabel setTextColor:[UIColor blackColor]];
		[_monthProfitLabel setTextColor:[UIColor blackColor]];
		[_totalProfitLabel setTextColor:[UIColor blackColor]];
		[subImageView(@"浪图UIImagV") setHidden:NO];
	} else {
		[self.view setBackgroundColor: [UIColor whiteColor]];
		[subLabel(@"本周收益label") setTextColor:[UIColor blackColor]];
		[subLabel(@"本月收益label") setTextColor:[UIColor blackColor]];
		[subLabel(@"总收益label") setTextColor:[UIColor blackColor]];
		[subLabel(@"额度转入转出label") setTextColor:[UIColor blackColor]];
		[subLabel(@"收益报表label") setTextColor:[UIColor blackColor]];
		[subLabel(@"转入转出记录label") setTextColor:[UIColor blackColor]];
		[subLabel(@"内容label") setTextColor:[UIColor blackColor]];
		[_weekProfitLabel setTextColor:[UIColor blackColor]];
		[_monthProfitLabel setTextColor:[UIColor blackColor]];
		[_totalProfitLabel setTextColor:[UIColor blackColor]];
		[subImageView(@"浪图UIImagV") setHidden:NO];
		
	}
	
	[self setYYBgViewBgColor];
	
}

-(void)setYYBgViewBgColor{
	if ([@"新年红,石榴红,六合资料,金沙主题,简约模板,火山橙,香槟金" containsString:Skin1.skitType]) {
		[_yyBgView setBackgroundColor:Skin1.navBarBgColor];
		self.waveBotomView.backgroundColor =  Skin1.navBarBgColor;
		self.waveView.realWaveColor =  Skin1.navBarBgColor;
	}
    else if(Skin1.is23) {
        [_yyBgView setBackgroundColor:RGBA(111, 111, 111, 1)];
        self.waveBotomView.backgroundColor =  RGBA(135 , 135 ,135, 1);
        self.waveView.realWaveColor = RGBA(135 , 135 ,135, 1);
    }
    else {
        [_yyBgView setBackgroundColor:Skin1.yubaoBgColor ? : Skin1.bgColor];
		self.waveBotomView.backgroundColor = Skin1.yubaoBgColor ? : Skin1.bgColor;
		self.waveView.realWaveColor = Skin1.yubaoBgColor ? : Skin1.bgColor;
	}
}
- (void)viewDidLoad {
	[super viewDidLoad];
	//    self.fd_prefersNavigationBarHidden = YES;

    if (!self.title) {
        self.title = @"利息宝";
    }
	self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
	[self.waveBgView addSubview:self.waveView];
	self.waveView.backgroundColor = [UIColor clearColor];
	
	self.waveBotomView.backgroundColor =  Skin1.bgColor;
	self.waveView.realWaveColor =  Skin1.bgColor;
	self.waveView.maskWaveColor = [UIColor clearColor];
	self.waveView.waveHeight = 10;
	[self.waveView startWaveAnimation];
	NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"yuebaoMone" ofType:@"gif"];
	NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
	FLAnimatedImage *bgAnimateImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
	self.animatedImageView.animatedImage = bgAnimateImage;
	self.animatedImageView.hidden = YES;
	[self skin];
	[self setYYBgViewBgColor];
	
	
	UGYUbaoTitleView *titleView = [[UGYUbaoTitleView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 50)];
	self.navigationItem.titleView = titleView;
	[titleView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP.Width);
	}];
	
	self.titleView = titleView;
	
	[self.titleView.returnButton addTarget:self action:@selector(returnButtonAction) forControlEvents:UIControlEventTouchUpInside];
	
	self.countDown = [[CountDown alloc] init];
	
}

- (void)returnButtonAction{
	[self.navigationController popViewControllerAnimated:YES];
	
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
		weakSelf.titleView.progressView.progress = progress;
		
	}];
	[self setYYBgViewBgColor];
	[self getYuebaoInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.countDown destoryTimer];
	[self.waveView stopWaveAnimation];
}

- (void)getYuebaoInfo {
    WeakSelf;
	[CMNetwork getYuebaoInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			weakSelf.infoModel = model.data;
			[weakSelf setupInfo];
		} failure:^(id msg) {
			[SVProgressHUD dismiss];
		}];
	}];
}

- (IBAction)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (IBAction)conversion:(id)sender {
	UGYubaoConversionViewController *conversionVC = _LoadVC_from_storyboard_(@"UGYubaoConversionViewController");
	conversionVC.infoModel = self.infoModel;
	[self.navigationController pushViewController:conversionVC animated:YES];
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
