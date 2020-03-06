//
//  NSObject+RnKeyValues.m
//  ug
//
//  Created by fish on 2020/2/12.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NSObject+RnKeyValues.h"
#import "MJFoundation.h"

@interface NSObject ()
+ (void)setMj_error:(NSError *)error;
+ (BOOL)mj_isReferenceReplacedKeyWhenCreatingKeyValues;
@end

@implementation NSObject (RnKeyValues)

- (id)rn_models {
    // 字典转模型
    id (^getModels)(id) = nil;
    id (^__block __sub)(id) = getModels = ^id (id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *temp = @[].mutableCopy;
            for (id ele in (NSArray *)obj) {
                [temp addObject:__sub(ele)];
            }
            return temp;
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *temp = @{}.mutableCopy;
            for (NSString *key in ((NSDictionary *)obj).allKeys) {
                temp[key] = __sub(obj[key]);
            }
            
            Class cls = NSClassFromString(temp[@"clsName"]);
            if (cls) {
                return [cls mj_objectWithKeyValues:temp];
            }
            return temp;
        }
        return obj;
    };
    return getModels(self);
}

#pragma mark -

- (id)rn_keyValues {
    // 是否是数据模型类
    BOOL (^isModelClass)(id) = ^BOOL (id obj) {
        return true;
        Class temp = [obj class];
        while (temp) {
            if (temp == [NSObject class])
                return true;
            if ([NSBundle bundleForClass:temp] != NSBundle.mainBundle)
                return false;
            temp = [temp superclass];
        }
        return true;
    };
    
    // 模型转字典
    id (^getKeyValues)(id) = nil;
    id (^__block __sub)(id) = getKeyValues = ^id (id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *temp = @[].mutableCopy;
            for (id ele in (NSArray *)obj) {
                [temp addObject:__sub(ele)];
            }
            return temp;
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *temp = @{}.mutableCopy;
            for (NSString *key in ((NSDictionary *)obj).allKeys) {
                temp[key] = __sub(obj[key]);
            }
            return temp;
        }
        else if (isModelClass(obj)) {
            return [obj rn_keyValuesWithKeys:nil ignoredKeys:nil];
        }
        return obj;
    };
    return getKeyValues(self);
}

- (NSMutableDictionary *)rn_keyValuesWithKeys:(NSArray *)keys ignoredKeys:(NSArray *)ignoredKeys
{
    // 如果自己不是模型类, 那就返回自己
    // 模型类过滤掉 NSNull
    // 唯一一个不返回自己的
    if ([self isMemberOfClass:NSNull.class]) { return nil; }
    // 这里虽然返回了自己, 但是其实是有报错信息的.
    // TODO: 报错机制不好, 需要重做
    MJExtensionAssertError(![MJFoundation isClassFromFoundation:[self class]], (NSMutableDictionary *)self, [self class], @"不是自定义的模型类")
    
    id keyValues = [NSMutableDictionary dictionary];
    
    Class clazz = [self class];
    NSArray *allowedPropertyNames = [clazz mj_totalAllowedPropertyNames];
    NSArray *ignoredPropertyNames = [clazz mj_totalIgnoredPropertyNames];
    
    [clazz mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        @try {
            // 0.检测是否被忽略
            if (allowedPropertyNames.count && ![allowedPropertyNames containsObject:property.name]) return;
            if ([ignoredPropertyNames containsObject:property.name]) return;
            if (keys.count && ![keys containsObject:property.name]) return;
            if ([ignoredKeys containsObject:property.name]) return;
            
            // 1.取出属性值
            id value = [property valueForObject:self];
            if (!value) return;
            
            // fish:新增过滤规则
            if (![value classIsCustom] && [value isKindOfClass:[UIResponder class]]) return;
            if (![value classIsCustom] && [value isKindOfClass:[UIView class]]) return;
            if (![value classIsCustom] && [value isKindOfClass:[UIViewController class]]) return;
            if (([NSBundle bundleForClass:[property srcClass]] != NSBundle.mainBundle) && [[property srcClass] isSubclassOfClass:[UIResponder class]]) return;
            if (([NSBundle bundleForClass:[property srcClass]] != NSBundle.mainBundle) && [[property srcClass] isSubclassOfClass:[UIView class]]) return;
            if (([NSBundle bundleForClass:[property srcClass]] != NSBundle.mainBundle) && [[property srcClass] isSubclassOfClass:[UIViewController class]]) return;
            
            // 2.如果是模型属性
            MJPropertyType *type = property.type;
            Class propertyClass = type.typeClass;
            if (!type.isFromFoundation && propertyClass) {
                value = [value rn_keyValues];
            } else if ([value isKindOfClass:[NSArray class]]) {
                // 3.处理数组里面有模型的情况
                value = [NSObject rn_keyValuesArrayWithObjectArray:value keys:keys ignoredKeys:ignoredKeys];
            } else if (propertyClass == [NSURL class]) {
                value = [value absoluteString];
            }
            
            // 4.赋值
            if ([clazz mj_isReferenceReplacedKeyWhenCreatingKeyValues]) {
                NSArray *propertyKeys = [[property propertyKeysForClass:clazz] firstObject];
                NSUInteger keyCount = propertyKeys.count;
                // 创建字典
                __block id innerContainer = keyValues;
                [propertyKeys enumerateObjectsUsingBlock:^(MJPropertyKey *propertyKey, NSUInteger idx, BOOL *stop) {
                    // 下一个属性
                    MJPropertyKey *nextPropertyKey = nil;
                    if (idx != keyCount - 1) {
                        nextPropertyKey = propertyKeys[idx + 1];
                    }
                    
                    if (nextPropertyKey) { // 不是最后一个key
                        // 当前propertyKey对应的字典或者数组
                        id tempInnerContainer = [propertyKey valueInObject:innerContainer];
                        if (tempInnerContainer == nil || [tempInnerContainer isKindOfClass:[NSNull class]]) {
                            if (nextPropertyKey.type == MJPropertyKeyTypeDictionary) {
                                tempInnerContainer = [NSMutableDictionary dictionary];
                            } else {
                                tempInnerContainer = [NSMutableArray array];
                            }
                            if (propertyKey.type == MJPropertyKeyTypeDictionary) {
                                innerContainer[propertyKey.name] = tempInnerContainer;
                            } else {
                                innerContainer[propertyKey.name.intValue] = tempInnerContainer;
                            }
                        }
                        
                        if ([tempInnerContainer isKindOfClass:[NSMutableArray class]]) {
                            NSMutableArray *tempInnerContainerArray = tempInnerContainer;
                            int index = nextPropertyKey.name.intValue;
                            while (tempInnerContainerArray.count < index + 1) {
                                [tempInnerContainerArray addObject:[NSNull null]];
                            }
                        }
                        
                        innerContainer = tempInnerContainer;
                    } else { // 最后一个key
                        if (propertyKey.type == MJPropertyKeyTypeDictionary) {
                            innerContainer[propertyKey.name] = value;
                        } else {
                            innerContainer[propertyKey.name.intValue] = value;
                        }
                    }
                }];
            } else {
                keyValues[property.name] = value;
            }
        } @catch (NSException *exception) {
            MJExtensionBuildError([self class], exception.reason);
            MJExtensionLog(@"%@", exception);
        }
    }];
    
    // 转换完毕
    if ([self respondsToSelector:@selector(mj_objectDidConvertToKeyValues:)]) {
        [self mj_objectDidConvertToKeyValues:keyValues];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if ([self respondsToSelector:@selector(mj_objectDidFinishConvertingToKeyValues)]) {
        [self mj_objectDidFinishConvertingToKeyValues];
    }
#pragma clang diagnostic pop
    
    return keyValues;
}

+ (NSMutableArray *)rn_keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys ignoredKeys:(NSArray *)ignoredKeys
{
    // 0.判断真实性
    MJExtensionAssertError([objectArray isKindOfClass:[NSArray class]], nil, [self class], @"objectArray参数不是一个数组");
    
    // 1.创建数组
    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (id object in objectArray) {
        if (keys) {
            id convertedObj = [object rn_keyValuesWithKeys:keys ignoredKeys:nil];
            if (!convertedObj) { continue; }
            [keyValuesArray addObject:convertedObj];
        } else {
            id convertedObj = [object rn_keyValuesWithKeys:nil ignoredKeys:ignoredKeys];
            if (!convertedObj) { continue; }
            [keyValuesArray addObject:convertedObj];
        }
    }
    return keyValuesArray;
}

@end
