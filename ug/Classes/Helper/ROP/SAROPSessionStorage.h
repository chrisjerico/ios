//
//  SAROPCookieStorage.h

#import "SAROPSessionConfiguration.h"

///
/// 会话信息
///
@interface SAROPSessionStorage : NSObject

@property (nonatomic,strong , nonnull) NSString* identifier;//readonly

@property (nonatomic, strong, nonnull) NSString* appKey;
@property (nonatomic, strong, nonnull) NSString* appSecret;

@property (nonatomic, strong, nullable) NSString* sessionId;
@property (nonatomic, strong, nullable) NSString* sessionTimestamp;

@property (nonatomic, strong, nullable) NSString* jsessionId;
@property (nonatomic, strong, nullable) NSString* imToken;
@property (nonatomic, strong, nullable) NSString* tenantId;

///
/// 使用标识符创建/加载(如果有的话)
///
+ (nonnull instancetype)sessionStorageWithIdentifier:(nonnull NSString*)identifier;

@end
