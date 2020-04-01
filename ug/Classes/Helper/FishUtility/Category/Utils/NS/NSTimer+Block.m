//
//  NSTimer+Block.m
//  dooboo
//
//  Created by fish on 16/5/27.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import "NSTimer+Block.h"
#import "cc_runtime_property.h"


@interface CCTimerModel : NSObject
@property (copy, nonatomic) void (^block)(NSTimer *timer);
- (void)onTiming:(NSTimer *)timer;
@end

@implementation CCTimerModel
- (void)onTiming:(NSTimer *)timer {
    if (self.block)
        self.block(timer);
}
@end


@interface NSTimer ()
@property (nonatomic) CCTimerModel *model;
@end

@implementation NSTimer (Block)

_CCRuntimeProperty_Retain(CCTimerModel *, model, setModel);

+ (NSTimer *)timerWithInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void (^)(NSTimer *))block {
    CCTimerModel *tm = [CCTimerModel new];
    tm.block = block;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:tm selector:@selector(onTiming:) userInfo:nil repeats:repeats];
    timer.model = tm;
    return timer;
}

+ (NSTimer *)scheduledTimerWithInterval:(NSTimeInterval)ti repeats:(BOOL)repeats block:(void (^)(NSTimer *))block {
    CCTimerModel *tm = [CCTimerModel new];
    tm.block = block;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:tm selector:@selector(onTiming:) userInfo:nil repeats:repeats];
    timer.model = tm;
    return timer;
}

- (void (^)(NSTimer *))block {
    return self.model.block;
}

@end
