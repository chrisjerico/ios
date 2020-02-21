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
+ (id)addOnceBlocks:(id)blocks key:(NSString *)key;   /**<   添加block让rn调用（调完即移除）（返回值是block替换为key后的结果） */
+ (void)sendEvent:(NSString *)eventName params:(id)params;            /**<   向rn发送事件 */
+ (void)selectViewController:(NSString *)vcName params:(NSDictionary * _Nullable)params;    /**<   切换rn页面 */
+ (void)waitLaunchFinish:(void (^)(BOOL waited))finishBlock;   /**<   等待rn加载完毕才执行block */
@end

NS_ASSUME_NONNULL_END
