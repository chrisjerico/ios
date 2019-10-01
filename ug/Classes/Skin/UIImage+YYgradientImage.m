//
//  UIImage+YYgradientImage.m
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UIImage+YYgradientImage.h"

@implementation UIImage (YYgradientImage)

+ (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(GradientDirection)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint startPt =  CGPointMake(0.0, 0.0);
    CGPoint endPt =  CGPointMake(0.0, 0.0);
    
    switch (gradientType) {
        case GradientDirectionTopToBottom:
            startPt= CGPointMake(0.0, 0.0);
            endPt= CGPointMake(0.0, bounds.size.height);
            break;
        case GradientDirectionLeftToRight:
            startPt = CGPointMake(0.0, 0.0);
            endPt = CGPointMake(bounds.size.width, 0.0);
            break;
        case GradientDirectionBottomToTop:
            startPt = CGPointMake(0.0, bounds.size.height);
            endPt = CGPointMake(0.0, 0.0);
            break;
        case GradientDirectionRightToLeft:
            startPt = CGPointMake(bounds.size.width, 0.0);
            endPt = CGPointMake(0, 0.0);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}


@end
