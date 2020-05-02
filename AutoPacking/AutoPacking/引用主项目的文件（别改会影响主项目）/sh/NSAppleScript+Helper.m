//
//  NSAppleScript+Helper.m
//  AutoReleaseRN
//
//  Created by fish on 2020/3/2.
//  Copyright © 2020 fish. All rights reserved.
//

#import "NSAppleScript+Helper.h"

#import <AppKit/AppKit.h>


@implementation NSAppleScript (Helper)

+ (NSString *)runProcessAsAdministrator:(NSString *)scriptPath arguments:(NSArray *)arguments {
    NSString *fullScript = ({
        NSString *isAdminPre = _NSString(@"user name \"fish\" password \"%@\" with administrator privileges", [NSString stringWithContentsOfFile:@"/Users/fish/自动打包/pwd.txt" encoding:NSUTF8StringEncoding error:nil]);
        NSString *script = _NSString(@"%@ %@", scriptPath, [arguments componentsJoinedByString:@" "]);
        fullScript = [NSString stringWithFormat:@"do shell script \"%@\" %@", script, isAdminPre];
    });
    NSDictionary *errorInfo = [NSDictionary new];
    NSAppleEventDescriptor *eventResult = [[[NSAppleScript new] initWithSource:fullScript] executeAndReturnError:&errorInfo];
    
    // Set output to the AppleScript's output
    return eventResult ? [eventResult stringValue] : [errorInfo valueForKey:NSAppleScriptErrorMessage];
}
@end
