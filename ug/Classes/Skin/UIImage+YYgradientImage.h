//
//  UIImage+YYgradientImage.h
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GradientDirection) {
    GradientDirectionTopToBottom = 0,    // 从上往下 渐变
    GradientDirectionLeftToRight,        // 从左往右
    GradientDirectionBottomToTop,      // 从下往上
    GradientDirectionRightToLeft      // 从右往左
};
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YYgradientImage)
+ (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(GradientDirection)gradientType;

//这个方法可以抽取到 UIImage 的分类中
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
