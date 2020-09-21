//
//  UIView+AutoLayoutText.h
//  Eyesir
//
//  Created by fish on 16/7/22.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLocalizable)                 // 自动本地化

@property (nonatomic) BOOL disableAutoLocalizable;  /**<   禁用自动本地化 */

+ (void)enableAutoLocalizable;                      /**<   开启所有View的自动本地化功能 */

+ (void)autoLocalizableView:(UIView *)view;

@end
