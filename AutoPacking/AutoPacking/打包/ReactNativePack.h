//
//  ReactNativePack.h
//  AutoPacking
//
//  Created by fish on 2020/6/25.
//  Copyright © 2020 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitModel.h"

#define RNPack [ReactNativePack shared]
#define RNCheckVersion2 @"1.2" // react-native升级了版本时更新，修改后会导致旧版本无法热更新

NS_ASSUME_NONNULL_BEGIN

@interface ReactNativePack : NSObject

@property (nonatomic, readonly) NSString *projectDir;       /**<   rn项目目录 */
@property (nonatomic, readonly) NSString *privateKey;       /**<   私钥 */

+ (instancetype)shared;
- (void)setupPlist:(NSDictionary *)dict;    /**<   初始化 */
- (void)checkEnvironment:(NSString *)environment log:(NSString *)log completion:(void (^)(NSString *environment, NSString *log))completion;
- (void)getCurrentVersionWithEnvironment:(NSString *)environment completion:(void (^)(NSString *version))completion;   /**<   获取当前版本号 */
- (void)pullCode:(NSString *)branch completion:(void (^)(void))completion;
- (void)pack:(NSString *)version environment:(NSString *)environment log:(NSString *)log completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
