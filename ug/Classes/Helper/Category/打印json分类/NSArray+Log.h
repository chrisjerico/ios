//
//  NSArray+Log.h
//  UGBWApp
//
//  Created by ug on 2020/5/13.
//  Copyright © 2020 ug. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Log)
// 检查内容是否合法
- (BOOL)checkArrayLegal;
@end

@interface NSDictionary (Log)

// 检查内容是否合法
- (BOOL)checkDictionaryLegal;

@end

NS_ASSUME_NONNULL_END
