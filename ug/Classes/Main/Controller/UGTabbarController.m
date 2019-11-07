//
//  UGTabbarController.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTabbarController.h"
#import "UGLotteryHomeController.h"         // 彩票大厅
#import "UGFundsViewController.h"           // 资金管理
#import "UGHomeViewController.h"            // 首页
#import "UGYYLotteryHomeViewController.h"   // 彩票大厅
#import "UGMineSkinViewController.h"        // 我的
#import "UGPromotionsController.h"          // 优惠活动
#import "UGChangLongController.h"           // 长龙助手
#import "UGLotteryRecordController.h"       // 开奖记录
#import "UGMissionCenterViewController.h"   // 任务中心
#import "UGSecurityCenterViewController.h"  // 安全中心
#import "UGMailBoxTableViewController.h"    // 站内信
#import "UGBankCardInfoController.h"        // 我的银行卡
#import "UGBindCardViewController.h"        // 银行卡管理
#import "UGYubaoViewController.h"           // 利息宝
#import "UGSigInCodeViewController.h"       // 每日签到
#import "UGPromotionIncomeController.h"     // 推广收益
#import "UGBalanceConversionController.h"   // 额度转换
#import "UGAgentViewController.h"           // 申请代理
#import "UGBMMemberCenterViewController.h"  // 黑色模板会员中心
#import "UGBMpreferentialViewController.h"  // 黑色模板优惠专区

#import "UGSystemConfigModel.h"
#import "UGAppVersionManager.h"

#import "cc_runtime_property.h"


@implementation UIViewController (CanPush)

_CCRuntimeProperty_Assign(BOOL, 允许未登录访问, set允许未登录访问)
_CCRuntimeProperty_Assign(BOOL, 允许游客访问, set允许游客访问)
@end





@interface UGTabbarController ()<UITabBarControllerDelegate>

@property (nonatomic, copy) NSArray<UGmobileMenu *> *gms;
@end

@implementation UGTabbarController

static UGTabbarController *_tabBarVC = nil;

+ (instancetype)shared {
    return _tabBarVC;
}

+ (BOOL)canPushToViewController:(UIViewController *)vc {
    UGUserModel *user = [UGUserModel currentUser];
    BOOL isLogin = UGLoginIsAuthorized();
    
    // 未登录禁止访问
    if (!isLogin && !vc.允许未登录访问) {
        NSLog(@"未登录禁止访问：%@", vc);
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
        return false;
    }
    
    // 游客禁止访问
    if (user.isTest && !vc.允许游客访问) {
        NSLog(@"游客禁止访问：%@", vc);
        UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];
        [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
            SANotificationEventPost(UGNotificationShowLoginView, nil);
        }];
        return false;
    }
    
    if (user) {
        // 聊天室
        if ([vc isKindOfClass:[UGChatViewController class]] && !user.chatRoomSwitch) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"聊天室已关闭" btnTitles:@[@"确定"]];
            return false;
        }
        
        // 任务中心
        else if ([vc isKindOfClass:[UGMissionCenterViewController class]] && [SysConf.missionSwitch isEqualToString:@"1"]) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"任务中心已关闭" btnTitles:@[@"确定"]];
            return false;
        }
        // 利息宝
        else if ([vc isKindOfClass:[UGYubaoViewController class]] && !user.yuebaoSwitch) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"利息宝已关闭" btnTitles:@[@"确定"]];
            return false;
        }
        // 每日签到
        else if ([vc isKindOfClass:[UGSigInCodeViewController class]] && [SysConf.checkinSwitch isEqualToString:@"0"]) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"每日签到已关闭" btnTitles:@[@"确定"]];
            return false;
        }
    }
    
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tabBarVC = self;
    _gms = @[
        [UGmobileMenu menu:@"/home"            :@"首页" :@"shouye" :@"shouyesel"         :[UGHomeViewController class]],
        [UGmobileMenu menu:@"/changLong"       :@"长龙助手" :@"changlong" :@"changlong"    :[UGChangLongController class]],
        [UGmobileMenu menu:@"/lotteryList"     :@"彩票大厅" :@"dating" :@"datongsel"       :[UGYYLotteryHomeViewController class]],
        [UGmobileMenu menu:@"/activity"        :@"优惠活动" :@"youhui1" :@"youhui1sel"     :[UGPromotionsController class]],
        [UGmobileMenu menu:@"/chatRoomList"    :@"聊天室" :@"liaotian" :@"liaotiansel"    :[UGChatViewController class]],
        [UGmobileMenu menu:@"/lotteryRecord"   :@"开奖记录" :@"zdgl" :@"zdgl"              :[UGLotteryRecordController class]],
        [UGmobileMenu menu:@"/user"            :@"我的" :@"wode" :@"wodesel"             :[UGMineSkinViewController class]],
        [UGmobileMenu menu:@"/user2"            :@"我的" :@"wode" :@"wodesel"             :[UGBMMemberCenterViewController class]],
        [UGmobileMenu menu:@"/task"            :@"任务中心" :@"renwu" :@"renwusel"         :[UGMissionCenterViewController class]],
        [UGmobileMenu menu:@"/securityCenter"  :@"安全中心" :@"ziyuan" :@"ziyuan"          :[UGSecurityCenterViewController class]],
        [UGmobileMenu menu:@"/funds"           :@"资金管理" :@"jinlingyingcaiwangtubiao" :@"jinlingyingcaiwangtubiaosel" :[UGFundsViewController class]],
        [UGmobileMenu menu:@"/message"         :@"站内信" :@"zhanneixin" :@"zhanneixin"   :[UGMailBoxTableViewController class]],
        [UGmobileMenu menu:@"/conversion"      :@"额度转换" :@"change" :@"change"          :[UGBalanceConversionController class]],
        [UGmobileMenu menu:@"/banks"           :@"银行卡" :@"yinhangqia" :@"yinhangqia"   :[UGBindCardViewController class]],
        [UGmobileMenu menu:@"/yuebao"          :@"利息宝" :@"lixibao" :@"lixibao"         :[UGYubaoViewController class]],
        [UGmobileMenu menu:@"/Sign"            :@"签到" :@"qiandao" :@"qiandaosel"       :[UGSigInCodeViewController class]],
        [UGmobileMenu menu:@"/referrer"        :@"推荐收益" :@"shouyi1" :@"shouyi1sel"     :[UGPromotionIncomeController class]],
        [UGmobileMenu menu:@"/暂无"             :@"申请代理" :@"shouyi1" :@"shouyi1sel"     :[UGAgentViewController class]],
    ];
    
    self.delegate = self;
    
    // 设置初始控制器
    [self resetUpChildViewController:@[@"/home", @"/lotteryList", @"/chatRoomList", @"/activity", @"/user", ]];
    
    // 更新为后台配置的控制器
    [self getSystemConfig];

    
//    SANotificationEventSubscribe(UGNotificationWithResetTabSuccess, self, ^(typeof (self) self, id obj) {
//         [self resetUpChildViewController];
//    });
    
    //    版本更新
    [[UGAppVersionManager shareInstance] updateVersionApi:false];
    [self setTabbarStyle];
    
    
    // 更新黑色模板状态栏
    [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
        UIStackView *sv = [TabBarController1.tabBar viewWithTagString:@"描边StackView"];
        if (!sv) {
            sv = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 65)];
            sv.axis = UILayoutConstraintAxisHorizontal;
            sv.distribution = UIStackViewDistributionFillEqually;
            sv.spacing = -0.75;
            sv.tagString = @"描边StackView";
            for (int i=0; i<5; i++) {
                UIView *v = [UIView new];
                v.layer.borderWidth = 0.7;
                v.layer.borderColor = APP.TextColor2.CGColor;
                v.backgroundColor = [UIColor clearColor];
                [sv addArrangedSubview:v];
            }
            sv.userInteractionEnabled = false;
            [TabBarController1.tabBar addSubview:sv];
        }
        for (UIView *v in sv.arrangedSubviews) {
            v.hidden = !([sv.arrangedSubviews indexOfObject:v] < TabBarController1.tabBar.items.count);
        }
        BOOL black = [Skin1.skitType isEqualToString:@"黑色模板"];
        sv.hidden = !black;
        [TabBarController1 setTabbarHeight:black ? 53 : 49];
    }];
}

- (void)setTabbarStyle {
    void (^block1)(NSNotification *) = ^(NSNotification *noti) {
        [TabBarController1.tabBar setBackgroundImage:[UIImage imageWithColor:Skin1.tabBarBgColor]];
        [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:Skin1.tabBarBgColor]];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:Skin1.navBarBgColor] forBarMetrics:UIBarMetricsDefault];
        
        for (UGNavigationController *nav in TabBarController1.viewControllers) {
            [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:Skin1.navBarBgColor] forBarMetrics:UIBarMetricsDefault];
        }
    };
    [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:block1];
    block1(nil);
    
    [self.tabBar setSelectedImageTintColor: Skin1.tabSelectedColor];
    [self.tabBar setUnselectedItemTintColor:Skin1.tabNoSelectColor];
    [[UITabBar appearance] setSelectedImageTintColor: Skin1.tabSelectedColor];
    [[UITabBar appearance] setUnselectedItemTintColor:Skin1.tabNoSelectColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabNoSelectColor} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabSelectedColor} forState:UIControlStateSelected];
    for (UIBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabNoSelectColor} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabSelectedColor} forState:UIControlStateSelected];
    }
    
    for (UGNavigationController *nav in TabBarController1.viewControllers) {
        UIView *stateView = [nav.navigationBar viewWithTagString:@"状态栏背景View"];
        if (!stateView) {
            stateView = [[UIView alloc] initWithFrame:CGRectMake(0, -k_Height_StatusBar, UGScreenW, k_Height_StatusBar)];
            stateView.tagString = @"状态栏背景View";
            [nav.navigationBar addSubview:stateView];
            stateView.backgroundColor = Skin1.navBarBgColor;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//   return UIStatusBarStyleLightContent = 1 //白色文字，深色背景时使用
}

- (void)setTabbarHeight:(CGFloat)height {
    static CGFloat __height = 50;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UITabBar aspect_hookSelector:@selector(sizeThatFits:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
            CGSize size = CGSizeZero;
            [ai.originalInvocation getReturnValue:&size];
            size.height = __height;
            [ai.originalInvocation invoke];
            [ai.originalInvocation setReturnValue:&size];
        } error:nil];
    });
    __height = height + APP.BottomSafeHeight;
    [self.view layoutSubviews];
    [self.selectedViewController.view layoutSubviews];
}


#pragma mark - 获得系统设置

- (void)getSystemConfig {

    [SVProgressHUD showWithStatus: nil];
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            
            [self setTabbarStyle];
            
            [[UGSkinManagers skinWithSysConf] useSkin];
            
            NSArray<UGmobileMenu *> *menus = [[UGmobileMenu arrayOfModelsFromDictionaries:SysConf.mobileMenu error:nil] sortedArrayUsingComparator:^NSComparisonResult(UGmobileMenu *obj1, UGmobileMenu *obj2) {
                return obj1.sort > obj2.sort;
            }];
            [self resetUpChildViewController:[menus valuesWithKeyPath:@"path"]];
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

/**
 *  添加子控制器
 */
- (void)resetUpChildViewController:(NSArray<NSString *> *)paths {
    NSMutableArray *vcs = [NSMutableArray new];
    for (NSString *path in paths) {
        UGmobileMenu *gm = [_gms objectWithValue:path keyPath:@"path"];
        
        // 优惠活动展示在首页
        if (gm.cls == [UGPromotionsController class] && SysConf.m_promote_pos)
            continue;
        
        // 已存在的控制器不需要重新初始化
        BOOL existed = false;
        for (UINavigationController *nav in self.viewControllers) {
            if ([nav.viewControllers.firstObject isKindOfClass:gm.cls]) {
                [vcs addObject:nav];
                existed = true;
                break;
            }
        }
        if (existed)
            continue;
        
        // 初始化新的控制器
        UIViewController *vc = _LoadVC_from_storyboard_(NSStringFromClass(gm.cls));
        if (!vc)
            vc = [gm.cls new];
        vc.tabBarItem.title = gm.name;
        vc.tabBarItem.image = [UIImage imageNamed:gm.icon];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:gm.selectedIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UGNavigationController *nav = [[UGNavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:nav];
    }
    if (vcs.count > 2) {
        self.viewControllers = vcs;
        [self setTabbarStyle];
    }
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    UIViewController *vc = ((UINavigationController *)viewController).viewControllers.firstObject;

    __weakSelf_(__self);
    void (^push)(NSString *, UIViewController *) = ^(NSString *name, UIViewController *vc) {
        // 初始化控制器
        UGmobileMenu *gm = [__self.gms objectWithValue:name keyPath:@"name"];
        vc.tabBarItem.title = gm.name;
        vc.tabBarItem.image = [UIImage imageNamed:gm.icon];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:gm.selectedIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        ((UINavigationController *)viewController).viewControllers = @[vc];
        tabBarController.selectedViewController = viewController;
    };
    //如果是黑色模板或者其他模板：我的 和 黑色模板的我的 进行判断
    if (UGLoginIsAuthorized()
          && ([vc isKindOfClass:[UGMineSkinViewController class]] || [vc isKindOfClass:[UGBMMemberCenterViewController class]]
              ||[vc isKindOfClass:[UGBMpreferentialViewController class]] || [vc isKindOfClass:[UGPromotionsController class]])) {
        //黑色模板的我的+不是黑色模板
        //我的+是黑色模板
        if (([vc isKindOfClass:[UGBMMemberCenterViewController class]] && ![Skin1.skitType isEqualToString:@"黑色模板"])){
            push(@"我的", [UGMineSkinViewController new]);
            return false;
        }
        if ([vc isKindOfClass:[UGMineSkinViewController class]] && [Skin1.skitType isEqualToString:@"黑色模板"]) {
            push(@"我的", _LoadVC_from_storyboard_(@"UGBMMemberCenterViewController"));
            return false;
        }
        if (([vc isKindOfClass:[UGBMpreferentialViewController class]] && ![Skin1.skitType isEqualToString:@"黑色模板"])){
            push(@"优惠活动", _LoadVC_from_storyboard_(@"UGPromotionsController"));
                       return false;
        }
        if (([vc isKindOfClass:[UGPromotionsController class]] && [Skin1.skitType isEqualToString:@"黑色模板"])){
            push(@"优惠活动", _LoadVC_from_storyboard_(@"UGBMpreferentialViewController"));
            return false;
        }
       
    }
    
    if (UGLoginIsAuthorized()
        && ([vc isKindOfClass:[UGPromotionIncomeController class]] || [vc isKindOfClass:[UGAgentViewController class]])) {
        // 试玩账号直接去推荐收益
        if (UserI.isTest) {
            push(@"推荐收益", [UGPromotionIncomeController new]);
            return false;
        }
        
        // 去推荐收益前判断如果用户不是代理，应该去申请代理页面
        // 去申请代理前判断如果用户是代理，应该去推荐收益页面
        if (([vc isKindOfClass:[UGPromotionIncomeController class]] && !UserI.isAgent) ||
            ([vc isKindOfClass:[UGAgentViewController class]] && UserI.isAgent)) {
            
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD dismiss];
                    UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                    int intStatus = obj.reviewStatus.intValue;

                    //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                    if (intStatus == 2) {
                        push(@"推荐收益", [UGPromotionIncomeController new]);
                    } else {
                        if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                            [HUDHelper showMsg:@"在线注册代理已关闭"];
                            return ;
                        }
                        push(@"申请代理", ({
                            UGAgentViewController *vc = [UGAgentViewController new];
                            vc.item = obj;
                            vc;
                        }));
                    }
                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
            return false;
        }
    }
    
    // push权限判断
    return [UGTabbarController canPushToViewController:vc];
}

@end
