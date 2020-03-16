//
//  NSTask+Block.m
//  AutoPacking
//
//  Created by fish on 2020/1/15.
//  Copyright © 2020 fish. All rights reserved.
//

#import "NSTask+Block.h"

#import <AppKit/AppKit.h>


@implementation NSTask (Block)

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)path arguments:(NSArray<NSString *> *)arguments completion:(void (^)(NSTask *ts))completion {
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = arguments;
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        if (completion) {
            completion(ts);
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [task launch];
        [task waitUntilExit];
    });
    return task;
}
@end
