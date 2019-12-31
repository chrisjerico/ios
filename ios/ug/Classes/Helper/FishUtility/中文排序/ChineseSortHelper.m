//
//  ChineseSortHelper.m
//  C
//
//  Created by fish on 2017/12/19.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "ChineseSortHelper.h"

@interface PinYinModel : NSObject
@property (nonatomic) NSString *pinyin;
@property (nonatomic) NSString *string;
@property (nonatomic) NSObject *obj;
@end

@implementation PinYinModel
@end


@implementation ChineseSortGroupModel
@end

@implementation ChineseSortHelper

+ (NSArray<ChineseSortGroupModel *> *)sortedWithStringArray:(NSArray<NSString *> *)array {
    return [ChineseSortHelper sortedWithObjectArray:array keyPath:nil];
}

+ (NSArray<ChineseSortGroupModel *> *)sortedWithObjectArray:(NSArray <NSObject *>*)array keyPath:(NSString *)keyPath {
    if (!keyPath.length && ![array.firstObject isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // 获取PinYinModel 数组
    NSMutableArray <PinYinModel *>*pinyins = ({
        NSMutableArray *temp = [NSMutableArray array];
        for (id obj in array) {
            NSString *string = [obj isKindOfClass:[NSString class]] ? obj : [obj valueForKeyPath:keyPath];
            NSString *pinyin = string.pinyin;
            if ([string hasPrefix:@"长"])    // 多音字 “长” 单独处理
                pinyin = [pinyin stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
            
            PinYinModel *m = [PinYinModel new];
            m.obj = obj;
            m.string = string;
            m.pinyin = pinyin;
            m.pinyin = [m.pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
            m.pinyin = [m.pinyin uppercaseString];
            
            if (pinyin.length)
                [temp addObject:m];
        }
        temp;
    });
    
    // 排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
    [pinyins sortUsingDescriptors:sortDescriptors];
    
    // 按首字母归类 ：A B C D E F G H I J K L M N O P Q R S T U V W X Y Z #
    NSMutableDictionary <NSString *, ChineseSortGroupModel *>*dict = ({
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        ChineseSortGroupModel *(^crecteGroup)(NSString *) = ^ChineseSortGroupModel *(NSString *key) {
            if (!temp[key]) {
                temp[key] = ({
                    ChineseSortGroupModel *m = [ChineseSortGroupModel new];
                    m.key = key;
                    m.array = [NSMutableArray array];
                    m;
                });
            }
            return temp[key];
        };
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[A-Z]*"];
        for (PinYinModel *m in pinyins) {
            NSString *first = [m.pinyin substringToIndex:1];
            if (![predicate evaluateWithObject:first]) {
                [crecteGroup(@"#").array addObject:m.obj];
            } else {
                [crecteGroup(first).array addObject:m.obj];
            }
        }
        temp;
    });
    
    // 对key(首字母)排序
    NSArray <ChineseSortGroupModel *>*ret = ({
        NSMutableArray *temp = [NSMutableArray array];
        NSArray <NSString *>*keys = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 characterAtIndex:0] > [obj2 characterAtIndex:0] ? NSOrderedDescending : NSOrderedAscending;
        }];
        
        if ([keys.firstObject isEqualToString:@"#"]) {
            keys = ({
                NSMutableArray *temp = [keys mutableCopy];
                [temp removeObjectAtIndex:0];
                [temp addObject:@"#"];
                [temp copy];
            });
        }
        
        for (NSString *key in keys) {
            [temp addObject:dict[key]];
        }
        [temp copy];
    });
    return ret;
}

@end
