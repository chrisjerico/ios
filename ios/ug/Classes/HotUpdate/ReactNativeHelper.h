//
//  ReactNativeHelper.h
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReactNativeHelper : RCTEventEmitter


+ (instancetype)shared;
- (void)updateVersion:(void (^)(NSString *version))completion;  /**<   版本更新 */
+ (UIViewController *)vcWithName:(NSString *)name params:(NSDictionary * _Nullable)params;    /**<   创建rn页面 */
+ (void)sendEvent:(NSString *)eventName params:(NSDictionary * _Nullable)params;              /**<   向rn发送事件 */
@end

NS_ASSUME_NONNULL_END
