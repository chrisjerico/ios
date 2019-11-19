//
//  UGHallViewController.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryHomeController.h"

// View
#import "UGLotteryCollectionViewCell.h"
#import "UGLotteryGameCollectionViewCell.h"
#import "UGTimeLotteryBetHeaderView.h"

// Tools
#import "CountDown.h"

@interface UGLotteryHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;

@end

static NSString *letteryTicketCellID = @"UGLotteryGameCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
@implementation UGLotteryHomeController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:Skin1.bgColor];
    self.navigationItem.title = @"彩票大厅";
//    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    self.countDown = [[CountDown alloc] init];
    [self initCollectionView];
    
    WeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAllNextIssueData];
    }];
    [self getAllNextIssueData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    WeakSelf
    __block NSDate *__lastRefresh = [NSDate date];
    [self.countDown countDownWithPER_SECBlock:^{
        // 每秒刷新倒计时Label
        [weakSelf updateTimeInVisibleCells];
        
        // 间隔超过5秒，且存在过期数据时才刷新数据
        if ([__lastRefresh timeIntervalSinceDate:[NSDate date]] < -5) {
            for (UGAllNextIssueListModel *anilm in weakSelf.lotteryGamesArray) {
                for (UGNextIssueModel *nim in anilm.list) {
                    // 判断是否存在过期数据（预留3秒等待下一期开盘）
                    if ([[nim.curOpenTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSinceDate:[NSDate date]] < -3) {
                        [weakSelf getAllNextIssueData];
                        __lastRefresh = [NSDate date];
                        return ;
                    }
                }
            }
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countDown destoryTimer];
}

- (void)getAllNextIssueData {
    [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.collectionView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            self.lotteryGamesArray = UGAllNextIssueListModel.lotteryGamesArray = model.data;
            [self.collectionView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
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
    return self.lotteryGamesArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    UGAllNextIssueListModel *model = self.lotteryGamesArray[section];
    return model.list.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGLotteryGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:letteryTicketCellID forIndexPath:indexPath];
    UGAllNextIssueListModel *model = self.lotteryGamesArray[indexPath.section];
    cell.item = model.list[indexPath.row];
    [cell setBackgroundColor: Skin1.homeContentColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UGTimeLotteryBetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        UGAllNextIssueListModel *model = self.lotteryGamesArray[indexPath.section];
        headerView.title = model.gameTypeName;
        headerView.leftTitle = YES;
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UGAllNextIssueListModel *listModel = self.lotteryGamesArray[indexPath.section];
    UGNextIssueModel *nextModel = listModel.list[indexPath.row];
    [NavController1 pushViewControllerWithNextIssueModel:nextModel];
}

- (void)initCollectionView {
    
    float itemW = (APP.Width - 16) / 2;
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW / 2);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(UGScreenW, 50);
        layout;
    });
    
    UICollectionView *collectionView = ({
        float collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar- 10;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, UGScreenW, collectionViewH) collectionViewLayout:layout];
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
         make.left.equalTo(self.view.mas_left);
         make.right.equalTo(self.view.mas_right);
         make.bottom.equalTo(self.view.mas_bottom).offset(-IPHONE_SAFEBOTTOMAREA_HEIGHT);
    }];
}

@end
