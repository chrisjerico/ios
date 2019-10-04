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

@interface UGTabbarController ()

@end

@implementation UGTabbarController
@synthesize qdwebVC;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setUpChildViewController];
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[[UGSkinManagers shareInstance] setTabbgColor]]];
    //去除 TabBar 自带的顶部阴影
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    //设置导航控制器颜色
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[[UGSkinManagers shareInstance] setNavbgColor]] forBarMetrics:UIBarMetricsDefault];
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    statusBar.backgroundColor = UGNavColor;
    
    [[UITabBar appearance] setSelectedImageTintColor: [[UGSkinManagers shareInstance] settabSelectColor]];
    
    [[UITabBar appearance] setUnselectedItemTintColor: [[UGSkinManagers shareInstance] settabNOSelectColor]];

    
//    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
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
    
    self.homeNavVC = [[UGNavigationController alloc] initWithRootViewController:mainVC];
    
    [self addOneChildViewController:self.homeNavVC
                          WithTitle:@"首页"
                          imageName:@"shouye"
                  selectedImageName:@"shouyesel"];
    
    self.LotteryNavVC = [[UGNavigationController alloc]initWithRootViewController:[[UGYYLotteryHomeViewController alloc] init]];
    
    [self addOneChildViewController:self.LotteryNavVC
                          WithTitle:@"购彩大厅"
                          imageName:@"dating"
                  selectedImageName:@"datongsel"];
    
    qdwebVC = [[UGChatViewController alloc] init];
    
    

    qdwebVC.webTitle = @"聊天室";
   
    
    
    if (![CMCommon stringIsNull:[UGUserModel currentUser].token]) {
         NSString *colorStr = [[UGSkinManagers shareInstance] setNavbgStringColor];
         qdwebVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr];
    } else {
        NSString *colorStr = [[UGSkinManagers shareInstance] setNavbgStringColor];
        qdwebVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr];
    }

    
    NSLog(@"qdwebVC.urlString= %@",[NSString stringWithFormat:@"%@%@%@&loginsessid=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid]);

    self.chatNavVC = [[UGNavigationController alloc]initWithRootViewController:qdwebVC];
    
    [self addOneChildViewController:self.chatNavVC
                          WithTitle:@"聊天室"
                          imageName:@"liaotian"
                  selectedImageName:@"liaotiansel"];
    
    
    self.promotionsNavVC = [[UGNavigationController alloc]initWithRootViewController:_LoadVC_from_storyboard_(@"UGPromotionsController")];
    
    [self addOneChildViewController: self.promotionsNavVC
                          WithTitle:@"优惠活动"
                          imageName:@"youhuiquan"
                  selectedImageName:@"youhuiquansel"];
    
                                                                                      
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    UGMineViewController *mineVC = [storyboard instantiateInitialViewController];
    
    UGMineSkinViewController * mineVC = [[UGMineSkinViewController alloc] init];
    
    self.mineNavVC = [[UGNavigationController alloc]initWithRootViewController:mineVC];

    [self addOneChildViewController:self.mineNavVC 
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

//这个方法可以抽取到 UIImage 的分类中
- (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
