//
//  PieView.m
//  PieAnimation
//
//  Created by PC-LiuChunhui on 16/4/5.
//  Copyright © 2016年 Mr.Wendao. All rights reserved.
//

#import "PieView.h"
#define kAnimationDuration 1.0f
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kPieBackgroundColor [UIColor grayColor]
#define kPieFillColor [UIColor clearColor].CGColor
#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]
#define kLabelLoctionRatio (1.2*bgRadius)

@interface PieView()
@property (nonatomic) CAShapeLayer *bgCircleLayer;

@end

@implementation PieView
- (id)initWithFrame:(CGRect)frame count:(NSUInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        self.backgroundColor = kPieBackgroundColor;
       
        //1.pieView中心点
        CGFloat centerWidth = self.frame.size.width * 0.5f;
        CGFloat centerHeight = self.frame.size.height * 0.5f;
        CGFloat centerX = centerWidth;
        CGFloat centerY = centerHeight;
        CGPoint centerPoint = CGPointMake(centerX, centerY);
        CGFloat radiusBasic = centerWidth > centerHeight ? centerHeight : centerWidth;
        
        //线的半径为扇形半径的一半，线宽是扇形半径，这样就能画出圆形了
        //2.背景路径
        CGFloat bgRadius = radiusBasic * 0.5;
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                              radius:bgRadius
                                                          startAngle:-M_PI_2
                                                            endAngle:M_PI_2 * 3
                                                           clockwise:YES];
        _bgCircleLayer = [CAShapeLayer layer];
        _bgCircleLayer.fillColor   = [UIColor clearColor].CGColor;
        _bgCircleLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
        _bgCircleLayer.strokeStart = 0.0f;
        _bgCircleLayer.strokeEnd   = 1.0f;
        _bgCircleLayer.zPosition   = 1;
        _bgCircleLayer.lineWidth   = bgRadius * 2.0f;
        _bgCircleLayer.path        = bgPath.CGPath;
        
        
        //3.子扇区路径
        CGFloat otherRadius = radiusBasic * 0.5 - 3.0;
        UIBezierPath *otherPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                 radius:otherRadius
                                                             startAngle:-M_PI_2
                                                               endAngle:M_PI_2 * 3
                                                              clockwise:YES];
        
        CGFloat offset = -0.5/count;
        for (int i = 0; i < count + 1; i++) {
            //图层
            CAShapeLayer *pie = [CAShapeLayer layer];
            [self.layer addSublayer:pie];
            pie.fillColor   = kPieFillColor;
            pie.strokeColor = (i%2 ? [UIColor clearColor] : [UIColor colorWithWhite:1 alpha:0.5]).CGColor;
            pie.strokeStart = (double)i/count + offset;
            pie.strokeEnd   = (double)(i+1)/count + offset;
            pie.lineWidth   = otherRadius * 2.0f;
            pie.zPosition   = 2;
            pie.path        = otherPath.CGPath;
            
            
            //计算百分比label的位置
            CGFloat centerAngle = M_PI * (pie.strokeStart + pie.strokeEnd);
            CGFloat labelCenterX = kLabelLoctionRatio * sinf(centerAngle) + centerX;
            CGFloat labelCenterY = -kLabelLoctionRatio * cosf(centerAngle) + centerY;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, radiusBasic * 0.7f, radiusBasic * 0.7f)];
            label.center = CGPointMake(labelCenterX, labelCenterY);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.layer.zPosition = 3;
            [self addSubview:label];
        }
        self.layer.mask = _bgCircleLayer;
        
    }
    return self;
}
- (void)stroke
{
    //画图动画
    self.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = kAnimationDuration;
    animation.fromValue = @0.0f;
    animation.toValue   = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [_bgCircleLayer addAnimation:animation forKey:@"circleAnimation"];
    
}
- (void)dealloc
{
    [self.layer removeAllAnimations];
}

@end
