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
@end
static NSString *letteryTicketCellID = @"UGLotteryGameCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
@implementation UGLotterySelectController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WeakSelf
    
    [self.countDown countDownWithPER_SECBlock:^{
        [weakSelf updateTimeInVisibleCells];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countDown destoryTimer];
}

- (void)updateTimeInVisibleCells {
    NSArray  *cells = self.collectionView.visibleCells; //取出屏幕可见ceLl
    for (UGLotteryGameCollectionViewCell *cell in cells) {
        cell.item = cell.item;
        
    }
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = UIColor.whiteColor;
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
	// Do any additional setup after loading the view.
}
-(void)cancel{
	[self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
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
	[cell setBackgroundColor: [[UGSkinManagers shareInstance] sethomeContentColor]];
	cell.layer.borderColor = [[[UGSkinManagers shareInstance] sethomeContentColor] CGColor];
	
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
	 __block UGNextIssueModel *nextModel = listModel.list[indexPath.row];
	if (self.didSelectedItemBlock) {
		self.didSelectedItemBlock(nextModel);
	}
	[self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end
