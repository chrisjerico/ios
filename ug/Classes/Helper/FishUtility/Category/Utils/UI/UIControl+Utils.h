//
//  UIControl+Utils.h
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Utils)

@property (nonatomic) void (^didSelectedChange)(__kindof UIControl *sender, BOOL selected);

- (void)handleControlEvents:(UIControlEvents)controlEvents actionBlock:(void (^)(__kindof UIControl *sender))actionBlock;
- (void)removeActionBlocksForControlEvents:(UIControlEvents)controlEvents;

@end
