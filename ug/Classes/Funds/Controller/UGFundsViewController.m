//
//  UGFoundsViewController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundsViewController.h"
#import "XYYSegmentControl.h"
#import "UGRechargeTypeTableViewController.h"
#import "UGWithdrawalViewController.h"
#import "UGRechargeRecordTableViewController.h"
#import "UGFundDetailsTableViewController.h"
#import "UGBMHeaderView.h"
#import "HMSegmentedControl.h"

@interface XYYSegmentControl ()
@property (nonatomic, strong) HMSegmentedControl *hmSegmentedControl;
@end

@interface UGFundsViewController ()<XYYSegmentControlDelegate>{
         UGBMHeaderView *headView;                /**<   GPK版导航头 */
}

@property (nonatomic, strong)UGRechargeRecordTableViewController *rechargeRecordVC;
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSArray <NSString *> *itemArray;
//===================================================
@property (weak, nonatomic) IBOutlet UIView *mheadView; /**<    头 */
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;    /**<    刷新按钮 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;/**<    昵称 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;   /**<    余额 */
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;/**<    真实名 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@end

@implementation UGFundsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)skin {
     [self buildSegment];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.navigationItem.title = self.navigationController.tabBarItem.title ? self.navigationController.tabBarItem.title : @"资金管理";
    
    if (!self.title) {
        self.title =  @"资金管理";
    }
	
	if (CHAT_TARGET) {
		self.headerHeight.constant = 0;
	}
    
    self.fd_prefersNavigationBarHidden = Skin1.isBlack;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    [_mheadView setBackgroundColor:Skin1.navBarBgColor];
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
    self.headImageView.layer.masksToBounds = YES;
    
    [self getUserInfo];
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
         [self setupUserInfo];
     });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (Skin1.isGPK) {
//        [self.navigationController setNavigationBarHidden:YES];//强制隐藏NavBar
//        [headView.leftwardMarqueeView start];
        [self.navigationController setNavigationBarHidden:NO];//不NavBar
        [self.view setBackgroundColor:Skin1.navBarBgColor];
    } else {
        [self.navigationController setNavigationBarHidden:NO];//不NavBar
    }
    
    
    if (OBJOnceToken(self)) {
        [self buildSegment];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [headView.leftwardMarqueeView pause];//fixbug  发热  掉电快
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.slideSwitchView changeSlideAtSegmentIndex:self.selectIndex];
}


#pragma mark - 配置segment
-(void)creatView{
    //===============导航头布局=================
       headView = [[UGBMHeaderView alloc] initView];
       [self.view addSubview:headView];
       [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
           make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
           make.left.equalTo(self.view.mas_left).offset(0);
           make.height.equalTo([NSNumber numberWithFloat:110]);
           make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
       }];
}
- (void)buildSegment
{
    SANotificationEventSubscribe(UGNotificationDepositSuccessfully, self, ^(typeof (self) self, id obj) {
        [self.slideSwitchView changeSlideAtSegmentIndex:2];
    });
    

    
    self.itemArray = @[@"存款",@"取款",@"存款记录",@"取款记录",@"资金明细"];
    if (Skin1.isGPK) {


//        [self.mheadView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headView.mas_bottom);
//            make.left.equalTo(self.view.mas_left).offset(0);
//            make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
//              make.height.mas_equalTo(130);
//        }];

         self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , headView.frame.size.height+headView.frame.origin.y, self.view.width, self.view.height) channelName:self.itemArray source:self];
        self.slideSwitchView.hmSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        self.slideSwitchView.hmSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self.view addSubview:self.slideSwitchView];
        [self.slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    } else {
        
        [self.mheadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.view);
            make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
            make.height.mas_equalTo(130);
        }];
        
        self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
        self.slideSwitchView.hmSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        self.slideSwitchView.hmSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self.view addSubview:self.slideSwitchView];
        
        [self.slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mheadView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
  
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor2;
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = Skin1.textColor1;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.textColor4;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.textColor1;
	if (CHAT_TARGET) {
		self.slideSwitchView.tabItemSelectedColor = RGBA(0x74, 0x94, 0xff, 1);
		self.slideSwitchView.tabItemSelectionIndicatorColor = RGBA(0x74, 0x94, 0xff, 1);
		self.slideSwitchView.tabSelectionStyle = XYYSegmentedControlSelectionStyleFullWidthStripe;
		
	}
}


#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    // 存款
    if (number == 0) {
        UGRechargeTypeTableViewController *rechargeVC = [[UGRechargeTypeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        return rechargeVC;
    }
    // 取款
    else if (number == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGWithdrawalViewController" bundle:nil];
        UGWithdrawalViewController *withdrawalVC = [storyboard instantiateInitialViewController];
        WeakSelf
        withdrawalVC.withdrawSuccessBlock = ^{
            weakSelf.selectIndex = 3;
            [weakSelf.slideSwitchView changeSlideAtSegmentIndex:weakSelf.selectIndex];
        };
        return withdrawalVC;
    }
    // 存款记录
    else if (number == 2) {
        if (! self.rechargeRecordVC) {
            self.rechargeRecordVC =  _LoadVC_from_storyboard_(@"UGRechargeRecordTableViewController");
            self.rechargeRecordVC.recordType = RecordTypeRecharge;
        }
        return self.rechargeRecordVC;
    }
    // 取款记录
    else if (number == 3) {
        UGRechargeRecordTableViewController *rechargeRecordVC = _LoadVC_from_storyboard_(@"UGRechargeRecordTableViewController");
        rechargeRecordVC.recordType = RecordTypeWithdraw;
        return rechargeRecordVC;
    }
    // 资金明细
    else {
        UGFundDetailsTableViewController *detailsVC = _LoadVC_from_storyboard_(@"UGFundDetailsTableViewController");
        return detailsVC;
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    if (number != 1)
        SANotificationEventPost(UGNotificationFundTitlesTap, nil);
    
    if (number == 2) {
        SANotificationEventPost(UGNotificationWithRecordOfDeposit, nil);
    }
	
	if (CHAT_TARGET) {
		self.navigationItem.title = self.itemArray[number];
	}
    
}

#pragma mark -- 网络请求
// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
}
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
            [weakSelf stopAnimation];
            [weakSelf setupUserInfo];
        } failure:^(id msg) {
            [self stopAnimation];
        }];
    }];
}

//刷新余额动画
- (void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshFirstButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

//刷新余额动画
- (void)stopAnimation {
    [self.refreshFirstButton.layer removeAllAnimations];
}

#pragma mark - UIS
- (void)setupUserInfo {
    
    UGUserModel *user = [UGUserModel currentUser];
    NSLog(@"user.avatar = %@",user.avatar);

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    self.userNameLabel.text = user.username;
    self.moneyLabel.text =  UGUserModel.currentUser.balance;
    
    [self.realNameLabel setHidden:YES];
    if (![CMCommon stringIsNull:user.fullName]) {
        self.realNameLabel.text = user.fullName;
    }
    else{
        self.realNameLabel.text = @"";
    }
    

}


@end

