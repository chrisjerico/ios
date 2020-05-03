//
//  LYLuckyCardRotationView.m
//  LYLuckyCardDemo
//
//  Created by leo on 17/2/9.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "LYLuckyCardRotationView.h"
#import "Masonry.h"
#import "LYLuckyCardCellView.h"

#define kLuckyCardCellCount 4 //转盘小格子数
#define kLuckyCardCellViewSize CGSizeMake(68, 173) //每个小格子大小

@interface LYLuckyCardRotationView () <CAAnimationDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;//转盘

@property (nonatomic, strong) NSMutableArray *cellArray;



@end

@implementation LYLuckyCardRotationView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellArray = [NSMutableArray arrayWithCapacity:kLuckyCardCellCount];
    CGFloat angle = 2 * M_PI / (CGFloat)kLuckyCardCellCount;
    for (int i = 0; i < kLuckyCardCellCount; i++) {
        CGRect cellFrame = CGRectZero;
        cellFrame.origin = CGPointMake(0, 0);
        cellFrame.size = kLuckyCardCellViewSize;
        LYLuckyCardCellView *cellView = [[LYLuckyCardCellView alloc] initWithFrame:cellFrame];
        [cellView configCell:i + 1];
        cellView.imageView.image = [UIImage imageNamed:@"dzp_Icon"];
        cellView.layer.anchorPoint = CGPointMake(0.5, 1);
        cellView.layer.position = CGPointMake(self.canRotationView.bounds.size.width / 2.0, self.canRotationView.bounds.size.height / 2.0);
        cellView.transform = CGAffineTransformMakeRotation(angle * i);
        [self.canRotationView addSubview:cellView];
        [self.cellArray addObject:cellView];
    }
}


-(void)setDataArray:(NSArray<DZPprizeModel *> *)dataArray{
//    _dataArray = dataArray;
//    self.cellArray = [NSMutableArray arrayWithCapacity:_dataArray.count];
//    CGFloat angle = 2 * M_PI / (CGFloat)_dataArray.count;
//    for (int i = 0; i < _dataArray.count; i++) {
//
//        DZPprizeModel *model = [_dataArray objectAtIndex:i];
//        CGRect cellFrame = CGRectZero;
//        cellFrame.origin = CGPointMake(0, 0);
//        cellFrame.size = kLuckyCardCellViewSize;
//        LYLuckyCardCellView *cellView = [[LYLuckyCardCellView alloc] initWithFrame:cellFrame];
//        [cellView.label setText:model.prizeName];
//        [cellView.imageView sd_setImageWithURL:[NSURL URLWithString:model.prizeIcon] placeholderImage:[UIImage imageNamed:@"loading"]];
//        cellView.layer.anchorPoint = CGPointMake(0.5, 1);
//        cellView.layer.position = CGPointMake(self.canRotationView.bounds.size.width / 2.0, self.canRotationView.bounds.size.height / 2.0);
//        cellView.transform = CGAffineTransformMakeRotation(angle * i);
//        [self.canRotationView addSubview:cellView];
//        [self.cellArray addObject:cellView];
//    }
//
//    [self setNeedsDisplay];
}



- (IBAction)beginAction:(id)sender {
    [self beignRotaion];
}

//开启动画方法
- (void)beignRotaion {
    NSInteger index = random() % _dataArray.count;
    LYLuckyCardCellView *cellView = self.cellArray[index];
    CGFloat angle = atan2(cellView.transform.b, cellView.transform.a);
    self.canRotationView.transform = CGAffineTransformMakeRotation(-angle);

    [self animationPart];

}
//动画方法
- (void)animationPart {
    
    int randomInt = [CMCommon getRandomNumber:1 to:6];
    
    [self.canRotationView.layer removeAllAnimations];
    self.animationPart1 = [CABasicAnimation animation];
    _animationPart1.keyPath = @"transform.rotation";
    //  最初的动画位置
        _animationPart1.fromValue = [NSNumber numberWithDouble:1.0];
    //  结束的动画位置
        _animationPart1.toValue = [NSNumber numberWithDouble:0.0];
//    animationPart1.byValue = @(randomInt * 2 * M_PI);
//    _animationPart1.byValue = @(2.25 * 2 * M_PI);
    //    动画间隔时间
        _animationPart1.duration= 3.0;
        _animationPart1.autoreverses= NO;
    //    动画完成之后是否还原
        _animationPart1.removedOnCompletion= NO;
    //     动画的次数      FLT_MAX=="forever"
//    _animationPart1.repeatCount = CGFLOAT_MAX;
    //    设置代理
        _animationPart1.delegate = self;
    
    _animationPart1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; //由快变慢
    _animationPart1.fillMode = kCAFillModeForwards;



    
    [self.canRotationView.layer addAnimation:_animationPart1 forKey:@"animationPart1"];
    
    NSLog(@"");
}

#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart%@",self.layer.animationKeys);
 
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"animationDidStop%@",self.layer.animationKeys);

//    if (anim==[self.layer animationForKey:DISMISSANIMATION]) {
//        [self removeFromSuperview];
//
//    }
//
}

@end
