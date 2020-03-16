//
//  NSUserDefaults+Utils.m
//  BBB
//
//  Created by fish on 16/9/13.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "NSUserDefaults+Utils.h"

@implementation NSUserDefaults (Utils)

- (BOOL)containsKey:(NSString *)key {
    return !!self.dictionaryRepresentation[key];
}

@end
