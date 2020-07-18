//
//  LanguageHelper.m
//  UGBWApp
//
//  Created by fish on 2020/7/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LanguageHelper.h"
#import "RegExCategories.h"

@implementation LanguageModel
- (NSString *)getLanCode {
    return _currentLanguageCode;
    return [NSString stringWithFormat:@"%@-%@", _currentLanguageCode, _currentLanguageCodeAppend];
}
@end



@implementation LanguageHelper {
    BOOL _isCN;
}

static NSDictionary <NSString *, NSString *>*_cnKvs = nil;

+ (instancetype)shared {
    static LanguageHelper *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self class] new];
        obj.lanCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"lanCode"] ? : @"zh";
        obj.version = [[NSUserDefaults standardUserDefaults] stringForKey:@"lan_version"];
        obj.notFoundStrings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"LanguageNotFoundStrings"]];
//        obj.notFoundStrings = @{}.mutableCopy;
//        [[obj.notFoundStrings.allKeys componentsJoinedByString:@"\n"] writeToFile:@"/Users/fish/Desktop/336.txt" atomically:true encoding:NSUTF8StringEncoding error:nil];
        // 上传未翻译字段
        if (obj.kvs.count) {
            NSMutableDictionary *keys = @{}.mutableCopy;
            for (NSString *key in obj.notFoundStrings.allKeys) {
                if ([obj.notFoundStrings[key] boolValue])
                    keys[key] = @0;
            }
            if (keys.count) {
//                [NetworkManager1 uploadLog:[keys.allKeys componentsJoinedByString:@"\n"] title:_NSString(@"%@未翻译字段", obj.lanCode) tag:@"未翻译字段"];
                [obj.notFoundStrings addEntriesFromDictionary:keys];
            }
        }
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            // 存本地
            [[NSUserDefaults standardUserDefaults] setObject:obj.notFoundStrings forKey:@"LanguageNotFoundStrings"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    });
    return obj;
}

- (NSString *)stringForKey:(NSString *)key {
    return _kvs[key];
}

- (void)setLanCode:(NSString *)lanCode {
    _lanCode = lanCode;
    _kvs = [[NSUserDefaults standardUserDefaults] dictionaryForKey:_NSString(@"lan_%@", lanCode)];
    _cnKvs = [[NSUserDefaults standardUserDefaults] dictionaryForKey:_NSString(@"lan_%@", @"zh")];
    _isCN = [lanCode isEqualToString:@"zh"];
    [[NSUserDefaults standardUserDefaults] setObject:lanCode forKey:@"lanCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)save:(NSDictionary *)kvs lanCode:(NSString *)lanCode ver:(NSString *)ver {
    NSMutableDictionary *temp = @{}.mutableCopy;
    for (NSString *key in kvs.allKeys) {
        NSString *value = kvs[key];
        value = [value stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        temp[key] = value;
    }
    kvs = [temp copy];
    [[NSUserDefaults standardUserDefaults] setObject:kvs forKey:_NSString(@"lan_%@", lanCode)];
    [[NSUserDefaults standardUserDefaults] setObject:ver forKey:@"lan_version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([@"zh" isEqualToString:lanCode]) _cnKvs = kvs;
    if ([_lanCode isEqualToString:lanCode]) _kvs = kvs;
}

- (NSString *)stringForCnString:(NSString *)cnString; {
    if (_isCN) return cnString;
    if (!cnString.hasChinese) return cnString;
    
    static NSDictionary *__lastCnKvs = nil;
    static NSMutableDictionary *__vks = nil;
    static NSMutableArray *__dynamicVs = nil;
    if (__lastCnKvs != _cnKvs) {
        __lastCnKvs = _cnKvs;
        __vks = @{}.mutableCopy;
        __dynamicVs = @[].mutableCopy;
        
        for (NSString *k in _cnKvs.allKeys) {
            NSString *v = _cnKvs[k];
            __vks[v] = k;
            if ([v containsString:@"%s"]) {
                [__dynamicVs addObject:v];
            }
        }
        [__dynamicVs removeObject:@"%s"];
    }
    
    NSString *key = __vks[cnString];
    if (!key.length) {
        // %s 子串取出来递归匹配，匹配成功则组合后返回。
        // ** 符合多个key挑哪个？都试一次，挑能完整翻译成功的 ** //
        for (NSString *dv in __dynamicVs) {
            NSString *reg = dv;
            for (NSString *s in @"\\$()*+.[]{}?^|") {
                reg = [reg stringByReplacingOccurrencesOfString:s withString:_NSString(@"\\%@", s)];
            }
            reg = _NSString(@"^%@$", [reg stringByReplacingOccurrencesOfString:@"%s" withString:@"([\\s\\S]*)"]);
            if ([cnString isMatch:RX(reg)]) {
                NSMutableArray *subCnArray = [[[cnString firstMatchWithDetails:RX(reg)].groups valueForKey:@"value"] mutableCopy];// 把%s全部取出来再匹配
                [subCnArray removeFirstObject];
                
                NSMutableArray *subRetArray = @[].mutableCopy;
                for (NSString *s in subCnArray) {
                    NSString *retString = nil;
                    if (!s.hasChinese) {
                        retString = s;
                    } else if ((retString = [self stringForCnString:s]).hasChinese) {
                        break;
                    }
                    [subRetArray addObject:retString];
                }
                if (subCnArray.count != subRetArray.count)
                    continue;
                
                int i = 0;
                NSMutableString *fullString = @"".mutableCopy;
                for (NSString *s in [[self stringForKey:__vks[dv]] componentsSeparatedByString:@"%s"]) {
                    if (s) [fullString appendString:s];
                    if (subRetArray[i]) [fullString appendString:subRetArray[i]];
                    i++;
                }
                return fullString;
            }
        }
        // 记录未匹配的文本，找机会上传
        if (!_notFoundStrings[cnString])
            _notFoundStrings[cnString] = @1;
        return cnString;
    } else {
        NSString *v = [self stringForKey:key];
        if (!v && !_notFoundStrings[cnString]) {
            _notFoundStrings[cnString] = @1;
        }
        return v ? : cnString;
    }
}

@end
