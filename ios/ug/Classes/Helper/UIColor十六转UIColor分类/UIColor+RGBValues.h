//
//  UIColor+RGBValues.h
//  LDBarButtonItemExample
//
//  Created by Christian Di Lorenzo on 1/24/13.
//  Copyright (c) 2013 Light Design. All rights reserved.
//
#define RGB(R, G, B)    [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1.0]
#import <UIKit/UIKit.h>

@interface UIColor (RGBValues)

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;

/**
 *  十六进制的颜色转换为UIColor
 */
+ (UIColor *)colorWithHexString: (NSString *)color;
@end
