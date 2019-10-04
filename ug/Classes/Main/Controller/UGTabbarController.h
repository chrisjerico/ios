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

@property (strong, nonatomic) NSMutableArray *vcs;


@end

NS_ASSUME_NONNULL_END
