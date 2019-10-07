//
//  NSMutableArray+KVO.m
//  AAA
//
//  Created by fish on 16/6/27.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "NSMutableArray+KVO.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"


NSString *const kNSMutableArrayKindDidInsertObject     = @"kNSMutableArrayKindDidInsertObject";
NSString *const kNSMutableArrayKindDidRemoveObject     = @"kNSMutableArrayKindDidRemoveObject";
NSString *const kNSMutableArrayKindDidReplaceObject    = @"kNSMutableArrayKindDidReplaceObject";
NSString *const kNSMutableArrayKindDidRemoveAllObjects = @"kNSMutableArrayKindDidRemoveAllObjects";
NSString *const kNSMutableArrayKindDidExchangeObject   = @"kNSMutableArrayKindDidExchangeObject";


@interface NSObject ()

- (void)array:(NSMutableArray *)array didChange:(NSDictionary<NSString *,id> *)change;                                  /**<   数组元素发生变化时调用 */

- (void)array:(NSMutableArray *)array didInsertObject:(id)object index:(NSUInteger)index;                               /**<   添加 */
- (void)array:(NSMutableArray *)array didRemoveObject:(id)object index:(NSUInteger)index;                               /**<   移除 */
- (void)array:(NSMutableArray *)array didReplaceObject:(id)oldObject index:(NSUInteger)index newObject:(id)newObject;   /**<   替换 */
- (void)arrayWillRemoveAllObjects:(NSMutableArray *)array;                                                              /**<   清空 */

- (void)array:(NSMutableArray *)array didExchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;     /**<   交换位置 */
- (void)array:(NSMutableArray *)array didSortWithOldArray:(NSArray *)oldArray;                                          /**<   排序 */
@end



@implementation NSMutableArray (KVO)

- (NSPointerArray *)observerPointers {
    NSPointerArray *obj = objc_getAssociatedObject(self, @selector(observers));
    if (!obj) {
        obj = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
        objc_setAssociatedObject(self, @selector(observers), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (NSArray *)observers {
    return self.observerPointers.allObjects;
}

- (void)addObserver:(id <NSMutableArrayDidChangeDelegate>)observer {
    if (![self.observers containsObject:observer])
        [self.observerPointers addPointer:(__bridge void * _Nullable)(observer)];
}

- (void)removeObserver:(id <NSMutableArrayDidChangeDelegate>)observer {
    NSUInteger index = [self.observers indexOfObject:observer];
    if (index < self.observers.count)
        [self.observerPointers removePointerAtIndex:index];
}


#pragma mark - JRSwizzle 方法交换

+ (void)load {
    [super load];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        // 增删改
        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_insertObject:atIndex:) withMethod:@selector(insertObject:atIndex:) error:nil];           // 只要是添加都会调这一函数

        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_removeObjectAtIndex:) withMethod:@selector(removeObjectAtIndex:) error:nil];             // 除removeAllObjects外，只要是移除都会调用此函数
        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_removeAllObjects) withMethod:@selector(removeAllObjects) error:nil];

        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_replaceObjectAtIndex:withObject:) withMethod:@selector(replaceObjectAtIndex:withObject:) error:nil]; // 除setObject:atIndex:外，只要是替换都回调此函数
        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_setObject:atIndex:) withMethod:@selector(setObject:atIndex:) error:nil];


        // 排序
        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_exchangeObjectAtIndex:withObjectAtIndex:) withMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) error:nil];
        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_sortUsingComparator:) withMethod:@selector(sortUsingComparator:) error:nil];
        [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(zj_sortWithOptions:usingComparator:) withMethod:@selector(sortWithOptions:usingComparator:) error:nil];
    });
}


#pragma mark 增删改

- (void)zj_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count || !anObject)
        return;

    [self zj_insertObject:anObject atIndex:index];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didInsertObject:index:)])
            [observer array:self didInsertObject:anObject index:index];

        if ([observer respondsToSelector:@selector(array:didChange:)])
            [observer array:self didChange:@{@"newObj":anObject, @"index":@(index), @"kind":kNSMutableArrayKindDidInsertObject}];
    }
}

- (void)zj_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count)
        return;

    id anObject = self[index];
    [self zj_removeObjectAtIndex:index];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didRemoveObject:index:)])
            [observer array:self didRemoveObject:anObject index:index];

        if ([observer respondsToSelector:@selector(array:didChange:)])
            [observer array:self didChange:@{@"oldObj":anObject, @"index":@(index), @"kind":kNSMutableArrayKindDidRemoveObject}];
    }
}

- (void)zj_removeAllObjects {
    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(arrayWillRemoveAllObjects:)])
            [observer arrayWillRemoveAllObjects:self];
    }

    NSArray *oldArray = [self copy];
    [self zj_removeAllObjects];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didChange:)])
            [observer array:self didChange:@{@"oldArray":oldArray, @"newArray":self, @"kind":kNSMutableArrayKindDidRemoveAllObjects}];
    }
}

- (void)zj_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count || !anObject)
        return;

    id oldObject = self[index];
    [self zj_replaceObjectAtIndex:index withObject:anObject];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didReplaceObject:index:newObject:)])
            [observer array:self didReplaceObject:oldObject index:index newObject:anObject];

        if ([observer respondsToSelector:@selector(array:didChange:)])
            [observer array:self didChange:@{@"oldObj":oldObject, @"index":@(index), @"newObj":anObject, @"kind":kNSMutableArrayKindDidReplaceObject}];
    }
}

- (void)zj_setObject:(id)anObject atIndex:(NSUInteger)idx {
    if (idx > self.count || !anObject)
        return;

    if (idx == self.count) {
        [self addObject:anObject];
        return;
    }

    id oldObject = self[idx];
    [self zj_setObject:anObject atIndex:idx];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didReplaceObject:index:newObject:)])
            [observer array:self didReplaceObject:oldObject index:idx newObject:anObject];

        if ([observer respondsToSelector:@selector(array:didChange:)])
            [observer array:self didChange:@{@"oldObj":oldObject, @"index":@(idx), @"newObj":anObject, @"kind":kNSMutableArrayKindDidReplaceObject}];
    }
}


#pragma mark 排序

- (void)zj_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (idx1 >= self.count || idx2 >= self.count)
        return;

    [self zj_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didExchangeObjectAtIndex:withObjectAtIndex:)])
            [observer array:self didExchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];

        if ([observer respondsToSelector:@selector(array:didChange:)])
            [observer array:self didChange:@{@"idx1":@(idx1), @"idx2":@(idx2), @"kind":kNSMutableArrayKindDidExchangeObject}];
    }
}

- (void)zj_sortUsingComparator:(NSComparator)cmptr {
    NSArray *oldArray = [self copy];
    [self zj_sortUsingComparator:cmptr];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didSortWithOldArray:)])
            [observer array:self didSortWithOldArray:oldArray];
    }
}

- (void)zj_sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    NSArray *oldArray = [self copy];
    [self zj_sortWithOptions:opts usingComparator:cmptr];

    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(array:didSortWithOldArray:)])
            [observer array:self didSortWithOldArray:oldArray];
    }
}

@end

