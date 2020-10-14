//
//  UGAppVersionManager.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGAppVersionManager : NSObject

@property (nonatomic, strong) void (^didAlertDismiss)(void);

+ (UGAppVersionManager *)shareInstance;

- (void)updateVersionApi:(BOOL)promptAlreadyLatest completion:(nullable void (^)(BOOL hasUpdate, BOOL isForce))completion;    /**<   是否要提示“已经是最新版本” */

@end

NS_ASSUME_NONNULL_END
