//
//  UGTabbarController.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGChatViewController.h"
#import "UGNavigationController.h"
#import "UGBalanceConversionController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGTabbarController : UITabBarController

@property (strong, nonatomic)UGBalanceConversionController *balanceConversionVC;
@property (strong, nonatomic) UGChatViewController *qdwebVC;

@property (strong, nonatomic) NSMutableArray *vcs;

@property (strong, nonatomic) UGNavigationController *nvcHome;

@property (strong, nonatomic) UGNavigationController *nvcChangLong;

@property (strong, nonatomic) UGNavigationController *nvcLotteryList;

@property (strong, nonatomic) UGNavigationController *nvcActivity;

@property (strong, nonatomic) UGNavigationController *nvcChatRoomList;

@property (strong, nonatomic) UGNavigationController *nvcLotteryRecord;

@property (strong, nonatomic) UGNavigationController *nvcUser;

@property (strong, nonatomic) UGNavigationController *nvcTask;

@property (strong, nonatomic) UGNavigationController *nvcSecurityCenter;

@property (strong, nonatomic) UGNavigationController *nvcFunds;

@property (strong, nonatomic) UGNavigationController *nvcMessage;

@property (strong, nonatomic) UGNavigationController *nvcConversion;

@property (strong, nonatomic) UGNavigationController *nvcBanks;

@property (strong, nonatomic) UGNavigationController *nvcYuebao;

@property (strong, nonatomic) UGNavigationController *nvcSign;

@property (strong, nonatomic) UGNavigationController *nvcReferrer;



@end

NS_ASSUME_NONNULL_END
