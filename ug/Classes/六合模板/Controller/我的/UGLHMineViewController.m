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
#import "UGMailBoxTableViewController.h"
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
@interface UGLHMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTabView;
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



@property (nonatomic, strong) NSArray <NSString *> *menuNameArray; /**<   表title  */
@property (nonatomic, strong) NSArray <NSString *> *imageNameArray;/**<   表img  */

@end

@implementation UGLHMineViewController

- (BOOL)允许游客访问 { return true; }


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.waveView startWaveAnimation];
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
    self.progressView.backgroundColor = Skin1.bgColor;
    
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveBottomView.backgroundColor = Skin1.tabBarBgColor;
    self.waveView.realWaveColor = Skin1.tabBarBgColor;
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
    
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    
    [self tableCelldataSource];
    [self.myTabView registerNib:[UINib nibWithNibName:@"UGMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGMenuTableViewCell"];
    [self.myTabView reloadData];
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
        [self.refreshFirstButton.layer removeAllAnimations];
        [self setupUserInfo:NO];
        [self.myTabView reloadData];
    });
    SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
        [subImageView(@"头像ImgV") sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    });
    
    [self getUserInfo];
    [self.myTabView reloadData];

}
#pragma mark table datasource
- (void)tableCelldataSource {

    self.menuNameArray = [NSMutableArray array];
    UGUserModel *user = [UGUserModel currentUser];
    NSLog(@"isAgent= %d",user.isAgent);
    if (user.isAgent) {
        self.menuNameArray = @[@"存款",@"取款",@"在线客服",@"银行卡管理",@"利息宝",@"额度转换",@"推荐收益",@"安全中心",@"站内信",@"彩票注单记录",@"其他注单记录",@"个人信息",@"建议反馈",@"活动彩金"];
        self.imageNameArray = @[@"LH_menu-cz",@"LH_menu-qk",@"LH_menu-message",@"LH_menu-account",@"LH_syb3",@"LH_menu-transfer",@"LH_task",@"LH_menu-password",@"LH_menu-notice",@"LH_menu-rule",@"LH_menu-rule",@"LH_task",@"LH_menu-feedback",@"LH_money"];
    } else {
        self.menuNameArray = @[@"存款",@"取款",@"在线客服",@"银行卡管理",@"利息宝",@"额度转换",@"代理申请",@"安全中心",@"站内信",@"彩票注单记录",@"其他注单记录",@"个人信息",@"建议反馈",@"活动彩金"];
        self.imageNameArray = @[@"LH_menu-cz",@"LH_menu-qk",@"LH_menu-message",@"LH_menu-account",@"LH_syb3",@"LH_menu-transfer",@"LH_task",@"LH_menu-password",@"LH_menu-notice",@"LH_menu-rule",@"LH_menu-rule",@"LH_task",@"LH_menu-feedback",@"LH_money"];
    }
}


#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuNameArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    subLabel(@"标题Label").text = self.menuNameArray[indexPath.row];
    [subImageView(@"图片ImageView") setImage:[UIImage imageNamed:self.imageNameArray[indexPath.row]]];
    if ([subLabel(@"标题Label").text isEqualToString:@"站内信"]) {
        if ([UGUserModel currentUser].unreadMsg) {
            [subLabel(@"红点Label") setHidden:NO];
            subLabel(@"红点Label").text = @([UGUserModel currentUser].unreadMsg).stringValue;
        }
    } else {
        [subLabel(@"红点Label") setHidden:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = self.menuNameArray[indexPath.row];
    if ([title isEqualToString:@"存款"]) {
           UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
           fundsVC.selectIndex = 0;
           [self.navigationController pushViewController:fundsVC animated:YES];
       }
       else if ([title isEqualToString:@"取款"]) {
           UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
           fundsVC.selectIndex = 1;
           [self.navigationController pushViewController:fundsVC animated:YES];
       }
       else if ([title isEqualToString:@"在线客服"]) {
           SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
           webViewVC.urlStr = SysConf.zxkfUrl;
           [self.navigationController pushViewController:webViewVC animated:YES];
       }
       else if ([title isEqualToString:@"银行卡管理"]) {
           [self.navigationController pushViewController:({
               UIViewController *vc = nil;
               UGUserModel *user = [UGUserModel currentUser];
               if (user.hasBankCard) {
                   vc = _LoadVC_from_storyboard_(@"UGBankCardInfoController");
               } else if (user.hasFundPwd) {
                   vc = _LoadVC_from_storyboard_(@"UGBindCardViewController");
               } else {
                   vc = _LoadVC_from_storyboard_(@"UGSetupPayPwdController");
               }
               vc;
           }) animated:YES];
       }
       else if ([title isEqualToString:@"利息宝"]) {
           [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
       }
       else if ([title isEqualToString:@"额度转换"]) {
           [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
       }
       else if ([title isEqualToString:@"代理申请"] || [title isEqualToString:@"推荐收益"]) {
           if (UserI.isTest) {
               [self.navigationController pushViewController:[UGPromotionIncomeController new] animated:YES];
           } else {
               [SVProgressHUD showWithStatus:nil];
               [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                   [CMResult processWithResult:model success:^{
                       [SVProgressHUD dismiss];
                       UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                       int intStatus = obj.reviewStatus.intValue;
                       
                       //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                       if (intStatus == 2) {
                           [self.navigationController pushViewController:[UGPromotionIncomeController new] animated:YES];
                       } else {
                           if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                               [HUDHelper showMsg:@"在线注册代理已关闭"];
                               return ;
                           }
                           UGAgentViewController *vc = [[UGAgentViewController alloc] init];
                           vc.item = obj;
                           [NavController1 pushViewController:vc animated:YES];
                       }
                   } failure:^(id msg) {
                       [SVProgressHUD showErrorWithStatus:msg];
                   }];
               }];
           }
       }
       else if ([title isEqualToString:@"安全中心"]) {
           [self.navigationController pushViewController:[UGSecurityCenterViewController new] animated:YES];
       } else if ([title isEqualToString:@"站内信"]) {
           [self.navigationController pushViewController:[[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
       } else if([title isEqualToString:@"彩票注单记录"]) {
           [self.navigationController pushViewController:[UGBetRecordViewController new] animated:YES];
       } else if ([title isEqualToString:@"其他注单记录"]) {
           UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
           betRecordVC.gameType = @"real";
           [self.navigationController pushViewController:betRecordVC animated:YES];
       } else if ([title isEqualToString:@"个人信息"]) {
           [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGUserInfoViewController") animated:YES];
       }
       else if ([title isEqualToString:@"建议反馈"]) {
           [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGFeedBackController") animated:YES];
       }
       else if ([title isEqualToString:@"活动彩金"]) {
           [self.navigationController pushViewController:[UGMosaicGoldViewController new] animated:YES];
       }
       else if ([title isEqualToString:@"长龙助手"]) {
           [self.navigationController pushViewController:[UGChangLongController new] animated:YES];
       }
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
            
            [self getSystemConfig];
            //初始化数据
            [self tableCelldataSource];
            [self.myTabView reloadData];
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



- (IBAction)dynamicAction:(id)sender {
    NSLog(@"我的动态");
    
    UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
    vc.title = @"我的动态";
    vc.request = ^CCSessionModel * _Nonnull(NSInteger page) {
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
    SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    
    if (config.zxkfUrl.length > 0) {
        webViewVC.urlStr = config.zxkfUrl;
    } else {
        [SVProgressHUD showErrorWithStatus:@"链接未配置"];
        return;
    }
    [self.navigationController pushViewController:webViewVC animated:YES];
}

@end
