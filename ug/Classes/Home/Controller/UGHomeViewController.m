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
#import "UGMissionCenterViewController.h"   // 任务中心
#import "UGLotteryHomeController.h"  // 彩票大厅
#import "UGYYLotterySecondHomeViewController.h" //展示购彩，真人大厅
#import "UGPostListVC.h"    // 六合帖子列表
#import "UGDocumentListVC.h"// 六合期数列表
#import "LHGalleryListVC1.h"   // 六合图库（样式1）
#import "LHGalleryListVC2.h"   // 六合图库（样式2）
#import "LHJournalDetailVC.h"   // 期刊详情
#import "UGPostDetailVC.h"      // 帖子详情


//测试--黑色模板
#import "UGfinancialViewViewController.h"

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
#import "FLAnimatedImageView.h"
#import "UGBMHeaderView.h"

// 六合View
//#import "UGLHLotteryCollectionViewCell.h"
#import "UGLHHomeContentCollectionViewCell.h"
#import "UGScratchMusicView.h"
#import "LHPostPayView.h"

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
#import "UGLHCategoryListModel.h"
#import "UGLHlotteryNumberModel.h"
#import "UGYYPlatformGames.h"
#import "UGhomeAdsModel.h"

// Tools
#import "UIImageView+WebCache.h"
#import "CMCommon.h"
#import "UGonlineCount.h"
#import <SafariServices/SafariServices.h>
#import "UIImage+YYgradientImage.h"
#import "SGBrowserView.h"
#import "CMLabelCommon.h"
#import "CMTimeCommon.h"
#import "CountDown.h"
#import "Global.h"
#import "CMAudioPlayer.h"

@interface UGHomeViewController ()<SDCycleScrollViewDelegate,UUMarqueeViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>

@property (nonatomic, strong) UGHomeTitleView *titleView;       /**<   自定义导航条 */
@property (weak, nonatomic) IBOutlet UGBMHeaderView *headerView;/**<   黑色模板导航头 */

@property (nonatomic, strong) UGYYRightMenuView *yymenuView;    /**<   侧边栏 */

@property (nonatomic, strong) UILabel *nolineLabel;             /**<   在线人数Label */
@property (nonatomic, strong) UGonlineCount *mUGonlineCount;    /**<   在线人数数据 */

@property (nonatomic, strong)  UGredEnvelopeView *uGredEnvelopeView;    /**<   红包浮动按钮 */
@property (nonatomic, strong)  UGredActivityView *uGredActivityView;    /**<   红包弹框 */

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;       /**<   最外层的ScrollView */
@property (weak, nonatomic) IBOutlet UIStackView *contentStackView;         /**<   contentScrollView的子视图StackView */

@property (weak, nonatomic) IBOutlet UIView *bannerBgView;                  /**<   横幅背景View */
@property (nonatomic, strong) SDCycleScrollView *bannerView;                /**<   横幅View */
@property (nonatomic, strong) NSArray <UGBannerCellModel *> *bannerArray;   /**<   横幅数据 */

@property (weak, nonatomic) IBOutlet UGGameNavigationView *gameNavigationView;      /**<   游戏导航父视图 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameNavigationViewHeight;  /**<   游戏导航Height约束 */

@property (weak, nonatomic) IBOutlet UGGameTypeCollectionView *gameTypeView;        /**<   游戏列表 */
@property (nonatomic, strong) NSMutableArray<GameCategoryModel *> *gameCategorys;   /**<   游戏列表数据 */

@property (weak, nonatomic) IBOutlet UIView *promotionView;                         /**<   优惠活动 view*/
@property (weak, nonatomic) IBOutlet UIStackView *promotionsStackView;              /**<   优惠活动 */

@property (weak, nonatomic) IBOutlet UIView *rollingView;                           /**<   跑马灯父视图 */
@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView;            /**<   跑马灯 */
@property (nonatomic, strong) NSMutableArray <NSString *> *leftwardMarqueeViewData; /**<   跑马灯数据 */
@property (nonatomic, strong) UGNoticeTypeModel *noticeTypeModel;                   /**<   点击跑马灯弹出的数据 */

@property (nonatomic, strong) UGPlatformNoticeView *notiveView;                     /**<   平台公告View */
@property (nonatomic, strong) NSMutableArray <UGNoticeModel *> *popNoticeArray;     /**<   公告数据 */

@property (weak, nonatomic) IBOutlet UIView *rankingView;                   /**<   中奖排行榜父视图 */
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;                    /**<   中奖排行标题Label */
@property (weak, nonatomic) IBOutlet UUMarqueeView *upwardMultiMarqueeView; /**<   中奖排行榜 */
@property (nonatomic, strong) UGRankListModel *rankListModel;               /**<   中奖排行榜数据 */
@property (nonatomic, strong) NSArray<UGRankModel *> *rankArray;            /**<   中奖排行榜数据 */

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;  /**<   底部商标Label */
@property (weak, nonatomic) IBOutlet UIView *bottomView;    /**<   底部商标ContentView */
    
@property (weak, nonatomic) IBOutlet UILabel *bottomTitle;  /**<   底部内容文字 */
@property (weak, nonatomic) IBOutlet UIButton *preferentialBtn;/**<   底部优惠按钮 */

@property (weak, nonatomic) IBOutlet UIView *homeAdsBigBgView;           /**<   首页广告图片大背景View */
@property (nonatomic, strong) NSArray <UGhomeAdsModel *> *homeAdsArray;   /**<   首页广告图片 */
@property (weak, nonatomic) IBOutlet UIView *homeAdsBgView;                  /**<   首页广告图片背景View */
@property (nonatomic, strong) SDCycleScrollView *homeAdsView;                /**<   首页广告图片View */
//-------------------------------------------
//六合
@property (weak, nonatomic) IBOutlet UIView *liuheResultContentView;                    /**<   六合开奖View*/

@property (weak, nonatomic) IBOutlet UILabel *lotteryTitleLabel;                        /**<   XX期开奖结果*/
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;                               /**<   咪*/
@property (weak, nonatomic) IBOutlet UICollectionView *lotteryCollectionView;           /**<  开奖的显示*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                                /**<  开奖的时间显示*/
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;                           /**<  开奖的倒计时显示*/
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;           /**<  论坛，专帖XXX显示*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;        /**<  contentCollectionView 的约束高*/
@property (weak, nonatomic) IBOutlet UISwitch *lotteryUISwitch;                         /**<   六合switch*/
@property (weak, nonatomic) IBOutlet UIView *liuheForumContentView;                     /**<   六合板块View*/
@property (weak, nonatomic) IBOutlet UIImageView *hormImgV;                             /**<  喇叭图片*/
@property (weak, nonatomic) IBOutlet UILabel *lottyLabel;                               /**<  开奖提示文字*/

@property (nonatomic, strong) NSMutableArray<UGLHCategoryListModel *> *lHCategoryList;   /**<   栏目列表数据 */
@property (nonatomic, strong) UGLHlotteryNumberModel *lhModel;
@property (strong, nonatomic)  CountDown *countDownForLabel;                            /**<   倒计时工具*/
@property (nonatomic)  BOOL hormIsOpen;                                                /**<  喇叭是否开启*/
@property (nonatomic,strong)  CMAudioPlayer *player ;                                  /**<  播放器*/
@property (strong, nonatomic) NSTimer *timer;
//--------------------------------------------

@end

@implementation UGHomeViewController
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [_countDownForLabel destoryTimer];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)skin {
    
//    return;
    FastSubViewCode(self.view);
    
    // 根据模板显示对应内容
    {
        static NSMutableArray *allViews = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            allViews = @[].mutableCopy;
        });
        for (UIView *v in _contentStackView.arrangedSubviews) {
            if (![allViews containsObject:v]) {
                [allViews addObject:v];
            }
            [v removeFromSuperview];
        }
        NSDictionary *dict = @{@"六合资料":@[_rollingView, _liuheResultContentView, _liuheForumContentView, _promotionView, _bottomView],
                               @"黑色模板":@[_bannerBgView, _gameTypeView.superview, _rankingView, _bottomView],
        };
        
        NSArray *views = dict[Skin1.skitType];
        if (views.count) {
            [_contentStackView addArrangedSubviews:views];
        } else {
            // 默认展示内容
            [_contentStackView addArrangedSubviews:@[_bannerBgView, _rollingView, _gameNavigationView.superview,_homeAdsBigBgView, _gameTypeView.superview, _promotionView, _rankingView, _bottomView]];
            
            // c134在导航栏下添加一张动图
            if ([APP.SiteId containsString:@"c134"]) {
                UIView *v = [UIView new];
                v.backgroundColor = [UIColor clearColor];
                CGFloat h = (APP.Width-20)/1194.0 * 247;
                [v addSubview:({
                    FLAnimatedImageView *imgView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(10, 10, APP.Width-20, h)];
                    [imgView sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"cplts_看图王" withExtension:@"gif"]];
                    imgView;
                })];
                [_contentStackView insertArrangedSubview:v atIndex:3];
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(APP.Width);
                    make.height.mas_equalTo(h+10);
                }];
            }
        }
    }
    // l001站点定制需求
    if ([APP.SiteId containsString:@"l001"]) {
        if (Skin1.isLH) {
            self.bottomTitle.text = @"💻电脑版";
            [self.preferentialBtn setHidden:YES];
        } else {
            self.bottomTitle.text = @"💻电脑版 🎁优惠活动";
            [self.preferentialBtn setHidden:NO];
        }
    }
    else{
        self.bottomTitle.text = @"💻电脑版 🎁优惠活动";
        [self.preferentialBtn setHidden:NO];
    }
    
    
    // 黑色模板的UI调整
    BOOL isBlack = Skin1.isBlack;
    _rollingView.backgroundColor = isBlack ? Skin1.bgColor : Skin1.navBarBgColor;
    _rankingView.backgroundColor = isBlack ? Skin1.bgColor : Skin1.navBarBgColor;
    _gameTypeView.cc_constraints.top.constant = isBlack ? 0 : 10;
    _headerView.hidden = !isBlack;
    self.fd_prefersNavigationBarHidden = isBlack;
    if (NavController1.topViewController == self) {
        self.navigationController.navigationBarHidden = isBlack;
    }
    [self.gameNavigationView reloadData];
}

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leftwardMarqueeView start];
    [self.upwardMultiMarqueeView start];
    
    self.titleView.imgName = SysConf.mobile_logo;
    if (_timer) {
        [_timer setFireDate:[NSDate date]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.leftwardMarqueeView pause];//fixbug  发热  掉电快
    [self.upwardMultiMarqueeView pause];//fixbug  发热  掉电快
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FastSubViewCode(self.view);
    
    __weakSelf_(__self);
    // 配置通知事件
    {
        // 换肤
        SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
            [__self skin];
        });
        // 免费试玩
        SANotificationEventSubscribe(UGNotificationTryPlay, self, ^(typeof (self) self, id obj) {
            [__self tryPlayClick];
        });
        // 去登录
        [self xw_addNotificationForName:UGNotificationShowLoginView block:^(NSNotification * _Nonnull noti) {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
        }];
        // 登录成功
        SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
            [__self getUserInfo];
            __self.titleView.showLoginView = NO;
            
        });
        // 退出登陆
        SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
            [__self userLogout];
        });
        // 登录超时
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            // onceToken 函数的作用是，限制为只弹一次框，修复弹框多次的bug
            if (OBJOnceToken(UGUserModel.currentUser)) {
                UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"您的账号已经登录超时，请重新登录。" btnTitles:@[@"确定"]];
                [ac setActionAtTitle:@"确定" handler:^(UIAlertAction *aa) {
                    __self.titleView.showLoginView = YES;
                    UGUserModel.currentUser = nil;
                    [__self.tabBarController setSelectedIndex:0];
                    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
                }];
            }
        });
        // 获取用户信息成功
        SANotificationEventSubscribe(UGNotificationGetUserInfo, self, ^(typeof (self) self, id obj) {
            [__self getUserInfo];
        });
        // 获取系统配置成功
        SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
            NSInteger cnt = 0;
            for (UIView *v in __self.promotionsStackView.arrangedSubviews) {
                cnt += !v.hidden;
            }
            __self.promotionView.hidden = !SysConf.m_promote_pos || !cnt;
        });
    }
    
    // 配置初始UI
    {
        subImageView(@"公告图标ImageView").image = [[UIImage imageNamed:@"notice"] qmui_imageWithTintColor:Skin1.textColor1];
        subImageView(@"优惠活动图标ImageView").image = [[UIImage imageNamed:@"礼品-(1)"] qmui_imageWithTintColor:Skin1.textColor1];
        subLabel(@"优惠活动标题Label").textColor = Skin1.textColor1;
        [subButton(@"查看更多优惠活动Button") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        self.gameNavigationView.layer.cornerRadius = 8;
        self.gameNavigationView.layer.masksToBounds = true;
        self.gameNavigationView.layer.borderWidth = 1;
        self.gameNavigationView.layer.borderColor = Skin1.homeContentColor.CGColor;
        
        [self.view setBackgroundColor: Skin1.bgColor];
        [self.rankingView setBackgroundColor:Skin1.navBarBgColor];
        [self.upwardMultiMarqueeView setBackgroundColor:Skin1.homeContentColor];
        [self.rollingView setBackgroundColor:Skin1.homeContentColor];
        [self.gameNavigationView setBackgroundColor:Skin1.homeContentColor];
        [self.gameTypeView setBackgroundColor:Skin1.bgColor];
        [self.bottomView setBackgroundColor:Skin1.navBarBgColor];
        
        [self setupSubView];

        [self skin];
        
        {//六合
            if ([Skin1.skitType isEqualToString:@"六合资料"]) {
                _hormIsOpen = YES;
                [_lotteryUISwitch setOn:SysConf.lhcdocMiCard] ;
                
                _countDownForLabel = [[CountDown alloc] init];
                _lHCategoryList = [NSMutableArray<UGLHCategoryListModel *> new];
                _player = [[CMAudioPlayer alloc] init];
                [self initLHCollectionView];
            }
           
        }
        
        self.gameTypeView.gameItemSelectBlock = ^(GameModel * _Nonnull game) {
            [NavController1 pushViewControllerWithGameModel:game];
        };
    }
    
    // 红包事件
    {
        self.uGredEnvelopeView = [[UGredEnvelopeView alloc] initWithFrame:CGRectMake(UGScreenW-100, 150, 95, 95) ];
        [self.view addSubview:_uGredEnvelopeView];
        [self.uGredEnvelopeView setHidden:YES];
        [self.uGredEnvelopeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(__self.view.mas_right).with.offset(-10);
            make.width.mas_equalTo(95.0);
            make.height.mas_equalTo(95.0);
            make.top.equalTo(__self.view.mas_top).offset(150);
        }];
        self.uGredEnvelopeView.cancelClickBlock = ^(void) {
            [__self.uGredEnvelopeView setHidden:YES];
        };
        
        // 红包弹框
        self.uGredEnvelopeView.redClickBlock = ^(void) {
            //        [__self.uGredEnvelopeView setHidden:YES];
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
                    __self.uGredEnvelopeView.item = (UGRedEnvelopeModel*)model.data;
                    
                    __self.uGredActivityView = [[UGredActivityView alloc] initWithFrame:CGRectMake(20,100, UGScreenW-50, UGScreenW-50+150) ];
                    __self.uGredActivityView.item = __self.uGredEnvelopeView.item;
                    if (__self.uGredEnvelopeView.item) {
                        [__self.uGredActivityView show];
                    }
                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
        };
    }
	
    // c200、c035站点定制需求
    if ([APP.SiteId containsString:@"c200"] || [APP.SiteId containsString:@"c035"]) {
        FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(APP.Width-100, 300, 100, 100)];
        gifImageView.contentMode = UIViewContentModeScaleAspectFit;
        gifImageView.userInteractionEnabled = true;
        [self.view addSubview:gifImageView];
        [gifImageView sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"lxb" withExtension:@"gif"]];
        [gifImageView addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController") animated:true];
        }];
    }
    
	// 拉取数据
	_contentScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[__self getSystemConfig];     // APP配置信息
		[__self getBannerList];       // Banner图
        if (__self.notiveView == nil) {
            [__self getNoticeList];   // 公告列表
        }
		[__self getUserInfo];         // 用户信息
		[__self getCheckinListData];  // 红包数据
		[__self systemOnlineCount];   // 在线人数
        [__self getPromoteList];      // 优惠活动
        [__self getRankList];         // 投注排行榜/中奖排行榜
        [__self gethomeAdsList];      //首页广告图片
        
        if ([Skin1.skitType isEqualToString:@"六合资料"]) {
            [__self getCategoryList];     //栏目列表
            [__self getLotteryNumberList];//当前开奖信息
            [__self getPlatformGamesWithParams];//购彩大厅信息
        }
      
        
	}];
    if (_contentScrollView.mj_header.refreshingBlock) {
        _contentScrollView.mj_header.refreshingBlock();
    }
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}


#pragma mark - 六合方法
- (void)initLHCollectionView {
//六合内容
    WSLWaterFlowLayout * _flow;
    _flow = [[WSLWaterFlowLayout alloc] init];
    _flow.delegate = self;
    _flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
//    self.contentCollectionView.backgroundColor = RGBA(221, 221, 221, 1);
      self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.tagString= @"六合内容";
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"UGLHHomeContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [CMCommon setBorderWithView:self.contentCollectionView top:YES left:YES bottom:NO right:YES borderColor:RGBA(221, 221, 221, 1) borderWidth:1];
    [self.contentCollectionView setCollectionViewLayout:_flow];
//六合开奖
    self.lotteryCollectionView.backgroundColor = [UIColor whiteColor];
    self.lotteryCollectionView.dataSource = self;
    self.lotteryCollectionView.delegate = self;
    self.lotteryCollectionView.tagString= @"六合开奖";
//    [self.lotteryCollectionView registerNib:[UINib nibWithNibName:@"UGLHLotteryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGLHLotteryCollectionViewCell"];
//    [self.lotteryCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.lotteryCollectionView setBounces:NO];
    [self.lotteryCollectionView setScrollEnabled:NO];
    
}
#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

     float itemW = (UGScreenW-1)/ 2.0;
     CGSize size = {itemW, 100};
     return size;
       
   
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}
/** 行数*/
//-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
//    return 5;
//}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 0;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 0;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{

    return UIEdgeInsetsMake(0, 0, 0,0);
}



#pragma mark UICollectionView datasource
////组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 
    return 1;

}
//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int rows = 0;
    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
         rows = (int)_lHCategoryList.count;
    } else {
        if (_lhModel.numbersArrary.count<5) {
             rows = (int)_lhModel.numbersArrary.count;
        } else {
             rows = (int)_lhModel.numbersArrary.count+1;
        }
       
//        rows = 8;
    }
    return rows;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
        UGLHHomeContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UGLHCategoryListModel *model = [self.lHCategoryList objectAtIndex:indexPath.row];
        FastSubViewCode(cell);
        [subImageView(@"图片ImgV") sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
        [subLabel(@"标题Label") setText:model.name];
        [subLabel(@"详细Label") setText:model.desc];
        
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"hot_01" ofType:@"gif"];
//        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
//        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        [model.isHot isEqualToString:@"1"] ? [subButton(@"hotButton") setHidden:NO] : [subButton(@"hotButton") setHidden:YES];
        [cell setBackgroundColor: [UIColor whiteColor]];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [RGBA(221, 221, 221, 1) CGColor];
        return cell;
    } else {
      UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//        if (OBJOnceToken(cell)) {
//            UGLHLotteryCollectionViewCell *c = _LoadView_from_nib_(@"UGLHLotteryCollectionViewCell");
//            c.tagString = @"cell";
//            [cell addSubview:c];
//            [c mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(cell);
//            }];
//        }
//        cell = [cell viewWithTagString:@"cell"];
        
    //        NSDictionary *dic = [self.menuNameArray objectAtIndex:indexPath.row];
       
        FastSubViewCode(cell);
        if (indexPath.row <= 5) {
            subLabel(@"球下字").text =  [_lhModel.numSxArrary objectAtIndex:indexPath.row];
            subLabel(@"球内字").text =  [_lhModel.numbersArrary objectAtIndex:indexPath.row];
            [subImageView(@"球图") setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", [_lhModel.numColorArrary objectAtIndex:indexPath.row]]]];
        }
        if (indexPath.row == 7) {
            subLabel(@"球下字").text =  [_lhModel.numSxArrary objectAtIndex:indexPath.row-1];
            subLabel(@"球内字").text =  [_lhModel.numbersArrary objectAtIndex:indexPath.row-1];
            [subImageView(@"球图") setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", [_lhModel.numColorArrary objectAtIndex:indexPath.row-1]]]];
        }
        

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
            [subButton(@"刮刮乐") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                NSLog(@"---");
                NSString *imgStr = [NSString stringWithFormat:@"icon_%@",[self->_lhModel.numColorArrary objectAtIndex:indexPath.row-1]];
                NSString *titileStr = [self->_lhModel.numbersArrary objectAtIndex:indexPath.row-1];
                NSString *titile2Str = [self->_lhModel.numSxArrary objectAtIndex:indexPath.row-1];
                UGScratchMusicView *inviteView = [[UGScratchMusicView alloc] initViewWithImgStr:imgStr upTitle:titileStr downTitle:titile2Str bgColor:[self->_lhModel.numColorArrary objectAtIndex:indexPath.row-1]];
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
////cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView.tagString isEqualToString:@"六合开奖"]) {

        CGSize size = {40, 70};
        return size;
    } else {
        float itemW = (UGScreenW)/ 2.0;
        CGSize size = {itemW, 100};
        return size;
    }
}
////item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
        UGLHCategoryListModel *model = [self.lHCategoryList objectAtIndex:indexPath.row];
        if ([model.alias isEqualToString:@"forum"]) {
            UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"高手论坛");
        }
        else if([model.alias isEqualToString:@"gourmet"]) {
            UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"极品专贴");
        }
        else if([model.alias isEqualToString:@"mystery"]) {
            UGDocumentListVC *vc = _LoadVC_from_storyboard_(@"UGDocumentListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"每期资料");
        }
        else if([model.alias isEqualToString:@"rule"]) {
            UGDocumentListVC *vc = _LoadVC_from_storyboard_(@"UGDocumentListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"公式规律");
        }
        else if([model.alias isEqualToString:@"sixpic"]) {
            LHGalleryListVC2 *vc = _LoadVC_from_storyboard_(@"LHGalleryListVC2");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"六合图库");
        }
        else if([model.alias isEqualToString:@"humorGuess"]) {
            LHJournalDetailVC *vc = _LoadVC_from_storyboard_(@"LHJournalDetailVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"幽默猜测");
        }
        else if([model.alias isEqualToString:@"rundog"]) {
            LHJournalDetailVC *vc = _LoadVC_from_storyboard_(@"LHJournalDetailVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"跑狗玄机");
        }
        else if([model.alias isEqualToString:@"fourUnlike"]) {
            LHJournalDetailVC *vc = _LoadVC_from_storyboard_(@"LHJournalDetailVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"四不像");
        }
        else if([model.alias isEqualToString:@"yellowCale"]) {
            NSLog(@"老黃历");
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLHOldYearViewController") animated:true];
        }
        else if([model.alias isEqualToString:@"CvB3zABB"]) {
            LHJournalDetailVC *vc = _LoadVC_from_storyboard_(@"LHJournalDetailVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"香港挂牌");
        }
        else {
            if (model.contentId.length) {
                // 获取帖子详情
                [SVProgressHUD showWithStatus:nil];
                [NetworkManager1 lhdoc_contentDetail:model.contentId].completionBlock = ^(CCSessionModel *sm) {
                    [SVProgressHUD dismiss];
                    if (!sm.error) {
                        UGLHPostModel *pm = [UGLHPostModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
                        
                        void (^push)(void) = ^{
                            UGPostDetailVC *vc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
                            vc.pm = pm;
                            vc.title = model.name;
                            [NavController1 pushViewController:vc animated:true];
                        };
                        if (!pm.hasPay && pm.price > 0.000001) {
                            LHPostPayView *ppv = _LoadView_from_nib_(@"LHPostPayView");
                            ppv.pm = pm;
                            ppv.didConfirmBtnClick = ^(LHPostPayView * _Nonnull ppv) {
                                if (!UGLoginIsAuthorized()) {
                                    [ppv hide:nil];
                                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                                    return;
                                }
                                [NetworkManager1 lhcdoc_buyContent:pm.cid].completionBlock = ^(CCSessionModel *sm) {
                                    if (!sm.error) {
                                        pm.hasPay = true;
                                        [ppv hide:nil];
                                        UIAlertController *ac = [AlertHelper showAlertView:@"支付成功" msg:nil btnTitles:@[@"确定"]];
                                        [ac setActionAtTitle:@"确定" handler:^(UIAlertAction *aa) {
                                            push();
                                        }];
                                    }
                                };
                            };
                            [ppv show];
                        } else {
                            push();
                        }
                    }
                };
                return;
            }
            BOOL ret = [NavController1 pushViewControllerWithLinkCategory:7 linkPosition:model.appLinkCode];
            if (!ret && model.appLink.length) {
                TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
                webViewVC.url = model.appLink;
                webViewVC.webTitle = model.name;
                [NavController1 pushViewController:webViewVC animated:YES];
            }
        }
    }
}


- (void)getUserInfo {
	if (!UGLoginIsAuthorized()) {
		return;
	}
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
	[CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[self.contentScrollView.mj_header endRefreshing];
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

// 彩票大厅数据
- (void)getAllNextIssueData {
	[SVProgressHUD showWithStatus: nil];
	[CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[SVProgressHUD dismiss];
		[CMResult processWithResult:model success:^{
            UGAllNextIssueListModel.lotteryGamesArray = model.data;
		} failure:nil];
	}];
}

// 自定义游戏列表
- (void)getCustomGameList {
	[SVProgressHUD showWithStatus: nil];
	[CMNetwork getCustomGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.contentScrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			[SVProgressHUD dismiss];
			if (model.data) {
				dispatch_async(dispatch_get_main_queue(), ^{
					GameCategoryDataModel *customGameModel = GameCategoryDataModel.gameCategoryData = (GameCategoryDataModel *)model.data;
                    
                    // 首页导航
					NSArray<GameModel *> *sourceData = customGameModel.navs;
                    self.gameNavigationView.superview.hidden = !sourceData.count;
					self.gameNavigationView.sourceData = sourceData;
                    // 设置任务大厅页的标题
                    GameModel *gm = [sourceData objectWithValue:@13 keyPath:@"subId"];
                    [UGMissionCenterViewController setTitle:gm.name.length ? gm.name : gm.title];
                    
					if (sourceData.count > 0) {
						self.gameNavigationViewHeight.constant = ((sourceData.count - 1)/5 + 1)*80;
						[self.view layoutIfNeeded];
					}
                    // 游戏列表
					self.gameTypeView.gameTypeArray = self.gameCategorys = customGameModel.icons.mutableCopy;
				});
			}
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

// 获取系统配置
- (void)getSystemConfig {
	[CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.contentScrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			
			NSLog(@"model = %@",model);
			
			UGSystemConfigModel *config = model.data;
			UGSystemConfigModel.currentConfig = config;
            
            if (![Skin1.skitType isEqualToString:@"六合资料"]) {//六合资料
                 [self getCustomGameList];   // 自定义游戏列表
                 [self getAllNextIssueData]; // 彩票大厅数据
            }
            
            [self.lotteryUISwitch setOn:SysConf.lhcdocMiCard] ;
            
//            [[UGSkinManagers skinWithSysConf] useSkin];
            
            NSString *title =[NSString stringWithFormat:@"COPYRIGHT © %@ RESERVED",config.webName];
            [self.bottomLabel setText:title];
			[self.titleView setImgName:config.mobile_logo];
			SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
		} failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

- (void)userLogout {
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
    self.titleView.showLoginView = YES;
    [NavController1 popToRootViewControllerAnimated:true];
    [TabBarController1 setSelectedIndex:0];
}

// 横幅广告
- (void)getBannerList {
	[CMNetwork getBannerListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.contentScrollView.mj_header endRefreshing];
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
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

// 跑马灯数据
- (void)getNoticeList {
	[CMNetwork getNoticeListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.contentScrollView.mj_header endRefreshing];
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
		[self.contentScrollView.mj_header endRefreshing];
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
				} else if (config.rankingListSwitch == 1) {
					self.rankLabel.text = @"中奖排行榜";
				} else if (config.rankingListSwitch == 2) {
					self.rankLabel.text = @"投注排行榜";
				}
                self.rankingView.hidden = !config.rankingListSwitch;
                self.bottomView.backgroundColor = Skin1.isBlack || !config.rankingListSwitch ? [UIColor clearColor] : Skin1.navBarBgColor;
                self.rankLabel.textColor = Skin1.textColor1;
                [self.view layoutIfNeeded];
				[self.upwardMultiMarqueeView reloadData];
			});
			
		} failure:^(id msg) {
			
		}];
	}];
}

//得到红包详情数据
- (void)getCheckinListData {
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
	[SVProgressHUD showWithStatus:nil];
	[CMNetwork activityRedBagDetailWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD dismiss];
		[CMResult processWithResult:model success:^{
            UGRedEnvelopeModel *rem = model.data;
            self.uGredEnvelopeView.item = rem;
            self.uGredEnvelopeView.hidden = !rem;
		} failure:^(id msg) {
            self.uGredEnvelopeView.hidden = true;
			[SVProgressHUD dismiss];
		}];
	}];
}

// APP在线人数
- (void)systemOnlineCount {
	[CMNetwork systemOnlineCountWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.contentScrollView.mj_header endRefreshing];
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
                if (listModel.list.count <= i) {
                    v.hidden = true;
                    continue;
                }
                UGPromoteModel *pm = listModel.list[i++];
                FastSubViewCode(v);
                subLabel(@"优惠活动Label").text = pm.title;
                subLabel(@"优惠活动Label").hidden = !pm.title.length;
                [subImageView(@"优惠活动ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        subImageView(@"优惠活动ImageView").cc_constraints.height.constant = image.height/image.width * (APP.Width - 48);
                    }
                }];
                [subButton(@"优惠活动Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                [subButton(@"优惠活动Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:pm.linkCategory linkPosition:pm.linkPosition];
                    if (!ret) {
                        // 去优惠详情
                        UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
                        detailVC.item = pm;
                        [NavController1 pushViewController:detailVC animated:YES];
                    }
                }];
            }
            __self.promotionView.hidden = !SysConf.m_promote_pos || !listModel.list.count;
        } failure:nil];
    }];
}
//首页广告图片
- (void)gethomeAdsList {
    [SVProgressHUD showWithStatus: nil];
    [CMNetwork systemhomeAdsWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.contentScrollView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                [SVProgressHUD dismiss];
                self.homeAdsArray = model.data;

                NSMutableArray *mutArr = [NSMutableArray array];
                if (self.homeAdsArray.count) {
                    [self.homeAdsBigBgView setHidden:NO];
                    for (UGhomeAdsModel *banner in self.homeAdsArray) {
                        [mutArr addObject:banner.image];
                    }
                    NSLog(@"mutArr = %@",mutArr);
                    self.homeAdsView.imageURLStringsGroup = mutArr.mutableCopy;
//                    self.bannerView.autoScrollTimeInterval = ((UGBannerModel*)model.data).interval.floatValue;
                }
                else{
                    [self.homeAdsBigBgView setHidden:YES];
                }
            });
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            [self.homeAdsBigBgView setHidden:YES];
        }];
    }];
}

#pragma mark ------------六合------------------------------------------------------
// 栏目列表
- (void)getCategoryList {
    
    
    [CMNetwork categoryListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.contentScrollView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            self->_lHCategoryList = [NSMutableArray<UGLHCategoryListModel *> new];
            NSLog(@"model= %@",model.data);
            NSArray *modelArr = (NSArray *)model.data;         //数组转模型数组

            if (modelArr.count==0) {
                 self.heightLayoutConstraint.constant = 0.0;
                return ;
            }
                   
            if (modelArr.count) {
                for (int i = 0 ;i<modelArr.count;i++) {
                    UGLHCategoryListModel *obj = [modelArr objectAtIndex:i];
                   
                    [self->_lHCategoryList addObject:obj];
                    NSLog(@"obj= %@",obj);
                }
            }
            //数组转模型数组
            NSLog(@"self->_lHCategoryList= %@",self->_lHCategoryList);
            FastSubViewCode(self.view)
//            subView(@"开奖结果").hidden = NO;
//            subView(@"六合论坛").hidden = NO;
            // 需要在主线程执行的代码
            [self.contentCollectionView reloadData];
            if (self->_lHCategoryList.count%2==0) {
                 self->_heightLayoutConstraint.constant = self->_lHCategoryList.count/2*101+1;
            } else {
                 self->_heightLayoutConstraint.constant = self->_lHCategoryList.count/2*101+101+1;
            }
           

        } failure:^(id msg) {
            
        }];
    }];
}


//int countkkk  = 0;
// 当前开奖信息
- (void)getLotteryNumberList {

    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork lotteryNumberWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [self.contentScrollView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            self.lhModel = nil;
            NSLog(@"model= %@",model.data);
            self.lhModel = (UGLHlotteryNumberModel *)model.data;
            self.lhModel.numSxArrary = [self->_lhModel.numSx componentsSeparatedByString:@","];
            self.lhModel.numbersArrary = [self->_lhModel.numbers componentsSeparatedByString:@","];
            self.lhModel.numColorArrary = [self->_lhModel.numColor componentsSeparatedByString:@","];
            NSLog(@"count = %lu",(unsigned long)self->_lhModel.numbersArrary.count);
            
            
            NSLog(@"lotteryStr = %@",self.lhModel.lotteryStr);
            
            if ([CMCommon stringIsNull:self.lhModel.lotteryStr]) {
                if (self.lhModel.numbersArrary.count) {
                    [self.lottyLabel setHidden:YES];
                    [self.lotteryCollectionView reloadData];
                }
            }
            else{
                self.lottyLabel.text = self.lhModel.lotteryStr;
                [self.lottyLabel setHidden:NO];
                
            }

#ifdef DEBUG
//            [self testKaiJiang];
//            return ;
#endif
            
            NSString *nper = [self.lhModel.issue  substringFromIndex:4];
            self.lotteryTitleLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",nper];
            [CMLabelCommon setRichNumberWithLabel:self.lotteryTitleLabel Color:[UIColor redColor] FontSize:17.0];
            NSArray *endTimeArray = [self->_lhModel.endtime componentsSeparatedByString:@" "];
            self.timeLabel.text = [endTimeArray objectAtIndex:0];

//            if (countkkk%2) {
//                self.lhModel.endtime = @"2019-12-12 21:55:00";
//            }
//            else{
//                self.lhModel.endtime = @"2019-12-14 21:30:00";
//            }
            NSLog(@"self.lhModel.serverTime = %@",self.lhModel.serverTime);
            NSLog(@"self.lhModel.endtime = %@",self.lhModel.endtime);
            long long startLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.serverTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
            long long finishLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.endtime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
            [self startLongLongStartStamp:startLongLong*1000 longlongFinishStamp:finishLongLong*1000];
//            countkkk ++;
        } failure:^(id msg) {
            
        }];
    }];
}

- (void)getPlatformGamesWithParams {
    [CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [Global getInstanse].lotterydataArray = model.data ;
            NSLog(@"[Global getInstanse].lotterydataArray = %@",[Global getInstanse].lotterydataArray);
        } failure:^(id msg) {
        }];
    }];
}


///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long long)strtLL longlongFinishStamp:(long long)finishLL{
    __weak __typeof(self) weakSelf= self;
    
    if (_countDownForLabel) {
        [_countDownForLabel destoryTimer];
    }
    
    [_countDownForLabel countDownWithStratTimeStamp:strtLL finishTimeStamp:finishLL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {

         [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}

///此方法用两个时间做参数进行倒计时
-(void)startDate:(NSDate *)startDate finishDate:(NSDate *)finishDate{
    __weak __typeof(self) weakSelf= self;
    if (_countDownForLabel) {
        [_countDownForLabel destoryTimer];
    }
    [_countDownForLabel countDownWithStratDate:startDate finishDate:finishDate  completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {

        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}

-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{

    NSString *hourStr = @"";
    NSString *minuStr = @"";
    NSString *secondStr = @"";
    if (day==0) {
        if (hour<10) {
            hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
        }else{
            hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
        }
    }else{
            hour = hour + 24*day;
            hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    }
    if (minute<10) {
        minuStr = [NSString stringWithFormat:@"0%ld",(long)minute];
    }else{
        minuStr = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    if (second<10) {
        secondStr = [NSString stringWithFormat:@"0%ld",(long)second];
    }else{
        secondStr = [NSString stringWithFormat:@"%ld",(long)second];
    }
    
    self.countdownLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuStr,secondStr];
    
    if ([self.countdownLabel.text  isEqualToString:@"00:00:00"]) {
        
        [self lotterTimeAction ];
    }
}
- (void)showPlatformNoticeView {
    if (self.notiveView == nil) {
        
         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!appDelegate.notiveViewHasShow) {
            self.notiveView = [[UGPlatformNoticeView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - APP.StatusBarHeight - APP.BottomSafeHeight - ([APP.SiteId isEqualToString:@"c085"] ? 160 : 200))];
            self.notiveView.dataArray = self.popNoticeArray;
            [self.notiveView.bgView setBackgroundColor: Skin1.navBarBgColor];
            [self.notiveView show];
        }
        appDelegate.notiveViewHasShow = YES;
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
#ifdef DEBUG
//    [[UGSkinManagers next] useSkin];
//    [HUDHelper showMsg:[UGSkinManagers currentSkin].skitString];
//    return;
#endif
    
    if ([cycleScrollView isEqual:self.bannerView]) {
        UGBannerCellModel *banner = self.bannerArray[index];
        BOOL ret = [NavController1 pushViewControllerWithLinkCategory:banner.linkCategory linkPosition:banner.linkPosition];
        if (!ret) {
            if ([banner.url containsString:@"mobile"]) {
                // 若跳转地址包含mobile则不做跳转
                return;
            }
            // 去外部链接
            if ([banner.url stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
                NSLog(@"url = %@",banner.url );
                //            if ([banner.url hasPrefix:@"http"]) {
                if ([banner.url isURL]) {
                    SLWebViewController *webVC = [[SLWebViewController alloc] init];
                    webVC.urlStr = banner.url;
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }
        }
    } else {
        UGhomeAdsModel *banner = self.homeAdsArray[index];
        BOOL ret = [NavController1 pushViewControllerWithLinkCategory:[banner.linkCategory integerValue] linkPosition:[banner.linkPosition integerValue]];
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
        content.textColor = Skin1.textColor1;
		content.text = self.leftwardMarqueeViewData[index];
	} else {
		UGRankModel *rank = self.rankArray[index];
		UILabel *content = [itemView viewWithTag:1001];
		content.text = rank.username;
        content.textColor = Skin1.textColor1;
		
		UILabel *coin = [itemView viewWithTag:1002];
        coin.text = rank.coin.length ? _NSString(@"%@元",rank.coin) : nil;
		
		UILabel *game = [itemView viewWithTag:1004];
		game.text = rank.type;
        game.textColor = Skin1.textColor1;
		
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
		
		[itemView setBackgroundColor:Skin1.homeContentColor];
		
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
	//	self.scrollContentHeightConstraints.constant = CGRectGetMaxY(self.rankingView.frame);
	//	self.scrollView.contentSize = CGSizeMake(UGScreenW, self.scrollContentHeightConstraints.constant);
	
	if (self.nolineLabel == nil) {
		UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(UGScreenW-140, 10, 140, 30)];
		text.backgroundColor = RGBA(27, 38, 116,0.5);
		text.textColor = [UIColor whiteColor];
		text.font = [UIFont systemFontOfSize:12];
		text.numberOfLines = 1;
		text.text = @"当前在线人数:10000";
		text.textAlignment= NSTextAlignmentCenter;
		text.layer.cornerRadius = 15;
		text.layer.masksToBounds = YES;
        text.hidden = true;
		[_bannerBgView addSubview:(_nolineLabel = text)];
	}
	
	
	self.contentScrollView.scrollEnabled = YES;
	self.contentScrollView.bounces = YES;
	//	self.scrollView.backgroundColor = Skin1.bgColor;
//	self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:self.bannerBgView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UGScreenW, 280/640.0 * APP.Width) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
	self.bannerView.backgroundColor = [UIColor clearColor];
	self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
	self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	self.bannerView.autoScrollTimeInterval = 2.0;
	self.bannerView.delegate = self;
    self.bannerView.pageDotColor = RGBA(210, 210, 210, 0.4);
	[self.bannerBgView insertSubview:self.bannerView atIndex:0];
    
    
    self.homeAdsView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UGScreenW-20, 250/1000.0 * (APP.Width-20)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];

    self.homeAdsView.backgroundColor = [UIColor clearColor];
    self.homeAdsView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.homeAdsView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.homeAdsView.autoScrollTimeInterval = 3.0;
    self.homeAdsView.delegate = self;
    self.homeAdsView.pageDotColor = RGBA(210, 210, 210, 0.4);
    [self.homeAdsBgView insertSubview:self.homeAdsView atIndex:0];
    
	self.leftwardMarqueeView.direction = UUMarqueeViewDirectionLeftward;
	self.leftwardMarqueeView.delegate = self;
	self.leftwardMarqueeView.timeIntervalPerScroll = 0.5f;
	self.leftwardMarqueeView.scrollSpeed = 60.0f;
	self.leftwardMarqueeView.itemSpacing = 20.0f;
	self.leftwardMarqueeView.touchEnabled = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNoticeInfo)];
	[self.leftwardMarqueeView addGestureRecognizer:tap];
	
	self.upwardMultiMarqueeView.direction = UUMarqueeViewDirectionUpward;
	self.upwardMultiMarqueeView.timeIntervalPerScroll = 0.0f;
	self.upwardMultiMarqueeView.scrollSpeed = 10.f;
	self.upwardMultiMarqueeView.useDynamicHeight = YES;
	self.upwardMultiMarqueeView.touchEnabled = YES;
	self.upwardMultiMarqueeView.delegate = self;
	
}

- (NSMutableArray<NSString *> *)leftwardMarqueeViewData {
	if (_leftwardMarqueeViewData == nil) {
		_leftwardMarqueeViewData = [NSMutableArray array];
	}
	return _leftwardMarqueeViewData;
}

- (NSMutableArray<UGNoticeModel *> *)popNoticeArray {
	if (_popNoticeArray == nil) {
		_popNoticeArray = [NSMutableArray array];
	}
	return _popNoticeArray;
}

- (NSMutableArray<GameCategoryModel *> *)gameCategorys {
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
    TGWebViewController *qdwebVC = [[TGWebViewController alloc] init];
    qdwebVC.url = pcUrl;
    qdwebVC.webTitle = UGSystemConfigModel.currentConfig.webName;
    [NavController1 pushViewController:qdwebVC animated:YES];
}
- (IBAction)goYOUHUIVC:(id)sender {
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController")  animated:YES];
}
- (IBAction)historyAcion:(id)sender {
    UGLotteryRecordController *recordVC = _LoadVC_from_storyboard_(@"UGLotteryRecordController");
    recordVC.gameId = self.lhModel.gameId;
    [NavController1 pushViewController:recordVC animated:true];
    
}
- (IBAction)voiceAction:(UIButton*)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就不开启
        _hormIsOpen = NO;
        [self.hormImgV setImage:[UIImage imageNamed:@"icon_sound02"]];
        [_player pause];
        [_timer setFireDate:[NSDate distantFuture]];
    } else { // 默认开启
        _hormIsOpen = YES;
        [self.hormImgV setImage:[UIImage imageNamed:@"icon_sound01"]];
        [_player continue];
        [_timer setFireDate:[NSDate date]];
    }
}
- (IBAction)loteryValueChange:(id)sender {
    
    [self.lotteryCollectionView reloadData];
}

//倒计时结束时触发
-(void)lotterTimeAction{
    [self.timer invalidate];
    self.timer = nil;
    
    
    [_lottyLabel setHidden:NO];
    _timeLabel.text = @"开奖中";
//    [_timeLabel setTextColor:[UIColor blackColor]];
    _countdownLabel.text = @"开奖中";
//    [_countdownLabel setTextColor:[UIColor blackColor]];
    [self setLhModel:nil];
    
    __weakSelf_(__self);
    __block UGLHlotteryNumberModel *__lastLHModel = nil;
    __block int __count = 0;
    _timer = [NSTimer scheduledTimerWithInterval:6 repeats:true block:^(NSTimer *timer) {
        CCSessionModel * sessionModel = [NetworkManager1 lhdoc_lotteryNumber];
        sessionModel.completionBlock = ^(CCSessionModel *sm) {
            NSNumber *cn = (NSNumber *)sm.responseObject[@"code"];
            if (!sm.error  && [cn intValue] == 0) {
                NSLog(@"model= %@",sm.responseObject[@"code"]);
                NSLog(@"获取开奖信息成功");
                NSLog(@"model= %@",sm.responseObject[@"data"]);
                __self.lhModel = nil;
                
                UGLHlotteryNumberModel *model = (UGLHlotteryNumberModel *)[UGLHlotteryNumberModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
                model.numSxArrary = [model.numSx componentsSeparatedByString:@","];
                model.numbersArrary = [model.numbers componentsSeparatedByString:@","];
                model.numColorArrary = [model.numColor componentsSeparatedByString:@","];
                model.isOpen = __self.lotteryUISwitch.isOn;
                NSLog(@"model = %@",model);
                __self.lhModel = model;
                if (!model) {
                    return ;
                }
                NSLog(@"auto= %d",model.autoBL);
                if (model.autoBL) {
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 需要在主线程执行的代码
                    
                    [__self.lottyLabel setHidden:YES];
                    [__self.lotteryCollectionView reloadData];
                    if (__self.lhModel.issue.length>4) {
                        NSString *nper = [__self.lhModel.issue  substringFromIndex:4];
                        __self.lotteryTitleLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",nper];
                    }
 
                    
                    [CMLabelCommon setRichNumberWithLabel:__self.lotteryTitleLabel Color:[UIColor redColor] FontSize:17.0];
#ifdef DEBUG
//                    if (__count < 7) {
//                        model.isFinish = 0;
//                    }
//                    else{
//                        model.isFinish = 1;
//                    }
#endif
                    if (model.isFinish == 1) {
                        NSArray *endTimeArray = [__self.lhModel.endtime componentsSeparatedByString:@" "];
                        __self.timeLabel.text = [endTimeArray objectAtIndex:0];
                        long long startLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.serverTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
                        long long finishLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.endtime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
                        [__self startLongLongStartStamp:startLongLong*1000 longlongFinishStamp:finishLongLong*1000];
                        
      
                        __lastLHModel = nil;
                        __count = 0;
                        [__self.timer invalidate];
                        __self.timer = nil;
                
                        [__self getLotteryNumberList ];

                    }
                    else
                    {
                        if (__lastLHModel) {
                            if ([CMCommon array:__lastLHModel.numbersArrary isOrderEqualTo:__self.lhModel.numbersArrary] ) {
                                return ;
                            }
                            else
                            {
                                model.count = __count;
                                [__self.player playLH:model ];
                                __lastLHModel = model;
                                __count ++;
                                NSLog(@"__count = %d",__count);
                            }
                        }
                        else{
                            [__self.player playLH:model ];
                            __lastLHModel = model;
                            __count ++;
                            NSLog(@"__count = %d",__count);
                        }

                    }
                    
                });
                
                if (!__self) {
                    __lastLHModel = nil;
                    __count = 0;
                    [__self.timer invalidate];
                    __self.timer = nil;
                }
            }
        };
        sessionModel.failureBlock = ^(NSError *error) {
            
        };
    }];
 
}

-(void)testKaiJiang{
    {//test
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeString = [dateFormatter stringFromDate:currentDate];
        
        NSDate *pastDate= [currentDate dateByAddingTimeInterval:3]; // 半小时前是-1800   1小时后是3600   1小时前是-3600
        NSString *pastTimeString = [dateFormatter stringFromDate:pastDate];
        long long startLongLong = [CMTimeCommon timeSwitchTimestamp:timeString andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        long long finishLongLong = [CMTimeCommon timeSwitchTimestamp:pastTimeString andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        [self startLongLongStartStamp:startLongLong*1000 longlongFinishStamp:finishLongLong*1000];
        
    }
}
@end

