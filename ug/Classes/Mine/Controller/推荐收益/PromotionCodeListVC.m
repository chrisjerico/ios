//
//  PromotionCodeGenerateVC.m
//  UGBWApp
//
//  Created by xionghx on 2020/11/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionCodeListVC.h"
#import "PromotionCodeCell.h"
#import "InviteCodeListModel.h"
#import "InviteCodeGenerateVC.h"
#import "InviteCodeConfigModel.h"
@interface PromotionCodeListVC ()<UITableViewDelegate, UITableViewDataSource, InviteCodeGenerateDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeTypeLabel;
@property (nonatomic, strong)NSArray * dataSrouce;
@property (nonatomic, strong)NSNumber * page;
@property (nonatomic, strong)NSNumber * rows;
@property (nonatomic, copy)void(^refreshBlock)(void);
@end

@implementation PromotionCodeListVC

- (void)viewDidLoad {
[super viewDidLoad];
	InviteCodeConfigModel *inviteCodeModel = UGSystemConfigModel.currentConfig.inviteCode;
	self.navigationItem.title = inviteCodeModel.displayWord;
	[self.tipsLabel setHidden: [inviteCodeModel.canUseNum isEqualToString: @"0"]];
	self.tipsLabel.text = [NSString stringWithFormat:@"每个%@可以使用%@次", inviteCodeModel.displayWord,inviteCodeModel.canUseNum];
	self.codeTypeLabel.text = inviteCodeModel.displayWord;
	self.dataSrouce = [NSArray array];
	self.page = @1;
	self.rows = @10;
	UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"生成%@", UGSystemConfigModel.currentConfig.inviteCode.displayWord] style:UIBarButtonItemStyleDone target:self action:@selector(generateAction)];
	self.navigationItem.rightBarButtonItem = rightItem;
	[rightItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: UIColor.whiteColor} forState:UIControlStateNormal];
	[rightItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: UIColor.whiteColor} forState:UIControlStateHighlighted];
	
	[self.tabelView registerNib:[UINib nibWithNibName:@"PromotionCodeCell" bundle:nil] forCellReuseIdentifier:@"PromotionCodeCell"];
	self.tabelView.delegate = self;
	self.tabelView.dataSource = self;
	self.tabelView.tableFooterView = [[UIView alloc] init];
	
	
	WeakSelf
	void(^refreshBlock)(void) = ^{
		[CMNetwork inviteCodeListWithParams:@{@"page": weakSelf.page, @"rows": weakSelf.rows , @"token": UGUserModel.currentUser.sessid } completion:^(CMResult<id> *model, NSError *err) {
			[SVProgressHUD dismiss];
			[weakSelf.tabelView.mj_header endRefreshing];
			[CMResult processWithResult:model success:^{
				weakSelf.dataSrouce = ((InviteCodeListModel*)model.data).list;
				[weakSelf.tabelView reloadData];
				weakSelf.page = @1;
			} failure:^(id msg) {
				[SVProgressHUD showErrorWithStatus:msg];
			}];
		}];
	};
	self.refreshBlock = refreshBlock;
	void(^loadMoreBlock)(void) = ^{
		NSNumber * newPage = [NSNumber numberWithLong: (weakSelf.page.integerValue + 1)];
		[CMNetwork inviteCodeListWithParams:@{@"page": newPage, @"rows": weakSelf.rows , @"token": UGUserModel.currentUser.sessid } completion:^(CMResult<id> *model, NSError *err) {
			[weakSelf.tabelView.mj_footer endRefreshing];
			[CMResult processWithResult:model success:^{
				InviteCodeListModel * listModel = model.data;
				if (listModel.list.count > 0) {
					weakSelf.dataSrouce = [weakSelf.dataSrouce arrayByAddingObjectsFromArray:listModel.list];
					[weakSelf.tabelView reloadData];
					weakSelf.page  = newPage;
				} else {
					[weakSelf.tabelView.mj_footer endRefreshingWithNoMoreData];
				}
			} failure:^(id msg) {
				[SVProgressHUD showErrorWithStatus:msg];
			}];
		}];
	};
	[SVProgressHUD showWithStatus:nil];
	refreshBlock();
	MJRefreshNormalHeader * refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		refreshBlock();
	}];
	MJRefreshAutoNormalFooter * refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
		loadMoreBlock();
	}];
	[self.tabelView setMj_header:refreshHeader];
	[self.tabelView setMj_footer:refreshFooter];
}


- (void)generateAction {
	InviteCodeGenerateVC * vc = [[InviteCodeGenerateVC alloc] init];
	vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
	vc.delegate = self;
	[self presentViewController:vc animated:true completion:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	PromotionCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionCodeCell" forIndexPath:indexPath];
	[cell bind:self.dataSrouce[indexPath.row]];
	return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSrouce.count;
}
- (void)generated {
	
	[SVProgressHUD showWithStatus:nil];
	self.refreshBlock();
}
@end
