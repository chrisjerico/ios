//
//  UGTabbarController.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TabBarController1 [UGTabbarController shared]

#define CheckLogin(允许未登录访问, 允许游客访问, returnValue)\
{\
    UGUserModel *user = [UGUserModel currentUser];\
    BOOL isLogin = UGLoginIsAuthorized();\
    if (!isLogin && !(允许未登录访问)) {\
        SANotificationEventPost(UGNotificationShowLoginView, nil);\
        return returnValue;\
    }\
    if (user.isTest && !(允许游客访问)) {\
        UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];\
        [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {\
            SANotificationEventPost(UGNotificationShowLoginView, nil);\
        }];\
        return returnValue;\
    }\
}


NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (CanPush)

@property (nonatomic) IBInspectable BOOL 允许未登录访问;   /**<   默认不允许 */
@property (nonatomic) IBInspectable BOOL 允许游客访问;    /**<   默认不允许 */
@end






@interface UGTabbarController : UITabBarController

+ (instancetype)shared;
+ (BOOL)canPushToViewController:(UIViewController *)vc;
- (void)setTabbarHeight:(CGFloat)height;    /**<   改变tabbar高度 */
-(void)setUGMailBoxTableViewControllerBadge; /**<   设置站内信有红点 */
@end

NS_ASSUME_NONNULL_END
