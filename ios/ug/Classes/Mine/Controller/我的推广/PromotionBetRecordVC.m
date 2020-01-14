//
//  PromotionBetRecordVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionBetRecordVC.h"
#import "PromotionOtherBetRecordVC.h"

#import "PromotionRecordCell1.h"
#import "PromotionRecordCell2.h"

#import "UGBetListModel.h"
#import "UGrealBetListModel.h"
#import "YBPopupMenu.h"
@interface PromotionBetRecordVC ()<UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>
{
	NSInteger _levelindex;
	NSArray * _levelArray;
}

@property (weak, nonatomic) IBOutlet UIStackView *headerStack;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headerLabels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)NSInteger pageNumber;
@property (nonatomic, strong)NSMutableArray* items;

@property (weak, nonatomic) IBOutlet UIView *levelSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIButton *levelSelectButton;
@end

@implementation PromotionBetRecordVC


- (void)rightButtonTaped {
	PromotionOtherBetRecordVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionOtherBetRecordVC"];
	[self.navigationController pushViewController:vc animated:true];
	
}
- (void)viewDidLoad {
	[super viewDidLoad];
	[self.tableView registerNib: [UINib nibWithNibName:@"PromotionRecordCell1" bundle:nil] forCellReuseIdentifier:@"PromotionRecordCell1"];
	[self.tableView registerNib: [UINib nibWithNibName:@"PromotionRecordCell2" bundle:nil] forCellReuseIdentifier:@"PromotionRecordCell2"];
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.pageSize = 20;
	self.pageNumber = 1;
	self.items = [NSMutableArray array];
	_levelArray = @[@"全部下线",@"1级下线",@"2级下线",@"3级下线",@"4级下线",@"5级下线",@"6级下线",@"7级下线",@"8级下线",@"9级下线",@"10级下线"];
	_levelindex = 0;
	WeakSelf;
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.pageNumber = 1;
		[weakSelf loadData];
	}];
	self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pageNumber =weakSelf.pageNumber+1;
		[weakSelf loadData];
		
	}];
	self.tableView.tableFooterView = [UIView new];
	[weakSelf loadData];
	self.navigationItem.title = @"彩票投注记录";
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightButton setTitle:@"其它" forState:UIControlStateNormal];
	rightButton.titleLabel.textColor = UIColor.whiteColor;
	[rightButton addTarget:self action:@selector(rightButtonTaped) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	
	
}

- (IBAction)levelButtonTaped:(id)sender {
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
	self.arrowImage.transform = transform;
	
	YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:_levelArray icons:nil menuWidth:CGSizeMake(UGScreenW / _levelArray.count + 70, 180) delegate:self];
	popView.type = YBPopupMenuTypeDefault;
	popView.fontSize = 12;
	popView.textColor = [UIColor colorWithHex:0x484D52];
	[popView showRelyOnView:self.levelSelectView];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	
	if (self.typeIndex == 0) {
		PromotionRecordCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionRecordCell1" forIndexPath:indexPath];
		[cell bindBetRecord:self.items[indexPath.row]];
		return cell;
		
	} else {
		PromotionRecordCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionRecordCell2" forIndexPath:indexPath];
		[cell bindOtherRecord:self.items[indexPath.row]];
		return cell;
	}
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.items.count;
}
- (void)loadData {
	if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
		return;
	}
	if ([UGUserModel currentUser].isTest) {
		return;
	}
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
							 @"page":@(self.pageNumber),
							 @"rows":@(self.pageSize),
	};
	
	[SVProgressHUD showWithStatus:nil];
	WeakSelf;
	[CMNetwork teamBetListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			[SVProgressHUD dismiss];
			NSDictionary *data =  model.data;
			NSArray *list = [data objectForKey:@"list"];
			if (weakSelf.pageNumber == 1 ) {
				[weakSelf.items removeAllObjects];
			}
			NSArray *array  = [UGBetListModel arrayOfModelsFromDictionaries:list error:nil];
			[weakSelf.items addObjectsFromArray:array];
			[weakSelf.tableView reloadData];
			if (array.count < self.pageSize) {
				[weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
				[weakSelf.tableView.mj_footer setHidden:YES];
			}else{
				
				[weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
				[weakSelf.tableView.mj_footer setHidden:NO];
			}
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
		if ([weakSelf.tableView.mj_header isRefreshing]) {
			[weakSelf.tableView.mj_header endRefreshing];
		}
		if ([weakSelf.tableView.mj_footer isRefreshing]) {
			[weakSelf.tableView.mj_footer endRefreshing];
		}
	}];
}



#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
	if (index >= 0) {
		_levelindex = index;
		[self.levelSelectButton setTitle:_levelArray[index] forState:UIControlStateNormal];
		[self loadData];
	}
	
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
	self.arrowImage.transform = transform;
}

@end
