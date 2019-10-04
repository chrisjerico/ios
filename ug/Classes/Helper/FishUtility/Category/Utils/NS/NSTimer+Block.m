//
//  NSTimer+Block.m
//  dooboo
//
//  Created by fish on 16/5/27.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import "NSTimer+Block.h"
#import "zj_runtime_property.h"


@interface ZJTimerModel : NSObject
@property (copy, nonatomic) void (^block)(NSTimer *timer);
- (void)onTiming:(NSTimer *)timer;
@end

@implementation ZJTimerModel
- (void)onTiming:(NSTimer *)timer {
    if (self.block)
        self.block(timer);
}
@end


@interface NSTimer ()
@property (nonatomic) ZJTimerModel *model;
@end

@implementation NSTimer (Block)

_ZJRuntimeProperty_Retain(ZJTimerModel *, model, setModel);

+ (NSTimer *)timerWithInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void (^)(NSTimer *))block {
    ZJTimerModel *tm = [ZJTimerModel new];
    tm.block = block;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:tm selector:@selector(onTiming:) userInfo:nil repeats:repeats];
    timer.model = tm;
    return timer;
}

+ (NSTimer *)scheduledTimerWithInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void (^)(NSTimer *))block {
    ZJTimerModel *tm = [ZJTimerModel new];
    tm.block = block;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:tm selector:@selector(onTiming:) userInfo:nil repeats:repeats];
    timer.model = tm;
    return timer;
}

- (void (^)(NSTimer *))block {
    return self.model.block;
}

@end
