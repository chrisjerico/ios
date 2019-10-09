//
//  UGTabbarController.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTabbarController.h"
#import "UGMineViewController.h"
#import "UGLotteryHomeController.h"
#import "UGFundsViewController.h"
#import "UGPromotionsController.h"
#import "UGNavigationController.h"
#import "UGHomeViewController.h"
#import "UGYYLotteryHomeViewController.h"
#import "UGMineSkinViewController.h"
#import "UGSystemConfigModel.h"

@interface UGTabbarController ()

@end

@implementation UGTabbarController
@synthesize qdwebVC,vcs,nvcHome,nvcChangLong,nvcLotteryList,nvcActivity,nvcChatRoomList,nvcLotteryRecord;
@synthesize nvcUser,nvcTask,nvcSecurityCenter,nvcFunds,nvcMessage,nvcConversion,nvcBanks,nvcYuebao;
@synthesize nvcSign,nvcReferrer,balanceConversionVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllNav];
    
    [self setUpChildViewController];
    [self getSystemConfig];
    
//    SANotificationEventSubscribe(UGNotificationWithResetTabSuccess, self, ^(typeof (self) self, id obj) {
//             [self resetUpChildViewController];
//    });

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBar layoutIfNeeded];
}

- (void)initAllNav{
    //====home
    self.nvcHome = [FFRouter routeObjectURL:@"/home"];
    //====长龙助手
     self.nvcChangLong = [FFRouter routeObjectURL:@"/changLong"];
    //====彩票大厅
    self.nvcLotteryList = [FFRouter routeObjectURL:@"/lotteryList"];
    //====优惠活动
    self.nvcActivity = [FFRouter routeObjectURL:@"/activity"];
    //====聊天室
    qdwebVC =  [FFRouter routeObjectURL:@"/chatRoomList"];
    self.nvcChatRoomList = [[UGNavigationController alloc]initWithRootViewController:qdwebVC];
    //====开奖记录
    self.nvcLotteryRecord = [FFRouter routeObjectURL:@"/lotteryRecord"];
    //====我的
    self.nvcUser = [FFRouter routeObjectURL:@"/user"];
    //====任务中心
    self.nvcTask = [FFRouter routeObjectURL:@"/task"];
    //====安全中心
    self.nvcSecurityCenter = [FFRouter routeObjectURL:@"/securityCenter"];
    //====资金管理
    self.nvcFunds = [FFRouter routeObjectURL:@"/funds"];
    //====站内信
    self.nvcMessage = [FFRouter routeObjectURL:@"/message"];
    //====额度转换
    balanceConversionVC =  [FFRouter routeObjectURL:@"/conversion"];
    self.nvcConversion = [[UGNavigationController alloc]initWithRootViewController:balanceConversionVC];
    //====银行卡
    self.nvcBanks = [FFRouter routeObjectURL:@"/banks"];
    //====利息宝
    self.nvcYuebao = [FFRouter routeObjectURL:@"/yuebao"];
    //====签到
    self.nvcSign = [FFRouter routeObjectURL:@"/Sign"];
    //====推广收益
    self.nvcReferrer = [FFRouter routeObjectURL:@"/referrer"];
   
   
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

- (UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//   return UIStatusBarStyleLightContent = 1 //白色文字，深色背景时使用
}


#pragma mark - Private Methods

/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes {
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UGSkinManagers shareInstance] settabNOSelectColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys: [[UGSkinManagers shareInstance] settabSelectColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    

}


/**
 *  添加子控制器
 */
- (void)setUpChildViewController {
    self.vcs  = [NSMutableArray new];
    [vcs addObject: self.nvcHome];
//    [vcs addObject: self.nvcLotteryList];
//    [vcs addObject: self.nvcChatRoomList];
//    [vcs addObject: self.nvcTask];
//    [vcs addObject: self.nvcUser];
    [self setViewControllers:vcs];
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
            
            [self resetUpChildViewController];
            
            
        } failure:^(id msg) {
            
            [SVProgressHUD dismiss];
            // 设置子控制器
            [self setUpChildViewController];
        }];
    }];
}

/**
 *  添加子控制器
 */
- (void)resetUpChildViewController {
   
   UGSystemConfigModel *config =  [UGSystemConfigModel currentConfig];
    
    //数组转模型数组
    NSMutableArray *personArray  = [UGmobileMenu arrayOfModelsFromDictionaries:config.mobileMenu error:nil];
    //model 按年龄属性 排序
    NSArray *ageSortResultArray = [personArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        UGmobileMenu *per1 = obj1;
        
        UGmobileMenu *per2 = obj2;
        
        if (per1.sort > per2.sort) {
            return NSOrderedDescending;//降序
        }
        else if (per1.sort < per2.sort)
        {
            return NSOrderedAscending;//升序
        }
        else
        {
            return NSOrderedSame;//相等
        }
        
    }];

    for (UGmobileMenu *per in ageSortResultArray) {
        NSLog(@"per.age = %d",(int )per.sort);
    }
    
    if ([CMCommon arryIsNull:ageSortResultArray]) {
        return;
    }
    if (ageSortResultArray.count<4) {
        return;
    }
    if (ageSortResultArray.count>5) {
        return;
    }
    
    self.vcs = [NSMutableArray new];
    for (int i = 0; i<ageSortResultArray.count; i++) {
        UGmobileMenu *menu = [ageSortResultArray objectAtIndex:i];
         UIViewController *ret = [FFRouter routeObjectURL:menu.path];
        
        if ([menu.path isEqualToString:@"/home"]) {
            [vcs addObject:nvcHome];
        }
        if ([menu.path isEqualToString:@"/changLong"]) {
            [vcs addObject:nvcChangLong];
        }
        if ([menu.path isEqualToString:@"/lotteryList"]) {
            [vcs addObject:nvcLotteryList];
        }
        if ([menu.path isEqualToString:@"/activity"]) {
            [vcs addObject:nvcActivity];
        }
        if ([menu.path isEqualToString:@"/chatRoomList"]) {
            [vcs addObject:nvcChatRoomList];
        }
        if ([menu.path isEqualToString:@"/lotteryRecord"]) {
            [vcs addObject:nvcLotteryRecord];
        }
        if ([menu.path isEqualToString:@"/user"]) {
            [vcs addObject:nvcUser];
        }
        if ([menu.path isEqualToString:@"/task"]) {
            [vcs addObject:nvcTask];
        }
        if ([menu.path isEqualToString:@"/securityCenter"]) {
            [vcs addObject:nvcSecurityCenter];
        }
        if ([menu.path isEqualToString:@"/funds"]) {
            [vcs addObject:nvcFunds];
        }
        if ([menu.path isEqualToString:@"/message"]) {
            [vcs addObject:nvcMessage];
        }
        if ([menu.path isEqualToString:@"/conversion"]) {
            [vcs addObject:nvcConversion];
        }
        if ([menu.path isEqualToString:@"/banks"]) {
            [vcs addObject:nvcConversion];
        }
        if ([menu.path isEqualToString:@"/yuebao"]) {
            [vcs addObject:nvcBanks];
        }
        if ([menu.path isEqualToString:@"/Sign"]) {
            [vcs addObject:nvcSign];
        }
        if ([menu.path isEqualToString:@"/referrer"]) {
            [vcs addObject:nvcReferrer];
        }
        
    }
//<<<<<<< HEAD
//
//=======
//    
//>>>>>>> dev_fish
    [self setViewControllers:vcs];
    [self setTabbarStyle];
}


@end
