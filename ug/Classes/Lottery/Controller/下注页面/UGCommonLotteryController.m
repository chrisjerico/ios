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

// Model
#import "GameCategoryDataModel.h"

@interface UGCommonLotteryController ()

@end


@implementation UGCommonLotteryController

+ (BOOL)pushWithModel:(UGNextIssueModel *)model {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return true;
    }
    
    NSDictionary *dict = @{@"cqssc" :@"UGSSCLotteryController",     // 重庆时时彩
                           @"pk10"  :@"UGBJPK10LotteryController",  // pk10
                           @"xyft"  :@"UGBJPK10LotteryController",  // 幸运飞艇
                           @"qxc"   :@"UGQXCLotteryController",     // 七星彩
                           @"lhc"   :@"UGHKLHCLotteryController",   // 六合彩
                           @"jsk3"  :@"UGJSK3LotteryController",    // 江苏快3
                           @"pcdd"  :@"UGPCDDLotteryController",    // pc蛋蛋
                           @"gd11x5":@"UGGD11X5LotteryController",  // 广东11选5
                           @"xync"  :@"UGXYNCLotteryController",    // 幸运农场
                           @"bjkl8" :@"UGBJKL8LotteryController",   // 北京快乐8
                           @"gdkl10":@"UGGDKL10LotteryController",  // 广东快乐10
                           @"fc3d"  :@"UGFC3DLotteryController",    // 福彩3D
                           @"pk10nn":@"UGPK10NNLotteryController",  // pk10牛牛
    };
    
    NSString *vcName = dict[model.gameType];
    if (vcName.length) {
        UGCommonLotteryController *vc = _LoadVC_from_storyboard_(vcName);
        if ([@[@"7", @"11", @"9"] containsObject:model.gameId]) {
            vc.shoulHideHeader = true;
        }
        UGNextIssueModel *nextIssueModel = [UGNextIssueModel new];
        [nextIssueModel setValuesWithObject:model];
        vc.nextIssueModel = nextIssueModel;
        vc.gameId = model.gameId;
        vc.gotoTabBlock = ^{
            TabBarController1.selectedIndex = 0;
        };
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
            vc.navigationItem.leftBarButtonItem = item;
            // 隐藏底部条
            vc.hidesBottomBarWhenPushed = YES;
        }
        // Push
        [NavController1 setViewControllers:({
            NSMutableArray *vcs = NavController1.viewControllers.mutableCopy;
            for (UIViewController *vc in NavController1.viewControllers) {
                if ([vc isKindOfClass:[UGCommonLotteryController class]]) {
                    [vcs removeObject:vc];
                }
            }
            [vcs addObject:vc];
            vcs;
        }) animated:YES];
        return true;
    }
    return false;
}


- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupTitleView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.shoulHideHeader) {
		[self hideHeader];
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

- (void)getGameDatas {}

- (void)setupTitleView {
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemWithTitle:_NSString(@"%@ ▼", self.nextIssueModel.title ? : @"") target:self action:@selector(onTitleClick)];
    self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItems.firstObject, item0];
    self.navigationItem.titleView = [UIView new];   // 隐藏标题
    
    if (OBJOnceToken(self)) {
        [self.navigationItem aspect_hookSelector:@selector(setTitle:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
            NSString *title = ai.arguments.lastObject;
            [(UIButton *)item0.customView setTitle:_NSString(@"%@ ▼", title) forState:UIControlStateNormal];
            [(UIButton *)item0.customView sizeToFit];
        } error:nil];
    }
}

- (void)onTitleClick {
    UGLotterySelectController * vc = [UGLotterySelectController new];
    vc.didSelectedItemBlock = ^(UGNextIssueModel *nextModel) {
        [UGCommonLotteryController pushWithModel:nextModel];
    };
    UGNavigationController * nav = [[UGNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:true completion:nil];
}

@end
