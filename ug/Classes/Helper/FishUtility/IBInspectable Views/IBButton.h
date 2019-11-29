//
//  IBButton.h
//  IBInspectable
//
//  Created by fish on 16/6/1.
//  Copyright © 2016年 aduu. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface IBButton : UIButton

// 集成IBView 参数
@property (nonatomic) IBInspectable CGFloat 圆角偏移量;
@property (nonatomic) IBInspectable CGPoint 圆角倍数;

@property (nonatomic) IBInspectable BOOL maskToBounds;

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;

// IBButton参数
@property (nonatomic) IBInspectable UIColor *选中时描边颜色;

@property (nonatomic) IBInspectable UIColor *默认背景色;
@property (nonatomic) IBInspectable UIColor *高亮背景色;
@property (nonatomic) IBInspectable UIColor *选中背景色;

@property (nonatomic) IBInspectable BOOL 选中时字体加粗;

@property (nonatomic) IBInspectable CGFloat 文字左间距;
@end


@interface UIButton (IBInspectableUtils)
@property (nonatomic) IBInspectable BOOL imgFitOrFill;
@property (nonatomic) IBInspectable CGSize imgSize;
@end
