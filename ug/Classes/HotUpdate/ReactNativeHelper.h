//
//  ReactNativeHelper.h
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved. iOS端 RCTEventEmitter 使用 Native发送通知消息到ReactNative
//  https://www.jianshu.com/p/8c575d5faaa6
//同时都推荐使用NativeEventEmitter子类
//在0.28版本之后，iOS向Js端发射消息的 思路如下
//Natived端，新版本模块类头文件必须继承自RCTEventEmitter
//1.-(NSArray *)supportedEvents;中设置所支持的通知的名称
//2.- (void)startObserving; Native端开启通知
//3.RN使用NativeEventEmitter.addListener模块监听通知
//4.RN在 componentWillUnmount 中remove移除通知
//5.- (void)stopObserving Native端移除通知


#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReactNativeHelper : RCTEventEmitter

+ (instancetype)shared;

+ (void)downloadNewestPackage:(void (^)(double progress))progress completion:(void (^)(BOOL ret))completion;

+ (void)waitLaunchFinish:(void (^)(BOOL waited))finishBlock;   /**<   等待rn加载完毕才执行block */

+ (void)sendEvent:(NSString *)eventName params:(id)params;            /**<   向rn发送事件 */
+ (id)addOnceBlocks:(id)blocks key:(NSString *)key;   /**<   添加block让rn调用（调完即移除）（返回值是block替换为key后的结果） */

+ (void)selectVC:(NSString *)vcName params:(NSDictionary *)params;    /**<   切换rn页面 */
+ (void)pushVC:(NSString *)vcName params:(NSDictionary *)params;
+ (void)refreshVC:(NSString *)vcName params:(NSDictionary *)params;
+ (void)leaveVC:(NSString *)vcName params:(NSDictionary *)params;
+ (void)removeVC:(NSString *)vcName;    /**<   移除页面 */

// 切换热更新
@property (nonatomic, class) NSString *currentCodePushKey;
+ (NSDictionary <NSString *, NSString *>*)allCodePushKey;

@end

NS_ASSUME_NONNULL_END
