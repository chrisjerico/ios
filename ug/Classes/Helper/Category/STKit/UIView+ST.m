//
//  UIView+ST.m
//  Notepad
//
//  Copyright © 2016年 com.st. All rights reserved.
//

#import "UIView+ST.h"

@implementation UIView (ST)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)sety:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}


- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}


- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)Size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (void)addTarget:(id)target
           action:(SEL)action;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (UIView *)getParsentView:(UIView *)view
{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

- (void)addBorderColor:(UIColor *)color{
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:0.5];
    [self.layer setCornerRadius:4];
}

- (void)popupShow {
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    view.y += UGScerrnH;
    [maskView addSubview:view];
    [window addSubview:maskView];
    [UIView animateWithDuration:0.35 animations:^{
        view.y -= UGScerrnH;
    }];
}

- (void)popupHidden {
    UIView* view = self;
    [UIView animateWithDuration:0.25 animations:^{
        view.y += UGScerrnH;
    } completion:^(BOOL finished) {
        
        [view.superview removeFromSuperview];
        [view removeFromSuperview];
    }];
}



- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
    return;
    
    CABasicAnimation *animation0 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation0.fromValue = [NSNumber numberWithFloat:0];
    animation0.toValue = [NSNumber numberWithFloat:1.1];
    animation0.duration = 0.25;
    animation0.autoreverses = NO;
    animation0.repeatCount = 0;
    animation0.removedOnCompletion = YES;
    animation0.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation0 forKey:@"zoom0"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSNumber numberWithFloat:1.1];
        animation.toValue = [NSNumber numberWithFloat:1];
        animation.duration = 0.15;
        animation.autoreverses = NO;
        animation.repeatCount = 0;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        [view.layer addAnimation:animation forKey:@"zoom1"];
    });


}

- (void)hidden {
    
    UIView* view = self;
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
    return;
    
    CABasicAnimation *animation0 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation0.fromValue = [NSNumber numberWithFloat:1];
    animation0.toValue = [NSNumber numberWithFloat:1.1];
    animation0.duration = 0.25;
    animation0.autoreverses = NO;
    animation0.repeatCount = 0;
    animation0.removedOnCompletion = YES;
    animation0.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation0 forKey:@"hiddenZoom0"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSNumber numberWithFloat:1.1];
        animation.toValue = [NSNumber numberWithFloat:0];
        animation.duration = 0.25;
        animation.autoreverses = NO;
        animation.repeatCount = 0;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        [view.layer addAnimation:animation forKey:@"hiddenZoom1"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            view.hidden = YES;
            view.superview.hidden = YES;
            [view.superview removeFromSuperview];
            [view removeFromSuperview];
        });
    });
    
   
}


-(UIViewController* )superViewController {
    
    for(UIView*next = [self superview]; next; next = next.superview)
    {
        UIResponder*nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            return(UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
