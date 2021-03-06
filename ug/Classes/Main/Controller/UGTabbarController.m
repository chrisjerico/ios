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
#import "UGYYLotteryHomeViewController.h"   // 购彩大厅
#import "UGMineSkinViewController.h"        // 我的
#import "UGPromotionsController.h"          // 优惠活动
#import "UGChangLongController.h"           // 长龙助手
#import "UGLotteryRecordController.h"       // 开奖记录
#import "UGMissionCenterViewController.h"   // 任务中心
#import "UGSecurityCenterViewController.h"  // 安全中心
#import "UGBankCardInfoController.h"        // 我的银行卡
#import "UGBindCardViewController.h"        // 银行卡管理
#import "UGYubaoViewController.h"           // 利息宝
#import "UGSigInCodeViewController.h"       // 每日签到
#import "UGPromotionIncomeController.h"     // 推广收益
//#import "UGBalanceConversionController.h"   // 额度转换
#import "UGAgentViewController.h"           // 申请代理
#import "UGBMMemberCenterViewController.h"  // GPK版会员中心
#import "UGBMpreferentialViewController.h"  // GPK版优惠专区
#import "UGBMLotteryHomeViewController.h"   // GPK版购彩大厅
#import "UGYYLotteryHomeViewController.h"   // 购彩大厅
#import "UGBMLoginViewController.h"         // GPK版登录页
#import "LotteryBetAndChatVC.h"             // 聊天室
#import "UGBetRecordViewController.h"       // 投注记录
#import "UGYYLotterySecondHomeViewController.h"
//======================================================
#import "UGLHMineViewController.h"         // 六合模板我的
#import "UGSystemConfigModel.h"
#import "UGAppVersionManager.h"
#import "UGMessagePopView.h"
#import "cc_runtime_property.h"
#import "UGMessageModel.h"

#import "FLAnimatedImageView.h"
#import "UITabBar+CustomBadge.h"
#import "UGUserModel.h"

#import "CMTimeCommon.h"
#import "RoomChatModel.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"
#import "UITabBarItem+WebCache.h"

#import "MultiTabbar.h"

#import "TZImagePickerController.h"

@implementation UIViewController (CanPush)

_CCRuntimeProperty_Assign(BOOL, 允许未登录访问, set允许未登录访问)
_CCRuntimeProperty_Assign(BOOL, 允许游客访问, set允许游客访问)
@end




@interface ReactNativeVC ()
@property (nonatomic, strong) RnPageModel *rpm;
@end

@interface UGTabbarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) MultiTabbar *customTabbar;

@property (nonatomic, strong) NSMutableArray<UGMobileMenu *> *mms;
@property (nonatomic, copy) NSString *fixedItemPaths;   // 固定在底部的页面，不会被替换
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
        Class cls = vc.class;
        if ([vc isKindOfClass:ReactNativeVC.class]) {
            cls = NSClassFromString(((ReactNativeVC *)vc).rpm.vcName);
        }
        // 聊天室
        if ((cls == UGChatViewController.class || cls == LotteryBetAndChatVC.class) && !user.chatRoomSwitch) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"尚未开启聊天室" btnTitles:@[@"确定"]];
            return false;
        }
        
        // 任务中心
        else if (cls == UGMissionCenterViewController.class && [SysConf.missionSwitch isEqualToString:@"1"]) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"任务中心已关闭" btnTitles:@[@"确定"]];
            return false;
        }
        // 利息宝
        else if (cls == UGYubaoViewController.class && !user.yuebaoSwitch) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"尚未开启利息宝" btnTitles:@[@"确定"]];
            return false;
        }
        // 每日签到
        else if (cls == UGSigInCodeViewController.class && [SysConf.checkinSwitch isEqualToString:@"0"]) {
            [AlertHelper showAlertView:@"温馨提示" msg:@"每日签到已关闭" btnTitles:@[@"确定"]];
            return false;
        }
    }
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tabBarVC = self;
    self.delegate = self;
    
    // 定时拉取站内信消息
    [self beginMessageRequest];
    
    __weakSelf_(__self);
    {
        // 自定义底部Tabbar，实现超5个item（实际上还是5个，页面会显示多个，点击时挑一个页面替换掉）
        _fixedItemPaths = @"/home";
        NSMutableArray *temp = @[].mutableCopy;
        [self.tabBar addSubview:_customTabbar = _LoadView_from_nib_(@"MultiTabbar")];
        _customTabbar.didClick = ^BOOL (UGMobileMenu * _Nonnull selectedMM, NSInteger idx) {
            if (OBJOnceToken(__self))
                [temp setArray:__self.mms];
            if ([__self.mms containsValue:selectedMM.path keyPath:@"path"]) {
                return [__self customSelectedIndex:[__self.mms indexOfValue:selectedMM.path keyPath:@"path"]];
            }
            
            // 除了固定页面之外，从最早创建的页面开始替换
            for (UGMobileMenu *mm in [temp copy]) {
                if ([__self.fixedItemPaths containsString:mm.path]) continue;
                
                NSInteger idx = [__self.mms indexOfObject:mm];
                [__self.mms removeObjectAtIndex:idx];
                [__self.mms insertObject:selectedMM atIndex:idx];
                [temp removeObjectAtIndex:[temp indexOfObject:mm]];
                [temp addObject:selectedMM];
                return [__self customSelectedIndex:idx];
                break;
            }
            return false;
        };
        [self.tabBar aspect_hookSelector:@selector(didAddSubview:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo>ai) {
            [__self.tabBar bringSubviewToFront:__self.customTabbar];
        } error:nil];
    }
    
    // 注册成功
    SANotificationEventSubscribe(UGNotificationRegisterComplete, self, ^(typeof (self) self, id obj) {
        [self performSelector:@selector(loadMessageList) withObject:nil/*可传任意类型参数*/ afterDelay:5.0];
    });
    // 免费试玩
    SANotificationEventSubscribe(UGNotificationTryPlay, self, ^(typeof (self) self, id obj) {
        [CMCommon clearWebCache];
        [CMCommon deleteWebCache];
        [CMCommon removeLastGengHao];
        
        NSDictionary *params = @{@"usr":@"46da83e1773338540e1e1c973f6c8a68",
                                 @"pwd":@"46da83e1773338540e1e1c973f6c8a68"
        };
        [SVProgressHUD showWithStatus:nil];
   
        [CMNetwork guestLoginWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                
                [SVProgressHUD showSuccessWithStatus:model.msg];
                UGUserModel *user = model.data;
                UGUserModel.currentUser = user;
                SANotificationEventPost(UGNotificationLoginComplete, nil);
                
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
    // 去登录
    [self xw_addNotificationForName:UGNotificationShowLoginView block:^(NSNotification * _Nonnull noti) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
    }];
    // 登录成功
    SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
        [CMCommon deleteWebCache];
        [CMCommon clearWebCache];
        [CMCommon removeLastGengHao];
        [__self getUserInfo];
        [__self chatgetToken];
        // 通知RN
        [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
            [ReactNativeHelper sendEvent:UGNotificationLoginComplete params:UserI];
        }];
        // 切换语言
        [NetworkManager1 language_getConfigs].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            LanguageModel *lm = [LanguageModel mj_objectWithKeyValues:sm.resObject[@"data"]];
            [LanguageHelper shared].supportLanguagesMap = lm.supportLanguagesMap;
            if (![[lm getLanCode] isEqualToString:[LanguageHelper shared].lanCode]) {
                [LanguageHelper changeLanguageAndRestartApp:[lm getLanCode]];
            }
        };
        
        if ([SysConf.loginNotice.loginNotice_switch isEqualToString:@"1"]) {
            
            if (![CMCommon stringIsNull:SysConf.loginNotice.loginNotice_text]) {
                UGMessagePopView *popView = [[UGMessagePopView alloc] initWithFrame:CGRectMake(0, 0, 350, 260)];
                popView.closeBlock = ^{
                        [LEEAlert closeWithCompletionBlock:nil];
                    };
             
                [LEEAlert alert].config
                .LeeTitle(@"提示")
                .LeeAddCustomView(^(LEECustomView *custom) {

                    popView.content = SysConf.loginNotice.loginNotice_text;
                    custom.view = popView;
                    custom.positionType = LEECustomViewPositionTypeCenter;
                })
                .LeeAction(@"确定", ^{
                })
                .LeeShow();
            }
       
        }
    });
    // 退出登陆
    SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
        [UGUserModel setCurrentUser:nil];
        
        [NavController1 popToRootViewControllerAnimated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TabBarController1 setSelectedIndex:0];
        });
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"roomName"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"roomId"];
        [CMCommon clearWebCache];
        [CMCommon deleteWebCache];
        [CMCommon removeLastGengHao];
        
        // 清楚FB
        NSInteger slot = 0;
        [SUCache deleteItemInSlot:slot];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
        // 通知RN
        [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
            [ReactNativeHelper sendEvent:UGNotificationUserLogout params:UserI];
        }];
        // 切换语言
        [NetworkManager1 language_getConfigs].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            LanguageModel *lm = [LanguageModel mj_objectWithKeyValues:sm.resObject[@"data"]];
            [LanguageHelper shared].supportLanguagesMap = lm.supportLanguagesMap;
            if (![[lm getLanCode] isEqualToString:[LanguageHelper shared].lanCode]) {
                [LanguageHelper changeLanguageAndRestartApp:[lm getLanCode]];
            }
        };
    });
    // 登录超时
    SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
        // onceToken 函数的作用是，限制为只弹一次框，修复弹框多次的bug
        if (OBJOnceToken(UGUserModel.currentUser)) {
            UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"您的账号已经登录超时，请重新登录。" btnTitles:@[@"确定"]];
            [ac setActionAtTitle:@"确定" handler:^(UIAlertAction *aa) {
                SANotificationEventPost(UGNotificationUserLogout, nil);
                UGUserModel.currentUser = nil;
                [TabBarController1 setSelectedIndex:0];
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
            }];
        }
    });
    // 获取用户信息
    SANotificationEventSubscribe(UGNotificationGetUserInfo, self, ^(typeof (self) self, id obj) {
        [__self getUserInfo];
    });
    
    
    // 更新GPK版Tabbar高度
    [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
        [TabBarController1 setTabbarHeight:Skin1.isGPK ? 53 : 50];
        
    }];
    
    {
        NSArray<UGMobileMenu *> *menus = [[UGMobileMenu arrayOfModelsFromDictionaries:SysConf.mobileMenu error:nil] sortedArrayUsingComparator:^NSComparisonResult(UGMobileMenu *obj1, UGMobileMenu *obj2) {
            return obj1.sort > obj2.sort;
        }];
        if (menus.count > 2) {
            // 后台配置的页面
            [self resetUpChildViewController:menus];
        } else {
            // 默认加载的页面
            NSMutableArray *temp = @[].mutableCopy;
            for (UGMobileMenu *mm in UGMobileMenu.allMenus) {
                if ([@"/home,/lotteryList,/chatRoomList,/activity,/user" containsString:mm.path]) {
                    [temp addObject:mm];
                }
            }
            [self resetUpChildViewController:temp];
        }
    }
    
    [self setTabbarStyle];

    
//    [self chatgetToken];
    
    [self getAllNextIssueData]; // 彩票大厅数据
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat h = APP.Height - [self.tabBar convertRect:self.tabBar.bounds toView:APP.Window].origin.y;
    _customTabbar.frame = CGRectMake(0, 0, APP.Width, h);
    [self.tabBar addSubview:_customTabbar];
}

- (void)setTabbarStyle {
    // TZImagePickerController相册导航条背景色
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [TZImagePickerController cc_hookSelector:@selector(initWithMaxImagesCount:delegate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            UINavigationController *nav = ai.instance;
            [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:Skin1.navBarBgColor size:APP.Size] forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.navBarTitleColor}];
        } error:nil];
    });
    
    void (^block1)(NSNotification *) = ^(NSNotification *noti) {
        // 这两句话在弹出系统相册的UI时会显示异常
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:Skin1.navBarBgColor size:APP.Size] forBarMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.navBarTitleColor}];
        
        for (UGNavigationController *nav in TabBarController1.viewControllers) {
            [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:Skin1.navBarBgColor size:APP.Size] forBarMetrics:UIBarMetricsDefault];
             [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.navBarTitleColor}];
        }
    };
    if (OBJOnceToken(self)) {
        [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:block1];
    }
    block1(nil);
    
    
    
    {
        static UIView *__stateView = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, APP.StatusBarHeight)];
            __stateView.backgroundColor = Skin1.navBarBgColor;
            __stateView.tagString = @"状态栏背景View";
            [self.view addSubview:__stateView];
            for (Class cls in @[QDWebViewController.class, UGBMLoginViewController.class]) {
                [cls cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
                    __stateView.hidden = true;
                } error:nil];
                [cls cc_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
                    __stateView.hidden = false;
                } error:nil];
            }
        });
        SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
            __stateView.backgroundColor = Skin1.navBarBgColor;
        });
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //   return UIStatusBarStyleLightContent = 1 //白色文字，深色背景时使用
}

- (void)setTabbarHeight:(CGFloat)height {
    //	if (@available(iOS 11.0, *) && ![UIDevice currentDevice].isSimulator) {
    if ((@available(iOS 11.0, *)) && !(TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1)) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UITabBar cc_hookSelector:@selector(sizeThatFits:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
                CGSize size = CGSizeZero;
                [ai.originalInvocation invoke];
                [ai.originalInvocation getReturnValue:&size];
                size.height = 50 + APP.BottomSafeHeight;
                [ai.originalInvocation setReturnValue:&size];
            } error:nil];
        });
        [self.view layoutSubviews];
        [self.selectedViewController.view layoutSubviews];
        self.customTabbar.frame = self.tabBar.bounds;
    }
}

/**
 *  添加子控制器
 */
- (void)resetUpChildViewController:(NSArray<UGMobileMenu *> *)menus {
    NSMutableArray <UIViewController *>*vcs = [NSMutableArray new];
    NSMutableArray *mms = @[].mutableCopy;
    NSMutableArray *currentVCs = self.viewControllers.mutableCopy;
    for (int i=0; i<5; i++) {
        UGMobileMenu *mm = i < menus.count ? menus[i] : [UGMobileMenu.allMenus objectWithValue:@"/qpdz" keyPath:@"path"];
        // 判断优惠活动展示在首页还是内页（c001显示在内页）
//        if ([mm.clsName isEqualToString:[UGPromotionsController className]] && SysConf.m_promote_pos && ![APP.SiteId isEqualToString:@"c001"] && !Skin1.isGPK)
//            continue;
        
        // 已存在的控制器不需要重新初始化
        BOOL existed = false;
        for (UINavigationController *nav in currentVCs) {
            if ([nav.viewControllers.firstObject isKindOfClass:NSClassFromString(mm.clsName)]) {
                [vcs addObject:nav];
                [mms addObject:mm];
                [currentVCs removeObject:nav];
                existed = true;
                break;
            }
        }
        if (existed) continue;
        
        // 初始化控制器
        // （这里加载了一个假的控制器，在 tabBarController:shouldSelectViewController: 函数才会加载真正的控制器）
        UIViewController *vc = [UIViewController new];
        vc.title = mm.name;
        UGNavigationController *nav = [[UGNavigationController alloc] initWithRootViewController:vc];
        nav.view.backgroundColor = Skin1.bgColor;
        nav.tabBarItem.title = mm.name;
        nav.title = mm.name;
        [vcs addObject:nav];
        [mms addObject:mm];
    }
    if (!_mms || vcs.count > 2) {
        self.mms = mms;
        self.customTabbar.items = menus;
        self.viewControllers = vcs;
        [self setTabbarStyle];
        [self tabBarController:self shouldSelectViewController:vcs.firstObject];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [_customTabbar setSelectedIndex:selectedIndex willCallback:true];
}

- (BOOL)customSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex < self.viewControllers.count) {
        if ([self tabBarController:self shouldSelectViewController:self.viewControllers[selectedIndex]]) {
            // 修复切换SelectedIndex后tabBar不显示bug
            UINavigationController *currentNav = self.selectedViewController;
            UINavigationController *nextNav = self.viewControllers[selectedIndex];
            if (currentNav.topViewController.hidesBottomBarWhenPushed) {
                if (!nextNav.topViewController.hidesBottomBarWhenPushed) {
                    [nextNav pushViewController:currentNav.topViewController animated:false];
                    [nextNav popToRootViewControllerAnimated:true];
                    [super setSelectedIndex:selectedIndex];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super setSelectedIndex:selectedIndex];
            });
            return true;
        }
    }
    return false;
}


#pragma mark -

- (void)getUserInfo {
    if (!UGLoginIsAuthorized()) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            SANotificationEventPost(UGNotificationGetUserInfoComplete, nil);
        } failure:^(id msg) {
            SANotificationEventPost(UGNotificationGetUserInfoComplete, nil);
            if (model.msg.length) {
                [SVProgressHUD showErrorWithStatus:model.msg];
                return ;
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //	NSLog(@"viewController = %@",viewController);
    //	NSLog(@"_mms = %@",_mms);
    UGMobileMenu *mm = _mms[[tabBarController.viewControllers indexOfObject:viewController]];
    NSLog(@"mm = %@",mm);
    // 由 UGMobileMenu控制显示的ViewController
    UIViewController *vc = ((UINavigationController *)viewController).viewControllers.firstObject;
    NSLog(@"vc = %@",vc);
    
    BOOL isDifferentRPM = false;
    if ([vc isKindOfClass:ReactNativeVC.class] && [vc.className isEqualToString:mm.clsName]) {
        RnPageModel *rpm = [APP.rnPageInfos objectWithValue:mm.path keyPath:@"tabbarItemPath"];
        isDifferentRPM = ![((ReactNativeVC *)vc) isEqualRPM:rpm];
        if (!isDifferentRPM) {
            if ([UGTabbarController canPushToViewController:({
                UIViewController *temp = [UIViewController new];
                temp.允许游客访问 = rpm.允许游客访问;
                temp.允许未登录访问 = rpm.允许未登录访问;
                temp;
            })]) {
                [(ReactNativeVC *)vc  pushOrJump:false rpm:rpm params:[vc rn_keyValues]];
                return true;
            }
            return false;
        }
    }
    
    // 真人视讯、棋牌电子、电竞、电子、棋牌、捕鱼
    BOOL isDifferentGameList = [vc isKindOfClass:UGYYLotterySecondHomeViewController.class] && ![vc.title isEqualToString:mm.name];
    
    // 控制器需要重新加载
    if (isDifferentRPM || isDifferentGameList || ![vc.className isEqualToString:mm.clsName]) {
        __weakSelf_(__self);
        [mm createViewController:^(__kindof UIViewController * _Nonnull vc) {
            RnPageModel *rpm = [APP.rnPageInfos objectWithValue:vc.className keyPath:@"vcName"];
            if (rpm) {
                vc = [ReactNativeVC reactNativeWithRPM:rpm params:[vc rn_keyValues]];
            }
            if ([tabBarController.viewControllers indexOfObject:viewController] && ![UGTabbarController canPushToViewController:vc]) {
                return ;
            }
            vc.title = mm.name;
            UINavigationController *nav = (UINavigationController *)viewController;
            nav.title = mm.name;
            nav.tabBarItem.title = mm.name;
            nav.viewControllers = @[vc];
            tabBarController.selectedViewController = nav;
            [__self.customTabbar setSelectedIndex:[__self.customTabbar.items indexOfValue:mm.path keyPath:@"path"] willCallback:false];
        }];
        return false;
    }
    
    // push权限判断
    return [UGTabbarController canPushToViewController:vc];
}


#pragma mark - 每90秒获取一次站内信

- (void)loadMessageList {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"page":@(1),
                             @"rows":@(20),
                             @"token":[UGUserModel currentUser].sessid,
                             @"type":@""
    };
    
    void (^readMessage)(UGMessageModel *) = ^(UGMessageModel *mm) {
        NSDictionary *params = @{@"id":mm.messageId,
                                 @"token":[UGUserModel currentUser].sessid,
        };
        [CMNetwork modifyMessageStateWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                mm.isRead = YES;
            } failure:^(id msg) {}];
        }];
    };
    NSLog(@"APP.messageRequestTimer= %@",APP.messageRequestTimer);
    dispatch_suspend(APP.messageRequestTimer);
    [CMNetwork getMessageListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"最新站内信的创建时间"];
            UGMessageListModel *mlm = model.data;
            
            NSLog(@"mlm.realTime.messageId =%@",mlm.realTime.messageId);
            if ([CMCommon stringIsNull:mlm.realTime.messageId] || [mlm.realTime.messageId isEqualToString:@"0"]) {
                return ;
            }
            
            NSArray <UGMessageModel *>*unreadArray = [mlm.list filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(UGMessageModel *mm, NSDictionary<NSString *,id> * _Nullable bindings) {
                NSDate *date = [mm.updateTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                if ([date isLaterThan:lastDate]) {
                    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"最新站内信的创建时间"];
                    return !mm.isRead;
                }
                return false;
            }]];
            
            if (unreadArray.count > 0) {
                for (UGMessageModel *model in [unreadArray reverseObjectEnumerator]) {

                    UGMessagePopView *popView = [[UGMessagePopView alloc] initWithFrame:CGRectMake(0, 0, 350, 260)];
                    popView.closeBlock = ^{
                            [LEEAlert closeWithCompletionBlock:nil];
                        };
                    NSLog(@"内容：%@",model.content);
                    [LEEAlert alert].config
                    .LeeTitle(model.title)
                    .LeeAddCustomView(^(LEECustomView *custom) {

                        popView.content = model.content;
                        custom.view = popView;
                        custom.positionType = LEECustomViewPositionTypeCenter;
                    })
                    .LeeAction(@"确定", ^{
                        readMessage(model);
                        dispatch_resume(APP.messageRequestTimer);
                    })
                    .LeeShow();
                    
//                    if (Skin1.isBlack) {
//                        [LEEAlert alert].config
//                        .LeeAddTitle(^(UILabel *label) {
//                            label.text = model.title;
//                            label.textColor = [UIColor whiteColor];
//                        })
//                        .LeeAddContent(^(UILabel *label) {
//                            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//                            NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
//                            ps.lineSpacing = 5;
//                            [mas addAttributes:@{NSParagraphStyleAttributeName:ps,} range:NSMakeRange(0, mas.length)];
//
//                            // 替换文字颜色
//                            NSAttributedString *as = [mas copy];
//                            for (int i=0; i<as.length; i++) {
//                                NSRange r = NSMakeRange(0, as.length);
//                                NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
//                                UIColor *c = dict[NSForegroundColorAttributeName];
//                                if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
//                                    dict[NSForegroundColorAttributeName] = Skin1.textColor2;
//                                    [mas addAttributes:dict range:NSMakeRange(i, 1)];
//                                }
//                            }
//
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                label.attributedText = mas;
//                            });
//                        })
//                        .LeeHeaderColor(Skin1.bgColor)
//                        .LeeAction(@"确定", ^{
//                            readMessage(model);
//                            dispatch_resume(APP.messageRequestTimer);
//                        })
//                        .LeeShow(); // 设置完成后 别忘记调用Show来显示
//                    }
//                    else {
//                        [LEEAlert alert].config
//                        .LeeTitle(model.title)
//                        .LeeAddContent(^(UILabel *label) {
//                            label.attributedText = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//                        })
//                        .LeeAction(@"确定", ^{
//                            readMessage(model);
//                            dispatch_resume(APP.messageRequestTimer);
//                        })
//                        .LeeShow(); // 设置完成后 别忘记调用Show来显示
//                    }
                }
            } else {
                dispatch_resume(APP.messageRequestTimer);
            }
            
        } failure:^(id msg) {
            dispatch_resume(APP.messageRequestTimer);
        }];
    }];
}

- (void)beginMessageRequest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 90 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            [TabBarController1 loadMessageList];
        });
        dispatch_resume(timer);
        APP.messageRequestTimer = timer;
    });
}

#pragma mark - 网络请求
// 得到线上配置的聊天室
- (void)chatgetToken {
    
    {//得到线上配置的聊天室
        NSDictionary *params = @{@"t":[NSString stringWithFormat:@"%ld",(long)[CMTimeCommon getNowTimestamp]],
                                 @"token":[UGUserModel currentUser].sessid
        };
        NSLog(@"token = %@",[UGUserModel currentUser].sessid);
        [CMNetwork chatgetTokenWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                NSLog(@"model.data = %@",model.data);
                NSDictionary *data = (NSDictionary *)model.data;
                NSMutableArray *chatIdAry = [NSMutableArray new];
                NSMutableArray *typeIdAry = [NSMutableArray new];
                NSMutableArray<UGChatRoomModel *> *chatRoomAry = [NSMutableArray new];
//                NSArray * chatAry = [data objectForKey:@"chatAry"];
                
                NSArray * roomAry =[RoomChatModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"chatAry"]];
                
                NSArray *chatAry = [roomAry sortedArrayUsingComparator:^NSComparisonResult(RoomChatModel *p1, RoomChatModel *p2){
                //对数组进行排序（升序）
                    return p1.sortId > p2.sortId;
                //对数组进行排序（降序）
                // return [p2.dateOfBirth compare:p1.dateOfBirth];
                }];
                
                for (int i = 0; i< chatAry.count; i++) {
                    RoomChatModel *dic =  [chatAry objectAtIndex:i];
                    [chatIdAry addObject:dic.roomId];
                    [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
                    
                }
                [CMCommon removeLastRoomAction:chatIdAry];
                
                NSNumber *number = [data objectForKey:@"chatRoomRedirect"];
                
                
                MyChatRoomsModel.currentRoom = [MyChatRoomsModel new];;
                SysChatRoom.chatRoomRedirect = [number intValue];
                SysChatRoom.chatRoomAry = chatRoomAry;
                
              

                if (![CMCommon arryIsNull:chatRoomAry]) {
                      UGChatRoomModel *obj  = SysChatRoom.defaultChatRoom = [chatRoomAry objectAtIndex:0];
                    NSLog(@"roomId = %@,sorId = %d,roomName = %@",obj.roomId,obj.sortId,obj.roomName);
            
                }
                else{
                    UGChatRoomModel *obj  = [UGChatRoomModel new];
                    obj.roomId = @"0";
                    obj.roomName = @"聊天室";
                    SysChatRoom.defaultChatRoom = obj;
                    
                }
                NSLog(@"SysChatRoom0000000000000000000000000000 = %@",SysChatRoom);
                [MyChatRoomsModel setCurrentRoom:SysChatRoom ];
  
            } failure:^(id msg) {
                //            [self stopAnimation];
            }];
        }];
        
    }
}

      

// 彩票大厅数据
- (void)getAllNextIssueData {
    [SVProgressHUD showWithStatus: nil];
    [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD dismiss];
         NSLog(@" model = %@",model);
        [CMResult processWithResult:model success:^{
            UGAllNextIssueListModel.lotteryGamesArray = model.data;
            
            NSLog(@" UGAllNextIssueListModel.lotteryGamesArray = %@",UGAllNextIssueListModel.lotteryGamesArray);
        } failure:nil];
    }];
}



@end
