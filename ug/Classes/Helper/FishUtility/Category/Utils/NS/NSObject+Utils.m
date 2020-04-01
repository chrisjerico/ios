//
//  NSObject+Utils.m
//  FishUtility
//
//  Created by fish on 16/8/15.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "NSObject+Utils.h"
#import "cc_objc_msgSend.h"
#import "cc_runtime_property.h"

@implementation NSObject (Utils)

_CCRuntimeProperty_Copy(NSString *, tagString, setTagString)
_CCRuntimeProperty_Readonly(NSMutableDictionary *, cc_userInfo, [@{} mutableCopy])

+ (NSArray<NSString *> *)methodList {
    NSMutableArray *list = [@[] mutableCopy];
    
    unsigned int outCount = 0;
    Method *m = class_copyMethodList(self, &outCount);
    for (int j=0; j<outCount; j++)
        [list addObject:NSStringFromSelector(method_getName(m[j]))];
    
    return [list copy];
}

+ (NSArray<NSString *> *)propertyList {
    NSMutableArray *list = [@[] mutableCopy];
    
    unsigned int outCount = 0;
    objc_property_t *p = class_copyPropertyList(self, &outCount);
    for (int j=0; j<outCount; j++)
        [list addObject:@(property_getName(*(p+j)))];
    
    return [list copy];
}

+ (NSArray<NSString *> *)ivarList {
    NSMutableArray *list = [@[] mutableCopy];
    
    unsigned int outCount = 0;
    Ivar *v = class_copyIvarList(self, &outCount);
    for (int j=0; j<outCount; j++)
        [list addObject:@(ivar_getName(v[j]))];
    
    return [list copy];
}

- (BOOL)isClass {
    return [self respondsToSelector:@selector(new)];
}

- (BOOL)classIsCustom {
    return [NSBundle bundleForClass:self.class] == NSBundle.mainBundle;
}

- (void *)performSelector:(SEL)aSelector arguments:(va_list)argList {
    return cc_objc_msgSendv1(self, NSStringFromSelector(aSelector).UTF8String, argList);
}

- (id)performSelector:(SEL)aSelector argArray:(NSArray *)argArray {
    return cc_objc_msgSendv2(self, NSStringFromSelector(aSelector).UTF8String, argArray);
}

- (void *)performSelector:(const char *)methodName, ... {
    va_list list;
    va_start(list, methodName);
    return cc_objc_msgSendv1(self, methodName, list);
}

+ (void *)performSelector:(const char *)methodName, ... {
    va_list list;
    va_start(list, methodName);
    return cc_objc_msgSendv1(self, methodName, list);
}

- (void)setValuesWithObject:(NSObject *)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        [self setValuesWithDictionary:(id)obj];
        return;
    }
    Class cls = [obj class];
    while (cls != [NSObject class]) {
        for (NSString *key in [cls ivarList])
            [self setValue:[obj valueForKey:key] forKey:key];
        cls = [cls superclass];
    }
}

- (void)setValuesWithDictionary:(NSDictionary<NSString *,id> *)dict {
    id obj = [[self class] mj_objectWithKeyValues:dict context:nil];
    for (NSString *key in dict.allKeys) {
        NSString *ivar = [@"_" stringByAppendingString:key];
        [self setValue:[obj valueForKey:ivar] forKey:ivar];
    }
}

- (id)valueForUndefinedKey:(NSString *)key {return nil;}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (void)setNilValueForKey:(NSString *)key {}

@end
