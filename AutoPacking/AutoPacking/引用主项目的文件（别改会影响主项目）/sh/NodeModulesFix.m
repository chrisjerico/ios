//
//  NodeModulesFix.m
//  AutoPacking
//
//  Created by fish on 2020/4/16.
//  Copyright © 2020 fish. All rights reserved.
//

#import "NodeModulesFix.h"

@implementation NodeModulesFix
+ (void)fixExportType {
    BOOL isDir = NO;
    
    NSString *node_modules_path = [NSString stringWithFormat:@"%@/node_modules/@react-navigation", Path.rnProjectDir];
    for (NSString *path in [[NSFileManager defaultManager] enumeratorAtPath:node_modules_path].allObjects) {
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", node_modules_path, path];
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
        if (isExist && !isDir && [path containsString:@"index."]) {
            NSString *content = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
            content = [content stringByReplacingOccurrencesOfString:@"export type {\n" withString:@"export {\n"];
            [content writeToFile:fullPath atomically:true encoding:NSUTF8StringEncoding error:nil];
        }
    }
}
@end
