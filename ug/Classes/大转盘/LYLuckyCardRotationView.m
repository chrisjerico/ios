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

#define kLuckyCardCellViewSize CGSizeMake(68, 173) //每个小格子大小

@interface LYLuckyCardRotationView () <CAAnimationDelegate>
{
    NSDictionary *data;//抽奖接口
}
@property (nonatomic, assign)  float angle;//奖品的角度
@property (strong, nonatomic) IBOutlet UIView *contentView;//转盘
@property (nonatomic, strong) NSMutableArray *cellArray;//奖品的视图
@property (weak, nonatomic) IBOutlet UIView *canRotationView;//可旋转的图
@property (nonatomic, strong) CABasicAnimation *animationPart;//动画
@property (weak, nonatomic) IBOutlet UIButton *myBtn;//点击按钮
@property (weak, nonatomic) IBOutlet UIView *winView;//可旋转的中奖View

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
}

-(void)setDataArray:(NSArray<DZPprizeModel *> *)dataArray{
    _dataArray = dataArray;
    self.cellArray = [NSMutableArray arrayWithCapacity:_dataArray.count];
    CGFloat angle = 2 * M_PI / (CGFloat)_dataArray.count;
    for (int i = 0; i < _dataArray.count; i++) {
        DZPprizeModel *model = [_dataArray objectAtIndex:i];
        CGRect cellFrame = CGRectZero;
        cellFrame.origin = CGPointMake(0, 0);
        cellFrame.size = kLuckyCardCellViewSize;
        LYLuckyCardCellView *cellView = [[LYLuckyCardCellView alloc] initWithFrame:cellFrame];
        [cellView.label setText:model.prizeName];
        [cellView.imageView sd_setImageWithURL:[NSURL URLWithString:model.prizeIcon] placeholderImage:[UIImage imageNamed:@"loading"]];
        cellView.layer.anchorPoint = CGPointMake(0.5, 1);
        cellView.layer.position = CGPointMake(self.canRotationView.bounds.size.width / 2.0, self.canRotationView.bounds.size.height / 2.0);
        cellView.transform = CGAffineTransformMakeRotation(angle * i);
        [self.canRotationView addSubview:cellView];
        [self.cellArray addObject:cellView];
    }
    [self setNeedsDisplay];
}

- (IBAction)beginAction:(id)sender {
    [self beignRotaion];
}

//开启动画方法
- (void)beignRotaion {
    [self animationPart1];
}

//动画方法
- (void)animationPart1 {
    [self.winView.layer removeAllAnimations];
    [self.canRotationView.layer removeAllAnimations];
    CABasicAnimation *animationPart1 = [CABasicAnimation animation];
    animationPart1.keyPath = @"transform.rotation";
    //  最初的动画位置
    animationPart1.fromValue = [NSNumber numberWithDouble:0.0];
    //    float f = (7.0-6.0)/7.0;
    //    //  结束的动画位置
    animationPart1.toValue = [NSNumber numberWithDouble:((5) * 2 * M_PI)];
    //    动画间隔时间
    animationPart1.duration= 3.0;
    animationPart1.autoreverses= NO;
    //    动画完成之后是否还原
    animationPart1.removedOnCompletion= NO;
    //    设置代理
    animationPart1.delegate = self;
    animationPart1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]; //由慢变快
    animationPart1.fillMode = kCAFillModeForwards;
    [self.canRotationView.layer addAnimation:animationPart1 forKey:@"beginAnima"];
}
//动画方法
- (void)animationPart :(float )angle{
    
    float bf = 5+angle;//5 表示转5
    self.animationPart = [CABasicAnimation animation];
    _animationPart.keyPath = @"transform.rotation";
    //  最初的动画位置
    _animationPart.fromValue = [NSNumber numberWithDouble:0.0];
    //  结束的动画位置
    _animationPart.toValue = [NSNumber numberWithDouble:bf * 2 * M_PI];
    //    动画间隔时间
    _animationPart.duration= 3.0;
    _animationPart.autoreverses= NO;
    //    动画完成之后是否还原
    _animationPart.removedOnCompletion= NO;
    //     动画的次数
    //    _animationPart1.repeatCount = CGFLOAT_MAX;
    //    设置代理
    _animationPart.delegate = self;
    _animationPart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; //由快变慢
    _animationPart.fillMode = kCAFillModeForwards;
    [self.canRotationView.layer addAnimation:_animationPart forKey:@"animationPart"];
}

//动画方法
- (void)animationWinning {

    [self.winView setHidden:NO];
    [self.winView.layer removeAllAnimations];
    CABasicAnimation *animationWin = [CABasicAnimation animation];
    animationWin.keyPath = @"transform.rotation";
    //  最初的动画位置
    animationWin.fromValue = [NSNumber numberWithDouble:0.0];
    //    //  结束的动画位置
    animationWin.toValue = [NSNumber numberWithDouble:((5) * 2 * M_PI)];
    //    动画间隔时间
    animationWin.duration= 5.0;
    animationWin.autoreverses= NO;
    //    动画完成之后是否还原
    animationWin.removedOnCompletion= NO;
    //    设置代理
    animationWin.delegate = self;
    animationWin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; //线性
    animationWin.fillMode = kCAFillModeForwards;
    [self.winView.layer addAnimation:animationWin forKey:@"animationWin"];
}


#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animationDidStart%@",self.canRotationView.layer.animationKeys);
    NSLog(@"animationDidStart%@",self.winView.layer.animationKeys);
    if ([self.canRotationView.layer.animationKeys[0] isEqualToString:@"beginAnima"]) {
        [self activityTurntableWin];
    }
    else if ([self.winView.layer.animationKeys[0] isEqualToString:@"animationWin"]) {
        
        FastSubViewCode(self);
        subView(@"半透明背景").hidden = NO;
        subLabel(@"奖品").hidden = NO;
        [subLabel(@"奖品") setText:[data objectForKey:@"prizeName"] ];
        subImageView(@"奖品图").hidden = NO;
        [subImageView(@"奖品图") sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"prizeIcon"]]];
        subImageView(@"中奖文字").hidden = NO;
  

        NSNumber * prizeflag = [self->data objectForKey:@"prizeflag"];
        if ([prizeflag isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {//中奖
            subImageView(@"中奖文字").image = [UIImage imageNamed:@"dzp_win"];
        }
        else{
             subImageView(@"中奖文字").image = [UIImage imageNamed:@"dzp_failure"];
        }
         NSNumber * integral = [data objectForKey:@"integral"];
        //发送通知
        NSDictionary *dict = @{@"MoenyNumber":integral};
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"setMoenyNumber" object:nil userInfo:dict]];

    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"animationDidStop%@",self.winView.layer.animationKeys);
    if ([self.canRotationView.layer.animationKeys[0] isEqualToString:@"animationPart"] && flag) {
        NSNumber * prizeId = [data objectForKey:@"prizeId"];
        NSLog(@"奖品id = %@", prizeId );
        NSLog(@"prizeName= %@", [data objectForKey:@"prizeName"] );
        NSLog(@"prizeIcon= %@", [data objectForKey:@"prizeIcon"] );
        [self.canRotationView.layer removeAllAnimations];
        if (self.angle != -1) {
             [self animationWinning];
        }
      
    }
    if ([self.canRotationView.layer.animationKeys[0] isEqualToString:@"beginAnima"]) {

        if (self.angle != -1  && flag) {
            [self animationPart:self.angle];
        }
    }
    if ([self.winView.layer.animationKeys[0] isEqualToString:@"animationWin"]) {
        if (flag) {
              [self performSelector:@selector(winner) withObject:nil/*可传任意类型参数*/ afterDelay:3.0];
        }
      
    }
    
}

-(void)winner{
    FastSubViewCode(self);
    [self.winView.layer removeAllAnimations];
    subView(@"半透明背景").hidden = YES;
    [self.winView setHidden:YES];
    subLabel(@"奖品").hidden = YES;
    subImageView(@"奖品图").hidden = YES;
    subImageView(@"中奖文字").hidden = YES;
    _myBtn.enabled = YES;
    
    
}
#pragma mark -网络请求  抽奖接口
//            prizeflag = 1,
//            integralOld = 39916,
//            prizeAmount = "100",
//            prizeId = 5,
//            prizeType = "2",
//            prizeMsg = "中奖",
//            integral = 40016,
//            prizeIcon = "https://cdn01.kspass.cn/upload/t029/customise/images/158582532987prizeIconNew.jpg?v=1585825329",
//            prizeIconName = "158582532987prizeIconNew",
//            prizeName = "100积分",
- (void)activityTurntableWin {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"activityId":self.DZPid,
    };
    
    WeakSelf;
    //投注记录信息
    _myBtn.enabled = NO;
    [CMNetwork activityTurntableWinWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            self.angle = -1;
            NSInteger code  = model.code;
            self->data =  model.data;
            
            if (code == 0) {
                NSNumber * prizeflag = [self->data objectForKey:@"prizeflag"];
                if ([prizeflag isEqualToNumber:[[NSNumber alloc] initWithInt:1]]) {//中奖
                    NSNumber * prizeId = [self->data objectForKey:@"prizeId"];
                    
                    //计算角度，开启动画
                    for (int i = 0; i < self->_dataArray.count; i++) {
                        DZPprizeModel *model = [weakSelf.dataArray objectAtIndex:i];
                        if ([model.prizeId isEqualToNumber:prizeId ]) {
                            
                            float fcount = (float)weakSelf.dataArray.count;
                            float fi = fcount - i*10/10;
                            float angle = fi/fcount;
                            //角度要如此计算：（count - i）/count
                            self.angle = angle;
                            break;
                        }
                    }
                } else  {//没中奖
                    self->_myBtn.enabled = YES;
                    NSLog(@"没中奖");
                    [self animationWinning];
                }
            }
           
            
        } failure:^(id msg) {
            self->_myBtn.enabled = YES;
            NSLog(@" 网络出错");
            [self.canRotationView.layer removeAllAnimations];
        }];
    }];
}


@end
