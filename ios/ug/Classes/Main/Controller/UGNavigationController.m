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
#import "JYRegisterViewController.h"            // 黑色模板注册
#import "JYLoginViewController.h"                // 简约模板登录
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
#import "LotteryBetAndChatVC.h"
#import "UGBalanceConversionController.h"//额度转换


// Tools
#import "UGAppVersionManager.h"
#import "NSObject+RnKeyValues.h"
#import "ReactNativeHelper.h"


@interface UGNavigationController ()

@end

@implementation UGNavigationController

static NSMutableArray <GameModel *> *__browsingHistoryArray = nil;

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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 去RN页面
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:viewController.className keyPath:@"clsName"];
    if (rpm) {
        ReactNativeVC *vc = [ReactNativeVC shared:rpm params:[viewController rn_keyValues]];
        vc.hidesBottomBarWhenPushed = true;
        // push权限判断
        if (!self.viewControllers.count || [UGTabbarController canPushToViewController:vc]) {
            [super pushViewController:vc animated:animated];
        }
        return;
    }
    
    // push权限判断
    if (self.viewControllers.count && ![UGTabbarController canPushToViewController:viewController])
        return;
    
    // 判断下是否是非根控制器
    if (self.childViewControllers.count) { // 不是根控制器
        
        
        if ([viewController isKindOfClass:[UGBalanceConversionController class]]) {
            
            if (APP.oldConversion) {
                 viewController =  _LoadVC_from_storyboard_(@"LineConversionHeaderVC");
            } 
        }
        
        
        if ([viewController isKindOfClass:[UGBMRegisterViewController class]]
            ||[viewController isKindOfClass:[UGRegisterViewController class]]
            ||[viewController isKindOfClass:[JYRegisterViewController class]] ) {
            
            if (!Skin1.isBlack && !Skin1.isJY){
                if (![viewController isKindOfClass:[UGRegisterViewController class]]) {
                    viewController =  _LoadVC_from_storyboard_(@"UGRegisterViewController");
                }
                
            }
            if (Skin1.isBlack){//黑色模板  注册
                if (![viewController isKindOfClass:[UGBMRegisterViewController class]]) {
                    viewController = _LoadVC_from_storyboard_(@"UGBMRegisterViewController");
                }
                
            }
            if (Skin1.isJY){//简约模板  注册
                if (![viewController isKindOfClass:[JYRegisterViewController class]]) {
                    viewController = _LoadVC_from_storyboard_(@"JYRegisterViewController");
                }
                
            }
        }
        
        if ([viewController isKindOfClass:[UGBMLoginViewController class]]
            ||[viewController isKindOfClass:[UGLoginViewController class]]
            ||[viewController isKindOfClass:[JYLoginViewController class]] ) {
            
            if (!Skin1.isBlack && !Skin1.isJY){
                if (![viewController isKindOfClass:[UGLoginViewController class]]) {
                    viewController =  _LoadVC_from_storyboard_(@"UGLoginViewController");
                }
                
            }
            if (Skin1.isBlack){//黑色模板  登录
                if (![viewController isKindOfClass:[UGBMLoginViewController class]]) {
                    viewController = _LoadVC_from_storyboard_(@"UGBMLoginViewController");
                }
                
            }
            if (Skin1.isJY){//简约模板  登录
                if (![viewController isKindOfClass:[JYLoginViewController class]]) {
                    viewController = _LoadVC_from_storyboard_(@"JYLoginViewController");
                }
                
            }
        }
        
        if ([viewController isKindOfClass:[UGBMpreferentialViewController class]]
            || [viewController isKindOfClass:[UGPromotionsController class]]) {
            
            if (Skin1.isBlack ){
                if (![viewController isKindOfClass:[UGBMpreferentialViewController class]]) {
                    viewController =  _LoadVC_from_storyboard_(@"UGBMpreferentialViewController");
                }
                
            }
            else{
                if (![viewController isKindOfClass:[UGPromotionsController class]]) {
                    viewController =  _LoadVC_from_storyboard_(@"UGPromotionsController");
                }
                
            }
        }
        if ([viewController isKindOfClass:[UGBMLotteryHomeViewController class]]
            || [viewController isKindOfClass:[UGYYLotteryHomeViewController class]]) {
            
            if (Skin1.isBlack ){
                if (![viewController isKindOfClass:[UGBMLotteryHomeViewController class]]) {
                    viewController =  _LoadVC_from_storyboard_(@"UGBMLotteryHomeViewController");
                }
                
            }
            else{
                if (![viewController isKindOfClass:[UGYYLotteryHomeViewController class]]) {
                    viewController =  [UGYYLotteryHomeViewController new];
                }
                
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
    
    
//    NSLog(@"NavController1= %@",NavController1);
//    NSLog(@"NavController1.viewControllers= %@",NavController1.viewControllers);
//    NSLog(@"lastVC= %@",NavController1.lastVC);
//    NSLog(@"viewControllers.lastObject= %@",NavController1.viewControllers.lastObject);
//    NSLog(@"self.navigationController= %@",self.navigationController);
//    NSLog(@"self.navigationController.lastObject= %@",self.navigationController.viewControllers.lastObject);
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
    else if ([NavController1.lastVC isKindOfClass:JYLoginViewController.class]&&[viewController isKindOfClass:[JYLoginViewController class]]) {
        UIViewController *vc = [NavController1.viewControllers objectWithValue:JYLoginViewController.class keyPath:@"class"];
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

@end
