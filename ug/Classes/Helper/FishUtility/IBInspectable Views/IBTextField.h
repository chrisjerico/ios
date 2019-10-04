//
//  IBTextField.h
//  C
//
//  Created by fish on 2018/1/5.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBTextField : UITextField
// 集成IBView 参数
@property (nonatomic) IBInspectable CGFloat 圆角偏移量;
@property (nonatomic) IBInspectable CGPoint 圆角倍数;

@property (nonatomic) IBInspectable BOOL maskToBounds;

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;


// IBTextField参数
@property (nonatomic) IBInspectable CGFloat insetLeft;
@property (nonatomic) IBInspectable CGFloat insetRight;
@end
