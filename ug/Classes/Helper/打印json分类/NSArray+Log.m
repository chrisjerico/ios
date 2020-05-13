//
//  NSArray+Log.m
//  UGBWApp
//
//  Created by ug on 2020/5/13.
//  Copyright © 2020 ug. All rights reserved.
//   https://www.jianshu.com/p/1beb2f6e39e0

#import "NSArray+Log.h"

// 如果需要在底部显示中文字符 （需要时打开，不需要时注释）
#define DDLogObject

@implementation NSArray (Log)

#if defined(DDLogObject) && defined(DEBUG)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableArray *mArr = self.mutableCopy;
    [self enumerateObjectsUsingBlock:^(NSObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class] ||
            [obj isKindOfClass:NSArray.class] ||
            [obj isKindOfClass:NSDictionary.class] ||
            [obj isKindOfClass:NSNull.class] ||
            ([obj isKindOfClass:NSNumber.class] && !isinf([((NSNumber *)obj) floatValue]) && !isnan([((NSNumber *)obj) floatValue]))
            ) {
        }else if(([obj isKindOfClass:NSNumber.class] && (isinf([((NSNumber *)obj) floatValue]) || isnan([((NSNumber *)obj) floatValue])))){
            mArr[idx] = @0;
        }else{
            mArr[idx] = [obj description];
        }
    }];
    if (![mArr checkArrayLegal]) return @"array字符串不合法";
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mArr
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return @"\n";
}

// 检查内容是否合法
- (BOOL)checkArrayLegal{
    __block BOOL legal = YES;
    [self enumerateObjectsUsingBlock:^(NSObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class] ||
            [obj isKindOfClass:NSNull.class] ||
            ([obj isKindOfClass:NSNumber.class] && !isinf([((NSNumber *)obj) floatValue]) && !isnan([((NSNumber *)obj) floatValue]))
            ) {
        }else if([obj isKindOfClass:NSArray.class]){
            legal = [(NSArray *)obj checkArrayLegal];
        }else if([obj isKindOfClass:NSDictionary.class]){
            legal = [(NSDictionary *)obj checkDictionaryLegal];
        }else if([obj isKindOfClass:NSNumber.class]){
            if (isinf([(NSNumber *)obj floatValue]) ||
                isnan([((NSNumber *)obj) floatValue])) {
                legal = NO;
                *stop = YES;
            }
        }else{
            legal = NO;
            *stop = YES;
        }
    }];
    return legal;
}

#endif




@end

@implementation NSDictionary (Log)

#if defined(DDLogObject) && defined(DEBUG)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableDictionary *mDic = self.mutableCopy;
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSObject*  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class] ||
            [obj isKindOfClass:NSArray.class] ||
            [obj isKindOfClass:NSDictionary.class] ||
            [obj isKindOfClass:NSNull.class] ||
            ([obj isKindOfClass:NSNumber.class] && !isinf([((NSNumber *)obj) floatValue]) && !isnan([((NSNumber *)obj) floatValue]))
            ) {
        }else if(([obj isKindOfClass:NSNumber.class] && (isinf([((NSNumber *)obj) floatValue]) || isnan([((NSNumber *)obj) floatValue])))){
            mDic[key] = @0;
        }else{
            mDic[key] = [obj description];
        }
    }];
    if (![mDic checkDictionaryLegal]) return @"dictionary字符串不合法";
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        NSString * tJsonString = [jsonString stringByRemovingPercentEncoding];
        if (tJsonString) return tJsonString;
        return jsonString;
    }else{
        return @"\n";
    }
}

- (BOOL)checkDictionaryLegal{
    __block BOOL legal = YES;
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSObject*  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class] ||
            [obj isKindOfClass:NSNull.class] ||
            ([obj isKindOfClass:NSNumber.class] && !isinf([((NSNumber *)obj) floatValue]) && !isnan([((NSNumber *)obj) floatValue]))
            ) {
        }else if([obj isKindOfClass:NSArray.class]){
            legal = [(NSArray *)obj checkArrayLegal];
        }else if([obj isKindOfClass:NSDictionary.class]){
            legal = [(NSDictionary *)obj checkDictionaryLegal];
        }else if([obj isKindOfClass:NSNumber.class]){
            if (isinf([(NSNumber *)obj floatValue]) ||
                isnan([((NSNumber *)obj) floatValue])) {
                legal = NO;
                *stop = YES;
            }
         }else{
             legal = NO;
             *stop = YES;
         }
    }];
    return legal;
}

#endif



@end
