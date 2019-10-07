//
//  NSNumber+Safe.h
//  C
//
//  Created by fish on 2018/5/17.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Safe)

@property (readonly) NSUInteger length;
- (NSNumber *)numberValue;
@end
