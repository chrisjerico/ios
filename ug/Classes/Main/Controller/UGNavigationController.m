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
#import "UGBMRegisterViewController.h"           // 黑色模板注册
#import "UGBMLoginViewController.h"              // 黑色模板登录
#import "UGLoginViewController.h"                // 模板登录
#import "UGRegisterViewController.h"             // 模板注册
#import "UGBMpreferentialViewController.h"       // 黑色模板优惠专区
#import "UGPromotionsController.h"               // 模板优惠专区
#import "UGBMLotteryHomeViewController.h"        // 黑色模板购彩大厅
#import "UGYYLotteryHomeViewController.h"        // 购彩大厅
#import "UGMailBoxTableViewController.h"         // 站内信
#import "UGSigInCodeViewController.h"            // 每日签到
#import "SLWebViewController.h"
#import "UGSecurityCenterViewController.h"  // 安全中心
#import "UGRealBetRecordViewController.h"   // 其他注单记录
#import "UGMosaicGoldViewController.h"    // 活动彩金
#import "UGLHMineViewController.h"    // 六合 我的
#import "UGMineSkinViewController.h"    //  我的
// Tools
#import "UGAppVersionManager.h"


@interface UGNavigationController ()

@end

@implementation UGNavigationController

static NSMutableArray <GameModel *> *__browsingHistoryArray = nil;

+ (NSMutableArray<GameModel *> *)browsingHistoryArray {
    return __browsingHistoryArray;
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
    
    //去除导航栏下方的横线
    [self.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    // 记录浏览历史
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *dataArray = __browsingHistoryArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"浏览历史"]]];
        [UGNavigationController cc_hookSelector:@selector(pushViewControllerWithGameModel:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
            BOOL ret = false;
            [ai.originalInvocation getReturnValue:&ret];
            if (ret) {
                GameModel *gm = ai.arguments.firstObject;
                for (GameModel *obj in [dataArray copy]) {
                    if (obj.seriesId == gm.seriesId && obj.subId == gm.subId)
                        [dataArray removeObject:obj];
                }
                [dataArray insertObject:gm atIndex:0];
                if (dataArray.count > 10) {
                    [dataArray setArray:[dataArray subarrayWithRange:NSMakeRange(0, 10)]];
                }
            }
        } error:nil];
        
        // 缓存到NSUserDefaults
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dataArray] forKey:@"浏览历史"];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dataArray] forKey:@"浏览历史"];
        }];
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (UIView *)topView {
    return NavController1.viewControllers.lastObject.view;
}
- (UIViewController *)firstVC {
    return NavController1.viewControllers.firstObject;
}

- (UIViewController *)lastVC{
    return NavController1.viewControllers.lastObject;
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
        [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
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

//        __weakSelf_(__self);
//        void (^navPush)(UIViewController *) = ^(UIViewController *vc) {
//             // 真正在执行跳转
//            [super pushViewController:viewController animated:animated];
//        };
        //如果是黑色模板==》黑色模板  登录 注册  优惠专区
        //如果不是黑色模板==》登录 注册  优惠专区  优惠活动
        if ([viewController isKindOfClass:[UGBMRegisterViewController class]] || [viewController isKindOfClass:[UGBMLoginViewController class]]
            ||[viewController isKindOfClass:[UGRegisterViewController class]] || [viewController isKindOfClass:[UGLoginViewController class]]
            ||[viewController isKindOfClass:[UGBMpreferentialViewController class]] || [viewController isKindOfClass:[UGPromotionsController class]]
            ||[viewController isKindOfClass:[UGBMLotteryHomeViewController class]] || [viewController isKindOfClass:[UGYYLotteryHomeViewController class]]) {
            //黑色模板的登录 注册+不是黑色模板
            //登录 注册+是黑色模板
            if (([viewController isKindOfClass:[UGBMRegisterViewController class]] && !Skin1.isBlack)){
                viewController =  _LoadVC_from_storyboard_(@"UGRegisterViewController");
            }
            if (([viewController isKindOfClass:[UGRegisterViewController class]] && Skin1.isBlack)){
                viewController = _LoadVC_from_storyboard_(@"UGBMRegisterViewController");
            }
            if (([viewController isKindOfClass:[UGBMLoginViewController class]] && !Skin1.isBlack)){
                viewController = _LoadVC_from_storyboard_(@"UGLoginViewController");
            }
            if (([viewController isKindOfClass:[UGLoginViewController class]] && Skin1.isBlack)){
                viewController = _LoadVC_from_storyboard_(@"UGBMLoginViewController");
            }
            if (([viewController isKindOfClass:[UGBMpreferentialViewController class]] && !Skin1.isBlack)){
                viewController = _LoadVC_from_storyboard_(@"UGPromotionsController");
            }
            if (([viewController isKindOfClass:[UGPromotionsController class]] && Skin1.isBlack)){
                viewController = _LoadVC_from_storyboard_(@"UGBMpreferentialViewController");
            }
            if (([viewController isKindOfClass:[UGBMLotteryHomeViewController class]] && !Skin1.isBlack)){
                  viewController =  [UGYYLotteryHomeViewController new];
            }
            if (([viewController isKindOfClass:[UGYYLotteryHomeViewController class]] && Skin1.isBlack)){
                viewController =  _LoadVC_from_storyboard_(@"UGBMLotteryHomeViewController");
            }
           
        }
        
        if ([viewController isKindOfClass:[UGLHMineViewController class]] || [viewController isKindOfClass:[UGBMMemberCenterViewController class]]
            ||[viewController isKindOfClass:[UGMineSkinViewController class]] ) {
            
            if (Skin1.isLH){
                UIViewController *vc = [NavController1.viewControllers objectWithValue:UGLHMineViewController.class keyPath:@"class"];
                if (vc) {
                    [NavController1 popToViewController:vc animated:false];
                    return;
                }
                viewController =  _LoadVC_from_storyboard_(@"UGLHMineViewController");
            }
            else if (Skin1.isBlack){
                UIViewController *vc = [NavController1.viewControllers objectWithValue:UGBMMemberCenterViewController.class keyPath:@"class"];
                if (vc) {
                    [NavController1 popToViewController:vc animated:false];
                    return;
                }
                viewController = _LoadVC_from_storyboard_(@"UGBMMemberCenterViewController");
            }
            else if (!Skin1.isLH && !Skin1.isBlack){
                UIViewController *vc = [NavController1.viewControllers objectWithValue:UGMineSkinViewController.class keyPath:@"class"];
                if (vc) {
                    [NavController1 popToViewController:vc animated:false];
                    return;
                }
                viewController = _LoadVC_from_storyboard_(@"UGMineSkinViewController");
            }
        }
        
    }
    NSLog(@"NavController1= %@",NavController1);
    NSLog(@"NavController1.viewControllers= %@",NavController1.viewControllers);
    NSLog(@"lastVC= %@",NavController1.lastVC);
    NSLog(@"viewControllers.lastObject= %@",NavController1.viewControllers.lastObject);
    NSLog(@"self.navigationController= %@",self.navigationController);
    NSLog(@"self.navigationController.lastObject= %@",self.navigationController.viewControllers.lastObject);
    // 登录
    if ([NavController1.lastVC isKindOfClass:UGBMLoginViewController.class]&&[viewController isKindOfClass:[UGBMLoginViewController class]]) {
        UIViewController *vc = [NavController1.viewControllers objectWithValue:UGBMLoginViewController.class keyPath:@"class"];
        if (vc) {
            [NavController1 popToViewController:vc animated:false];
            return;
        }
    }
    else if ([NavController1.lastVC isKindOfClass:UGLoginViewController.class]&&[viewController isKindOfClass:[UGLoginViewController class]]) {
        UIViewController *vc = [NavController1.viewControllers objectWithValue:UGLoginViewController.class keyPath:@"class"];
        if (vc) {
            [NavController1 popToViewController:vc animated:false];
            return;
        }
    }
    else {
        // 真正在执行跳转
        [super pushViewController:viewController animated:animated];
    }
   
}


#pragma mark - 根据Model快捷跳转函数

- (BOOL)pushViewControllerWithGameModel:(GameModel *)model {
    if (model.game_id) {
        model.gameId = model.game_id;
    }
    
    // 去资料页
    if ([model.docType intValue] == 1) {
        [NavController1 pushViewController:[[UGDocumentVC alloc] initWithModel:model] animated:true];
        return true;
    }
    // 去二级游戏列表
    if (model.isPopup) {
        UGGameListViewController *gameListVC = [[UGGameListViewController alloc] init];
        gameListVC.game = model;
        [NavController1 pushViewController:gameListVC animated:YES];
        return true;
    }
    // 去彩票下注页、或第三方游戏页、或功能页
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:model.seriesId linkPosition:model.subId];
    
    if (!ret) {
        // 去外部链接
        if (model.url.length) {
            SLWebViewController *vc = [SLWebViewController new];
            vc.urlStr = model.url;
            [NavController1 pushViewController:vc animated:true];
            return true;
        }
    } else {
        return true;
    }
    return false;
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
            [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
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
                if (!UGLoginIsAuthorized()) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                    return true;
                }
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
//            TGWebViewController *sf = [[TGWebViewController alloc] initWithURL:[NSURL URLWithString:_NSString(@"%@/Open_prize/index.php", APP.Host)]];

            TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
            webViewVC.允许未登录访问 = true;
            webViewVC.允许游客访问 = true;
            webViewVC.url = _NSString(@"%@/Open_prize/index.php", APP.Host);
            webViewVC.webTitle = @"开奖网";
            [NavController1 pushViewController:webViewVC animated:YES];
            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"%@/Open_prize/index.php", APP.Host)]];
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
            if (SysConf.appPopupQqImg.length) {
                __block UIView *__v = _LoadView_from_nib_(@"客服AlertView");
                __v.frame = APP.Bounds;
                FastSubViewCode(__v);
                subLabel(@"微信号Label").text = @"QQ客服";
                if (SysConf.appPopupQqNum.length) {
                    subLabel(@"微信号Label").text = _NSString(@"QQ客服(%@)", SysConf.appPopupQqNum);
                }
                [subImageView(@"二维码ImageView") sd_setImageWithURL:[NSURL URLWithString:SysConf.appPopupQqImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        subImageView(@"二维码ImageView").cc_constraints.height.constant = image.height/image.width * 280;
                    }
                }];
                [subButton(@"确定Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    [__v removeFromSuperview];
                    __v = nil;
                }];
                [APP.Window addSubview:__v];
            }
            else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", SysConf.serviceQQ1)]];
            }
            break;
        }
        case 12: {
            // 微信客服
            __block UIView *__v = _LoadView_from_nib_(@"客服AlertView");
            __v.frame = APP.Bounds;
            FastSubViewCode(__v);
            subLabel(@"微信号Label").text = @"微信客服";
            if (SysConf.appPopupWechatNum.length) {
                subLabel(@"微信号Label").text = _NSString(@"微信客服(%@)", SysConf.appPopupWechatNum);
            }
            [subImageView(@"二维码ImageView") sd_setImageWithURL:[NSURL URLWithString:SysConf.appPopupWechatImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    subImageView(@"二维码ImageView").cc_constraints.height.constant = image.height/image.width * 280;
                }
            }];
            [subButton(@"确定Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                [__v removeFromSuperview];
                __v = nil;
            }];
            [APP.Window addSubview:__v];
            break;
        }
        case 13: {
            // 任务大厅
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:true];
            break;
        }
        case 14: {
            // 站内信
            [NavController1 pushViewController:[[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:true];
            break;
        }
        case 15: {
            // 签到
            [NavController1 pushViewController:[UGSigInCodeViewController new] animated:YES];
            break;
        }
        case 16: {
            // 投诉中心
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGFeedBackController") animated:YES];
            break;
        }
        default: {
            return false;
        }
    }
    return true;
}

- (BOOL)pushVCWithUserCenterItemType:(UserCenterItemType)uciType {
    switch (uciType) {
        case UCI_在线客服: {
            SLWebViewController *webViewVC = [SLWebViewController new];
            webViewVC.urlStr = SysConf.zxkfUrl;
            [NavController1 pushViewController:webViewVC animated:YES];
            return true;
        }
        case UCI_额度转换: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
            return true;
        }
        case UCI_开奖走势: {
            [HUDHelper showMsg:@"敬请期待"];
            return true;
        }
        case UCI_全民竞猜: {
            [HUDHelper showMsg:@"敬请期待"];
            return true;
        }
        case UCI_存款: {
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 0;
            [NavController1 pushViewController:fundsVC animated:YES];
            return true;
        }
        case UCI_取款: {
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 1;
            [NavController1 pushViewController:fundsVC animated:YES];
            return true;
        }
        case UCI_银行卡管理: {
            [NavController1 pushViewController:({
                UIViewController *vc = nil;
                UGUserModel *user = [UGUserModel currentUser];
                if (user.hasBankCard) {
                    vc = _LoadVC_from_storyboard_(@"UGBankCardInfoController");
                } else if (user.hasFundPwd) {
                    vc = _LoadVC_from_storyboard_(@"UGBindCardViewController");
                } else {
                    vc = _LoadVC_from_storyboard_(@"UGSetupPayPwdController");
                }
                vc;
            }) animated:YES];
            return true;
        }
        case UCI_利息宝: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
            return true;
        }
        case UCI_推荐收益: {
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
            return true;
        }
        case UCI_安全中心: {
            [NavController1 pushViewController:[UGSecurityCenterViewController new] animated:YES];
            return true;
        }
        case UCI_站内信: {
            [NavController1 pushViewController:[[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            return true;
        }
        case UCI_彩票注单记录: {
            [NavController1 pushViewController:[UGBetRecordViewController new] animated:YES];
            return true;
        }
        case UCI_其他注单记录: {
            UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
            betRecordVC.gameType = @"real";
            [NavController1 pushViewController:betRecordVC animated:YES];
            return true;
        }
        case UCI_个人信息: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGUserInfoViewController") animated:YES];
            return true;
        }
        case UCI_建议反馈: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGFeedBackController") animated:YES];
            return true;
        }
        case UCI_活动彩金: {
            [NavController1 pushViewController:[UGMosaicGoldViewController new] animated:YES];
            return true;
        }
        case UCI_长龙助手: {
            [NavController1 pushViewController:[UGChangLongController new] animated:YES];
            return true;
        }
        case UCI_任务中心: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController")  animated:YES];
            return true;
        }
            
        default:
            return false;
    }
}

@end
