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

@interface UGTabbarController ()

@end

@implementation UGTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 TabBarItemTestAttributes 的颜色。
    [self setUpTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setUpChildViewController];
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    //去除 TabBar 自带的顶部阴影
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    //设置导航控制器颜色
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:UGNavColor] forBarMetrics:UIBarMetricsDefault];
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    statusBar.backgroundColor = UGNavColor;
    
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
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:UGNavColor,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
}


/**
 *  添加子控制器
 */
- (void)setUpChildViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"UGHomeViewController" bundle:nil];
    UGHomeViewController *mainVC = [mainStoryboard instantiateInitialViewController];
    [self addOneChildViewController:[[UGNavigationController alloc] initWithRootViewController:mainVC]
                          WithTitle:@"首页"
                          imageName:@"shouye"
                  selectedImageName:@"shouyesel"];
    
    [self addOneChildViewController:[[UGNavigationController alloc]initWithRootViewController:[[UGLotteryHomeController alloc] init]]
                          WithTitle:@"购彩大厅"
                          imageName:@"dating"
                  selectedImageName:@"datongsel"];
    
    QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
    qdwebVC.navigationTitle = @"聊天室";
//    qdwebVC.urlString = [NSString stringWithFormat:@"%@%@",baseServerUrl,chatRoomUrl];
    
     qdwebVC.urlString = @"http://test10.6yc.com/dist/#/home?from=app&logintoken=87f2c1f02045f209b99b233214e36eaa&sessiontoken=sid3m3sdYLqh3hg44SOdW44I49g";
    [self addOneChildViewController:[[UGNavigationController alloc]initWithRootViewController:qdwebVC]
                          WithTitle:@"聊天室"
                          imageName:@"liaotian"
                  selectedImageName:@"liaotiansel"];
    
    [self addOneChildViewController:[[UGNavigationController alloc]initWithRootViewController:[[UGPromotionsController alloc] initWithStyle:UITableViewStyleGrouped]]
                          WithTitle:@"优惠活动"
                          imageName:@"youhuiquan"
                  selectedImageName:@"youhuiquansel"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UGMineViewController *mineVC = [storyboard instantiateInitialViewController];
    [self addOneChildViewController:[[UGNavigationController alloc]initWithRootViewController:mineVC]
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
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
