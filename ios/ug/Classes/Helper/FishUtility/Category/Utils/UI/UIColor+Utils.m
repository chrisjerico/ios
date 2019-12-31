//
//  UIColor+Utils.m
//  FishUtility
//
//  Created by fish on 16/8/15.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

- (UIImage *)image {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)isEqualToColor:(UIColor *)color {
    return CGColorEqualToColor(self.CGColor, color.CGColor);
}

+ (UIColor *)randomColor {
    return [self randomColorWithAlpha:1];
}

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(arc4random()%256)/255.0
                           green:(arc4random()%256)/255.0
                            blue:(arc4random()%256)/255.0
                           alpha:alpha];
}

@end


@implementation NSValue (CGColorValue)

+ (NSValue *)valueWithCGColor:(CGColorRef)color {
    return [NSValue valueWithBytes:&color objCType:@encode(CGColorRef)];
}

- (CGColorRef)CGColorValue {
    CGColorRef color;
    [self getValue:&color];
    return color;
}

@end
