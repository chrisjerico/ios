//
//  CMLabelCommon.m
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMLabelCommon.h"

@implementation CMLabelCommon

/**
 *改变字符串中具体某字符串的颜色
 */
+ (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    NSRange markRange = [tempStr rangeOfString:change];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] range:markRange];
    theLab.attributedText = strAtt;
}
 
/*
 *x*y
 *改变字符start 和 end 之间的字符的颜色 和 字体大小
 */
+ (void)messageAction:(UILabel *)theLab startString:(NSString *)start endString:(NSString *)end andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    // 'x''y'字符的范围
    NSRange tempRange = NSMakeRange(0, 0);
    if ([self judgeStringIsNull:start]) {
        tempRange = [tempStr rangeOfString:start];
    }
    NSRange tempRangeOne = NSMakeRange([strAtt length], 0);
    if ([self judgeStringIsNull:end]) {
        tempRangeOne =  [tempStr rangeOfString:end];
    }
    // 更改字符颜色
    NSRange markRange = NSMakeRange(tempRange.location+tempRange.length, tempRangeOne.location-(tempRange.location+tempRange.length));
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    // 更改字体
    // [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] range:NSMakeRange(0, [strAtt length])];
    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] range:markRange];
    theLab.attributedText = strAtt;
}
 
/**
 *改变字符串中所有数字的颜色
 */
+ (void)setRichNumberWithLabel:(UILabel*)label Color:(UIColor *)color FontSize:(CGFloat)size {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSString *temp = nil;
    for(int i =0; i < [attributedString length]; i++) {
        temp = [label.text substringWithRange:NSMakeRange(i, 1)];
        if ([self isPureInt:temp]) {
            [attributedString setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             color, NSForegroundColorAttributeName,
                                             [UIFont systemFontOfSize:size],NSFontAttributeName, nil]
                                      range:NSMakeRange(i, 1)];
        }
    }
    label.attributedText = attributedString;
}


/**
 *此方法是用来判断一个字符串是不是整型.
 *如果传进的字符串是一个字符,可以用来判断它是不是数字
 */
+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}
 
/**
 *判断字符串是否不全为空
 */
+ (BOOL)judgeStringIsNull:(NSString *)string {
    if ([[string class] isSubclassOfClass:[NSNumber class]]) {
        return YES;
    }
    BOOL result = NO;
    if (string != nil && string.length > 0) {
        for (int i = 0; i < string.length; i ++) {
            NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
            if (![subStr isEqualToString:@" "] && ![subStr isEqualToString:@""]) {
                result = YES;
            }
        }
    }
    return result;
}

//————————————————
//版权声明：本文为CSDN博主「枫志应明」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/wsyx768/article/details/25101173
@end
