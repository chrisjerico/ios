//
//  UIView+Frame.h
//  Qlippie
//
//  Created by fish on 15/6/12.
//  Copyright (c) 2015年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat bx;       /**<   右下角的 x */
@property (nonatomic) CGFloat by;       /**<   右下角的 y */

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@end
