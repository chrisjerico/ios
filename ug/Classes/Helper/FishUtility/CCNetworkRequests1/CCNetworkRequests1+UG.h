//
//  CCNetworkRequests1+UG.h
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//


// 提款类型
typedef NS_ENUM(NSInteger, UGWithdrawalType) {
    UGWithdrawalTypeAll = 0,   // 全部
    UGWithdrawalTypeBankCard = 1, // 银行卡
    UGWithdrawalTypeAlipay = 2,   // 支付宝
    UGWithdrawalTypeWeChat = 3,   // 微信
    UGWithdrawalTypeVirtual = 4,  // 虚拟币
};


#import "CCNetworkRequests1.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCNetworkRequests1 (UG)

//得到线上配置的聊天室
- (CCSessionModel *)chat_getToken;


// 1.取得語言配置
- (CCSessionModel *)language_getConfigs;

// 2.取得完整語言包
- (CCSessionModel *)language_getLanguagePackage:(NSString *)languageCode;

// 3.依鍵值取得語言訊息
- (CCSessionModel *)language_getLanguageMessageByKeys:(NSArray <NSString *>*)keys languageCode:(NSString *)languageCode;

// 4.變更語言
- (CCSessionModel *)language_changeTo:(NSString *)languageCode;

// 获取提款渠道列表
- (CCSessionModel *)system_bankList:(UGWithdrawalType)type;

// 我的提款账户列表
- (CCSessionModel *)user_bankCard;

// 绑定提款账户
- (CCSessionModel *)user_bindBank:(UGWithdrawalType)type wid:(NSString *)wid addr:(NSString *)addr acct:(NSString *)acct pwd:(NSString *)pwd;

// 设置真实姓名
- (CCSessionModel *)user_profileName:(NSString *)realname;

// 提款申请
- (CCSessionModel *)withdraw_apply:(NSString *)wid amount:(NSString *)amount virtualAmount:(NSString *)vAmount pwd:(NSString *)pwd;

// 获取头像配置
- (CCSessionModel *)user_getAvatarSetting;

// 修改头像
- (CCSessionModel *)user_updateAvatar:(NSString *)publicAvatarId;

// 上传头像
- (CCSessionModel *)user_uploadAvatar:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
