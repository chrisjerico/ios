//
//  NSTask+Block.h
//  AutoPacking
//
//  Created by fish on 2020/1/15.
//  Copyright © 2020 fish. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTask (Block)

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)path arguments:(NSArray<NSString *> *)arguments completion:(void (^)(NSTask *ts))completion;
@end

NS_ASSUME_NONNULL_END
