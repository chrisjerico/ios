//
//  UGNotificationEvent.h
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *UGNotificationLoginComplete;
FOUNDATION_EXTERN NSString *UGNotificationloginCancel;
FOUNDATION_EXTERN NSString *UGNotificationShowLoginView;
FOUNDATION_EXTERN NSString *UGNotificationUserLogout;
FOUNDATION_EXTERN NSString *UGNotificationloginTimeout;
FOUNDATION_EXTERN NSString *UGNotificationGetUserInfo;
FOUNDATION_EXTERN NSString *UGNotificationGetUserInfoComplete;
FOUNDATION_EXTERN NSString *UGNotificationUserAvatarChanged;
FOUNDATION_EXTERN NSString *UGNotificationAutoTransferOut;
FOUNDATION_EXTERN NSString *UGNotificationYuebaoInfoChanged;
FOUNDATION_EXTERN NSString *UGNotificationGetYuebaoInfo;
FOUNDATION_EXTERN NSString *UGNotificationFundTitlesTap;
FOUNDATION_EXTERN NSString *UGNotificationGetChanglongBetRecrod;


/// 登录授权
///
/// 如果没有授权将跳转至登录页面, 并在登录完成后回调
///
FOUNDATION_EXPORT void UGLoginAuthorize(void(^handler)(BOOL isFinish));

///
/// 检查是否己经授权
///
/// 这个方法不会跳转至登录
///
FOUNDATION_EXPORT bool UGLoginIsAuthorized(void);
