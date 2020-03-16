//
//  UIView+Frame.m
//  Qlippie
//
//  Created by fish on 15/6/12.
//  Copyright (c) 2015年 fish. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setBx:(CGFloat)bx {
    self.x = bx-self.width;
}

-(CGFloat)bx {
    return self.x+self.width;
}

-(void)setBy:(CGFloat)by {
    self.y = by-self.height;
}

-(CGFloat)by {
    return self.y+self.height;
}


- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


// Miu 控件之间对齐用
- (CGFloat)centerX
{
    return self.center.x;
}
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint newcenter = self.center;
    newcenter.x = centerX;
    self.center = newcenter;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint newcenter = self.center;
    newcenter.y = centerY;
    self.center = newcenter;
}

@end
