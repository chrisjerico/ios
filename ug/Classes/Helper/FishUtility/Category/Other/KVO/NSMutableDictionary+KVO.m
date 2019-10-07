//
//  NSMutableDictionary+KVO.m
//  AAA
//
//  Created by fish on 16/6/28.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "NSMutableDictionary+KVO.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"

NSString *const kNSMutableDictionaryKindDidSetObject        = @"kNSMutableDictionaryKindDidSetObject";
NSString *const kNSMutableDictionaryKindDidRemoveObject     = @"kNSMutableDictionaryKindDidRemoveObject";
NSString *const kNSMutableDictionaryKindDidRemoveAllObjects = @"kNSMutableDictionaryKindDidRemoveAllObjects";

@interface NSObject ()

- (void)dictionary:(NSMutableDictionary *)dict didChange:(NSDictionary<NSString *,id> *)change;     /**<   数组元素发生变化时调用 */

- (void)dictionary:(NSMutableDictionary *)dict didSetObject:(id)object key:(id)key;                 /**<   添加 */
- (void)dictionary:(NSMutableDictionary *)dict didRemoveObject:(id)object key:(id)key;              /**<   移除 */
- (void)dictionaryWillRemoveAllObjects:(NSMutableDictionary *)dict;                                 /**<   清空 */
@end


@implementation NSMutableDictionary (KVO)

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

- (void)addObserver:(id<NSMutableDictionaryDidChangeDelegate>)observer {
    if (![self.observers containsObject:observer])
        [self.observerPointers addPointer:(__bridge void * _Nullable)(observer)];
}

- (void)removeObserver:(id<NSMutableDictionaryDidChangeDelegate>)observer {
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
        [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(zj_removeObjectForKey:) withMethod:@selector(removeObjectForKey:) error:nil];
        [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(zj_setObject:forKey:) withMethod:@selector(setObject:forKey:) error:nil];
        [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(zj_setObject:forKeyedSubscript:) withMethod:@selector(setObject:forKeyedSubscript:) error:nil];
        [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(zj_removeAllObjects) withMethod:@selector(removeAllObjects) error:nil];
    });
}

- (void)zj_removeObjectForKey:(id)aKey {
    if (!aKey)
        return;
    
    id obj = self[aKey];
    [self zj_removeObjectForKey:aKey];
    
    if (obj) {
        for (NSObject *observer in self.observers) {
            if ([observer respondsToSelector:@selector(dictionary:didRemoveObject:key:)])
                [observer dictionary:self didRemoveObject:obj key:aKey];
            
            if ([observer respondsToSelector:@selector(dictionary:didChange:)])
                [observer dictionary:self didChange:@{@"oldObj":obj, @"key":aKey, @"kind":kNSMutableDictionaryKindDidRemoveObject}];
        }
    }
}
//
- (void)zj_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject || !aKey)
        return;
    
    id oldObj = self[aKey];
    [self zj_setObject:anObject forKey:aKey];
    
    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(dictionary:didSetObject:key:)])
            [observer dictionary:self didSetObject:anObject key:aKey];
        
        if ([observer respondsToSelector:@selector(dictionary:didChange:)]) {
            [observer dictionary:self didChange:({
                NSDictionary *dict = [@{@"newObj":anObject, @"key":aKey, @"kind":kNSMutableDictionaryKindDidSetObject} mutableCopy];
                [dict setValue:oldObj forKey:@"oldObj"];
                dict = [dict copy];
            })];
        }
    }
}

- (void)zj_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    if (!anObject || !aKey)
        return;
    
    id oldObj = self[aKey];
    [self zj_setObject:anObject forKeyedSubscript:aKey];
    
    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(dictionary:didSetObject:key:)])
            [observer dictionary:self didSetObject:anObject key:aKey];
        
        if ([observer respondsToSelector:@selector(dictionary:didChange:)]) {
            [observer dictionary:self didChange:({
                NSDictionary *dict = [@{@"newObj":anObject, @"key":aKey, @"kind":kNSMutableDictionaryKindDidSetObject} mutableCopy];
                [dict setValue:oldObj forKey:@"oldObj"];
                dict = [dict copy];
            })];
        }
    }
}

- (void)zj_removeAllObjects {
    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(dictionaryWillRemoveAllObjects:)])
            [observer dictionaryWillRemoveAllObjects:self];
    }
    
    NSDictionary *dict = [self copy];
    [self zj_removeAllObjects];
    
    for (NSObject *observer in self.observers) {
        if ([observer respondsToSelector:@selector(dictionary:didChange:)])
            [observer dictionary:self didChange:@{@"oldDict":dict, @"newDict":self, @"kind":kNSMutableDictionaryKindDidRemoveAllObjects}];
    }
}

@end

