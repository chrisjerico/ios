
//
//  UGMainViewController.m
//  ug
//
//  Created by ug on 2019/7/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGHomeViewController.h"

// ViewController
#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGPcddLotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"
#import "UGLotteryRecordController.h"
#import "UGMailBoxTableViewController.h"
#import "UGYubaoViewController.h"
#import "UGDocumentVC.h"
#import "UGFundsViewController.h"
#import "SLWebViewController.h"
#import "SLWebViewController.h"
#import "QDWebViewController.h"
#import "UGGameListViewController.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGChangLongController.h"
#import "UGLoginViewController.h"
#import "UGRegisterViewController.h"
#import "UGPromoteDetailController.h"   // 优惠活动详情
#import "UGPromotionsController.h"
#import "UGAgentViewController.h"   // 申请代理

// View
#import "SDCycleScrollView.h"
#import "CustomCollectionViewCell.h"
#import "UUMarqueeView.h"
#import "UGGameTypeCollectionView.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "UGredEnvelopeView.h"
#import "UGredActivityView.h"
#import "GameCategoryDataModel.h"
#import "UGNoticePopView.h"
#import "UGHomeTitleView.h"
#import "UGLotteryRulesView.h"
#import "STButton.h"
#import "UGPlatformNoticeView.h"
#import "UGAppVersionManager.h"
#import "UGPromotionIncomeController.h"

// 六合View
#import "UGLHLotteryCollectionViewCell.h"
#import "UGLHHomeContentCollectionViewCell.h"
#import "UGScratchMusicView.h"

// Model
#import "UGBannerModel.h"
#import "UGNoticeModel.h"
#import "UGSystemConfigModel.h"
#import "UGPromoteModel.h"
#import "UGRankModel.h"
#import "UGAllNextIssueListModel.h"
#import "UGYYRightMenuView.h"
#import "UGGameNavigationView.h"
#import "UGPlatformGameModel.h"

// Tools
#import "UIImageView+WebCache.h"
#import "CMCommon.h"
#import "UGonlineCount.h"
#import <SafariServices/SafariServices.h>
#import "UIImage+YYgradientImage.h"
#import "SGBrowserView.h"

@interface UGHomeViewController ()<SDCycleScrollViewDelegate,UUMarqueeViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bannerBgView;                          /**<   Banner */
@property (weak, nonatomic) IBOutlet UGGameNavigationView *gameNavigationView;      /**<   游戏导航父视图 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameNavigationViewHeight;  /**<   游戏导航 */

@property (weak, nonatomic) IBOutlet UGGameTypeCollectionView *gameTypeView;/**<   游戏列表 */
@property (weak, nonatomic) IBOutlet UIView *rankingView;                   /**<   中奖排行榜父视图 */

@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView;    /**<   滚动公告 */
@property (weak, nonatomic) IBOutlet UUMarqueeView *upwardMultiMarqueeView; /**<   中奖排行榜 */
@property (weak, nonatomic) IBOutlet UIView *promotionView;                 /**<   优惠活动 view*/
@property (weak, nonatomic) IBOutlet UIStackView *promotionsStackView;      /**<   优惠活动 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameViewHeight;
@property (nonatomic, strong)UGPlatformNoticeView *notiveView;        /**<   平台公告 */

@property (nonatomic, strong) UGHomeTitleView *titleView;               /**<   自定义导航条 */
@property (nonatomic, strong) SDCycleScrollView *bannerView;            /**<   滚动广告面板 */

@property (nonatomic, strong) NSMutableArray *leftwardMarqueeViewData;      /**<   公告数据 */
@property (nonatomic, strong) NSMutableArray *popNoticeArray;


@property (nonatomic, strong) NSMutableArray *gameCategorys;
@property (nonatomic, strong) UGNoticeTypeModel *noticeTypeModel;
@property (nonatomic, strong) UGRankListModel *rankListModel;

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *noticeArray;
@property (nonatomic, strong) NSArray<UGRankModel *> *rankArray;           /**<   中奖排行榜数据 */
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, assign) BOOL initSubview;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic)  UGredEnvelopeView *uGredEnvelopeView;    /**<   红包浮动按钮 */
@property (strong, nonatomic)  UGredActivityView *uGredActivityView;    /**<   红包弹框 */

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;   /**<   侧边栏 */

@property (nonatomic, strong) UGonlineCount *mUGonlineCount;

@property (strong, nonatomic)UILabel *nolineLabel;

@property (weak, nonatomic) IBOutlet UIView *rollingView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankViewHeight;


//-------------------------------------------
//六合
@property (weak, nonatomic) IBOutlet UILabel *lotteryTitleLabel;        /**<   XX期开奖结果*/
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;              /**<   咪*/
@property (weak, nonatomic) IBOutlet UICollectionView *lotteryCollectionView;/**<  开奖的显示*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                /**<  开奖的时间显示*/
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;           /**<  开奖的倒计时显示*/
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView; /**<  论坛，专帖XXX显示*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;/**<  contentCollectionView 的约束高*/
@property (weak, nonatomic) IBOutlet UISwitch *lotteryUISwitch;

//--------------------------------------------

@end

@implementation UGHomeViewController
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)skin {
    
    FastSubViewCode(self.view);
    NSString* skitType = [[UGSkinManagers shareInstance] skitType];
    if ([skitType isEqualToString:@"六合资料"]) {//六合资料
      #pragma mark - 测试
        self.heightLayoutConstraint.constant = 7*100+5;
        self.gameNavigationViewHeight.constant = 0;
        self.gameNavigationView.hidden = YES;
        self.gameTypeView.hidden = YES;
        self.rankingView.hidden = YES;
        self.promotionView.hidden = NO;
        subView(@"开奖结果").hidden = NO;
        subView(@"六合论坛").hidden = NO;
   
    }
    else{
        self.heightLayoutConstraint.constant = 0;
        self.gameNavigationView.hidden = NO;
        self.gameTypeView.hidden = NO;
        self.rankingView.hidden = NO;
        subView(@"开奖结果").hidden = YES;
        subView(@"六合论坛").hidden = YES;
        self.promotionView.hidden = NO;
    }
    
	[self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    [self.upwardMultiMarqueeView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
    [self.rollingView setBackgroundColor:[[UGSkinManagers shareInstance]sethomeContentColor]];
    [self.gameNavigationView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
    [self.leftwardMarqueeView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
    [self.gameTypeView setBackgroundColor:[[UGSkinManagers shareInstance] setbgColor]];
     self.gameNavigationView.layer.borderColor = [[UGSkinManagers shareInstance] sethomeContentBorderColor].CGColor;
    [self.gameNavigationView reloadData];
    [[UGSkinManagers shareInstance] navigationBar:(UGNavigationController *)self.navigationController bgColor: [[UGSkinManagers shareInstance] setNavbgColor]];
}

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {

    [super viewDidLoad];

	SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
		[self skin];
	});
	self.gameNavigationView.layer.cornerRadius = 8;
	self.gameNavigationView.layer.masksToBounds = true;
	self.gameNavigationView.layer.borderWidth = 1;
	self.gameNavigationView.layer.borderColor = [[UGSkinManagers shareInstance] sethomeContentBorderColor].CGColor;
	[self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
	[self.rankingView setBackgroundColor:[[UGSkinManagers shareInstance] setNavbgColor]];
	[self.upwardMultiMarqueeView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
	[self.rollingView setBackgroundColor:[[UGSkinManagers shareInstance]sethomeContentColor]];
	[self.gameNavigationView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
	[self.leftwardMarqueeView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
	[self.gameTypeView setBackgroundColor:[[UGSkinManagers shareInstance] setbgColor]];
    [self.bottomView setBackgroundColor:[[UGSkinManagers shareInstance] setNavbgColor]];
    [[UGSkinManagers shareInstance] navigationBar:(UGNavigationController *)self.navigationController bgColor: [[UGSkinManagers shareInstance] setNavbgColor]];
    
	[[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[[UGSkinManagers shareInstance] setTabbgColor]]];
	
	[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UGSkinManagers shareInstance] settabNOSelectColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
	
	[[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys: [[UGSkinManagers shareInstance] settabSelectColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
	
	[[UITabBar appearance] setSelectedImageTintColor: [[UGSkinManagers shareInstance] settabSelectColor]];
	
	[[UITabBar appearance] setUnselectedItemTintColor: [[UGSkinManagers shareInstance] settabNOSelectColor]];
	
	
	[self setupSubView];
    {//六合
        [self initLHCollectionView];
    }
	
	
	SANotificationEventSubscribe(UGNotificationTryPlay, self, ^(typeof (self) self, id obj) {
		[self tryPlayClick];
	});
	
	SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
		[self getUserInfo];
		self.titleView.showLoginView = NO;
		
	});
	SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
		[self userLogout];
	});
	SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
		// onceToken 函数的作用是，限制为只弹一次框，修复弹框多次的bug
        if (OBJOnceToken(UGUserModel.currentUser)) {
            [QDAlertView showWithTitle:@"提示" message:@"您的账号已经登录超时，请重新登录。" cancelButtonTitle:nil otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                self.titleView.showLoginView = YES;
                UGUserModel.currentUser = nil;
                [self.tabBarController setSelectedIndex:0];
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
            }];
        }
	});
    
    [self xw_addNotificationForName:UGNotificationShowLoginView block:^(NSNotification * _Nonnull noti) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
    }];
	SANotificationEventSubscribe(UGNotificationGetUserInfo, self, ^(typeof (self) self, id obj) {
		[self getUserInfo];
	});
	SANotificationEventSubscribe(UGNotificationAutoTransferOut, self, ^(typeof (self) self, id obj) {
		[self autoTransferOut];
	});
    SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
        [self.promotionsStackView superviewWithTagString:@"优惠活动ContentView"].hidden = !SysConf.m_promote_pos;
    });
    
	
	self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

		[self getSystemConfig];     // APP配置信息
		[self getBannerList];       // Banner图
        if (self.notiveView == nil) {
            [self getNoticeList];   // 公告列表
        }
		[self getUserInfo];         // 用户信息
		[self getCheckinListData];  // 红包数据
		[self systemOnlineCount];   // 在线人数
        [self getPromoteList];      // 优惠活动
       
        [[UGSkinManagers shareInstance] navigationBar:(UGNavigationController *)self.navigationController bgColor: [[UGSkinManagers shareInstance] setNavbgColor]];
	}];

    [self getBannerList];
    if (self.notiveView == nil) {
        [self getNoticeList];
        [self getSystemConfig];
    }
    [self getUserInfo];        // 用户信息
    [self getCheckinListData]; // 红包数据
    [self systemOnlineCount];  // 在线人数
    [self getPromoteList];      // 优惠活动
	
    __weakSelf_(__self);
    [self xw_addNotificationForName:@"gameNavigationItemTaped" block:^(NSNotification * _Nonnull noti) {
        [__self gameNavigationAction:noti.object];
    }];
	
	WeakSelf
	self.gameTypeView.gameItemSelectBlock = ^(GameModel * _Nonnull game) {
		[weakSelf showGameVC:game];
	};
	
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    // 红包事件
    {
        self.uGredEnvelopeView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-100, 150, 95, 95) ];
        [self.view addSubview:_uGredEnvelopeView];
        [self.uGredEnvelopeView setHidden:YES];
        [self.uGredEnvelopeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.width.mas_equalTo(95.0);
            make.height.mas_equalTo(95.0);
            make.top.equalTo(self.view.mas_top).offset(150);
        }];
        self.uGredEnvelopeView.cancelClickBlock = ^(void) {
            [weakSelf.uGredEnvelopeView setHidden:YES];
        };
        
        // 红包弹框
        WeakSelf;
        self.uGredEnvelopeView.redClickBlock = ^(void) {
            //        [weakSelf.uGredEnvelopeView setHidden:YES];
            if (!UGLoginIsAuthorized()) {
                UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"您还未登录" btnTitles:@[@"取消", @"马上登录"]];
                [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
                    UGLoginAuthorize(^(BOOL isFinish) {
                        if (!isFinish)
                            return ;
                    });
                }];
                return;
            }
            if ([UGUserModel currentUser].isTest) {
                UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];
                [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }];
                return ;
            }
            
            NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
            
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork activityRedBagDetailWithParams:params completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD dismiss];
                    weakSelf.uGredEnvelopeView.item = (UGRedEnvelopeModel*)model.data;
                    
                    weakSelf.uGredActivityView = [[UGredActivityView alloc] initWithFrame:CGRectMake(20,100, UGScreenW-50, UGScreenW-50+150) ];
                    weakSelf.uGredActivityView.item = weakSelf.uGredEnvelopeView.item;
                    if (weakSelf.uGredEnvelopeView.item) {
                        [weakSelf.uGredActivityView show];
                    }
                } failure:^(id msg) {
                    [SVProgressHUD dismiss];
//                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
        };
    }
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.leftwardMarqueeView start];
    [self.upwardMultiMarqueeView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[self.leftwardMarqueeView pause];//fixbug  发热  掉电快
	[self.upwardMultiMarqueeView pause];//fixbug  发热  掉电快
	self.initSubview = YES;
}
#pragma mark - 六合方法
- (void)initLHCollectionView {
//六合内容
    self.contentCollectionView.backgroundColor = RGBA(221, 221, 221, 1);
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.tagString= @"六合内容";
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"UGLHHomeContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [CMCommon setBorderWithView:self.contentCollectionView top:YES left:YES bottom:YES right:YES borderColor:RGBA(221, 221, 221, 1) borderWidth:1];
//六合开奖
    self.lotteryCollectionView.backgroundColor = [UIColor whiteColor];
    self.lotteryCollectionView.dataSource = self;
    self.lotteryCollectionView.delegate = self;
    self.lotteryCollectionView.tagString= @"六合开奖";
    [self.lotteryCollectionView registerNib:[UINib nibWithNibName:@"UGLHLotteryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.lotteryCollectionView setBounces:NO];
    [self.lotteryCollectionView setScrollEnabled:NO];
    
}

#pragma mark UICollectionView datasource
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 
    return 1;
}
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int rows = 0;
    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
         rows = 14;
    } else {
        rows = 8;
    }
    return rows;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
       UGLHHomeContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     //        NSDictionary *dic = [self.menuNameArray objectAtIndex:indexPath.row];
         FastSubViewCode(cell);
         [cell setBackgroundColor: [UIColor whiteColor]];
         return cell;
    } else {
      UGLHLotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //        NSDictionary *dic = [self.menuNameArray objectAtIndex:indexPath.row];
        FastSubViewCode(cell);
        if (indexPath.row == 6) {
            subImageView(@"球图").hidden = YES;
            subLabel(@"球内字").hidden = YES;
            subLabel(@"加").hidden = NO;
            subLabel(@"球下字").hidden = YES;
            subButton(@"刮刮乐").hidden = YES;
        }
        else if (self.lotteryUISwitch.isOn&&indexPath.row == 7) {
            subImageView(@"球图").hidden = YES;
            subLabel(@"球内字").hidden = YES;
            subLabel(@"加").hidden = NO;
            subLabel(@"球下字").hidden = YES;
            subButton(@"刮刮乐").hidden = NO;
             [subButton(@"刮刮乐") handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
                NSLog(@"---");
                 UGScratchMusicView *inviteView = [[UGScratchMusicView alloc] initView];
                [SGBrowserView showMoveView:inviteView];
            }];
        }
        else {
            subImageView(@"球图").hidden = NO;
            subLabel(@"球内字").hidden = NO;
            subLabel(@"加").hidden = YES;
            subLabel(@"球下字").hidden = NO;
            subButton(@"刮刮乐").hidden = YES;
        }
        [cell setBackgroundColor: [UIColor whiteColor]];
        return cell;
    }
      
}
//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
         float itemW = (UGScreenW-1)/ 2.0;
         CGSize size = {itemW, 100};
         return size;
    } else {
        CGSize size = {40, 70};
        return size;
    }
}
//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
#pragma mark ---------------- 六合方法
- (void)gameNavigationAction: (GameModel *)model{
    
    if ([model.subId isEqualToString:@"1"]) {
        // 资金管理
        [self.navigationController pushViewController:[UGFundsViewController new] animated:true];
    } else if ([model.subId isEqualToString:@"8"]) {
        // 利息宝
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
    } else if ([model.subId isEqualToString:@"5"]) {
        // 长龙助手
        UGChangLongController *changlongVC = [[UGChangLongController alloc] init];
        changlongVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:changlongVC animated:YES];
    } else if ([model.subId isEqualToString:@"7"]) {
        // 开奖网
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"%@/Open_prize/index.php", baseServerUrl)]];
    } else if ([model.subId isEqualToString:@"6"]) {
        // 推广收益
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
                        [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
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
    } else if ([model.subId isEqualToString:@"2"]) {
        // APP下载
        [[UGAppVersionManager shareInstance] updateVersionApi:true];
    } else if ([model.subId isEqualToString:@"3"]) {
        // 聊天室
        [self.navigationController pushViewController:[UGChatViewController new] animated:YES];
    } else if ([model.subId isEqualToString:@"4"]) {
        // 在线客服
        TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
        webViewVC.url = SysConf.zxkfUrl;
        webViewVC.webTitle = @"在线客服";
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
    else if ([model.subId isEqualToString:@"9"]) {
        // 优惠活动
       [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
    }
    else if ([model.subId isEqualToString:@"10"]) {
        // 游戏记录
        UGBetRecordViewController *vc = [[UGBetRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
    else if ([model.subId isEqualToString:@"11"]) {
        // QQ客服
        NSString *qqstr;
        if ([CMCommon stringIsNull:SysConf.serviceQQ1]) {
            qqstr = SysConf.serviceQQ2;
        } else {
            qqstr = SysConf.serviceQQ1;
        }
        NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqstr];
        NSURL *url = [NSURL URLWithString:qq];
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
       TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
       webViewVC.url = model.url;
       webViewVC.webTitle = model.title;
       [self.navigationController pushViewController:webViewVC animated:YES];
    }
}

- (void)getUserInfo {
	if (!UGLoginIsAuthorized()) {
		return;
	}
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
	[CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			UGUserModel *user = model.data;
			UGUserModel *oldUser = [UGUserModel currentUser];
			user.sessid = oldUser.sessid;
			user.token = oldUser.token;
			UGUserModel.currentUser = user;
			self.titleView.userName = user.username;
			SANotificationEventPost(UGNotificationGetUserInfoComplete, nil);
		} failure:^(id msg) {
			SANotificationEventPost(UGNotificationGetUserInfoComplete, nil);
			if (model.msg.length) {
				[SVProgressHUD showErrorWithStatus:model.msg];
				return ;
			}
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

//游戏中的余额自动转出
- (void)autoTransferOut {
	if (!UGLoginIsAuthorized()) {
		return;
	}
	[CMNetwork autoTransferOutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
		
	}];
}

// 彩票大厅数据
- (void)getAllNextIssueData {
	[SVProgressHUD showWithStatus: nil];
	[CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[SVProgressHUD dismiss];
		[CMResult processWithResult:model success:^{
			
			self.lotteryGamesArray = model.data;
			
		} failure:^(id msg) {
			
		}];
	}];
	
}

// 自定义游戏列表
- (void)getCustomGameList {
	[SVProgressHUD showWithStatus: nil];
	[CMNetwork getCustomGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			[SVProgressHUD dismiss];
			if (model.data) {
				dispatch_async(dispatch_get_main_queue(), ^{
					GameCategoryDataModel * customGameModel = (GameCategoryDataModel*)model.data;
                    self.gameCategorys = customGameModel.icons.mutableCopy;
					
					NSArray<GameModel *> *sourceData = customGameModel.navs;
                    self.gameNavigationView.superview.hidden = !sourceData.count;
					self.gameNavigationView.sourceData = sourceData;
					if (sourceData.count > 0) {
						self.gameNavigationViewHeight.constant = ((sourceData.count - 1)/4 + 1)*80;
						[self.view layoutIfNeeded];
					}
					self.gameTypeView.gameTypeArray = self.gameCategorys;
				});
			}
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

// 获取三方游戏路径
- (void)getGotoGameUrl:(UGPlatformGameModel *)game {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"id":game.gameId
	};
	[SVProgressHUD showWithStatus:nil];
	[CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			[SVProgressHUD dismiss];
			dispatch_async(dispatch_get_main_queue(), ^{
				QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
                
                NSLog(@"网络链接：model.data = %@",model.data);
                qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
				qdwebVC.enterGame = YES;
				[self.navigationController pushViewController:qdwebVC  animated:YES];
			});
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

// 获取系统配置
- (void)getSystemConfig {
	[CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			
			NSLog(@"model = %@",model);
			
			UGSystemConfigModel *config = model.data;
			UGSystemConfigModel.currentConfig = config;

			[[UGSkinManagers shareInstance] setSkin];
            NSString* skitType = [[UGSkinManagers shareInstance] skitType];
            if (![skitType isEqualToString:@"六合资料"]) {//六合资料
                 [self getCustomGameList];   // 自定义游戏列表
                 [self getRankList];         // 中奖列表
                 [self getAllNextIssueData]; // 彩票大厅数据
            }
            NSString *title =[NSString stringWithFormat:@"COPYRIGHT © %@ RESERVED",config.webName];
            [self.bottomLabel setText:title];
			[self.titleView setImgName:config.mobile_logo];
			SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
		} failure:^(id msg) {
			
		}];
	}];
}

- (void)userLogout {
	NSDictionary *dict = @{@"token":[UGUserModel currentUser].sessid};
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
    self.titleView.showLoginView = YES;
    UGUserModel.currentUser = nil;
    [NavController1 popToRootViewControllerAnimated:true];
    [TabBarController1 setSelectedIndex:0];
    
	[CMNetwork userLogoutWithParams:dict completion:nil];
}

// 横幅广告
- (void)getBannerList {
	[CMNetwork getBannerListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			
			dispatch_async(dispatch_get_main_queue(), ^{
				// 需要在主线程执行的代码
				self.bannerArray = ((UGBannerModel*)model.data).list;
				NSMutableArray *mutArr = [NSMutableArray array];
				if (self.bannerArray.count) {
					for (UGBannerCellModel *banner in self.bannerArray) {
						
						[mutArr addObject:banner.pic];
					}
					self.bannerView.imageURLStringsGroup = mutArr.mutableCopy;
					self.bannerView.autoScrollTimeInterval = ((UGBannerModel*)model.data).interval.floatValue;
				}
			});
			
		} failure:^(id msg) {
			
		}];
	}];
}

// 公告列表
- (void)getNoticeList {
	[CMNetwork getNoticeListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			dispatch_async(dispatch_get_main_queue(), ^{
				UGNoticeTypeModel *type = model.data;
				self.noticeTypeModel = model.data;
				self.popNoticeArray = type.popup.mutableCopy;
				for (UGNoticeModel *notice in type.scroll) {
					//                NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[notice.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
					[self.leftwardMarqueeViewData addObject:notice.title];
				}
				[self.leftwardMarqueeView reloadData];
				if (self.popNoticeArray.count) {
					
                    if (self.notiveView == nil) {
                        [self showPlatformNoticeView];
                    }
					
				}
			});
		} failure:nil];
	}];
}

// 中奖排行榜、投注排行榜
- (void)getRankList {
	[CMNetwork getRankListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			
			dispatch_async(dispatch_get_main_queue(), ^{
				// 需要在主线程执行的代码
				UGRankListModel *rank = model.data;
				self.rankListModel = rank;
                self.rankArray = ({
                    // 填充5条空数据，看起来就有一段空白形成翻页效果
                    NSMutableArray *temp = rank.list.mutableCopy;
                    for (int i=0; i<5; i++) {
                        UGRankModel *rm = [UGRankModel new];
                        [temp addObject:rm];
                    }
                    [temp copy];
                });
				
				
				UGSystemConfigModel * config = UGSystemConfigModel.currentConfig;
				
				if (config.rankingListSwitch == 0) {
					self.rankingView.hidden = YES;
					self.rankViewHeight.constant = 0;
					[self.view layoutIfNeeded];
				} else if (config.rankingListSwitch == 1) {
					self.rankingView.hidden = false;
					self.rankViewHeight.constant = 250;
					[self.view layoutIfNeeded];
					self.rankLabel.text = @"中奖排行榜";
				} else if (config.rankingListSwitch == 2) {
					self.rankingView.hidden = false;
					self.rankViewHeight.constant = 250;
					[self.view layoutIfNeeded];
					self.rankLabel.text = @"投注排行榜";

				}
				
				[self.upwardMultiMarqueeView reloadData];

			});
			
		} failure:^(id msg) {
			
		}];
	}];
}

//得到红包详情数据
- (void)getCheckinListData {
	BOOL isLogin = UGLoginIsAuthorized();
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
	
	[SVProgressHUD showWithStatus:nil];
	WeakSelf;
	[CMNetwork activityRedBagDetailWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				// 需要在主线程执行的代码
				// 需要在主线程执行的代码
				[SVProgressHUD dismiss];
				self.uGredEnvelopeView.item = (UGRedEnvelopeModel*)model.data;
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					//需要在主线程执行的代码
					[self.uGredEnvelopeView setHidden:NO];
				}];
			});
		} failure:^(id msg) {
			[self.uGredEnvelopeView setHidden:YES];
			[SVProgressHUD dismiss];
		}];
	}];
}

// APP在线人数
- (void)systemOnlineCount {
	[CMNetwork systemOnlineCountWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			
			dispatch_async(dispatch_get_main_queue(), ^{
				// 需要在主线程执行的代码
				
				self.mUGonlineCount = model.data;
				
				int intOnlineSwitch = [self.mUGonlineCount.onlineSwitch intValue];
				
				if (intOnlineSwitch == 1) {
					[self.nolineLabel setHidden:NO];
					[self.nolineLabel setText:[NSString stringWithFormat:@"当前在线人数：%@",self.mUGonlineCount.onlineUserCount]];
				} else {
					[self.nolineLabel setHidden:YES];
				}
				
			});
			
		} failure:^(id msg) {
			
		}];
	}];
}

// 优惠活动
- (void)getPromoteList {
    __weakSelf_(__self);
    [CMNetwork getPromoteListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGPromoteListModel *listModel = model.data;
            int i=0;
            for (UIView *v in __self.promotionsStackView.arrangedSubviews) {
                UGPromoteModel *pm = listModel.list[i++];
                FastSubViewCode(v);
                subLabel(@"优惠活动Label").text = pm.title;
                [subImageView(@"优惠活动ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        subImageView(@"优惠活动ImageView").cc_constraints.height.constant = image.height/image.width * (APP.Width - 48);
                    }
                }];
                [subButton(@"优惠活动Button") removeActionBlocksForControlEvents:UIControlEventTouchUpInside];
                [subButton(@"优惠活动Button") handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
                    UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
                    detailVC.item = pm;
                    [__self.navigationController pushViewController:detailVC animated:YES];
                }];
            }
        } failure:nil];
    }];
}




- (void)showPlatformNoticeView {
    if (self.notiveView == nil) {
        
         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!appDelegate.notiveViewHasShow) {
            self.notiveView = [[UGPlatformNoticeView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
            self.notiveView.dataArray = self.popNoticeArray;
            [self.notiveView.bgView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
            [self.notiveView show];
        }
        appDelegate.notiveViewHasShow = YES;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
	UGBannerCellModel *banner = self.bannerArray[index];
    if ([banner.url containsString:@"mobile"]) {
        // 若跳转地址包含mobile则不做跳转
        return;
    }
	if ([banner.url stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
		SLWebViewController *webVC = [[SLWebViewController alloc] init];
		webVC.urlStr = banner.url;
		[self.navigationController pushViewController:webVC animated:YES];
	}
}

#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView *)marqueeView {
	if (marqueeView == self.leftwardMarqueeView) {
		return 1;
	}
	return 6;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView *)marqueeView {
	if (marqueeView == self.leftwardMarqueeView) {
		return self.leftwardMarqueeViewData ? self.leftwardMarqueeViewData.count : 0;
	}
	return self.rankArray ? self.rankArray.count : 0;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView {
	
	if (marqueeView == self.leftwardMarqueeView) {
		
		itemView.backgroundColor = [UIColor clearColor];
		
		UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
		content.font = [UIFont systemFontOfSize:14.0f];
		content.tag = 1001;
		[itemView addSubview:content];
	} else {
		
		itemView.backgroundColor = [UIColor whiteColor];
		UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, (CGRectGetHeight(itemView.bounds) - 16.0f) / 2.0f, 16.0f, 16.0f)];
		icon.tag = 1003;
		[itemView addSubview:icon];
		UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(20.0f + 20.0f, 0.0f, CGRectGetWidth(itemView.bounds) - 20.0f - 20.0f - 75.0f, CGRectGetHeight(itemView.bounds))];
		userName.font = [UIFont systemFontOfSize:14.0f];
		userName.textColor = [UIColor redColor];
		userName.tag = 1001;
		[itemView addSubview:userName];
		
		UILabel *gameLabel = [[UILabel alloc] initWithFrame:CGRectMake((UGScreenW / 3), 0, (UGScreenW / 3), itemView.height)];
		gameLabel.textColor = [UIColor blackColor];
		gameLabel.textAlignment = NSTextAlignmentCenter;
		gameLabel.font = [UIFont systemFontOfSize:14];
		gameLabel.tag = 1004;
		[itemView addSubview:gameLabel];
		
		UILabel *amountLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gameLabel.frame), 0, (UGScreenW / 3)-20, itemView.height)];
		amountLable.textColor = [UIColor redColor];
		amountLable.font = [UIFont systemFontOfSize:14];
		amountLable.textAlignment = NSTextAlignmentCenter;
		amountLable.tag = 1002;
		[itemView addSubview:amountLable];
	}
}

- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
	if (marqueeView == self.leftwardMarqueeView) {
		UILabel *content = [itemView viewWithTag:1001];
		content.text = self.leftwardMarqueeViewData[index];
	} else {
		UGRankModel *rank = self.rankArray[index];
		UILabel *content = [itemView viewWithTag:1001];
		content.text = rank.username;
		[content setTextColor:UIColor.blackColor];
		
		UILabel *coin = [itemView viewWithTag:1002];
        coin.text = rank.coin.length ? _NSString(@"%@元",rank.coin) : nil;
		
		UILabel *game = [itemView viewWithTag:1004];
		game.text = rank.type;
		
		
		UIImageView *icon = [itemView viewWithTag:1003];
		NSString *imgName = nil;
		icon.hidden = NO;
        if (!rank.coin.length) {
            imgName = @"yuandian";
            icon.hidden = YES;
        } else if (index == 0) {
			imgName = @"diyiming";
		} else if (index == 1) {
			imgName = @"dierming";
		} else if (index == 2) {
			imgName = @"disanming";
		} else {
			imgName = @"yuandian";
			icon.hidden = YES;
		}
		icon.image = [UIImage imageNamed:imgName];
		
		[itemView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
		
	}
}

- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
	// for upwardMultiMarqueeView
	return self.upwardMultiMarqueeView.height / 6;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
	// for leftwardMarqueeView
	UILabel *content = [[UILabel alloc] init];
	content.text = self.leftwardMarqueeViewData[index];
	return content.intrinsicContentSize.width;  // icon width + label width (it's perfect to cache them all)
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
	
	
}

- (void)rightBarBtnClick {
	self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
	self.yymenuView.titleType = @"1";
	self.yymenuView.lotteryGamesArray = self.lotteryGamesArray;
	[self.yymenuView show];
}

- (void)tryPlayClick {
	
	NSDictionary *params = @{@"usr":@"46da83e1773338540e1e1c973f6c8a68",
							 @"pwd":@"46da83e1773338540e1e1c973f6c8a68"
	};
	[SVProgressHUD showWithStatus:nil];
	[CMNetwork guestLoginWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			
			[SVProgressHUD showSuccessWithStatus:model.msg];
			UGUserModel *user = model.data;
			UGUserModel.currentUser = user;
			SANotificationEventPost(UGNotificationLoginComplete, nil);
			
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

- (void)showBalanceTrans {
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"余额转换" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定转入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
	}];
	UIAlertAction *enter = [UIAlertAction actionWithTitle:@"进入游戏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
	}];
	[alert addAction:cancel];
	[alert addAction:sure];
	[alert addAction:enter];
	[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = @"请输入需要转入的金额";
		//        [textField addTarget:self action:nil forControlEvents:UIControlEventEditingChanged];
	}];
	
	[self presentViewController:alert animated:YES completion:nil];
	
}

- (void)showNoticeInfo {
	NSMutableString *str = [[NSMutableString alloc] init];
	for (UGNoticeModel *notice in self.noticeTypeModel.scroll) {
		[str appendString:notice.content];
	}
	if (str.length) {
		float y;
		if ([CMCommon isPhoneX]) {
			y = 160;
		} else {
			y = 100;
		}
		UGNoticePopView *popView = [[UGNoticePopView alloc] initWithFrame:CGRectMake(40, y, UGScreenW - 80, UGScerrnH - y * 2)];
		popView.content = str;
		[popView show];
	}
}

- (void)showGameVC:(GameModel *)model {
	if (!UGLoginIsAuthorized()) {
		SANotificationEventPost(UGNotificationShowLoginView, nil);
		return;
	}
	if ([model.docType intValue] == 1) {
		UGDocumentVC * vc = [[UGDocumentVC alloc] initWithModel:model];
		[self.navigationController pushViewController: vc animated:true];
		return;
	}
	if (model.game_id) {
		model.gameId = model.game_id;
	}
	
	void(^judeBlock)(UGCommonLotteryController * lotteryVC) = ^(UGCommonLotteryController * lotteryVC) {
		if ([@[@"7", @"11", @"9"] containsObject: model.gameId]) {
			lotteryVC.shoulHideHeader = true;
		}
		UGNextIssueModel * nextIssueModel = [UGNextIssueModel new];
		nextIssueModel.gameId = model.gameId;
		nextIssueModel.title = model.title;
		lotteryVC.model = nextIssueModel;
		lotteryVC.allList = self.lotteryGamesArray;
	};
	
	
	if ([@"cqssc" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
		UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
		lotteryVC.gameId = model.gameId;
		lotteryVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(lotteryVC);
		[self.navigationController pushViewController:lotteryVC animated:YES];
	} else if ([@"pk10" isEqualToString:model.gameType] ||
			  [@"xyft" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
		UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(markSixVC);
		
		[self.navigationController pushViewController:markSixVC animated:YES];
		
	} else if ([@"qxc" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
		UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
		sevenVC.gameId = model.gameId;
		sevenVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(sevenVC);
		
		[self.navigationController pushViewController:sevenVC animated:YES];
		
	} else if ([@"lhc" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGHKLHCLotteryController" bundle:nil];
		UGHKLHCLotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(markSixVC);

		[self.navigationController pushViewController:markSixVC animated:YES];
		
	} else if ([@"jsk3" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGJSK3LotteryController" bundle:nil];
		UGJSK3LotteryController *fastThreeVC = [storyboard instantiateInitialViewController];
		fastThreeVC.gameId = model.gameId;
		fastThreeVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(fastThreeVC);

		[self.navigationController pushViewController:fastThreeVC animated:YES];
	} else if ([@"pcdd" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPCDDLotteryController" bundle:nil];
		UGPCDDLotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(PCVC);

		[self.navigationController pushViewController:PCVC animated:YES];
		
	} else if ([@"gd11x5" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGD11X5LotteryController" bundle:nil];
		UGGD11X5LotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(PCVC);

		[self.navigationController pushViewController:PCVC animated:YES];
		
	} else if ([@"xync" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGXYNCLotteryController" bundle:nil];
		UGXYNCLotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(PCVC);

		[self.navigationController pushViewController:PCVC animated:YES];
		
	} else if ([@"bjkl8" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJKL8LotteryController" bundle:nil];
		UGBJKL8LotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(PCVC);

		[self.navigationController pushViewController:PCVC animated:YES];
		
	} else if ([@"gdkl10" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGDKL10LotteryController" bundle:nil];
		UGGDKL10LotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(PCVC);

		[self.navigationController pushViewController:PCVC animated:YES];
		
	} else if ([@"fc3d" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFC3DLotteryController" bundle:nil];
		UGFC3DLotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(markSixVC);

		[self.navigationController pushViewController:markSixVC animated:YES];
		
	} else if ([@"pk10nn" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPK10NNLotteryController" bundle:nil];
		UGPK10NNLotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(markSixVC);

		[self.navigationController pushViewController:markSixVC animated:YES];
	} else {
		// 进入第三方游戏
		if (model.url && ![model.url isEqualToString:@""]) {
			NSURL * url = [NSURL URLWithString:model.url];
			if (url.scheme == nil) {
				url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", model.url]];
			}
			SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:url];
			[self presentViewController:sf animated:YES completion:nil];
		} else if (model.subType.count > 0) {
			UGGameListViewController *gameListVC = [[UGGameListViewController alloc] init];
			gameListVC.game = model;
			[self.navigationController pushViewController:gameListVC animated:YES];
		} else {
			[self getGotoGameUrl:model];
		}
	}
}

- (void)setupSubView {
	UGHomeTitleView *titleView = [[UGHomeTitleView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 50)];
	self.navigationItem.titleView = titleView;
	self.titleView = titleView;
	WeakSelf
	self.titleView.moreClickBlock = ^{
		[weakSelf rightBarBtnClick];
	};
	self.titleView.tryPlayClickBlock = ^{
		[weakSelf tryPlayClick];
	};
	self.titleView.loginClickBlock = ^{
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
	};
	self.titleView.registerClickBlock = ^{
		[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGRegisterViewController") animated:YES];
	};
	self.titleView.userNameTouchedBlock = ^{
		[weakSelf.tabBarController setSelectedIndex:4];
	};
	
	if (UGLoginIsAuthorized()) {
		self.titleView.showLoginView = NO;
		self.titleView.userName = UserI.username;
	}
	//    self.bannerBgViewHeightConstraint.constant = UGScreenW * 0.5;
	//	self.rankingViewHeightConstraints.constant = UGScreenW;
	//	self.scrollContentHeightConstraints.constant = CGRectGetMaxY(self.rankingView.frame);
	//	self.scrollView.contentSize = CGSizeMake(UGScreenW, self.scrollContentHeightConstraints.constant);
	
	if (self.nolineLabel == nil) {
		UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(UGScreenW-140, 5, 140, 30)];
		text.backgroundColor = RGBA(27, 38, 116,0.5);
		text.textColor = [UIColor whiteColor];
		text.font = [UIFont systemFontOfSize:12];
		text.numberOfLines = 1;
		text.text = @"当前在线人数:10000";
		text.textAlignment= NSTextAlignmentCenter;
		text.layer.cornerRadius = 15;
		text.layer.masksToBounds = YES;
		[self.view addSubview:text];
		self.nolineLabel = text;
		[self.nolineLabel setHidden:YES];
	}
	
	
	self.scrollView.scrollEnabled = YES;
	self.scrollView.bounces = YES;
	//	self.scrollView.backgroundColor = UGBackgroundColor;
//	self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:self.bannerBgView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UGScreenW, 280/640.0 * APP.Width) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
	self.bannerView.backgroundColor = [UIColor clearColor];
	self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
	self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	self.bannerView.autoScrollTimeInterval = 2.0;
	self.bannerView.delegate = self;
	[self.bannerBgView addSubview:self.bannerView];
    
    
	self.leftwardMarqueeView.direction = UUMarqueeViewDirectionLeftward;
	self.leftwardMarqueeView.delegate = self;
	self.leftwardMarqueeView.timeIntervalPerScroll = 0.5f;
	self.leftwardMarqueeView.scrollSpeed = 60.0f;
	self.leftwardMarqueeView.itemSpacing = 20.0f;
	self.leftwardMarqueeView.touchEnabled = YES;
	self.leftwardMarqueeView.backgroundColor = [UIColor whiteColor];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNoticeInfo)];
	[self.leftwardMarqueeView addGestureRecognizer:tap];
	
	self.upwardMultiMarqueeView.direction = UUMarqueeViewDirectionUpward;
	self.upwardMultiMarqueeView.timeIntervalPerScroll = 0.0f;
	self.upwardMultiMarqueeView.scrollSpeed = 10.f;
	self.upwardMultiMarqueeView.useDynamicHeight = YES;
	self.upwardMultiMarqueeView.touchEnabled = YES;
	self.upwardMultiMarqueeView.delegate = self;
	
}

- (NSMutableArray *)leftwardMarqueeViewData {
	if (_leftwardMarqueeViewData == nil) {
		_leftwardMarqueeViewData = [NSMutableArray array];
	}
	return _leftwardMarqueeViewData;
}

- (NSMutableArray *)popNoticeArray {
	if (_popNoticeArray == nil) {
		_popNoticeArray = [NSMutableArray array];
	}
	return _popNoticeArray;
}

- (NSMutableArray *)gameCategorys {
	if (_gameCategorys == nil) {
		_gameCategorys = [NSMutableArray array];
	}
	return _gameCategorys;
}
#pragma mark - 其他按钮事件
// 查看更多优惠活动
- (IBAction)onShowMorePromoteBtnClick:(UIButton *)sender {
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
}
- (IBAction)goPCVC:(id)sender {
    BOOL isLogin = UGLoginIsAuthorized();
    if (isLogin) {
       
        TGWebViewController *qdwebVC = [[TGWebViewController alloc] init];
        qdwebVC.url = pcUrl;
        qdwebVC.webTitle = UGSystemConfigModel.currentConfig.webName;
        [self.navigationController pushViewController:qdwebVC  animated:YES];
        
        NSLog(@"pcUrl = %@",pcUrl);
    }
    else {
         SANotificationEventPost(UGNotificationShowLoginView, nil);
    }
}
- (IBAction)goYOUHUIVC:(id)sender {
    BOOL isLogin = UGLoginIsAuthorized();
    if (isLogin) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Promote" bundle:nil];
        UGPromotionsController *qdwebVC = [storyboard instantiateViewControllerWithIdentifier:@"UGPromotionsController"];
        [self.navigationController pushViewController:qdwebVC  animated:YES];
    }
    else {
         SANotificationEventPost(UGNotificationShowLoginView, nil);
    }
   
}
- (IBAction)historyAcion:(id)sender {

    
}
- (IBAction)voiceAction:(id)sender {
}
- (IBAction)loteryValueChange:(id)sender {
    
    [self.lotteryCollectionView reloadData];
}

@end
