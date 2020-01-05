//
//  UIColor+YYUI.m
//  ug
//
//  Created by ug on 2020/1/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UIColor+YYUI.h"
@implementation UIColor (YYUI)

- (UIColor *)yyui_inverseColor {
    const CGFloat *componentColors = CGColorGetComponents(self.CGColor);
    UIColor *newColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                               green:(1.0 - componentColors[1])
                                                blue:(1.0 - componentColors[2])
                                               alpha:componentColors[3]];
    return newColor;
}
@end
