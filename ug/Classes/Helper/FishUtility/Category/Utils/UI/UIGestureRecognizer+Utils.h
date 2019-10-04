//
//  UIGestureRecognizer+Utils.h
//  dooboo
//
//  Created by fish on 16/5/16.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Utils)

@property (nonatomic, copy) IBInspectable NSString *tagString;

@property (readonly) NSMutableArray <void (^)(__kindof UIGestureRecognizer *gr)>*actionBlocks;

+ (instancetype)gestureRecognizer:(void (^)(__kindof UIGestureRecognizer *gr))actionBlock;
@end
