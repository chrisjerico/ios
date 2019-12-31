//
//  CMTimeCommon.m
//  ug
//
//  Created by ug on 2019/10/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMTimeCommon.h"

@implementation CMTimeCommon
//获取当前系统时间的时间戳

#pragma mark - 获取当前时间的 时间戳

+(NSInteger)getNowTimestamp{

 

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];//现在时间

    

    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);

    //时间转时间戳的方法:

   

    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];

    

    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值

    

    return timeSp;

}

 

//将某个时间转化成 时间戳

#pragma mark - 将某个时间转化成 时间戳

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{

    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    

    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate

    //时间转时间戳的方法:

    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];

    

    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值

    

    return timeSp;

}

 

//将某个时间戳转化成 时间

#pragma mark - 将某个时间戳转化成 时间

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{

    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];

    NSLog(@"1296035591  = %@",confromTimesp);

    

    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];

    

    NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);

    

    return confromTimespStr;

}

//日期的年月日
+ (NSInteger)getYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *currentTimeString = [formatter stringFromDate:self];
    return currentTimeString.integerValue;
}
+ (NSInteger)getMonth {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *currentTimeString = [formatter stringFromDate:self];
    return currentTimeString.integerValue;
}
+ (NSInteger)getDay {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *currentTimeString = [formatter stringFromDate:self];
    return currentTimeString.integerValue;
}

//当前日期20090909
+ (NSString *)currentDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

/******************************************************************************
函数名称 : lastDay;
函数描述 :
   //前一天

输入参数 : NSDate *date
输出参数 : NSDate
返回参数 : NSDate
备注信息 :
******************************************************************************/
+ (NSDate *)lastDay:(NSDate *)date {
    return [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
}

/******************************************************************************
函数名称 : nextDay;
函数描述 :
   //nextDay

输入参数 : NSDate *date
输出参数 : NSDate
返回参数 : NSDate
备注信息 :
******************************************************************************/
+ (NSDate *)nextDay:(NSDate *)date {
    return [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
}

/******************************************************************************
函数名称 : lastDayStr;
函数描述 :
   //前一天

输入参数 : NSString *dateStr  20091102
输出参数 : NSString
返回参数 : NSString
备注信息 :
******************************************************************************/
+ (NSString *)lastDayStr:(NSString *)dateStr format:(NSString *)formatStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    [dateFormatter setDateFormat:formatStr];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSDate *lastDaydate = [CMTimeCommon lastDay:date];
    
    NSString *lastStrDate = [dateFormatter stringFromDate:lastDaydate];
    NSLog(@"lastStrDate = %@",lastStrDate);
    return lastStrDate;
}

/******************************************************************************
函数名称 : nextDayStr;
函数描述 :
   //后一天

输入参数 : NSString *dateStr  20091102
输出参数 : NSString
返回参数 : NSString
备注信息 :
******************************************************************************/
+ (NSString *)nextDayStr:(NSString *)dateStr format:(NSString *)formatStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    [dateFormatter setDateFormat:formatStr];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSDate *lastDaydate = [CMTimeCommon nextDay:date];
    
    NSString *lastStrDate = [dateFormatter stringFromDate:lastDaydate];
    NSLog(@"dateStr = %@",dateStr);
    NSLog(@"nextDayStr = %@",lastStrDate);
    return lastStrDate;
}

/******************************************************************************
函数名称 : dateForStr ： format
函数描述 :
   //时间格式的字符串转date

输入参数 : NSString *dateStr  时间字符串   formatStr 时间格式
返回参数 : NSDate
备注信息 :
******************************************************************************/
+ (NSDate *)dateForStr:(NSString *)dateStr format:(NSString *)formatStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    [dateFormatter setDateFormat:formatStr];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题

    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

/******************************************************************************
函数名称 : strForDate;
函数描述 :
   //date转字符串

输入参数 : NSDate *date  时间   formatStr 时间格式
返回参数 : NSString
备注信息 :
******************************************************************************/
+ (NSString *)strForDate:(NSDate *)date format:(NSString *)formatStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    [dateFormatter setDateFormat:formatStr];

    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

@end
