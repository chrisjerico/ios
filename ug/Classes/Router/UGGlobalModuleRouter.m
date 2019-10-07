//
//  UGGlobalModuleRouter.m
//  ug
//
//  Created by ug on 2019/10/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGlobalModuleRouter.h"
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
#import "UGNavigationController.h"

@implementation UGGlobalModuleRouter
// 在load方法中自动注册，在主工程中不用写任何代码。
+ (void)load {
    
    [self registerRouteURL];
  
}


+(void)registerRouteURL {
    [FFRouter setLogEnabled:YES];
    
   
    
    //注册 /home 首页
    [FFRouter registerObjectRouteURL:@"/home" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"UGHomeViewController" bundle:nil];
        UGHomeViewController *viewController = [mainStoryboard instantiateInitialViewController];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"首页";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"shouye"];
        UIImage *image = [UIImage imageNamed:@"shouyesel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /changLong 长龙助手
    [FFRouter registerObjectRouteURL:@"/changLong" handler:^id(NSDictionary *routerParameters) {
        UGChangLongController *viewController = [[UGChangLongController alloc] init];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"长龙助手";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"changlong"];
        UIImage *image = [UIImage imageNamed:@"changlong"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
         UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;

    }];
    
    //注册 /lotteryList 彩票大厅
    [FFRouter registerObjectRouteURL:@"/lotteryList" handler:^id(NSDictionary *routerParameters) {
        UGYYLotteryHomeViewController *viewController = [[UGYYLotteryHomeViewController alloc] init];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"彩票大厅";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"dating"];
        UIImage *image = [UIImage imageNamed:@"datongsel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /activity 优惠活动
    [FFRouter registerObjectRouteURL:@"/activity" handler:^id(NSDictionary *routerParameters) {
        UGPromotionsController *viewController = [[UGPromotionsController alloc] init];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"优惠活动";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"youhui1"];
        UIImage *image = [UIImage imageNamed:@"youhui1sel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /chatRoomList 聊天室
    [FFRouter registerObjectRouteURL:@"/chatRoomList" handler:^id(NSDictionary *routerParameters) {
       UGChatViewController  *viewController = [[UGChatViewController alloc] init];
        viewController.webTitle = @"聊天室";
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"聊天室";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"liaotian"];
        UIImage *image = [UIImage imageNamed:@"liaotiansel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        
        return viewController;
    }];
    
    //注册 /lotteryRecord 开奖记录
    [FFRouter registerObjectRouteURL:@"/lotteryRecord" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"UGLotteryRecordController" bundle:nil];
        UGLotteryRecordController *viewController = [storyboad instantiateInitialViewController];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"开奖记录";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"zdgl"];
        UIImage *image = [UIImage imageNamed:@"zdgl"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /user 我的
    [FFRouter registerObjectRouteURL:@"/user" handler:^id(NSDictionary *routerParameters) {
          UGMineSkinViewController * viewController = [[UGMineSkinViewController alloc] init];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"我的";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"wode"];
        UIImage *image = [UIImage imageNamed:@"wodesel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /task 任务中心
    [FFRouter registerObjectRouteURL:@"/task" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGMissionCenterViewController" bundle:nil];
        UGMissionCenterViewController *viewController = [storyboard instantiateInitialViewController];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"任务中心";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"renwu"];
        UIImage *image = [UIImage imageNamed:@"renwusel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /securityCenter 安全中心
    [FFRouter registerObjectRouteURL:@"/securityCenter" handler:^id(NSDictionary *routerParameters) {
        UGSecurityCenterViewController *viewController = [[UGSecurityCenterViewController alloc] init];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"安全中心";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"ziyuan"];
        UIImage *image = [UIImage imageNamed:@"ziyuan"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /funds 资金管理
    [FFRouter registerObjectRouteURL:@"/funds" handler:^id(NSDictionary *routerParameters) {
         UGFundsViewController * viewController = [UGFundsViewController new];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"资金管理";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"jinlingyingcaiwangtubiao"];
        UIImage *image = [UIImage imageNamed:@"jinlingyingcaiwangtubiaosel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /message 站内信
    [FFRouter registerObjectRouteURL:@"/message" handler:^id(NSDictionary *routerParameters) {
        UGMailBoxTableViewController *viewController = [[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"站内信";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"zhanneixin"];
        UIImage *image = [UIImage imageNamed:@"zhanneixin"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /conversion 额度转换
    [FFRouter registerObjectRouteURL:@"/conversion" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        UGBalanceConversionController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionController"];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"额度转换";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"change"];
        UIImage *image = [UIImage imageNamed:@"change"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        return viewController;
    }];

    //注册 /banks 银行卡
    [FFRouter registerObjectRouteURL:@"/banks" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBindCardViewController" bundle:nil];
        UGBankCardInfoController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UGBankCardInfoController"];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"银行卡";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"yinhangqia"];
        UIImage *image = [UIImage imageNamed:@"yinhangqia"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /yuebao 利息宝
    [FFRouter registerObjectRouteURL:@"/yuebao" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
        UGYubaoViewController *viewController = [storyboard instantiateInitialViewController];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"利息宝";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"lixibao"];
        UIImage *image = [UIImage imageNamed:@"lixibao"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /Sign 签到
    [FFRouter registerObjectRouteURL:@"/Sign" handler:^id(NSDictionary *routerParameters) {
         UGSigInCodeViewController *viewController = [[UGSigInCodeViewController alloc] init];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"签到";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"qiandao"];
        UIImage *image = [UIImage imageNamed:@"qiandaosel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    //注册 /referrer 推广收益
    [FFRouter registerObjectRouteURL:@"/referrer" handler:^id(NSDictionary *routerParameters) {
         UGPromotionIncomeController *viewController = [[UGPromotionIncomeController alloc] init];
        viewController.view.backgroundColor     = UGBackgroundColor;
        viewController.tabBarItem.title         = @"推广收益";
        viewController.tabBarItem.image         = [UIImage imageNamed:@"shouyi1"];
        UIImage *image = [UIImage imageNamed:@"shouyi1sel"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        viewController.tabBarItem.selectedImage = image;
        UGNavigationController *nvc = [[UGNavigationController alloc]initWithRootViewController:viewController];
        return nvc;
    }];
    
    
}
@end
