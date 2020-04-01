//
//  UGLHHomeContentCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHHomeContentCollectionViewCell.h"

@implementation UGLHHomeContentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 一闪一闪的动画效果
    FastSubViewCode(self);
    __weakSelf_(__self);
    __block NSInteger __i = 0;
    __block NSTimer *__timer = [NSTimer scheduledTimerWithInterval:0.27 repeats:true block:^(NSTimer *timer) {
        __i++;
        subButton(@"hotButton").y += __i%2 ? 2 : -2;
        if (__i > 1000000) {
            __i = 0;
        }
        if (!__self) {
            [__timer invalidate];
            __timer = nil;
        }
    }];
}

@end
