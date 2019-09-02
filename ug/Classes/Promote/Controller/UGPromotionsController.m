//
//  UGPromotionsController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionsController.h"
#import "UGPromotionsTableViewCell.h"
#import "SLWebViewController.h"
#import "UGPromoteModel.h"
#import "UGPromoteDetailController.h"
#import "QDWebViewController.h"

@interface UGPromotionsController ()
@property (nonatomic, strong) NSArray *dataArray;


@end

static NSString *promotionsCellid = @"UGPromotionsTableViewCell";
@implementation UGPromotionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"优惠活动";
    self.view.backgroundColor = UGBackgroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGPromotionsTableViewCell" bundle:nil] forCellReuseIdentifier:promotionsCellid];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPromoteList];
    }];
    [self getPromoteList];
}

- (void)getPromoteList {
    
    [CMNetwork getPromoteListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            UGPromoteListModel *listModel = model.data;
            self.dataArray = listModel.list;
            [self.tableView reloadData];
        } failure:^(id msg) {
            
            
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromotionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:promotionsCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.width / 5 * 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UGPromoteModel *model = self.dataArray[indexPath.row];
    UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
    detailVC.item = model;
    [self.navigationController pushViewController:detailVC animated:YES];

}

@end
