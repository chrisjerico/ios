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
@interface DZPMainView ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgGif;//转盘头部gif
@property (weak, nonatomic) IBOutlet LYLuckyCardRotationView *mDZPView;//转盘
@property (weak, nonatomic) IBOutlet UIImageView *btnBgImgV;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic)  DZPTwoView *twoView;
@property (strong, nonatomic)  DZPOneView *oneView;

@property (nonatomic, strong) NSArray <DZPModel *> *dzpArray;   /**<   转盘活动数据 */

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

    NSArray *objs= [[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil];
    // 按屏幕比例缩放（因为等比例约束太复杂，所以直接缩放得了）
//    CGFloat scale = APP.Width/414;
//    self.transform = CGAffineTransformMakeScale(scale, scale);
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
    [self  removeFromSuperview];
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}




-(void)setItem:(DZPModel *)item{
    [self activityTurntableLog:item.DZPid];
    self.oneView.dataArray = item.param.content_turntable;
    self.mDZPView.DZPid = item.DZPid;
    self.mDZPView.dataArray =  [DZPprizeModel mj_objectArrayWithKeyValuesArray:item.param.prizeArr];
   
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



@end
