//
//  NSObject+AspectsHelper.h
//  ug
//
//  Created by fish on 2019/11/19.
//  Copyright © 2019 ug. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AspectsHelper)

+ (void)cc_hookSelector:(SEL)selector withOptions:(AspectOptions)options usingBlock:(void(^)(id<AspectInfo> ai))block error:(NSError **)error;
- (void)cc_hookSelector:(SEL)selector withOptions:(AspectOptions)options usingBlock:(void(^)(id<AspectInfo> ai))block error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
