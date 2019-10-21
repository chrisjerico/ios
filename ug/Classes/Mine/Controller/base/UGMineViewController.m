//
//  UGMineViewController.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMineViewController.h"
#import "UGMineMenuCollectionViewCell.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGMissionCenterViewController.h"
#import "SLWebViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGBalanceConversionController.h"
#import "CMCommon.h"
#import "UGPromotionIncomeController.h"
#import "UGBindCardViewController.h"
#import "UGUserInfoViewController.h"
#import "UGAvaterSelectView.h"
#import "UGBankCardInfoController.h"
#import "UGSetupPayPwdController.h"
#import "UGYubaoViewController.h"
#import "WavesView.h"
#import "UGMenuTableViewCell.h"
#import "UGUserLevelModel.h"
#import "UGFeedBackController.h"
#import "QDWebViewController.h"
#import "UGMailBoxTableViewController.h"
#import "UGBetRecordTableViewController.h"
#import "UGRealBetRecordViewController.h"
#import "UGSystemConfigModel.h"

#import "UGSigInCodeViewController.h"
#import "UGAgentViewController.h"
#import "UGMosaicGoldViewController.h"
#import "UGSystemConfigModel.h"
#import "STBarButtonItem.h"
#import "UGYYRightMenuView.h"
#import "UGLotteryRecordController.h"
#import "UGAllNextIssueListModel.h"
#import "UGChangLongController.h"
#import "UGagentApplyInfo.h"
#import "UGAgentViewController.h"


#import "UGMineMenuCollectionViewCell.h"

@interface UGMineViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskRewardTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *curLevleGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelIntLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImager;




@property (weak, nonatomic) IBOutlet UILabel *taskRewradTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskRewardTotalLabel;

@property (weak, nonatomic) IBOutlet UIButton *taskButton;

@property (weak, nonatomic) IBOutlet UIImageView *curLevelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextLevelImageView;
@property (weak, nonatomic) IBOutlet UILabel *curLevel1Label;
@property (weak, nonatomic) IBOutlet UILabel *nextLevel2Label;



@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *waveBgView;
@property (weak, nonatomic) IBOutlet UIView *waveBottomView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *balanceBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) WavesView *waveView;
@property (nonatomic, strong) NSArray *imageNameArray;
@property (nonatomic, strong) NSArray *menuNameArray;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (weak, nonatomic) IBOutlet UIButton *signButton;

@property (nonatomic, strong) NSArray *lotteryGamesArray;

//====================================
@property (nonatomic, strong) UICollectionView *mcollectionView;


@end

static  NSString *menuCollectionViewCellid = @"UGMineMenuCollectionViewCell";
static NSString *menuTabelViewCellid = @"UGMenuTableViewCell";
@implementation UGMineViewController



-(void)menuNameArrayDate{
    UGUserModel *user = [UGUserModel currentUser];
    NSLog(@"isAgent= %d",user.isAgent);
    if (user.isAgent) {
        self.menuNameArray = @[@"存款",@"取款",@"在线客服",@"银行卡管理",@"利息宝",@"额度转换",@"推荐收益",@"安全中心",@"站内信",@"彩票注单记录",@"其他注单记录",@"个人信息",@"建议反馈",@"活动彩金"];
        self.imageNameArray = @[@"chongzhi",@"tixian",@"zaixiankefu",@"yinhangqia",@"lixibao",@"change",@"shouyi",@"ziyuan",@"zhanneixin",@"zdgl",@"zdgl",@"huiyuanxinxi",@"jianyi",@"zdgl"];
    } else {
        self.menuNameArray = @[@"存款",@"取款",@"在线客服",@"银行卡管理",@"利息宝",@"额度转换",@"代理申请",@"安全中心",@"站内信",@"彩票注单记录",@"其他注单记录",@"个人信息",@"建议反馈",@"活动彩金"];
        self.imageNameArray = @[@"chongzhi",@"tixian",@"zaixiankefu",@"yinhangqia",@"lixibao",@"change",@"shouyi",@"ziyuan",@"zhanneixin",@"zdgl",@"zdgl",@"huiyuanxinxi",@"jianyi",@"zdgl"];
    }
    [self.tableView reloadData];
}

-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    [self.userInfoView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
    
   [self.tableView reloadData];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    [self.userInfoView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
    
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    
    
    SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
    });
    
    self.navigationItem.title = @"我的";
    self.userInfoView.backgroundColor = [[UGSkinManagers shareInstance] setbgColor];
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.height / 2 ;
    self.avaterImageView.layer.masksToBounds = YES;
    self.view.backgroundColor = [[UGSkinManagers shareInstance] setbgColor];
    self.avaterImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvaterSelectView)];
    [self.avaterImageView addGestureRecognizer:tap];

    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMenuTableViewCell" bundle:nil] forCellReuseIdentifier:menuTabelViewCellid];
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = [[UGSkinManagers shareInstance] setbgColor];
    
   
    
    [self menuNameArrayDate];
    
   
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveBottomView.backgroundColor = [[UGSkinManagers shareInstance] setTabbgColor];
    self.waveView.realWaveColor = [[UGSkinManagers shareInstance] setTabbgColor];
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
   
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
        [self.refreshButton.layer removeAllAnimations];
        [self setupUserInfo:NO];
        [self.tableView reloadData];
    });
    SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    });
//    [self setUserInfoWithHeaderImg:YES];
    [self getAllNextIssueData];
    [self getUserInfo];
    [self.tableView reloadData];
    
//    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];

}





- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.waveView startWaveAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.waveView stopWaveAnimation];
    [self.refreshButton.layer removeAllAnimations];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.refreshButton.selected) {
        [self startAnimation];
        
    }
}

- (void)showAvaterSelectView {
    if (UserI.isTest) {
        return;
    }
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
}

- (IBAction)showMissionVC:(id)sender {
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:YES];
}
- (IBAction)showSign:(id)sender {
    [self.navigationController pushViewController:[UGSigInCodeViewController new] animated:YES];
}

- (IBAction)refreshBalance:(id)sender {
//    SANotificationEventPost(UGNotificationGetUserInfo, nil);
    [self getUserInfo];
    [self getAllNextIssueData];
}

#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuNameArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuTabelViewCellid forIndexPath:indexPath];
    cell.title = self.menuNameArray[indexPath.row];
    cell.imgName = self.imageNameArray[indexPath.row];
    cell.unreadMsg = [UGUserModel currentUser].unreadMsg;
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
    } else if ([title isEqualToString:@"取款"]) {
        UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
        fundsVC.selectIndex = 1;
        [self.navigationController pushViewController:fundsVC animated:YES];
    } else if ([title isEqualToString:@"在线客服"]) {
        SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
      
		if (config.zxkfUrl.length > 0) {
			webViewVC.urlStr = config.zxkfUrl;
		} else {
//			[SVProgressHUD showErrorWithStatus:@"链接未配置"];
			return;
		}
        [self.navigationController pushViewController:webViewVC animated:YES];
       
    } else if ([title isEqualToString:@"银行卡管理"]) {
        if (UserI.hasBankCard) {
            [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBankCardInfoController") animated:YES];
        } else {
            if (UserI.hasFundPwd) {
                [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBindCardViewController") animated:YES];
            } else {
                [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGSetupPayPwdController") animated:YES];
            }
        }
    } else if ([title isEqualToString:@"利息宝"]){
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
    } else if ([title isEqualToString:@"额度转换"]){
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
    } else if ([title isEqualToString:@"推荐收益"]) {
        [self.navigationController pushViewController:[UGPromotionIncomeController new] animated:YES];
    } else if ([title isEqualToString:@"代理申请"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        } else {
            UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
            if ([config.agent_m_apply isEqualToString:@"1"]) {
                //调接口
                [self teamAgentApplyInfoWithParams];
            } else {
                [self.navigationController.view makeToast:@"在线注册代理已关闭" duration:1.5 position:CSToastPositionCenter];
            }
        }
    } else if ([title isEqualToString:@"安全中心"]) {
        [self.navigationController pushViewController:[UGSecurityCenterViewController new] animated:YES];
    } else if ([title isEqualToString:@"站内信"]) {
        [self.navigationController pushViewController:[UGMailBoxTableViewController new] animated:YES];
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
}

//刷新余额动画
-(void)startAnimation
{
    
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
    
}

//刷新余额动画
-(void)stopAnimation
{
    
    [self.refreshButton.layer removeAllAnimations];
    
}


- (CAShapeLayer *)containerLayer
{
    if (!_containerLayer) {
        _containerLayer = [self defaultLayer];
        CGRect rect = (CGRect){(self.progressView.bounds.size.width-self.progressView.bounds.size.height)/2,0,self.progressView.bounds.size.height,self.progressView.bounds.size.height};
        _containerLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
    }
    return _containerLayer;
}

- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = (CGPoint){0,CGRectGetHeight(self.progressView.frame)/2};
    CGPoint endPoint = (CGPoint){CGRectGetWidth(self.progressView.frame)*progress,startPoint.y};
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    return path;
    
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [self defaultLayer];
        _progressLayer.lineWidth = self.progressView.height;
        _progressLayer.strokeColor = UGRGBColor(95, 190, 249).CGColor;
    }
    return _progressLayer;
}

- (CAShapeLayer *)defaultLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor grayColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.progressView.bounds;
    return layer;
}




#pragma mark - UIS
- (void)setupUserInfo:(BOOL)flag  {
    UGUserModel *user = [UGUserModel currentUser];
    
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if ([config.checkinSwitch isEqualToString:@"0"]) {
        [self.signButton setHidden:YES];
    } else {
        [self.signButton setHidden:NO];
    }
    
    

    if ([config.missionSwitch isEqualToString:@"0"]) {
        [self.taskButton setHidden:NO];
    } else {
        [self.taskButton setHidden:YES];
    }
    
    
    if (flag) {
        
                [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"txp"]];
            }
   
    self.userNameLabel.text = user.username;
    self.levelNameLabel.text = user.curLevelGrade;
    
    NSString *imagerStr = [user.curLevelGrade lowercaseString];
    NSLog(@"imagerStr = %@",imagerStr);
    
    if (![CMCommon stringIsNull:user.curLevelGrade] && user.curLevelGrade.length>4) {
        NSString *subStr = [user.curLevelGrade substringFromIndex:3];
        
        int levelsInt = [subStr intValue];
        NSString *imgStr = @"";
        if (levelsInt <11) {
            imgStr = [NSString stringWithFormat:@"vip%d",levelsInt];
        } else {
            imgStr = @"vip11";
        }
        
        [self.vipImager setImage: [UIImage imageNamed:imgStr]];
        
        NSString *img2Str = @"";
        if (levelsInt <11) {
            img2Str = [NSString stringWithFormat:@"grade_%d",levelsInt];
        } else {
            img2Str = @"grade_11";
        }
        
        [self.curLevelImageView setImage: [UIImage imageNamed:img2Str]];
        self.curLevel1Label.text = [NSString stringWithFormat:@"VIP%@",subStr];
    }
    
    if (![CMCommon stringIsNull:user.nextLevelGrade] && user.nextLevelGrade.length>4) {
        NSString *sub2Str = [user.nextLevelGrade substringFromIndex:3];
        
        int levels2Int = [sub2Str intValue];
        
        NSString *img2_1Str = @"";
        if (levels2Int <11) {
            img2_1Str = [NSString stringWithFormat:@"grade_%d",levels2Int];
        } else {
            img2_1Str = @"grade_11";
        }
        
        [self.nextLevelImageView setImage: [UIImage imageNamed:img2_1Str]];
        self.nextLevel2Label.text = [NSString stringWithFormat:@"VIP%@",sub2Str];
        
        int int1String = [user.taskRewardTotal intValue];
        NSLog(@"int1String = %d",int1String);
        int int2String = [user.nextLevelInt intValue];
        NSLog(@"int2String = %d",int2String);
        self.nextLevelIntLabel.text = [NSString stringWithFormat:@"成长值（%d-%d）",int1String,int2String];
    }
    
    self.nextLevelIntLabel.text = _NSString(@"成长值（%@-%@）", _FloatString4(user.taskRewardTotal.doubleValue), _FloatString4(user.nextLevelInt.doubleValue));
    
    if (![CMCommon stringIsNull:user.taskRewardTitle]) {
        self.taskRewardTitleLabel.text = user.taskRewardTitle;
    }
    if (![CMCommon stringIsNull:user.taskRewardTotal]) {
        self.taskRewardTotalLabel.text = _FloatString4(user.taskReward.doubleValue);
    }
    
    double floatString = [user.balance doubleValue];
    self.balanceLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    //进度条
    float floatProgress = (float)[user.taskRewardTotal doubleValue]/[user.nextLevelInt doubleValue];
    self.progressLayer.path = [self progressPathWithProgress:floatProgress].CGPath;
    
}

#pragma mark -- 网络请求

//用户签到（签到类型：0是签到，1是补签）
- (void)teamAgentApplyInfoWithParams{
    
    //    NSString *date = @"2019-09-04";
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamAgentApplyInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
            
            NSLog(@"%@",obj.reviewStatus);
            
            int intStatus = obj.reviewStatus.intValue;
            
            //0 未提交  1 待审核  2 审核通过 3 审核拒绝
            if (intStatus == 2) {
                [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
            }
            else {
                UGAgentViewController *vc = [[UGAgentViewController alloc] init];
                vc.item = obj;
                [NavController1 pushViewController:vc animated:YES];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
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
            
            [self getSystemConfig];
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
            NSLog(@"签到==%d",[UGSystemConfigModel  currentConfig].checkinSwitch);
            [self setupUserInfo:YES];
            [self menuNameArrayDate ];
            [self stopAnimation];
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}


- (void)getAllNextIssueData {
    [SVProgressHUD showWithStatus: nil];
    [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            
            self.lotteryGamesArray = model.data;
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
    
}
#pragma mark --其他方法
- (void)rightBarBtnClick {
    UGYYRightMenuView *yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    yymenuView.titleType = @"1";
    //此处为重点
    WeakSelf;
    yymenuView.backToHomeBlock = ^{
        weakSelf.navigationController.tabBarController.selectedIndex = 0;
    };
    [yymenuView show];
}

@end
