//
//  UIColor+YYUI.m
//  ug
//
//  Created by ug on 2020/1/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UIColor+YYUI.h"
@implementation UIColor (YYUI)

- (CGFloat)qmui_red {
    CGFloat r;
    if ([self getRed:&r green:0 blue:0 alpha:0]) {
        return r;
    }
    return 0;
}

- (CGFloat)qmui_green {
    CGFloat g;
    if ([self getRed:0 green:&g blue:0 alpha:0]) {
        return g;
    }
    return 0;
}

- (CGFloat)qmui_blue {
    CGFloat b;
    if ([self getRed:0 green:0 blue:&b alpha:0]) {
        return b;
    }
    return 0;
}

- (CGFloat)qmui_alpha {
    CGFloat a;
    if ([self getRed:0 green:0 blue:0 alpha:&a]) {
        return a;
    }
    return 0;
}

+ (UIColor *)qmui_colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    progress = MIN(progress, 1.0f);
    CGFloat fromRed = fromColor.qmui_red;
    CGFloat fromGreen = fromColor.qmui_green;
    CGFloat fromBlue = fromColor.qmui_blue;
    CGFloat fromAlpha = fromColor.qmui_alpha;
    
    CGFloat toRed = toColor.qmui_red;
    CGFloat toGreen = toColor.qmui_green;
    CGFloat toBlue = toColor.qmui_blue;
    CGFloat toAlpha = toColor.qmui_alpha;
    
    CGFloat finalRed = fromRed + (toRed - fromRed) * progress;
    CGFloat finalGreen = fromGreen + (toGreen - fromGreen) * progress;
    CGFloat finalBlue = fromBlue + (toBlue - fromBlue) * progress;
    CGFloat finalAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    
    return [UIColor colorWithRed:finalRed green:finalGreen blue:finalBlue alpha:finalAlpha];
}

- (UIColor *)yyui_inverseColor {
    const CGFloat *componentColors = CGColorGetComponents(self.CGColor);
    UIColor *newColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                               green:(1.0 - componentColors[1])
                                                blue:(1.0 - componentColors[2])
                                               alpha:componentColors[3]];
    return newColor;
}

- (UIColor *)qmui_transitionToColor:(UIColor *)toColor progress:(CGFloat)progress {
    return [UIColor qmui_colorFromColor:self toColor:toColor progress:progress];
}





@end
