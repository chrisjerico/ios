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
#import "UGChatsViewController.h"
#import "UGHomeViewController.h"
#import "UGYYLotteryHomeViewController.h"
#import "UGMineSkinViewController.h"
#import "UGSystemConfigModel.h"

@interface UGTabbarController ()

@end

@implementation UGTabbarController
@synthesize qdwebVC,vcs;
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setUpChildViewController];
    [self getSystemConfig];

}

-(void)setTabbarStyle{
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
- (void)setUpTabBarItemTextAttributes{
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UGSkinManagers shareInstance] settabNOSelectColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys: [[UGSkinManagers shareInstance] settabSelectColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    

}


/**
 *  添加子控制器
 */
- (void)setUpChildViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"UGHomeViewController" bundle:nil];
    UGHomeViewController *mainVC = [mainStoryboard instantiateInitialViewController];
    
   UGNavigationController *homeNavVC = [[UGNavigationController alloc] initWithRootViewController:mainVC];
    
    [vcs addObject:homeNavVC];
    
    [self addOneChildViewController:homeNavVC
                          WithTitle:@"首页"
                          imageName:@"shouye"
                  selectedImageName:@"shouyesel"];
    
    UGNavigationController *LotteryNavVC = [[UGNavigationController alloc]initWithRootViewController:[[UGYYLotteryHomeViewController alloc] init]];
    
      [vcs addObject:LotteryNavVC];
    
    [self addOneChildViewController:LotteryNavVC
                          WithTitle:@"购彩大厅"
                          imageName:@"dating"
                  selectedImageName:@"datongsel"];
    
    qdwebVC = [[UGChatViewController alloc] init];
    qdwebVC.webTitle = @"聊天室";
   
    if (![CMCommon stringIsNull:[UGUserModel currentUser].token]) {
         NSString *colorStr = [[UGSkinManagers shareInstance] setNavbgStringColor];
        if ([CMCommon stringIsNull:colorStr]) {
            colorStr = @"0x609AC5";
        }
         qdwebVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@&back=hide",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr];
    } else {
        NSString *colorStr = [[UGSkinManagers shareInstance] setNavbgStringColor];
        if ([CMCommon stringIsNull:colorStr]) {
            colorStr = @"0x609AC5";
        }
        qdwebVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@&back=hide",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr];
    }

    
    NSLog(@"qdwebVC.urlString= %@",[NSString stringWithFormat:@"%@%@%@&loginsessid=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid]);

    UGNavigationController *chatNavVC = [[UGNavigationController alloc]initWithRootViewController:qdwebVC];
    
    [vcs addObject:chatNavVC];
    
    [self addOneChildViewController:chatNavVC
                          WithTitle:@"聊天室"
                          imageName:@"liaotian"
                  selectedImageName:@"liaotiansel"];
    
    
//<<<<<<< HEAD
    UGNavigationController *promotionsNavVC = [[UGNavigationController alloc]initWithRootViewController:[[UGPromotionsController alloc] init]];
//=======
//    self.promotionsNavVC = [[UGNavigationController alloc]initWithRootViewController:_LoadVC_from_storyboard_(@"UGPromotionsController")];
//>>>>>>> dev_fish
    
    [self addOneChildViewController: promotionsNavVC
                          WithTitle:@"优惠活动"
                          imageName:@"youhuiquan"
                  selectedImageName:@"youhuiquansel"];
    
                                                                                      
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    UGMineViewController *mineVC = [storyboard instantiateInitialViewController];
    
    UGMineSkinViewController * mineVC = [[UGMineSkinViewController alloc] init];
    
     UGNavigationController *mineNavVC = [[UGNavigationController alloc]initWithRootViewController:mineVC];

      [vcs addObject:mineNavVC];
    
    [self addOneChildViewController:mineNavVC
                          WithTitle:@"我的"
                          imageName:@"wode"
                  selectedImageName:@"wodesel"];
    
    
   
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
- (void)resetUpChildViewController{
   
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
    vcs = [NSMutableArray new];
    for (int i = 0; i<ageSortResultArray.count; i++) {
        UGmobileMenu *menu = [ageSortResultArray objectAtIndex:i];
         UIViewController *ret = [FFRouter routeObjectURL:menu.path];
        
        if ([menu.path isEqualToString:@"/chatRoomList"]) {
            qdwebVC = (UGChatViewController *)ret;
        }
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:ret];
        [vcs addObject:nvc];
    }
    
    [self setViewControllers:vcs];
    [self setTabbarStyle];
}


@end
