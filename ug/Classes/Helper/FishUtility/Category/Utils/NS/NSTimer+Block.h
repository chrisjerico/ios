//
//  NSTimer+Block.h
//  dooboo
//
//  Created by fish on 16/5/27.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)      // 实现了 block相关函数可以在iOS10以下使用

@property (nonatomic, readonly) void (^block)(NSTimer *timer);

+ (NSTimer *)timerWithInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
+ (NSTimer *)scheduledTimerWithInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end
