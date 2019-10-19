//
//  UGCommonLotteryController.m
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGCommonLotteryController.h"
#import "UGLotterySelectController.h"

#import "UGLotteryHomeController.h"
#import "STBarButtonItem.h"
#import "UGLotteryCollectionViewCell.h"
#import "CMCommon.h"
#import "UGLotteryAssistantController.h"
#import "CountDown.h"
#import "UGHallLotteryModel.h"
#import "UGChangLongController.h"
#import "UGAllNextIssueListModel.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "UGLotteryGameCollectionViewCell.h"

#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"
@interface UGCommonLotteryController ()

@end

@implementation UGCommonLotteryController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupTitleView];

}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.shoulHideHeader) {
		[self hideHeader];
	}
	if (self.shoulHideContent) {
		[self hideContent];
	}

	
}

- (void)hideHeader {
	UIImageView * mmcHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmcbg" ]];
	[self.view addSubview:mmcHeader];
	[mmcHeader mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.equalTo(self.view);
		make.height.equalTo(@114);
	}];
}
- (void)hideContent {
	
}

- (void)setupTitleView {
	UILabel *titleLabel = [UILabel new];
	[titleLabel setUserInteractionEnabled:true];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@ ▼", self.model.title ? : @""];
	titleLabel.textColor = UIColor.whiteColor;
	[titleLabel addGestureRecognizer: [UITapGestureRecognizer gestureRecognizer:^(__kindof UIGestureRecognizer *gr) {
		UGLotterySelectController * vc = [UGLotterySelectController new];
		vc.dataArray = [self.allList mutableCopy];
		vc.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
			void(^judeBlock)(UGCommonLotteryController * lotteryVC) = ^(UGCommonLotteryController * lotteryVC) {
				if ([@[@"7", @"11", @"9"] containsObject: nextModel.gameId]) {
					lotteryVC.shoulHideHeader = true;
				}
				lotteryVC.allList = self.allList;
				lotteryVC.model = nextModel;
			};
			
			UGCommonLotteryController * preparePushVC;
			
			if ([@"cqssc" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
				UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
				lotteryVC.nextIssueModel = nextModel;
				lotteryVC.gameId = nextModel.gameId;
				lotteryVC.lotteryGamesArray = self.allList;
				//此处为重点
				lotteryVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(lotteryVC);
				preparePushVC = lotteryVC;
			} else if ([@"pk10" isEqualToString:nextModel.gameType] ||
					   [@"xyft" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
				UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
				markSixVC.nextIssueModel = nextModel;
				markSixVC.gameId = nextModel.gameId;
				markSixVC.lotteryGamesArray = self.allList;
				//此处为重点
				markSixVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(markSixVC);
				
				preparePushVC = markSixVC;
				
			} else if ([@"qxc" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
				UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
				sevenVC.nextIssueModel = nextModel;
				sevenVC.gameId = nextModel.gameId;
				sevenVC.lotteryGamesArray = self.allList;
				sevenVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(sevenVC);
				
				preparePushVC = sevenVC;
				
			} else if ([@"lhc" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGHKLHCLotteryController" bundle:nil];
				UGHKLHCLotteryController *markSixVC = [storyboard instantiateInitialViewController];
				markSixVC.nextIssueModel = nextModel;
				markSixVC.gameId = nextModel.gameId;
				markSixVC.lotteryGamesArray = self.allList;
				markSixVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(markSixVC);
				
				preparePushVC = markSixVC;
				
			} else if ([@"jsk3" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGJSK3LotteryController" bundle:nil];
				UGJSK3LotteryController *fastThreeVC = [storyboard instantiateInitialViewController];
				fastThreeVC.nextIssueModel = nextModel;
				fastThreeVC.gameId = nextModel.gameId;
				fastThreeVC.lotteryGamesArray = self.allList;
				fastThreeVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(fastThreeVC);
				
				preparePushVC = fastThreeVC;
			} else if ([@"pcdd" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPCDDLotteryController" bundle:nil];
				UGPCDDLotteryController *PCVC = [storyboard instantiateInitialViewController];
				PCVC.nextIssueModel = nextModel;
				PCVC.gameId = nextModel.gameId;
				PCVC.lotteryGamesArray = self.allList;
				PCVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(PCVC);
				
				preparePushVC = PCVC;
				
			} else if ([@"gd11x5" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGD11X5LotteryController" bundle:nil];
				UGGD11X5LotteryController *PCVC = [storyboard instantiateInitialViewController];
				PCVC.nextIssueModel = nextModel;
				PCVC.gameId = nextModel.gameId;
				PCVC.lotteryGamesArray = self.allList;
				PCVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(PCVC);
				
				preparePushVC = PCVC;
				
			} else if ([@"bjkl8" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJKL8LotteryController" bundle:nil];
				UGBJKL8LotteryController *PCVC = [storyboard instantiateInitialViewController];
				PCVC.nextIssueModel = nextModel;
				PCVC.gameId = nextModel.gameId;
				PCVC.lotteryGamesArray = self.allList;
				PCVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(PCVC);
				
				preparePushVC = PCVC;
				
			} else if ([@"gdkl10" isEqualToString:nextModel.gameType] ||
					   [@"xync" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGDKL10LotteryController" bundle:nil];
				UGGDKL10LotteryController *PCVC = [storyboard instantiateInitialViewController];
				PCVC.nextIssueModel = nextModel;
				PCVC.gameId = nextModel.gameId;
				PCVC.lotteryGamesArray = self.allList;
				PCVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(PCVC);
				
				preparePushVC = PCVC;
				
			} else if ([@"fc3d" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFC3DLotteryController" bundle:nil];
				UGFC3DLotteryController *markSixVC = [storyboard instantiateInitialViewController];
				markSixVC.nextIssueModel = nextModel;
				markSixVC.gameId = nextModel.gameId;
				markSixVC.lotteryGamesArray = self.allList;
				markSixVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(markSixVC);
				
				preparePushVC = markSixVC;
				
			} else if ([@"pk10nn" isEqualToString:nextModel.gameType]) {
				UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPK10NNLotteryController" bundle:nil];
				UGPK10NNLotteryController *markSixVC = [storyboard instantiateInitialViewController];
				markSixVC.nextIssueModel = nextModel;
				markSixVC.gameId = nextModel.gameId;
				markSixVC.lotteryGamesArray = self.allList;
				markSixVC.gotoTabBlock = ^{
					self.navigationController.tabBarController.selectedIndex = 0;
				};
				judeBlock(markSixVC);
				
				preparePushVC = markSixVC;
				
			}
			
            // 设置导航条返回按钮
            {
                UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateNormal];
                [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateHighlighted];
                [backButton sizeToFit];
                [backButton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
                    [NavController1 popViewControllerAnimated:true];
                }];
                UIView *containView = [[UIView alloc] initWithFrame:backButton.bounds];
                [containView addSubview:backButton];
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containView];
                // 设置返回按钮
                preparePushVC.navigationItem.leftBarButtonItem = item;
                // 隐藏底部条
                preparePushVC.hidesBottomBarWhenPushed = YES;
            }
            
			NSMutableArray *viewCtrs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
			[viewCtrs removeLastObject];
			[viewCtrs addObject: preparePushVC];
			[preparePushVC setHidesBottomBarWhenPushed:true];
			[self.navigationController setViewControllers:viewCtrs animated:YES];
		};
		UGNavigationController * nav = [[UGNavigationController alloc] initWithRootViewController:vc];
		[self presentViewController:nav animated:true completion:nil];
	}]];
    if (OBJOnceToken(self)) {
        [self.navigationItem aspect_hookSelector:@selector(setTitle:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
            NSString *title = ai.arguments.lastObject;
            titleLabel.text = [NSString stringWithFormat:@"%@ ▼", title];
        } error:nil];
    }
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    v.userInteractionEnabled = true;
    v.clipsToBounds = false;
    [v addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(v);
    }];
    self.navigationItem.titleView = v;
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
}
@end
