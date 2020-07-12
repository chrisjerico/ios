//
//  CCNetworkRequests1+UG.h
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//



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
- (CCSessionModel *)language_getLanguageMessageByKeys:(NSString *)languageCode keys:(NSArray <NSString *>*)keys;

// 4.變更語言
- (CCSessionModel *)language_changeTo:(NSString *)languageCode;

@end

NS_ASSUME_NONNULL_END
