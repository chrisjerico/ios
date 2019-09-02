//
//  UIColor+ST.h

#import <UIKit/UIKit.h>

@interface UIColor (ST)
/**
 *  从HEX字符串得到一个UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  从HEX数值得到一个UIColor对象
 */
+ (instancetype)colorWithHex: (NSUInteger)hex;

/**
 *  从HEX数值和Alpha数值得到一个UIColor对象
 */
+ (UIColor *)colorWithHex:(unsigned int)hex
                    alpha:(float)alpha;

/**
 *  创建一个随机UIColor对象
 */
+ (UIColor *)randomColor;

/**
 *  从已知UIColor对象和Alpha对象得到一个UIColor对象
 */
+ (UIColor *)colorWithColor:(UIColor *)color
                      alpha:(float)alpha;
@end
