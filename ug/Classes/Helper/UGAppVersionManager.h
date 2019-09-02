//
//  UGAppVersionManager.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGAppVersionManager : NSObject
+(UGAppVersionManager *)shareInstance;

-(void)updateVersionNow:(BOOL)isNow;
@end

NS_ASSUME_NONNULL_END
