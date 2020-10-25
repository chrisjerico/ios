//
//  NSString+Utils.h
//  dooboo
//
//  Created by fish on 16/4/28.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIColor;

#define _NSString(fmt, ...)  [NSString stringWithFormat:(fmt), ##__VA_ARGS__]

@interface NSString (Utils)

@property (readonly, nonatomic) BOOL hasNumber;                     /**<   包含数字 */
@property (readonly, nonatomic) BOOL hasFloat;                      /**<   包含浮点数 */
@property (readonly, nonatomic) BOOL hasASCII;                      /**<   包含ASCII码 */
@property (readonly, nonatomic) BOOL hasChinese;                    /**<   包含中文 */
@property (readonly, nonatomic) BOOL hasLetter;                     /**<   包含字母 */
@property (readonly, nonatomic) BOOL hasLowercaseLetter;            /**<   包含小写字母 */
@property (readonly, nonatomic) BOOL hasUppercaseLetter;            /**<   包含大写字母 */
@property (readonly, nonatomic) BOOL hasSpecialCharacter;           /**<   包含特殊字符 */


@property (readonly, nonatomic) BOOL isNumber;                      /**<   数字 */
@property (readonly, nonatomic) BOOL isFloat;                       /**<   浮点数 */
@property (readonly, nonatomic) BOOL isInteger;                     /**<   整数 */
@property (readonly, nonatomic) BOOL isASCII;                       /**<   纯ASCII码 */
@property (readonly, nonatomic) BOOL isChinese;                     /**<   纯中文 */
@property (readonly, nonatomic) BOOL isLetter;                      /**<   纯字母 */
@property (readonly, nonatomic) BOOL isLowercaseLetter;             /**<   纯小写字母 */
@property (readonly, nonatomic) BOOL isUppercaseLetter;             /**<   纯大写字母 */
@property (readonly, nonatomic) BOOL isSpecialCharacter;            /**<   纯特殊字符 */
@property (readonly, nonatomic) BOOL isHtmlStr;                     /**<   含有html标签的检测 */

//@property (readonly, nonatomic) BOOL (^isDate)(NSString *format);   /**<   日期 */
@property (readonly, nonatomic) BOOL isEmail;                       /**<   Email */
@property (readonly, nonatomic) BOOL isQQ;                          /**<   QQ */
@property (readonly, nonatomic) BOOL isTel;                         /**<   座机电话号码 */
@property (readonly, nonatomic) BOOL isMobile;                      /**<   手机号码 */
@property (readonly, nonatomic) BOOL isIDCardNumber;                /**<   身份证号码 */
//@property (readonly, nonatomic) BOOL isZipcode;                   /**<   邮政编码 */
@property (readonly, nonatomic) BOOL isBankCardNumber;              /**<   银行卡号码 */
@property (readonly, nonatomic) NSDictionary *bankCardInfo;         /**<   银行卡信息 */


@property (readonly, nonatomic) BOOL isNull;                        /**<   null */
@property (readonly, nonatomic) BOOL isURL;                         /**<   URL */
@property (readonly, nonatomic) BOOL isHexColor;                    /**<   16进制颜色 */
@property (readonly, nonatomic) BOOL isIP;                          /**<   IP地址 */
@property (readonly, nonatomic) BOOL isIPv4;                        /**<   IPv4地址 */
@property (readonly, nonatomic) BOOL isIPv6;                        /**<   IPv6地址 */


@property (readonly, nonatomic) BOOL isPhoto;                       /**<   照片 */
@property (readonly, nonatomic) BOOL isVideo;                       /**<   视频 */
@property (readonly, nonatomic) BOOL isRAR;                         /**<   压缩包 */

@property (readonly, nonatomic, copy) NSString *urlEncodedString;           /**<   URL编码字符串 */
@property (readonly, nonatomic, copy) NSString *md5;                        /**<   获取MD5 */
@property (readonly, nonatomic, copy) NSDictionary *urlParams;              /**<   从url中获取参数 */
@property (readonly, nonatomic, copy) NSArray *ipSections;                  /**<   从ip地址中获取4个段 */
@property (readonly, nonatomic, copy) UIColor *hexColor;                    /**<   hexColor */
@property (readonly, nonatomic, copy) NSString *pinyin;                     /**<   获取拼音 */

- (BOOL)isDateWithFormat:(NSString *)format;                    /**<    判断是否是日期 */
- (NSDate *)dateWithFormat:(NSString *)format;                  /**<    获取日期 */
- (UIImage *)qrCodeWithWidth:(CGFloat)w;                        /**<    获取二维码图片 */
- (UIImage *)qrCodeWithWidth:(CGFloat)w color:(UIColor *)color; /**<    获取二维码图片 */
- (NSString *)stringByAppendingURLParams:(NSDictionary *)dict;  /**<    拼接url参数 */
- (NSString *)substringWithFrameSize:(CGSize)size font:(UIFont *)font;   /**<    按照显示框大小裁剪字符串 */
- (UIFont *)fontWithFrameSize:(CGSize)size maxFont:(UIFont *)maxFont;   /**<   按照显示框大小获取能刚好放进去的文字大小 */
- (NSString *)ciphertextWithHead:(int)head tail:(int)tail style:(int)style;      /**<   中间加*号（style：0长度不够时两边显示数量保持一致，1优先显示右边，2优先显示左边） */

- (NSString *)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len;

+ (NSString *)convertToCamelCaseFromSnakeCase:(NSString *)key;  /**<   下划线命名转驼峰命名 */
@end


@interface NSMutableString (Utils)
- (void)setObject:(NSString *)str atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);
@end
