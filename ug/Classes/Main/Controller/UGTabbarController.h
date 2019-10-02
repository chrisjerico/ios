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

NS_ASSUME_NONNULL_BEGIN

@interface UGTabbarController : UITabBarController

@property (strong, nonatomic) UGChatViewController *qdwebVC;

@property (strong, nonatomic) UGNavigationController *homeNavVC;

@property (strong, nonatomic) UGNavigationController *chatNavVC;

@property (strong, nonatomic) UGNavigationController *LotteryNavVC;

@property (strong, nonatomic) UGNavigationController *promotionsNavVC;

@property (strong, nonatomic) UGNavigationController *mineNavVC ;

@end

NS_ASSUME_NONNULL_END
