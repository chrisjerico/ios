//
//  SAROPSessionConfiguration.h
//  ChargeManage
//
//  Created by sagesse on 5/19/16.
//  Copyright © 2016 Shenzhen Comtop Information Techology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

///
///
/// 默认使用
///
///
@interface SAROPSessionConfiguration : NSObject <NSCopying, NSMutableCopying>

/// 配置id
@property (nonatomic, strong) NSString *identifier;

/// 服务器地址
@property (nonatomic, strong) NSURL* serverURL;
@property (nonatomic, strong) NSString* serverName;
/// 系统语言环境
@property (nonatomic, strong) NSLocale* systemLocale;

/// 默认app配置
@property (nonatomic, strong) NSString* defaultAppKey;
@property (nonatomic, strong) NSString* defaultAppSecret;

/// 附加信息
@property (nonatomic, readonly, copy) NSDictionary* allHTTPHeaderFields;

///
/// @brief 默认ROP配置, 这些配置将会从Info.plist中读取
///
/// @note Info.plist中的配置:
/// <key>SAROPServer</key>
/// <dict>
///     <key>SAROPServerURL</key>
///     <string>http://172.24.91.1:8082</string>
///     <key>SAROPServerName</key>
///     <string>msp-cas</string>
///     <key>SAROPServerKey</key>
///     <string>app-key</string>
///     <key>SAROPServerSecret</key>
///     <string>app-secret</string>
/// </dict>
///
+ (instancetype)defaultConfiguration;
///
/// @brief 自定义的ROP配置
///
+ (instancetype)configurationWithConfiguration:(NSURLSessionConfiguration*)configuration;


- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

@end
