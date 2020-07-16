//
//  NSTask+Block.m
//  AutoPacking
//
//  Created by fish on 2020/1/15.
//  Copyright © 2020 fish. All rights reserved.
//

#import "NSTask+Block.h"

#import <AppKit/AppKit.h>

@implementation OutputModel
@end

@implementation NSTask (Block)

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)path arguments:(NSArray<NSString *> *)arguments completion:(nonnull void (^)(OutputModel * _Nonnull))completion {
    NSArray *outputFiles = @[
        [NSTemporaryDirectory() stringByAppendingPathComponent:@".output1.txt"],
        [NSTemporaryDirectory() stringByAppendingPathComponent:@".output2.txt"],
        [NSTemporaryDirectory() stringByAppendingPathComponent:@".output3.txt"],
        [NSTemporaryDirectory() stringByAppendingPathComponent:@".output4.txt"],
    ];
    for (NSString *file in outputFiles) {
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    }
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = [outputFiles arrayByAddingObjectsFromArray:arguments];
    task.terminationHandler = ^(NSTask *ts) {
        [ts terminate];
        
        OutputModel *om = [OutputModel new];
        om.output1 = [NSString stringWithContentsOfFile:outputFiles[0] encoding:NSUTF8StringEncoding error:nil];
        om.output2 = [NSString stringWithContentsOfFile:outputFiles[1] encoding:NSUTF8StringEncoding error:nil];
        om.output3 = [NSString stringWithContentsOfFile:outputFiles[2] encoding:NSUTF8StringEncoding error:nil];
        om.output4 = [NSString stringWithContentsOfFile:outputFiles[3] encoding:NSUTF8StringEncoding error:nil];
        for (NSString *file in outputFiles) {
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
        
        if (completion) {
            completion(om);
        }
    };
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [task launch];
        [task waitUntilExit];
    });
    return task;
}
@end
