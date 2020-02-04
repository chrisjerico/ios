//
//  UIColor+YYUI.h
//  ug
//
//  Created by ug on 2020/1/5.
//  Copyright © 2020 ug. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YYUI)
 /**<   计算反色 */
- (UIColor *)yyui_inverseColor;

/**
 *  将自身变化到某个目标颜色，可通过参数progress控制变化的程度，最终得到一个纯色
 *  @param toColor 目标颜色
 *  @param progress 变化程度，取值范围0.0f~1.0f
 */
- (UIColor *)qmui_transitionToColor:(nullable UIColor *)toColor progress:(CGFloat)progress;
@end

NS_ASSUME_NONNULL_END
