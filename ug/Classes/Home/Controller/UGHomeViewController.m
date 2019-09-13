
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
@interface UGHomeViewController ()<SDCycleScrollViewDelegate,UUMarqueeViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *bannerBgView;
@property (weak, nonatomic) IBOutlet UIView *gameTypeView;
@property (weak, nonatomic) IBOutlet UIView *rankingView;

@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView;
@property (weak, nonatomic) IBOutlet UUMarqueeView *upwardMultiMarqueeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerBgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankingViewHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameTypeViewHeightConstraint;

@property (nonatomic, strong) UGHomeTitleView *titleView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UGGameTypeCollectionView *gameTypeCollectionView;

@property (nonatomic, strong) NSMutableArray *leftwardMarqueeViewData;
@property (nonatomic, strong) NSMutableArray *upwardMultiMarqueeViewData;
@property (nonatomic, strong) NSMutableArray *popNoticeArray;

@property (nonatomic, strong) NSMutableArray *gameTypeArray;
@property (nonatomic, strong) UGNoticeTypeModel *noticeTypeModel;
@property (nonatomic, strong) UGRankListModel *rankListModel;

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *noticeArray;
@property (nonatomic, strong) NSArray *rankArray;
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, assign) BOOL initSubview;
@end

@implementation UGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
        [self getUserInfo];
        self.titleView.showLoginView = NO;
      
    });
    SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
        [self userLogout];
    });
    SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
        [QDAlertView showWithTitle:@"提示" message:@"您的账号已经登录超时，请重新登录。" cancelButtonTitle:nil otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            self.titleView.showLoginView = YES;
            UGUserModel.currentUser = nil;
            [self.tabBarController setSelectedIndex:0];
            [self loginClick];
            
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
    [self getPlatformGamesList];
//    [self getBannerList];
    [self getNoticeList];
    [self getRankList];
    [self getAllNextIssueData];
    [self getUserInfo];
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getSystemConfig];
        [self getPlatformGamesList];
//        [self getBannerList];
        [self getNoticeList];
        [self getRankList];
        [self getUserInfo];
        [self getAllNextIssueData];
    }];
    
    UGGameTypeCollectionView *gameView = [[UGGameTypeCollectionView alloc] initWithFrame:self.gameTypeView.bounds];
    [self.gameTypeView addSubview:gameView];
    self.gameTypeCollectionView = gameView;
      WeakSelf
//    self.gameTypeCollectionView.platformSelectBlock = ^(NSInteger selectIndex) {
//
//        float itemH = UGScreenW / 3;
//        UGPlatformModel *model = weakSelf.gameTypeArray[selectIndex];
//        float collectionViewH = ((model.games.count - 1) / 3 + 1) * itemH;
//        weakSelf.gameTypeViewHeightConstraint.constant = collectionViewH + 80;
//                weakSelf.scrollContentHeightConstraints.constant = CGRectGetMaxY(weakSelf.rankingView.frame);
//                weakSelf.scrollView.contentSize = CGSizeMake(UGScreenW, weakSelf.scrollContentHeightConstraints.constant);
//        [weakSelf.view layoutIfNeeded];
//    };
    self.gameTypeCollectionView.gameItemSelectBlock = ^(UGPlatformGameModel * _Nonnull game) {
        [weakSelf showGameVC: game];
    };
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

}

-(BOOL)prefersStatusBarHidden{
    
    return NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leftwardMarqueeView start];
    [self.upwardMultiMarqueeView start];

}

- (void)viewWillDisappear:(BOOL)animated {
    self.initSubview = YES;
}

- (void)viewWillLayoutSubviews {
  
    if (!self.initSubview) {
        
        [self setupSubView];
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

- (void)getPlatformGamesList {
    
    [SVProgressHUD showWithStatus: nil];
    [CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
         [self.scrollView.mj_header endRefreshing];
        //     fixbug:这个接口后再请求轮播图，否则看不到轮播图
         [self getBannerList];
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            if (model.data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.gameTypeArray = model.data;
                    float itemH = UGScreenW / 3;
                    NSInteger count = 0;
                    for (UGPlatformModel *gameType in self.gameTypeArray) {
                        count = gameType.games.count > count ? gameType.games.count : count;
                    }
                    float collectionViewH = ((count - 1) / 3 + 1) *itemH;
                    self.gameTypeViewHeightConstraint.constant = collectionViewH + 80;
                    self.scrollContentHeightConstraints.constant = CGRectGetMaxY(self.rankingView.frame);
                    self.scrollView.contentSize = CGSizeMake(UGScreenW, self.scrollContentHeightConstraints.constant + 200);
                    [self.view layoutIfNeeded];
                    
                    self.gameTypeCollectionView.gameTypeArray = self.gameTypeArray;
                });
                
            }
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
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
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            
        } failure:^(id msg) {
            
        }];
    }];
}

- (void)userLogout {
    
    NSDictionary *dict = @{@"token":[UGUserModel currentUser].sessid};
    [SVProgressHUD showWithStatus:@"退出登录..."];
    [CMNetwork userLogoutWithParams:dict completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
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
            self.bannerArray = model.data;
            NSMutableArray *mutArr = [NSMutableArray array];
            if (self.bannerArray.count) {
                for (UGBannerModel *banner in self.bannerArray) {
                    [mutArr addObject:banner.pic];
                }
                self.bannerView.imageURLStringsGroup = mutArr.mutableCopy;
            }
        } failure:^(id msg) {
            
        }];
    }];
    
}

- (void)getNoticeList {
    
    [CMNetwork getNoticeListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
         [self.scrollView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            UGNoticeTypeModel *type = model.data;
            self.noticeTypeModel = model.data;
            self.popNoticeArray = type.popup.mutableCopy;
            for (UGNoticeModel *notice in type.scroll) {
//                NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[notice.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                [self.leftwardMarqueeViewData addObject:notice.title];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
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
            UGRankListModel *rank = model.data;
            self.rankListModel = rank;
            self.rankArray = rank.list.mutableCopy;
            if (rank.show) {
                self.rankingView.hidden = NO;
                [self.upwardMultiMarqueeView reloadData];
            }else {
                self.rankingView.hidden = YES;
            }
        } failure:^(id msg) {
            
        }];
    }];
}

- (void)showPlatformNoticeView {
    UGPlatformNoticeView *notiveView = [[UGPlatformNoticeView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
    notiveView.dataArray = self.popNoticeArray;
    [notiveView show];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    UGBannerModel *banner = self.bannerArray[index];
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
    float y;
    if ([CMCommon isPhoneX]) {
        y = 44;
    }else {
        y = 20;
    }
    UGRightMenuView *menuView = [[UGRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , y, UGScreenW / 2, UGScerrnH)];
    menuView.titleArray = @[@"投注记录",@"开奖记录",@"长龙助手",@"站内短信",@"退出登录"];
    menuView.imageNameArray = @[@"shouyesel",@"zdgl",@"kaijiangjieguo",@"guize",@"changlong",@"zhanneixin",@"tuichudenglu"];
    WeakSelf
    menuView.menuSelectBlock = ^(NSInteger index) {
        
        if (index == 0) {
            if ([UGUserModel currentUser].isTest) {
                [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        SANotificationEventPost(UGNotificationShowLoginView, nil);
                    }
                }];
            }else {
                
                UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
                [weakSelf.navigationController pushViewController:betRecordVC animated:YES];
            }
            
        }else if (index == 1) {
            UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"UGLotteryRecordController" bundle:nil];
            UGLotteryRecordController *recordVC = [storyboad instantiateInitialViewController];
            UGAllNextIssueListModel *model = self.lotteryGamesArray.firstObject;
            UGNextIssueModel *game = model.list.firstObject;
            recordVC.gameId = game.gameId;
            recordVC.lotteryGamesArray = self.lotteryGamesArray;
            [self.navigationController pushViewController:recordVC animated:YES];
            
        }else if (index == 2) {
    
            UGChangLongController *changlongVC = [[UGChangLongController alloc] init];
            changlongVC.lotteryGamesArray = self.lotteryGamesArray;
            [self.navigationController pushViewController:changlongVC animated:YES];
            
        }else if (index == 3) {
            UGMailBoxTableViewController *mailBoxVC = [[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:mailBoxVC animated:YES];
            
        }else if (index == 4) {
          
            [QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [weakSelf userLogout];
                    });
                }
            }];
        }else if (index == 7) {
            if ([UGUserModel currentUser].isTest) {
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
        }else if (index == 8) {
            if ([UGUserModel currentUser].isTest) {
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
        }else {
            
            
        }
    };
    [menuView show];
    
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

- (void)showGameVC:(UGPlatformGameModel *)model {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }

    if ([@"cqssc" isEqualToString:model.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
        UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
        lotteryVC.gameId = model.gameId;
        lotteryVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:lotteryVC animated:YES];
    }else if ([@"pk10" isEqualToString:model.gameType] ||
              [@"xyft" isEqualToString:model.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
        UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.gameId = model.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else if ([@"qxc" isEqualToString:model.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
        UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
        sevenVC.gameId = model.gameId;
        sevenVC.lotteryGamesArray = self.lotteryGamesArray;
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
        if (model.isPopup) {
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
    self.bannerBgViewHeightConstraint.constant = UGScreenW * 0.5;
    self.rankingViewHeightConstraints.constant = UGScreenW;
    self.scrollContentHeightConstraints.constant = CGRectGetMaxY(self.rankingView.frame);
    self.scrollView.contentSize = CGSizeMake(UGScreenW, self.scrollContentHeightConstraints.constant);
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = YES;
    self.scrollView.backgroundColor = UGBackgroundColor;
    self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:self.bannerBgView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView.backgroundColor = [UIColor whiteColor];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bannerView.autoScrollTimeInterval = 2.0;
    self.bannerView.delegate = self;
    [self.bannerBgView addSubview:self.bannerView];
    
    self.leftwardMarqueeView.direction = UUMarqueeViewDirectionLeftward;
    self.leftwardMarqueeView.delegate = self;
    self.leftwardMarqueeView.timeIntervalPerScroll = 0.0f;
    self.leftwardMarqueeView.scrollSpeed = 60.0f;
    self.leftwardMarqueeView.itemSpacing = 20.0f;
    self.leftwardMarqueeView.touchEnabled = YES;
    self.leftwardMarqueeView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNoticeInfo)];
    [self.leftwardMarqueeView addGestureRecognizer:tap];
    
    self.upwardMultiMarqueeView.direction = UUMarqueeViewDirectionUpward;
    self.upwardMultiMarqueeView.timeIntervalPerScroll = 0.0f;
    self.upwardMultiMarqueeView.scrollSpeed = 50.f;
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

- (NSMutableArray *)gameTypeArray {
    if (_gameTypeArray == nil) {
        _gameTypeArray = [NSMutableArray array];
    }
    return _gameTypeArray;
}

@end
