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
#import "UGBankCardInfoController.h"        // 银行卡
#import "UGBindCardViewController.h"        // 银行卡
#import "UGYubaoViewController.h"           // 利息宝
#import "UGSigInCodeViewController.h"       // 每日签到
#import "UGPromotionIncomeController.h"     // 推广收益
#import "UGBalanceConversionController.h"   // 额度转换

#import "UGSystemConfigModel.h"
#import "UGAppVersionManager.h"

@interface UGTabbarController ()<UITabBarControllerDelegate>

@property (nonatomic, copy) NSArray<UGmobileMenu *> *gms;
@end

@implementation UGTabbarController

static UGTabbarController *_tabBarVC = nil;

+ (instancetype)shared {
    return _tabBarVC;
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
        [UGmobileMenu menu:@"/task"            :@"任务中心" :@"renwu" :@"renwusel"         :[UGMissionCenterViewController class]],
        [UGmobileMenu menu:@"/securityCenter"  :@"安全中心" :@"ziyuan" :@"ziyuan"          :[UGSecurityCenterViewController class]],
        [UGmobileMenu menu:@"/funds"           :@"资金管理" :@"jinlingyingcaiwangtubiao" :@"jinlingyingcaiwangtubiaosel" :[UGFundsViewController class]],
        [UGmobileMenu menu:@"/message"         :@"站内信" :@"zhanneixin" :@"zhanneixin"   :[UGMailBoxTableViewController class]],
        [UGmobileMenu menu:@"/conversion"      :@"额度转换" :@"change" :@"change"          :[UGBalanceConversionController class]],
        [UGmobileMenu menu:@"/banks"           :@"银行卡" :@"yinhangqia" :@"yinhangqia"   :[UGBindCardViewController class]],
        [UGmobileMenu menu:@"/yuebao"          :@"利息宝" :@"lixibao" :@"lixibao"         :[UGYubaoViewController class]],
        [UGmobileMenu menu:@"/Sign"            :@"签到" :@"qiandao" :@"qiandaosel"       :[UGSigInCodeViewController class]],
        [UGmobileMenu menu:@"/referrer"        :@"推广收益" :@"shouyi1" :@"shouyi1sel"     :[UGPromotionIncomeController class]],
    ];
    
    self.delegate = self;
    
    // 设置初始控制器
    [self resetUpChildViewController:@[@"/home", @"/lotteryList", @"/chatRoomList", @"/task", @"/user", ]];
    
    // 更新为后台配置的控制器
//    [self getSystemConfig];
    
//    SANotificationEventSubscribe(UGNotificationWithResetTabSuccess, self, ^(typeof (self) self, id obj) {
//         [self resetUpChildViewController];
//    });
    
    //    版本更新
    [[UGAppVersionManager shareInstance] updateVersionNow:YES];
}

- (void)setTabbarStyle {
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
  
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[[UGSkinManagers shareInstance] setTabbgColor]]];
    //去除 TabBar 自带的顶部阴影
    //    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    //设置导航控制器颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[[UGSkinManagers shareInstance] setNavbgColor]] forBarMetrics:UIBarMetricsDefault];
    
    
    [[UITabBar appearance] setSelectedImageTintColor: [[UGSkinManagers shareInstance] settabSelectColor]];
    
    [[UITabBar appearance] setUnselectedItemTintColor: [[UGSkinManagers shareInstance] settabNOSelectColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//   return UIStatusBarStyleLightContent = 1 //白色文字，深色背景时使用
}


#pragma mark - Private Methods

/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UGSkinManagers shareInstance] settabNOSelectColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UGSkinManagers shareInstance] settabSelectColor]} forState:UIControlStateSelected];
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param imageName         图片
 *  @param selectedImageName 选中图片
 */

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    
    viewController.view.backgroundColor     = UGBackgroundColor;
    viewController.tabBarItem.title         = title;
    viewController.tabBarItem.image         = [UIImage imageNamed:imageName];
    UIImage *image = [UIImage imageNamed:selectedImageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    viewController.tabBarItem.selectedImage = image;
    [self addChildViewController:viewController];
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
            
            [[UGSkinManagers shareInstance] setSkin];
            
            NSArray<UGmobileMenu *> *menus = [[UGmobileMenu arrayOfModelsFromDictionaries:SysConf.mobileMenu error:nil] sortedArrayUsingComparator:^NSComparisonResult(UGmobileMenu *obj1, UGmobileMenu *obj2) {
                return obj1.sort > obj2.sort;
            }];
            [self resetUpChildViewController:[menus valuesWithKeyPath:@"path"]];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

/**
 *  添加子控制器
 */
- (void)resetUpChildViewController:(NSArray<NSString *> *)paths {
    self.viewControllers = ({
        
        NSMutableArray *vcs = [NSMutableArray new];
        for (NSString *path in paths) {
            UGmobileMenu *gm = [_gms objectWithValue:path keyPath:@"path"];
            
            BOOL existed = false;
            for (UIViewController *vc in self.viewControllers) {
                if ([vc isKindOfClass:gm.cls]) {
                    [vcs addObject:vc];
                    existed = true;
                    break;
                }
            }
            if (existed)
                continue;
            
            UIViewController *vc = _LoadVC_from_storyboard_(NSStringFromClass(gm.cls));
            if (!vc)
                vc = [gm.cls new];
            vc.tabBarItem.title = gm.name;
            vc.tabBarItem.image = [UIImage imageNamed:gm.icon];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:gm.selectedIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            [vc aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
//                ((UIViewController *)ai.instance).view.backgroundColor = UGBackgroundColor;
//            } error:nil];
            UGNavigationController *nav = [[UGNavigationController alloc] initWithRootViewController:vc];
            [vcs addObject:nav];
        }
        vcs;
    });
}


#pragma mark - UITabBarControllerDelegate

/// 切换
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    CMMETHOD_BEGIN_O(viewController.restorationIdentifier);
    
    UIViewController *vc = ((UINavigationController *)viewController).viewControllers.firstObject;
    UGUserModel *user = [UGUserModel currentUser];
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
   
    
    BOOL isLogin = UGLoginIsAuthorized();
    
    if (isLogin) {
        if ([vc isKindOfClass:[UGChatViewController class]]) {
            // 聊天室
            if (!user.chatRoomSwitch) {//关
                [QDAlertView showWithTitle:@"温馨提示" message:@"聊天室已关闭" cancelButtonTitle:@"确定" otherButtonTitle:nil completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
                return NO;
            } else {
                ((UGChatViewController *)vc).url = _NSString(@"%@%@%@&loginsessid=%@&color=%@&back=hide", baseServerUrl, newChatRoomUrl, [UGUserModel currentUser].token, [UGUserModel currentUser].sessid, [[UGSkinManagers shareInstance] setChatNavbgStringColor]);
                return YES;
            }
        }
        else if([vc isKindOfClass:NSClassFromString(@"UGMissionCenterViewController")] ) {
            // 任务中心
            if ([config.missionSwitch isEqualToString:@"1"]) {//关
                [QDAlertView showWithTitle:@"温馨提示" message:@"任务中心已关闭" cancelButtonTitle:@"确定" otherButtonTitle:nil completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
                return NO;
            } else {
                return YES;
            }
        }
        else if([vc isKindOfClass:NSClassFromString(@"UGYubaoViewController")]) {
            // 利息宝
            NSLog(@"user.yuebaoSwitch = %d",user.yuebaoSwitch);
            if (!user.yuebaoSwitch) {//关
                [QDAlertView showWithTitle:@"温馨提示" message:@"利息宝已关闭" cancelButtonTitle:@"确定" otherButtonTitle:nil completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
                return NO;
            } else {
                return YES;
            }
        }
        else if([vc isKindOfClass:NSClassFromString(@"UGSigInCodeViewController")]) {
            // 每日签到
            if ([config.checkinSwitch isEqualToString:@"0"]) {//关
                [QDAlertView showWithTitle:@"温馨提示" message:@"每日签到已关闭" cancelButtonTitle:@"确定" otherButtonTitle:nil completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
                return false;
            } else {
                return true;
            }
        }
    } else {
        if (![vc isKindOfClass:[UGHomeViewController class]]) {
            UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"您还未登录" btnTitles:@[@"取消", @"马上登录"]];
            [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
                UGLoginAuthorize(^(BOOL isFinish) {
                    if (!isFinish)
                        return ;
                    [tabBarController setSelectedViewController:viewController];
                });
            }];
            return false;
        }
    }
    return true;
}

@end
