//
//  UIColor+Utils.h
//  FishUtility
//
//  Created by fish on 16/8/15.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

// 16进制颜色
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// RGB
#define UIColorRGB(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]

// RGBA
#define UIColorRGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]

@interface UIColor (Utils)

+ (UIColor *)randomColor;
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

- (BOOL)isEqualToColor:(UIColor *)color;
- (UIImage *)image;

@end



@interface NSValue (CGColorValue)
+ (NSValue *)valueWithCGColor:(CGColorRef)color;
- (CGColorRef)CGColorValue;
@end
