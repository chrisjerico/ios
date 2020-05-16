//
//  UIView+Extension.h
//  微博
//
//  Created by tianwang on 15-3-28.
//  Copyright (c) 2015年 shenlan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;



- (void)show;
- (void)hidden;
@end
