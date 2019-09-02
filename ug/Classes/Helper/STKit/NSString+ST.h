//
//  NSString+ST.h


#import <Foundation/Foundation.h>

@interface NSString (ST)
/**
 *  1.返回字符串所占用的尺寸
 *
 *  @param fontSize     字体大小
 *  @param maxWidth     最大宽度
 *  @param maxHeight    最大高度
 */
//- (CGSize)sizeWithFont:(CGFloat)fontSize
//              maxWidth:(CGFloat)maxWidth
//             maxHeight:(CGFloat)maxHeight;


/**
 *  2.判断自己是否为空
 *
 *  @return 是空，返回YES
 */
- (BOOL) isBlank;

/**
 *  3.自身为空的替换字符串
 *
 *  @return 是空，返回替换字符串，不是空，返回自身
 */
- (NSString *)isBlankWithChangeString:(NSString *)changeString;

/**
 *  4.是否是手机号
 *
 *  @return <#return value description#>
 */
- (BOOL)isTelNum;

/**
 *  5.时间戳字符串,格式：2016年02月23日
 */
- (NSString *)stringToDateString;


/**
 *  6.时间戳字符串,格式：2016-02-23
 */
- (NSString *)stringToFormatDateString;


/**
 *  7.时间戳字符串,格式：2016.02.23
 */
- (NSString *)stringToFormat0DateString;

/**
 *  8.时间戳字符串,格式：YYYY-MM-dd HH:mm:ss
 */
- (NSString *)stringToFormatSecondDateString;

/**
 *  9.时间戳转时间模型
 */
- (NSDateComponents *)stringToDateComponents;

/**
 *  10.去除字符串中的符号，如 《》 【】 [] () \n \\ \
 */
- (NSString *)stringByReplaceSymbols;

/**
 *  11.json字符串，转成字典
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)stringJsonToDictionary;

/**
 *  时间转时间戳,YYYY年MM月dd日
 *
 *  @param NSString <#NSString description#>
 *
 *  @return <#return value description#>
 */

- (NSString *)stringTimeToTimeInterval;

/**
 *  时间转时间戳,yyyy-HH-mm HH:mm:ss
*/

- (NSString *)timeStrToTimeInterval;

/**
 *  毫秒数转字符格式，TO HH:MM
 */
- (NSString *)stringToSecond;

/**
 *  10.时间戳字符串,格式：MM-dd HH:mm
 */
- (NSString *)stringToFormatMMddHHmmDateString;

/**
 *  是否金额格式
 *
 *  @return YES/NO
 */
-(BOOL)isMoneyNum;

/**
 *  是否是纯数字
 *
 *  @return YES/NO
 */
- (BOOL)isNumText;

//拼接服务器图片地址
-(NSString *)cloudfsImageUrl;

//拼接服务器地址
-(NSString *)appendServerURL;

//校验身份证格式
- (BOOL)isVerifyIDCardNumber;

//比较两个时间的大小
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

//去除前后空格
- (NSString *)stringByTrimming;


- (NSString *)stringToRestfulUrlWithFlag:(BOOL )flag;

- (NSString *)removeFloatAllZero;
@end
