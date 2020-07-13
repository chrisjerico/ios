//
//  LanguageHelper.m
//  UGBWApp
//
//  Created by fish on 2020/7/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LanguageHelper.h"


@implementation LanguageModel
- (NSString *)getLanCode {
    return [NSString stringWithFormat:@"%@-%@", _currentLanguageCode, _currentLanguageCodeAppend];
}
@end



@implementation LanguageHelper

+ (instancetype)shared {
    static LanguageHelper *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self class] new];
        obj.lanCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"lanCode"] ? : @"";
    });
    return obj;
}

- (NSString *)stringForKey:(NSString *)key {
    return _kvs[key] ? : key;
}

- (void)setLanCode:(NSString *)lanCode {
    _lanCode = lanCode;
    _kvs = [[NSUserDefaults standardUserDefaults] dictionaryForKey:_NSString(@"lan_%@", lanCode)];
    [[NSUserDefaults standardUserDefaults] setObject:lanCode forKey:@"lanCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)save:(NSDictionary *)kvs lanCode:(NSString *)lanCode {
    [[NSUserDefaults standardUserDefaults] setObject:kvs forKey:_NSString(@"lan_%@", lanCode)];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([_lanCode isEqualToString:lanCode]) {
        _kvs = kvs;
    }
}

@end
