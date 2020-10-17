//
//  CMLabelCommon.h
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface CMLabelCommon : NSObject



/**
 *改变字符串中具体某些字符串的颜色
 */
+ (void)messageSomeAction:(UILabel *)theLab changeString:(NSString *)change andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize;

/**
 *改变字符串中具体某字符串的颜色
 */
+ (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize ;
 
/*
 *x*y
 *改变字符start 和 end 之间的字符的颜色 和 字体大小
 */
+ (void)messageAction:(UILabel *)theLab startString:(NSString *)start endString:(NSString *)end andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize ;
 
/**
 *改变字符串中所有数字的颜色
 */
+ (void)setRichNumberWithLabel:(UILabel*)label Color:(UIColor *)color FontSize:(CGFloat)size ;


/*
*
*改变字符lab 根据分隔符 最近长度 的颜色改变
 length：长度
 markColor ：改变颜色
 isMarkRangeType: 最前； 最后
 @"66690-1213-66666-78979-123123-98898-7777-908999";
 比如：-  前2个长度变红
 [self messageAction:self.label labStr:str separation:@"-" length:2 andMarkColor:[UIColor redColor]];
 
*/
typedef NS_ENUM(NSInteger, MarkRangeType) {
    MR_前面   = 1,
    MR_后面   = 2,
};
+(void)messageAction:(UILabel *)theLab labStr:(NSString*)str separation:(NSString *)separation  length:(int)length  andMarkColor:(UIColor *)markColor isMarkRangeType:(MarkRangeType )mrType ;

/*
*
* label 倒数 第几个 变颜色
 length：长度
 markColor ：改变颜色
 local ：倒数第几个
*/
+(void)messageLabel:(UILabel *)theLab length:(int)length local:(int)local  andMarkColor:(UIColor *)markColor;

#pragma mark - 获取这个字符串中的所有xxx的所在的index
+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText;

@end

NS_ASSUME_NONNULL_END
