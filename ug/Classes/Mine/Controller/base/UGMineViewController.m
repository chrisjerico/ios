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


@interface UGMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskRewardTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *curLevleGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelIntLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImager;

@property (weak, nonatomic) IBOutlet UIImageView *curLevelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextLevelImageView;

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

@end

static  NSString *menuCollectionViewCellid = @"UGMineMenuCollectionViewCell";
static NSString *menuTabelViewCellid = @"UGMenuTableViewCell";
@implementation UGMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.fd_prefersNavigationBarHidden = YES;
    self.navigationItem.title = @"我的";
    self.userInfoView.backgroundColor = UGNavColor;
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.height / 2 ;
    self.avaterImageView.layer.masksToBounds = YES;
    self.view.backgroundColor = UGBackgroundColor;
    self.avaterImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvaterSelectView)];
    [self.avaterImageView addGestureRecognizer:tap];

    self.imageNameArray = @[@"chongzhi",@"tixian",@"zaixiankefu",@"yinhangqia",@"lixibao",@"change",@"shouyi",@"ziyuan",@"zhanneixin",@"zdgl",@"zdgl",@"huiyuanxinxi",@"jianyi",@"zdgl"];
   
    
    UGUserModel *user = [UGUserModel currentUser];
    if (user.isAgent) {
         self.menuNameArray = @[@"存款",@"取款",@"在线客服",@"银行卡管理",@"利息宝",@"额度转换",@"推荐收益",@"安全中心",@"站内信",@"彩票注单记录",@"其他注单记录",@"个人信息",@"建议反馈",@"活动彩金"];
    } else {
       self.menuNameArray = @[@"存款",@"取款",@"在线客服",@"银行卡管理",@"利息宝",@"额度转换",@"代理申请",@"安全中心",@"站内信",@"彩票注单记录",@"其他注单记录",@"个人信息",@"建议反馈",@"活动彩金"];
    }
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMenuTableViewCell" bundle:nil] forCellReuseIdentifier:menuTabelViewCellid];
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = UGBackgroundColor;
    
    self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
    [self.waveBgView addSubview:self.waveView];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveBottomView.backgroundColor = UGRGBColor(84, 171, 238);
    self.waveView.realWaveColor = UGRGBColor(84, 171, 238);
    self.waveView.maskWaveColor = [UIColor clearColor];
    self.waveView.waveHeight = 10;
   
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self.refreshButton.layer removeAllAnimations];
        [self setupUserInfo:NO];
        [self.tableView reloadData];
    });
    SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    });
//    [self setUserInfoWithHeaderImg:YES];
    [self getUserInfo];
    [self.tableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
     [self.waveView startWaveAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
     [self.waveView stopWaveAnimation];
    [self.refreshButton.layer removeAllAnimations];
    
}

- (void)viewDidAppear:(BOOL)animated {
   
    if (self.refreshButton.selected) {
        [self startAnimation];
        
    }

}

//- (void)setUserInfoWithHeaderImg:(BOOL)flag {
//    UGUserModel *user = [UGUserModel currentUser];
//    if (flag) {
//
//        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
//    }
//    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",user.username,user.curLevelTitle];
//    self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[user.balance removeFloatAllZero]];
//    self.taskRewardTitleLabel.text = [NSString stringWithFormat:@"%@:\n%@",user.taskRewardTitle,user.curLevelInt];
//    self.nextLevelIntLabel.text = [NSString stringWithFormat:@"成长值(%@ - %@)",user.curLevelInt,user.nextLevelInt];
//    self.curLevleGradeLabel.text = user.curLevelGrade;
//    self.nextLevelGradeLabel.text = user.nextLevelGrade;
//    float per = user.curLevelInt.floatValue / user.nextLevelInt.floatValue;
//    self.progressLayer.path = [self progressPathWithProgress:per].CGPath;
//}

- (void)showAvaterSelectView {
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
    
}

- (IBAction)showMissionVC:(id)sender {
    UGUserModel *user = [UGUserModel currentUser];
    if (user.isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    }else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGMissionCenterViewController" bundle:nil];
        UGMissionCenterViewController *missionVC = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:missionVC animated:YES];
    }
    
}
- (IBAction)showSign:(id)sender {
    UGUserModel *user = [UGUserModel currentUser];
    if (user.isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    }else {
  
        //
//        UGSignInViewController *vc = [[UGSignInViewController alloc] initWithNibName:@"UGSignInViewController" bundle:nil];
        UGSigInCodeViewController *vc = [[UGSigInCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (IBAction)refreshBalance:(id)sender {

    SANotificationEventPost(UGNotificationGetUserInfo, nil);

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
    
    if (indexPath.row == 0) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
  
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 0;
            [self.navigationController pushViewController:fundsVC animated:YES];
        }
        
    }else if (indexPath.row == 1) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 1;
            [self.navigationController pushViewController:fundsVC animated:YES];
        }
       
    }else if (indexPath.row == 2) {
        SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        if (config.zxkfUrl) {
            
            webViewVC.urlStr = config.zxkfUrl;
        }
        [self.navigationController pushViewController:webViewVC animated:YES];
       
    }else if (indexPath.row == 3) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBindCardViewController" bundle:nil];
            if (user.hasBankCard) {
                UGBankCardInfoController *binkVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBankCardInfoController"];
                [self.navigationController pushViewController:binkVC animated:YES];
            }else {
                if (user.hasFundPwd) {
                    
                    UGBindCardViewController *bankCardVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBindCardViewController"];
                    [self.navigationController pushViewController:bankCardVC animated:YES];
                }else {
                    UGSetupPayPwdController *fundVC = [storyboard instantiateViewControllerWithIdentifier:@"UGSetupPayPwdController"];
                    [self.navigationController pushViewController:fundVC animated:YES];
                }
            }
        }

    }else if (indexPath.row == 4){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
        UGYubaoViewController *lixibaoVC = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:lixibaoVC  animated:YES];
        
    }else if (indexPath.row == 5){
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
     
            UGBalanceConversionController *conversion = [self.storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionController"];
            [self.navigationController pushViewController:conversion  animated:YES];
        }
        
    }else if (indexPath.row == 6) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            UGPromotionIncomeController *incomeVC = [[UGPromotionIncomeController alloc] init];
            [self.navigationController pushViewController:incomeVC animated:YES];
        }else {
             UGUserModel *user = [UGUserModel currentUser];
            if (user.isAgent) {
                UGPromotionIncomeController *incomeVC = [[UGPromotionIncomeController alloc] init];
                [self.navigationController pushViewController:incomeVC animated:YES];
            } else {
                UGAgentViewController*incomeVC = [[UGAgentViewController alloc] init];
                [self.navigationController pushViewController:incomeVC animated:YES];
            }
//            UGAgentViewController*incomeVC = [[UGAgentViewController alloc] init];
//            [self.navigationController pushViewController:incomeVC animated:YES];
          
        }
       
    }else if (indexPath.row == 7) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
 
            UGSecurityCenterViewController *securityCenterVC = [[UGSecurityCenterViewController alloc] init];
            [self.navigationController pushViewController:securityCenterVC animated:YES];
        }
        
    }else if (indexPath.row == 8) {
        UGMailBoxTableViewController *mailBoxVC = [[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:mailBoxVC animated:YES];

    }else if (indexPath.row == 9) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
       
            UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
            [self.navigationController pushViewController:betRecordVC animated:YES];
        }
        
    }else if (indexPath.row == 10) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGRealBetRecordViewController" bundle:nil];
            UGRealBetRecordViewController *betRecordVC = [storyboard instantiateInitialViewController];
            betRecordVC.gameType = @"real";
            [self.navigationController pushViewController:betRecordVC animated:YES];
        }
        
    }else if (indexPath.row == 11) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGUserInfoViewController" bundle:nil];
            UGUserInfoViewController *userInfoVC = [storyboard instantiateInitialViewController];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
        
    }
    else if (indexPath.row == 12) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFeedBackController" bundle:nil];
            UGFeedBackController *feedbackVC = [storyboard instantiateInitialViewController];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
    }
    else {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
    
            UGMosaicGoldViewController *vc = [[UGMosaicGoldViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
    
    if (flag) {
        
                [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
            }
   
    self.userNameLabel.text = user.username;
    self.levelNameLabel.text = user.curLevelGrade;
    
    NSString *imagerStr = [user.curLevelGrade lowercaseString];
    NSLog(@"imagerStr = %@",imagerStr);
    
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
    
    NSString *sub2Str = [user.nextLevelGrade substringFromIndex:3];
    
    int levels2Int = [sub2Str intValue];
    
    NSString *img2_1Str = @"";
    if (levels2Int <11) {
        img2_1Str = [NSString stringWithFormat:@"grade_%d",levels2Int];
    } else {
        img2_1Str = @"grade_11";
    }
    
    [self.nextLevelImageView setImage: [UIImage imageNamed:img2_1Str]];
    
    int int1String = [user.taskRewardTotal intValue];
    NSLog(@"int1String = %d",int1String);
    int int2String = [user.nextLevelInt intValue];
    NSLog(@"int2String = %d",int2String);
    self.nextLevelIntLabel.text = [NSString stringWithFormat:@"成长值（%d-%d）",int1String,int2String];
    
    
    double floatString = [user.balance doubleValue];
    self.balanceLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    //进度条
    float floatProgress = (float)[user.taskRewardTotal doubleValue]/[user.nextLevelInt doubleValue];
    self.progressLayer.path = [self progressPathWithProgress:floatProgress].CGPath;
    
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
            [self setupUserInfo:YES];
            
            [self stopAnimation];
            
        } failure:^(id msg) {
            
            [self stopAnimation];
            
        }];
    }];
}
@end
