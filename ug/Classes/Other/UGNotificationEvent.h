//
//  UGNotificationEvent.h
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *UGNotificationLoginComplete;            // 登录成功
FOUNDATION_EXTERN NSString *UGNotificationloginCancel;
FOUNDATION_EXTERN NSString *UGNotificationShowLoginView;            // 显示登录弹框
FOUNDATION_EXTERN NSString *UGNotificationUserLogout;
FOUNDATION_EXTERN NSString *UGNotificationloginTimeout;
FOUNDATION_EXTERN NSString *UGNotificationGetUserInfo;              // 获取我的信息
FOUNDATION_EXTERN NSString *UGNotificationGetUserInfoComplete;      // 获取我的信息完成
FOUNDATION_EXTERN NSString *UGNotificationGetSystemConfigComplete;  // 获取配置信息完成
FOUNDATION_EXTERN NSString *UGNotificationUserAvatarChanged;
FOUNDATION_EXTERN NSString *UGNotificationAutoTransferOut;
FOUNDATION_EXTERN NSString *UGNotificationYuebaoInfoChanged;
FOUNDATION_EXTERN NSString *UGNotificationGetYuebaoInfo;
FOUNDATION_EXTERN NSString *UGNotificationFundTitlesTap;
FOUNDATION_EXTERN NSString *UGNotificationGetChanglongBetRecrod;

FOUNDATION_EXTERN NSString *UGNotificationDepositSuccessfully;
FOUNDATION_EXTERN NSString *UGNotificationGetRewardsSuccessfully;
FOUNDATION_EXTERN NSString *UGNotificationTryPlay;

FOUNDATION_EXTERN NSString *UGNotificationWithdrawalsSuccess;

FOUNDATION_EXTERN NSString *UGNotificationWithSkinSuccess;
FOUNDATION_EXTERN NSString *UGNotificationWithResetTabSuccess;
FOUNDATION_EXTERN NSString *UGNotificationWithRecordOfDeposit;

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
