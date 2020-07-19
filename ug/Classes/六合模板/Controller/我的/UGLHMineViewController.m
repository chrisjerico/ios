//
//  UGLHMineViewController.m
//  ug
//
//  Created by ug on 2019/11/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHMineViewController.h"
//-----------UIViewController
#import "UGFundsViewController.h"
#import "SLWebViewController.h"
#import "UGPromotionIncomeController.h"
#import "UGAgentViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGBetRecordViewController.h"
#import "UGRealBetRecordViewController.h"
#import "UGMosaicGoldViewController.h"
#import "UGChangLongController.h"
#import "UGSigInCodeViewController.h"
#import "UGMissionCenterViewController.h"
#import "UGPostListVC.h"

//-----------cell
#import "UGMenuTableViewCell.h"
//-----------View
#import "STBarButtonItem.h"
#import "UGYYRightMenuView.h"
#import "WavesView.h"
#import "UGAvaterSelectView.h"
//-----------model
#import "LHUserModel.h"
@interface UGLHMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;/**<   头像*/
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;/**<   刷新按钮*/
@property (weak, nonatomic) IBOutlet UIView *progressView;       /**<   进度条 */
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;       /**<   任务中心 */
@property (weak, nonatomic) IBOutlet UIButton *signButton;       /**<   每日签到 */
@property (strong, nonatomic)UGYYRightMenuView *yymenuView;   /**<   侧边栏 */

@property (weak, nonatomic) IBOutlet UILabel *moneyNameLabel; /**<   咔咔币 */
@property (weak, nonatomic) IBOutlet UILabel *moenyNumberLabel;/**<   咔咔币数量 */
@property (weak, nonatomic) IBOutlet UIView *waveBgView;      /**<   波浪背景 */
@property (weak, nonatomic) IBOutlet UIView *waveBottomView;  /**<   波浪下View */
@property (nonatomic, strong) WavesView *waveView;            /**<   波浪 */

@property (weak, nonatomic) IBOutlet UIImageView *imgBV;      /**<   大V图片*/

@end

@implementation UGLHMineViewController

- (BOOL)允许游客访问 { return true; }


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.waveView startWaveAnimation];
    self.navigationController.navigationBarHidden = false;
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.waveView stopWaveAnimation];
    [self.refreshFirstButton.layer removeAllAnimations];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.refreshFirstButton.selected) {
        [self startAnimation];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //模板
    FastSubViewCode(self.userInfoView)
    [self.userInfoView setBackgroundColor: Skin1.navBarBgColor];
    //将图层的边框设置为圆脚 
    self.userInfoView.layer.cornerRadius = 15;
    self.userInfoView.layer.masksToBounds = YES;
    
    subImageView(@"头像ImgV").layer.cornerRadius = 70 / 2 ;
    subImageView(@"头像ImgV").layer.masksToBounds = YES;
    subImageView(@"头像ImgV").userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvaterSelectView)];
    [subImageView(@"头像ImgV") addGestureRecognizer:tap];
    
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = UGRGBColor(213, 224, 237);
    
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveBottomView.backgroundColor = Skin1.tabBarBgColor;
    self.waveView.realWaveColor = Skin1.tabBarBgColor;
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
    
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    
    __weakSelf_(__self);
    [__self.tableView.dataArray setArray:SysConf.userCenter];
    [__self.tableView reloadData];
    SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
        [__self.tableView.dataArray setArray:SysConf.userCenter];
        [__self.tableView reloadData];
    });
    
//    [self tableCelldataSource];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGMenuTableViewCell"];
    [self.tableView reloadData];
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
        [self.refreshFirstButton.layer removeAllAnimations];
        [self setupUserInfo:NO];
        [self.tableView reloadData];
    });
    SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
        [subImageView(@"头像ImgV") sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    });
    
    [self getUserInfo];
    [self.tableView reloadData];

}


#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    UGUserCenterItem *uci = tableView.dataArray[indexPath.row];
    subLabel(@"标题Label").text = uci.name;
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:uci.logo] placeholderImage:[UIImage imageNamed:uci.lhImgName]];
    subLabel(@"红点Label").text = @([UGUserModel currentUser].unreadMsg).stringValue;
    subLabel(@"红点Label").hidden = !(uci.code==UCI_站内信 && [UGUserModel currentUser].unreadMsg);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UGUserCenterItem *uci = tableView.dataArray[indexPath.row];
    [NavController1 pushVCWithUserCenterItemType:uci.code];
}


#pragma mark - UIS

- (void)setupUserInfo:(BOOL)flag  {
   
    UGUserModel *user = [UGUserModel currentUser];
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    
    if ([config.missionSwitch isEqualToString:@"0"]) {
        [self.taskButton setHidden:NO];
        if ([config.checkinSwitch isEqualToString:@"0"]) {
            [self.signButton setHidden:YES];
        } else {
            [self.signButton setHidden:NO];
        }
    } else {
        [self.taskButton setHidden:YES];
        [self.signButton setHidden:YES];
    }
    FastSubViewCode(self.userInfoView)
    if (flag) {
        [subImageView(@"头像ImgV") sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    }
    subLabel(@"名字Label").text = user.username;
    subLabel(@"用户等级Label").text = user.curLevelGrade;
    subLabel(@"小等级Label").text = user.curLevelGrade;
    subLabel(@"大等级Label").text = user.nextLevelGrade;
    
    subLabel(@"成长值Label").text = _NSString(@"距离下一级还差%@分", _FloatString4(user.nextLevelInt.doubleValue - user.taskRewardTotal.doubleValue));
   
    if (![CMCommon stringIsNull:user.taskRewardTitle]) {
        self.moneyNameLabel.text = user.taskRewardTitle;
    }
    if (![CMCommon stringIsNull:user.taskRewardTotal]) {
        self.moenyNumberLabel.text = _FloatString4(user.taskReward.doubleValue);
    }
    
    double floatString = [user.balance doubleValue];
    subLabel(@"金币Label").text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    //进度条
    double progress = user.taskRewardTotal.doubleValue/user.nextLevelInt.doubleValue;
    self.progressLayer.path = [self progressPathWithProgress:progress].CGPath;
}


#pragma mark -- 网络请求

- (void)getLHUserInfo :(NSString *)uid {
//    return;
//    // 这个网络请求导致必现闪退，排查不到原因，只能先注释掉
//    [SVProgressHUD showWithStatus:nil];
//    [NetworkManager1 lhcdoc_getUserInfo:uid].completionBlock = ^(CCSessionModel *sm) {
//        NSLog(@"sm.responseObject[@data]= %@",sm.responseObject[@"data"]);
//        [SVProgressHUD dismiss];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            // UI更新代码
//            if (!sm.error) {
//                NSLog(@"sm.responseObject[@data]= %@",sm.responseObject[@"data"]);
//                LHUserModel*user = [LHUserModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
//                user.isLhcdocVip ? [self.imgBV setHidden:NO]:[self.imgBV setHidden:YES];
//            }
//            
//            
//        }];
//        
//    };
    
    
    NSDictionary *params = @{@"uid":uid};
    [CMNetwork lhcdocgetUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            LHUserModel*user = model.data;
            
            if (user) {
                UGUserModel *oldUser = [UGUserModel currentUser];
                oldUser.isLhcdocVip = user.isLhcdocVip;
                FastSubViewCode(self.userInfoView)
                oldUser.lhnickname = user.nickname;
                UGUserModel.currentUser = oldUser;
                NSLog(@"是否是六合文档的VIP==%d",user.isLhcdocVip);
                user.isLhcdocVip ? [self.imgBV setHidden:NO]:[self.imgBV setHidden:YES];
            }
            
        } failure:^(id msg) {
//            [self stopAnimation];
        }];
    }];
}

- (void)getUserInfo {
    [self startAnimation];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            NSLog(@"签到==%d",[UGUserModel currentUser].checkinSwitch);
            [self getLHUserInfo:user.userId];
            [self getSystemConfig];
            //初始化数据
//            [self tableCelldataSource];
//            [self.tableView reloadData];
        } failure:^(id msg) {
            [self stopAnimation];
        }];
    }];
}

- (void)getSystemConfig {
    
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            NSLog(@"签到==%@",[UGSystemConfigModel  currentConfig].checkinSwitch);
            [self setupUserInfo:YES];
            [self stopAnimation];
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}
#pragma mark --其他方法
- (void)showAvaterSelectView {
    if (UserI.isTest) {
        return;
    }
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
}
- (void)rightBarBtnClick {
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"1";
    //此处为重点
    WeakSelf;
    self.yymenuView.backToHomeBlock = ^{
        weakSelf.navigationController.tabBarController.selectedIndex = 0;
    };
    [self.yymenuView show];
}

- (IBAction)showMissionVC:(id)sender {
    NSLog(@"任务中心");
    UIViewController *vc = [NavController1.viewControllers objectWithValue:UGMissionCenterViewController.class keyPath:@"class"];
    if (vc) {
        [NavController1 popToViewController:vc animated:false];
    } else {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:false];
    }
}
- (IBAction)showSign:(id)sender {
    NSLog(@"每日签到");
    [self.navigationController pushViewController:[UGSigInCodeViewController new] animated:YES];
}

// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
    
    if (sender) {
        __weakSelf_(__self);
        [CMNetwork needToTransferOutWithParams:@{@"token":UserI.token} completion:^(CMResult<id> *model, NSError *err) {
            BOOL needToTransferOut = [model.data[@"needToTransferOut"] boolValue];
            if (needToTransferOut) {
                UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"真人游戏正在进行或有余额未成功转出，请确认是否需要转出游戏余额" btnTitles:@[@"取消", @"确认"]];
                [ac setActionAtTitle:@"确认" handler:^(UIAlertAction *aa) {
                    [CMNetwork autoTransferOutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                        if (!err) {
                            [SVProgressHUD showSuccessWithStatus:@"转出成功"];
                            [__self getUserInfo];
                        }
                    }];
                }];
            }
        }];
    }
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

- (CAShapeLayer *)containerLayer {
    if (!_containerLayer) {
        _containerLayer = [self defaultLayer];
        CGRect rect = (CGRect){(self.progressView.bounds.size.width-self.progressView.bounds.size.height)/2, 0, self.progressView.bounds.size.height, self.progressView.bounds.size.height};
        _containerLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
    }
    return _containerLayer;
}

- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress {
    if (progress < 0.0001) { return nil; }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = (CGPoint){-5, CGRectGetHeight(self.progressView.frame)/2};
    CGPoint endPoint = (CGPoint){CGRectGetWidth(self.progressView.frame)*progress, startPoint.y};
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    return path;
}

- (CAShapeLayer *)defaultLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor grayColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.progressView.bounds;
    return layer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [self defaultLayer];
        _progressLayer.lineWidth = self.progressView.height;
        _progressLayer.strokeColor = Skin1.progressBgColor.CGColor;
    }
    return _progressLayer;
}


#pragma mark - IBAction

- (IBAction)dynamicAction:(id)sender {
    NSLog(@"我的动态");
    UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
    vc.title = @"我的动态";
    vc.request = ^CCSessionModel * _Nonnull(NSInteger page) {
        if (UserI.isTest) {
            return nil;
        }
        return [NetworkManager1 lhdoc_historyContent:nil  page:page];
    };
    [NavController1 pushViewController:vc animated:true];
}

- (IBAction)depositAction:(id)sender {
    NSLog(@"我的存款");
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 0;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)withdrawalsAction:(id)sender {
    NSLog(@"我的取款");
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 1;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)conversionAction:(id)sender {
    NSLog(@"额度转换");
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController") animated:YES];
}
- (IBAction)interestAction:(id)sender {
    NSLog(@"利息宝");
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
}
- (IBAction)recordAction:(id)sender {
    NSLog(@"充值记录");
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 3;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)withdrawalRecordAction:(id)sender {
    NSLog(@"提现记录");
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 4;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)bettingRecordAction:(id)sender {
    NSLog(@"投注记录");
    [self.navigationController pushViewController:[UGBetRecordViewController new] animated:YES];
}
- (IBAction)customerServiceAction:(id)sender {
    NSLog(@"联系客服");
    [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
}
- (IBAction)lhNickNameAction:(id)sender {

    
    // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
    __block UITextField *tf = nil;
    [LEEAlert alert].config
    .LeeTitle(@"请输入昵称")
    .LeeContent(@"")
    .LeeAddTextField(^(UITextField *textField) {
        textField.placeholder = @"请输入昵称：1-8个汉字";
        textField.textColor = [UIColor darkGrayColor];
        textField.限制长度 = 8;
        UGUserModel *oldUser = [UGUserModel currentUser];
        textField.text = oldUser.lhnickname;
        tf = textField; //赋值
    })
    
    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
    .LeeDestructiveAction(@"好的", ^{
        if (!tf.text.length) {
            return ;
        }
        if (!tf.text.isChinese) {
            [HUDHelper showMsg:@"请输入纯汉字昵称"];
            return;
        }
        [NetworkManager1 lhcdoc_setNickname:tf.text].successBlock = ^(id responseObject) {
            [self getUserInfo];
        };
        
    })
    .leeShouldActionClickClose(^(NSInteger index){
        // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
        // 这里演示了与输入框非空校验结合的例子
        BOOL result = ![tf.text isEqualToString:@""];
        result = index == 1 ? result : YES;
        return result;
    })
    .LeeShow();
    
}

@end
