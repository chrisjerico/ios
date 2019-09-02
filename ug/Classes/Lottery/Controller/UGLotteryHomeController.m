//
//  UGHallViewController.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryHomeController.h"
#import "STBarButtonItem.h"
#import "UGLotteryCollectionViewCell.h"
#import "CMCommon.h"
#import "UGRightMenuView.h"
#import "UGLotteryAssistantController.h"
#import "CountDown.h"
#import "UGHallLotteryModel.h"
#import "UGChangLongController.h"
#import "UGAllNextIssueListModel.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "UGLotteryGameCollectionViewCell.h"

#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"
@interface UGLotteryHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CountDown *loadCountdown;

@end

static NSString *letteryTicketCellID = @"UGLotteryGameCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
@implementation UGLotteryHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UGBackgroundColor;
    self.navigationItem.title = @"购彩大厅";
//    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    self.countDown = [[CountDown alloc] init];
    [self initCollectionView];
    WeakSelf
   
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAllNextIssueData];
    }];
    self.loadCountdown = [[CountDown alloc] init];
    [self getAllNextIssueData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    WeakSelf
    [self.loadCountdown countDownWithSec:30 PER_SECBlock:^{
        [weakSelf getAllNextIssueData];
    }];
    [self.countDown countDownWithPER_SECBlock:^{
        [weakSelf updateTimeInVisibleCells];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.loadCountdown destoryTimer];
    [self.countDown destoryTimer];
}

- (void)getAllNextIssueData {
    
    [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.collectionView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            
            self.dataArray = model.data;
            [self.collectionView reloadData];
            
        } failure:^(id msg) {
            
        }];
    }];

}

- (void)updateTimeInVisibleCells {
    NSArray  *cells = self.collectionView.visibleCells; //取出屏幕可见ceLl
    for (UGLotteryCollectionViewCell *cell in cells) {
        cell.item = cell.item;
        
    }
}

- (void)rightBarBtnClick {
    float y;
    if ([CMCommon isPhoneX]) {
        y = 44;
    }else {
        y = 20;
    }
    UGRightMenuView *menuView = [[UGRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , y, UGScreenW / 2, UGScerrnH)];
    menuView.titleArray = @[@"返回首页",@"投注记录",@"开奖记录",@"彩种规则",@"长龙助手",@"站内短信",@"退出登录"];
    menuView.imageNameArray = @[@"shouyesel",@"zdgl",@"kaijiangjieguo",@"guize",@"changlong",@"zhanneixin",@"tuichudenglu"];
    WeakSelf
    menuView.menuSelectBlock = ^(NSInteger index) {

        if (index == 0) {
            
        }else if (index == 1) {
            if ([UGUserModel currentUser].isTest) {
                [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        SANotificationEventPost(UGNotificationShowLoginView, nil);
                    }
                }];
            }else {
                
                UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
                [self.navigationController pushViewController:betRecordVC animated:YES];
            }
            
        }else if (index == 2) {
            
            
        }else if (index == 3) {
            UGLotteryRulesView *rulesView = [[UGLotteryRulesView alloc] initWithFrame:CGRectMake(30, 120, UGScreenW - 60, UGScerrnH - 230)];
            [rulesView show];
            
        }else if (index == 4) {
            QDWebViewController *yuebaoVC = [[QDWebViewController alloc] init];
            yuebaoVC.navigationTitle = @"长龙助手";
            yuebaoVC.urlString = [NSString stringWithFormat:@"%@%@",baseServerUrl,changlongUrl];
            [self.navigationController pushViewController:yuebaoVC  animated:YES];
            
        }else if (index == 5) {
           
            
        }else if (index == 6) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
             
            }];
        }else if (index == 7) {
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            [weakSelf.navigationController pushViewController:fundsVC animated:YES];
            
        }else if (index == 8) {
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 1;
            [weakSelf.navigationController pushViewController:fundsVC animated:YES];
            
        }else {
        
           
        }
        
    };
    [menuView show];
}

#pragma mark UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataArray.count;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    UGAllNextIssueListModel *model = self.dataArray[section];
    return model.list.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGLotteryGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:letteryTicketCellID forIndexPath:indexPath];
    UGAllNextIssueListModel *model = self.dataArray[indexPath.section];
    cell.item = model.list[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UGTimeLotteryBetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        UGAllNextIssueListModel *model = self.dataArray[indexPath.section];
        headerView.title = model.gameTypeName;
        headerView.leftTitle = YES;
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UGAllNextIssueListModel *listModel = self.dataArray[indexPath.section];
    UGNextIssueModel *nextModel = listModel.list[indexPath.row];
    if ([@"cqssc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
        UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
        lotteryVC.nextIssueModel = nextModel;
        lotteryVC.gameId = nextModel.gameId;
        lotteryVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:lotteryVC animated:YES];
    }else if ([@"pk10" isEqualToString:nextModel.gameType] ||
              [@"xyft" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
        UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else if ([@"qxc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
        UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
        sevenVC.nextIssueModel = nextModel;
        sevenVC.gameId = nextModel.gameId;
        sevenVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:sevenVC animated:YES];
        
    }else if ([@"lhc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGHKLHCLotteryController" bundle:nil];
        UGHKLHCLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else if ([@"jsk3" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGJSK3LotteryController" bundle:nil];
        UGJSK3LotteryController *fastThreeVC = [storyboard instantiateInitialViewController];
        fastThreeVC.nextIssueModel = nextModel;
        fastThreeVC.gameId = nextModel.gameId;
        fastThreeVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:fastThreeVC animated:YES];
    }else if ([@"pcdd" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPCDDLotteryController" bundle:nil];
        UGPCDDLotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"gd11x5" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGD11X5LotteryController" bundle:nil];
        UGGD11X5LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"bjkl8" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJKL8LotteryController" bundle:nil];
        UGBJKL8LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"gdkl10" isEqualToString:nextModel.gameType] ||
              [@"xync" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGDKL10LotteryController" bundle:nil];
        UGGDKL10LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"fc3d" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFC3DLotteryController" bundle:nil];
        UGFC3DLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else if ([@"pk10nn" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPK10NNLotteryController" bundle:nil];
        UGPK10NNLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else {
        
    }

}

- (void)initCollectionView {
    
    float itemW = (UGScreenW - 15) / 2;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW / 2);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(UGScreenW, 50);
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        float collectionViewH;
        if ([CMCommon isPhoneX]) {
            collectionViewH = UGScerrnH - 88 - 83 - 10;
        }else {
            collectionViewH = UGScerrnH - 64 - 49 - 10;
        }
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 5, UGScreenW - 10, collectionViewH) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.layer.cornerRadius = 10;
        collectionView.layer.masksToBounds = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotteryGameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:letteryTicketCellID];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

    }
    return _dataArray;
    
}


@end
