//
//  UGHallViewController.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "GameHomeVC.h"
#import "STBarButtonItem.h"
#import "UGLotteryCollectionViewCell.h"
#import "CMCommon.h"
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


#import "UGYYLotteryHomeViewController.h"
#import "UGhomeRecommendCollectionViewCell.h"
#import "UGYYPlatformGames.h"
#import "UGYYLotterySecondHomeViewController.h"
#import "UGLotteryHomeController.h"

@interface UGGameHomeCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView * backDropImageView;
@property(nonatomic, strong)UILabel * itemLabel;
@property(nonatomic, strong)UILabel * subItemLabel;


@end


@implementation UGGameHomeCell

-(UIImageView *)backDropImageView {
	if (!_backDropImageView) {
		_backDropImageView = [UIImageView new];
	}
	return _backDropImageView;
}

-(UILabel *)itemLabel {
	if (!_itemLabel) {
		_itemLabel = [UILabel new];
		_itemLabel.font = [UIFont boldSystemFontOfSize:20];
		_itemLabel.textColor = UIColor.whiteColor;
	}
	return _itemLabel;
}
- (UILabel *)subItemLabel {
	if (!_subItemLabel) {
		_subItemLabel = [UILabel new];
		_subItemLabel.text = @"进入游戏";
		_subItemLabel.font = [UIFont systemFontOfSize:12];
		_subItemLabel.textColor = UIColor.whiteColor;
		_subItemLabel.textAlignment = NSTextAlignmentCenter;
		_subItemLabel.layer.cornerRadius = 4;
		_subItemLabel.layer.masksToBounds = true;
		_subItemLabel.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
		
	}
	return _subItemLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self addSubview:self.backDropImageView];
		[self.backDropImageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		[self addSubview:self.itemLabel];
		[self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.backDropImageView).offset(24);
			make.top.equalTo(self.backDropImageView).offset(16);

		}];
		[self addSubview:self.subItemLabel];
			[self.subItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(self.backDropImageView).offset(24);
				make.top.equalTo(self.backDropImageView).offset(48);
				make.size.mas_equalTo(CGSizeMake(72, 24));

			}];
	}
	return self;
}

-(void)binde: (UGYYPlatformGames *) model {
	if ([model.category isEqualToString:@"lottery"]) {
		[self.backDropImageView setImage:[UIImage imageNamed:@"caipiaoyouxi"]];
		self.itemLabel.text = @"彩票游戏";
	}
	else  if([model.category isEqualToString:@"game"]) {
		[self.backDropImageView setImage:[UIImage imageNamed:@"dianziyouxi"]];
		self.itemLabel.text = @"电子游戏";
		
	}
	else  if([model.category isEqualToString:@"fish"]) {
		[self.backDropImageView setImage:[UIImage imageNamed:@"buyuyouxi"]];
		self.itemLabel.text = @"捕鱼游戏";
		
	}
	else  if([model.category isEqualToString:@"card"]) {
		[self.backDropImageView setImage:[UIImage imageNamed:@"qipaiyouxi"]];
		self.itemLabel.text = @"棋牌游戏";
		
	}
	else  if([model.category isEqualToString:@"sport"]) {
		[self.backDropImageView setImage:[UIImage imageNamed:@"tiyusaishi"]];
		self.itemLabel.text = @"体育赛事";
		
	}
	else  if([model.category isEqualToString:@"real"]) {
		[self.backDropImageView setImage:[UIImage imageNamed:@"zhenrenshixun"]];
		self.itemLabel.text = @"真人视讯";
		
	}
}
@end

@interface GameHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation GameHomeVC

- (BOOL)允许游客访问 { return true; }

- (void)skin {
	//    [self.view setBackgroundColor: Skin1.bgColor];
	//    [self getPlatformGamesWithParams];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

}
- (void)viewDidLoad {
	[super viewDidLoad];
	_dataArray = [NSMutableArray array];
	self.navigationItem.title = @"UG游戏大厅";
	self.view.backgroundColor = UIColor.whiteColor;
	//    [self.view setBackgroundColor: Skin1.bgColor];
	//    self.title = @"购彩大厅";
	
	//    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
	//        [self skin];
	//    });
	
	[self initCollectionView];
	
	WeakSelf
	self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[weakSelf getPlatformGamesWithParams];
	}];
	[self getPlatformGamesWithParams];
}

- (void)initCollectionView {
	
	float itemW = UGScreenW - 48;
	UICollectionViewFlowLayout *layout = ({
		layout = [[UICollectionViewFlowLayout alloc] init];
		layout.estimatedItemSize = CGSizeZero;
		layout.itemSize = CGSizeMake(itemW, itemW*88/327.0);
		layout.minimumInteritemSpacing = 0;
		layout.minimumLineSpacing = 12;
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		layout.headerReferenceSize = CGSizeMake(UGScreenW, 20);
		layout.footerReferenceSize = CGSizeMake(UGScreenW, 20);
		
		
		layout;
	});
	
	UICollectionView *collectionView = ({
		collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
		collectionView.backgroundColor = [UIColor clearColor];
		collectionView.layer.cornerRadius = 10;
		collectionView.layer.masksToBounds = YES;
		collectionView.dataSource = self;
		collectionView.delegate = self;
		[collectionView registerClass: [UGGameHomeCell class] forCellWithReuseIdentifier:@"UGGameHomeCell"];
		//        [collectionView registerNib:[UINib nibWithNibName:@"UGhomeRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell"];
		[collectionView setShowsHorizontalScrollIndicator:NO];
		collectionView;
	});
	
	self.collectionView = collectionView;
	[self.view addSubview:collectionView];
	[collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}


#pragma mark UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	//    UGhomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell" forIndexPath:indexPath];
	UGGameHomeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGGameHomeCell" forIndexPath:indexPath];
	UGYYPlatformGames *model = self.dataArray[indexPath.row];
	[cell binde:model];
	//    cell.item = model;
	//    [cell setBackgroundColor: Skin1.homeContentColor];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	
	UGYYPlatformGames *listModel = self.dataArray[indexPath.row];
	
	if ([@"lottery" isEqualToString:listModel.category]) {//彩票
		UGLotteryHomeController*vc = [[UGLotteryHomeController alloc] init];
		[self.navigationController pushViewController:vc animated:YES];
	}
	else if ([@"game" isEqualToString:listModel.category] ) {//电子
		UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
		vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
		vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
		[self.navigationController pushViewController:vc animated:YES];
		
	}
	else if ([@"fish" isEqualToString:listModel.category]) {//捕鱼
		UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
		vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
		vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
		[self.navigationController pushViewController:vc animated:YES];
	}
	else if ([@"card" isEqualToString:listModel.category]) {//棋牌
		
		UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
		vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
		vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
		[self.navigationController pushViewController:vc animated:YES];
	}
	else if ([@"sport" isEqualToString:listModel.category]) {//体育
		UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
		vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
		vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
		[self.navigationController pushViewController:vc animated:YES];
	}
	else if ([@"real" isEqualToString:listModel.category]) {//真人
		
		UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
		vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
		vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
		[self.navigationController pushViewController:vc animated:YES];
	}
	else if ([@"esport" isEqualToString:listModel.category]) {//电竞
		
		UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
		vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
		vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
		[self.navigationController pushViewController:vc animated:YES];
	}
	
	NSLog(@"listModel.category = %@",listModel.category);
}

- (void)getPlatformGamesWithParams {
    WeakSelf;
	[CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
		[self.collectionView.mj_header endRefreshing];
		[CMResult processWithResult:model success:^{
			weakSelf.dataArray = model.data;
			[weakSelf.collectionView reloadData];
		} failure:^(id msg) {
		}];
	}];
}

@end
