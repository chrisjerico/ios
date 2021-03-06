//
//  AppDelegate.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "AppDelegate.h"
#import "UGNavigationController.h"
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
#import "UGBalanceConversionController.h"
#import "UGBankCardInfoController.h"
#import "UGYubaoViewController.h"
#import "UGSigInCodeViewController.h"
#import "UGPromotionIncomeController.h"
#import "UGLaunchPageVC.h"
#import "UGSystemConfigModel.h"
#import "KMCGeigerCounter.h"
#import "AppDelegate+HgBugly.h"
#import "JPUSHService.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>
#import <UTDID/UTDevice.h>


@interface AppDelegate ()<UITabBarControllerDelegate, UNUserNotificationCenterDelegate, JPUSHRegisterDelegate>
{
    
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = ({
        // 版本更新弹框需要在NavController才能弹出来
        UINavigationController *nav = [UINavigationController new];
        nav.navigationBarHidden = true;
        nav.viewControllers = @[[UGLaunchPageVC new]];
        nav;
    });
    [self.window makeKeyAndVisible];
    
    self.notiveViewHasShow = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    // UI自适应键盘库
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 极光推送
    [self setupJPush:launchOptions];

    // 友盟推送
    [self setupUM:launchOptions];

    [self userAgent];
#ifdef APP_TEST
	[LogVC enableLogVC];
#endif
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [FBSDKSettings setAppID:@"721421892046141"];
	
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

// 极光推送
- (void)setupJPush:(NSDictionary *)launchOptions {
    NSDictionary *dict = @{@"c049":@"6ee045aa7ffcf3320b396041",
                           @"c084":@"865d65d06153a662e03a57d4",
                           @"c008":@"07c42b09a5f1b3f80ccb9b0a",
                           @"l001":@"704176e51cf8b2c37fe28834",
                           @"c151":@"a7b7100d34f78632cc7dfbbe",
                           @"l002":@"8b2a4bfdcf4665e11568ecc5",
                           @"c213":@"2a5472a86daeef60423604fe",
                           @"c116":@"7f2bd0c8a274309e5929e9c8",
                           @"c092":@"f40ba329b3db2f53db929a63",
                           @"c200":@"1ef3298b38418f7232668c37",
                           @"c052":@"bc76977c162ffe40285b9dc7",
                           @"c193":@"9cbb58d0eebcb5c1b421163e",
                           @"c012":@"2772c653994de0f3faa0f4eb",
                           @"c230":@"ac740711a824da1018ef0810",
                           @"c085":@"c50224b5f533daabb09fbfc7",
                           @"c002":@"216c64bd4631f22235cb8cc5",
                           @"c175":@"e7d80ea4cf6ee9d2b39208f4",
                           @"c217":@"854010b0c6c28834fe3f2c59",
                           @"c205":@"5b3e0d686b6280279dd27046",
                           @"c134":@"0a147cb4535e95735584df96",
                           @"c073":@"152d1909dbdfc06852701573",
                           @"c085yw":@"c4d57865261cf422a844cb6e",
                           @"c206":@"5be94507f8ebcc99b2214d05",
                           @"c006":@"9f74e61061ff6b7281026599",
                           @"c245":@"10115d9f8171c4199d9f4e51",
                           @"c115":@"5121ee36308813df753e8eaa",
    };
    
    NSLog(@"APP.SiteId = %@",APP.SiteId);
    NSLog(@"dict[APP.SiteId] = %@",dict[APP.SiteId]);
    NSString *appKey = dict[APP.SiteId] ? : @"21d1b87f65b557d2946af463";
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lotteryHormIsOpen"];//下注界面默认喇叭开启
    
#ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:@"develop" apsForProduction:0 advertisingIdentifier:nil];
    [KMCGeigerCounter sharedGeigerCounter].enabled = NO;
     [self initBugly];
 
#else
    [self initBugly];
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:@"dis" apsForProduction:1 advertisingIdentifier:nil];
#endif
    
    
    [JPUSHService registerForRemoteNotificationConfig:({
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
        entity;
    }) delegate:self];
}
// 友盟推送
- (void)setupUM:(NSDictionary *)launchOptions {
    NSDictionary *dict = @{
        @"c208":@"5ffd4b93dbc1cd0defd360fc",
        @"c053":@"600eb473a3a44870349bbe16",
        @"c217":@"60166eac0ee94b6d773e5fd6",
        @"c085":@"60251089d57fee40b0b0dcc3",
        @"a002":@"602d21b8668f9e17b8b00711",
        @"c134":@"6035170dd57fee40b0bbb436",
    };
    NSString *appKey = dict[APP.SiteId];
    if (!appKey.length) {
        NSLog(@"Error：该站点没有集成友盟推送！");
        return;
    }
    
    [UMConfigure initWithAppkey:appKey channel:@"App Store"];
#ifdef DEBUG
    [UMConfigure setLogEnabled:true];
#endif
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"友盟注册 = %d", granted);
        if (granted) {
        }else{
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate (友盟)

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

#pragma mark - 系统配置

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[JPUSHService registerDeviceToken:deviceToken];
    [UMessage registerDeviceToken:deviceToken];
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
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
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
     [FBSDKAppEvents activateApp];
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


@end
