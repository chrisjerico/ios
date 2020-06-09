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
#import "UGMailBoxTableViewController.h"
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
#import <YunCeng/YunCeng.h>

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
    NSDictionary *dict = @{@"c049":@"6ee045aa7ffcf3320b396041",
                           @"c084":@"865d65d06153a662e03a57d4",
                           @"c008":@"07c42b09a5f1b3f80ccb9b0a",
                           @"c053":@"370d706112f879592224e336",
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
    };
    
    NSLog(@"APP.SiteId = %@",APP.SiteId);
    NSLog(@"dict[APP.SiteId] = %@",dict[APP.SiteId]);
    NSString *appKey = dict[APP.SiteId] ? dict[APP.SiteId] : @"21d1b87f65b557d2946af463";
    
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
    
    
    // 游戏盾
    if ([APP.SiteId isEqualToString:@"a002"]) {
        const char *appKey = "IiCJZtVLWMDn-RwCrHYVU7yl32EXfL7yYzrnCC-I1_GGW-J_3dLjRyaM-v_Frp7sKW5LTBCcyXA+NUv2RF7EPOOAaHsENPTwc3MawM_NeFssWsvyJ+YNSP_Yjn0wyoQYP_3z2Bw3KKeNnqcFFzS-y6z22YJElbA7HAuFfsDnWOdJoOnwTb4h7JZ5b4tB9sQoxbG6gobyhwbBhbeb77A8oEZi+kb+WceFMdmBM1k-gUAeAE_wTc5YUev-DGyiFlvtv8a_NWWIkOdTwz_WhGYzlRPlaR05JVwvlsp+qP51heTd2zLqn6sJrsAFXEpf0X05mlllpv6q-A_DcpRCSwrtEassbZ3RkS2hdTFuzGY6hfCIzT5X8HwarALxAi+r2TgxUgIn7hwOOgNNfFHBjnyXQ4IwlWZ";
        const char *token = "001";
        const char *groupName = "groupnameug01.W4Eyq4un0q.ftnormal03ah.com";
        const char *dip = "ug01";
        const char *dport = "9080";
        
        NSLog(@"游戏盾初始化前，appKey=%s, token=%s", appKey, token);
        int ret = [YunCeng initEx:appKey :token];
        NSLog(@"游戏盾初始化%@，错误码：%d", ret ? @"失败" : @"成功", ret);
        
        int ipLen = 100;
        char *ipString = (char *)malloc(ipLen * sizeof(char));
        int portLen = 100;
        char *portString = (char *)malloc(ipLen * sizeof(char));
        
        NSLog(@"获取ip前：token=%s, groupName=%s, dip=%s, dport=%s, ip=%s, ipLen=%d, port=%s, portLen=%d", token, groupName, dip, dport, ipString, ipLen, portString, portLen);
//        int ipStatus = [YunCeng getProxyTcpByIp:token :groupName :dip :dport :ipString :ipLen :portString :portLen];
        int ipStatus = [YunCeng getProxyTcpByDomain:token :groupName :dip :dport :ipString :ipLen :portString :portLen];
        NSLog(@"获取ip%@，错误码：%d", ipStatus ? @"失败" : @"成功", ipStatus);
        
        NSLog(@"ip = %s", ipString);
        NSLog(@"port = %s", portString);
        [APP setValue:_NSString(@"http://%s:%s", ipString, portString) forKey:@"_Host"];
        NSLog(@"APP.Host = %@", APP.Host);
    }
    

    [self userAgent];
#ifdef APP_TEST
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
