//
//  UIView+CTop.h
//  CarKeys
//
//  Created by Apple on 2016/12/14.
//  Copyright © 2016年 comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CTop)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

- (void)show;
- (void)hidden;


@end
