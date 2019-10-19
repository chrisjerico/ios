//
//  UGTableViewController.m
//  ug
//
//  Created by ug on 2019/8/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChanglongBetRecordController.h"
#import "UGChanglongBetRecrodCell.h"
#import "UGBetRecordViewController.h"
#import "UGChanglongBetRecordModel.h"
#import "UGBetRecordDetailViewController.h"
#import "UGAllNextIssueListModel.h"
@interface UGChanglongBetRecordController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
static NSString *changlongBetRecordCellId = @"UGChanglongBetRecrodCell";
@implementation UGChanglongBetRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 72;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"UGChanglongBetRecrodCell" bundle:nil] forCellReuseIdentifier:changlongBetRecordCellId];
    
    UIView *footerVC = [[UIView alloc] init];
    footerVC.backgroundColor = [UIColor clearColor];
    footerVC.size = CGSizeMake(UGScreenW, 80);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, UGScreenW - 20, 44)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"查看更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showBetRrecordList) forControlEvents:UIControlEventTouchUpInside];
    [footerVC addSubview:button];
    self.tableView.tableFooterView = footerVC;
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getChanglongBetRecord];
    }];
    SANotificationEventSubscribe(UGNotificationGetChanglongBetRecrod, self, ^(typeof (self) self, id obj) {
        
         [self getChanglongBetRecord];
    });
    [self getChanglongBetRecord];
}

- (void)showBetRrecordList {
    [self.navigationController pushViewController:[UGBetRecordViewController new] animated:YES];
}

- (void)getChanglongBetRecord {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"betId":@"",
                             @"gameId":@"",
							 @"tag":@"1"
                             };
    [CMNetwork getChanglongBetListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            self.dataArray = model.data;
            [self.tableView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UserI.isTest ? 0 : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGChanglongBetRecrodCell *cell = [tableView dequeueReusableCellWithIdentifier:changlongBetRecordCellId forIndexPath:indexPath];

    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBetRecordDetailViewController" bundle:nil];
    UGBetRecordDetailViewController *detailVC = [storyboard instantiateInitialViewController];
    UGChanglongBetRecordModel *model = self.dataArray[indexPath.row];
    for (UGAllNextIssueListModel *listGame in self.lotteryGamesArray) {
        for (UGNextIssueModel *game in listGame.list)
            if ([game.gameId isEqualToString:model.gameId])
                model.pic = game.pic;
    }
    detailVC.item = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
