//
//  UGLotterySelectController.m
//  ug
//
//  Created by xionghx on 2019/10/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotterySelectController.h"
#import "UGLotteryGameCollectionViewCell.h"
#import "UGAllNextIssueListModel.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "CountDown.h"



@interface UGLotterySelectController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CountDown *countDown;

@property (nonatomic, readonly) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;/**<   彩票大厅数据 */
@end


static NSString *letteryTicketCellID = @"UGLotteryGameCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";


@implementation UGLotterySelectController

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
            self->_lotteryGamesArray = UGAllNextIssueListModel.lotteryGamesArray = model.data;
            [self.collectionView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)updateTimeInVisibleCells {
    NSArray  *cells = self.collectionView.visibleCells; //取出屏幕可见ceLl
    for (UGLotteryGameCollectionViewCell *cell in cells) {
        cell.item = cell.item;
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    _lotteryGamesArray = UGAllNextIssueListModel.lotteryGamesArray;
    
	self.view.backgroundColor = Skin1.textColor4;
    self.navigationController.navigationBar.backgroundColor = Skin1.navBarBgColor;
    self.countDown = [[CountDown alloc] init];
	self.navigationItem.title = @"点击图标切换彩票";
	UIButton * rightItem = [UIButton buttonWithType:UIButtonTypeSystem];
	[rightItem setTitle:@"取消" forState:UIControlStateNormal];
	[rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[rightItem addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
	[self.view addSubview:self.collectionView];
	[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
    
    [self getAllNextIssueData];
}

- (void)cancel {
	[self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		float itemW = (UGScreenW - 20) / 2;
		UICollectionViewFlowLayout *layout = ({
			layout = [[UICollectionViewFlowLayout alloc] init];
			layout.itemSize = CGSizeMake(itemW, itemW / 2);
			layout.minimumInteritemSpacing = 5;
			layout.minimumLineSpacing = 5;
			layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
			layout.headerReferenceSize = CGSizeMake(UGScreenW, 50);
			layout;
		});
		
		UICollectionView *collectionView = ({
			collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
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
		_collectionView = collectionView;
	}
	return _collectionView;
}

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
	 __block UGNextIssueModel *nextModel = listModel.list[indexPath.row];
	if (self.didSelectedItemBlock) {
		self.didSelectedItemBlock(nextModel);
	}
	[self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end
