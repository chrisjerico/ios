//
//  NSArray+Safe.m
//  C
//
//  Created by fish on 2018/3/19.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "NSArray+Safe.h"
#import "JRSwizzle.h"

@implementation NSArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSArray jr_swizzleClassMethod:@selector(arrayWithObjects:count:) withClassMethod:@selector(ccSafe_arrayWithObjects:count:) error:nil];
        [NSClassFromString(@"__NSPlaceholderArray") jr_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(ccSafe_initWithObjects:count:) error:nil];
        [NSClassFromString(@"__NSArray0") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(ccSafe_objectAtIndex:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(ccSafe_objectAtIndex:) error:nil];
        [NSClassFromString(@"__NSSingleObjectArrayI") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(ccSafe_objectAtIndex:) error:nil];
    });
}

+ (instancetype)ccSafe_arrayWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id temp[cnt];
    NSUInteger idx = cnt;
    while (idx--) {
        temp[idx] = objects[idx] ? : [NSNull null];
    }
    return [self ccSafe_arrayWithObjects:temp count:cnt];
}

- (instancetype)ccSafe_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id temp[cnt];
    NSUInteger idx = cnt;
    while (idx--) {
        temp[idx] = objects[idx] ? : [NSNull null];
    }
    return [self ccSafe_initWithObjects:temp count:cnt];
}

- (id)ccSafe_objectAtIndex:(NSUInteger)index {
    if (index < self.count)
        return [self ccSafe_objectAtIndex:index];
    return nil;
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return nil;
}

@end


@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(ccSafe_insertObject:atIndex:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(ccSafe_removeObjectAtIndex:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(ccSafe_replaceObjectAtIndex:withObject:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(setObject:atIndex:) withMethod:@selector(ccSafe_setObject:atIndex:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(ccSafe_objectAtIndexedSubscript:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(ccSafe_setObject:atIndexedSubscript:) error:nil];
    });
}

- (void)ccSafe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index <= self.count)
        [self ccSafe_insertObject:anObject atIndex:index];
}

- (void)ccSafe_removeObjectAtIndex:(NSUInteger)index {
    if (index <= self.count)
        [self ccSafe_removeObjectAtIndex:index];
}

- (void)ccSafe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index <= self.count)
        [self ccSafe_replaceObjectAtIndex:index withObject:anObject];
}

- (void)ccSafe_setObject:(id)anObject atIndex:(NSUInteger)index {
    if (index <= self.count)
        [self ccSafe_setObject:anObject atIndex:index];
}

- (id)ccSafe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count)
        return [self ccSafe_objectAtIndexedSubscript:idx];
    return nil;
}

- (void)ccSafe_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (!obj) {
        obj = [NSNull null];
    }
    if (idx <= self.count) 
        [self ccSafe_setObject:obj atIndexedSubscript:idx];
}

@end
