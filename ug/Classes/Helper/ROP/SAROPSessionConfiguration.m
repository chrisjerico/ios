//
//  SAROPSessionConfiguration.m
//  ChargeManage
//
//  Created by sagesse on 5/19/16.
//  Copyright © 2016 Shenzhen Comtop Information Techology Co., Ltd. All rights reserved.
//

#import "SAROPSessionConfiguration.h"

#define SAROP_SESSION_DEBUG_SERVER_URL  @"http://172.24.91.1:8082"
#define SAROP_SESSION_DEBUG_SERVER_NAME @"msp-cas"
#define SAROP_SESSION_DEBUG_APP_KEY     @"app-key"
#define SAROP_SESSION_DEBUG_APP_SECRET  @"app-secret"

@interface SAROPSessionConfiguration () {
    NSMutableDictionary* _allHTTPHeaderFields;
}

@property (nonatomic, strong) NSURLSessionConfiguration* configuration;

@end

@implementation SAROPSessionConfiguration

///
/// @brief 默认ROP配置
///
+ (instancetype)defaultConfiguration {
    static SAROPSessionConfiguration* _defaultConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultConfiguration = [self configurationWithConfiguration: configuration];
        _defaultConfiguration.identifier = @"default.rop.sa";
    });
    return _defaultConfiguration;
}

///
/// @brief 自定义的ROP配置
///
+ (instancetype)configurationWithConfiguration:(NSURLSessionConfiguration*)systemConfiguration {
    SAROPSessionConfiguration* configuration = [[self alloc] init];
    
    NSDictionary* info = NSBundle.mainBundle.infoDictionary;
    
    NSString* url = [info valueForKeyPath: @"SAROPServer.SAROPServerURL"] ?: SAROP_SESSION_DEBUG_SERVER_URL;
    NSString* name = [info valueForKeyPath: @"SAROPServer.SAROPServerName"] ?: SAROP_SESSION_DEBUG_SERVER_NAME;
    NSString* appKey = [info valueForKeyPath: @"SAROPServer.SAROPServerKey"] ?: SAROP_SESSION_DEBUG_APP_KEY;
    NSString* appSecret = [info valueForKeyPath: @"SAROPServer.SAROPServerSecret"] ?: SAROP_SESSION_DEBUG_APP_SECRET;
    
    configuration.defaultAppKey = appKey;
    configuration.defaultAppSecret = appSecret;
    
    configuration.serverURL = [NSURL URLWithString:url];
    configuration.serverName = name;
    configuration.systemLocale = [NSLocale currentLocale];
    
    configuration.configuration = systemConfiguration;
    
    return configuration;
}


- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    _allHTTPHeaderFields[field] = value;
}
- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    _allHTTPHeaderFields[field] = value;
}
- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return _allHTTPHeaderFields[field];
}
- (NSDictionary*)allHTTPHeaderFields {
    return _allHTTPHeaderFields.copy;
}

#pragma mark - NSCopying & NSMutableCopying

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    typeof(self) ns = [self.class allocWithZone:zone];
    
    ns.defaultAppKey = self.defaultAppKey;
    ns.defaultAppSecret = self.defaultAppSecret;
    
    ns.serverURL = self.serverURL;
    ns.serverName = self.serverName;
    ns.systemLocale = self.systemLocale;
    
    ns.configuration = self.configuration;
    
    ns->_allHTTPHeaderFields = self->_allHTTPHeaderFields;
    
    return ns;
}

@end
