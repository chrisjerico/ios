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

@end

NS_ASSUME_NONNULL_END
