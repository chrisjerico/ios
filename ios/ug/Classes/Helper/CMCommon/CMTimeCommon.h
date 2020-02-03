//
//  CMTimeCommon.h
//  ug
//
//  Created by ug on 2019/10/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMTimeCommon : NSObject

/******************************************************************************
函数名称 : yyUrlConversionParameter;
函数描述 :把类似
   //获取当前系统时间的时间戳

输入参数 : nil
输出参数 : NSInteger
返回参数 : NSInteger    ==>1571407419
备注信息 :
******************************************************************************/

+(NSInteger)getNowTimestamp;


/******************************************************************************
函数名称 : timeSwitchTimestamp;
函数描述 :把类似
   //将某个时间转化成 时间戳

输入参数 : formatTime  时间    format  格式 类似 @"YYYY-MM-dd hh:mm:ss"
输出参数 : NSInteger
返回参数 : NSInteger    ==>1571407170
备注信息 :
******************************************************************************/

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

/******************************************************************************
函数名称 : timestampSwitchTime;
函数描述 :把类似
   //将某个时间戳转化成 时间

输入参数 : timestamp  时间挫   format  格式 类似@"YYYY-MM-dd hh:mm:ss"
输出参数 : NSString
返回参数 : NSString    ==>2019-10-17 09:30:00
备注信息 :
******************************************************************************/

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;


//日期的年月日
+ (NSInteger)getYear;
+ (NSInteger)getMonth;
+ (NSInteger)getDay;
//当前日期20090909
+ (NSString *)currentDateString;

/******************************************************************************
函数名称 : currentDateStringWithFormat;
函数描述 :
   //根据格式返回当前时间的字符串

输入参数 : format
输出参数 : NSString 当前时间的字符串
返回参数 :
备注信息 :
******************************************************************************/
+ (NSString *)currentDateStringWithFormat:(NSString *)format;
/******************************************************************************
函数名称 : dateStringWithFormat; date
函数描述 :
   //根据格式,时间返回时间的字符串 NSDate转NSString

输入参数 : format，date
输出参数 : NSString 当前时间的字符串
返回参数 :
备注信息 :
******************************************************************************/
+ (NSString *)dateStringWithFormat:(NSString *)format  date:(NSDate *)date;
/******************************************************************************
函数名称 : lastDayStr;
函数描述 :
   //前一天

输入参数 : NSString *dateStr  20091102
输出参数 : NSString
返回参数 : NSString
备注信息 :
******************************************************************************/
+ (NSString *)lastDayStr:(NSString *)dateStr format:(NSString *)formatStr;

/******************************************************************************
函数名称 : nextDayStr;
函数描述 :
   //后一天

输入参数 : NSString *dateStr  20091102
输出参数 : NSString
返回参数 : NSString
备注信息 :
******************************************************************************/
+ (NSString *)nextDayStr:(NSString *)dateStr format:(NSString *)formatStr;

/******************************************************************************
函数名称 : dateForStr ： format
函数描述 :
   //时间格式的字符串转date

输入参数 : NSString *dateStr  时间字符串   formatStr 时间格式
返回参数 : NSDate
备注信息 :
******************************************************************************/
+ (NSDate *)dateForStr:(NSString *)dateStr format:(NSString *)formatStr;

/******************************************************************************
函数名称 : strForDate;
函数描述 :
   //date转字符串

输入参数 : NSDate *date  时间   formatStr 时间格式
返回参数 : NSString
备注信息 :
******************************************************************************/
+ (NSString *)strForDate:(NSDate *)date format:(NSString *)formatStr;

/******************************************************************************
函数名称 : compareOneDay;
函数描述 :
   //比较NSDate 大小

输入参数 :oneDay 时间   anotherDay
返回参数 : int   1  晚， -1 早  0 相同
备注信息 :
******************************************************************************/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

/******************************************************************************
函数名称 : formatTimeStr;
函数描述 :
   //返回 刚刚，几分钟前，几小时前，昨天，前天

输入参数 :timeStr   "2017-01-01 21:05:10
返回参数 : 刚刚，几分钟前，几小时前，昨天，前天
备注信息 :
******************************************************************************/
+(NSString *)formatTimeStr:(NSString *)timeStr;
@end

NS_ASSUME_NONNULL_END
