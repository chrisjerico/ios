//
//  UIColor+CTop.m
//  CarKeys
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 comtop. All rights reserved.
//

#import "UIColor+CTop.h"

@implementation UIColor (CTop)
+(UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
+(UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
}

+ (instancetype)opacityColorWithHex: (NSUInteger)hex {
    return [self colorWithRed: ((hex >> 16) & 0xFF) / 255.0
                        green: ((hex >> 8) & 0xFF) / 255.0
                         blue: ((hex >> 0) & 0xFF) / 255.0
                        alpha: 1];
}

@end
