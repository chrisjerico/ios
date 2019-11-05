//
//  UGNavigationController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNavigationController.h"
#import "UGBMMemberCenterViewController.h"
#import "UGBMBrowseViewController.h"

// ViewController
#import "UGCommonLotteryController.h"
#import "UGChangLongController.h"
#import "UGFundsViewController.h"
#import "UGAgentViewController.h"
#import "UGPromotionIncomeController.h"
#import "UGBetRecordViewController.h"
#import "UGGameListViewController.h"
#import "UGDocumentVC.h"
#import <SafariServices/SafariServices.h>

// Tools
#import "UGAppVersionManager.h"


@interface UGNavigationController ()

@end

@implementation UGNavigationController

static UGNavigationController *_navController = nil;

+ (instancetype)shared {
    return _navController;
}

+ (void)load {
    // 获取哪个类下的导航条,管理自己下导航条
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    // 设置背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forBarMetrics:UIBarMetricsDefault];
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navController = self;
    
    //去除导航栏下方的横线
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (UIView *)topView {
    return _navController.viewControllers.lastObject.view;
}
- (UIViewController *)firstVC{
    return _navController.viewControllers.firstObject;
}

- (UIViewController *)lastVC{
    return _navController.viewControllers.lastObject;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // push权限判断
    if (self.viewControllers.count && ![UGTabbarController canPushToViewController:viewController])
        return;
    
    // 判断下是否是非根控制器
    if (self.childViewControllers.count) { // 不是根控制器
        // 设置非根控制器的返回按钮
        // 设置返回按钮
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
        viewController.navigationItem.leftBarButtonItem = item;
        
        if ([viewController isKindOfClass:UGBMBrowseViewController.class]||[viewController isKindOfClass:UGBMMemberCenterViewController.class]) {
             // 不隐藏底部条
                viewController.hidesBottomBarWhenPushed = NO;
        }
        else{
             // 隐藏底部条
               viewController.hidesBottomBarWhenPushed = YES;
        }
        
   
    }
    
    // 真正在执行跳转
    [super pushViewController:viewController animated:animated];
}


#pragma mark - 根据Model快捷跳转函数

- (void)pushViewControllerWithGameModel:(GameModel *)model {
    if (model.game_id) {
        model.gameId = model.game_id;
    }
    
    // 去资料页
    if ([model.docType intValue] == 1) {
        [NavController1 pushViewController:[[UGDocumentVC alloc] initWithModel:model] animated:true];
        return;
    }
    // 去二级游戏列表
    if (model.isPopup) {
        UGGameListViewController *gameListVC = [[UGGameListViewController alloc] init];
        gameListVC.game = model;
        [NavController1 pushViewController:gameListVC animated:YES];
        return;
    }
    // 去彩票下注页、或第三方游戏页、或功能页
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:model.seriesId linkPosition:model.subId];
    
    if (!ret) {
        // 去外部链接
        if (model.url.length) {
            NSURL *url = [NSURL URLWithString:model.url];
            if (url.scheme == nil) {
                url = [NSURL URLWithString:_NSString(@"http://%@", model.url)];
            }
            SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:url];
            sf.允许未登录访问 = true;
            sf.允许游客访问 = true;
            [NavController1 presentViewController:sf animated:YES completion:nil];
            return;
        }
    }
}

- (BOOL)pushViewControllerWithNextIssueModel:(UGNextIssueModel *)model {
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
        if ([UGTabbarController canPushToViewController:vc]) {
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
        }
        return true;
    }
    return false;
}

- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(NSInteger)linkPosition {
    // 去游戏页面
    switch (linkCategory) {
        case 1: {
            // 去彩票下注页
            return [NavController1 pushViewControllerWithNextIssueModel:[UGNextIssueModel modelWithGameId:@(linkPosition).stringValue]];
        }
        case 2:
        case 3:
        case 4:
        case 5:
        case 6: {
            // 去第三方游戏页面
            if (!UGLoginIsAuthorized()) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UGNotificationShowLoginView object:nil];
                return true;
            }
            NSDictionary *params = @{@"token":UserI.sessid, @"id":@(linkPosition).stringValue};
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD dismiss];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
                        NSLog(@"网络链接：model.data = %@", model.data);
                        qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
                        qdwebVC.enterGame = YES;
                        [NavController1 pushViewController:qdwebVC animated:YES];
                    });
                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
            return true;
        }
        default:;
    }
    
    if (linkCategory != 7) {
        return false;
    }
    
    // 去功能页面
    switch (linkPosition) {
        case 1: {
            // 资金管理
            [NavController1 pushViewController:[UGFundsViewController new] animated:true];
            break;
        }
        case 2: {
            // APP下载
            [[UGAppVersionManager shareInstance] updateVersionApi:true];
            break;
        }
        case 3: {
            // 聊天室
            [NavController1 pushViewController:[UGChatViewController new] animated:YES];
            break;
        }
        case 4: {
            // 在线客服
            TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
            webViewVC.url = SysConf.zxkfUrl;
            webViewVC.webTitle = @"在线客服";
            [NavController1 pushViewController:webViewVC animated:YES];
            break;
        }
        case 5: {
            // 长龙助手
            [NavController1 pushViewController:[UGChangLongController new] animated:YES];
            break;
        }
        case 6: {
            // 推广收益
            if (UserI.isTest) {
                [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
            } else {
                [SVProgressHUD showWithStatus:nil];
                [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                    [CMResult processWithResult:model success:^{
                        [SVProgressHUD dismiss];
                        UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                        int intStatus = obj.reviewStatus.intValue;
                        
                        //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                        if (intStatus == 2) {
                            [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
                        } else {
                            if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                                [HUDHelper showMsg:@"在线注册代理已关闭"];
                                return ;
                            }
                            UGAgentViewController *vc = [[UGAgentViewController alloc] init];
                            vc.item = obj;
                            [NavController1 pushViewController:vc animated:YES];
                        }
                    } failure:^(id msg) {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }];
                }];
            }
            break;
        }
        case 7: {
            // 开奖网
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"%@/Open_prize/index.php", baseServerUrl)]];
            break;
        }
        case 8: {
            // 利息宝
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
            break;
        }
        case 9: {
            // 优惠活动
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
            break;
        }
        case 10: {
            // 注单记录
            UGBetRecordViewController *vc = [[UGBetRecordViewController alloc] init];
            [NavController1 pushViewController:vc animated:true];
            break;
        }
        case 11: {
            // QQ客服
            NSString *qqstr;
            if ([CMCommon stringIsNull:SysConf.serviceQQ1]) {
                qqstr = SysConf.serviceQQ2;
            } else {
                qqstr = SysConf.serviceQQ1;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qqstr)]];
            break;
        }
        case 13: {
            // 任务大厅
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:true];
            break;
        }
        default: {
            return false;
        }
    }
    return true;
}

@end
