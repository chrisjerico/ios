
//
//  UGMainViewController.m
//  ug
//
//  Created by ug on 2019/7/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGHomeViewController.h"
#import "SDCycleScrollView.h"
#import "CustomCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UUMarqueeView.h"
#import "UGGameTypeCollectionView.h"
#import "UGPlatformTitleCollectionView.h"
#import "UGLoginViewController.h"
#import "UGRegisterViewController.h"
#import "CMCommon.h"
#import "UGRightMenuView.h"
#import "STButton.h"
#import "UGPlatformNoticeView.h"
#import "UITabBarController+ShowViewController.h"
#import "UGSystemConfigModel.h"
#import "UGChangLongController.h"
#import "UGRightMenuView.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "UGPlatformGameModel.h"
#import "SLWebViewController.h"
#import "QDWebViewController.h"
#import "UGGameListViewController.h"
#import "UGBannerModel.h"
#import "SLWebViewController.h"
#import "UGNoticeModel.h"
#import "UGRankModel.h"
#import "UGNoticePopView.h"
#import "UGHomeTitleView.h"

#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGPcddLotteryController.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"
#import "UGLotteryRecordController.h"
#import "UGMailBoxTableViewController.h"
#import "UGAllNextIssueListModel.h"

#import "UGredEnvelopeView.h"
#import "UGredActivityView.h"
#import "GameCategoryDataModel.h"
#import "UGDocumentVC.h"
#import "UGonlineCount.h"
#import "UGYubaoViewController.h"

#import "UGYYRightMenuView.h"
#import <SafariServices/SafariServices.h>
#import "UIImage+YYgradientImage.h"

#import "UGGameNavigationView.h"
#import "UGFundsViewController.h"


@interface UGHomeViewController ()<SDCycleScrollViewDelegate,UUMarqueeViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *bannerBgView;                          /**<   Banner */
@property (weak, nonatomic) IBOutlet UGGameNavigationView *gameNavigationView;      /**<   游戏导航父视图 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameNavigationViewHeight;  /**<   游戏导航 */

@property (weak, nonatomic) IBOutlet UGGameTypeCollectionView *gameTypeView;/**<   游戏列表 */
@property (weak, nonatomic) IBOutlet UIView *rankingView;                   /**<   中奖排行榜父视图 */

@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView;    /**<   滚动公告 */
@property (weak, nonatomic) IBOutlet UUMarqueeView *upwardMultiMarqueeView; /**<   中奖排行榜 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameViewHeight;


@property (nonatomic, strong) UGHomeTitleView *titleView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) NSMutableArray *leftwardMarqueeViewData;      /**<   公告数据 */
@property (nonatomic, strong) NSMutableArray *upwardMultiMarqueeViewData;   /**<   中奖排行榜数据 */
@property (nonatomic, strong) NSMutableArray *popNoticeArray;

@property (nonatomic, strong) NSMutableArray *gameCategorys;
@property (nonatomic, strong) UGNoticeTypeModel *noticeTypeModel;
@property (nonatomic, strong) UGRankListModel *rankListModel;

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *noticeArray;
@property (nonatomic, strong) NSArray *rankArray;
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, assign) BOOL initSubview;

@property (strong, nonatomic)  UGredEnvelopeView *uGredEnvelopeView;
@property (strong, nonatomic)  UGredActivityView *uGredActivityView;    /**<   红包弹框 */


@property (strong, nonatomic)UGRightMenuView *menuView;

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;

@property (nonatomic, strong) UGonlineCount *mUGonlineCount;

@property (strong, nonatomic)UILabel *nolineLabel;

@property (weak, nonatomic) IBOutlet UIView *rollingView;

@end

@implementation UGHomeViewController
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)skin{

    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
 

	[self.rankingView setBackgroundColor:[[UGSkinManagers shareInstance] setNavbgColor]];
    [self.upwardMultiMarqueeView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
    [self.rollingView setBackgroundColor:[[UGSkinManagers shareInstance]sethomeContentColor]];
    [self.gameNavigationView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
     [self.leftwardMarqueeView setBackgroundColor:[[UGSkinManagers shareInstance] sethomeContentColor]];
     [self.gameTypeView setBackgroundColor:[[UGSkinManagers shareInstance] setbgColor]];
     self.gameNavigationView.layer.borderColor = [[UGSkinManagers shareInstance] sethomeContentBorderColor].CGColor;
    
    [self getCustomGameList];
}

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
    
	[[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[[UGSkinManagers shareInstance] setTabbgColor]]];
	
	[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UGSkinManagers shareInstance] settabNOSelectColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
	
	[[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys: [[UGSkinManagers shareInstance] settabSelectColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
	
	[[UITabBar appearance] setSelectedImageTintColor: [[UGSkinManagers shareInstance] settabSelectColor]];
	
	[[UITabBar appearance] setUnselectedItemTintColor: [[UGSkinManagers shareInstance] settabNOSelectColor]];
	
	
	[self setupSubView];
	
	
	
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
        [UGUserModel.currentUser onceToken:ZJOnceToken block:^{
            [QDAlertView showWithTitle:@"提示" message:@"您的账号已经登录超时，请重新登录。" cancelButtonTitle:nil otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                self.titleView.showLoginView = YES;
                UGUserModel.currentUser = nil;
                [self.tabBarController setSelectedIndex:0];
                [self loginClick];
            }];
        }];
	});
	SANotificationEventSubscribe(UGNotificationShowLoginView, self, ^(typeof (self) self, id obj) {
		[self loginClick];
	});
	SANotificationEventSubscribe(UGNotificationGetUserInfo, self, ^(typeof (self) self, id obj) {
		[self getUserInfo];
		
	});
	SANotificationEventSubscribe(UGNotificationAutoTransferOut, self, ^(typeof (self) self, id obj) {
		[self autoTransferOut];
	});
	
	[self getSystemConfig];
	[self getCustomGameList];
	[self getBannerList];
	[self getNoticeList];
	[self getRankList];
	[self getAllNextIssueData];
	[self getUserInfo];
	[self getCheckinListData];
	[self systemOnlineCount];
	
	self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         SANotificationEventPost(UGNotificationWithResetTabSuccess, nil);
		[self getSystemConfig];
		[self getCustomGameList];
		[self getBannerList];
		[self getNoticeList];
		[self getRankList];
		[self getUserInfo];
		[self getAllNextIssueData];
		[self getCheckinListData];
		[self systemOnlineCount];
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectiongViewHeightUpdated:) name:@"UGPlatformCollectionViewContentHeight" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameNavigationItemTaped:) name:@"gameNavigationItemTaped" object:nil];
	
	WeakSelf
	self.gameTypeView.platformSelectBlock = ^(NSInteger selectIndex) {
		[self.view layoutIfNeeded];
	};
	self.gameTypeView.gameItemSelectBlock = ^(GameModel * _Nonnull game) {
		[weakSelf showGameVC: game];
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
            
            if ([UGUserModel currentUser].isTest) {
                UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];
                [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }];
                return ;
            }
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
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
        };
    }
}

-(BOOL)prefersStatusBarHidden{
	
	return NO;
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//    [self.leftwardMarqueeView start];
//    [self.upwardMultiMarqueeView start];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.leftwardMarqueeView pause];//fixbug  发热  掉电快
    [self.upwardMultiMarqueeView pause];//fixbug  发热  掉电快
	self.initSubview = YES;
}

- (void)viewWillLayoutSubviews {
	
	if (self.initSubview) {
		return;
	}
	
	[self getBannerList];
	
	
}

- (void)collectiongViewHeightUpdated: (NSNotification *)notification {
	self.gameViewHeight.constant = ((NSNumber *)notification.object).floatValue + 80;
	[self.view layoutIfNeeded];
}

-(void)gameNavigationItemTaped: (NSNotification *)notification {
	
	GameModel * model = notification.object;
	
	if ([model.subId isEqualToString:@"1"]) {
		UGFundsViewController * vc = [UGFundsViewController new];
		[self.navigationController pushViewController:vc animated:true];
	} else if ([model.subId isEqualToString:@"8"]) {
		SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
		UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
		if (config.zxkfUrl) {
			webViewVC.urlStr = config.zxkfUrl;
		}
		[self.navigationController pushViewController:webViewVC animated:YES];
	} else if ([model.subId isEqualToString:@"5"]) {
		UGChangLongController *changlongVC = [[UGChangLongController alloc] init];
		 changlongVC.lotteryGamesArray = self.lotteryGamesArray;
		 [self.navigationController pushViewController:changlongVC animated:YES];

	} else if ([model.subId isEqualToString:@"7"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://test10.6yc.com/Open_prize/index.php"]];
	} else if ([model.subId isEqualToString:@"6"]) {
		[SVProgressHUD showInfoWithStatus:@"推荐收益已关闭"];
		
	} else if ([model.subId isEqualToString:@"2"]) {
		[SVProgressHUD showInfoWithStatus:@"下载链接未配置"];

	} else if ([model.subId isEqualToString:@"3"]) {
		// 聊天室
		UGChatViewController * qdwebVC = [[UGChatViewController alloc] init];

		 qdwebVC.webTitle = @"聊天室";
		
		 
		 if (![CMCommon stringIsNull:[UGUserModel currentUser].token]) {
			  NSString *colorStr = [[UGSkinManagers shareInstance] setChatNavbgStringColor];
			  qdwebVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr];
		 } else {
			 NSString *colorStr = [[UGSkinManagers shareInstance] setChatNavbgStringColor];
			 qdwebVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr];
		 }
		
		[self.navigationController pushViewController:qdwebVC animated:YES];

	} else if ([model.subId isEqualToString:@"4"]) {
		// 在线客服
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
- (void)getCustomGameList {
	
	[SVProgressHUD showWithStatus: nil];
	[CMNetwork getCustomGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			[SVProgressHUD dismiss];
			if (model.data) {
				dispatch_async(dispatch_get_main_queue(), ^{
					GameCategoryDataModel * customGameModel = (GameCategoryDataModel*)model.data;
					[self.gameCategorys removeAllObjects];
					[self.gameCategorys addObject:customGameModel.lottery];
					[self.gameCategorys addObject:customGameModel.real];
					[self.gameCategorys addObject:customGameModel.fish];
					[self.gameCategorys addObject:customGameModel.game];
					[self.gameCategorys addObject:customGameModel.card];
					[self.gameCategorys addObject:customGameModel.sport];
					
					
					NSArray<GameModel *> * sourceData = customGameModel.navigation.list;
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
- (void)getPlatformGamesList {
	
}

- (void)getGotoGameUrl:(UGPlatformGameModel *)game {
	
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"id":game.gameId
	};
	[SVProgressHUD showWithStatus:nil];
	[CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			[SVProgressHUD dismiss];
			dispatch_async(dispatch_get_main_queue(), ^{
				QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
				qdwebVC.urlString = model.data;
				qdwebVC.enterGame = YES;
				[self.navigationController pushViewController:qdwebVC  animated:YES];
			});
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
}

- (void)getSystemConfig {
	[CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			
			NSLog(@"model = %@",model);
			
			UGSystemConfigModel *config = model.data;
			UGSystemConfigModel.currentConfig = config;
			
			
			[[UGSkinManagers shareInstance] setSkin];
    
			
			[self.titleView setImgName:config.mobile_logo];
			
		} failure:^(id msg) {
			
		}];
	}];
}

- (void)userLogout {
	
	
	NSDictionary *dict = @{@"token":[UGUserModel currentUser].sessid};
	[SVProgressHUD showWithStatus:@"退出登录..."];
	[CMNetwork userLogoutWithParams:dict completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			//            [SVProgressHUD showSuccessWithStatus:model.msg];
			[SVProgressHUD showSuccessWithStatus:@"退出成功"];
			self.titleView.showLoginView = YES;
			UGUserModel.currentUser = nil;
			dispatch_async(dispatch_get_main_queue(), ^{
				
				[self.tabBarController setSelectedIndex:0];
			});
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
	
}

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
				}
			});
			
		} failure:^(id msg) {
			
		}];
	}];
	
}

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
					
					[self showPlatformNoticeView];
				}
			});
			
			
		} failure:^(id msg) {
			
		}];
	}];
}

- (void)getRankList {
	
	[CMNetwork getRankListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.scrollView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			
			dispatch_async(dispatch_get_main_queue(), ^{
				// 需要在主线程执行的代码
				UGRankListModel *rank = model.data;
				self.rankListModel = rank;
				self.rankArray = rank.list.mutableCopy;
				
				if (rank.show) {
					self.rankingView.hidden = NO;
					[self.upwardMultiMarqueeView reloadData];
				}else {
					self.rankingView.hidden = YES;
				}
			});
			
		} failure:^(id msg) {
			
		}];
	}];
}

//得到红包详情数据
- (void)getCheckinListData {
	
	
	BOOL isLogin = UGLoginIsAuthorized();
	
	if (!isLogin) {
		
	}
	
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
			
			[SVProgressHUD showErrorWithStatus:msg];
			
		}];
	}];
}


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
- (void)showPlatformNoticeView {
	UGPlatformNoticeView *notiveView = [[UGPlatformNoticeView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
	notiveView.dataArray = self.popNoticeArray;
    [notiveView.bgView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
	[notiveView show];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
	
	UGBannerCellModel *banner = self.bannerArray[index];
	if (banner.url.length) {
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
	}else {
		
		itemView.backgroundColor = [UIColor whiteColor];
		UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, (CGRectGetHeight(itemView.bounds) - 16.0f) / 2.0f, 16.0f, 16.0f)];
		icon.tag = 1003;
		[itemView addSubview:icon];
		UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(20.0f + 20.0f, 0.0f, CGRectGetWidth(itemView.bounds) - 20.0f - 20.0f - 75.0f, CGRectGetHeight(itemView.bounds))];
		userName.font = [UIFont systemFontOfSize:14.0f];
		userName.textColor = [UIColor redColor];
		userName.tag = 1001;
		[itemView addSubview:userName];
		
		UILabel *gameLabel = [[UILabel alloc] initWithFrame:CGRectMake(UGScreenW / 3, 0, UGScreenW / 3, itemView.height)];
		gameLabel.textColor = [UIColor blackColor];
		gameLabel.textAlignment = NSTextAlignmentCenter;
		gameLabel.font = [UIFont systemFontOfSize:14];
		gameLabel.tag = 1004;
		[itemView addSubview:gameLabel];
		
		UILabel *amountLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gameLabel.frame), 0, UGScreenW / 3, itemView.height)];
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
	}else {
		UGRankModel *rank = self.rankArray[index];
		UILabel *content = [itemView viewWithTag:1001];
		content.text = rank.username;
        [content setTextColor:UIColor.blackColor];
		
		UILabel *coin = [itemView viewWithTag:1002];
		coin.text = [NSString stringWithFormat:@"%@元",rank.coin];
		
		UILabel *game = [itemView viewWithTag:1004];
		game.text = rank.type;
   
		
		UIImageView *icon = [itemView viewWithTag:1003];
		NSString *imgName = nil;
		icon.hidden = NO;
		if (index == 0) {
			imgName = @"diyiming";
		}else if (index == 1) {
			imgName = @"dierming";
		}else if (index == 2) {
			imgName = @"disanming";
		}else {
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

- (void)loginClick {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
	UGLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"UGLoginViewController"];
	[self.tabBarController showViewControllerInSelected:loginVC animated:YES];
}

- (void)registerClick {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
	UGRegisterViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"UGRegisterViewController"];
	[self.navigationController pushViewController:loginVC animated:YES];
	
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
		}else {
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
	};
	
	
	if ([@"cqssc" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
		UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
		lotteryVC.gameId = model.gameId;
		lotteryVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(lotteryVC);
		[self.navigationController pushViewController:lotteryVC animated:YES];
	}else if ([@"pk10" isEqualToString:model.gameType] ||
			  [@"xyft" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
		UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(markSixVC);
		
		[self.navigationController pushViewController:markSixVC animated:YES];
		
	}else if ([@"qxc" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
		UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
		sevenVC.gameId = model.gameId;
		sevenVC.lotteryGamesArray = self.lotteryGamesArray;
		judeBlock(sevenVC);
		
		[self.navigationController pushViewController:sevenVC animated:YES];
		
	}else if ([@"lhc" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGHKLHCLotteryController" bundle:nil];
		UGHKLHCLotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:markSixVC animated:YES];
		
	}else if ([@"jsk3" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGJSK3LotteryController" bundle:nil];
		UGJSK3LotteryController *fastThreeVC = [storyboard instantiateInitialViewController];
		fastThreeVC.gameId = model.gameId;
		fastThreeVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:fastThreeVC animated:YES];
	}else if ([@"pcdd" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPCDDLotteryController" bundle:nil];
		UGPCDDLotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:PCVC animated:YES];
		
	}else if ([@"gd11x5" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGD11X5LotteryController" bundle:nil];
		UGGD11X5LotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:PCVC animated:YES];
		
	}else if ([@"xync" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGXYNCLotteryController" bundle:nil];
		UGXYNCLotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:PCVC animated:YES];
		
	}else if ([@"bjkl8" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJKL8LotteryController" bundle:nil];
		UGBJKL8LotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:PCVC animated:YES];
		
	}else if ([@"gdkl10" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGDKL10LotteryController" bundle:nil];
		UGGDKL10LotteryController *PCVC = [storyboard instantiateInitialViewController];
		PCVC.gameId = model.gameId;
		PCVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:PCVC animated:YES];
		
	}else if ([@"fc3d" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFC3DLotteryController" bundle:nil];
		UGFC3DLotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:markSixVC animated:YES];
		
	}else if ([@"pk10nn" isEqualToString:model.gameType]) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPK10NNLotteryController" bundle:nil];
		UGPK10NNLotteryController *markSixVC = [storyboard instantiateInitialViewController];
		markSixVC.gameId = model.gameId;
		markSixVC.lotteryGamesArray = self.lotteryGamesArray;
		[self.navigationController pushViewController:markSixVC animated:YES];
		
	}else {
		//        进入第三方游戏
		
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
		}else {
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
		[weakSelf loginClick];
	};
	self.titleView.registerClickBlock = ^{
		[weakSelf registerClick];
	};
	if (UGLoginIsAuthorized()) {
		self.titleView.showLoginView = NO;
		UGUserModel *user = [UGUserModel currentUser];
		self.titleView.userName = user.username;
	}
	//    self.bannerBgViewHeightConstraint.constant = UGScreenW * 0.5;
	//	self.rankingViewHeightConstraints.constant = UGScreenW;
	//	self.scrollContentHeightConstraints.constant = CGRectGetMaxY(self.rankingView.frame);
	//	self.scrollView.contentSize = CGSizeMake(UGScreenW, self.scrollContentHeightConstraints.constant);
	
	if (self.nolineLabel == nil) {
		UILabel *text =[ [UILabel alloc]initWithFrame:CGRectMake(UGScreenW-140,5,140,30 )];
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
	self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:self.bannerBgView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
	self.bannerView.backgroundColor = [UIColor whiteColor];
	self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
	self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	self.bannerView.autoScrollTimeInterval = 2.0;
	self.bannerView.delegate = self;
	[self.bannerBgView addSubview:self.bannerView];
	
	self.leftwardMarqueeView.direction = UUMarqueeViewDirectionUpward;
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

- (NSMutableArray *)upwardMultiMarqueeViewData {
	if (_upwardMultiMarqueeViewData == nil) {
		_upwardMultiMarqueeViewData = [NSMutableArray array];
	}
	return _upwardMultiMarqueeViewData;
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

@end
