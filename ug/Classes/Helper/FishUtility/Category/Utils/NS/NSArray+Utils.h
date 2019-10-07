//
//  NSArray+Utils.h
//  C
//
//  Created by fish on 2018/1/24.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Utils.h"

@interface NSArray <ObjectType>(Utils)

- (ObjectType)objectWithTagString:(NSString *)tagString;    /**<    根据tagString获取元素 */


// ———— IsEqualValue，判断值相等的元素

- (BOOL)containsValue:(id)value;                            /**<    是否包含值相等的元素 */
- (NSUInteger)indexOfValue:(id)value;                       /**<    获取值相等的元素下标 */

// ———— IsEqualValue + KeyPath，判断元素keyPath内容值相等

- (BOOL)containsValue:(id)value keyPath:(NSString *)keyPath;
- (NSUInteger)indexOfValue:(id)value keyPath:(NSString *)keyPath;
- (ObjectType)objectWithValue:(id)value keyPath:(NSString *)keyPath;

- (NSArray <ObjectType>*)objectsWithValue:(id)value keyPath:(NSString *)keyPath;
- (NSArray *)valuesWithKeyPath:(NSString *)keyPath;
@end


@interface NSMutableArray <ObjectType>(Utils)

- (void)removeValue:(id)value;
@end
