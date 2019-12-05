//
//  ShellHelper.h
//  AutoPacking
//
//  Created by fish on 2019/11/26.
//  Copyright © 2019 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteModel.h"

#define ProjectDir ([NSUserName() isEqualToString:@"fish"] ? @"/Users/fish/archive" : @"/Users/ug/pack")
#define IpaDir ([NSUserName() isEqualToString:@"fish"] ? @"/Users/fish/archive" : @"/Library/WebServer/Documents/ipa_")

NS_ASSUME_NONNULL_BEGIN

@interface ShellHelper : NSObject

+ (void)pullCode:(void (^)(void))completion;        /**<   拉取最新代码 */
+ (void)packing:(NSArray <SiteModel *> *)sites completion:(void (^)(void))completion;         /**<   打包 */
+ (void)upload:(void (^)(void))completion;          /**<   上传 */

@end

NS_ASSUME_NONNULL_END
