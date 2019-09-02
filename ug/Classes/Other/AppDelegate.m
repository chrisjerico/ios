//
//  AppDelegate.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "AppDelegate.h"
#import "UGTabbarController.h"
#import "UGNavigationController.h"
#import "UGMineViewController.h"
#import "UGLotteryHomeController.h"
#import "UGChatsViewController.h"
#import "UITabBarController+ShowViewController.h"
#import "QDWebViewController.h"
#import "UGAppVersionManager.h"
@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UGTabbarController *tabbar = [[UGTabbarController alloc] init];
    tabbar.delegate = self;
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
//    版本更新
//    [[UGAppVersionManager shareInstance] updateVersionNow:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//横竖屏切换
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (self.allowRotation == 1) {
        return YES;
    }
    return NO;
}

#pragma mark - UITabBarControllerDelegate

/// 切换
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    CMMETHOD_BEGIN_O(viewController.restorationIdentifier);
    
    BOOL isLogin = UGLoginIsAuthorized();
 
    if (isLogin) {
//         UGNavigationController *navi = (UGNavigationController *)viewController;
//        if ([navi.viewControllers.firstObject isKindOfClass:[UGChatsViewController class]]) {
//            QDWebViewController *webVC = [[QDWebViewController alloc] init];
//            webVC.navigationItem.title = @"聊天室";
//            webVC.urlString = [NSString stringWithFormat:@"%@/dist/index.html#/chatRoomList",baseServerUrl];
//            [tabBarController showViewControllerInSelected:webVC animated:YES];
//            return CMMETHOD_END_C(false);
//        }
        return YES;
    }else {
        
        UGNavigationController *navi = (UGNavigationController *)viewController;
        if ([navi.viewControllers.firstObject isKindOfClass:[UGMineViewController class]] ||
            [navi.viewControllers.firstObject isKindOfClass:[UGLotteryHomeController class]] ||
            [navi.viewControllers.firstObject isKindOfClass:[QDWebViewController class]]
            ) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"您还未登录" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex) {
                    
                    UGLoginAuthorize(^(BOOL isFinish) {
                        if (!isFinish) {
                            return ;
                        }
//                        if ([navi.viewControllers.firstObject isKindOfClass:[UGChatsViewController class]]) {
//                            QDWebViewController *webVC = [[QDWebViewController alloc] init];
//                             webVC.navigationItem.title = @"聊天室";
//                            webVC.urlString = [NSString stringWithFormat:@"%@/dist/index.html#/chatRoomList",baseServerUrl];
//                           [tabBarController showViewControllerInSelected:webVC animated:YES];
//                            return;
//                        }else {
                        
                            [tabBarController setSelectedViewController:viewController];
//                        }
                        
                    });
                }
            }];
            
            return NO;
        }
        
    }
    return YES;
}

@end
