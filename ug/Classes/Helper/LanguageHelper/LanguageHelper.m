//
//  LanguageHelper.m
//  UGBWApp
//
//  Created by fish on 2020/7/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LanguageHelper.h"
#import "RegExCategories.h"
#import "cc_runtime_property.h"



@implementation UIStackView (UGLanguage)
- (BOOL)国际版竖或横轴 { return false; }
- (void)set国际版竖或横轴:(BOOL)国际版竖或横轴 {
    if (![LanguageHelper shared].isCN) {
        self.axis = 国际版竖或横轴 ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
    }
}
@end


@implementation NSString (UGLanguage)
_CCRuntimeProperty_Assign(BOOL, fromNetwork, setFromNetwork)
@end




@implementation LanguageModel
- (NSString *)getLanCode {
    return _currentLanguageCode;
    return [NSString stringWithFormat:@"%@-%@", _currentLanguageCode, _currentLanguageCodeAppend];
}
@end



@implementation LanguageHelper 

static NSDictionary <NSString *, NSString *>*_cnKvs = nil;
static NSMutableDictionary <NSString *, NSNumber *>*_temp = nil;

+ (instancetype)shared {
    static LanguageHelper *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self class] new];
        obj.lanCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"lanCode"] ? : @"zh";
        obj.version = [[NSUserDefaults standardUserDefaults] stringForKey:@"lan_version"];
        obj.notFoundStrings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"LanguageNotFoundStrings"]];
        _temp = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"LanguageNotFoundStringsTemp"]];
        
        // 存本地
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [[NSUserDefaults standardUserDefaults] setObject:obj.notFoundStrings forKey:@"LanguageNotFoundStrings"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        [obj addNotFoundString:nil];// 上传
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
    _isYN = [lanCode isEqualToString:@"vi"];
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

+ (void)setNoTranslate:(id)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        ((NSString *)obj).fromNetwork = true;
    } else if ([obj isKindOfClass:[NSArray class]]) {
        for (id sub in obj) {
            [LanguageHelper setNoTranslate:sub];
        }
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        for (id sub in [obj allValues]) {
            [LanguageHelper setNoTranslate:sub];
        }
    } else if ([obj classIsCustom]) {
        for (NSString *k in [[obj class] ivarList]) {
            [LanguageHelper setNoTranslate:[obj valueForKey:k]];
        }
    }
}

- (NSString *)stringForCnString:(NSString *)cnString; {
    if (cnString.fromNetwork) return cnString;
    if ([cnString containsString:@"龘"]) return [cnString stringByReplacingOccurrencesOfString:@"龘" withString:@""];
    if (_isCN) return cnString;
    if (!cnString.hasChinese) return cnString;
    
    static NSDictionary *__lastCnKvs = nil;
    static NSMutableDictionary *__vks = nil;// 非动态文本
    static NSMutableArray *__dynamicVs = nil;// 动态文本
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
        return [self addNotFoundString:cnString];
    } else {
        return [self stringForKey:key] ? : [self addNotFoundString:cnString];
    }
}

- (NSString *)addNotFoundString:(NSString *)s {
    // 记录未匹配的文本
    if (s.length && !_temp[s]) {
        self.notFoundStrings[s] = @1;
    }
    
    BOOL upload = self.notFoundStrings.count >= 2000;
    if (OBJOnceToken(self)) {
        if ([[NSUserDefaults standardUserDefaults] containsKey:@"LanguageUpdateTime"]) {
            NSDate *date = [[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageUpdateTime"] dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            if (fabs([date timeIntervalSinceDate:[NSDate date]]) > 24 * 60 * 60) {
                upload = true;
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"LanguageUpdateTime"];
        }
    }
    
    // 上传
    if (upload) {
        NSDictionary *dict = self.notFoundStrings.copy;
        [NetworkManager1 uploadLog:[dict.allKeys componentsJoinedByString:@"\n"] title:@"未翻译字段" tag:@"未翻译字段"].completionBlock = ^(CCSessionModel *sm) {
            if (!sm.error) {
                [self.notFoundStrings removeObjectsForKeys:dict.allKeys];
                [_temp addEntriesFromDictionary:dict];
                [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"LanguageUpdateTime"];
                [[NSUserDefaults standardUserDefaults] setObject:self.notFoundStrings forKey:@"LanguageNotFoundStrings"];
                [[NSUserDefaults standardUserDefaults] setObject:_temp forKey:@"LanguageNotFoundStringsTemp"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        };
    }
    return s;
}

@end
