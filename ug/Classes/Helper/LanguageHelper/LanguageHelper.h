//
//  LanguageHelper.h
//  UGBWApp
//
//  Created by fish on 2020/7/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN




@interface LanguageModel : NSObject
@property (nonatomic, copy) NSString *packageLastVersion;           /**<   语言包版本号 */
@property (nonatomic, copy) NSString *currentLanguageCode;          /**<   当前语言 */
@property (nonatomic, copy) NSString *currentLanguageCodeAppend;    /**<   当前语言 */

@property (nonatomic, copy) NSDictionary <NSString *, id> *config;
@property (nonatomic, copy) NSDictionary <NSString *, NSArray <NSString *>*>*supportLanguageAppends;

- (NSString *)getLanCode;
@end







@interface LanguageHelper : NSObject

@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *lanCode;
@property (nonatomic, readonly) NSDictionary <NSString *, NSString *>*kvs;
@property (nonatomic, strong) NSMutableDictionary *notFoundStrings;

+ (instancetype)shared;
- (NSString *)stringForKey:(NSString *)key;
- (void)save:(NSDictionary *)kvs lanCode:(NSString *)lanCode ver:(NSString *)ver;


- (NSString *)stringForCnString:(NSString *)cnString; /**<   通过中文找key，再返回key对应的翻译文本 */
@end

NS_ASSUME_NONNULL_END
