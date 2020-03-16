//
//  NSNumber+Safe.m
//  C
//
//  Created by fish on 2018/5/17.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "NSNumber+Safe.h"

@implementation NSNumber (Safe)

- (NSUInteger)length {
    return [self.stringValue length];
}

- (NSNumber *)numberValue {
    return self;
}
@end
