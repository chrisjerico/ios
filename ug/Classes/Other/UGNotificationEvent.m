
//
//  UGNotificationEvent.m
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNotificationEvent.h"

NSString *UGNotificationLoginComplete = @"UGNotificationLoginComplete";
NSString *UGNotificationloginCancel = @"UGNotificationloginCancel";
NSString *UGNotificationloginTimeout = @"UGNotificationloginTimeout";
NSString *UGNotificationUserLogout = @"UGNotificationUserLogout";
NSString *UGNotificationShowLoginView = @"UGNotificationShowLoginView";
NSString *UGNotificationGetUserInfo = @"UGNotificationGetUserInfo";
NSString *UGNotificationGetUserInfoComplete = @"UGNotificationGetUserInfoComplete";
NSString *UGNotificationGetSystemConfigComplete = @"UGNotificationGetSystemConfigComplete"; // 获取系统配置成功
NSString *UGNotificationUserAvatarChanged = @"UGNotificationUserAvatarChanged";
NSString *UGNotificationYuebaoInfoChanged = @"UGNotificationYuebaoInfoChanged";
NSString *UGNotificationGetYuebaoInfo = @"UGNotificationGetYuebaoInfo";
NSString *UGNotificationFundTitlesTap = @"UGNotificationFundTitlesTap";
NSString *UGNotificationGetChanglongBetRecrod = @"UGNotificationGetChanglongBetRecrod";

NSString *UGNotificationDepositSuccessfully = @"UGNotificationDepositSuccessfully";//跳到存款记录
NSString *UGNotificationGetRewardsSuccessfully = @"UGNotificationGetRewardsSuccessfully";

NSString *UGNotificationTryPlay = @"UGNotificationTryPlay";
NSString *UGNotificationWithdrawalsSuccess = @"UGNotificationWithdrawalsSuccess";
NSString *UGNotificationWithSkinSuccess = @"UGNotificationWithSkinSuccess";//换肤
NSString *UGNotificationWithResetTabSuccess = @"UGNotificationWithResetTabSuccess";//换tabBar

NSString *UGNotificationWithRecordOfDeposit = @"UGNotificationWithRecordOfDeposit";//存款记录刷新
///
/// 登录授权
///
/// 如果没有授权将跳转至登录页面, 并在登录完成后回调
///
FOUNDATION_EXPORT void UGLoginAuthorize(void(^handler)(BOOL isFinish)) {
    CMMETHOD_BEGIN;
    
    // 如果己经登录.
    BOOL isLogin = UGLoginIsAuthorized();
    
    if (isLogin) {
        if (handler != nil) {
            handler(true);
        }
        return ;
        
    }
    @synchronized (UGUserModel.class) {
        static NSMutableArray* s_arr = nil;
        
        if (s_arr == nil) {
            s_arr = NSMutableArray.new;
            // 添加回调
            SANotificationEventSubscribe(UGNotificationLoginComplete, UGUserModel.class, ^(id self, id obj) {
                @synchronized (UGUserModel.class) {
                    [s_arr enumerateObjectsUsingBlock:^(void(^obj)(BOOL), NSUInteger idx, BOOL * _Nonnull stop) {
                        obj(true);
                    }];
                    s_arr = nil;
                }
            });
            SANotificationEventSubscribe(UGNotificationloginCancel, UGUserModel.class, ^(id self, id obj) {
                @synchronized (UGUserModel.class) {
                    [s_arr enumerateObjectsUsingBlock:^(void(^obj)(BOOL), NSUInteger idx, BOOL * _Nonnull stop) {
                        obj(false);
                    }];
                    s_arr = nil;
                }
            });
            
            SANotificationEventPost(UGNotificationShowLoginView, nil);
        }
        if (s_arr != nil && handler != nil) {
            [s_arr addObject:handler];
        }
    }
    
    CMMETHOD_END;
}

///
/// 检查是否己经授权
///
/// 这个方法不会跳转至登录
///
FOUNDATION_EXPORT bool UGLoginIsAuthorized() {
    
    return UGUserModel.currentUser != nil;
    
}
