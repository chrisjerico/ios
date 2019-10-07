//
//  NSMutableDictionary+KVO.h
//  AAA
//
//  Created by fish on 16/6/28.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kNSMutableDictionaryKindDidSetObject;
FOUNDATION_EXPORT NSString *const kNSMutableDictionaryKindDidRemoveObject;
FOUNDATION_EXPORT NSString *const kNSMutableDictionaryKindDidRemoveAllObjects;


@protocol NSMutableDictionaryDidChangeDelegate <NSObject>

- (void)dictionary:(NSMutableDictionary *)dict didChange:(NSDictionary<NSString *,id> *)change;     /**<   字典元素发生变化时调用 */

- (void)dictionary:(NSMutableDictionary *)dict didSetObject:(id)object key:(id)key;                 /**<   添加 */
- (void)dictionary:(NSMutableDictionary *)dict didRemoveObject:(id)object key:(id)key;              /**<   移除 */
- (void)dictionaryWillRemoveAllObjects:(NSMutableDictionary *)dict;                                 /**<   清空 */
@end



@interface NSMutableDictionary (KVO)

@property (readonly, copy) NSArray *observers;

- (void)addObserver:(id <NSMutableDictionaryDidChangeDelegate>)observer;
- (void)removeObserver:(id <NSMutableDictionaryDidChangeDelegate>)observer;

@end

