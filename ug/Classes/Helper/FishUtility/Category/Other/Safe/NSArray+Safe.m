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
        [NSArray jr_swizzleClassMethod:@selector(arrayWithObjects:count:) withClassMethod:@selector(zjSafe_arrayWithObjects:count:) error:nil];
        [NSClassFromString(@"__NSPlaceholderArray") jr_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(zjSafe_initWithObjects:count:) error:nil];
        [NSClassFromString(@"__NSArray0") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(zjSafe_objectAtIndex:) error:nil];
    });
}

+ (instancetype)zjSafe_arrayWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id temp[cnt];
    NSUInteger idx = cnt;
    while (idx--) {
        temp[idx] = objects[idx] ? : [NSNull null];
    }
    return [self zjSafe_arrayWithObjects:temp count:cnt];
}

- (instancetype)zjSafe_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id temp[cnt];
    NSUInteger idx = cnt;
    while (idx--) {
        temp[idx] = objects[idx] ? : [NSNull null];
    }
    return [self zjSafe_initWithObjects:temp count:cnt];
}

- (id)zjSafe_objectAtIndex:(NSUInteger)index {
    if (index < self.count)
        return [self zjSafe_objectAtIndex:index];
    return nil;
}

@end


@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(zjSafe_insertObject:atIndex:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(zjSafe_removeObjectAtIndex:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(zjSafe_replaceObjectAtIndex:withObject:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(setObject:atIndex:) withMethod:@selector(zjSafe_setObject:atIndex:) error:nil];
        [NSClassFromString(@"__NSArrayM") jr_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(zjSafe_objectAtIndexedSubscript:) error:nil];
    });
}

- (void)zjSafe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index <= self.count)
        [self zjSafe_insertObject:anObject atIndex:index];
}

- (void)zjSafe_removeObjectAtIndex:(NSUInteger)index {
    if (index <= self.count)
        [self zjSafe_removeObjectAtIndex:index];
}

- (void)zjSafe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index <= self.count)
        [self zjSafe_replaceObjectAtIndex:index withObject:anObject];
}

- (void)zjSafe_setObject:(id)anObject atIndex:(NSUInteger)index {
    if (index <= self.count)
        [self zjSafe_setObject:anObject atIndex:index];
}

- (id)zjSafe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count)
        return [self zjSafe_objectAtIndexedSubscript:idx];
    return nil;
}

@end
