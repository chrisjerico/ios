//
//  MGSlider.h
//  MGSlideDemo
//
//  Created by maling on 2019/7/24.
//  Copyright © 2019 maling. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MGSlider : UIView
@property (nullable, nonatomic, strong) UIImage *thumbImage;//锚点的图片
@property (nullable, nonatomic, strong) UIColor *thumbColor;//锚点的背景色
@property (nonatomic, assign) CGSize thumbSize;//锚点的大小
@property (nullable, nonatomic, strong) UIColor *trackColor;//进度条的颜色-
@property (nullable, nonatomic, strong) UIColor *untrackColor;//进度条的颜色+
@property (nullable, nonatomic, strong) UIImage *trackImage;
@property (nullable, nonatomic, strong) UIImage *untrackImage;
@property (nonatomic, assign) CGFloat margin; // 距离左右内间距
@property (nonatomic, assign, getter=isZoom) BOOL zoom; // 默认点击放大
@property (nonatomic, assign) CGFloat progressLineHeight;// 拖动条的高度
@property (nonatomic, assign) UIEdgeInsets touchRangeEdgeInsets;

@property (nonatomic, assign) CGFloat progress;// 默认第一次锚点所在的位置，1：100%  这个设置拖动条终点的位置
@property (nonatomic, assign) CGFloat moveProgress;//移动的刻度
@property (nonatomic, assign) CGFloat endProgress;//移动的刻度


@property (nonatomic, strong) UIImageView * _Nullable valveIV;


- (void)changeValue:(void(^_Nullable)(CGFloat value))changeEvent endValue:(void(^_Nullable)(CGFloat value))endValue;


@end


