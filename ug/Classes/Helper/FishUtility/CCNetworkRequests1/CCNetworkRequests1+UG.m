//
//  CCNetworkRequests1+UG.m
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "CCNetworkRequests1+UG.h"
#import "CMTimeCommon.h"

@implementation CCNetworkRequests1 (UG)

//得到线上配置的聊天室
- (CCSessionModel *)chat_getToken{
    return [self req:@"wjapp/api.php?c=chat&a=getToken"
                    :@{@"t":[NSString stringWithFormat:@"%ld",(long)[CMTimeCommon getNowTimestamp]]}
                    :true];
}

// 1.取得語言配置
- (CCSessionModel *)language_getConfigs {
    return [self req:@"wjapp/api.php?c=language&a=getConfigs"
                    :nil
                    :false];
}

// 2.取得完整語言包
- (CCSessionModel *)language_getLanguagePackage:(NSString *)languageCode {
    return [self req:@"wjapp/api.php?c=language&a=getLanguagePackage"
                    :@{@"languageCode":languageCode}
                    :false];
}

// 3.依鍵值取得語言訊息
- (CCSessionModel *)language_getLanguageMessageByKeys:(NSString *)languageCode keys:(NSArray <NSString *>*)keys {
    return [self req:@"wjapp/api.php?c=language&a=getLanguageMessageByKeys"
                    :@{@"languageCode":languageCode, @"keys":keys}
                    :true];
}

// 4.變更語言
- (CCSessionModel *)language_changeTo:(NSString *)languageCode {
    return [self req:@"wjapp/api.php?c=language&a=changeTo"
                    :@{@"languageCode":languageCode}
                    :true];
}

@end
