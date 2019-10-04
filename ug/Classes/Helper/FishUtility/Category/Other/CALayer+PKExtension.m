//
//  CALayer+PKExtension.m
//  pk
//
//  Created by Jack on 2019/6/24.
//  Copyright © 2019 fish. All rights reserved.
//

#import "CALayer+PKExtension.h"

@implementation CALayer (PKExtension)

- (void)pk_pauseAnimation
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)pk_resumeAnimation
{
    CFTimeInterval pausedTime = self.timeOffset;
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end
