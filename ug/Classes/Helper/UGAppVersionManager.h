//
//  UGAppVersionManager.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGAppVersionManager : NSObject

+ (UGAppVersionManager *)shareInstance;

- (void)updateVersionApi:(BOOL)promptAlreadyLatest completion:(nullable void (^)(BOOL showUpdated, BOOL isForce))completion;    /**<   是否要提示“已经是最新版本” */

@end

NS_ASSUME_NONNULL_END
