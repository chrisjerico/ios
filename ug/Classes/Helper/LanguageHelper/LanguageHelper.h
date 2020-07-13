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
@property (nonatomic, copy) NSString *currentLanguageCode;          /**<   当前语言 */
@property (nonatomic, copy) NSString *currentLanguageCodeAppend;    /**<   当前语言 */

@property (nonatomic, copy) NSDictionary <NSString *, id> *config;
@property (nonatomic, copy) NSDictionary <NSString *, NSArray <NSString *>*>*supportLanguageAppends;

- (NSString *)getLanCode;
@end







@interface LanguageHelper : NSObject

@property (nonatomic, copy) NSString *lanCode;
@property (nonatomic, readonly) NSDictionary <NSString *, NSString *>*kvs;

+ (instancetype)shared;
- (NSString *)stringForKey:(NSString *)key;
- (void)save:(NSDictionary *)kvs lanCode:(NSString *)lanCode;

@end

NS_ASSUME_NONNULL_END
