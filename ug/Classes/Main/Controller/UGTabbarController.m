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



#import "UGSystemConfigModel.h"
#import "UGAppVersionManager.h"

#import "cc_runtime_property.h"


@implementation UIViewController (CanPush)

_CCRuntimeProperty_Assign(BOOL, 未登录禁止访问, set未登录禁止访问)
_CCRuntimeProperty_Assign(BOOL, 游客禁止访问, set游客禁止访问)
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
    if (!isLogin && (vc.未登录禁止访问 || vc.游客禁止访问)) {
        NSLog(@"未登录禁止访问：%@", vc);
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
        return false;
    }
    
    // 游客禁止访问
    if (user.isTest && vc.游客禁止访问) {
        NSLog(@"游客禁止访问：%@", vc);
        UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];
        [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
            SANotificationEventPost(UGNotificationShowLoginView, nil);
        }];
        return false;
    }
    
    // 聊天室
    if ([vc isKindOfClass:[UGChatViewController class]] && !user.chatRoomSwitch) {
        [AlertHelper showAlertView:@"温馨提示" msg:@"聊天室已关闭" btnTitles:@[@"确定"]];
        return false;
    }
    // 任务中心
    else if([vc isKindOfClass:[UGMissionCenterViewController class]] && [SysConf.missionSwitch isEqualToString:@"1"]) {
        [AlertHelper showAlertView:@"温馨提示" msg:@"任务中心已关闭" btnTitles:@[@"确定"]];
        return false;
    }
    // 利息宝
    else if([vc isKindOfClass:[UGYubaoViewController class]] && !user.yuebaoSwitch) {
        [AlertHelper showAlertView:@"温馨提示" msg:@"利息宝已关闭" btnTitles:@[@"确定"]];
        return false;
    }
    // 每日签到
    else if([vc isKindOfClass:[UGSigInCodeViewController class]] && [SysConf.checkinSwitch isEqualToString:@"0"]) {
        [AlertHelper showAlertView:@"温馨提示" msg:@"每日签到已关闭" btnTitles:@[@"确定"]];
        return false;
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
        [UGmobileMenu menu:@"/task"            :@"任务中心" :@"renwu" :@"renwusel"         :[UGMissionCenterViewController class]],
        [UGmobileMenu menu:@"/securityCenter"  :@"安全中心" :@"ziyuan" :@"ziyuan"          :[UGSecurityCenterViewController class]],
        [UGmobileMenu menu:@"/funds"           :@"资金管理" :@"jinlingyingcaiwangtubiao" :@"jinlingyingcaiwangtubiaosel" :[UGFundsViewController class]],
        [UGmobileMenu menu:@"/message"         :@"站内信" :@"zhanneixin" :@"zhanneixin"   :[UGMailBoxTableViewController class]],
        [UGmobileMenu menu:@"/conversion"      :@"额度转换" :@"change" :@"change"          :[UGBalanceConversionController class]],
        [UGmobileMenu menu:@"/banks"           :@"银行卡" :@"yinhangqia" :@"yinhangqia"   :[UGBindCardViewController class]],
        [UGmobileMenu menu:@"/yuebao"          :@"利息宝" :@"lixibao" :@"lixibao"         :[UGYubaoViewController class]],
        [UGmobileMenu menu:@"/Sign"            :@"签到" :@"qiandao" :@"qiandaosel"       :[UGSigInCodeViewController class]],
        [UGmobileMenu menu:@"/referrer"        :@"推荐收益" :@"shouyi1" :@"shouyi1sel"     :[UGPromotionIncomeController class]],
    ];
    
    self.delegate = self;
    
    // 设置初始控制器
    [self resetUpChildViewController:@[@"/home", @"/lotteryList", @"/chatRoomList", @"/referrer", @"/user", ]];
    
    // 更新为后台配置的控制器
    [self getSystemConfig];
    
//    SANotificationEventSubscribe(UGNotificationWithResetTabSuccess, self, ^(typeof (self) self, id obj) {
//         [self resetUpChildViewController];
//    });
    
    //    版本更新
    [[UGAppVersionManager shareInstance] updateVersionApi:false];
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
    self.viewControllers = ({
        
        NSMutableArray *vcs = [NSMutableArray new];
        for (NSString *path in paths) {
            UGmobileMenu *gm = [_gms objectWithValue:path keyPath:@"path"];
            
            // 优惠活动展示在首页
            if (gm.cls == [UGPromotionsController class] && SysConf.m_promote_pos)
                continue;
            
            // 已存在的控制器不需要重新初始化
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
        vcs;
    });
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // push权限判断
    return [UGTabbarController canPushToViewController:((UINavigationController *)viewController).viewControllers.firstObject];
}

@end
