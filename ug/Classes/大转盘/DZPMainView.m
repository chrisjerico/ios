//
//  DZPMainView.m
//  UGBWApp
//
//  Created by ug on 2020/4/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "DZPMainView.h"
#import "LYLuckyCardRotationView.h"
#import "FLAnimatedImageView.h"
#import "DZPTwoView.h"
#import "DZPOneView.h"
#import "FLAnimatedImageView.h"
#import "DZPModel.h"
#import "SGBrowserView.h"
@interface DZPMainView ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgGif;//转盘头部gif
@property (weak, nonatomic) IBOutlet LYLuckyCardRotationView *mDZPView;//转盘
@property (weak, nonatomic) IBOutlet UIImageView *btnBgImgV;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (strong, nonatomic)  DZPTwoView *twoView;
@property (strong, nonatomic)  DZPOneView *oneView;

@property (nonatomic, strong) NSArray <DZPModel *> *dzpArray;   /**<   转盘活动数据 */
@property (weak, nonatomic) IBOutlet UILabel *moenyNumberLabel; /**<   用户积分 */

@end

@implementation DZPMainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        DZPMainView *v = [[DZPMainView alloc] initWithFrame:CGRectZero];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        

    }
    return self;
}


- (instancetype)DZPMainView {

//    NSArray *objs= [[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil];
    // 按屏幕比例缩放（因为等比例约束太复杂，所以直接缩放得了）
//    CGFloat scale = APP.Width/414;
//    self.transform = CGAffineTransformMakeScale(scale, scale);
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"DZPMainView" owner:nil options:nil];

    return [objs firstObject];
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [self DZPMainView];
        

        _imgGif.contentMode = UIViewContentModeScaleAspectFit;
        [_imgGif sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"ztlight" withExtension:@"gif"]];
        _oneView = [[DZPOneView alloc] initWithFrame:CGRectZero];
        _twoView = [[DZPTwoView alloc] initWithFrame:CGRectZero];
        [_contentView addSubview:_oneView];
        [_oneView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(_contentView);
         }];
        UGUserModel *user = [UGUserModel currentUser];
        if (![CMCommon stringIsNull:user.taskRewardTotal]) {
            self.moenyNumberLabel.text = [NSString stringWithFormat:@"剩余积分：%@",_FloatString4(user.taskReward.doubleValue)];
        }
        else{
            self.moenyNumberLabel.text = @"剩余积分：0";
        }
        //注册通知：
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setMoenyNumber:) name:@"setMoenyNumber" object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setDZPStar:) name:@"setDZPStar" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setDZPEnd:) name:@"setDZPEnd" object:nil];
       
    }
    return self;
}



- (IBAction)leftAction:(id)sender {
    [_btnBgImgV setImage:[UIImage imageNamed:@"seg_leftSelected"]];
    
    [_contentView removeAllSubviews];
    [_contentView addSubview:_oneView];
    [_oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView);
    }];
    
}
- (IBAction)rightAciton:(id)sender {
    [_btnBgImgV setImage:[UIImage imageNamed:@"seg_rightSelected"]];
    [_contentView removeAllSubviews];
    
    
    [_contentView addSubview:_twoView];
    [_twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView);
    }];
}


- (void)hiddenSelf {

//    [view.superview removeFromSuperview];
//    [self  removeFromSuperview];
    [SGBrowserView hide];
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}




-(void)setItem:(DZPModel *)item{
    
    [[Global getInstanse] setDZPid:item.DZPid];
    [self activityTurntableLog:item.DZPid];
    self.oneView.dataArray = item.param.content_turntable;
    self.mDZPView.DZPid = item.DZPid;
    self.mDZPView.dataArray =  [DZPprizeModel mj_objectArrayWithKeyValuesArray:item.param.prizeArr];
    
    self.mDZPView.chassis_img = item.param.chassis_img;
}


//大转盘
- (void)activityTurntableLog :(NSString *)pzdid{
 
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"activityId":pzdid,
    };
    [CMNetwork activityTurntableLogWithParams:params completion:^(CMResult<id> *model, NSError *err) {

        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                 NSArray * dataArray = (NSArray *)model.data;

                if ( dataArray.count) {

                   NSMutableArray *data =  [DZPModel mj_objectArrayWithKeyValuesArray:dataArray];

                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // 需要在主线程执行的代码
                         self.twoView.dataArray =  data;
                    });
    
                }

            });
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];

        }];
    }];
}

//实现监听方法
-(void)setMoenyNumber:(NSNotification *)notification
{
    NSNumber *moenyNumber = notification.userInfo[@"MoenyNumber"];//1316
    NSString *moenyNumberStr = [NSString stringWithFormat:@"%@",moenyNumber];
    if (![CMCommon stringIsNull:moenyNumberStr]) {
        self.moenyNumberLabel.text = [NSString stringWithFormat:@"剩余积分：%@",_FloatString4(moenyNumberStr.doubleValue)];
    }
    else{
        self.moenyNumberLabel.text = @"剩余积分：0";
    }
    self.moenyNumberLabel.text = [NSString stringWithFormat:@"剩余积分：%@",moenyNumber];
    [self activityTurntableLog:[Global getInstanse].DZPid];
 }

-(void)setDZPStar:(NSNotification *)notification
{
    [_imgGif sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"ztlight2" withExtension:@"gif"]];
    
}
-(void)setDZPEnd:(NSNotification *)notification
{
    [_imgGif sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"ztlight" withExtension:@"gif"]];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setMoenyNumber" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setDZPStar" object:self];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setDZPEnd" object:self];
}
@end
