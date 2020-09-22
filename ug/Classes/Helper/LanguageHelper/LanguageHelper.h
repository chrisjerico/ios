//
//  LanguageHelper.h
//  UGBWApp
//
//  Created by fish on 2020/7/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIStackView (UGLanguage)
@property (nonatomic) IBInspectable BOOL 国际版竖或横轴;
@end



@interface NSString (UGLanguage)
@property (nonatomic, assign) BOOL fromNetwork; /**<   从接口获取的文本显示原文，不进行翻译 */
@end

@interface LanguageMap : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@end

@interface LanguageModel : NSObject
@property (nonatomic, copy) NSString *packageLastVersion;           /**<   语言包版本号 */
@property (nonatomic, copy) NSString *currentLanguageCode;          /**<   当前语言 */
@property (nonatomic, copy) NSString *currentLanguageCodeAppend;    /**<   当前语言 */
@property (nonatomic, strong) NSArray <LanguageMap *>*supportLanguagesMap;

@property (nonatomic, copy) NSDictionary <NSString *, id> *config;
@property (nonatomic, copy) NSDictionary <NSString *, NSArray <NSString *>*>*supportLanguageAppends;

- (NSString *)getLanCode;
@end







@interface LanguageHelper : NSObject

@property (nonatomic, strong) NSArray <LanguageMap *>*supportLanguagesMap;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *lanCode;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) BOOL hasKeys;
@property (nonatomic, readonly) BOOL isCN;
@property (nonatomic, readonly) BOOL isYN;

+ (instancetype)shared;
+ (void)save:(NSDictionary *)kvs lanCode:(NSString *)lanCode ver:(NSString *)ver;
+ (void)setNoTranslate:(id)obj; /**<   传入数据模型、字符串、数组、字典 */
+ (void)changeLanguageAndRestartApp:(NSString *)lanCode;

- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForCnString:(NSString *)cnString; /**<   通过中文找key，再返回key对应的翻译文本 */
@end

NS_ASSUME_NONNULL_END
