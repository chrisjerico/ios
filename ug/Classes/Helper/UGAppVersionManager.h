//
//  UGAppVersionManager.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGAppVersionManager : NSObject
+ (UGAppVersionManager *)shareInstance;

- (void)updateVersionApi:(BOOL)flag;    /**<   flag= 1时，无最新版本提示“已是最新”，flag=0则不提示 */
@end

NS_ASSUME_NONNULL_END
