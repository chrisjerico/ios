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

@property (weak, nonatomic) IBOutlet UIView *canRotationView;//可旋转的图

@property (nonatomic, strong) CABasicAnimation *animationPart;//动画



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
//    self.cellArray = [NSMutableArray arrayWithCapacity:kLuckyCardCellCount];
//    CGFloat angle = 2 * M_PI / (CGFloat)kLuckyCardCellCount;
//    for (int i = 0; i < kLuckyCardCellCount; i++) {
//        CGRect cellFrame = CGRectZero;
//        cellFrame.origin = CGPointMake(0, 0);
//        cellFrame.size = kLuckyCardCellViewSize;
//        LYLuckyCardCellView *cellView = [[LYLuckyCardCellView alloc] initWithFrame:cellFrame];
//        [cellView configCell:i + 1];
//        cellView.imageView.image = [UIImage imageNamed:@"dzp_Icon"];
//        cellView.layer.anchorPoint = CGPointMake(0.5, 1);
//        cellView.layer.position = CGPointMake(self.canRotationView.bounds.size.width / 2.0, self.canRotationView.bounds.size.height / 2.0);
//        cellView.transform = CGAffineTransformMakeRotation(angle * i);
//        [self.canRotationView addSubview:cellView];
//        [self.cellArray addObject:cellView];
//    }
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
    NSInteger index = random() % _dataArray.count;
    LYLuckyCardCellView *cellView = self.cellArray[index];
    CGFloat angle = atan2(cellView.transform.b, cellView.transform.a);
    self.canRotationView.transform = CGAffineTransformMakeRotation(-angle);

    [self animationPart1];

}

//动画方法
- (void)animationPart1 {
    
    [self.canRotationView.layer removeAllAnimations];
    
    CABasicAnimation *animationPart1 = [CABasicAnimation animation];
     animationPart1.keyPath = @"transform.rotation";
    //  最初的动画位置
//        animationPart1.fromValue = [NSNumber numberWithDouble:1.0];
//    //  结束的动画位置
//        animationPart1.toValue = [NSNumber numberWithDouble:0.0];
//    animationPart1.byValue = @(randomInt * 2 * M_PI);
       animationPart1.byValue = @(5 * 2 * M_PI);
    //    动画间隔时间
        animationPart1.duration= 3.0;
        animationPart1.autoreverses= NO;
    //    动画完成之后是否还原
        animationPart1.removedOnCompletion= NO;
    //     动画的次数      FLT_MAX=="forever"
//    _animationPart1.repeatCount = CGFLOAT_MAX;
    //    设置代理
        animationPart1.delegate = self;
    
    animationPart1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]; //由慢变快
    animationPart1.fillMode = kCAFillModeForwards;
    animationPart1.tagString = @"开始动画";

    [self.canRotationView.layer addAnimation:animationPart1 forKey:@"animationPart1"];
    
    NSLog(@"");
}
//动画方法
- (void)animationPart :(float )angle{

    self.animationPart = [CABasicAnimation animation];
    _animationPart.keyPath = @"transform.rotation";
    //  最初的动画位置
        _animationPart.fromValue = [NSNumber numberWithDouble:0.0];
    //  结束的动画位置
        _animationPart.toValue = [NSNumber numberWithDouble:angle];
//    animationPart1.byValue = @(randomInt * 2 * M_PI);
//    _animationPart1.byValue = @(2.25 * 2 * M_PI);
    //    动画间隔时间
        _animationPart.duration= 3.0;
        _animationPart.autoreverses= NO;
    //    动画完成之后是否还原
        _animationPart.removedOnCompletion= NO;
    //     动画的次数      FLT_MAX=="forever"
//    _animationPart1.repeatCount = CGFLOAT_MAX;
    //    设置代理
        _animationPart.delegate = self;

    _animationPart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; //由快变慢
    _animationPart.fillMode = kCAFillModeForwards;




    [self.canRotationView.layer addAnimation:_animationPart forKey:@"animationPart"];

    NSLog(@"");
}

#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart%@",self.layer.animationKeys);
 
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"animationDidStop%@",self.layer.animationKeys);

    if (anim==[self.layer animationForKey:@"animationPart"]) {
        NSLog(@"提示中奖");
        

    }

}

#pragma mark -网络请求
//"prizeId": 2,  奖品id
//  "prizeIcon": "https://cdn01.asqmena.com/upload/t028/customise/images/157976179284prizeIconNew.jpg?v=1579761792", 奖品图标
//  "prizeIconName": "157976179284prizeIconNew", 图标名字
//  "prizeName": "3",奖品名称
//  "prizeType": "4",奖品类型 参考后台 1为彩金 2为积分 3为其他 4为 未中奖
//  "prizeAmount": "0",中奖数值
//  "prizeMsg": "未中奖", 信息
//  "prizeflag": 0, 是否中奖标识 0为未中奖 1为中奖
//  "integralOld": 3708, 抽奖前积分
//  "integral": 3708 抽奖后积分（算上中奖的）
- (void)loadData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }

    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"activityId":self.DZPid,
                             
    };

    WeakSelf;
    //投注记录信息
    [CMNetwork activityTurntableWinWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
           
            NSDictionary *data =  model.data;
           DZPprizeModel *obj = [DZPprizeModel mj_setKeyValues:data];
            if (obj.prizeflag == 1) {//中奖

                NSLog(@"奖品id = %@", obj.prizeId );
                //计算角度，开启动画
                for (int i = 0; i < self->_dataArray.count; i++) {
                     DZPprizeModel *model = [weakSelf.dataArray objectAtIndex:i];
                    if ([model.prizeId isEqualToString:obj.prizeId ]) {
                    
                        float angle = i/weakSelf.dataArray.count;
                        
                        [self animationPart:angle];
                        
                        break;
                    }
                }
                
                
            } else  if (obj.prizeflag == 0) {//没中奖
                           
            }
            
            
            

        } failure:^(id msg) {
            
        }];
    }];
}


@end
