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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameViewHeight;            /**<   游戏列表Height约束 */
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
    
    // 根据模板显示对应内容
    {
        for (UIView *v in _contentStackView.arrangedSubviews) {
            [v removeFromSuperview];
        }
        NSDictionary *dict = @{@"六合资料":@[_bannerBgView, _rollingView, subView(@"开奖结果"), subView(@"六合论坛"), _promotionView, _bottomView],
                               @"黑色模板":@[_bannerBgView, _gameTypeView.superview, _rankingView, _bottomView],
        };
        NSArray *arrangedSubviews = dict[Skin1.skitType];
        if (!arrangedSubviews) {
            // 默认展示内容
            arrangedSubviews = @[_bannerBgView, _rollingView, _gameNavigationView.superview, _gameTypeView.superview, _promotionView, _rankingView, _bottomView];
        }
        for (UIView *v in arrangedSubviews) {
            [_contentStackView addArrangedSubview:v];
        }
    }
    
    // 黑色模板的UI调整
    BOOL isBlack = [Skin1.skitType isEqualToString:@"黑色模板"];
    _rollingView.backgroundColor = isBlack ? Skin1.bgColor : Skin1.navBarBgColor;
    _rankingView.backgroundColor = isBlack ? Skin1.bgColor : Skin1.navBarBgColor;
    _gameTypeView.cc_constraints.top.constant = isBlack ? 0 : 10;
    _headerView.hidden = !isBlack;
    self.fd_prefersNavigationBarHidden = isBlack;
    [self.gameNavigationView reloadData];
}

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

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
            [__self.promotionsStackView superviewWithTagString:@"优惠活动ContentView"].hidden = !SysConf.m_promote_pos;
        });
    }
    
    // 配置初始UI
    {
        subView(@"开奖结果").hidden = YES;
        subView(@"六合论坛").hidden = YES;
        
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
        {//六合
            [self initLHCollectionView];
        }
        [self skin];
        
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
	
    // c200站点定制需求
    if ([APP.SiteId containsString:@"c200"]) {
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
	}];
    if (_contentScrollView.mj_header.refreshingBlock) {
        _contentScrollView.mj_header.refreshingBlock();
    }
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.leftwardMarqueeView start];
    [self.upwardMultiMarqueeView start];
    
    self.titleView.imgName = SysConf.mobile_logo;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[self.leftwardMarqueeView pause];//fixbug  发热  掉电快
	[self.upwardMultiMarqueeView pause];//fixbug  发热  掉电快
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

			[[UGSkinManagers skinWithSysConf] useSkin];
            
            if (![Skin1.skitType isEqualToString:@"六合资料"]) {//六合资料
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
                self.bottomView.backgroundColor = [Skin1.skitType isEqualToString:@"黑色模板"] || !config.rankingListSwitch ? [UIColor clearColor] : Skin1.navBarBgColor;
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
            self.uGredEnvelopeView.hidden = false;
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
                    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:pm.linkCategory linkPosition:pm.linkPosition];
                    if (!ret) {
                        // 去优惠详情
                        UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
                        detailVC.item = pm;
                        [NavController1 pushViewController:detailVC animated:YES];
                    }
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
            [self.notiveView.bgView setBackgroundColor: Skin1.navBarBgColor];
            [self.notiveView show];
        }
        appDelegate.notiveViewHasShow = YES;
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
	UGBannerCellModel *banner = self.bannerArray[index];
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:banner.linkCategory linkPosition:banner.linkPosition];
    if (!ret) {
        if ([banner.url containsString:@"mobile"]) {
            // 若跳转地址包含mobile则不做跳转
            return;
        }
        // 去外部链接
        if ([banner.url stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
            SLWebViewController *webVC = [[SLWebViewController alloc] init];
            webVC.urlStr = banner.url;
            [self.navigationController pushViewController:webVC animated:YES];
        }
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

    
//    #ifdef DEBUG
    {
        //黑色模板财务中心
//                UGfinancialViewViewController *vc = [UGfinancialViewViewController new];
//                [self.navigationController pushViewController:vc  animated:YES];
    }

    {
        //黑色模板优惠专区
//        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBMpreferentialViewController") animated:true];
    }
    {
         //黑色模板登录
//         [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBMLoginViewController") animated:true];
     }
    {
         //黑色模版注册
//         [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBMRegisterViewController") animated:true];
     }
    {
             //黑色模版会员中心
//             [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBMMemberCenterViewController") animated:true];
    }

//    #else
    
        BOOL isLogin = UGLoginIsAuthorized();
        if (isLogin) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Promote" bundle:nil];
            UGPromotionsController *qdwebVC = [storyboard instantiateViewControllerWithIdentifier:@"UGPromotionsController"];
            [self.navigationController pushViewController:qdwebVC  animated:YES];
        }
        else {
             SANotificationEventPost(UGNotificationShowLoginView, nil);
        }
//    #endif
    

   
}
- (IBAction)historyAcion:(id)sender {

    
}
- (IBAction)voiceAction:(id)sender {
}
- (IBAction)loteryValueChange:(id)sender {
    
    [self.lotteryCollectionView reloadData];
}

@end
