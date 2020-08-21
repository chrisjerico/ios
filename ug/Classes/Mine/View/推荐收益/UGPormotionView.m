//
//  UGPormotionView.m
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPormotionView.h"
#import "WavesView.h"

@interface UGPormotionView ()
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshBalanceButton;

@property (weak, nonatomic) IBOutlet UIView *waveBgView;
@property (weak, nonatomic) IBOutlet UIView *waveBottomView;

@property (nonatomic, strong) WavesView *waveView;

@end
@implementation UGPormotionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGPormotionView" owner:self options:0].firstObject;
        self.frame = frame;
        
       
        self.avaterImageView.layer.cornerRadius = self.avaterImageView.height / 2 ;
        self.avaterImageView.layer.masksToBounds = YES;
        self.avaterImageView.userInteractionEnabled = YES;
        [self setBackgroundColor: Skin1.navBarBgColor];

        [self setupUserInfo];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新 神马的
            [self waveAnimation];
        });

    }
    return self;
}

- (void)waveAnimation {
    [self.waveBottomView  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.mas_left).with.offset(0);
         make.right.equalTo(self.mas_right).with.offset(0);
         make.width.equalTo(self.mas_width);
         make.height.mas_equalTo(20.0);
         make.bottom.equalTo(self.mas_bottom);
     }];
    
    [self.waveBgView  mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.mas_left).with.offset(0);
         make.right.equalTo(self.mas_right).with.offset(0);
         make.width.equalTo(self.mas_width);
         make.height.mas_equalTo(20.0);
         make.bottom.equalTo(self.mas_bottom).offset(-20);
         
     }];
    
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveBottomView.backgroundColor =  Skin1.navBarBgColor;
    self.waveView.realWaveColor =  Skin1.navBarBgColor;
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
    [self.waveView startWaveAnimation];
}

//刷新余额动画
- (void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshBalanceButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
    
}

//刷新余额动画
- (void)stopAnimation {
    [self.refreshBalanceButton.layer removeAllAnimations];
}


#pragma mark - UIS

- (void)setupUserInfo {
    UGUserModel *user = [UGUserModel currentUser];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];

    self.userNameLabel.text = user.username;
    
    double floatString = [user.balance doubleValue];
    self.balanceLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
  
}


#pragma mark -- 网络请求

- (void)getUserInfo {
    [self startAnimation];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf;
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            [weakSelf setupUserInfo];
            
            [weakSelf stopAnimation];
            
            
           
            
        } failure:^(id msg) {
            
            [self stopAnimation];
            
        }];
    }];
}


#pragma mark -- 其他方法

- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
}

@end
