//
//  UIView+yyCornerRadius.m
//  ug
//
//  Created by ug on 2019/11/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UIView+yyCornerRadius.h"

@implementation UIView (yyCornerRadius)
-(void)makeRoundedCorner:(CGFloat)cornerRadius
{
    CALayer *roundedlayer = [self layer];
    [roundedlayer setMasksToBounds:YES];
    [roundedlayer setCornerRadius:cornerRadius];
}
@end
