//
//  AppDelegate.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "AppDelegate.h"
#import "UGNavigationController.h"
#import "UGMineViewController.h"
#import "UGLotteryHomeController.h"
#import "UGChatsViewController.h"
#import "UITabBarController+ShowViewController.h"
#import "UGChatViewController.h"
#import "UGAppVersionManager.h"


#ifdef DEBUG
//#import <DoraemonKit/DoraemonManager.h>
#endif
#import "AppDelegate+HgBugly.h"


@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate
@synthesize tabbar;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tabbar = [[UGTabbarController alloc] init];
    tabbar.delegate = self;
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
     [self ug_setupAppDelegate];
//    版本更新
//    [[UGAppVersionManager shareInstance] updateVersionNow:YES];
    
#ifdef DEBUG
    [LogVC enableLogVC];
#endif
    
    return YES;
}

//获得userAgent
-(void)userAgent{
    //获得userAgent
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] ?:@"";
    
    //add my info to the new agent
    NSString *systemVersion  = [[UIDevice currentDevice] systemVersion];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    CGFloat  iphoneScale     = [[UIScreen mainScreen] scale];
    NSString *model          = [[UIDevice currentDevice] model];
    NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appendAgent = [NSString stringWithFormat:@"%@/%@ (%@/%@ ; %@; Scale/%0.2f)", identifier,currentVersion, model,systemVersion,localeIdentifier,iphoneScale];
    if ([oldAgent rangeOfString:appendAgent].location == NSNotFound) {
        NSString *newAgent  = [NSString stringWithFormat:@"%@ %@", oldAgent,appendAgent];
        NSLog(@"new agent :%@", newAgent);
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": newAgent,@"HTTPUserAgent":appendAgent}];
    }
}
#pragma mark - 系统配置
- (void)ug_setupAppDelegate
{
#ifdef DEBUG
    //默认
//    [[DoraemonManager shareInstance] install];
    // 或者使用传入位置,解决遮挡关键区域,减少频繁移动
    //[[DoraemonManager shareInstance] installWithStartingPosition:CGPointMake(66, 66)];
#endif
     [self initBugly];
    [self userAgent];
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
            [navi.viewControllers.firstObject isKindOfClass:[UGChatViewController class]]
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
