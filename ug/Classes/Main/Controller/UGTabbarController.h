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

@property (nonatomic) IBInspectable BOOL 允许未登录访问;   /**<   默认不允许 */
@property (nonatomic) IBInspectable BOOL 允许游客访问;    /**<   默认不允许 */
@end






@interface UGTabbarController : UITabBarController

+ (instancetype)shared;
+ (BOOL)canPushToViewController:(UIViewController *)vc;
- (void)setTabbarHeight:(CGFloat)height;    /**<   改变tabbar高度 */
@end

NS_ASSUME_NONNULL_END
