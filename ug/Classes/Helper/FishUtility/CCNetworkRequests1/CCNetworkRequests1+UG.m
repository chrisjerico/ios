//
//  CCNetworkRequests1+UG.m
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "CCNetworkRequests1+UG.h"
#import "CMTimeCommon.h"
#import "UGEncryptUtil.h"

@implementation CCNetworkRequests1 (UG)

//得到线上配置的聊天室
- (CCSessionModel *)chat_getToken{
    return [self req:@"wjapp/api.php?c=chat&a=getToken"
                    :@{@"t":[NSString stringWithFormat:@"%ld",(long)[CMTimeCommon getNowTimestamp]]}
                    :true];
}

// 1.取得語言配置
- (CCSessionModel *)language_getConfigs {
    if (DisableLanguage) return nil;
    return [self req:@"wjapp/api.php?c=language&a=getConfigs"
                    :nil
                    :false];
}

// 2.取得完整語言包
- (CCSessionModel *)language_getLanguagePackage:(NSString *)languageCode {
    if (DisableLanguage) return nil;
    return [self req:@"wjapp/api.php?c=language&a=getLanguagePackage"
                    :@{@"languageCode":languageCode}
                    :false];
}

// 3.依鍵值取得語言訊息
- (CCSessionModel *)language_getLanguageMessageByKeys:(NSArray <NSString *>*)keys languageCode:(NSString *)languageCode {
    return [self req:@"wjapp/api.php?c=language&a=getLanguageMessageByKeys"
                    :@{@"languageCode":languageCode, @"keys":[keys jsonStringEncoded]}
                    :true];
}

// 4.變更語言
- (CCSessionModel *)language_changeTo:(NSString *)languageCode {
    if (DisableLanguage) return nil;
    return [self req:@"wjapp/api.php?c=language&a=changeTo"
                    :@{@"languageCode":languageCode}
                    :true];
}

// 获取提款渠道列表
- (CCSessionModel *)system_bankList:(UGWithdrawalType)type {
    return [self req:@"wjapp/api.php?c=system&a=bankList"
                    :@{@"status":@"0",
                       @"type":@(type),
                    }
                    :false];
}

// 我的提款账户列表
- (CCSessionModel *)user_bankCard {
    return [self req:@"wjapp/api.php?c=user&a=bankCard"
                    :nil
                    :false];
}

// 绑定提款账户
- (CCSessionModel *)user_bindBank:(UGWithdrawalType)type wid:(NSString *)wid addr:(NSString *)addr acct:(NSString *)acct {
    return [self req:@"wjapp/api.php?c=user&a=bindBank"
                    :@{@"type":@(type),
                       @"bank_id":wid,
                       @"bank_addr":addr,
                       @"bank_card":acct,
                       @"owner_name":UserI.fullName,
                    }
                    :true];
}

- (CCSessionModel *)user_profileName:(NSString *)realname {
    return [self req:@"wjapp/api.php?c=user&a=profileName"
                    :@{@"fullName":realname,}
                    :true];
}

- (CCSessionModel *)withdraw_apply:(NSString *)wid amount:(NSString *)amount virtualAmount:(NSString *)vAmount pwd:(NSString *)pwd {
    return [self req:@"wjapp/api.php?c=withdraw&a=apply"
                    :@{@"id":wid,
                       @"money":amount,
                       @"virtual_amount":vAmount,
                       @"pwd":[UGEncryptUtil md5:pwd],
                    }
                    :true];
}

@end
