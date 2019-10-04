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
        UGHomeViewController *mainVC = [mainStoryboard instantiateInitialViewController];
        return mainVC;
    }];
    
    //注册 /changLong 长龙助手
    [FFRouter registerObjectRouteURL:@"/changLong" handler:^id(NSDictionary *routerParameters) {
        UGChangLongController *changlongVC = [[UGChangLongController alloc] init];
        return changlongVC;
    }];
    
    //注册 /lotteryList 彩票大厅
    [FFRouter registerObjectRouteURL:@"/lotteryList" handler:^id(NSDictionary *routerParameters) {
        UGYYLotteryHomeViewController *vc = [[UGYYLotteryHomeViewController alloc] init];
        return vc;
    }];
    
    //注册 /activity 优惠活动
    [FFRouter registerObjectRouteURL:@"/activity" handler:^id(NSDictionary *routerParameters) {
        UGPromotionsController *vc = [[UGPromotionsController alloc] init];
        return vc;
    }];
    
    //注册 /chatRoomList 聊天室
    [FFRouter registerObjectRouteURL:@"/chatRoomList" handler:^id(NSDictionary *routerParameters) {
       UGChatViewController  *qdwebVC = [[UGChatViewController alloc] init];
        qdwebVC.webTitle = @"聊天室";
        return qdwebVC;
    }];
    
    //注册 /lotteryRecord 开奖记录
    [FFRouter registerObjectRouteURL:@"/lotteryRecord" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"UGLotteryRecordController" bundle:nil];
        UGLotteryRecordController *recordVC = [storyboad instantiateInitialViewController];
        return recordVC;
    }];
    
    //注册 /user 我的
    [FFRouter registerObjectRouteURL:@"/user" handler:^id(NSDictionary *routerParameters) {
          UGMineSkinViewController * mineVC = [[UGMineSkinViewController alloc] init];
           return mineVC;
    }];
    
    //注册 /task 任务中心
    [FFRouter registerObjectRouteURL:@"/task" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGMissionCenterViewController" bundle:nil];
        UGMissionCenterViewController *missionVC = [storyboard instantiateInitialViewController];
        return missionVC;
    }];
    
    //注册 /securityCenter 安全中心
    [FFRouter registerObjectRouteURL:@"/securityCenter" handler:^id(NSDictionary *routerParameters) {
        UGSecurityCenterViewController *securityCenterVC = [[UGSecurityCenterViewController alloc] init];
        return securityCenterVC;
    }];
    
    //注册 /funds 资金管理
    [FFRouter registerObjectRouteURL:@"/funds" handler:^id(NSDictionary *routerParameters) {
         UGFundsViewController * vc = [UGFundsViewController new];
         return vc;
    }];
    
    //注册 /message 站内信
    [FFRouter registerObjectRouteURL:@"/message" handler:^id(NSDictionary *routerParameters) {
        UGMailBoxTableViewController *mailBoxVC = [[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        return mailBoxVC;
    }];
    
    //注册 /conversion 额度转换
    [FFRouter registerObjectRouteURL:@"/conversion" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        UGBalanceConversionController *conversion = [storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionController"];
        return conversion;
    }];

    //注册 /banks 银行卡
    [FFRouter registerObjectRouteURL:@"/banks" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBindCardViewController" bundle:nil];
        UGBankCardInfoController *binkVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBankCardInfoController"];
        return binkVC;
    }];
    
    //注册 /yuebao 利息宝
    [FFRouter registerObjectRouteURL:@"/yuebao" handler:^id(NSDictionary *routerParameters) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
        UGYubaoViewController *lixibaoVC = [storyboard instantiateInitialViewController];
        return lixibaoVC;
    }];
    
    //注册 /Sign 签到
    [FFRouter registerObjectRouteURL:@"/Sign" handler:^id(NSDictionary *routerParameters) {
         UGSigInCodeViewController *vc = [[UGSigInCodeViewController alloc] init];
         return vc;
    }];
    
    //注册 /referrer 推广收益
    [FFRouter registerObjectRouteURL:@"/referrer" handler:^id(NSDictionary *routerParameters) {
         UGPromotionIncomeController *incomeVC = [[UGPromotionIncomeController alloc] init];
         return incomeVC;
    }];
    
    
}
@end
