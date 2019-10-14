//
//  UGTabbarController.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TabBarController1 [UGTabbarController shared]

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (CanPush)

@property (nonatomic) IBInspectable BOOL 未登录禁止访问;
@property (nonatomic) IBInspectable BOOL 游客禁止访问;
@end






@interface UGTabbarController : UITabBarController

+ (instancetype)shared;
+ (BOOL)canPushToViewController:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
