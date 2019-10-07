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

-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    [self getAllNextIssueData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.navigationItem.title = @"彩票大厅";
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
	void(^judeBlock)(UGCommonLotteryController * lotteryVC) = ^(UGCommonLotteryController * lotteryVC) {
		if ([@[@"7", @"11", @"9"] containsObject: nextModel.gameId]) {
				lotteryVC.shoulHideHeader = true;
			}
	};
	
	
	
    if ([@"cqssc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
        UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
        lotteryVC.nextIssueModel = nextModel;
        lotteryVC.gameId = nextModel.gameId;
        lotteryVC.lotteryGamesArray = self.dataArray;
        //此处为重点
        lotteryVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
		judeBlock(lotteryVC);
        [self.navigationController pushViewController:lotteryVC animated:YES];
    } else if ([@"pk10" isEqualToString:nextModel.gameType] ||
              [@"xyft" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
        UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        //此处为重点
        markSixVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
		judeBlock(markSixVC);

        [self.navigationController pushViewController:markSixVC animated:YES];
        
    } else if ([@"qxc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
        UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
        sevenVC.nextIssueModel = nextModel;
        sevenVC.gameId = nextModel.gameId;
        sevenVC.lotteryGamesArray = self.dataArray;
        sevenVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:sevenVC animated:YES];
        
    } else if ([@"lhc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGHKLHCLotteryController" bundle:nil];
        UGHKLHCLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        markSixVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
		judeBlock(markSixVC);

        [self.navigationController pushViewController:markSixVC animated:YES];
        
    } else if ([@"jsk3" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGJSK3LotteryController" bundle:nil];
        UGJSK3LotteryController *fastThreeVC = [storyboard instantiateInitialViewController];
        fastThreeVC.nextIssueModel = nextModel;
        fastThreeVC.gameId = nextModel.gameId;
        fastThreeVC.lotteryGamesArray = self.dataArray;
        fastThreeVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:fastThreeVC animated:YES];
    } else if ([@"pcdd" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPCDDLotteryController" bundle:nil];
        UGPCDDLotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        PCVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:PCVC animated:YES];
        
    } else if ([@"gd11x5" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGD11X5LotteryController" bundle:nil];
        UGGD11X5LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        PCVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:PCVC animated:YES];
        
    } else if ([@"bjkl8" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJKL8LotteryController" bundle:nil];
        UGBJKL8LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        PCVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:PCVC animated:YES];
        
    } else if ([@"gdkl10" isEqualToString:nextModel.gameType] ||
              [@"xync" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGDKL10LotteryController" bundle:nil];
        UGGDKL10LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.dataArray;
        PCVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:PCVC animated:YES];
        
    } else if ([@"fc3d" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFC3DLotteryController" bundle:nil];
        UGFC3DLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        markSixVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    } else if ([@"pk10nn" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPK10NNLotteryController" bundle:nil];
        UGPK10NNLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.dataArray;
        markSixVC.gotoTabBlock = ^{
            self.navigationController.tabBarController.selectedIndex = 0;
        };
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    } else {
        
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
            collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar- 10;
  
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
    
    
    [self.collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view.mas_top).with.offset(10);
         make.left.equalTo(self.view.mas_left).with.offset(5);
         make.right.equalTo(self.view.mas_right).with.offset(-5);
         make.bottom.equalTo(self.view.mas_bottom).offset(-IPHONE_SAFEBOTTOMAREA_HEIGHT);
    }];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

    }
    return _dataArray;
    
}


@end
