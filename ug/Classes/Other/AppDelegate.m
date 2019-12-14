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
#import "UGChatViewController.h"
#import "UGAppVersionManager.h"
#import "UGHomeViewController.h"
#import "UGChangLongController.h"
#import "UGYYLotteryHomeViewController.h"
#import "UGPromotionsController.h"
#import "UGChatViewController.h"
#import "UGLotteryRecordController.h"
#import "UGMineSkinViewController.h"
#import "UGMissionCenterViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGFundsViewController.h"
#import "UGMailBoxTableViewController.h"
#import "UGBalanceConversionController.h"
#import "UGBankCardInfoController.h"
#import "UGYubaoViewController.h"
#import "UGSigInCodeViewController.h"
#import "UGPromotionIncomeController.h"
#import "UGLaunchPageVC.h"
#import "UGSystemConfigModel.h"

#ifdef DEBUG

#endif
#import "AppDelegate+HgBugly.h"

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif




@interface AppDelegate ()<UITabBarControllerDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [UGLaunchPageVC new];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    // UI自适应键盘库
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 极光推送
    NSDictionary *dict = @{@"c049":@"ccb82fc32e80809ae7655a47",
                           @"c008":@"cd266717f2634d6cc6b35ccc",
    };
    NSString *appKey = dict[APP.SiteId] ? : @"21d1b87f65b557d2946af463";
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:@"develop" apsForProduction:false advertisingIdentifier:nil];
    [JPUSHService registerForRemoteNotificationConfig:({
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
        entity;
    }) delegate:self];
    
//#ifndef DEBUG
    [self initBugly];
//#endif
    [self userAgent];
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
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
	[application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//横竖屏切换
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
	if (self.allowRotation == 1) {
		return UIInterfaceOrientationMaskAll;
	} else{
		return (UIInterfaceOrientationMaskPortrait);
	}
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate {
	if (self.allowRotation == 1)
		return true;
	return false;
}

@end
