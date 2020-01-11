//
//  JSPatchHelper.h
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSPatchHelper : NSObject

+ (void)updateVersion:(NSString *)version completion:(void (^)(BOOL ok))completion;  /**<   版本更新 */

@end

NS_ASSUME_NONNULL_END
