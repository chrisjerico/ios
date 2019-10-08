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
/******************************************************************************
 函数名称 : gradientImageWithBounds;
 函数描述 : 把图片颜色渐变方法
 输入参数 : bounds 大小 colors：渐变颜色 2个 gradientType 方向
 输出参数 : UIImage
 返回参数 : UIImage
 备注信息 :
 ******************************************************************************/
+ (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(GradientDirection)gradientType;

/******************************************************************************
 函数名称 : qmui_imageWithTintColor;
 函数描述 : 把图片的纹理颜色换掉方法
 输入参数 : (UIColor *)
 输出参数 : UIImage
 返回参数 : UIImage
 备注信息 :
 ******************************************************************************/
- (UIImage *)qmui_imageWithTintColor:(UIColor *)tintColor;
/******************************************************************************
 函数名称 : qmui_imageWithBlendColor;
 函数描述 : 把图片的背景颜色换掉方法
 输入参数 : (UIColor *)
 输出参数 : UIImage
 返回参数 : UIImage
 备注信息 :
 ******************************************************************************/
- (UIImage *)qmui_imageWithBlendColor:(UIColor *)blendColor ;
@end

NS_ASSUME_NONNULL_END
