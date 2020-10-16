//
//  CMLabelCommon.m
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//
//            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:_titleLab3.text];
//             [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, 10)];
//             [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(24, 10)];
//             _titleLab3.attributedText = attriStr;
#import "CMLabelCommon.h"

@implementation CMLabelCommon


/**
 *改变字符串中具体某些字符串的颜色
 *theLab  要改变的label
 *change 要改变的文字组 @"300777.com,400777.com"
 *markColor  要变成的颜色 ：[UIColor redColor]
 *fontSize     要变成的字体  ：为 0 就是保持和原来一样
 *
 */
+ (void)messageSomeAction:(UILabel *)theLab changeString:(NSString *)change andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize {
 
    NSMutableAttributedString *attriStr = nil;
    if (theLab.attributedText.string.length) {
        attriStr = [[NSMutableAttributedString alloc] initWithAttributedString:theLab.attributedText];
    } else {
        attriStr = [[NSMutableAttributedString alloc] initWithString:theLab.text];
    }
   
    NSDictionary * attriBute ;
    if (fontSize) {
        attriBute = @{NSForegroundColorAttributeName:markColor,NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    } else {
        attriBute = @{NSForegroundColorAttributeName:markColor};
    }
   
    
    NSArray  *array = [change componentsSeparatedByString:@","];
    for (NSString *ns in array) {
        NSRange markRange = [theLab.text rangeOfString:ns];
        [attriStr addAttributes:attriBute range:markRange];
    }

    theLab.attributedText = attriStr;
}


/**
 *改变字符串中具体某字符串的颜色
 */
+ (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = nil;
    if (theLab.attributedText.string.length) {
        strAtt = [[NSMutableAttributedString alloc] initWithAttributedString:theLab.attributedText];
    } else {
        strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    }
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
    NSMutableAttributedString *strAtt = nil;
    if (theLab.attributedText.string.length) {
        strAtt = [[NSMutableAttributedString alloc] initWithAttributedString:theLab.attributedText];
    } else {
        strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    }
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
    if ([CMCommon stringIsNull:label.text]) {
        return;
    }
    NSMutableAttributedString *attributedString = nil;
    if (label.attributedText.string.length) {
        attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    } else {
        attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    }
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

/*
*
*改变字符lab 根据分隔符 最近长度 的颜色改变
 length：长度
 markColor ：改变颜色
 mrType:是否是最前面，1 全部 2 最前；3 最后
 @"66690-1213-66666-78979-123123-98898-7777-908999";
 比如：-  前2个长度变红
 [self messageAction:self.label labStr:str separation:@"-" length:2 andMarkColor:[UIColor redColor]];
 
*/


+(void)messageAction:(UILabel *)theLab labStr:(NSString*)str separation:(NSString *)separation  length:(int)length  andMarkColor:(UIColor *)markColor isMarkRangeType:(MarkRangeType )mrType {
    
    if (!str.length) {
        str = theLab.text;
    }
    NSArray  *array = [str componentsSeparatedByString:separation];//--分隔符
    NSString *arrStr0 = [array objectAtIndex:0];
    if (arrStr0.length < length) {
        return;
    }
  
    NSMutableArray *arrayRanges = [self getRangeStr:str findText:separation];
    NSMutableAttributedString *strAtt = nil;
    if (theLab.attributedText.string.length) {
        strAtt = [[NSMutableAttributedString alloc] initWithAttributedString:theLab.attributedText];
        strAtt.string = str;
    } else {
        strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    }
    
    
    if (mrType == MR_前面) {
        for (int i = 0; i<arrayRanges.count; i++) {
            NSRange markRange = NSMakeRange([[arrayRanges objectAtIndex:i] intValue]+1,length);
            [strAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:markRange];
        }
        NSRange markFrontRange = NSMakeRange(0,length);
        [strAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:markFrontRange];
        theLab.attributedText = strAtt;
    }
    else if  (mrType == MR_后面) {
        for (int i = 0; i<arrayRanges.count; i++) {
            NSRange  markRange =  NSMakeRange([[arrayRanges objectAtIndex:i] intValue]-length,length);
            [strAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:markRange];
        }
        NSRange markEndRange = NSMakeRange(str.length-length,length);
        [strAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:markEndRange];
        theLab.attributedText = strAtt;
    }
  
}
/*
*
* label 倒数 第几个 变颜色
 length：长度
 markColor ：改变颜色
 local ：倒数第几个  最后1位 为1
*/
+(void)messageLabel:(UILabel *)theLab length:(int)length local:(int)local  andMarkColor:(UIColor *)markColor
{
    if (local < length) {
        return;
    }
    NSMutableAttributedString *strAtt = nil;
    if (theLab.attributedText.string.length) {
        strAtt = [[NSMutableAttributedString alloc] initWithAttributedString:theLab.attributedText];
    } else {
        strAtt = [[NSMutableAttributedString alloc] initWithString:theLab.text];
    }
    NSRange markEndRange = NSMakeRange(theLab.text.length-local,length);
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markEndRange];
    theLab.attributedText = strAtt;
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


#pragma mark - 获取这个字符串中的所有xxx的所在的index
+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
        {
            
            if (0 == i)
            {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            } else {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)  {
                
                break;
                
            }else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}

@end
