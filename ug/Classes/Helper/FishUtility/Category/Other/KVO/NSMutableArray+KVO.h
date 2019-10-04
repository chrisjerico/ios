//
//  NSMutableArray+KVO.h
//  AAA
//
//  Created by fish on 16/6/27.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kNSMutableArrayKindDidInsertObject;
FOUNDATION_EXPORT NSString *const kNSMutableArrayKindDidRemoveObject;
FOUNDATION_EXPORT NSString *const kNSMutableArrayKindDidReplaceObject;
FOUNDATION_EXPORT NSString *const kNSMutableArrayKindDidRemoveAllObjects;
FOUNDATION_EXPORT NSString *const kNSMutableArrayKindDidExchangeObject;


@protocol NSMutableArrayDidChangeDelegate <NSObject>

@optional
- (void)array:(NSMutableArray *)array didChange:(NSDictionary<NSString *,id> *)change;                                  /**<   数组元素发生变化时调用 */

- (void)array:(NSMutableArray *)array didInsertObject:(id)object index:(NSUInteger)index;                               /**<   添加 */
- (void)array:(NSMutableArray *)array didRemoveObject:(id)object index:(NSUInteger)index;                               /**<   移除 */
- (void)array:(NSMutableArray *)array didReplaceObject:(id)oldObject index:(NSUInteger)index newObject:(id)newObject;   /**<   替换 */
- (void)arrayWillRemoveAllObjects:(NSMutableArray *)array;                                                              /**<   清空 */

- (void)array:(NSMutableArray *)array didExchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;     /**<   交换位置 */
- (void)array:(NSMutableArray *)array didSortWithOldArray:(NSArray *)oldArray;                                          /**<   排序 */
@end


@interface NSMutableArray (KVO)

@property (readonly, copy) NSArray *observers;

- (void)addObserver:(id <NSMutableArrayDidChangeDelegate>)observer;
- (void)removeObserver:(id <NSMutableArrayDidChangeDelegate>)observer;

@end

