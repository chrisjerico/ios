//
//  NSArray+Utils.m
//  C
//
//  Created by fish on 2018/1/24.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "NSArray+Utils.h"


BOOL IsEqualValue(id obj, id value) {
    if (obj == value ||
        ([obj isKindOfClass:[NSNumber class]] && [[value numberValue] isEqualToNumber:(NSNumber *)obj]) ||
        ([obj isKindOfClass:[NSString class]] && [[value stringValue] isEqualToString:(NSString *)obj]) ||
        ([obj isKindOfClass:[NSValue class]] && [value isKindOfClass:[NSValue class]] && [obj isEqualToValue:value])) {
        return true;
    }
    return false;
}



@implementation NSArray (Utils)


#pragma mark - tagString

- (id)objectWithTagString:(NSString *)tagString {
    for (id obj in self) {
        if ([[obj tagString] isEqualToString:tagString])
            return obj;
    }
    return nil;
}


#pragma mark - IsEqualValue

- (BOOL)containsValue:(id)value {
    for (id obj in self) {
        if (IsEqualValue(obj, value))
            return true;
    }
    return false;
}

- (NSUInteger)indexOfValue:(id)value {
    NSUInteger i = 0;
    for (id obj in self) {
        if (IsEqualValue(obj, value))
            return i;
        i++;
    }
    return false;
}

#pragma mark - IsEqualValue + KeyPath

- (BOOL)containsValue:(id)value keyPath:(NSString *)keyPath {
    return !![self objectWithValue:value keyPath:keyPath];
}

- (NSUInteger)indexOfValue:(id)value keyPath:(NSString *)keyPath {
    NSUInteger i = 0;
    for (id obj in self) {
        id v2 = keyPath.length ? [obj valueForKeyPath:keyPath] : obj;
        if (IsEqualValue(v2, value))
            return i;
        i++;
    }
    return false;
}

- (id)objectWithValue:(id)value keyPath:(NSString *)keyPath {
    if (value) {
        for (id obj in self) {
            id v2 = keyPath.length ? [obj valueForKeyPath:keyPath] : obj;
            if (IsEqualValue(v2, value))
                return obj;
        }
    }
    return nil;
}

- (NSArray *)objectsWithValue:(id)value keyPath:(NSString *)keyPath {
    NSMutableArray *values = [NSMutableArray array];
    for (id obj in self) {
        id v2 = keyPath.length ? [obj valueForKeyPath:keyPath] : obj;
        if (IsEqualValue(v2, value))
            [values addObject:obj];
    }
    return [values copy];
}

- (NSArray *)valuesWithKeyPath:(NSString *)keyPath {
    NSMutableArray *values = [NSMutableArray array];
    for (id obj in self) {
        [values addObject:[obj valueForKeyPath:keyPath] ? : [NSNull null]];
    }
    return [values copy];
}

@end




@implementation NSMutableArray (Utils)

- (void)removeValue:(id)value {
    for (id obj in self) {
        if (IsEqualValue(obj, value)) {
            [self removeObject:obj];
            return;
        }
    }
}
@end
