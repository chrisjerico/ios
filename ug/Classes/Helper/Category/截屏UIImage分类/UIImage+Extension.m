//
//  UIImage+Extension.m
//  ug
//
//  Created by ug on 2020/1/19.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UIImage+Extension.h"


@implementation UIImage (Extension)

/**
*  "截屏""
*
*
*/
+ (UIImage *)rendImageWithView:(UIView *)view{
    
//      1.开始位图上下文
    UIGraphicsBeginImageContext(view.frame.size);
//      2.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    3.截图
    [view.layer renderInContext:ctx];
//    4.获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
//    5.关闭上下文
    UIGraphicsEndImageContext() ;
    
    return newImage;
    
}

@end
