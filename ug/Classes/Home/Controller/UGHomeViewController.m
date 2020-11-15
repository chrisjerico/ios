//
//  UGMainViewController.m
//  ug
//
//  Created by ug on 2019/7/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGHomeViewController.h"

// ViewController
#import "UGYubaoViewController.h"
#import "UGLoginViewController.h"
#import "UGRegisterViewController.h"
#import "UGAgentViewController.h"   // 申请代理
#import "UGMissionCenterViewController.h"   // 任务中心

// View
#import "SDCycleScrollView.h"
#import "UUMarqueeView.h"
#import "UGGameTypeCollectionView.h"
#import "GameCategoryDataModel.h"
#import "UGHomeTitleView.h"
#import "UGTKLHomeTitleView.h"
#import "UGPromotionIncomeController.h"
#import "FLAnimatedImageView.h"
#import "UGBMHeaderView.h"
#import "UGLHHomeContentCollectionViewCell.h"
#import "UGScratchMusicView.h"
#import "LHPostPayView.h"
#import "UGLHPrizeView.h"           //解码器
#import "JS_TitleView.h"
#import "HomeBannerView.h"
#import "HomeMarqueeView.h"
#import "HomeLHColumnView.h"
#import "HomeWaistAdsView.h"
#import "HomePromotionsVC.h"    // 底部优惠活动View
#import "HomeBetFormView.h"
#import "HomeTrademarkView.h"   // 底部商标
#import "HomeRankingView.h"
#import "HomeFloatingButtonsView.h"
#import "JS_HomePromoteContainerView.h"
#import "HSC_TitleView.h"

// Model
#import "UGAllNextIssueListModel.h"
#import "UGSystemConfigModel.h"
#import "UGAllNextIssueListModel.h"
#import "UGYYRightMenuView.h"
#import "UGGameNavigationView.h"
#import "UGChatRoomModel.h"
 #import "RoomChatModel.h"

// Tools
#import "UIImageView+WebCache.h"
#import "CMCommon.h"
#import "UIImage+YYgradientImage.h"
#import "CMTimeCommon.h"
#import "CountDown.h"
#import "Global.h"
#import "UIColor+RGBValues.h"
#import "HomeJSWebmasterView.h"



@interface UGHomeViewController ()<SDCycleScrollViewDelegate,UUMarqueeViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UGHomeTitleView *titleView;       /**<   自定义导航条 */
@property (nonatomic, strong) UGTKLHomeTitleView *tkltitleView; /**<   自定义导航条 */

@property (nonatomic, strong) JS_TitleView * js_titleView; 		/**<   金沙导航条 */
@property (nonatomic, strong) HSC_TitleView * hsc_titleView; 	/**<   火山橙导航条 */


@property (nonatomic, strong) UGYYRightMenuView *yymenuView;    /**<   侧边栏 */

//-------------------------------------------
//六合开奖View
@property (weak, nonatomic) IBOutlet UIView *LhPrize_FView;
@property (weak, nonatomic) IBOutlet UGLHPrizeView *lhPrizeView; /**<    解码器 */


//--推荐按钮-----------------------------------------
@property (weak, nonatomic) IBOutlet UIView *upRecommendedView;                  /**<   推荐上View */
@property (weak, nonatomic) IBOutlet UIView *downRecommendedView;                  /**<   推荐下View */

@property (weak, nonatomic) IBOutlet UIView *upWithinView;                  /**<   上内View */
@property (weak, nonatomic) IBOutlet UIView *downWithinView;                  /**<   下内View */

@property (weak, nonatomic) IBOutlet UILabel *upTitleLabel;                   /**<   下文字View */
@property (weak, nonatomic) IBOutlet UILabel *downTitleLabel;                /**<   下文字View */


@property (weak, nonatomic) IBOutlet UGBMHeaderView *headerView;/**<   GPK版导航头 */
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;       /**<   最外层的ScrollView */
@property (weak, nonatomic) IBOutlet UIStackView *contentStackView;         /**<   contentScrollView的子视图StackView */

@property (nonatomic, strong) HomeBannerView *bannerView;       /**<   顶部横幅 */
@property (weak, nonatomic) IBOutlet JS_HomePromoteContainerView *homePromoteContainer;  /**<   站长推荐 */

@property (weak, nonatomic) IBOutlet UGGameNavigationView *gameNavigationView;      /**<   游戏导航父视图 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameNavigationViewHeight;  /**<   游戏导航Height约束 */
@property (weak, nonatomic) IBOutlet UGGameTypeCollectionView *gameTypeView;        /**<   游戏列表 */
@property (nonatomic, strong) NSMutableArray<GameCategoryModel *> *gameCategorys;   /**<   游戏列表数据 */

@property (nonatomic, strong) HomeMarqueeView *rollingView;             /**<   跑马灯公告 */
@property (nonatomic, strong) HomeWaistAdsView *waistAdsView;           /**<   腰部广告 */
@property (nonatomic, strong) HomeLHColumnView *lhColumnView;           /**<   六合栏目列表 */
@property (nonatomic, strong) HomePromotionsVC *promotionVC;            /**<   优惠活动 */
@property (nonatomic, strong) HomeRankingView *rankingView;             /**<   中奖/投注排行榜 */
@property (nonatomic, strong) HomeBetFormView *betFormView;             /**<   投注专栏 */
@property (nonatomic, strong) HomeTrademarkView *trademarkView;         /**<   底部商标 */
@property (nonatomic, strong) HomeFloatingButtonsView *floatingBtnsView;/**<   首页所有悬浮按钮 */
@property (nonatomic, strong) HomeJSWebmasterView *jsWebmasterView;     /**<  金沙站长推荐 */
@end

@implementation UGHomeViewController
- (void)dealloc {
    
    if (_lhPrizeView.timer) {
        if ([_lhPrizeView.timer isValid]) {
            [_lhPrizeView.timer invalidate];
            _lhPrizeView.timer = nil;
        }
    }
    [_lhPrizeView.countDownForLabel destoryTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (JS_TitleView *)js_titleView {
    if (!_js_titleView) {
        _js_titleView = [[UINib nibWithNibName:@"JS_TitleView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        _js_titleView.frame = self.navigationController.navigationBar.bounds;
    }
    return _js_titleView;
}
- (HSC_TitleView *)hsc_titleView {
    if (!_hsc_titleView) {
        _hsc_titleView = [[UINib nibWithNibName:@"HSC_TitleView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        _hsc_titleView.bounds = self.navigationController.navigationBar.bounds;
        
    }
    return _hsc_titleView;
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
        NSDictionary *dict;
        if (SysConf.m_promote_pos) {
            
            dict  = @{@"六合资料":@[_rollingView, _LhPrize_FView, _gameNavigationView.superview, _lhColumnView, _promotionVC.view, _trademarkView],
                                   @"GPK版":@[_bannerView, _gameTypeView.superview, _promotionVC.view, _rankingView, _trademarkView],
                                   @"金沙主题":@[_bannerView, _rollingView,_jsWebmasterView,_waistAdsView, _homePromoteContainer, _gameTypeView.superview, _promotionVC.view, _rankingView, _trademarkView],
                                   @"火山橙":@[_bannerView, _rollingView, _waistAdsView, _gameNavigationView.superview, _gameTypeView.superview, _promotionVC.view, _betFormView, _trademarkView],
            };
        } else {
            
            dict  = @{@"六合资料":@[_rollingView, _LhPrize_FView, _gameNavigationView.superview, _lhColumnView,  _trademarkView],
                                   @"GPK版":@[_bannerView, _gameTypeView.superview,  _rankingView, _trademarkView],
                                   @"金沙主题":@[_bannerView, _rollingView,_jsWebmasterView,_waistAdsView, _homePromoteContainer, _gameTypeView.superview,  _rankingView, _trademarkView],
                                   @"火山橙":@[_bannerView, _rollingView, _waistAdsView, _gameNavigationView.superview, _gameTypeView.superview,  _betFormView, _trademarkView],
            };
        }

		if ([@"l002" containsString:APP.SiteId]) {
			NSMutableDictionary * mDic = dict.mutableCopy;
			mDic[@"六合资料"] = @[_bannerView, _LhPrize_FView, _rollingView, _gameNavigationView.superview, _lhColumnView, _trademarkView];
			dict = mDic.copy;
		}
        NSArray *views = dict[Skin1.skitType];
	
        if (views.count) {
            [_contentStackView addArrangedSubviews:views];
        } else {
            // 默认展示内容
            if (SysConf.m_promote_pos) {
                [_contentStackView addArrangedSubviews:@[_bannerView, _rollingView,_upRecommendedView, _gameNavigationView.superview,_downRecommendedView, _waistAdsView, _gameTypeView.superview, _promotionVC.view, _rankingView, _trademarkView,]];
            }
            else{
                [_contentStackView addArrangedSubviews:@[_bannerView, _rollingView,_upRecommendedView, _gameNavigationView.superview,_downRecommendedView, _waistAdsView, _gameTypeView.superview,  _rankingView, _trademarkView,]];
            }
        
            
        }
    }
  
    // GPK版的UI调整
    BOOL isGPK = Skin1.isGPK;

    _gameTypeView.cc_constraints.top.constant = isGPK||Skin1.isJY||Skin1.isTKL? 0 : 10;

    _headerView.hidden = !isGPK;
    self.fd_prefersNavigationBarHidden = isGPK;
    if (NavController1.topViewController == self) {
        self.navigationController.navigationBarHidden = isGPK;
    }
    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        _gameTypeView.backgroundColor = [UIColor colorWithHex:0xf9f9f9];
        UIView * titleView = [UIView new];
        [titleView addSubview:self.js_titleView];
        [self.js_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(titleView);
            make.width.equalTo(@(APP.Width - 20));
            make.height.equalTo(@44);
        }];
        self.navigationItem.titleView = titleView;
    } else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
        UIView * titleView = [UIView new];
        [titleView addSubview:self.hsc_titleView];
        [self.hsc_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(titleView);
            make.width.equalTo(@(APP.Width - 20));
            make.height.equalTo(@44);
        }];
        self.navigationItem.titleView = titleView;
//        Method;
//        Func
//        Invocation
//        Selector
//        IMP
    }
    
    [self.gameNavigationView reloadData];
}

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rollingView start];
    [self.rankingView start];
    
    if (Skin1.isTKL) {
          self.tkltitleView.imgName = SysConf.mobile_logo;
    } else {
          self.titleView.imgName = SysConf.mobile_logo;
    }
  
    if (_lhPrizeView.timer) {
        [_lhPrizeView.timer setFireDate:[NSDate date]];
    }

    self.navigationController.navigationBarHidden = [Skin1 isGPK];
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rollingView pause];//fixbug  发热  掉电快
    [self.rankingView pause];//fixbug  发热  掉电快
    if (_lhPrizeView.timer) {
        [_lhPrizeView.timer setFireDate:[NSDate distantFuture]];
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
        // 登录成功
        SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
            
            if (Skin1.isTKL) {
                 __self.tkltitleView.showLoginView = NO;
            } else {
                 __self.titleView.showLoginView = NO;
            }
        });
        // 退出登陆
        SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
            if (Skin1.isTKL) {
                __self.tkltitleView.showLoginView = YES;
            } else {
                __self.titleView.showLoginView = YES;
            }
            
//            [__self.bigWheelView setHidden:YES];
        });
        // 登录超时
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            // onceToken 函数的作用是，限制为只弹一次框，修复弹框多次的bug
            if (OBJOnceToken(UGUserModel.currentUser)) {
                if (Skin1.isTKL) {
                     __self.tkltitleView.showLoginView = YES;
                } else {
                     __self.titleView.showLoginView = YES;
                }
               
            }
        });
        SANotificationEventSubscribe(UGNotificationGetUserInfo, self, ^(typeof (self) self, id obj) {
            [__self.contentScrollView.mj_header endRefreshing];
        });
        SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {

            if (Skin1.isTKL) {
                  __self.tkltitleView.userName = UserI.username;
            } else {
                  __self.titleView.userName = UserI.username;
            }

        });
        // 获取系统配置成功
        SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if ([SysConf.switchShowFriendReferral isEqualToString:@"1"]) {

                    if ([SysConf.showNavigationBar isEqualToString:@"1"]) {
                        [__self.upRecommendedView setHidden:NO];
                        [__self.downRecommendedView setHidden:YES];
                    } else {
                        [__self.upRecommendedView setHidden:YES];
                        [__self.downRecommendedView setHidden:NO];
                    }
                }
                else{
                    [__self.upRecommendedView setHidden:YES];
                    [__self.downRecommendedView setHidden:YES];
                }
            });

            
            [[AppDefine shared] setupSiteAndSkinParams];
        });
    }
    
    // 横幅
    _bannerView = _LoadView_from_nib_(@"HomeBannerView");
    
    // 跑马灯公告
    _rollingView = _LoadView_from_nib_(@"HomeMarqueeView");
    
    // 腰部广告
    _waistAdsView = _LoadView_from_nib_(@"HomeWaistAdsView");
    
    // 六合栏目列表
    _lhColumnView = _LoadView_from_nib_(@"HomeLHColumnView");
    
    // 金沙站长推荐
    _jsWebmasterView = _LoadView_from_nib_(@"HomeJSWebmasterView");
//    _jsWebmasterView.heightLayoutConstraint.constant = 0.1;
    
    // 优惠活动
    _promotionVC = _LoadVC_from_storyboard_(@"HomePromotionsVC");
    [self addChildViewController:_promotionVC];
    
    // 投注/中奖排行榜
    _rankingView = _LoadView_from_nib_(@"HomeRankingView");
    
    // 底部商标
    _trademarkView = _LoadView_from_nib_(@"HomeTrademarkView");
    
    // 悬浮按钮
    _floatingBtnsView = _LoadView_from_nib_(@"HomeFloatingButtonsView");
    [self.view addSubview:_floatingBtnsView];
    
    // 配置初始UI
    {
        subView(@"优惠活动Cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor : Skin1.homeContentColor;
        if (Skin1.isJY||Skin1.isTKL) {
            subImageView(@"公告图标ImageView").image = [UIImage imageNamed:@"JY_gg"] ;
           
            subView(@"推荐好友上View").layer.borderWidth = 1;
            subView(@"推荐好友上View").layer.borderColor = [RGBA(232, 232, 232, 1) CGColor];
            subView(@"推荐好友下View").layer.borderWidth = 1;
            subView(@"推荐好友下View").layer.borderColor = [RGBA(232, 232, 232, 1) CGColor];
        }
        else{
            subImageView(@"公告图标ImageView").image = [[UIImage imageNamed:@"notice"] qmui_imageWithTintColor:Skin1.textColor1];
        }
        

        
        if (!Skin1.isLH) {
            self.gameNavigationView.layer.cornerRadius = 8;
            self.gameNavigationView.layer.masksToBounds = true;
            self.gameNavigationView.layer.borderWidth = 1;
            self.gameNavigationView.layer.borderColor = Skin1.homeContentColor.CGColor;
        }
       

        
        if (APP.isWhite) {
            subView(@"优惠活动外View").layer.borderWidth = 0;
            subView(@"优惠活动外View").backgroundColor = [UIColor clearColor];
            _gameNavigationView.layer.borderWidth = 1;
            _gameNavigationView.layer.borderColor = [[UIColor whiteColor] CGColor];
        }
        else{
            subView(@"优惠活动外View").layer.borderWidth = 1;
            subView(@"优惠活动外View").layer.borderColor = [[UIColor whiteColor] CGColor];
        }
        
        if (APP.isNoBorder) {
            subView(@"优惠活动外View").layer.cornerRadius = 0;
            subView(@"优惠活动外View").layer.masksToBounds = NO;
            subView(@"优惠活动外View").layer.borderWidth = 0;
            subView(@"优惠活动外View").backgroundColor = [UIColor clearColor];
        } else {
            subView(@"优惠活动外View").layer.cornerRadius = 5;
            subView(@"优惠活动外View").layer.masksToBounds = YES;
            
            if ( [@"c012," containsString:APP.SiteId]) {
                subView(@"优惠活动外View").layer.borderWidth = 1;
                subView(@"优惠活动外View").layer.borderColor = [[UIColor whiteColor] CGColor];
            }
        }
        
        if ( [@"c012," containsString:APP.SiteId]) {//第3种样式：
            subView(@"优惠活动外View").backgroundColor = Skin1.homeContentColor;
        }
        
        
        [self.view setBackgroundColor: Skin1.bgColor];
        
//        [self.gameNavigationView setBackgroundColor:Skin1.homeContentColor];
        [self.gameTypeView setBackgroundColor:Skin1.bgColor];
        [self.upRecommendedView setBackgroundColor:Skin1.bgColor];
        [self.downRecommendedView setBackgroundColor:Skin1.bgColor];
        
        [self setupSubView];
        
        [self skin];
        
        [self.upRecommendedView setHidden:YES];
        [self.downRecommendedView setHidden:YES];
        
        self.upWithinView.layer.cornerRadius = 5;//设置那个圆角的有多圆
        self.upWithinView.layer.masksToBounds = YES;//设为NO时，边框外的画面依然会被显示出来
        
        self.downWithinView.layer.cornerRadius = 5;//设置那个圆角的有多圆
        self.downWithinView.layer.masksToBounds = YES;//设为NO时，边框外的画面依然会被显示出来
        
        [self.upWithinView setBackgroundColor:Skin1.homeContentColor];
        [self.downWithinView setBackgroundColor:Skin1.homeContentColor];
        
        self.upTitleLabel.textColor = Skin1.textColor1;
        self.downTitleLabel.textColor = Skin1.textColor1;
        
        //游戏列表点击事件
        self.gameTypeView.gameItemSelectBlock = ^(GameModel * _Nonnull game) {
            [NavController1 pushViewControllerWithGameModel:game];
        };
    }
    
    // c200、c035站点定制需求
    if ([APP.SiteId containsString:@"c035"]) {
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
        [__self requestUrl];
    }];
    
    
    
    if (_contentScrollView.mj_header.refreshingBlock) {
        _contentScrollView.mj_header.refreshingBlock();
    }
}

-(void)requestUrl{
    // 创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        // 请求一
          [self getSystemConfig];     // APP配置信息
    });
    dispatch_group_async(group, queue, ^{
        // 请求一
          [self getCustomGameList];     // 游戏列表
    });
    dispatch_group_async(group, queue, ^{
        [self.rollingView reloadData:^(BOOL succ) {}];   // 公告列表

    });
    dispatch_group_async(group, queue, ^{
        [self.waistAdsView reloadData:^(BOOL succ) {}];     // 首页广告图
    });
    dispatch_group_async(group, queue, ^{
        
        // 请求二
        [self.bannerView reloadData:^(BOOL succ) {}];       // Banner图、在线人数
    });
    dispatch_group_async(group, queue, ^{
          // 请求3
           [self getAllNextIssueData]; // 彩票大厅数据 

    });
    dispatch_group_async(group, queue, ^{
        
        // 请求4
        [self getUserInfo];         // 用户信息
    });
    dispatch_group_async(group, queue, ^{
        
        // 请求5 请求所有悬浮按钮数据
        [self.floatingBtnsView reloadData:^(BOOL succ) {}];
        
    });
    dispatch_group_async(group, queue, ^{
        
        // 请求7
        [self.promotionVC reloadData:^(BOOL succ) {}];
    });
    dispatch_group_async(group, queue, ^{
           
           // 请求8
        [self.rankingView reloadData:^(BOOL succ) {}];     // 投注排行榜/中奖排行榜
           
    });
    dispatch_group_async(group, queue, ^{
           
           // 请求9
//           [self gethomeAdsList];     // 首页广告图片
           
    });
       
    dispatch_group_async(group, queue, ^{
           
           // 请求10
//           [self chatgetToken];     // 在线配置的聊天室÷
           
    });
    dispatch_group_async(group, queue, ^{
           
           // 请求12 // 六合栏目列表
        [self.lhColumnView reloadData:^(BOOL succ) {}];
           
    });
    dispatch_group_async(group, queue, ^{
           
           // 请求13
           [self getPlatformGamesWithParams];     //购彩大厅信息
           
    });
   
    dispatch_group_async(group, queue, ^{
           
           // 请求14
        if ([Skin1.skitType isEqualToString:@"六合资料"]) {
            
            if ([CMCommon stringIsNull:SysConf.appSelectType]) {
                [self.lhPrizeView  setGid:@""];
            } else {
                if ( [SysConf.appSelectType isEqualToString:@"0"]) {
                    [self.lhPrizeView  setGid:@""];
                } else {
                    [self.lhPrizeView  setGid:SysConf.appSelectType];
                }
            }
            
        }
    });
    
    dispatch_group_notify(group, queue, ^{
        
        // 三个请求对应三次信号等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        //在这里 进行请求后的方法，回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{

        });
        
        
    });
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}


// 得到线上配置的聊天室
- (void)chatgetToken {
    

    {//得到线上配置的聊天室
        NSDictionary *params = @{@"t":[NSString stringWithFormat:@"%ld",(long)[CMTimeCommon getNowTimestamp]],
                                 @"token":[UGUserModel currentUser].sessid
        };
        NSLog(@"token = %@",[UGUserModel currentUser].sessid);
        [CMNetwork chatgetTokenWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                NSLog(@"model.data = %@",model.data);
                NSDictionary *data = (NSDictionary *)model.data;
                NSMutableArray *chatIdAry = [NSMutableArray new];
                NSMutableArray *typeIdAry = [NSMutableArray new];
                NSMutableArray<UGChatRoomModel *> *chatRoomAry = [NSMutableArray new];
//                NSArray * chatAry = [data objectForKey:@"chatAry"];
                
                NSArray * roomAry =[RoomChatModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"chatAry"]];
                
                NSArray *chatAry = [roomAry sortedArrayUsingComparator:^NSComparisonResult(RoomChatModel *p1, RoomChatModel *p2){
                //对数组进行排序（升序）
                    return p1.sortId > p2.sortId;
                //对数组进行排序（降序）
                // return [p2.dateOfBirth compare:p1.dateOfBirth];
                }];
                
                for (int i = 0; i< chatAry.count; i++) {
                    RoomChatModel *dic =  [chatAry objectAtIndex:i];
                    [chatIdAry addObject:dic.roomId];
                    [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
                    
                }
                [CMCommon removeLastRoomAction:chatIdAry];
                
                NSNumber *number = [data objectForKey:@"chatRoomRedirect"];
                
                
                MyChatRoomsModel.currentRoom = [MyChatRoomsModel new];;
                SysChatRoom.chatRoomRedirect = [number intValue];
                SysChatRoom.chatRoomAry = chatRoomAry;
                
              

                if (![CMCommon arryIsNull:chatRoomAry]) {
                      UGChatRoomModel *obj  = SysChatRoom.defaultChatRoom = [chatRoomAry objectAtIndex:0];
                    NSLog(@"roomId = %@,sorId = %d,roomName = %@",obj.roomId,obj.sortId,obj.roomName);
            
                }
                else{
                    UGChatRoomModel *obj  = [UGChatRoomModel new];
                    obj.roomId = @"0";
                    obj.roomName = @"聊天室";
                    SysChatRoom.defaultChatRoom = obj;
                    
                }
                NSLog(@"SysChatRoom0000000000000000000000000000 = %@",SysChatRoom);
                [MyChatRoomsModel setCurrentRoom:SysChatRoom ];
  
            } failure:^(id msg) {
                //            [self stopAnimation];
            }];
        }];
        
    }
}

- (void)getUserInfo {
    if (!UGLoginIsAuthorized()) {
        return;
    }
    WeakSelf;
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [weakSelf.contentScrollView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            NSLog(@"uid = %@",user.uid);
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            
            if (Skin1.isTKL) {
                 weakSelf.tkltitleView.userName = user.username;
            } else {
                 weakSelf.titleView.userName = user.username;
            }
           
            SANotificationEventPost(UGNotificationGetUserInfoComplete, nil);
            
            [weakSelf  chatgetToken];
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
        NSLog(@" model = %@",model);
        [CMResult processWithResult:model success:^{
            UGAllNextIssueListModel.lotteryGamesArray = model.data;
            
            NSLog(@" UGAllNextIssueListModel.lotteryGamesArray = %@",UGAllNextIssueListModel.lotteryGamesArray);
        } failure:nil];
    }];
}

// 自定义游戏列表
- (void)getCustomGameList {
    
    [SVProgressHUD showWithStatus: nil];
    WeakSelf;
    [CMNetwork getCustomGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [weakSelf.contentScrollView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            if (model.data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"model.data = %@",model.data);
                    GameCategoryDataModel *customGameModel = GameCategoryDataModel.gameCategoryData = (GameCategoryDataModel *)model.data;
                    
                    // 首页导航
                    NSArray<GameModel *> *sourceData = customGameModel.navs;
                    
                    weakSelf.gameNavigationView.superview.hidden = !sourceData.count;
                    weakSelf.gameNavigationView.sourceData = sourceData;
                    // 设置任务大厅页的标题
                    GameModel *gm = [sourceData objectWithValue:@13 keyPath:@"subId"];
                    [UGMissionCenterViewController setTitle:gm.name.length ? gm.name : gm.title];
                    
                    if (sourceData.count > 0) {
                        /**
                         #917 c190首页中间游戏导航需增加logo图标，游戏导航栏可进行滑动
                         */
                        if (([SysConf.mobileTemplateCategory isEqualToString:@"9"] && [@"c190" containsString:APP.SiteId])) {
                            weakSelf.gameNavigationViewHeight.constant = 60;
                            weakSelf.gameNavigationView.showsVerticalScrollIndicator = NO;
                        }
                        else if ([Skin1 isJY] || Skin1.isTKL)
                        {
                            weakSelf.gameNavigationViewHeight.constant = ((sourceData.count - 1)/5 + 1)*80;
                            weakSelf.gameNavigationView.showsVerticalScrollIndicator = NO;
                        }
                        else {
                            weakSelf.gameNavigationViewHeight.constant = ((sourceData.count - 1)/5 + 1)*80;
                            
                        }
                        [weakSelf.view layoutIfNeeded];
					}
					
					if (sourceData.count == 1) {
						weakSelf.gameNavigationViewHeight.constant = 0;
                        [weakSelf.view layoutIfNeeded];
					}
                    // 游戏列表
                    self.gameTypeView.gameTypeArray = weakSelf.gameCategorys = customGameModel.icons.mutableCopy;
                    
                    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
                        NSMutableArray<GameCategoryModel*> *newGameTypeArray =
                        [[NSMutableArray alloc] initWithArray:self.gameTypeView.gameTypeArray];
                        for (GameCategoryModel *object in  self.gameTypeView.gameTypeArray) {
                            if ([object.name isEqualToString:@"站长推荐"]) {
                                weakSelf.jsWebmasterView.jsWebmasterList = object.list;
                                [newGameTypeArray removeObject:object];
                                break;
                            }
                        }
                        
                        NSArray<GameModel *> * homePromoteItems = [weakSelf.gameCategorys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(GameCategoryModel * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                            return [evaluatedObject.iid isEqualToString:@"7"];
                        }]][0].list;
                        if (homePromoteItems.count > 1) {
                            [weakSelf.homePromoteContainer bind: homePromoteItems];
                            
                        } else if ([weakSelf.contentStackView.arrangedSubviews containsObject:weakSelf.homePromoteContainer])  {
                            [weakSelf.contentStackView removeArrangedSubview:weakSelf.homePromoteContainer];
                            [weakSelf.homePromoteContainer removeFromSuperview];
                        }
                        weakSelf.gameTypeView.gameTypeArray = weakSelf.gameCategorys = [newGameTypeArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(GameCategoryModel *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                            return ![evaluatedObject.iid isEqualToString:@"7"];
                        }]].mutableCopy;
                    }
                    
                });
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

// 获取系统配置
- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.contentScrollView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            
            HJSonLog(@"model = %@",model);
            
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            NSLog(@"SysConf.announce_first = %d",SysConf.announce_first);

            if (Skin1.isTKL) {
                [weakSelf.tkltitleView setImgName:config.mobile_logo];
            } else {
                [weakSelf.titleView setImgName:config.mobile_logo];
            }
            
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

#pragma mark ------------六合------------------------------------------------------

- (void)getPlatformGamesWithParams {
    [CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            NSMutableArray <UGYYPlatformGames *>*lotterydataArray = ({
               NSMutableArray *temp = @[].mutableCopy;
               NSArray *dataArray = model.data;
               for (int i=0; i<dataArray.count; i++) {
                   [temp addObject:dataArray[i]];
               }
               temp;
           });
           
           [Global getInstanse].lotterydataArray   = lotterydataArray;
        } failure:^(id msg) {
        }];
    }];
}

- (void)rightBarBtnClick {
    
    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        [JS_Sidebar show];
        return;
    }
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"1";
    [self.yymenuView show];
}


- (void)setupSubView {
    
    
    if (Skin1.isTKL) {
        
         UGTKLHomeTitleView *titleView = [[UGTKLHomeTitleView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 44)];
         self.navigationItem.titleView = titleView;
         self.tkltitleView = titleView;
         WeakSelf
         self.tkltitleView.moreClickBlock = ^{
             [weakSelf rightBarBtnClick];
         };
         self.tkltitleView.tryPlayClickBlock = ^{
             SANotificationEventPost(UGNotificationTryPlay, nil);
         };
         self.tkltitleView.loginClickBlock = ^{
             [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
         };
         self.tkltitleView.registerClickBlock = ^{
             [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGRegisterViewController") animated:YES];
         };
         self.tkltitleView.userNameTouchedBlock = ^{
             [weakSelf.tabBarController setSelectedIndex:4];
         };
        self.tkltitleView.chatClickBlock = ^{
            [NavController1 pushViewControllerWithNextIssueModel:nil isChatRoom:YES];
        };
         
         
         
         if (UGLoginIsAuthorized()) {
             self.tkltitleView.showLoginView = NO;
             self.tkltitleView.userName = UserI.username;
         }
    } else {
        
         UGHomeTitleView *titleView = [[UGHomeTitleView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 44)];
         self.navigationItem.titleView = titleView;
         self.titleView = titleView;
         WeakSelf
         self.titleView.moreClickBlock = ^{
             [weakSelf rightBarBtnClick];
         };
         self.titleView.tryPlayClickBlock = ^{
             SANotificationEventPost(UGNotificationTryPlay, nil);
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
        self.titleView.chatClickBlock = ^{
            [NavController1 pushViewControllerWithNextIssueModel:nil isChatRoom:YES];
        };
         
         
         
         
         if (UGLoginIsAuthorized()) {
             self.titleView.showLoginView = NO;
             self.titleView.userName = UserI.username;
         }
    }
 
    //	self.scrollContentHeightConstraints.constant = CGRectGetMaxY(self.rankingView.frame);
    //	self.scrollView.contentSize = CGSizeMake(UGScreenW, self.scrollContentHeightConstraints.constant);
    
    
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollView.bounces = YES;
    //	self.scrollView.backgroundColor = Skin1.bgColor;
}

- (NSMutableArray<GameCategoryModel *> *)gameCategorys {
    if (_gameCategorys == nil) {
        _gameCategorys = [NSMutableArray array];
    }
    return _gameCategorys;
}

- (IBAction)goRecommendedAction:(id)sender {
    
    UGUserModel *user = [UGUserModel currentUser];
    BOOL isLogin = UGLoginIsAuthorized();
    
    // 未登录禁止访问
    if (!isLogin) {
        NSLog(@"未登录禁止访问");
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
        return ;
    }
    
    //推荐
    if (UserI.isTest) {
        [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
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
//                    if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
//                        [HUDHelper showMsg:@"在线注册代理已关闭"];
//                        return ;
//                    }
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

@end

