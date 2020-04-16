//
//  NSAppleScript+Helper.h
//  AutoReleaseRN
//
//  Created by fish on 2020/3/2.
//  Copyright © 2020 fish. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAppleScript (Helper)

+ (NSString *)runProcessAsAdministrator:(NSString *)scriptPath arguments:(NSArray *)arguments;
@end

NS_ASSUME_NONNULL_END
