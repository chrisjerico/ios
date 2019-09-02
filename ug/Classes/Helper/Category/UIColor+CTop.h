//
//  UIColor+CTop.h
//  CarKeys
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CTop)
+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;
+ (UIColor *)randomColor;
+ (instancetype)opacityColorWithHex: (NSUInteger)hex;
@end
